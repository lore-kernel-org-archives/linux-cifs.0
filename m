Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FBEC07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 10:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D82461C92
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 10:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhGGKTG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 06:19:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16372 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231260AbhGGKTG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 06:19:06 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167AGApa028650;
        Wed, 7 Jul 2021 10:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=reseqOmkFhsyBn9vgj+E4F3gaETFLuNXt19JAgl2xZo=;
 b=EB4O/IPI7yfDAf2dhzHp9Qdb991pwoApUaUzqB7XBF+pLKaUJ53ARm7IpkNQNq+l/cnJ
 P9/BvWytha1GD46enCCBay8IxD3rpnNPRQ3unO9y+SRXcTwzqh9FPSEuOfQXFabOgt+i
 +fPhJc1O45XnqOBp18CTwVcXM0g/OWpD5/25Sc1M7nCwNS/PmO0s1xQ2FP78XJPA6yPL
 UcIIAUwWTJXTVxvME0Z3lr0GRuiA4vYz9dF0Ez6fKQQ1FXmnpuQiKTFLaQPBUI2tYKcd
 /jjINRDt0mEmRHbKT3rGyvWbbEvoYatWw0hWACrPAiKfRBQ/pTz//qBSz/oTiPrcE8F4 Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n4yd0k2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:16:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167AG8va019544;
        Wed, 7 Jul 2021 10:16:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3030.oracle.com with ESMTP id 39jd134npx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZM+EKLrqkAOO/2gD44nGATDsLj67SbcA9Nft33ALnamHfV+wwAOw6we+2qOTNAqtU7Xm7um6I2agreVeghYxHQ8XX455M2WeaqgxvcS8ZF0dDILAZ0rNdgtVCPkP9TkZ13AMQD9lrDrXrKNmG3UGSWXml2fCwjPB0z2lkTODtMITu4ozlGveUaPWq7ERDrjmxDDdunMFn1G5wp55m7P8HdZFpBVrh/bkpcqIyy6v1EW8L7qeYBfwCw5xyMlcyVWtS536DJ0n2H4c9vXK8QGypOe8KZS+Ca4SS+qmxeVHjfNyJWqor5Go2B52bWOjUUkwRTSkJYtmb1HV+vrQHMQ4aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=reseqOmkFhsyBn9vgj+E4F3gaETFLuNXt19JAgl2xZo=;
 b=ZDOgj1hYQ2l5nXHzTgGb/gu5/RV99jAu6j5YVlP3J5h3QM4AB/q+WQbvxW6RaG8ClWggkU1awhyaZe3ymmnHR4ajUQ0TJc6a539CEIDnyexxdCElq+BaFkQFtquZXg/LLUn53f2DCsn8CdlPkN+f2KhSOj9drIDiPgShYyFApbqiCGgejuoU3U9kMORnwXy0TfUSBWKsiAxaT1QXw3MsTBEOVFmCLihIj94qdICF7u7G8dvCMPgHipuvJ9Fsfcup71YCnc0MvK4EaxKPe2GlNG0Jt81HoL+gb28X05k7S6zqoKjtQtsM59ieGwaW623pWxqAtxYJ1QJGx4vEXOzqWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=reseqOmkFhsyBn9vgj+E4F3gaETFLuNXt19JAgl2xZo=;
 b=TrbgC/GRJNDC+YZbuMfO6L+Q66shrzdZDR3L0p+deoaoLOd/dkpbDQhZASeiqSzv6v+yImuRaZBOhbQcXls3xgE1XMzBYVmkHHiTLhp4ZZ48q6tWP9A1RuBckLXjKGDC5o4gxlo6pX6X3iJ0i/IAZIN5y4EFenpwkE5w+RyQ9pw=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5425.namprd10.prod.outlook.com
 (2603:10b6:5:35f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Wed, 7 Jul
 2021 10:15:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 10:15:58 +0000
Date:   Wed, 7 Jul 2021 13:15:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: delete some stray tabs
Message-ID: <YOV+zDoSSwH2oMzG@mwanda>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: JNXP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::34)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mwanda (102.222.70.252) by JNXP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Wed, 7 Jul 2021 10:15:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 019a3c37-813f-4fc6-5ef8-08d9413036df
X-MS-TrafficTypeDiagnostic: CO6PR10MB5425:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB54254DA9825098FE4F8F931E8E1A9@CO6PR10MB5425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:235;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: inqD1BU4y+MjLBz17sKMJW+ONdp/kHvOUKtLHHUlPyAC/ONDkwKCE52CSpAnWndZhij/66Dv0BDl8BZkb/U5qMFhsVvy5uMMOgmy7hl9yE8beCjoCv8fVNxAgbztKNVCd0OW5gwEBS07AzHgfLxGmpGIEKYgCCvht/cgIXs2+jib1CAoUVh3g+ObIk/RbIGOBnQ1klFEY9uksE1F1BEzl9TUCfaue0YZMZplNsFgmMLZCaKtLXd1utQ4Mw6gT72bnZLT+ppEDLvQydWKxuiZkIu+o96v0sNpN6KNLaFE0bOm67L8KE84idKeheiUcp5sNCIShz3jwXaxMBYV6sM+n05+VPSNhBbSVsBHOXQjJSUjbalf3foAYT/a6b7aBpzYx3u4jpFk/YzbW2AM07M15zBfylFNAVF20yFcZDztaKLnHc3qLz3Uyi6815Z8xw/Y9ZO2L1KhAYaQakNDAd3ztZBmOP0n72k6qc7w/+WUtd1tt6IGk3F8P9hZhNaihergXxqvvpPAPxYyTAI81YyCrKgSPqtM0E6yXzRBhMXpjoAGbZ6MrfqgSybEbyFHjUmyU8McRyMOoCnLvfJG+ZYrYjWr61/RUh+GB64k1EtiMvPOqA5moN5bMg3qPcD0bJ9KMVgdB8i2mDMoBEP0M0JoGXbv99xs08tvLaJrRs2nLMQAHiTKPsdpQecB/2lSEGFvOaNRjZ+0xD8Bg/nLtnR1SmW/md2NjaIRtghHGpOfpkw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(396003)(346002)(52116002)(4744005)(55016002)(9686003)(66556008)(38350700002)(6666004)(8936002)(66476007)(54906003)(8676002)(956004)(38100700002)(44832011)(66946007)(6496006)(6916009)(186003)(5660300002)(83380400001)(4326008)(33716001)(86362001)(2906002)(9576002)(316002)(26005)(478600001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eCaovKchYcKE4vjWZP+EQhVQIgJ7nvZefqAF2ihm2SEwf93IbYZrMVNPHpgA?=
 =?us-ascii?Q?ZA/54nTKiooeQuyWpwj4K5GR7O2Pg2FFp11WIiZZ3ne9Cb+02PYw65qxqKzR?=
 =?us-ascii?Q?InxU14lq2nlgElAC6K2DRd9q/BPxh0JxXwuGUr0npz+HVmXBwYfMscCjh4Yq?=
 =?us-ascii?Q?zOicxXwxLOz6cvdJzen0H7ijUWVkAG5r+TwkhsukqYkXxtAVZXr4JEx3ES2G?=
 =?us-ascii?Q?3hyxsFHLuOtKpxyCje9XURXQ8uZ7bDFGytH+oOXXlb7WNc/LmcF6ApGv0QX1?=
 =?us-ascii?Q?/o+a/+q+MYthhFByqsNwVYKVY2K55oiKiVy2lcTCzTcDIlxoijDwN2LUiYW8?=
 =?us-ascii?Q?sgT5m0KudaTwer1q12Jw4F4u/qISsdBeY0N8zk8D/484Nnkb7DRZi1NXqHzp?=
 =?us-ascii?Q?SgvK0HoEvglT5yUDpzLVC643zYky/LpxJxAom+bYhlhK3+33Lt5B8afcAoCc?=
 =?us-ascii?Q?8ZJX+BuLSuh8s+/J1OOr1xuNtspZHGSV35PnIYpP8+IRd9n3SO6VetpvsD5O?=
 =?us-ascii?Q?8VOM0gkV0ByQD8xDyeYZPmAIEWHplDpxiAkHuNDp66gfvqAf/quhmVHotPTB?=
 =?us-ascii?Q?6vy3AHtFYK3tNRQmkNEjeQtKf6Mxt+w+pL4ytqWelNsRDWlCGqmMrLYvkgJ2?=
 =?us-ascii?Q?0lmjOvQf72Ic4UMGH1TAbvY/hknCzTlF3YvjRILk1kLgfkYXng7l9vejJgjE?=
 =?us-ascii?Q?AhCrOz38rQxF/q+69AG6QvRKzjlvjeBrDqERU8vMEcVTHc0RBJmg9AbI8CJd?=
 =?us-ascii?Q?0xVp37mZOKbS1vSj6AcIjpbbySE7bpbbxbylkGJ4/B6lax2gSL71ZiqPtE/k?=
 =?us-ascii?Q?FMAF+j5e0x4ubq1QF00m58sHfaNXbvzOuVSxaD66oZb119v8uFDSmj4RGVAV?=
 =?us-ascii?Q?1UOWeMuShkz5ih8gCLS4Mkcx7RfIyDS5HiC/DDS/zHLyy8cFD3ZKXuGd7hF+?=
 =?us-ascii?Q?dy48lAHPA1fleE8Jv+X/dxZmeMI97KjiYJQGRzXgWFXdxuZ6EtGt5IZXkOk2?=
 =?us-ascii?Q?FkSgM6Dcs2CbcIqOtfDMtEsa/YF76AJrdbwSyt5PCXz+aGUfFtOadMDDXhjE?=
 =?us-ascii?Q?Ac+m8WqWUUuVU+Q6t+3ml1eVjpFRXRP9v+G+QxeyPK/XHM/SPy5qPY+urAYG?=
 =?us-ascii?Q?5DyjyoUsbqY3kchbZWyEGLFqSfZIM1m97S8h+M0tjHBBDQ6gz3Is9LPL3ecK?=
 =?us-ascii?Q?FaPCH43b+Zw/HX7rxTaM9lbNQTQLprSU7AvfQi4f8aVqiXeln/27ep7Dec+Y?=
 =?us-ascii?Q?2txFxUMlWuZlafQqGKAJxSZ1jLNyDYoC2a2Eh56ZPxoRNDWpqLnGbQGEkJ1k?=
 =?us-ascii?Q?8dEJt0wpTjrIlvUrYKQ9So/S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019a3c37-813f-4fc6-5ef8-08d9413036df
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 10:15:58.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvYEx0m3Ovfe+k6em3pPMhXXX77pKkOy3pxC8pHwcIG2lQ9mejbmHbbT1B2qiXnTjLZRiVpPXXE8KbcCGizPkl2KhzcW9gqdnTxwjcBh8Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070061
X-Proofpoint-GUID: VlCEOUz0UDSqKauvmNOekuQjul4BpGbv
X-Proofpoint-ORIG-GUID: VlCEOUz0UDSqKauvmNOekuQjul4BpGbv
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These lines are intended one tab too far.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index dda90812feef..b4c851ccda32 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6684,7 +6684,7 @@ int smb2_lock(struct ksmbd_work *work)
 			    cmp_lock->start < smb_lock->end) {
 				pr_err("previous lock conflict with zero byte lock range\n");
 				rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
-					goto out;
+				goto out;
 			}
 
 			if (smb_lock->zero_len && !cmp_lock->zero_len &&
@@ -6692,7 +6692,7 @@ int smb2_lock(struct ksmbd_work *work)
 			    smb_lock->start < cmp_lock->end) {
 				pr_err("current lock conflict with zero byte lock range\n");
 				rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
-					goto out;
+				goto out;
 			}
 
 			if (((cmp_lock->start <= smb_lock->start &&
-- 
2.30.2

