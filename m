Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7714FC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 07:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EA446109D
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 07:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhIGHfP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 03:35:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53158 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhIGHfP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 03:35:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1876HKtL017560;
        Tue, 7 Sep 2021 07:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=OnbxRMxo5wyfyBQMBKlACgi9racjqbSbjQI4RcItxrA=;
 b=RQTdUWuXxp0AKOI8nb051Keu1mQTEad24GYd3OvbK3fNc3G35ykIqlcBBlAcZRaVV6/1
 C9iRN7/isHAQX/IHkzNw2qtT99U+hTJj6VBvj/Si8J6RP6bwwg41aj0/UR3zhxr49Ltj
 7v13Y+YPncM3y3X1ecZUco7Au0TRuQI/dmlH0hwsOTPo8d8Gq34QsSVeRoBj3hllUrBF
 5xEByJOrppWCrp9Ay0dvcc8FjifTowungEOTbXXoWJPOzIv04WCUS/KtMz42SAHuYAIa
 c6J1WcgAE/bF2JFRHEwBIKZWczyjLwsUSs7lqTESj7P7y6W0R+oyVp6S1dgYkPcQcPB6 cQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=OnbxRMxo5wyfyBQMBKlACgi9racjqbSbjQI4RcItxrA=;
 b=vjUxBvNx2qf/l3kA0pji2HcjyyiPiQ2+aRvx93yBCD/rXh6fCtf+p0KruGc4QnSguiDk
 2yKLJnxfgGrkICA9JG+e1e0eCSsQvFM11qU0WHrSSWm+sD6mgraxou3EfjFQjGLJpbjv
 W88nFg14eLFfRPUasT3ddIy2xM2ge2XcCQLewcyfRVRS7lbgzlFsRHDLP+CY/OTcp1IT
 Gwm+rwJtqleyOGJmM+GSiPR5im/mQ0Eu+mAjpB3j1FOvG5gG/G/zLP3SFcYaiChi5w89
 CxuoRLI7GKUNC/5mBo0s4TQ0uQPxl5/cVQmyluD7V3uzeOzPg+cOhVKPKKJOvnyTC6By iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3awq29gxkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 07:33:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1877UlRa120281;
        Tue, 7 Sep 2021 07:33:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by userp3030.oracle.com with ESMTP id 3auwwwdkr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 07:33:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQkQmxa1QInn9jmHqOc4z/DjPMztZC7IqD6b4rGhlpUxX2oL4wYvgw6AgRmbuNaYm2UXyaNdaljAAX0KGDX5PyFRapo6DHq+iAp1bZB29w6Uhpj5Orcypvfr82GbS6+to+uNUCCzxH0pz7pULZZD8Y26d4/LtgdtnxtGHq5GSGwXKuEl+1NGcVAZimHoI+63I75LaHReft//JfP39TDPj8cDiLCLaL6w7VYMD/vZiTEpy9r18CDY3F97f5kJZeiPn5NKSvGAeYjOaU8exOVkJaCXDBYDEAGyuaMRR0KwFSQcC7RG5f7srIOO0chMI1Y8omXC1Iibyvrm/3/2v4X5xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OnbxRMxo5wyfyBQMBKlACgi9racjqbSbjQI4RcItxrA=;
 b=EL2/LkIjutLc+yxv9EDmESzJQGkjcjIgzQ8e54YzANav6X3XOwEFBxAVXvKEc4Enfc7iX1aErgBsOzezQA+2WiAd2P2ax/h0Z8TR8IzTnan++n9LgZm0V0pLwvSnIgO3IICoNEn1CffJ6ql5VYByO24mQ5/Pukg79IOMrgX5n7bREW6T8F0vAdaiRGRcm+E17sD+Sac2b7RCvsFXbsnqjDlR/PUVi8VRfTz38qLaCW7y9RUIbOOwNslQhH02QInzC1KKaVn7S2Eko16IK1Z5U7g29awQDNaWkzAtqy4F9pFTlLCORKOl2mDBOEPLKjJ8Ej9mb9Zfki/zPOtLiPHqig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnbxRMxo5wyfyBQMBKlACgi9racjqbSbjQI4RcItxrA=;
 b=q7mguQK9bzIqzdziUOYFOxNEoXCcG9qtE7s9mBTcdW84b2koe+dU97/vgZB8/ZSt5bgULxpqtOsNqDCnm58cPOSxZVfNvCB6QULB2pdBjaHuKIv7i3f0nkpUxGcMJ3ciTOF+Dw6PsoDWnTCuAzJFdIr4GAtur3W8OzCGIGAFJdE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1775.namprd10.prod.outlook.com
 (2603:10b6:301:a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Tue, 7 Sep
 2021 07:33:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 07:33:47 +0000
Date:   Tue, 7 Sep 2021 10:33:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: potential uninitialized error code in
 set_file_basic_info()
Message-ID: <20210907073340.GC18254@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 7 Sep 2021 07:33:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45f2cd26-1ad8-455e-4ce0-08d971d1d45f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1775DFBAA89AF1C11800CB5D8ED39@MWHPR10MB1775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZGuTpgrIq+fM27IpX8VDM3kDFTgJI+zuygX5JDFMJFKuX1Es1rB889ZRRhfHcHafPBW+ogubN/3TuC1nanX9dsJTUPTFlCldD8yAGhOr9RzYVUW5AFWKM0zdIjmBpkHXTd22DyW5bbLa3/EyjgH/9o035da7kxQcuICvF388NtIm/U217EAfWLbJbl+ujFxR6qgNxiRTdBgIhA6INVmSU4EBOPq4wDlYlqIkTaw+6O3UR5mogLj9IpfiHTSTGsqvfbnzgxemUdB/hLUFufj+qXg/LVg2ZdFsvCfP0tKv8W3pza2OS9jtJlH9rYLZXfcBqjkJHT+eHkDpeqQ7uZVdSBgtKzEb6zSioLskdxVSRGKwG9ntmOmtai1g6SutQUJV04kS7wufePd2lFCXGZ1zp1eKKEBg37CC7m60JX5CrIE/7v5k4+lvoS8OxmJeS7UT9CAwvJ0d5K4jwgHA9+y2ftpbxVf0dzzvbxbkVn+0+2BczanGhXftQrEm4awpQhXWMIYfWF6+3dTJOsX1vvO1YVOP9o6sENj/TiZislyiCk9tr6PJFIyUlylc/4BD4ngOzNNH1a2gIYxdvAwhj/LSCaZi9ltJ3lRZvI1lOm7L49kN/2Fv2PBlHgHtsgPb/7Emlr8XNF9/zhREgSmXoFq1aA0XIANls3LTuaR1/uUZmse6hV8bZkSscEjpzRr5MmRCN54L/hduwiMg+AyKSwh5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(86362001)(54906003)(38350700002)(38100700002)(4744005)(66556008)(66476007)(66946007)(5660300002)(508600001)(55016002)(9686003)(6666004)(4326008)(52116002)(110136005)(2906002)(6496006)(33656002)(44832011)(9576002)(186003)(8936002)(8676002)(26005)(83380400001)(33716001)(956004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h76JgTSXrRmkAdOtCKJbfqQHWXXkS9AuMIafcqFzksznGrm9dJzxLB0picLy?=
 =?us-ascii?Q?2AH7JkKFdSr13NLLK4FR1SQyZ5NLCn1bkKf9yFsuRgJQut2uDRm2ZuIcJUj0?=
 =?us-ascii?Q?7oHbKfwMWb9z9ygq8xY3gPJVZp79tsFbVJmSeKRTV2MAnb7aXv0sCRGJnfD0?=
 =?us-ascii?Q?vHcknw5jScfRjTdXOTRn5VyWYP+mNJiTmOIqnOG3sRZ23fE4Cs1ehUyag1aX?=
 =?us-ascii?Q?g1XnZCqk8N70z34VrqBDXZm7qOvzGPqoLXwJHgGMhBOFBgFmGBOnd5ZWx/5C?=
 =?us-ascii?Q?rQ5diOulxSYn3qz83gu1O0THWdsHxXkglV55TkT4RBwQsHL84MNFn+Eqm230?=
 =?us-ascii?Q?8PpOKk9jeKvPCscfgcoqJ/lDFSTm4fDAR+/ofHjAu/ycIzvBAFCcrzA8p1/Y?=
 =?us-ascii?Q?gzp6G9kDFg3heLGLv7tiZBLdgFAZrQogFwtTm0CT/QKtb3yr2d1TwksGYbdP?=
 =?us-ascii?Q?RgrBbxiVxlPtBWRn60s8ccV13kBJRS1K0IqEDMDkjEfHvOLrF4bVDLMFtjHj?=
 =?us-ascii?Q?0l23dufTvwHWcH8mGY85PRr/YqFTSJmo2D1vNnLIrD9O6kK1Z62eDaNBi5ra?=
 =?us-ascii?Q?OhVDWUTPvdcGPoiy7hst98B7t3qmc6G1US6JIUFxaHhIARwVChfhT+Nay9p1?=
 =?us-ascii?Q?vzu/WawShvogDZv+3VTZmjaWukRrcr1fxh+6E6Tsw86pNnQxgH6UANjAgQKe?=
 =?us-ascii?Q?2O+r8beg9vD2HRptEIpMvqhef4A4yQ3b0hx5c6SqA5+uTE4CHkhjjlFPZnmZ?=
 =?us-ascii?Q?vr9YBjSxZFP+YfaHNaHSSKp72gI7xL8VWPMYzP+QEqdiBP8pmeQpbItffvoO?=
 =?us-ascii?Q?WVU0ELRJKL97mA3WpEDIGyGcLr6S+INYAM+vjF8oqB0PUehebGpKqpcCzR/N?=
 =?us-ascii?Q?LpKZn2+GzVXVFQHlgIKg22e/vZL0p6h+76jQ4qxoRw+rdnQA1x/JJjDemXe/?=
 =?us-ascii?Q?wssCzH03X6aeB3Lg0QPUtKcnjvF24CqKaqvHSQctFC1xfoGM7u7T839kSD4D?=
 =?us-ascii?Q?Ds082IdVYUvHx69eYiFyNhGH7woyhEuOO7gZAksFee2jtVAGigWRfePVZW2S?=
 =?us-ascii?Q?P1BsFvW6QOXNzVj9hd43vgxNVelfrJGwepU9ebgAahpNq+kDABu4Ef7KdmyQ?=
 =?us-ascii?Q?TH4IIuw/TZYyyYCQ1dP9iImyVNJfRrftRCGxfQlGld6bNyl3xKlKsm0DQGM2?=
 =?us-ascii?Q?hOkG5F2+8wKM+7inI6iot47p5ojh1N/GHVQoSGUeDHRUNh4MbDpVB++mkzMm?=
 =?us-ascii?Q?ghtsGMeAq5MnTik6IF6iInAk8njaOSHiryYW3S3F/9TvKcfPst19k3CxOzX4?=
 =?us-ascii?Q?0EQLx5aswG2QV/8OGzwe9Od8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f2cd26-1ad8-455e-4ce0-08d971d1d45f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 07:33:47.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtZRaf3pTq1ryhrIQRdNKajxzbD8a3XjOgXyojndKq61+brPyB2dhZ/P9A7YN1jCrMbPpUqCKyft69crLj0VdUoCGdiz9dCutQO1bu3flMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1775
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109070049
X-Proofpoint-ORIG-GUID: -jApV7kFe-FeAMiamDk2_wYk8qIfam7U
X-Proofpoint-GUID: -jApV7kFe-FeAMiamDk2_wYk8qIfam7U
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Smatch complains that there are some paths where "rc" is not set.

Fixes: eb5784f0c6ef ("ksmbd: ensure error is surfaced in set_file_basic_info()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a350e1cef7f4..c86164dc70bb 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5444,7 +5444,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 	struct file *filp;
 	struct inode *inode;
 	struct user_namespace *user_ns;
-	int rc;
+	int rc = 0;
 
 	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
 		return -EACCES;
-- 
2.20.1

