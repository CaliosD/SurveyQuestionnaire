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

@interface QuestionnaireViewController ()<QuestionnaireCVDelegate>

@property (nonatomic, strong) QuestionnaireTitleView *titleView;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) QuestionnaireCV *questionCV;

@property (nonatomic, strong) QuestionnaireModel *questionnaire;
@property (nonatomic, strong) NSMutableArray *answerArray;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation QuestionnaireViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _answerArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView
{
    if (isiPhone) {
        self.view = [UIView new];
        self.view.backgroundColor = [UIColor whiteColor];
        
        // larry3d, ogre, puffy,
        [self.view addSubview:self.titleView];
        [self.view addSubview:self.questionCV];
        
    }
    else{
        self.view = [UIView new];
        self.view.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(1024, 300);
        layout.minimumInteritemSpacing = 1.f;
        layout.minimumLineSpacing = 1.f;
        layout.headerReferenceSize = CGSizeMake(1024, 80);
        
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
        
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(105, 0, 25, 25)];
        [_nextButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        titleView.backgroundColor = [UIColor clearColor];
        [titleView addSubview:_prevButton];
        [titleView addSubview:_nextButton];
        self.navigationItem.titleView = titleView;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestForQuestionnaireData];
}

- (void)viewWillLayoutSubviews
{
    [self.questionCV.collectionViewLayout invalidateLayout];
}

#pragma mark - Actions

- (void)prevButtonPressed
{
//    NSInteger index = _carousel.currentItemIndex;
//    if (index > 0 && index < _questionnaire.questions.count) {
//        [_carousel scrollToItemAtIndex:index - 1 animated:YES];
//    }
}

- (void)nextButtonPressed
{
//    NSInteger index = _carousel.currentItemIndex;
//    if (index >= 0 && index < _questionnaire.questions.count - 1) {
//        [_carousel scrollToItemAtIndex:index + 1 animated:YES];
//    }
}

- (void)answerSheetItemPressed
{
    if (_questionnaire && _questionnaire.questions.count > 0) {
        AnswerSheetViewController *answerVC = [[AnswerSheetViewController alloc] init];
        answerVC.answerArray = _answerArray;
        answerVC.questionTitle = _questionnaire.questionnaireTitle;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:answerVC];
        [self.navigationController presentViewController:nav animated:YES completion:NULL];
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

#pragma mark - Networking

- (void)requestForQuestionnaireData
{
    NSDictionary *model = [[MockData sharedData] questionnaire];
    _questionnaire = [QuestionnaireModel objectWithKeyValues:model];
    [_answerArray removeAllObjects];
    
    for (int i = 0; i < _questionnaire.questions.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        [_answerArray addObject:arr];
    }
    
    if (isiPhone) {
        [self.titleView configureTitleViewWithText:_questionnaire.questionnaireTitle totalPage:_questionnaire.questions.count];
        self.questionCV.itemHeight = self.view.frame.size.height - [self.titleView getTitleViewHeight] - 64;
    }
    else{
        [self setTitle:_questionnaire.questionnaireTitle];
    }
    
    self.questionCV.questions = _questionnaire.questions;
    [self.questionCV reloadData];

}

#pragma mark - QuestionnaireCVDelegate

- (void)updateCurrentIndex:(NSInteger)index
{
    [self.titleView setCurrentPage:index];
}

@end
