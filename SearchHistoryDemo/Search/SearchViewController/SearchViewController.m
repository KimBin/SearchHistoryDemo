//
//  ViewController.m
//  SearchHistoryDemo
//
//  Created by Lzq on 16/3/6.
//  Copyright © 2016年 Lzq. All rights reserved.
//

#import "SearchViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "FMDBTools.h"
#import "SearchModel.h"
@interface SearchViewController ()
{
    NSMutableArray *myArray; //模拟的数组
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    
}





@property (retain, nonatomic)UITableView *tableView;

@end

@implementation SearchViewController


- (void)viewWillAppear:(BOOL)animated
{
    [[FMDBTools shareManageDate]creatSearchHistory];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[FMDBTools shareManageDate]closeDB];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationUI];
    [self searchBarUI];
    [self initTableView];

    
}


#pragma mark 导航栏
- (void)initNavigationUI
{
 //   [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction)];
    
    self.title = @"SearchDemo";
    self.view.backgroundColor = [UIColor whiteColor];

}

#pragma mark 搜索控件
- (void)searchBarUI
{
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索列表"];
    [self.view addSubview:mySearchBar];
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    

}


#pragma mark 显示的tableView
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = mySearchBar;
    dataArray = [[FMDBTools shareManageDate]selectAllHistory];
    myArray = [NSMutableArray array];
    
#warning 模拟搜索的数据 这里为10条
    for (int i = 0; i <= 10; i++)
    {
        SearchModel *model = [[SearchModel alloc]init];
        model.title = [NSString stringWithFormat:@"test%d",i];
        [myArray addObject:model];
    }
    
    
    
    UIButton*deleteBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
    
    [deleteBtn setTitle:@"清空搜索历史" forState:(UIControlStateNormal)];
    [deleteBtn setTitleColor:[UIColor colorWithWhite:0.702 alpha:1.000] forState:(UIControlStateNormal)];
    [deleteBtn addTarget:self action:@selector(deleteHistory:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableFooterView = deleteBtn;

}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    else {
        return dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchModel *model = searchResults[indexPath.row];
        cell.textLabel.attributedText = model.attributeTitle;
    }
    else {
        SearchModel *model = dataArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchModel *model = searchResults[indexPath.row];
        [[FMDBTools shareManageDate]insertSearchDate:model];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"插入成功，做了一个不会重复插入的判断" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alert show];
        dataArray = [[FMDBTools shareManageDate]selectAllHistory];
        [self.tableView reloadData];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"点击历史不会插入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<myArray.count; i++) {
            SearchModel *model = myArray[i];
            if ([ChineseInclude isIncludeChineseInString:model.title]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.title];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:
                                     NSCaseInsensitiveSearch];
                NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:model.title];
                [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:titleResult];
                model.attributeTitle = attriStr;
                if (titleResult.length>0) {
                    [searchResults addObject:model];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.title];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                NSMutableAttributedString *attriStr1 = [[NSMutableAttributedString alloc]initWithString:model.title];
                [attriStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:titleResult];
                model.attributeTitle = attriStr1;
                if (titleHeadResult.length>0) {
                    [searchResults addObject:model];
                }
            }
            else {
                NSRange titleResult=[model.title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:model.title];
                [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:titleResult];
                model.attributeTitle = attriStr;
                if (titleResult.length>0) {
                    [searchResults addObject:model];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (SearchModel *m in myArray) {
            NSRange titleResult=[m.title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:m.title];
            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:titleResult];
            m.attributeTitle = attriStr;
            if (titleResult.length>0) {
                [searchResults addObject:m];
            }
        }
    }
}



#pragma mark 清空数据
- (void)deleteHistory:(UIButton *)btn
{
    //这里是一条一条的删  ，可以直接删表
    [[FMDBTools shareManageDate]deleteHistoryTable];
    [dataArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark 返回
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
