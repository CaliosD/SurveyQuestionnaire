//
//  SingleQuestionTV.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "SingleQuestionTV.h"
#import "SingleOptionTVCell.h"
#import "SingleQuestionModel.h"
#import "QuestionnaireModel.h"

#import "UITableView+FDTemplateLayoutCell.h"

static NSString *SingleQuestionTVCellIdentifier = @"OptionCellIdentifier";

@interface SingleQuestionTV ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) QuestionType questionType;

@end

@implementation SingleQuestionTV

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[SingleOptionTVCell class] forCellReuseIdentifier:SingleQuestionTVCellIdentifier];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return isiPhone ? 1 : [(NSArray *)_model count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return isiPhone ? [(SingleQuestionModel *)_model options].count : [[(SingleQuestionModel *)[(NSArray*)_model objectAtIndex:section] options] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SingleOptionTVCell *cell = (SingleOptionTVCell *)[tableView dequeueReusableCellWithIdentifier:SingleQuestionTVCellIdentifier];
    if (!cell) {
        cell = [[SingleOptionTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SingleQuestionTVCellIdentifier];
    }

    [self configureCell:cell atIndex:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [self headerHeightInSection:section] + 12 * 2)];
    header.backgroundColor = [UIColor whiteColor];
    
    if (isiPad) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [header addSubview:line];
    }
    
    UILabel *qType = [[UILabel alloc] initWithFrame:CGRectMake(12, 14, 50, 15)];
    qType.font = [UIFont systemFontOfSize:15.f];
    qType.textColor = [UIColor colorWithRed:0.f green:153/255.f blue:255/255.f alpha:1.f];
    [header addSubview:qType];
    
    UILabel *question = [[UILabel alloc] initWithFrame:CGRectMake(50 + 12, 12, self.bounds.size.width - 50 - 12 * 3, [self headerHeightInSection:section])];
    question.numberOfLines = 0;
    question.lineBreakMode = NSLineBreakByWordWrapping;
    question.font = [UIFont systemFontOfSize:15.f];
    [header addSubview:question];
    
    SingleQuestionModel *model = isiPhone ? (SingleQuestionModel *)_model : (SingleQuestionModel *)[(NSArray*)_model objectAtIndex:section];
    qType.text = [NSString stringWithFormat:@"(%@)", [self questionType:model.questionType]];
    question.text = model.question;
    
    return header;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleOptionTVCell * cell = (SingleOptionTVCell *)[tableView cellForRowAtIndexPath:indexPath];
    OptionModel *option = isiPhone ? [[(SingleQuestionModel *)_model options] objectAtIndex:indexPath.row] : [[(SingleQuestionModel *)[(NSArray*)_model objectAtIndex:indexPath.section] options] objectAtIndex: indexPath.row];
    option.isSelected = !option.isSelected;
    cell.option = option;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self headerHeightInSection:section] + 12 * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:SingleQuestionTVCellIdentifier configuration:^(SingleOptionTVCell *cell) {
        [self configureCell:cell atIndex:indexPath];
    }];
}

- (void)configureCell:(SingleOptionTVCell *)cell atIndex:(NSIndexPath *)indexPath
{
    SingleQuestionModel * question = isiPhone ? (SingleQuestionModel *)_model : (SingleQuestionModel *)[(NSArray *)_model objectAtIndex:indexPath.section];
    _questionType = question.questionType;
    
    OptionModel *option = [question.options objectAtIndex:indexPath.row];
    cell.questionType = question.questionType;
    cell.option = option;
}

#pragma mark - Private

- (NSString *)questionType:(QuestionType)type
{
    NSString *question;
    switch (type) {
        case QuestionType_SingleOption:
            question = @"单选";
            break;
        case QuestionType_MultipleOptions:
            question = @"多选";
            break;
        default:
            break;
    }
    return question;
}

- (CGFloat)headerHeightInSection:(NSInteger)section
{
    CGFloat height = 0.f;
    SingleQuestionModel *model = isiPhone ? (SingleQuestionModel *)_model : (SingleQuestionModel *)[(NSArray*)_model  objectAtIndex:section];

    if (model) {
        height = [model.question boundingRectWithSize:CGSizeMake(self.bounds.size.width - 50 - 12 * 3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    }
    return height;
}

@end
