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
@property (strong, nonatomic) AnswerSheetCV *answerSheetCV;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation AnswerSheetViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.answerSheetCV];
    
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
        
    }
    return _answerSheetCV;
}

#pragma mark - AnswerSheetCVDelegate

- (void)answerCellSelectedWithIndex:(NSInteger)index
{
    
}

@end
