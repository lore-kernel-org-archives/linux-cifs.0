Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DC8C433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 21:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D3F2601FE
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 21:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243763AbhCAVAl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Mar 2021 16:00:41 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:52362 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243923AbhCAU6Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Mar 2021 15:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614632228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ymZdXc8KeAs6VLGDDf6HDnnV4qYGqCLvirzOKPy/gkU=;
        b=hybg8sstbyL66PM++6vY2PR6kp5jLw49RQ3fKBHHHQt1W2wu8Ytt1If7H/807R69/mqZtR
        O/icltDiwxJ+FpEYBh9X6wkxC+J0AuLozjeJUZkhn+M03LqzDE00+ZgqGmYJcG5GysrEM+
        lNvFOemcMSNSmFV2yP/B08HF695lJg0=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2059.outbound.protection.outlook.com [104.47.9.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-qvfSgHjoNwyTzK-Ln67IIw-1; Mon, 01 Mar 2021 21:57:07 +0100
X-MC-Unique: qvfSgHjoNwyTzK-Ln67IIw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxLLIPrQpTFnmvSBDnum/2hcFM4T21TFeWzba7qHtGWQdhaRDEFTMZBrozxs1Vcuj24yk6cLAhPKImV4nvEfTsfeYi7WWI15nQBz7EJJXDqm7C6SvWGJEn+we7oSswTjQXdWOJellpfYjrJuSri6F8Jos9aJUqiS4pvc/qTt++47RzebQqyjwiPgzkRz0b5ZcFyyDvBrMkd7lqRsIKXql+1y2mZET86tsa/Qib2ETyFKHnw6IPjW+T2zZnnh5dH6its/j57n2u2jBDzejB45eoQmV/uLC+mBHKInimxb7aAEbIJ2uwQEkNOR18cretwqkcCH6b+ryCylxNlotsTr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymZdXc8KeAs6VLGDDf6HDnnV4qYGqCLvirzOKPy/gkU=;
 b=hNI+pZDFmPZCEHWqctWMi6rT+hQpFGigBLZcZzzEcTCTitNpmgS0cae3uoH8l6iXaUoxxcsgKKDe2lcuvNwnN0qdRXVA5/d9AgIoGMuHhhKmKiZR+44nKQBbucbdhm3Z8KaPFZ/ZonJRf4k9d362Mll9ch/VMqdyzejeouSR/RRruXuKXln3DtuAnzUi9NXdp7YQxEmavo5E4MloSR/mQaQtIwxo73LSuvm7xfLS/idm+BHRCD9K37+L2y1gxM0mi4N3XZ70BETt+KpyzVOrhlfyvPz6DRe9BzxTA3qEGNOfJe5Wlpb9dRleJlmBTGEijAKwZ3DFn/h8rMqX4CY+qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB3229.eurprd04.prod.outlook.com (2603:10a6:802:e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Mon, 1 Mar
 2021 20:57:05 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 20:57:05 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Subject: Re: [EXPERIMENT] new mount API verbose errors from userspace
In-Reply-To: <87tupuya6t.fsf@suse.com>
References: <87tupuya6t.fsf@suse.com>
Date:   Mon, 01 Mar 2021 21:57:04 +0100
Message-ID: <87o8g2y4m7.fsf@suse.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-Originating-IP: [2003:fa:70b:4a92:20ca:256:2191:52c5]
X-ClientProxiedBy: ZR0P278CA0056.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::7) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a92:20ca:256:2191:52c5) by ZR0P278CA0056.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Mon, 1 Mar 2021 20:57:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27921d0e-d2bf-47d1-ce59-08d8dcf491e8
X-MS-TrafficTypeDiagnostic: VI1PR04MB3229:
X-Microsoft-Antispam-PRVS: <VI1PR04MB32296CA727595770B4CAE0EBA89A9@VI1PR04MB3229.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /qko0DS1UCYfnKl1RO4gmWd/flGA538m9kpuFrFUJJA8AbcquOAF+0FbhDy2WsgbrOt9w3gtZYk9drOs4V2lg638VvLaG94LxLmPGmFcNPbzUo9hdqFGRnC+z+t3okyib3dm2n5mpT9I6nt5sZhPaIv8QTHJow+OjUaNHdjCm7rq3HhrcFQQCqFT5GWAgMa8zKm6FAnKTbkPvjGedKvDybuOaPZYQ6wVZoGnWWlmydxu8CBUqeV9TssFpHdhhf+fooXJTCXLxEdGJ2rev6jrjKQMNCWpopCJGf6qwHM88KcKBeXcW2xPUskrzYNt4Y3o1FC/BXZk2Q2F41oMtoiQ7RSWK5FdirMJSQUD8lsDsHSYXgNBEp83AbzRZH5or2oQthVYGnulnkCfBAV0GZKPxn2/NG4ot0fQJPsd9ySv8o10iRuSS5B/bFuQITVOxZGL45QP7U5TDn3Zf2D6qYzjOu4YmesSHHnJlhxXQenp3FbSQRU5rvkg/x4bm+64O+7SAroMUnEC2LJe31undD7cVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(66476007)(316002)(8936002)(66576008)(6486002)(6496006)(564344004)(52116002)(478600001)(86362001)(66556008)(2616005)(5660300002)(235185007)(16526019)(33964004)(186003)(36756003)(8676002)(66946007)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x+BEXsGUz5aZy0o9QWv2WHnb8iCaTQXIUnI8+vmu3PUOVOb56aodBmGu052K?=
 =?us-ascii?Q?0xrgKHX5gDesays8rP8O0qCkgd2MNkmjnQOxSGul/hOto1N64WroBE+2V+h2?=
 =?us-ascii?Q?Uy5+D9O/QBsjLINufCR6O5Y1BAfSeKkZ6eB34MrciunTsD2s2JDmK0IeCqcl?=
 =?us-ascii?Q?QQgK6boELxh9z8T+12CiKAZAnZAnMcMJ5FDycgkLmfLT5k8R+3p7TPg8AZl0?=
 =?us-ascii?Q?JZTXo8qwrZliyYZ48ND1bc0f2Dc+MGV79bmocHiLxOvfoiAPDrdm4KyzpsxW?=
 =?us-ascii?Q?5jA4fu04CmITWzY9Ny5UOHrICuOa4z9pgMGvnAHY+bqm2k4x+dnrI8UTqDjt?=
 =?us-ascii?Q?sLv6Qalni7fYtDIrqKu3nnp4/iNkUD5pD4Fkz0TBPsrjL8AOAWFqCeefkp1D?=
 =?us-ascii?Q?bA7cv5TsxMN3ouoOWdrgaDs2d4gJDhKdMFPPYgxlGj4PLu4FHJ3pjsPmiL1I?=
 =?us-ascii?Q?PVcqU+Cty1B2QFoD72rde8qvu/NwxicYIretEGGtJ7ID/AK8NNzvpuNSpkLH?=
 =?us-ascii?Q?FhoLH6dwEH/dBwLC02C+AXX692RO67s/WKXgv+BNyZ4G67i+Q2rlBhXiqNrR?=
 =?us-ascii?Q?sNkAVv+lRdk+dmb5xiO6jFWAjAhsCXDOQT2v92PsBdcovMS5vpZqMTSSzi0x?=
 =?us-ascii?Q?CszteAhiKLlEDchgH2YV+kAyIKea8nGzd5co26ZQLLNm+JoaYj3nstW827fj?=
 =?us-ascii?Q?vj1CwiI5HaIvI+LLMqxgy4+3Gm4mpKfRjOOtnIDH0UZG+zEM3Ot2VX02uGck?=
 =?us-ascii?Q?l7snUmnG0E4Q9Od3VYjZ2warvY4LOonulOAOc1oglfEjOLCqJI7B0/NfpTny?=
 =?us-ascii?Q?qIdtXI6QsRtN0YHANZ1S8tvNEzysYgKFLuX9gTOlCTXTsdqiUEVrk/bl/M1W?=
 =?us-ascii?Q?lTa3N2sd0ySaaYJFrWlDgZY3pSwJ/mk5V70pwyZakGg0AfdbdMG+3CiIUESp?=
 =?us-ascii?Q?M3OTkr7Fqbqpzscu/EkmYUc8D6cN9TEs+ueLFuFnHES7FF35GWV4+ff94RrA?=
 =?us-ascii?Q?5kpyX/7hYGQ5Pls+fn7ugxR3Lt9IEfTlVc1UU9OnOQzRhTpJfNwDxKyUNOYr?=
 =?us-ascii?Q?w1HMwAoQVMCzmIYLE77SPm3nm9lu3N5tAeYV007+7DkyNJ2NpU8h+JfY4j8O?=
 =?us-ascii?Q?WBvTy6yKPK/U92UWnSovhRpe4+e9tr+SkbRvcVID+DYhELuTQ82EfbPNLdga?=
 =?us-ascii?Q?PQh9qDJ+tZ8pjh92sdMdTlY7KqKDRaU3unIealbsiwiOT282rQGHF5i8PZoM?=
 =?us-ascii?Q?Z/5/6+ulaK3UdXVIO+2JAOoV4yO+ysoZEr8iVYqNYOCqDnmuFnXIoqtgJCOM?=
 =?us-ascii?Q?eTUjE9+wn9ZskuA/Ps0e6BDwq/Iq8GIY26uz4QVOCsctxdr4dqeUKR/qJsci?=
 =?us-ascii?Q?nUtUVcqRDDuCCOkzTzoowvLgqcCB?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27921d0e-d2bf-47d1-ce59-08d8dcf491e8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 20:57:05.2188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 99e+8VMvWUbYHbcRQy83Qd7trao4G+2NkY3xhSJwXSag/GZzAzpwJYy5gz9SmyYK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3229
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Oops, sent the wrong set of patches. Resending right one.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=fs_context_log.patches

