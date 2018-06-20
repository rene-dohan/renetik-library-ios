//
//  Created by Rene Dohan on 6/11/12.
//


#import <Foundation/Foundation.h>

@interface UITableView (CSExtension)

- (instancetype)setup:(id <UITableViewDelegate, UITableViewDataSource>)parent;

- (instancetype)setup:(id <UITableViewDelegate>)delegate :(id <UITableViewDataSource>)dataSource;

- (void)deselectSelectedRow;

- (void)deselectSelectedRows:(BOOL)animated;

- (UITableViewCell *)getCell:(Class)clazz;

- (id)dequeueReusableCell:(NSString *)identifier;

- (instancetype)hideEmptyCellSplitterBySettingEmptyFooter;

- (void)toggleEditingAnimated:(BOOL)animated;

- (UITableViewCell *)getCellForView:(Class)viewClass;

- (UITableViewCell *)createCellForView:(Class)viewClass :(void (^)(UITableViewCell *))onCreate;

- (UITableViewCell *)getCellWithStyle:(NSString *)string :(UITableViewCellStyle)style;

- (UITableViewCell *)getCellWithStyle:(NSString *const)id :(enum UITableViewCellStyle)style :(void (^)(UITableViewCell *cell))onCreate;
@end