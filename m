Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5750EC432BE
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jul 2021 11:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3676160C51
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jul 2021 11:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhGZLB3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:01:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13172 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233545AbhGZLB1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 26 Jul 2021 07:01:27 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QBbnu8015878;
        Mon, 26 Jul 2021 11:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=EtDmBi6+Dkm1CnebormDlXnn+2XX2WVS7W4O9MEEBVw=;
 b=ferpKbyLQOd3warMwne6O1l54UB7I5F2YCrwzOtEb8FdprXqsMz2PiYLClFaRTleQQQ5
 A4bo4C6ikXTLhxoCdQkdS1rCBqppt5y0H+GvL0bHJfZ7/AKNqOoyDZDeWGFD97LvLlbW
 S0ZvUbffe0H9fGHjW3o1rMrOgPH7lOMSqEE8h6WRtiDIW6N+/ShuH7NQS4MLy+T1+4Z2
 yQzc13e3ZrVCpklaTILcmo6b1gIOHAxnUb9aQsdPdgLR5a0m1H37xLAmuGIE+uPTZWU/
 JaM0Y9yzNd+hI7sYs60F9eFnizOOuPRN1cuMw/WHNvDIexH+r6ICpLDZmd/jRRRaZ1C4 8Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=EtDmBi6+Dkm1CnebormDlXnn+2XX2WVS7W4O9MEEBVw=;
 b=SmbdRZt52NfrsdjwN5/pDkMeEReo/lRTtdBWS0T8bG6ep4KJrv1OYUdi+GwBeJYwSkM8
 YVobVCGldO9wRXwU6tLA+r/4+UiIPA1HSmV6trANdimC6MGAlkOrLv4PKB3dHITtF0sI
 yfOgaAziRUI4RYGRarP5HcU0wkCvAsb7K4gACdt20n7VqsHeWNehOofXyCD+H1U5Edsr
 OIvX+4AXwPIwUhNxksXDGo99a/HmSiG9Nr2D/wPvTL+gYkykDWuyyiKTDtsfusJwV2H3
 /wxOHociUYijOYnI7IpLjR18lBqzaZUCaY+fe7cCqcWiTAnViReBPFNKtibxvXQu1fdc Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a0afrtv3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 11:41:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QBYnGu067409;
        Mon, 26 Jul 2021 11:41:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3a07yvagnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 11:41:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRWHMxMRnxvkypjHlnGX5Ku4rSWGnCvTYTgU60ihm2Qjqg572CLpd8kSXhENrEujxM+8kSSOS0jL4RCVjaYL2NmUkcqBQsTZiC+JXSlJ/eW7XILCwT2VxkTGPT9C7iQpm/5dX3h4fDeRuV/c64w9nAxZlgtXOgXWvNTTm8+gXH19X1ikBGq41RxpqS4dSk/akGSjz2QN1DHGTzyoAwuCashYUAq57bdGlARLFVJekTCgenCMx2PSdc36kS8BjRAVNBSWHs4Cze7YVr33ZyXrMp1NcbI6EpiNSMKKEpB9gXfclqozkBa4P2s6KLzCcM8OsTnW4+tvJRX6KaSWYgDhCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtDmBi6+Dkm1CnebormDlXnn+2XX2WVS7W4O9MEEBVw=;
 b=H2UN0gAetOw/3f/CsTjj7dvXsNxDjy8lcD9ThP1XYK2Z43b+J0ewaAy1jcg2a3SviZTV5fNnCkt5Mh2v+OwQ3s/DQ7y8Ov2ZsHywsYUsfSihtak4PlF50IaHTGN/bUcO49M4sH9yLLNDqcHCFqf3TKXwGI6qHBC2vPFkNKQ9MCLJS26Ym+byizMh1bUU4p1HKfWO7cGO/FBgIeW0ixx+Ah2SkW7c2254JgwvvP1LCyQGZEvZUqKKIYw4PlnjJA9tybnUMovhbXgQiYQg9VJJAopqPnMAopfZNco2nq11UU36KLA2goQM/TYcI7tqbTS874WVHoe7m8OCdsIlqLA1Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtDmBi6+Dkm1CnebormDlXnn+2XX2WVS7W4O9MEEBVw=;
 b=bNEu81U98um9aN4r+2gBQGs8yddASce54DlV/oD7Qj3jcMx1Io8Aa+tetVWRtjOonDrNRcoJmGPwiNtWNbYnlTGs8dK1kajG2cjXt3RbeeeChTi6atPatjuM89ujiHnMsv/Fuv198MY3HQ1F3NWVkfcMhhFba9jA1qyimWSJv9Y=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1663.namprd10.prod.outlook.com
 (2603:10b6:301:7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 11:41:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 11:41:47 +0000
Date:   Mon, 26 Jul 2021 14:41:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     namjae.jeon@samsung.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] ksmbd: fix unused err value in smb2_lock
Message-ID: <20210726114137.GA30721@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0144.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0144.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 11:41:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6397ee18-117a-49ea-4514-08d9502a59d2
X-MS-TrafficTypeDiagnostic: MWHPR10MB1663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB16634BD648EFC26B9A6DF0B28EE89@MWHPR10MB1663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Px1fatoe13k34WTIP46YOXWW9zXhkXM+qHJENxpYxVE3aqlaoORl4ijCVIILz4oOLE44PwZ94f9lNv1LhuXIf8wViOsxoMDDK0G9ZjiYJIfZi66UkhPN0Cp9eWPBmYi6hOf0nrfd07Oqu1IqPcGWwCkP0Vc7fnKJBeeBZcbiBPPAbczdMoMnZuAYQURPGARI2kyQk43pdGtsuL/Dnl1r/nS2rAo6sEajatWe/8P3hfMVqOzHbh/cAhyqDRwUfM4T+XMrKhmUDN0SVkVfFNEs9u0tacX50HT4GW6UccQygKXH6cRpGRs5bC4gW27pL7KheBI2jLBtI9I9F/y9sv22re5wIPQhlO259+wyP9Oz7vhTzmGztoCHBbi3+pGB1vl4wAmHCYlm0Pzm3LWOGhxoxVBUVoZyIPgdnsKWCwFJ13b0S3A38yR3cIBz4tsbplnyhCoeyNOZVHw+oZNfpdlnS3fGr6XRhAoLxQjnU/ci4kIbWmumQZfNxPOJG543cUKWcpRjilrPm1HlPClwjG9NukuEJP6iJUDIDV+VFWv4oc0TqkO5UEiwgths048qHU1hw6q856KRtH0D5uND2iSTSKzmrJS+rOvEf4ju5sws2ybVlzaMAuZUlxLzWSQonguUUXHeE7Jl1PhNlcuVMSnIO2GQxNczaamUOIaeAPxBnK5xTzB5vxU+gelWLQOfuvmp0Wg2bsJdsTlkom2QrMCkPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(366004)(39860400002)(55016002)(9686003)(86362001)(26005)(186003)(33716001)(66476007)(66556008)(66946007)(316002)(8676002)(83380400001)(2906002)(4326008)(6666004)(478600001)(52116002)(8936002)(6916009)(38100700002)(33656002)(44832011)(38350700002)(9576002)(6496006)(1076003)(5660300002)(956004)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kq+cL/TBIjhE2naZVUXUx4SNpCEZn70ZX7mWulcaFpxCJtZxGQhKASeEbZKu?=
 =?us-ascii?Q?7SVS00KGudfyvpYU8MePWfD3vIEcls05PRIYbO5JjjNw4pIfXF3hLsAwNgDF?=
 =?us-ascii?Q?L79u7mFRmn5R5XKvJFdgo5QGxXj9H3Cw2sHmUTfpjvxUBK6QQwKkKK/ZnQtw?=
 =?us-ascii?Q?NcQ34V4ZOJSsJZFQHSbbt07BkGNd3DihgMlD/eBzjbTxOCz8hxjWtHFVeQbi?=
 =?us-ascii?Q?e2S2eK4l+dK+dcvIFTPUnTD2GFtKKh89GeLBjsf0aHRalfLX+Hv+FBGs/+1y?=
 =?us-ascii?Q?5Bby5XNtP3+3y/qKGwjzEVrAZMCT1K7LD7bzVfdaQj4bVsDD1sZl2iVzBbot?=
 =?us-ascii?Q?Hckm1/8rF7V5L2kCnqIbm0ygOSDUw4v96RcLbiKJ2cGA5uuoWYT3v/1hGImc?=
 =?us-ascii?Q?PjOmg+eALzSw6cgauEmutDsBmR8NZ8TOHY2mzCGXaSEoS+JIfBcVLvqobNNh?=
 =?us-ascii?Q?vFSrVjwsFQq3LJIPUXSetQ7+exSjLZ8f6blUgYBlZLxmS7/C9We+JUVB8yup?=
 =?us-ascii?Q?PB898ILACte2K0ypPzW50Gz0Rh0UxoAYdOqOCpfJriF/ncaEA9WfZSu3IA+m?=
 =?us-ascii?Q?I3wXtdMmCk3hpEKKhcR0fXk7FEXgf9X7HSB327fu0NpAseuargU9YO1AYZWg?=
 =?us-ascii?Q?CESB09lNjfR16di0U+Rbs8t+TrD995p2VbaE3bBUWYSraHI8nkSbVzBgnA53?=
 =?us-ascii?Q?bji64wvDH5XSe+e1+KWm3yO2Vpz18iz1oe5bUAlAaae9K3kY9qmOOBTm+K0w?=
 =?us-ascii?Q?L7USnuwMnRJZ9oHW38K/uxz14oLnYoQlAjeFMaBD3ffg9oZcGT/5Liorjbdf?=
 =?us-ascii?Q?knymL6buA3YKjcHzpXQ66A0IiIhTZqDH8tLcANN+RXT+Biv7LFTfRshhXzfE?=
 =?us-ascii?Q?766OFPkqXUdGUcsgYGrCuwpHJKfT4Lohis5J0BRqxHcgt99DrjWPhvA/76XU?=
 =?us-ascii?Q?BVSLvp0WofgzOY+NCt5fVqsLMnixkhulI4gUS8Vh8/GHKw7WjR4AHBjzTsGv?=
 =?us-ascii?Q?wWS+UcQOO+E6c8oan2Wc7f+wdc3JGUeJwjUPYdjFnBTeTEGQHobisKO+J/iz?=
 =?us-ascii?Q?J8IPJ+vHYkwqLPSmV8o0yTSTuXCK+DcLLo9EAhVish0MURnXPEVpD7h8Y2iF?=
 =?us-ascii?Q?ijcC7wP+xRHU0E22D+mmNUqk9ko/CIxaBZ/EmXXzNt7Yd8WyR8AJ9h1MlhF5?=
 =?us-ascii?Q?fXJUOUasraw5t0WT/P/s9W4kEzIwarbwflWPZoXfHvOpJzLXZBsuEOGXbNe5?=
 =?us-ascii?Q?lQESYJ4qa2MRngb2gPxYOjDPlprb34SgSXyJtk6SbkM2lvvL86xpj0HL2Omz?=
 =?us-ascii?Q?1dIvq8iaxQaVOSTLnkLdtdyV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6397ee18-117a-49ea-4514-08d9502a59d2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 11:41:47.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lfy0R+0ehaJW69xk/BSQUgWTsfLKlYD3GDTjeY2gBAIM6D73a6jtGodtGuU+f7K6duchcgj8UilY/EnKQfwRUzaUPEBGqfqQQ/uGwKYKU28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10056 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260067
