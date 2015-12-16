//
//  QuestionnaireViewController.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "AnswerSheetViewController.h"

#import "QuestionnaireTitleView.h"
#import "QuestionnaireCV.h"

#import "QuestionnaireModel.h"
#import "AnswersheetModel.h"

static NSInteger QuestionnaireNotDoneAlertTag = 999;
static NSInteger QuestionnaireDoneAlertTag = 1000;
static void *QuestionnaireViewControllerAnswerArrayObservationContext = &QuestionnaireViewControllerAnswerArrayObservationContext;

@interface QuestionnaireViewController ()<QuestionnaireCVDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) QuestionnaireTitleView *titleView;
@property (nonatomic, strong) UIButton               *prevButton;
@property (nonatomic, strong) UIButton               *nextButton;
@property (nonatomic, strong) QuestionnaireCV        *questionCV;
@property (nonatomic, strong) UIButton               *submitButton;

@property (nonatomic, strong) QuestionnaireModel     *questionnaire;
@property (nonatomic, strong) NSMutableArray         *answersheet;
@property (nonatomic, assign) NSInteger              currentItemIndex;

@property (nonatomic, assign) BOOL                   didSetupConstraints;

@end

@implementation QuestionnaireViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentItemIndex = 0;
        self.answersheet = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAnswerArray:) name:QuestionnaireAnswersChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToQuestionAtIndex:) name:QuestionnaireScrollNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateAnswerArray:(NSNotification *)notif
{
    NSDictionary *dict = notif.userInfo;
    NSArray *answers = dict[@"answers"];
    
    [self.answersheet replaceObjectAtIndex:_currentItemIndex withObject:answers];
    [self updateSubmitButton];
}

- (void)scrollToQuestionAtIndex:(NSNotification *)notif
{
    NSDictionary *dict = notif.userInfo;
    NSInteger index = [dict[@"index"] integerValue];
    
    if (isiPhone) {
        _currentItemIndex = index;
        [_questionCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self updateViewWithCurrentIndex:_currentItemIndex];
    }
    else{
        [_questionCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }

}

- (void)loadView
{
    if (isiPhone) {
        self.view = [UIView new];
        self.view.backgroundColor = [UIColor whiteColor];
        
        // larry3d, ogre, puffy,
        [self.view addSubview:self.titleView];
        [self.view addSubview:self.questionCV];
        
        [self.view addSubview:self.submitButton];
    }
    else{
        self.view = [UIView new];
        self.view.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1.f;
        layout.minimumLineSpacing = 1.f;
        
        _questionCV = [[QuestionnaireCV alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _questionCV.showsHorizontalScrollIndicator = NO;
        _questionCV.cvDelegate = self;

        [self.view addSubview:_questionCV];
    }

    [self.view setNeedsUpdateConstraints];

}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        if (isiPhone) {
            [self.titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0) excludingEdge:ALEdgeBottom];
            
            [self.questionCV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleView withOffset:0];
            [self.questionCV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];

        }
        else{
            [_questionCV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0)];
        }
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isiPhone) {
        
        UIBarButtonItem *answerSheetItem = [[UIBarButtonItem alloc] initWithTitle:@"答题卡" style:UIBarButtonItemStyleDone target:self action:@selector(answerSheetItemPressed)];
        self.navigationItem.rightBarButtonItem = answerSheetItem;
        
        _prevButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_prevButton setImage:[UIImage imageNamed:@"prev.png"] forState:UIControlStateNormal];
        [_prevButton addTarget:self action:@selector(prevButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _prevButton.enabled = NO;
        
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(105, 0, 25, 25)];
        [_nextButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        titleView.backgroundColor = [UIColor clearColor];
        [titleView addSubview:_prevButton];
        [titleView addSubview:_nextButton];
        self.navigationItem.titleView = titleView;
        
        [[MockData sharedData] setCurrentIndex:0];
    }
    else{
        UIBarButtonItem *answerSheetItem = [[UIBarButtonItem alloc] initWithTitle:@"答题卡" style:UIBarButtonItemStyleDone target:self action:@selector(answerSheetItemPressed)];
        UIBarButtonItem *submitSheetItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitButtonPressed)];
        self.navigationItem.rightBarButtonItems = @[submitSheetItem,answerSheetItem];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_questionnaire) {
        [self requestForQuestionnaireData];
    }
}

- (void)viewWillLayoutSubviews
{
    [self.questionCV.collectionViewLayout invalidateLayout];
}

#pragma mark - Actions

