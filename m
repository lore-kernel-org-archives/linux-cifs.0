Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9072DC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Nov 2021 12:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhK3MzJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 07:55:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29204 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232694AbhK3Myv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 30 Nov 2021 07:54:51 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUBdLlL000940;
        Tue, 30 Nov 2021 12:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=LFEx4FIIf055Ims/JaLkDKWeSCZ1ZNatFhG6KP0Skks=;
 b=RA3KU1h+euioxvhHyTeQ+jG0Yf97Fr85UWjfvuchvlxH1n8FluFpzg6Se/U7GoB3H4Ax
 6mSWsqnpa1J78N+a+/6bcHC9k1lXegaW9/yIsMzk9twCntsCm5KjyObABZlCd96i3L/v
 +CdFD+dTx4jlrLbqjUzQqiD7hDzIkTJ0D1lDBC9tG++OdAiNV0bFN4lytddzY750VJs+
 uLcH8IN66g7goMTbBsqm8HYpWGTWzRZ9SxNlSaSLE90Rx6Toprz2ZltfpAlWOaFacYw+
 23N+fpKH8bXpOraFtHIx2nDFX6J5BE8axAHLCFBmhCfryo0Mg3SDFS4cjtUJxzpX5v5c CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmrt81ddk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 12:51:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AUCjcKr195877;
        Tue, 30 Nov 2021 12:51:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by aserp3030.oracle.com with ESMTP id 3ckaqek8fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 12:51:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bg2GbDYoRGSkGDFwxA/S6kLanUT/6dRNU9rOjyU+bYayJjiwhDLCwv7lNV4tX/RwL0TrRK+n5YYRfl6Bm75D8fQyjd0QEFU4nRIHLqvl8rnB/VbYLvWstuhK+ci4iRV9tQybDOYYpJGYNgzJTeq6CaAjieMagfqWM6G5cAH3H4z1rV8f4SfnOsEfGcjSeXfrG/ehilRoFoSZSC2feqUoL68CP5OxP94q15WzwQMmmgMistfEY7W0+Tqhw+crh3lgamGHfcXmRVMVEqojHfpdqMmly8jiRlpI/ukNhjvXIF1igG7LBHdyBw1stPU9Zk/SqUqE/DtjpWJTSz/AC4dN8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFEx4FIIf055Ims/JaLkDKWeSCZ1ZNatFhG6KP0Skks=;
 b=ETKL5TCbCfj/jsoWK1hDRHsiXOzmNFrhShBeF9yjVZkULAYfyG1OTwzSJYgWU1E1MNXPrnBvt8D49GiJ0oNSWeVYil7Z8xd8sRYL8EctQqt1eb1YdsWENN8q0dOTZgnHQwtP5yT8hBgkV+tW4+gCF9EqbscIfc8cp6BtGOrhLinXDRjU79OfJ+8StkU2LF0fga50vSVhUTom3gbFZG3yHz1lRi5aoZn7k2Kzu1q5C8UZ/5SB7oS4kGKYi3U6vtLqBztQFcTIgz46Fnmzt4bPW5PWzKgtiFNf6dwe93VYzEfT6MJ8jpEmTDOMP0pbeAz5RuiHZNPnbJWweGgntKAhKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFEx4FIIf055Ims/JaLkDKWeSCZ1ZNatFhG6KP0Skks=;
 b=RE115cW/uz3GKvbwdRq36YRLfcVVzhU1GK5jzwBuFsSKU1KFH3s813Rc2J5KqC0LRm4BVw3XD+Pt1vvOJJFFFAHkynytKxxsZWSQ2MmP0rwEmUjVU8doFgRu6dSuqEI1T1Sav4zugEV+vXxdJXM/7uj9UZUb4zj00T3xLrpluFc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2367.namprd10.prod.outlook.com
 (2603:10b6:301:30::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Tue, 30 Nov
 2021 12:51:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 12:51:12 +0000
Date:   Tue, 30 Nov 2021 15:50:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: fix error code in ndr_read_int32()
Message-ID: <20211130125047.GA24578@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::24) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 12:51:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e4740f0-3ff7-4239-8040-08d9b40016a3
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2367:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB236734FEE1E48E3C16E019108E679@MWHPR1001MB2367.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kwPG1oRt+IRU09q5GYB9mQsC/1/JHUl9N+yx8wlg75LnsmSKWFOYTdAdLjYzf/oqcivTS3ab6Z6NeRBRNJrCL46z7r4Wh68sn4A01Rox5KeBx1DM59FPH1sZrTfvk8Qzq/4OfBxLNXfP29hBEHuyZm5GDYl8sIWI3hl2Ehw02sZKxiD/MwcpXmUKJQ0yXQ7ze5tgnPPCQVW3rxokgpHiA30WJNp/xxIeClAd1SdE6E1QFFS2rOH6tX6CPjywDUz6mItpxlXez35juina81/Pp/EkPbURZJDDoPORmzJOhvCPmbTAtc5yExFYo+Z7f60tg0701KFFQ4yJcyBpAuaJAZKCNcDOvOZERbalsF89xomVs3UvJYgidIiO2UriLF3cPwEu06VEATvR6+0mWKxsvj2DRZTaIYmy9vFYlSPXZJruJoO+OjsNtqj4HOLxPZoTlo8t49gyPRKxOKY4GQEaiuT0qrc6vHSkTHlPJ7ng9ohyWLTJdEaFIB3jDbicVj0LjPOcZtA1SoLCT2zHvBSToY0Opb4x2IShXF1ITTnSKP33UlA+vZCHDvJ0rNvLB0PnkK7itnvXaBYXwx58hiXMVqhL7qoU44eBO+1z9ZMk4GBkExmRNiQKbWRBn7RkHQw6UXE1ArADYhPrU6Cl3sfu6q6Y3QnvisBtjmZ1mes8JZgAYGgIgaL0hBtc5ZjiQB+YsodTVteEMYhg/R82/a74Tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(4326008)(5660300002)(6916009)(55016003)(33656002)(186003)(6666004)(8936002)(9576002)(54906003)(9686003)(6496006)(8676002)(4744005)(316002)(66946007)(66476007)(66556008)(956004)(83380400001)(1076003)(26005)(86362001)(2906002)(38100700002)(38350700002)(52116002)(508600001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?52iaLoF5mlJnHINaAlu2OtwvON+VVuvemCZoK1/Z4Mxrfnoju2v17EkIotnn?=
 =?us-ascii?Q?daKhP93AkVq6Z/5uatVnIg1K1LVuOM0OG8uzBIAzbp8E354At0lJiY4jgYu9?=
 =?us-ascii?Q?S97To6gV1nvn0PnBUeI/1CUjVhD38oeXd4xPMeopO04T9WfXKtG6AXC/ZaUo?=
 =?us-ascii?Q?gbsHIkV1p9k4jeP1DoUMKmmQlni/jJxArQNoA1hOfTzl6x8Q1d/Ub3jXMrZQ?=
 =?us-ascii?Q?7M9f80ZUNS/ZrcDufYmDls9qwG2XjAt7Mz/0PeBxLES+WEwUY/8ozArL3q7f?=
 =?us-ascii?Q?RTKt0EaC294qBozTPeYGGqP8oqwwZsP2QWQuuH+iLwff9KrQuKLvHDsO38+g?=
 =?us-ascii?Q?X/FMCuovfOrgRQacZQbuLAXw2a379VXUBcAF86hDoF+UNX0OB0DIpZqsAQzY?=
 =?us-ascii?Q?Roa6Qap3i2Fin1zi+KxFPPV04u/l4fbF9Rbf9tuu4LWpaonKFI/KxMVc3U0Y?=
 =?us-ascii?Q?Efn2EbuZw9MCjpa8SwjxN20jXT5D5qbBiCewlPMF2q6QqQBSfMSOrUkfO4UJ?=
 =?us-ascii?Q?HXKXzmdFEAuMYLEjHwBaULRtWdjqT9SA3NUGMl9mh5bdIqMiXiATdOUgM39U?=
 =?us-ascii?Q?1x7UpT5AkVeTKb6yBsIWTOLpYHRhmid64MCZUJGnQkBZolHtlUmMPWwXt/lu?=
 =?us-ascii?Q?4WjR4DozESvnQmHF39dsI4Lv1ZnkyR/UQ2WhVJ0jyADGzym00EJRbHJ4ZO4G?=
 =?us-ascii?Q?Sa7dG2ZR90haljQeZyOqSuCuiRbxhK9wWnLRzD8ZjsigOdh4JNxyS7PZR14G?=
 =?us-ascii?Q?vlhPc9eoUTV8yWTXmuM6hZAAKE3DokURh+8KfHKHsQ+J1exosj5izjnv2/cT?=
 =?us-ascii?Q?s2RGMA2bw3dD8l+yg7Nj9/ZpQ1Suu5Av4qOh6TTeB7NLjp1IWlpa04EVEWbA?=
 =?us-ascii?Q?rzvt0wYCXm/WM7q2M9HIhf5feng2qnral7ENhaJ/y67fQABkrEE4nFW5uGDe?=
 =?us-ascii?Q?6oLnEqpQuueqZmQHkIt7ItST5HcJ87l9Lg8FZw7l9ZnNzivUZjIwQT4fnHRF?=
 =?us-ascii?Q?z8/vLDc0SPpWmBOG49Yp2xgSCZFy3Oh3Jx5JFQfkGi87pmGhMdicMzSkJZBm?=
 =?us-ascii?Q?jj5XSr6k1teSZomuOg7L+XWXIGhoB+q5w2GrspREKNUSHEfQxFGLxMSoXjb1?=
 =?us-ascii?Q?pbj2bY+avnURCTTKJKDJAPO27cq0FvRJ82jxjLN4y9t0mZ0g6Qlee5QtzqJd?=
 =?us-ascii?Q?M+WgMPN3ZAqWo9D/T61rHxgGRuNmomQ0YIIwCd4KhUDTvVC5p1oj27BG+185?=
 =?us-ascii?Q?5NWqUlqkyyFbPJwAzGuNITprg25G4k/Lkie5ymqPSSCg+5Tw5lATDff2cKon?=
 =?us-ascii?Q?jf2TAS9KqC5HDWa7FM5C/KhJZ2RyuW8UtXtvgXKUWnLYxGnYRSUkx55hCU5S?=
 =?us-ascii?Q?khi/s2ERjYYTOtKRYUk4WZ+Tzur5ysAspi3fOIQw5oGCRu0QWJALbaCL2D+G?=
 =?us-ascii?Q?zBnL81FNCXRxo1sHJl8d7PDeti3241gev7So9SRV2SVPOxHR+sWYynbPpUko?=
 =?us-ascii?Q?RHc9Gnh7td5rzE2WWihzJLa4xK8IKnjTO0WXYuoeDl9QykzGZN/ivlNJ00Fm?=
 =?us-ascii?Q?FroRZKt3URrC0nexJ6Esl7e84CN6Ee2Idr5j623jcARxslYcUY1yjK8xnIOH?=
 =?us-ascii?Q?fkPZ5/89Ilg2JwyHVns1JHc57qYId4EDm5A6qYNqQ/30r7uLrUL7E4asiDY3?=
 =?us-ascii?Q?8QkX6nwG7hg8pUBA2QZCYSdL0e8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4740f0-3ff7-4239-8040-08d9b40016a3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 12:51:12.3498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHzVOuUMMQhfOOavuF2jOE9H7pYOHe7nGCBDp3OdXwEIKYO4UruBQ2UHjeZE8XNOfuRZTSwE/dxR4uLvxDbsW5AI1Gyly+e8rkRXTjpql0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2367
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300073
X-Proofpoint-ORIG-GUID: KCGEbaAtnDmnyvIBHtGRj5BnxLgFCbLZ
X-Proofpoint-GUID: KCGEbaAtnDmnyvIBHtGRj5BnxLgFCbLZ
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a failure path and it should return -EINVAL instead of success.
Otherwise it could result in the caller using uninitialized memory.

Fixes: 303fff2b8c77 ("ksmbd: add validation for ndr read/write functions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/ndr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/ndr.c b/fs/ksmbd/ndr.c
index 8317f7ca402b..5052be9261d9 100644
--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -148,7 +148,7 @@ static int ndr_read_int16(struct ndr *n, __u16 *value)
 static int ndr_read_int32(struct ndr *n, __u32 *value)
 {
 	if (n->offset + sizeof(__u32) > n->length)
-		return 0;
+		return -EINVAL;
 
 	if (value)
 		*value = le32_to_cpu(*(__le32 *)ndr_get_field(n));
-- 
2.20.1

