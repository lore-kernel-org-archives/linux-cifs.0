Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE446C433ED
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 12:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2B36113E
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 12:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243155AbhDFMbb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:31:31 -0400
Received: from esg-scz1.cuda-inc.com ([198.35.20.38]:56425 "EHLO
        esg-scz1.cuda-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242997AbhDFMba (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 08:31:30 -0400
X-Greylist: delayed 834 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 08:31:30 EDT
X-ASG-Debug-ID: 1617711448-0e7bdd3dd57fdb10001-broWZD
Received: from IP-SCZ1-EXCH02.ad.cuda-inc.com ([10.42.96.75]) by esg-scz1.cuda-inc.com with ESMTP id KE9SLcsTEkbKtTRV (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO) for <linux-cifs@vger.kernel.org>; Tue, 06 Apr 2021 05:17:28 -0700 (PDT)
X-Barracuda-Envelope-From: sthielemann@barracuda.com
X-ASG-Whitelist: Client
Received: from IP-SCZ1-EXCH02.ad.cuda-inc.com (10.42.96.75) by
 IP-SCZ1-EXCH02.ad.cuda-inc.com (10.42.96.75) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 6 Apr 2021 05:17:27 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.57) by
 IP-SCZ1-EXCH02.ad.cuda-inc.com (10.42.96.75) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2 via Frontend Transport; Tue, 6 Apr 2021 05:17:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyfXYMw/PDlSsRQ9By1LKrX+8T/t3SkrmFG8JQHUuKitA9ab2Pv3wVy02+HdBvESSFCjmXkm334f2OC6/+FQi1JlNYW1G1sgdFgqR8A2iuQ8qSVpJBzId/UtIsiFvZu9TG/4pI45nDRc4CaYj9z/yBw0rhXaYjtcnbeay9XQ5IbXGCMdKOxMEbWX3tydweuvIfQzj98yHh9rJZb36mCUsT8hL8WjWlr1PkuXrxdfyrAYHHxlWdgm4MCXpK6MYPIJfNUmxdh5RmofUhiLgbJhpcq4hQOEQXBXcr6+3sxCQZGSvliS2GgzkmBnPYQ+YFttIKXd8x0EbU0yl9rRtGNilQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMNrzYYYithCpIfWpLgGGL0ra7GiblvJ1zRPHZ4PPwg=;
 b=Mc/hacgz65PBDwbKL5O2JvhUMO0Hs6ktNaqdb1OSxbR0Z34o6jOdRCY+2ctkq92LI6Gc7Sf68Q5wVcmBpZu8pLC+2OxJSpFiaKhrq/wrIoz66uINqPh8L8AgxgHqeuTRHE8ZOg4Rq4Bw8wbfMgWkACTWsCU0GXbMh5Jq8xW10L6qCVFgp0V5+H/Y36v5DNfz7fh9XUBK2/lUOM73IISXWgPzkHKP0S4q2uUiLRP+DCjaNOg3ZLvo+ZZweKhPs2xGvYGZW0rBgCKVWEFJfjoT2tZZCZWAbIoo8OoOTuUPatZp4x05j8rUg8aucqC7LpwmbooxPQ7m20fq8Ss2FxHMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=barracuda.com; dmarc=pass action=none
 header.from=barracuda.com; dkim=pass header.d=barracuda.com; arc=none
Received: from DM6PR10MB3833.namprd10.prod.outlook.com (2603:10b6:5:1d2::33)
 by DM5PR10MB1484.namprd10.prod.outlook.com (2603:10b6:3:12::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 12:17:26 +0000
Received: from DM6PR10MB3833.namprd10.prod.outlook.com
 ([fe80::c60:b1cb:d94:f9b6]) by DM6PR10MB3833.namprd10.prod.outlook.com
 ([fe80::c60:b1cb:d94:f9b6%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 12:17:26 +0000
X-Barracuda-Effective-Source-IP: UNKNOWN[2603:10b6:3:12::13]
X-Barracuda-Apparent-Source-IP: 2603:10b6:3:12::13
From:   Seth Thielemann <sthielemann@barracuda.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Subject: [PATCH cifs segfault ]
Thread-Topic: [PATCH cifs segfault ]
X-ASG-Orig-Subj: [PATCH cifs segfault ]
Thread-Index: AQHXKt4/gcN4ypBJS06lRQOFN2ocFQ==
Date:   Tue, 6 Apr 2021 12:17:26 +0000
Message-ID: <DM6PR10MB3833F0DD867BF1B48F60B99FA2769@DM6PR10MB3833.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=barracuda.com;
x-originating-ip: [198.35.20.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44401b67-ce8b-4271-1387-08d8f8f5f0ee
x-ms-traffictypediagnostic: DM5PR10MB1484:
x-microsoft-antispam-prvs: <DM5PR10MB1484CB67D9036B31BBCDDF62A2769@DM5PR10MB1484.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dw9HUG/TX7fzuqXe4WMF+vLRqUCox1Bgq159B6raL3QioHtlTMZKBsmVhMLz5DT0riyqVyIntpYE3j1GOqwNE356xPCcIZhuc5GSxHFsIAU9J/e6SRvMNFNRLgTGrQGC8Md5OrRfcR2Z8gyNUALQpx0uOYfIyWOFkUthqICMhfNu14EOp66+qxvDP47kT9bRIthlprQBu+jQNlodOct8nKlx6/yOO7TWIidp4vJggQlZNmTX1eGTTEVIlse27vFrCERWfbguSfM+47Ztnsqyvu1D4Nk+Kh6BUqxcYIjhy3VVA6SMFp7tLN30v+vMx1CRFfIe4h8TDlTwxOQD8Enu4TOcs69sis8agCf6SYyw/+LLWv/6EWKy4DudTPkpde/OrYw4B/Mz5++RbXRXJ4XiB2BMvOaPqcSZV9nhtd4GrRvpziRJ3sl3JuOodeVRWXVCJtq528H1HZLo+30Xmolo4RRfKvqKxDXSTo8AupIroCx1HNEtkZXBO5zek8INRPmN2GZCtfxJ/+grQM+wXXLCv44iajGqWXQ0T3CtbAyP3auBfKugvnWH/iyHp6p7xUsjazo61r2qLGELy64HfbDQi2lw/rj9g1c3HumH/lzAWnCVE4XvLTkF6adYCjE9PBgD90Tov/9c0D765u7bJb1dDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3833.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(376002)(366004)(83380400001)(186003)(6916009)(8676002)(316002)(26005)(38100700001)(8936002)(33656002)(52536014)(66476007)(64756008)(66946007)(66446008)(55016002)(76116006)(86362001)(71200400001)(9686003)(478600001)(6506007)(7696005)(53546011)(5660300002)(2906002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?ZuXqONTpVIgHC9KleSzeJ8BwPEYMe/UHM4YegRZrMhQaHf2PjTt20FdF/l?=
 =?iso-8859-1?Q?LG1ohmCs1XBTSrfpkQfLLa/BeooL5b3aVfKW4lkuBu2KKoTTfUVtKvNoGk?=
 =?iso-8859-1?Q?lS8NArjhCIlqzghIxp/4yQNPOmCHQOoTjZF1BObURBAezkZexYNIZunClU?=
 =?iso-8859-1?Q?4IZSAqU6zldLJ62hSOgOzZexI5Jf5Hqa/9ZAH0oAFc4fW2dutGJN74pB8P?=
 =?iso-8859-1?Q?/1AFD3bdnW3Zf4dO4Q8hvWtAQc+vazOPltYCLcmiWquCDvD9XW6NhgUO6Z?=
 =?iso-8859-1?Q?0gwq5dwLFPGuJI7T/EuI+0PmYS5jQ3pr2NUawXB+n4ROxBu65BPPZ6LcBt?=
 =?iso-8859-1?Q?BBPHA3bFEfmIGjkShDou51+afWvbBSDrVXDe4crtqilNTQ++IAddOvKC+l?=
 =?iso-8859-1?Q?7/xfh9Cb8EXKl4LnmH/P2JJZK1P3ntwUzhdjaQjyprGBFuElZOKiZEhK09?=
 =?iso-8859-1?Q?PyuXWkcSYodMurQ2GEMZ8ibm9cTzrddPllB2QLF/BcIoizwsu49gC1zrud?=
 =?iso-8859-1?Q?VhjbSOE3qbT3485uIcoJORVl9yJLx7WxIhYmVT7fCGJ/vel/zxxdW8Y1YY?=
 =?iso-8859-1?Q?2mc5JXkxVFVV/OyV9HUrDf7LnQQaGZlojV7WcylCB6ZlYn7rOoQn6TcjJ9?=
 =?iso-8859-1?Q?jvrxe5AZ0vNBYsf4zHBRz67/3yhUqsqwK+WW1duJLmN9fbq+aqgOKhDqY5?=
 =?iso-8859-1?Q?0d0Itkz7mWFRK5/kMUDFVQ96hEu2mwaeejmOlquiuGXpybm+5lpnDS5Muc?=
 =?iso-8859-1?Q?zbzmLmTOrx1tINxmE9TBm2phnK2XqVU6ra8aye+oJSQU2AdpyOx9EA8q6i?=
 =?iso-8859-1?Q?KkqpefWKGrV3PV46+InD2XfZ7NtYtlyPfJBxBS0zfGJkUMoF2TJUMXSPoA?=
 =?iso-8859-1?Q?x4YWP3fUg3dQVEQH4lBmewRmA8/ACmIzmyo6oXq4U5YLjo2WzCmnS9JQED?=
 =?iso-8859-1?Q?mw6VPJ9rRX+x9sRCrkPKd/gCFO5Is0jOeqPLMc3Yt12e+BmC/RJCfY1XqJ?=
 =?iso-8859-1?Q?p58qnqpcpbVxSPJ+lf34ifM9yEQGmZBFd68u9oYBSKP3HchwbniiPiXjfC?=
 =?iso-8859-1?Q?8iTOwZjvUew3BdTZZqUUIw5g86MjSGt9ilwhRqKfxv5q0Kyg+H8J9Bhs+N?=
 =?iso-8859-1?Q?wVNtG8gk4gPJXiHy+5JV6WXOJVdNZJjGs82A/e27kM1GdbXrp2tUO7u1qG?=
 =?iso-8859-1?Q?Ww8sWoQWASOpNLHvzpPyp20ubYyCGKIDuLvUy593yv/43PnPO7xTMiLGvE?=
 =?iso-8859-1?Q?bI5vbXoXdyB/MX0klKVbJUcE9wdPy3YcCOqfeHpJ3bl6GDH3GPKtm19se5?=
 =?iso-8859-1?Q?sqXxN9ulU4WczgsZ6KNLzf6/WCqo/qGsQHZHPSFAvmoEMrU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3833.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44401b67-ce8b-4271-1387-08d8f8f5f0ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 12:17:26.4176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b893e0b8-2743-4fa7-81eb-0155a9060350
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ljlXjyHftpLYzo9QN4L38LBcnjCF/kfUzIkldtWRT4qfBoEwA+ykpfqlbGqNvUnhkFCANt+nNp6OXuif0u5VH1Vm8LtOE4hBYevDyzZdOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1484
X-OriginatorOrg: barracuda.com
X-Barracuda-Connect: UNKNOWN[10.42.96.75]
X-Barracuda-Start-Time: 1617711448
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://10.42.53.101:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cuda-inc.com
X-Barracuda-Scan-Msg-Size: 9188
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From e14cbf048c40d565e31d28479794d1feff9474f0 Mon Sep 17 00:00:00 2001                                                                                                                                                                                                          
From: "J. Seth Thielemann" <sthielemann@barracuda.com>                                                                                                                                                                                                                          
Date: Mon, 5 Apr 2021 14:58:59 -0400                                                                                                                                                                                                                                            
Subject: [PATCH] BNBS-45422: cifs segfault 6.5.03                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                
- Observed segfaults during cifs share backups, core investigation and strace revealed that files were being opened                                                                                                                                                             
  but upon read the syscall was returning a 32-bit error code:                                                                                                                                                                                                                  
open("/mnt/datasource/12/USERS8/pjabbia/data/MailPersonalFolders/Personal Folders.pst", O_RDONLY) = 10 <0.001080>                                                                                                                                                               
....                                                                                                                                                                                                                                                                            
read(10, "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ)6 \26
5ZZZZ\3274\325\16\250\177\0\0h%\1\0\0\0\0\0Y\f\0\0\0\0\0\0\27C\225\231ZZZZh\232\202\33\250\177\0\0h\232\202\33\250\177\0\0\320\234\206\33\250\177\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ)6 \265ZZZZ\2572\32
5\16\250\177\0\0\300#\1\0\0\0\0\0Y\f\0\0\0\0\0\0\27C\225\231ZZZZ\20\234\202\33\250\177\0\0\20\234\202\33\250\177\0\0\320\234\206\33\250\177\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"..., 8192) = 4294967283 <0.000144>                                                                                                                                      
                                                                                                                                                                                                                                                                                
- Above is an impossible situation, the sign extension was at fault. The two functions using the trinary assignment of rc                                                                                                                                                       
in the cifs asio context:                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                
Before:                                                                                                                                                                                                                                                                         
   188d6:       bb f0 fe 00 00          mov    ebx,0xfef0                                                                                                                                                                                                                       
   188db:       45 85 e4                test   r12d,r12d                                                                                                                                                                                                                        
   188de:       44 89 e0                mov    eax,r12d   <- msl cleared
   188e1:       0f 84 6a 01 00 00       je     18a51 <cifs_uncached_writev_complete+0x371>
   188e7:       48 8b 7c 24 18          mov    rdi,QWORD PTR [rsp+0x18]
   188ec:       49 89 85 a8 00 00 00    mov    QWORD PTR [r13+0xa8],rax <- saved

After:
   189ce:       bb f0 fe 00 00          mov    ebx,0xfef0
   189d3:       48 85 ed                test   rbp,rbp
   189d6:       74 7c                   je     18a54 <cifs_uncached_writev_complete+0x374>
   189d8:       48 8b 7c 24 18          mov    rdi,QWORD PTR [rsp+0x18]
   189dd:       49 89 ae a8 00 00 00    mov    QWORD PTR [r14+0xa8],rbp

- Use ssize_t here to make sure the sign extension is handled properly.

Signed-off-by: J. Seth Thielemann <sthielemann@barracuda.com>
---
 fs/cifs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 31d5787..b2640fc 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2988,7 +2988,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
        struct cifs_tcon *tcon;
        struct cifs_sb_info *cifs_sb;
        struct dentry *dentry = ctx->cfile->dentry;
-       int rc;
+       ssize_t rc;

        tcon = tlink_tcon(ctx->cfile->tlink);
        cifs_sb = CIFS_SB(dentry->d_sb);
@@ -3075,7 +3075,7 @@ static ssize_t __cifs_writev(
        struct cifs_aio_ctx *ctx;
        struct iov_iter saved_from = *from;
        size_t len = iov_iter_count(from);
-       int rc;
+       ssize_t rc;

        /*
         * iov_iter_get_pages_alloc doesn't work with ITER_KVEC.
@@ -3689,7 +3689,7 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
        struct cifs_readdata *rdata, *tmp;
        struct iov_iter *to = &ctx->iter;
        struct cifs_sb_info *cifs_sb;
-       int rc;
+       ssize_t rc;

        cifs_sb = CIFS_SB(ctx->cfile->dentry->d_sb);

@@ -3910,7 +3910,7 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
        struct cifsFileInfo *cfile = (struct cifsFileInfo *)
                                                iocb->ki_filp->private_data;
        struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
-       int rc = -EACCES;
+       ssize_t rc = -EACCES;

        /*
         * In strict cache mode we need to read from the server all the time
--
1.8.3.1

===========================================================
Get the 13 Email Threat Types eBook

https://www.barracuda.com/13-threats-report?utm_source=email_signature&utm_campaign=13tt&utm_medium=email&utm_content=13tt-ebook

DISCLAIMER:
This e-mail and any attachments to it contain confidential and proprietary material of Barracuda, its affiliates or agents, and is solely for the use of the intended recipient. Any review, use, disclosure, distribution or copying of this transmittal is prohibited except by or on behalf of the intended recipient. If you have received this transmittal in error, please notify the sender and destroy this e-mail and any attachments and all copies, whether electronic or printed.
===========================================================