From 2b0fa815fe8337f93174eba888dc67b140498af9 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Mon, 1 Mar 2021 19:25:00 +0100
Subject: [PATCH 1/3] cifs: make fs_context error logging wrapper

This new helper will be used in the fs_context mount option parsing
code. It log errors both in:
* the fs_context log queue for userspace to read
* kernel printk buffer (dmesg, old behaviour)

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/fs_context.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 87dd1f7168f2..dc0b7c9489f5 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -13,7 +13,12 @@
 #include <linux/parser.h>
 #include <linux/fs_parser.h>
 
-#define cifs_invalf(fc, fmt, ...) invalf(fc, fmt, ## __VA_ARGS__)
+/* Log errors in fs_context (new mount api) but also in dmesg (old style) */
+#define cifs_errorf(fc, fmt, ...)			\
+	do {						\
+		errorf(fc, fmt, ## __VA_ARGS__);	\
+		cifs_dbg(VFS, fmt, ## __VA_ARGS__);	\
+	} while (0)
 
 enum smb_version {
 	Smb_1 = 1,
-- 
2.30.0


From b71d570d614b427067651cd5bcc738fc19c4627a Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Mon, 1 Mar 2021 19:32:09 +0100
Subject: [PATCH 2/3] cifs: add fs_context param to parsing helpers

Add fs_context param to parsing helpers to be able to log into it in
next patch.

Make some helper static as they are not used outside of fs_context.c

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/fs_context.c | 21 +++++++++++----------
 fs/cifs/fs_context.h |  4 ----
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 892f51a21278..6158d92cb9c0 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -188,8 +188,8 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	{}
 };
 
-int
-cifs_parse_security_flavors(char *value, struct smb3_fs_context *ctx)
+static int
+cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_context *ctx)
 {
 
 	substring_t args[MAX_OPT_ARGS];
@@ -254,8 +254,8 @@ static const match_table_t cifs_cacheflavor_tokens = {
 	{ Opt_cache_err, NULL }
 };
 
-int
-cifs_parse_cache_flavor(char *value, struct smb3_fs_context *ctx)
+static int
+cifs_parse_cache_flavor(struct fs_context *fc, char *value, struct smb3_fs_context *ctx)
 {
 	substring_t args[MAX_OPT_ARGS];
 
@@ -339,7 +339,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 }
 
 static int
-cifs_parse_smb_version(char *value, struct smb3_fs_context *ctx, bool is_smb3)
+cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_context *ctx, bool is_smb3)
 {
 	substring_t args[MAX_OPT_ARGS];
 
@@ -684,7 +684,8 @@ static void smb3_fs_context_free(struct fs_context *fc)
  * Compare the old and new proposed context during reconfigure
  * and check if the changes are compatible.
  */
-static int smb3_verify_reconfigure_ctx(struct smb3_fs_context *new_ctx,
+static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
+				       struct smb3_fs_context *new_ctx,
 				       struct smb3_fs_context *old_ctx)
 {
 	if (new_ctx->posix_paths != old_ctx->posix_paths) {
@@ -747,7 +748,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	int rc;
 
-	rc = smb3_verify_reconfigure_ctx(ctx, cifs_sb->ctx);
+	rc = smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx);
 	if (rc)
 		return rc;
 
@@ -1175,16 +1176,16 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		goto cifs_parse_mount_err;
 	case Opt_vers:
 		/* protocol version (dialect) */
-		if (cifs_parse_smb_version(param->string, ctx, is_smb3) != 0)
+		if (cifs_parse_smb_version(fc, param->string, ctx, is_smb3) != 0)
 			goto cifs_parse_mount_err;
 		ctx->got_version = true;
 		break;
 	case Opt_sec:
-		if (cifs_parse_security_flavors(param->string, ctx) != 0)
+		if (cifs_parse_security_flavors(fc, param->string, ctx) != 0)
 			goto cifs_parse_mount_err;
 		break;
 	case Opt_cache:
-		if (cifs_parse_cache_flavor(param->string, ctx) != 0)
+		if (cifs_parse_cache_flavor(fc, param->string, ctx) != 0)
 			goto cifs_parse_mount_err;
 		break;
 	case Opt_witness:
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index dc0b7c9489f5..56d7a75e2390 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -262,10 +262,6 @@ struct smb3_fs_context {
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
 
-extern int cifs_parse_cache_flavor(char *value,
-				   struct smb3_fs_context *ctx);
-extern int cifs_parse_security_flavors(char *value,
-				       struct smb3_fs_context *ctx);
 extern int smb3_init_fs_context(struct fs_context *fc);
 extern void smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx);
 extern void smb3_cleanup_fs_context(struct smb3_fs_context *ctx);
-- 
2.30.0


From db2dc91319687f438a5f99bc4ecddc17dec7bf3b Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Mon, 1 Mar 2021 19:34:02 +0100
Subject: [PATCH 3/3] cifs: log mount errors using cifs_errorf()

This makes the errors accessible from userspace via dmesg and
the fs_context fd.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/fs_context.c | 95 +++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 49 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 6158d92cb9c0..9b0e82bc584f 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -203,7 +203,7 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 
 	switch (match_token(value, cifs_secflavor_tokens, args)) {
 	case Opt_sec_krb5p:
-		cifs_dbg(VFS, "sec=krb5p is not supported!\n");
+		cifs_errorf(fc, "sec=krb5p is not supported!\n");
 		return 1;
 	case Opt_sec_krb5i:
 		ctx->sign = true;
@@ -238,7 +238,7 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 		ctx->nullauth = 1;
 		break;
 	default:
-		cifs_dbg(VFS, "bad security option: %s\n", value);
+		cifs_errorf(fc, "bad security option: %s\n", value);
 		return 1;
 	}
 
@@ -291,7 +291,7 @@ cifs_parse_cache_flavor(struct fs_context *fc, char *value, struct smb3_fs_conte
 		ctx->cache_rw = true;
 		break;
 	default:
-		cifs_dbg(VFS, "bad cache= option: %s\n", value);
+		cifs_errorf(fc, "bad cache= option: %s\n", value);
 		return 1;
 	}
 	return 0;
@@ -347,24 +347,24 @@ cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_contex
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	case Smb_1:
 		if (disable_legacy_dialects) {
-			cifs_dbg(VFS, "mount with legacy dialect disabled\n");
+			cifs_errorf(fc, "mount with legacy dialect disabled\n");
 			return 1;
 		}
 		if (is_smb3) {
-			cifs_dbg(VFS, "vers=1.0 (cifs) not permitted when mounting with smb3\n");
+			cifs_errorf(fc, "vers=1.0 (cifs) not permitted when mounting with smb3\n");
 			return 1;
 		}
-		cifs_dbg(VFS, "Use of the less secure dialect vers=1.0 is not recommended unless required for access to very old servers\n");
+		cifs_errorf(fc, "Use of the less secure dialect vers=1.0 is not recommended unless required for access to very old servers\n");
 		ctx->ops = &smb1_operations;
 		ctx->vals = &smb1_values;
 		break;
 	case Smb_20:
 		if (disable_legacy_dialects) {
-			cifs_dbg(VFS, "mount with legacy dialect disabled\n");
+			cifs_errorf(fc, "mount with legacy dialect disabled\n");
 			return 1;
 		}
 		if (is_smb3) {
-			cifs_dbg(VFS, "vers=2.0 not permitted when mounting with smb3\n");
+			cifs_errorf(fc, "vers=2.0 not permitted when mounting with smb3\n");
 			return 1;
 		}
 		ctx->ops = &smb20_operations;
@@ -372,10 +372,10 @@ cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_contex
 		break;
 #else
 	case Smb_1:
-		cifs_dbg(VFS, "vers=1.0 (cifs) mount not permitted when legacy dialects disabled\n");
+		cifs_errorf(fc, "vers=1.0 (cifs) mount not permitted when legacy dialects disabled\n");
 		return 1;
 	case Smb_20:
-		cifs_dbg(VFS, "vers=2.0 mount not permitted when legacy dialects disabled\n");
+		cifs_errorf(fc, "vers=2.0 mount not permitted when legacy dialects disabled\n");
 		return 1;
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
 	case Smb_21:
@@ -403,7 +403,7 @@ cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_contex
 		ctx->vals = &smbdefault_values;
 		break;
 	default:
-		cifs_dbg(VFS, "Unknown vers= option specified: %s\n", value);
+		cifs_errorf(fc, "Unknown vers= option specified: %s\n", value);
 		return 1;
 	}
 	return 0;
@@ -588,14 +588,14 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 
 	if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
-		cifs_dbg(VFS, "SMB Direct requires Version >=3.0\n");
+		cifs_errorf(fc, "SMB Direct requires Version >=3.0\n");
 		return -EOPNOTSUPP;
 	}
 
 #ifndef CONFIG_KEYS
 	/* Muliuser mounts require CONFIG_KEYS support */
 	if (ctx->multiuser) {
-		cifs_dbg(VFS, "Multiuser mounts require kernels with CONFIG_KEYS enabled\n");
+		cifs_errorf(fc, "Multiuser mounts require kernels with CONFIG_KEYS enabled\n");
 		return -1;
 	}
 #endif
@@ -605,13 +605,13 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 
 
 	if (!ctx->UNC) {
-		cifs_dbg(VFS, "CIFS mount error: No usable UNC path provided in device string!\n");
+		cifs_errorf(fc, "CIFS mount error: No usable UNC path provided in device string!\n");
 		return -1;
 	}
 
 	/* make sure UNC has a share name */
 	if (strlen(ctx->UNC) < 3 || !strchr(ctx->UNC + 3, '\\')) {
-		cifs_dbg(VFS, "Malformed UNC. Unable to find share name.\n");
+		cifs_errorf(fc, "Malformed UNC. Unable to find share name.\n");
 		return -ENOENT;
 	}
 
@@ -689,45 +689,45 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 				       struct smb3_fs_context *old_ctx)
 {
 	if (new_ctx->posix_paths != old_ctx->posix_paths) {
-		cifs_dbg(VFS, "can not change posixpaths during remount\n");
+		cifs_errorf(fc, "can not change posixpaths during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->sectype != old_ctx->sectype) {
-		cifs_dbg(VFS, "can not change sec during remount\n");
+		cifs_errorf(fc, "can not change sec during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->multiuser != old_ctx->multiuser) {
-		cifs_dbg(VFS, "can not change multiuser during remount\n");
+		cifs_errorf(fc, "can not change multiuser during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->UNC &&
 	    (!old_ctx->UNC || strcmp(new_ctx->UNC, old_ctx->UNC))) {
-		cifs_dbg(VFS, "can not change UNC during remount\n");
+		cifs_errorf(fc, "can not change UNC during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->username &&
 	    (!old_ctx->username || strcmp(new_ctx->username, old_ctx->username))) {
-		cifs_dbg(VFS, "can not change username during remount\n");
+		cifs_errorf(fc, "can not change username during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->password &&
 	    (!old_ctx->password || strcmp(new_ctx->password, old_ctx->password))) {
-		cifs_dbg(VFS, "can not change password during remount\n");
+		cifs_errorf(fc, "can not change password during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->domainname &&
 	    (!old_ctx->domainname || strcmp(new_ctx->domainname, old_ctx->domainname))) {
-		cifs_dbg(VFS, "can not change domainname during remount\n");
+		cifs_errorf(fc, "can not change domainname during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->nodename &&
 	    (!old_ctx->nodename || strcmp(new_ctx->nodename, old_ctx->nodename))) {
-		cifs_dbg(VFS, "can not change nodename during remount\n");
+		cifs_errorf(fc, "can not change nodename during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->iocharset &&
 	    (!old_ctx->iocharset || strcmp(new_ctx->iocharset, old_ctx->iocharset))) {
-		cifs_dbg(VFS, "can not change iocharset during remount\n");
+		cifs_errorf(fc, "can not change iocharset during remount\n");
 		return -EINVAL;
 	}
 
@@ -934,7 +934,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		 */
 		if ((result.uint_32 < CIFS_MAX_MSGSIZE) ||
 		   (result.uint_32 > (4 * SMB3_DEFAULT_IOSIZE))) {
-			cifs_dbg(VFS, "%s: Invalid blocksize\n",
+			cifs_errorf(fc, "%s: Invalid blocksize\n",
 				__func__);
 			goto cifs_parse_mount_err;
 		}
@@ -952,25 +952,25 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_acregmax:
 		ctx->acregmax = HZ * result.uint_32;
 		if (ctx->acregmax > CIFS_MAX_ACTIMEO) {
-			cifs_dbg(VFS, "acregmax too large\n");
+			cifs_errorf(fc, "acregmax too large\n");
 			goto cifs_parse_mount_err;
 		}
 		break;
 	case Opt_acdirmax:
 		ctx->acdirmax = HZ * result.uint_32;
 		if (ctx->acdirmax > CIFS_MAX_ACTIMEO) {
-			cifs_dbg(VFS, "acdirmax too large\n");
+			cifs_errorf(fc, "acdirmax too large\n");
 			goto cifs_parse_mount_err;
 		}
 		break;
 	case Opt_actimeo:
 		if (HZ * result.uint_32 > CIFS_MAX_ACTIMEO) {
-			cifs_dbg(VFS, "timeout too large\n");
+			cifs_errorf(fc, "timeout too large\n");
 			goto cifs_parse_mount_err;
 		}
 		if ((ctx->acdirmax != CIFS_DEF_ACTIMEO) ||
 		    (ctx->acregmax != CIFS_DEF_ACTIMEO)) {
-			cifs_dbg(VFS, "actimeo ignored since acregmax or acdirmax specified\n");
+			cifs_errorf(fc, "actimeo ignored since acregmax or acdirmax specified\n");
 			break;
 		}
 		ctx->acdirmax = ctx->acregmax = HZ * result.uint_32;
@@ -983,7 +983,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		break;
 	case Opt_max_credits:
 		if (result.uint_32 < 20 || result.uint_32 > 60000) {
-			cifs_dbg(VFS, "%s: Invalid max_credits value\n",
+			cifs_errorf(fc, "%s: Invalid max_credits value\n",
 				 __func__);
 			goto cifs_parse_mount_err;
 		}
@@ -991,7 +991,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		break;
 	case Opt_max_channels:
 		if (result.uint_32 < 1 || result.uint_32 > CIFS_MAX_CHANNELS) {
-			cifs_dbg(VFS, "%s: Invalid max_channels value, needs to be 1-%d\n",
+			cifs_errorf(fc, "%s: Invalid max_channels value, needs to be 1-%d\n",
 				 __func__, CIFS_MAX_CHANNELS);
 			goto cifs_parse_mount_err;
 		}
@@ -1000,7 +1000,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_handletimeout:
 		ctx->handle_timeout = result.uint_32;
 		if (ctx->handle_timeout > SMB3_MAX_HANDLE_TIMEOUT) {
-			cifs_dbg(VFS, "Invalid handle cache timeout, longer than 16 minutes\n");
+			cifs_errorf(fc, "Invalid handle cache timeout, longer than 16 minutes\n");
 			goto cifs_parse_mount_err;
 		}
 		break;
@@ -1011,23 +1011,23 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		case 0:
 			break;
 		case -ENOMEM:
-			cifs_dbg(VFS, "Unable to allocate memory for devname\n");
+			cifs_errorf(fc, "Unable to allocate memory for devname\n");
 			goto cifs_parse_mount_err;
 		case -EINVAL:
-			cifs_dbg(VFS, "Malformed UNC in devname\n");
+			cifs_errorf(fc, "Malformed UNC in devname\n");
 			goto cifs_parse_mount_err;
 		default:
-			cifs_dbg(VFS, "Unknown error parsing devname\n");
+			cifs_errorf(fc, "Unknown error parsing devname\n");
 			goto cifs_parse_mount_err;
 		}
 		ctx->source = kstrdup(param->string, GFP_KERNEL);
 		if (ctx->source == NULL) {
-			cifs_dbg(VFS, "OOM when copying UNC string\n");
+			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
 		fc->source = kstrdup(param->string, GFP_KERNEL);
 		if (fc->source == NULL) {
-			cifs_dbg(VFS, "OOM when copying UNC string\n");
+			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
 		break;
@@ -1047,7 +1047,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		ctx->username = kstrdup(param->string, GFP_KERNEL);
 		if (ctx->username == NULL) {
-			cifs_dbg(VFS, "OOM when copying username string\n");
+			cifs_errorf(fc, "OOM when copying username string\n");
 			goto cifs_parse_mount_err;
 		}
 		break;
@@ -1059,7 +1059,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 
 		ctx->password = kstrdup(param->string, GFP_KERNEL);
 		if (ctx->password == NULL) {
-			cifs_dbg(VFS, "OOM when copying password string\n");
+			cifs_errorf(fc, "OOM when copying password string\n");
 			goto cifs_parse_mount_err;
 		}
 		break;
@@ -1086,7 +1086,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		kfree(ctx->domainname);
 		ctx->domainname = kstrdup(param->string, GFP_KERNEL);
 		if (ctx->domainname == NULL) {
-			cifs_dbg(VFS, "OOM when copying domainname string\n");
+			cifs_errorf(fc, "OOM when copying domainname string\n");
 			goto cifs_parse_mount_err;
 		}
 		cifs_dbg(FYI, "Domain name set\n");
@@ -1110,7 +1110,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			kfree(ctx->iocharset);
 			ctx->iocharset = kstrdup(param->string, GFP_KERNEL);
 			if (ctx->iocharset == NULL) {
-				cifs_dbg(VFS, "OOM when copying iocharset string\n");
+				cifs_errorf(fc, "OOM when copying iocharset string\n");
 				goto cifs_parse_mount_err;
 			}
 		}
@@ -1190,7 +1190,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		break;
 	case Opt_witness:
 #ifndef CONFIG_CIFS_SWN_UPCALL
-		cifs_dbg(VFS, "Witness support needs CONFIG_CIFS_SWN_UPCALL config option\n");
+		cifs_errorf(fc, "Witness support needs CONFIG_CIFS_SWN_UPCALL config option\n");
 			goto cifs_parse_mount_err;
 #endif
 		ctx->witness = true;
@@ -1289,7 +1289,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		break;
 	case Opt_fsc:
 #ifndef CONFIG_CIFS_FSCACHE
-		cifs_dbg(VFS, "FS-Cache support needs CONFIG_CIFS_FSCACHE kernel config option set\n");
+		cifs_errorf(fc, "FS-Cache support needs CONFIG_CIFS_FSCACHE kernel config option set\n");
 		goto cifs_parse_mount_err;
 #endif
 		ctx->fsc = true;
@@ -1310,15 +1310,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		if (result.negated) {
 			ctx->nopersistent = true;
 			if (ctx->persistent) {
-				cifs_dbg(VFS,
-				  "persistenthandles mount options conflict\n");
+				cifs_errorf(fc, "persistenthandles mount options conflict\n");
 				goto cifs_parse_mount_err;
 			}
 		} else {
 			ctx->persistent = true;
 			if ((ctx->nopersistent) || (ctx->resilient)) {
-				cifs_dbg(VFS,
-				  "persistenthandles mount options conflict\n");
+				cifs_errorf(fc, "persistenthandles mount options conflict\n");
 				goto cifs_parse_mount_err;
 			}
 		}
@@ -1329,8 +1327,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		} else {
 			ctx->resilient = true;
 			if (ctx->persistent) {
-				cifs_dbg(VFS,
-				  "persistenthandles mount options conflict\n");
+				cifs_errorf(fc, "persistenthandles mount options conflict\n");
 				goto cifs_parse_mount_err;
 			}
 		}
-- 
2.30.0


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

--=-=-=--