- (void)prevButtonPressed
{
    NSInteger index = _currentItemIndex;
    if (index > 0 && index < _questionnaire.questions.count) {
        _currentItemIndex = index - 1;
        [self updateViewWithCurrentIndex:_currentItemIndex];
        [_questionCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)nextButtonPressed
{
    NSInteger index = _currentItemIndex;
    if (index >= 0 && index < _questionnaire.questions.count - 1) {
        _currentItemIndex = index + 1;
        [self updateViewWithCurrentIndex:_currentItemIndex];
        [_questionCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)answerSheetItemPressed
{
    if (isiPhone) {
        if (_questionnaire && _questionnaire.questions.count > 0) {
            AnswerSheetViewController *answerVC = [[AnswerSheetViewController alloc] init];
            answerVC.answerArray = self.answersheet;
            answerVC.questionTitle = _questionnaire.questionnaireTitle;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:answerVC];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        }
    }
    else if (isiPad){
        if (_questionCV.answers.count > 0) {
            AnswerSheetViewController *answerVC = [[AnswerSheetViewController alloc] init];
            answerVC.answerArray = _questionCV.answers;
            answerVC.questionTitle = _questionnaire.questionnaireTitle;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:answerVC];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        }
    }

}

- (void)submitButtonPressed
{
    if ([self isQuestionnaireDone]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否立即提交问卷？" delegate:self cancelButtonTitle:@"稍后提交" otherButtonTitles:@"确定", nil];
        alert.tag = QuestionnaireNotDoneAlertTag;
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需要回答所有问题才能提交问卷" delegate:self cancelButtonTitle:@"查看答题卡" otherButtonTitles:@"确定", nil];
        alert.tag = QuestionnaireDoneAlertTag;
        [alert show];
    }
}

#pragma mark - Lazy-Lazy

- (QuestionnaireTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [QuestionnaireTitleView newAutoLayoutView];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

- (QuestionnaireCV *)questionCV
{
    if (!_questionCV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 1.f;
        layout.minimumLineSpacing = 1.f;
        layout.headerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsZero;

        _questionCV = [[QuestionnaireCV alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _questionCV.translatesAutoresizingMaskIntoConstraints = NO;
        _questionCV.pagingEnabled = YES;
        _questionCV.showsHorizontalScrollIndicator = NO;
        _questionCV.cvDelegate = self;
    }
    return _questionCV;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 44)];
        [_submitButton setTitle:@"提  交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:[UIColor redColor]];
        [_submitButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

#pragma mark - Networking

- (void)requestForQuestionnaireData
{
    NSDictionary *model = [[MockData sharedData] questionnaire];
    _questionnaire = [QuestionnaireModel objectWithKeyValues:model];
    
    for (int i = 0; i < _questionnaire.questions.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        [self.answersheet addObject:arr];
    }
    
    if (isiPhone) {
        [self.titleView configureTitleViewWithText:_questionnaire.questionnaireTitle totalPage:_questionnaire.questions.count];
        self.questionCV.itemHeight = self.view.frame.size.height - [self.titleView getTitleViewHeight] - 64;
    }
    else{
        [self setTitle:_questionnaire.questionnaireTitle];
    }
    
    self.questionCV.questions = [NSMutableArray arrayWithArray:_questionnaire.questions];
    [self.questionCV reloadData];
}

#pragma mark - QuestionnaireCVDelegate

- (void)updateCurrentIndex:(NSInteger)index
{
    _currentItemIndex = index;
    [self updateViewWithCurrentIndex:_currentItemIndex];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // submit and network request
    }
    else{
        if (alertView.tag == QuestionnaireDoneAlertTag) {
            [self answerSheetItemPressed];
        }
        else if (alertView.tag == QuestionnaireNotDoneAlertTag){
            // submit later
        }
    }
}

#pragma mark - Private

- (void)updateViewWithCurrentIndex:(NSInteger)index
{
    [self.titleView setCurrentPage:_currentItemIndex];
    _nextButton.enabled = (_currentItemIndex == _questionnaire.questions.count - 1) ? NO : YES;
    _prevButton.enabled = (_currentItemIndex == 0) ? NO : YES;
    [self updateSubmitButton];
}

- (BOOL)isQuestionnaireDone
{
    BOOL done = YES;

    for (NSArray *arr in self.answersheet) {
        if (arr.count == 0) {
            done = NO;
        }
    }
    return done;
}

- (void)updateSubmitButton
{
    if ([self isQuestionnaireDone] || _currentItemIndex == _questionnaire.questions.count - 1) {
        [self showSubmitButton];
    }
    else{
        [self hideSubmitButton];
    }
}

-(void)showSubmitButton
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         _submitButton.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)hideSubmitButton
{
    if (_submitButton.frame.origin.y == self.view.frame.size.height - 44) {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             _submitButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

@end
