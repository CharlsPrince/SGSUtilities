//
//  ToastViewController.m
//  SGSUtilities
//
//  Created by Lee on 2017/2/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ToastViewController.h"
#import "SGSToast.h"
#import "UIViewController+SGSToast.h"

static NSString * const kStr1 = @"hello, world";

static NSString * const kStr2 = @"华盛顿邮报》2月6日报道，美国联邦第九巡回上诉法庭定于美国东部时间2月7日下午6时（北京时间8日早晨7时）举行听证会，就针对特朗普移民禁令的法庭裁决听取美国司法部与华盛顿州、明尼苏达州的口头陈述。;";

static NSString * const kStr3 = @"华盛顿邮报》2月6日报道，美国联邦第九巡回上诉法庭定于美国东部时间2月7日下午6时（北京时间8日早晨7时）举行听证会，就针对特朗普移民禁令的法庭裁决听取美国司法部与华盛顿州、明尼苏达州的口头陈述。 据报道，此次听证会将通过电话进行。本案双方，司法部和华盛顿州、明尼苏达州各有30分钟陈述各自的论点。目前还不清楚听证会结束后，第九巡回上诉法庭将于何时作出裁决。 《华盛顿邮报》称，这标志着特朗普针对难民的总统指令到了一个关键时刻，特朗普移民禁令目前的命运取决于第九巡回上诉法庭的三名联邦法官。《华盛顿邮报》称，如果司法部或者华盛顿州、明尼苏达州任何一方不认同第九巡回上诉法庭的裁决，联邦最高法院最早将于本周介入本案。 中国人民大学国际关系学院副院长金灿荣教授在接受澎湃新闻（www.thepaper.cn）采访时认为，未来无论最高法院做出何种裁决，都将对特朗普政府的权威及其后续执政带来重大影响。 移民禁令为了国家安全还是歧视据《华盛顿邮报》报道，本案双方的言辞都非常激烈，华盛顿州和明尼苏达州在周一递交的文件中称，恢复特朗普的移民禁令将“再次引发混乱”。 司法部则指出，移民禁令是“总统合法行使针对外国人进入美国和接纳难民事务的权力。”并称联邦法官下令暂停执行这一禁令是一个错误，而且“极为过分”。 特朗普政府也坚持认为移民禁令是出于国家安全的必要措施。2月6日晚间，特朗普再次就此事发布推文表示：“极端伊斯兰恐怖主义的威胁非常真实，只要看看欧洲和中东正在发生的事情就知道了。法院必须迅速行动！” 而据CNN报道，华盛顿州和明尼苏达州总检察长向法院提出的几项论点包括，特朗普的禁令违反了宪法第一修正案，因它表现出政府对于某种宗教的偏向。此外该禁令还违反了宪法第十四修正案平等保护条款，因为禁令存在民族和宗教歧视。 金灿荣教授在接受澎湃新闻采访时表示，对于特朗普移民禁令是国家安全的必要，还是违反宪法原则，在不同的立场会有不同的看法。 “特朗普的支持者当然认为国家安全至上，抽象的原则要让路。但是对于另一部分美国人来讲，宪法原则不能违反。”金灿荣教授表示，“美国的宪法强调，任何公共政策不能针对某一类人。可以打击某一种行为，但是不能把具体的行为归类于某一类人。这是宪法原则。 ";

@interface ToastViewController ()

@end

@implementation ToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: [self showCenterSingleLineToastOnWindow]; break;
                case 1: [self showCenterMutLineToastOnWindow]; break;
                case 2: [self showTopOffsetSingleLineToastOnWindow]; break;
                case 3: [self showTopOffsetMutLineToastOnWindow]; break;
                case 4: [self showBottomOffsetSingleLineToastOnWindow]; break;
                case 5: [self showBottomOffsetMutLineToastOnWindow]; break;
                case 6: [self showSingleToastAndDismissAfterFiveSecondOnWindow]; break;
                case 7: [self showLongTextToastOnWindow]; break;
                default: break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0: [self showCenterSingleLineToast]; break;
                case 1: [self showCenterMutLineToast]; break;
                case 2: [self showTopOffsetSingleLineToast]; break;
                case 3: [self showTopOffsetMutLineToast]; break;
                case 4: [self showBottomOffsetSingleLineToast]; break;
                case 5: [self showBottomOffsetMutLineToast]; break;
                case 6: [self showSingleToastAndDismissAfterFiveSecond]; break;
                case 7: [self showLongTextToast]; break;
                default: break;
            }
            break;
        default:
            break;
    }
}

#pragma mark - window

- (void)showCenterSingleLineToastOnWindow {
    [SGSToast showWithMessage:kStr1];
}

- (void)showCenterMutLineToastOnWindow  {
    [SGSToast showWithMessage:kStr2];
}

- (void)showTopOffsetSingleLineToastOnWindow  {
    [SGSToast showWithMessage:kStr1 topOffset:30];
}

- (void)showTopOffsetMutLineToastOnWindow  {
    [SGSToast showWithMessage:kStr2 topOffset:30];
}

- (void)showBottomOffsetSingleLineToastOnWindow  {
    [SGSToast showWithMessage:kStr1 bottomOffset:30];
}

- (void)showBottomOffsetMutLineToastOnWindow  {
    [SGSToast showWithMessage:kStr2 bottomOffset:30];
}

- (void)showSingleToastAndDismissAfterFiveSecondOnWindow  {
    [SGSToast showWithMessage:kStr1 duration:5];
}

- (void)showLongTextToastOnWindow  {
    [SGSToast showWithMessage:kStr3];
}


#pragma mark - self.view

- (void)showCenterSingleLineToast {
    [self showToastWithMessage:kStr1];
}

- (void)showCenterMutLineToast {
    [self showToastWithMessage:kStr2];
}

- (void)showTopOffsetSingleLineToast {
    [self showToastWithMessage:kStr1 topOffset:30];
}

- (void)showTopOffsetMutLineToast {
    [self showToastWithMessage:kStr2 topOffset:30];
}

- (void)showBottomOffsetSingleLineToast {
    [self showToastWithMessage:kStr1 bottomOffset:30];
}

- (void)showBottomOffsetMutLineToast {
    [self showToastWithMessage:kStr2 bottomOffset:30];
}

- (void)showSingleToastAndDismissAfterFiveSecond {
    [self showToastWithMessage:kStr1 duration:5];
}

- (void)showLongTextToast {
    [self showToastWithMessage:kStr3];
}


@end
