Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477C1C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 12:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CCCB6136A
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 12:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350101AbhI3M1L (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:27:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50198 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350096AbhI3M1K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Sep 2021 08:27:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UCL9cl009927;
        Thu, 30 Sep 2021 12:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=3cy71uPQGnsnZcWqcEpdFQnZBGdXwahyT/LFY5B/q3U=;
 b=I0RtoIVBIy2UKoxw7IfD6F++oVKQwMd9xBTLx2LSxD4oJdc8yhEyTY4/qTWrh9O+THb4
 M6D9PyLZ1TMvBX7cI6u15eWZdUQaES5z+awyEIA78JZqk/dtYimiExkNH1kqbSRaydIL
 JBgdJTjzJqqVPLhgtNntkfqN13bXD1ocy6KuPfPYR9O4yHC+RHS0v5yz5N51dLrUhx7n
 nPV4aMLrKuzAmisL9lbhZdPNqF5993eRcHD4o5n4g3laJlzzu/sgBrfMKIiyYKd3SSAR
 sGQGQKSMvbCFJlPBcbYiqK4dEE/qdYD4OGBWNTw97xY4SRFdqnTcgx+0+qxAcSQQzJSP Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bchepwp97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 12:25:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UCFmcA032655;
        Thu, 30 Sep 2021 12:25:13 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 3bceu6y4ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 12:25:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYItiRYRixdQvhs7y9psUs5q22IeFlNQhh6mkAKLSBA7tbyuEIGTqB06iCnIxK2Ep48MiR9G5+qMvgTjmQXXf88bo5zrEPseWfY+j37hY0AMr1RF6a6HB/5sja1OerIB6gY5i5pJntV6HSRAP/dzhKz8PkwfAIGcaeShtEpDzLBWU94Kp6qKWZsRbjvcBV4ntiuAHN5mMSbUHCsK7s6CD8P6+OVL0R7SHXDleM+mtEViaLensNY73R4Cg/aqb285Zwo9cKKoMGohoxw2K2qYXgUUrJNEXCjCKHm/Vu6HhCB0hsFadVi74rkv00MudsikpOlamEC0iUgAeOFD1A/eYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3cy71uPQGnsnZcWqcEpdFQnZBGdXwahyT/LFY5B/q3U=;
 b=V3yfpxNrK3hfFAJuU9sl1pzYTxTimQ6mLRb3aWDTRizZ3lMrjPiFeATCr5/ULgavXBK8qVjsq6hirO8lflXI6Fa6mFKrUro5EQVDqzQaiRcXnYXcpzQg3Ohihgughrq1Q/j9HWu49746A/TXz9FBwtubufubY9M2W2opILDY8IldNvWR+zuwv9l07pI08wrRQsAT3AXawpYvCjInRqnMyEYF2hEE4U24USJWH7NZgxjWGo+YRIRguadN9go6Z6UkFCSvPYlqdqUx2tBHJ+T6AzGYdxz95SfX0mRwnlQpCZt5i/1gsCo9SL4mlVWlt+xR98BaQ0vnI3IoKBfkpxNOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cy71uPQGnsnZcWqcEpdFQnZBGdXwahyT/LFY5B/q3U=;
 b=iSCCsv98DY8PkL5LVPTXVrN74nzAs5Vdi82nh8+P/T60xDwGT3pPyxzZATRPPw00JlA3ULRXVgGQVZgBvbh2kyHfMZJzVz5MS2azG6HCuVlUwhaUMlkmICUIXef016EkynreUKpC22yOftPir97CblBT+uxpnnM6alUNqaRISrg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1824.namprd10.prod.outlook.com
 (2603:10b6:300:10a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 12:25:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 12:25:11 +0000
Date:   Thu, 30 Sep 2021 15:24:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: missing check for NULL in convert_to_nt_pathname()
Message-ID: <20210930122456.GA10068@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (41.210.159.27) by ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Thu, 30 Sep 2021 12:25:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb0577d9-d0ab-4a98-514b-08d9840d5924
X-MS-TrafficTypeDiagnostic: MWHPR10MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB18249F21672C37B88D13B6DB8EAA9@MWHPR10MB1824.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FFEZOor1tZ0tBArveMTNY/6SYuJfVDqdPzuq/HkRxZlPeIuY2iQqDZJYiibosprzTbRgV0mZXjf+k5kXKvMsojYooTa7TitK0UAiDshHiEeUK+rPTL5gmjMmS5CtTwpQ3Dq7q7WEKbK0a6fBxbdm+3VjmWpN5aFGqjm0z+zMCHfJGUOJPose/kq1Zo8UZa6uQzxorLI/BrjdJLGuVI/4XG5X63Nv4ZJukv4dwVD5pSwHyJs7Eqh1tWvVQJEyrYjX1RZiaHOA8b2YuwJixyHFn4cP2DTa92Uwr9Wm186ayhnfxhNcX7pyyK1eHqK8EFVGP2kPMX0YBSf1MZspyX/JzFmX7gDoQw9DUX5VQMB2MgLRPpD9QcWioRRoxOh4Assjw3IMU4bMNDlxAd+DCXzPQWofApOxj+mhXH48cV6Bglt3GpOUgGTketiUMcUt0YBh7LlU7qdiOuKrJazUn03W2UU6SdzO5yuMyzflika1aow8lcoONkMmbg54k9quF3DujoXhak2PkGQ1+0sOoTnZtqu/j3Cg+KCyQo07Y1TThhQnw9rBr+IJxUffhFCGRNa+FMvMfYr8tZ5rg1H0tG6kYksmdLY8CDp6s7tn0QBH9Bb53GHcv6pSDemx70d59zLU131fVVPRit5OLwpAigSKKvRZMsxjUTAU49Qst9nnz6YLlfJHd6/dxEc9qS0+CF6STx+zQfTRt2tXX7CAiE7ZjhysSJXybm+z1teT38+x4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9576002)(83380400001)(110136005)(54906003)(6666004)(8936002)(316002)(508600001)(1076003)(8676002)(4326008)(66556008)(66476007)(52116002)(66946007)(6496006)(5001810100001)(5660300002)(44832011)(33716001)(9686003)(186003)(26005)(55016002)(2906002)(33656002)(86362001)(38100700002)(38350700002)(956004)(5716013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oLmUlQmZSjY1vCdN18O/4AWjZM3jnDoVrlWPe4QKnRILMAwck1q+Kpa9VDPp?=
 =?us-ascii?Q?1b29zzM+Dj/oGAIXGbx/FgN76H7DJgfF8yVqBX1PF+hlv45ULCm2GY0N9CCW?=
 =?us-ascii?Q?mNWZLpxwLsEnkdeIyREIEA7FyhW+L8pEzk79i7rNC0AqkxwlyTqAlG1DoHCS?=
 =?us-ascii?Q?s4oH95632Y+gXt4N2Pu8RW+eIyJjCyr0w/7LgxnlyLK+JF9lFRiq0db3vZkW?=
 =?us-ascii?Q?l7cJzerWanoypyACLzwLpJY8HkNFtNEeviV6FMuL4PIByvxrexMvPpdVuJk3?=
 =?us-ascii?Q?lK94ZAltqWf6vtaWOtGpx3X0J1bjsAToL4r8VcQ84TWls5UWJwDyP48MVAGl?=
 =?us-ascii?Q?7Y4Ikaazh/aiTxix0cUKjSCPssgdCaJXTKPZGnjZFgUTZSD+y8KsJabd+YqK?=
 =?us-ascii?Q?KHmcBfRpUXrVTYpzyYkJMhnXnrpBRRQ3UFcVJ9qDDoANcqopZlnhZQrbPDjB?=
 =?us-ascii?Q?veUPc3oXQ08DSxCaWTtRwDe6n/ctXP2P8Rtg8alYCZal1mvwtKIA3J55dcKg?=
 =?us-ascii?Q?GDHBYNVmCWHNnG6bbx9VBGHRcUDLpUtdlRdFpFvayCYK4Di6dKmMUjdZmhcH?=
 =?us-ascii?Q?pM+bkAOZSzSAtv8YZ2fL08zK0xgfQIiewVzbEogtI3ycZ0UjTUalAb+xSoaH?=
 =?us-ascii?Q?Fq039oER+XdRPwRSP1qD2tFGFlOVua0Bg6g6vM6LFCJcCPFSHAZisLzwfLSt?=
 =?us-ascii?Q?akEUK75k6gxBo8oSrENuIGGPuaFf8iSJB5Ll3xqwEsFuBQgO6YuYN071790z?=
 =?us-ascii?Q?kidgiRuel39bB8oLalaq5bndssqZWeqaEEinKBUMDkORiXbho0AIR0NMX9cN?=
 =?us-ascii?Q?m+Ynen1+tld+cbrgYFf4OcWQnhoY9DeuT0/3aqrD5Y6vbLLlZYTbcEqucWfo?=
 =?us-ascii?Q?az6X8Lvsb2abPKC8X+8AZY+RTDyWFp8NtqtpgsXqoYvRnLp4VMqJfp+CUx8k?=
 =?us-ascii?Q?mFlDd63frz8rYovEwIAH1qde2EybnbH2NMLYveDLVaeXjQzpxoXhdrSCwB4F?=
 =?us-ascii?Q?PrBNoJgrvud3+2EsJrsSAs7r5D3ZINYq0+kbAMFA9GuZiIj9aP1CVMcY1PkC?=
 =?us-ascii?Q?L4flFljU1cKHeqRELGq2fDTbhLAoDoF/ftZdRXp9Ymu1iUq95LyUJshitJJ7?=
 =?us-ascii?Q?uOINF3wjvBG69mavF6mXWMuX6VHq7/hQtJRzFYfbVigA7HzH/8q93J77KFd1?=
 =?us-ascii?Q?ArqPB6SI3xHz3vF6hsXeNJRixzfzDogM0OzDclvuyP2uAEFkIBddx85unraR?=
 =?us-ascii?Q?4lOp89cuHPKkmM9HIJpLDvZvYYCJX1vCRoHS8tXCu1FWG26cziThGh6jxxUZ?=
 =?us-ascii?Q?KCBnlwmIqoppsrlPbi5mGgkK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0577d9-d0ab-4a98-514b-08d9840d5924
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 12:25:11.5908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aznPoZH2wnfr79wCtlAmxGq4swTZVjQWdeamztB2UAhjMxjeLIgJ0QZ8pqaMXEdXlbUnh8aQn9XVScd9FDB8NZXRR3aJ7LQe0jDfRgm9kJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1824
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300078
X-Proofpoint-ORIG-GUID: nV6cYASdkM9fQQ5h0UOn8iG57FBwcx_F
X-Proofpoint-GUID: nV6cYASdkM9fQQ5h0UOn8iG57FBwcx_F
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The kmalloc() does not have a NULL check.  This code can be re-written
slightly cleaner to just use the kstrdup().

Fixes: 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of share access")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/misc.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
index 6a19f4bc692d..60e7ac62c917 100644
--- a/fs/ksmbd/misc.c
+++ b/fs/ksmbd/misc.c
@@ -162,17 +162,14 @@ char *convert_to_nt_pathname(char *filename)
 {
 	char *ab_pathname;
 
-	if (strlen(filename) == 0) {
-		ab_pathname = kmalloc(2, GFP_KERNEL);
-		ab_pathname[0] = '\\';
-		ab_pathname[1] = '\0';
-	} else {
-		ab_pathname = kstrdup(filename, GFP_KERNEL);
-		if (!ab_pathname)
-			return NULL;
+	if (strlen(filename) == 0)
+		filename = "\\";
 
-		ksmbd_conv_path_to_windows(ab_pathname);
-	}
+	ab_pathname = kstrdup(filename, GFP_KERNEL);
+	if (!ab_pathname)
+		return NULL;
+
+	ksmbd_conv_path_to_windows(ab_pathname);
 	return ab_pathname;
 }
 
-- 
2.20.1

