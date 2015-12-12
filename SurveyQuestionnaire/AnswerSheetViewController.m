//
//  AnswerSheetViewController.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/4/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "AnswerSheetViewController.h"
#import "QuestionnaireTitleView.h"
#import "AnswerSheetCV.h"

@interface AnswerSheetViewController ()<AnswerSheetCVDelegate>

@property (strong, nonatomic) QuestionnaireTitleView *titleView;
@property (strong, nonatomic) AnswerSheetCV          *answerSheetCV;
@property (nonatomic, strong) UIButton               *submitButton;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation AnswerSheetViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.answerSheetCV];
    [self.view addSubview:self.submitButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [_titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0) excludingEdge:ALEdgeBottom];
        
        [_answerSheetCV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleView withOffset:12];
        [_answerSheetCV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"答题卡"];
    self.view.backgroundColor = [UIColor whiteColor];
       
    [_titleView configureTitleViewWithText:_questionTitle totalPage:0];
    _answerSheetCV.answers = _answerArray;
    [_answerSheetCV reloadData];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemPressed)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
}

- (void)cancelItemPressed
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)submitButtonPressed
{
    if ([self isQuestionnaireDone]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否立即提交问卷？" delegate:self cancelButtonTitle:@"稍后提交" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需要回答所有问题才能提交问卷" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

- (AnswerSheetCV *)answerSheetCV
{
    if (!_answerSheetCV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.5;
        layout.itemSize = CGSizeMake(50, 50);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _answerSheetCV = [[AnswerSheetCV alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _answerSheetCV.answerSheetDelegate = self;
    }
    return _answerSheetCV;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 44, [[UIScreen mainScreen] bounds].size.width, 44)];
        [_submitButton setTitle:@"提  交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:[UIColor redColor]];
        [_submitButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

#pragma mark - AnswerSheetCVDelegate

- (void)answerCellSelectedWithIndex:(NSInteger)index
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionnaireScrollNotification object:self userInfo:@{@"index":[NSNumber numberWithInteger:index]}];
}

#pragma mark - Private
- (BOOL)isQuestionnaireDone
{
    BOOL done = YES;
    for (NSArray *a in self.answerArray) {
        if (a.count == 0) {
            done = NO;
        }
    }
    return done;
}

@end
