/*!
 *  @file SGSBaseTableViewProtocol.m
 *
 *  @author Created by 吴周鑫 on 16-4-24.
 *
 *  @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SGSBaseTableViewProtocol.h"

@interface SGSBaseTableViewProtocol()

@property (nonatomic,copy  ) NSString                            *cellIdentifier;
@property (nonatomic,strong) NSArray                             *items;
//Number of sections in table view
@property (nonatomic       ) NSInteger                           sectionNumber;
//Block for cell configuration
@property (nonatomic,copy  ) TableViewCellConfigurate         cellConfigureBlock;
//Block for number of rows configuration
@property (nonatomic,copy  ) TableViewNumberOfRowsInSectionConfigurate numberOfRowsConfigure;

@end

@implementation SGSBaseTableViewProtocol
-(id)initWithItems:(NSArray *)aItems
    cellIdentifier:(NSString *)aCellIdentifier
  numberOfSections:(NSInteger)aSectionNumber
numberOfRowsInSectionConfigureBlock:(TableViewNumberOfRowsInSectionConfigurate)aNunberOfRowsInSectionConfigureBlock
cellConfigureBlock:(TableViewCellConfigurate)aCellConfigureBlock;
{
    self = [super init];
    if (self) {
        self.items = aItems;
        self.cellIdentifier = aCellIdentifier;
        self.sectionNumber = aSectionNumber;
        self.numberOfRowsConfigure = [aNunberOfRowsInSectionConfigureBlock copy];
        self.cellConfigureBlock = [aCellConfigureBlock copy];
    }
    return self;
}

-(id)initWithItems:(NSArray *)aItems
    cellIdentifier:(NSString *)aCellIdentifier
cellConfigureBlock:(TableViewCellConfigurate)aCellConfigureBlock
{
    return [self initWithItems:aItems
                cellIdentifier:aCellIdentifier
              numberOfSections:1
numberOfRowsInSectionConfigureBlock:nil
            cellConfigureBlock:aCellConfigureBlock];
}

#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionNumber;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectRowAtIndexPath:)]) {
        [self.delegate selectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellHeightAtIndexPath:)]) {
        return [self.delegate cellHeightAtIndexPath:indexPath];
    }
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellHeaderViewAtSection:)]) {
        return [self.delegate cellHeaderViewAtSection:section];
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellHeightForHeaderViewAtSection:)]) {
        return [self.delegate cellHeightForHeaderViewAtSection:section];
    }
    
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellFooterViewAtSection:)]) {
        return [self.delegate cellFooterViewAtSection:section];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellHeightForFooterViewAtSection:)]) {
        return [self.delegate cellHeightForFooterViewAtSection:section];
    }
    return 0.1f;
}

#pragma mark - UITableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowsConfigure) {
        return self.numberOfRowsConfigure(section);
    }
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id item = self.items[(NSUInteger)indexPath.row];
    self.cellConfigureBlock(cell,item,indexPath);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.delegate) {
            [self.delegate deleteRowAtIndexPath:indexPath];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(isCellEditable)]) {
        return [self.delegate isCellEditable];
    }
    return NO;
}
@end
