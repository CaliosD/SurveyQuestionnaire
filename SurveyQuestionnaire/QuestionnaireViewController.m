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
#import "SingleQuestionTV.h"
#import "QuestionnaireModel.h"

#import "iCarousel.h"

@interface QuestionnaireViewController ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong) QuestionnaireTitleView *titleView;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) SingleQuestionTV *questionTV;

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
        [self.view addSubview:self.carousel];
        
        [self.view setNeedsUpdateConstraints];
    }
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.titleView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0) excludingEdge:ALEdgeBottom];

        [self.carousel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleView withOffset:12];
        [self.carousel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 12, 0) excludingEdge:ALEdgeTop];

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
    else{
        [self.view addSubview:self.questionTV];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestForQuestionnaireData];
}

#pragma mark - Actions

- (void)prevButtonPressed
{
    NSInteger index = _carousel.currentItemIndex;
    if (index > 0 && index < _questionnaire.questions.count) {
        [_carousel scrollToItemAtIndex:index - 1 animated:YES];
    }
}

- (void)nextButtonPressed
{
    NSInteger index = _carousel.currentItemIndex;
    if (index >= 0 && index < _questionnaire.questions.count - 1) {
        [_carousel scrollToItemAtIndex:index + 1 animated:YES];
    }
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

- (iCarousel *)carousel
{
    if (!_carousel) {
        
        _carousel = [iCarousel newAutoLayoutView];
//        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(12, 118 + 64, 351, 537)];
        _carousel.backgroundColor = [UIColor redColor];
        _carousel.centerItemWhenSelected = YES;
        _carousel.type = iCarouselTypeLinear;
        _carousel.userInteractionEnabled = YES;
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        _carousel.bounces = NO;
    }
    return _carousel;
}

- (SingleQuestionTV *)questionTV
{
    if (!_questionTV) {
        _questionTV = [[SingleQuestionTV alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    }
    return _questionTV;
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
        [self.carousel reloadData];
    }
    else{
        [self setTitle:_questionnaire.questionnaireTitle];
        self.questionTV.model = _questionnaire.questions;
        [self.questionTV reloadData];
    }
}

# pragma mark - iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _questionnaire.questions.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CGFloat titleHeight = [_questionnaire.questionnaireTitle boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    SingleQuestionTV *tableView = nil;
    if (view == nil) {
        CGRect frame = CGRectMake(0, 0, self.carousel.frame.size.width, self.view.frame.size.height - titleHeight - 24 - 64);
        view = [[UIView alloc] initWithFrame:frame];
        tableView = [[SingleQuestionTV alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.tag = 18;
        [view addSubview:tableView];
    }
    else{
        tableView = (SingleQuestionTV *)[view viewWithTag:18];
    }

    if (_questionnaire && _questionnaire.questions.count > 0) {
        tableView.model = [_questionnaire.questions objectAtIndex:index];
        [tableView reloadData];
    }

    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [self.titleView setCurrentPage:carousel.currentItemIndex];
    _prevButton.enabled = (carousel.currentItemIndex == 0) ? NO : YES;
    _nextButton.enabled = (carousel.currentItemIndex == _questionnaire.questions.count - 1) ? NO : YES;

    /**
     *  提交按钮显示条件：
     *  - 已经到达问卷的最后一页
     *  或 
     *  - 全部问题都已经完成时
     */
    if (carousel.currentItemIndex == _questionnaire.questions.count - 1) {
        
    }
}

@end
