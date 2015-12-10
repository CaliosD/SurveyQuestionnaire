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

#import "UITableView-FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h"

static NSString *SingleQuestionTVCellIdentifier = @"OptionCellIdentifier";

@interface SingleQuestionTV ()<UITableViewDelegate, UITableViewDataSource>

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
        _answerArray = [NSMutableArray array];
    }
    return self;
}

- (void)setModel:(SingleQuestionModel *)model
{
    _model = model;
    [_answerArray removeAllObjects];
    /**
     *  Init for answer array.
     */
    for (NSInteger i = 0; i < _model.options.count; i++) {
        OptionModel *option = _model.options[i];
        if (option.isSelected) {
            [_answerArray addObject:[NSNumber numberWithInteger:i]];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.options.count;
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
    OptionModel *option = [_model.options objectAtIndex:indexPath.row];
    option.isSelected = !option.isSelected;
    [_model.options replaceObjectAtIndex:indexPath.row withObject:option];
    [cell updateCellWithSelected:option.isSelected];

    if (_model.questionType == QuestionType_MultipleOptions) {
        if (option.isSelected) {
            [_answerArray addObject:[NSNumber numberWithInteger:indexPath.row]];
        }
        else{
            [_answerArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
        }
    }
    else if (_model.questionType == QuestionType_SingleOption){
        if (option.isSelected) {
            if (_answerArray.count > 0) {
                SingleOptionTVCell * oldCell = (SingleOptionTVCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_answerArray[0] integerValue] inSection:0]];
                [oldCell updateCellWithSelected:NO];
                OptionModel *o = [_model.options objectAtIndex:[_answerArray[0] integerValue]];
                o.isSelected = NO;
                [_model.options replaceObjectAtIndex:[_answerArray[0] integerValue] withObject:o];
            }
            
            [_answerArray removeAllObjects];
            [_answerArray addObject:[NSNumber numberWithInteger:indexPath.row]];
        }
        else{
            [_answerArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
        }
    }
    
    NSLog(@"()( send:%ld, %@",(long)_index,_answerArray);
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionnaireAnswersChangeNotification object:self userInfo:@{@"index": [NSNumber numberWithInteger:_index], @"answer":_answerArray}];
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
    OptionModel *option = [_model.options objectAtIndex:indexPath.row];
    cell.questionType = _model.questionType;
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
    SingleQuestionModel *model = isiPhone ? _model : (SingleQuestionModel *)[(NSArray*)_model  objectAtIndex:section];

    if (model) {
        height = [model.question boundingRectWithSize:CGSizeMake(self.bounds.size.width - 50 - 12 * 3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    }
    return height;
}

@end