X-Proofpoint-ORIG-GUID: KuJYMxvROwf6gzBs0gm6sfSATOHFvBl_
X-Proofpoint-GUID: KuJYMxvROwf6gzBs0gm6sfSATOHFvBl_
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch 96ad4ec51c06: "ksmbd: fix unused err value in smb2_lock"
from Jul 13, 2021, leads to the following static checker warning:

	fs/ksmbd/smb2pdu.c:6565 smb2_lock()
	warn: missing error code here? 'smb_flock_init()' failed.

fs/ksmbd/smb2pdu.c
    6518 int smb2_lock(struct ksmbd_work *work)
    6519 {
    6520 	struct smb2_lock_req *req = work->request_buf;
    6521 	struct smb2_lock_rsp *rsp = work->response_buf;
    6522 	struct smb2_lock_element *lock_ele;
    6523 	struct ksmbd_file *fp = NULL;
    6524 	struct file_lock *flock = NULL;
    6525 	struct file *filp = NULL;
    6526 	int lock_count;
    6527 	int flags = 0;
    6528 	int cmd = 0;
    6529 	int err = 0, i;
    6530 	u64 lock_start, lock_length;
    6531 	struct ksmbd_lock *smb_lock = NULL, *cmp_lock, *tmp, *tmp2;
    6532 	struct ksmbd_conn *conn;
    6533 	int nolock = 0;
    6534 	LIST_HEAD(lock_list);
    6535 	LIST_HEAD(rollback_list);
    6536 	int prior_lock = 0;
    6537 
    6538 	ksmbd_debug(SMB, "Received lock request\n");
    6539 	fp = ksmbd_lookup_fd_slow(work,
    6540 				  le64_to_cpu(req->VolatileFileId),
    6541 				  le64_to_cpu(req->PersistentFileId));
    6542 	if (!fp) {
    6543 		ksmbd_debug(SMB, "Invalid file id for lock : %llu\n",
    6544 			    le64_to_cpu(req->VolatileFileId));
    6545 		rsp->hdr.Status = STATUS_FILE_CLOSED;
    6546 		goto out2;
    6547 	}
    6548 
    6549 	filp = fp->filp;
    6550 	lock_count = le16_to_cpu(req->LockCount);
    6551 	lock_ele = req->locks;
    6552 
    6553 	ksmbd_debug(SMB, "lock count is %d\n", lock_count);
    6554 	if (!lock_count) {
    6555 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
    6556 		goto out2;
    6557 	}
    6558 
    6559 	for (i = 0; i < lock_count; i++) {
    6560 		flags = le32_to_cpu(lock_ele[i].Flags);
    6561 
    6562 		flock = smb_flock_init(filp);
    6563 		if (!flock) {
    6564 			rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
--> 6565 			goto out;
                                ^^^^^^^^
Should this be an error code?


    6566 		}
    6567 
    6568 		cmd = smb2_set_flock_flags(flock, flags);
    6569 
    6570 		lock_start = le64_to_cpu(lock_ele[i].Offset);
    6571 		lock_length = le64_to_cpu(lock_ele[i].Length);
    6572 		if (lock_start > U64_MAX - lock_length) {
    6573 			pr_err("Invalid lock range requested\n");
    6574 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
    6575 			goto out;

Same for a bunch of these early gotos as well.

    6576 		}
    6577 
    6578 		if (lock_start > OFFSET_MAX)
    6579 			flock->fl_start = OFFSET_MAX;
    6580 		else
    6581 			flock->fl_start = lock_start;
    6582 
    6583 		lock_length = le64_to_cpu(lock_ele[i].Length);
    6584 		if (lock_length > OFFSET_MAX - flock->fl_start)
    6585 			lock_length = OFFSET_MAX - flock->fl_start;
    6586 
    6587 		flock->fl_end = flock->fl_start + lock_length;
    6588 
    6589 		if (flock->fl_end < flock->fl_start) {
    6590 			ksmbd_debug(SMB,
    6591 				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
    6592 				    flock->fl_end, flock->fl_start);
    6593 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
    6594 			goto out;
    6595 		}
    6596 
    6597 		/* Check conflict locks in one request */
    6598 		list_for_each_entry(cmp_lock, &lock_list, llist) {
    6599 			if (cmp_lock->fl->fl_start <= flock->fl_start &&
    6600 			    cmp_lock->fl->fl_end >= flock->fl_end) {
    6601 				if (cmp_lock->fl->fl_type != F_UNLCK &&
    6602 				    flock->fl_type != F_UNLCK) {
    6603 					pr_err("conflict two locks in one request\n");
    6604 					rsp->hdr.Status =
    6605 						STATUS_INVALID_PARAMETER;
    6606 					goto out;
    6607 				}
    6608 			}
    6609 		}
    6610 
    6611 		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
    6612 		if (!smb_lock) {
    6613 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
    6614 			goto out;
    6615 		}
    6616 	}
    6617 
    6618 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
    6619 		if (smb_lock->cmd < 0) {
    6620 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
    6621 			goto out;
    6622 		}
    6623 
    6624 		if (!(smb_lock->flags & SMB2_LOCKFLAG_MASK)) {
    6625 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
    6626 			goto out;
    6627 		}
    6628 
    6629 		if ((prior_lock & (SMB2_LOCKFLAG_EXCLUSIVE | SMB2_LOCKFLAG_SHARED) &&
    6630 		     smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) ||
    6631 		    (prior_lock == SMB2_LOCKFLAG_UNLOCK &&
    6632 		     !(smb_lock->flags & SMB2_LOCKFLAG_UNLOCK))) {
    6633 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
    6634 			goto out;
    6635 		}
    6636 
    6637 		prior_lock = smb_lock->flags;
    6638 
    6639 		if (!(smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) &&
    6640 		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY))
    6641 			goto no_check_cl;
    6642 
    6643 		nolock = 1;
    6644 		/* check locks in connection list */
    6645 		read_lock(&conn_list_lock);
    6646 		list_for_each_entry(conn, &conn_list, conns_list) {
    6647 			spin_lock(&conn->llist_lock);
    6648 			list_for_each_entry_safe(cmp_lock, tmp2, &conn->lock_list, clist) {
    6649 				if (file_inode(cmp_lock->fl->fl_file) !=
    6650 				    file_inode(smb_lock->fl->fl_file))
    6651 					continue;
    6652 
    6653 				if (smb_lock->fl->fl_type == F_UNLCK) {
    6654 					if (cmp_lock->fl->fl_file == smb_lock->fl->fl_file &&
    6655 					    cmp_lock->start == smb_lock->start &&
    6656 					    cmp_lock->end == smb_lock->end &&
    6657 					    !lock_defer_pending(cmp_lock->fl)) {
    6658 						nolock = 0;
    6659 						list_del(&cmp_lock->flist);
    6660 						list_del(&cmp_lock->clist);
    6661 						spin_unlock(&conn->llist_lock);
    6662 						read_unlock(&conn_list_lock);
    6663 
    6664 						locks_free_lock(cmp_lock->fl);
    6665 						kfree(cmp_lock);
    6666 						goto out_check_cl;
    6667 					}
    6668 					continue;
    6669 				}
    6670 
    6671 				if (cmp_lock->fl->fl_file == smb_lock->fl->fl_file) {
    6672 					if (smb_lock->flags & SMB2_LOCKFLAG_SHARED)
    6673 						continue;
    6674 				} else {
    6675 					if (cmp_lock->flags & SMB2_LOCKFLAG_SHARED)
    6676 						continue;
    6677 				}
    6678 
    6679 				/* check zero byte lock range */
    6680 				if (cmp_lock->zero_len && !smb_lock->zero_len &&
    6681 				    cmp_lock->start > smb_lock->start &&
    6682 				    cmp_lock->start < smb_lock->end) {
    6683 					spin_unlock(&conn->llist_lock);
    6684 					read_unlock(&conn_list_lock);
    6685 					pr_err("previous lock conflict with zero byte lock range\n");
    6686 					rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
    6687 						goto out;
    6688 				}
    6689 
    6690 				if (smb_lock->zero_len && !cmp_lock->zero_len &&
    6691 				    smb_lock->start > cmp_lock->start &&
    6692 				    smb_lock->start < cmp_lock->end) {
    6693 					spin_unlock(&conn->llist_lock);
    6694 					read_unlock(&conn_list_lock);
    6695 					pr_err("current lock conflict with zero byte lock range\n");
    6696 					rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
    6697 						goto out;
    6698 				}
    6699 
    6700 				if (((cmp_lock->start <= smb_lock->start &&
    6701 				      cmp_lock->end > smb_lock->start) ||
    6702 				     (cmp_lock->start < smb_lock->end &&
    6703 				      cmp_lock->end >= smb_lock->end)) &&
    6704 				    !cmp_lock->zero_len && !smb_lock->zero_len) {
    6705 					spin_unlock(&conn->llist_lock);
    6706 					read_unlock(&conn_list_lock);
    6707 					pr_err("Not allow lock operation on exclusive lock range\n");
    6708 					rsp->hdr.Status =
    6709 						STATUS_LOCK_NOT_GRANTED;
    6710 					goto out;
    6711 				}
    6712 			}
    6713 			spin_unlock(&conn->llist_lock);
    6714 		}
    6715 		read_unlock(&conn_list_lock);
    6716 out_check_cl:
    6717 		if (smb_lock->fl->fl_type == F_UNLCK && nolock) {
    6718 			pr_err("Try to unlock nolocked range\n");
    6719 			rsp->hdr.Status = STATUS_RANGE_NOT_LOCKED;
    6720 			goto out;
    6721 		}
    6722 
    6723 no_check_cl:
    6724 		if (smb_lock->zero_len) {
    6725 			err = 0;
    6726 			goto skip;
    6727 		}
    6728 
    6729 		flock = smb_lock->fl;
    6730 		list_del(&smb_lock->llist);
    6731 retry:
    6732 		err = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
    6733 skip:
    6734 		if (flags & SMB2_LOCKFLAG_UNLOCK) {
    6735 			if (!err) {
    6736 				ksmbd_debug(SMB, "File unlocked\n");
    6737 			} else if (err == -ENOENT) {
    6738 				rsp->hdr.Status = STATUS_NOT_LOCKED;
    6739 				goto out;
    6740 			}
    6741 			locks_free_lock(flock);
    6742 			kfree(smb_lock);
    6743 		} else {
    6744 			if (err == FILE_LOCK_DEFERRED) {
    6745 				void **argv;
    6746 
    6747 				ksmbd_debug(SMB,
    6748 					    "would have to wait for getting lock\n");
    6749 				spin_lock(&work->conn->llist_lock);
    6750 				list_add_tail(&smb_lock->clist,
    6751 					      &work->conn->lock_list);
    6752 				spin_unlock(&work->conn->llist_lock);
    6753 				list_add(&smb_lock->llist, &rollback_list);
    6754 
    6755 				argv = kmalloc(sizeof(void *), GFP_KERNEL);
    6756 				if (!argv) {
    6757 					err = -ENOMEM;
    6758 					goto out;
    6759 				}
    6760 				argv[0] = flock;
    6761 
    6762 				err = setup_async_work(work,
    6763 						       smb2_remove_blocked_lock,
    6764 						       argv);
    6765 				if (err) {
    6766 					rsp->hdr.Status =
    6767 					   STATUS_INSUFFICIENT_RESOURCES;
    6768 					goto out;
    6769 				}
    6770 				spin_lock(&fp->f_lock);
    6771 				list_add(&work->fp_entry, &fp->blocked_works);
    6772 				spin_unlock(&fp->f_lock);
    6773 
    6774 				smb2_send_interim_resp(work, STATUS_PENDING);
    6775 
    6776 				ksmbd_vfs_posix_lock_wait(flock);
    6777 
    6778 				if (work->state != KSMBD_WORK_ACTIVE) {
    6779 					list_del(&smb_lock->llist);
    6780 					spin_lock(&work->conn->llist_lock);
    6781 					list_del(&smb_lock->clist);
    6782 					spin_unlock(&work->conn->llist_lock);
    6783 					locks_free_lock(flock);
    6784 
    6785 					if (work->state == KSMBD_WORK_CANCELLED) {
    6786 						spin_lock(&fp->f_lock);
    6787 						list_del(&work->fp_entry);
    6788 						spin_unlock(&fp->f_lock);
    6789 						rsp->hdr.Status =
    6790 							STATUS_CANCELLED;
    6791 						kfree(smb_lock);
    6792 						smb2_send_interim_resp(work,
    6793 								       STATUS_CANCELLED);
    6794 						work->send_no_response = 1;
    6795 						goto out;
    6796 					}
    6797 					init_smb2_rsp_hdr(work);
    6798 					smb2_set_err_rsp(work);
    6799 					rsp->hdr.Status =
    6800 						STATUS_RANGE_NOT_LOCKED;
    6801 					kfree(smb_lock);
    6802 					goto out2;
    6803 				}
    6804 
    6805 				list_del(&smb_lock->llist);
    6806 				spin_lock(&work->conn->llist_lock);
    6807 				list_del(&smb_lock->clist);
    6808 				spin_unlock(&work->conn->llist_lock);
    6809 
    6810 				spin_lock(&fp->f_lock);
    6811 				list_del(&work->fp_entry);
    6812 				spin_unlock(&fp->f_lock);
    6813 				goto retry;
    6814 			} else if (!err) {
    6815 				spin_lock(&work->conn->llist_lock);
    6816 				list_add_tail(&smb_lock->clist,
    6817 					      &work->conn->lock_list);
    6818 				list_add_tail(&smb_lock->flist,
    6819 					      &fp->lock_list);
    6820 				spin_unlock(&work->conn->llist_lock);
    6821 				list_add(&smb_lock->llist, &rollback_list);
    6822 				ksmbd_debug(SMB, "successful in taking lock\n");
    6823 			} else {
    6824 				rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
    6825 				goto out;
    6826 			}
    6827 		}
    6828 	}
    6829 
    6830 	if (atomic_read(&fp->f_ci->op_count) > 1)
    6831 		smb_break_all_oplock(work, fp);
    6832 
    6833 	rsp->StructureSize = cpu_to_le16(4);
    6834 	ksmbd_debug(SMB, "successful in taking lock\n");
    6835 	rsp->hdr.Status = STATUS_SUCCESS;
    6836 	rsp->Reserved = 0;
    6837 	inc_rfc1001_len(rsp, 4);
    6838 	ksmbd_fd_put(work, fp);
    6839 	return 0;
    6840 
    6841 out:
    6842 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
    6843 		locks_free_lock(smb_lock->fl);
    6844 		list_del(&smb_lock->llist);
    6845 		kfree(smb_lock);
    6846 	}
    6847 
    6848 	list_for_each_entry_safe(smb_lock, tmp, &rollback_list, llist) {
    6849 		struct file_lock *rlock = NULL;
    6850 		int rc;
    6851 
    6852 		rlock = smb_flock_init(filp);
    6853 		rlock->fl_type = F_UNLCK;
    6854 		rlock->fl_start = smb_lock->start;
    6855 		rlock->fl_end = smb_lock->end;
    6856 
    6857 		rc = vfs_lock_file(filp, 0, rlock, NULL);
    6858 		if (rc)
    6859 			pr_err("rollback unlock fail : %d\n", rc);
    6860 
    6861 		list_del(&smb_lock->llist);
    6862 		spin_lock(&work->conn->llist_lock);
    6863 		if (!list_empty(&smb_lock->flist))
    6864 			list_del(&smb_lock->flist);
    6865 		list_del(&smb_lock->clist);
    6866 		spin_unlock(&work->conn->llist_lock);
    6867 
    6868 		locks_free_lock(smb_lock->fl);
    6869 		locks_free_lock(rlock);
    6870 		kfree(smb_lock);
    6871 	}
    6872 out2:
    6873 	ksmbd_debug(SMB, "failed in taking lock(flags : %x)\n", flags);
    6874 	smb2_set_err_rsp(work);
    6875 	ksmbd_fd_put(work, fp);
    6876 	return err;
    6877 }

regards,
dan carpenter
