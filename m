Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377B3C07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 10:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1547361C9A
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 10:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhGGKS4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 06:18:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64176 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231137AbhGGKS4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 06:18:56 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167A6FSZ018833;
        Wed, 7 Jul 2021 10:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=69AVrFlA0p7Ld1tGlqg8tRYVshAVghpG1eimPH6BkWs=;
 b=XPbS5Z1zQb9DhrbMFAyFJ4uUFRlZBtdXWOVJgxqo1KotGJOqYeG9kO5ATCZNn9ZY0dBB
 vor21VClraUq2CF2pf60OsSXx2h8UYN65HWEi3K8o2hoAOPY8JghudiKKQulHTgXrt5I
 1VTAWf2UTYJdtb60HULvwneqgnpaa3iu6Hc5G1u4ADX4pZW+mzwycKR8BFB2DpIgfX3/
 PAz2yUC/wV7DC1n7P7bn5SKmKxUo2PP3nc70ex8PfhPiyED0HKFtl7yEcfM76KdTGieY
 r/P323CmAw5Yy1+QZKFCp238GbWH28Moeqf6Cyn5jAWTSvJf6pH+gs+KbMnfAhLhW4lF Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m3mhbrvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:15:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167AAWn7034453;
        Wed, 7 Jul 2021 10:15:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3030.oracle.com with ESMTP id 39jdxjwfdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:15:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUS1kODeJRIBcc21yij7XVDY7BZ8dG/Qm5v28r5ZQ3yn3tMKafaCWf9nsGQyRx3weJqYtimWXEYb/mZibUwNiyby6T2WaYez8bcniMCzZBXOWp6y7rDOeoP4n4VJRYZ9pveBP2U4ec06tGWicVWyd0wWgAwZr6CK4zI/DQHqL2XJk8QZeDOtuJxR0WMONftWkyZyXS2FglROwaZ8rJJSL2lbVvZ100NELRTfvJlWBmEiVqSyzh6i9mwdUxipHFxumBxGayM7VbOMrmhRpwD0BvZKxgbQFOhD6XNlgYD9MdgSA9QUheW1X6Ft/M7XqO/PbjVhZrEjrjQkqtVVL0GmHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69AVrFlA0p7Ld1tGlqg8tRYVshAVghpG1eimPH6BkWs=;
 b=nPNA4koQVCXpGRZjIWP/gGpnkqSEq35wYtEaFJ3ewLkLl2C/kp9LiuDJSYCQZCZwpQhDCG4oq3exd8p8pWpZmgNHYAorgKTXa2HHuhlvLusxIfRA97pNfuzJRMcMiE3xGCgVzLOeqmSKLhwdkRPBxFAcr5++4g/lfdHrRMwgEZN/HtypQJomgwGX+sC/gmRoIdW3SBQf9e16TQ2RcrD9jtj9tZnKizbEcTtGkwgjZkwVj7Bozu+jjFOt9s0iwN8oU/c6Sc8wC224QiiU5hW6JEQB7vItocBzHs+v5n3Uahaafc5UgrRViSjROcUdNoLdQY0sO9jYJIipgQRExAxCmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69AVrFlA0p7Ld1tGlqg8tRYVshAVghpG1eimPH6BkWs=;
 b=p4ACZxTKbnY5xdAKS+LbzoNzai1x3LW3qvj/lglQRmbXXqE5avDL8YYFUN6NItbqoliHYJVIHT53uGjV206J05R9t0y9RPoyA2u1PfMQklJumJga0nzkhVqlIQcopFVupUmrIA4JcZsBV0T9WN8ibjMRAeWaMs74j1f9qiX2aK8=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5425.namprd10.prod.outlook.com
 (2603:10b6:5:35f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Wed, 7 Jul
 2021 10:15:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 10:15:52 +0000
Date:   Wed, 7 Jul 2021 13:15:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: use kasprintf() in ksmbd_vfs_xattr_stream_name()
Message-ID: <YOV+xDbnpDrR/Ipj@mwanda>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: JNAP275CA0040.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mwanda (102.222.70.252) by JNAP275CA0040.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Wed, 7 Jul 2021 10:15:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9431d4d2-6d69-473c-9f49-08d9413032f3
X-MS-TrafficTypeDiagnostic: CO6PR10MB5425:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB54253B14A514D0787400190F8E1A9@CO6PR10MB5425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:132;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2O5R64qhVYkFOM+SLmqS4zpzr68GK7Ioq9cXlJefAtMJLstW4U7vFbIaDnmKdQpGeRmojYYlSeaP6i7wxvl+hSxX3mCYVbVosW0C4A60XpP6m671mTANQ6KhEjdpP53uNtR/t/O9cQvBdd3MYzmLXDiP60Zihn5PVNAU4Ltv4zqV4aiBSUGTHglYwal2+68wFqNHy6OL6ymKWAvJaPmJ8xiMgVPwJJ3d2Z86oxM0ywEoXDIJks70/tvvK0IUYn7aVv386KG1iBMMDwrG/WwEICF3T3vxT1u5jh6/AgCst+FtALjSqAE78FmlaakeSsjOQrbyIsI5M3nHpsP6A42son41Xy1cvMKDPk/AWb0SmA1EwAjuex+w1P/I1IqDg133zqP8Wf2rpSCleRjK0D4I5Qi/dk1gDE9w6RqkN0zazDzUfLIG7BLsC8rUnlZAtBUvNS8JRYMkV3jZMmBRsYqvdeqv7WUuNO+bFCBw1OlMME7Y+kaADE8mkOy9Zi/w2PIUXcrYKglTK98CXe8kQ0yMD3MiuPPI6sIoEzHpz98xIZ9mhvX61k6tdCLGoWOvXp7DzkZCDwNJorhFoTItTNHIcjEjuNKy6/moriRetINkNIXcuYn6iealDHHE8DrKGvEjdGLc2uVBLO5UJt/ocKJbsxBUEjw2N2/Ha1Pd455/KkkLQQLxtdVqHgMQwDZ4XLwsJcW4tHO8G+TMkbSkup8KNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(396003)(346002)(52116002)(55016002)(9686003)(66556008)(38350700002)(6666004)(8936002)(66476007)(54906003)(8676002)(956004)(38100700002)(44832011)(66946007)(6496006)(6916009)(186003)(5660300002)(83380400001)(4326008)(33716001)(86362001)(2906002)(9576002)(316002)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?susbtHiXJ/tUzoOhLCqHJ8GRkvLV2l4qq0TkrGg9XguTLAYI1GncLZGW6NAR?=
 =?us-ascii?Q?fKrC/BlqMUyiSPuFV8AeKhCVWpYts93JwM3/p0NRcj4vxOfeBo9G0MCx6QRo?=
 =?us-ascii?Q?a/5VJu4Hh8useryWoHCfkC4UNhShtQfAYGsVK9dYR/KQffqpMzPWHAnewBbV?=
 =?us-ascii?Q?xkt8RuvSg+7cFVWtU8pBUY3RYjHWaq/ZYTCjMFCwt78MX9t8iN/Fzya3ob9b?=
 =?us-ascii?Q?730g6JtpSr/me9snIg7VPq94yFcHaf5V97KaP4sE/Ywxw12XwdxAuVngKa7n?=
 =?us-ascii?Q?TO1D4PDEJ6xBcEpOi7Ab3zj/sgk2pa4TNNCcbiCnyMLPuqpSe7y0K6QCKjXG?=
 =?us-ascii?Q?a109FsT5Bxxcgp/IlkVhjk5wtQpNXxdxh1rx0HtDSVhfUOyYKWWBfA6NbSuT?=
 =?us-ascii?Q?h3yGkGsQ4k3QDlNgaSZQT1aeB331bZrT1dUPAPHOIz7wrnbznLgSvkAiXGzt?=
 =?us-ascii?Q?P2PLzOIB+HVPyyq3V7jJvVQ4vX/qGyUH7jKP/9EBatEHw2edeB/VH6yFVNEx?=
 =?us-ascii?Q?BCc0eRzmM66mtBARWUfUpyMWvcJHvmzMxXyojZGRfVuTmfD8E5jNfG5c8uan?=
 =?us-ascii?Q?wJPaNpv34qXtA3ox7Gin5VIPjbsyUKWuRWUN2JGmE1Lo7dB0Kk++LSgnwXp9?=
 =?us-ascii?Q?tKsnEeD+n6FaXnOVHESa9noQ1L4W0nCkt0P1WKYm8KZare/80DWCgV8R0SOC?=
 =?us-ascii?Q?48NnwjXEP83foyzo+G6XZ187+53hWJpoqtu/IfejkLVhaxrudHVSOUIQHrfA?=
 =?us-ascii?Q?le8R6FZNsQXVIqsYSy5A6mizzljQB7yOXRHOE1mx7E2G1KLOg888hdk4zx9i?=
 =?us-ascii?Q?A4fNl3qYXfG/nR645gxysBvIItl/T+/HPYYkftr+StOUBiN5Z40CE0ZwcnbA?=
 =?us-ascii?Q?I+U8BaewVnx9okjIf6IysWLxnstF0T6hXQURQxLvuoPVKHTFINsjitFB7tmg?=
 =?us-ascii?Q?ht5nruTstQHVJRxRdxnzSqtJxq458XDFGeOGhvr27o4aOhIBbr6ylnS+ukRr?=
 =?us-ascii?Q?Nh3HPRosUiNrSs7wLyhxQ9/Jnv5jv3qAyJDVXoN+pzkGElyu/vln5wMHWEFx?=
 =?us-ascii?Q?kH2Uo2N7jiMpUNj3pGqucbgD/dMMTxQBupCUcdxOTThk7DUbR7h38ifjuy7q?=
 =?us-ascii?Q?R4K8uPIWeD/KqMlpjmHPYW/gCYyY0vLMEM9Ze+E/bySWOuxsjKe8R8cZ75zI?=
 =?us-ascii?Q?P5ZftkTWU2XnckhDkdPgTD7FHGMzDb7h1swf1pNcPDiR8K4RsTdRn+/NojJk?=
 =?us-ascii?Q?9plFC6N1lz0YiC4Xzy+RtpYyY3dp8dyd93oF5yNbktIKQyRrudYhH0Txm7bD?=
 =?us-ascii?Q?ZDUudi2CMDWovF3F6hPxdgyP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9431d4d2-6d69-473c-9f49-08d9413032f3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 10:15:52.0577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynmo4iYyaU4Qjc0HlKvlKZMxO9e/dAK0302WKpopP9ErlR2B4ovhdgsutIukbhWHcqeFDXJNrSXx1smWsllGUuqHrnIWAl5k8PRq3/cafEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070060
X-Proofpoint-GUID: nZKjU7POIiYzeLDExmn0Jxj4Mtwdz3pD
X-Proofpoint-ORIG-GUID: nZKjU7POIiYzeLDExmn0Jxj4Mtwdz3pD
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Simplify the code by using kasprintf().  This also silences a Smatch
warning:

    fs/ksmbd/vfs.c:1725 ksmbd_vfs_xattr_stream_name()
    warn: inconsistent indenting

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested.

 fs/ksmbd/vfs.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 0f5a4fb8215f..d3bab9235e9a 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1697,35 +1697,20 @@ ssize_t ksmbd_vfs_casexattr_len(struct user_namespace *user_ns,
 int ksmbd_vfs_xattr_stream_name(char *stream_name, char **xattr_stream_name,
 				size_t *xattr_stream_name_size, int s_type)
 {
-	int stream_name_size;
-	char *xattr_stream_name_buf;
-	char *type;
-	int type_len;
+	char *type, *buf;
 
 	if (s_type == DIR_STREAM)
 		type = ":$INDEX_ALLOCATION";
 	else
 		type = ":$DATA";
 
-	type_len = strlen(type);
-	stream_name_size = strlen(stream_name);
-	*xattr_stream_name_size = stream_name_size + XATTR_NAME_STREAM_LEN + 1;
-	xattr_stream_name_buf = kmalloc(*xattr_stream_name_size + type_len,
-					GFP_KERNEL);
-	if (!xattr_stream_name_buf)
+	buf = kasprintf(GFP_KERNEL, "%s%s%s",
+			XATTR_NAME_STREAM, stream_name,	type);
+	if (!buf)
 		return -ENOMEM;
 
-	memcpy(xattr_stream_name_buf, XATTR_NAME_STREAM, XATTR_NAME_STREAM_LEN);
-
-	if (stream_name_size) {
-		memcpy(&xattr_stream_name_buf[XATTR_NAME_STREAM_LEN],
-		       stream_name, stream_name_size);
-	}
-	memcpy(&xattr_stream_name_buf[*xattr_stream_name_size - 1], type, type_len);
-		*xattr_stream_name_size += type_len;
-
-	xattr_stream_name_buf[*xattr_stream_name_size - 1] = '\0';
-	*xattr_stream_name = xattr_stream_name_buf;
+	*xattr_stream_name = buf;
+	*xattr_stream_name_size = strlen(buf) + 1;
 
 	return 0;
 }
-- 
2.30.2

