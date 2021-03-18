Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93837C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5445264E28
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCRNL3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 09:11:29 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31333 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231126AbhCRNL0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 18 Mar 2021 09:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616073085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KH3v+UY7D2qLBd951BDUULV/6XK8mh8q0h27l/gWn1I=;
        b=C8aaH8UKMoeevAHlmqBjIRRlC7UE+9glhuK5l4oCjfjDWfCYF1LY/mu1T0k6pxz1nQaNO9
        VHQdSuvaKmwCSAELkOVlpK6CWKjFosB/W+tnG4faI2QbwJtSPOpgtyPg+GZTGEnQqTQ1PX
        GdfLN0uYvtlHjxa0xyJ7D2T8FHvBofQ=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2109.outbound.protection.outlook.com [104.47.17.109])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-Fu8pI-0JN1KRwlQ84aiZQQ-1; Thu, 18 Mar 2021 14:11:23 +0100
X-MC-Unique: Fu8pI-0JN1KRwlQ84aiZQQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BevQQ/n24aolbL3W0u/X5qT+l/ErdUpIpEgAFv83hoyGavDklfQUAX+i++zV8igMgJCWC+f8uWsBqqXFtq05Yf0aQgLhWqpDpAQrpI1Dj+hMHPJkxoazpFDEL4gk0ZCCUUdQb66+jFjXO9DabxsoMugqyVr1qvFBP1eNj3Ci0BKdf96MhybiNDVP8blaYNK5+x5FM4i5TFX9VXKRGUK/Q5HisI9SmSDcn541GFygasECsKnXgKSERo0cyzFMNBhXElDmt7Atv3e6NyfqvGyr+PxrjliwbsHNA1IzeLILs/BiE8NMc5cq7PWedn+Xm7TjkMb0iDypD0VceyJHLgDLDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KH3v+UY7D2qLBd951BDUULV/6XK8mh8q0h27l/gWn1I=;
 b=oASD74VASuDWX/4UTYLM9HedmCjCq+z0DBmmttOdwsqPKwfmz6Sy1ILiA35rOoR0a8suq5XTPyE9C88uFYpvWZEbX/X4DyUXaCXuzzFNF4YjUxyso7x2++wvfVC05vVs9C/04P/q2NTh+PihZs+z8NmIJ4lcGgXGkfMy0A4pSlCKmxmU+VBCOgqiNSbM9ThZl6+N9p6SxiGwWWOlMkmPszCWNAvjALr4e/PbunZ6ILFadh1DTopIStu8Eur1h4/SrrVomhyzMUJKhVZGmNODlF3YumaOVqUY09osAhopUq9qejuC0glNYNLn5nx4+3vOwPF0tR1UaJQcfinTVoS7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5390.eurprd04.prod.outlook.com (2603:10a6:803:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 13:11:06 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.032; Thu, 18 Mar 2021
 13:11:06 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [EXPERIMENT v2] new mount API verbose errors from userspace
In-Reply-To: <87eegouqo8.fsf@suse.com>
References: <87k0qoxz7r.fsf@suse.com> <87tupuya6t.fsf@suse.com>
 <CAN05THRV_Tns4MTO-GFNg0reR+HJKa1BCSQ0m23PTSryGNPCeg@mail.gmail.com>
 <181014.1615311429@warthog.procyon.org.uk> <87eegouqo8.fsf@suse.com>
Date:   Thu, 18 Mar 2021 14:10:58 +0100
Message-ID: <87eegcsj31.fsf@suse.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-Originating-IP: [2003:fa:700:2866:22c7:97d:4e03:1280]
X-ClientProxiedBy: AM4PR0101CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2866:22c7:97d:4e03:1280) by AM4PR0101CA0052.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 13:11:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a76ad721-6fd4-4420-99b9-08d8ea0f47e3
X-MS-TrafficTypeDiagnostic: VI1PR04MB5390:
X-Microsoft-Antispam-PRVS: <VI1PR04MB539095F5346E2113E17D3A83A8699@VI1PR04MB5390.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FSqIL+wf2k2r+U3zkhVKdM/PxRmeE9SQiXfbIsuwACQt8Gbhf/R84+IcBx9XcinqPmD+/ZfT2Qw+wcg9akb4O443xeFqJDFIJ0HwP7VR6wm+zCFC6gBHqD7F0nWe1j7gBghjPB8CWH4F8fg3+N3I0k99Pq6y8HT24dmPAMoxawAlmoZeLFgkV2emtRxm44F9m5K4JCRutvOiZUWr82M0KV8psAit3XKafaiLNcGG6soyF+UsMgwH5B3o5LkeGskeGt9RZfgIvY2zU9lHT6G5xzZIvVJtSjD2WeYxHypvpu+Y8UpkVc6R7Yje/yWKbovzbI4MHot9QNlUAuL7ZvLqMKE4EvIHjpOSYD2j0TbuwIRHWQDWcT4Ra6svKoGDTGjFS8kNv/bJzXyKn8uCiDh6Sp1frxYP2oMkjA6YZ5SntZ0nnjZTH99khv4zsx/lIql2OsswY/PyX5unDkZWwD/mH2O8LIiA63wk6De4FczKSboLjB4MOzUbp9LD2Z9XdI8xNt6hfSm2y7WQQe0DGmq3j3SErJ0Y+rgFxPng38T/HJcyoPuo88XDOCll+sWPbnVKmQMx+KYOACb8KKaYYvGIdYuBuC2FT00nVsPTLJ9uwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(136003)(39860400002)(346002)(316002)(5660300002)(2906002)(52116002)(6916009)(38100700001)(478600001)(6486002)(66946007)(66476007)(66576008)(66556008)(235185007)(36756003)(54906003)(2616005)(8936002)(86362001)(33964004)(16526019)(186003)(4326008)(6496006)(6666004)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E9bUH3ZJdBDsWZvqBFXgWUYU3STxp6lDlLzbzUjBSOIg/k5mfVfgzUyq9HVQ?=
 =?us-ascii?Q?GpzfGlL68TQJaV4trvZWdNt+N4BZ9kBiM26F1kcfM2IZYo2UYtbjfZRygFRC?=
 =?us-ascii?Q?j+aUWNVOjgR7vlK/2/yS2AYTUm2EOmjDiY/NdJchO+dmRniyY+z2D/nweqPo?=
 =?us-ascii?Q?SFsSU8y9Ca0Cx2Ja8jFsz0cnQzbevGypBwh7EwKjw26iHm3suzV8pWVDfPQH?=
 =?us-ascii?Q?1R1kRhbW2UqVPqtcMbNbdA8xwjiHjDJ7JbsKxSnF//vRyoYVM4edylc+FF9j?=
 =?us-ascii?Q?+CwqZBblefj6EL2/eymU9PNRokSNVtugV+52wR185QDbcZTwa/dJB8VE8B04?=
 =?us-ascii?Q?MY+kc2SKbP3O0THKev+eUacU03LYJTysucMItw94kt2gSraZlEOMWqIYlCuK?=
 =?us-ascii?Q?zwS9dM5z8RcPKyTtxpIciq+Yk4l/fA1fls9oOCmkcM7LYKx3CHKL5PQ/21aD?=
 =?us-ascii?Q?5tcjfFQQwXd/+cN/HIaK/YDJezoBif9MSH5AQfP6Mr6VrW7U0idjD6CThb6h?=
 =?us-ascii?Q?mDn64iFbWWCzB6alzw/Wt4SFCyWvlIevoe115pBIRoa1dIoJQCFHcB1gdXWw?=
 =?us-ascii?Q?ijY2VZ1sZlFK+1WnghJLATgFrCOp6ajDd6G2YxPQCvfRXBwGq7H8qKgyiu5v?=
 =?us-ascii?Q?3vRJ0NYxeis9T3OWbbSthPWfGiM4DWJ3mlZNzbFB5mX983/3NJ3zbeMvwoz0?=
 =?us-ascii?Q?ywaA+xUaeMSADFMA6nENPLGMitfDz+JQhQ3kcm63zQIMQt/30T3LGoq+oXbf?=
 =?us-ascii?Q?hmsT2xIIFX6/s3OH4N03pIF0DjhYJbZvQ1Yf/bUOoOonmjOHQLDFsj1ZgGtc?=
 =?us-ascii?Q?qfqNAmWxy6VEny57xlaoqXkl7lOBFV7op9OJg1ef+kmdVQJfpkNknubZaULz?=
 =?us-ascii?Q?2hX0YwSPqFqH7YxS0dEokMcY93c+LJK8YT2KLLgW147UyyGCQTtgpnxeX4mU?=
 =?us-ascii?Q?Cioosss1QY2LPVosxBCO5ps07YjWYH3Oc3jVKs+vF0ujxrtQxG7X/Kait7ip?=
 =?us-ascii?Q?NJrE3uI3p9bQHVMuRobrbtx/2nu7zISjam4AGVe42BbZXs6v48AfMTzpPp2w?=
 =?us-ascii?Q?T9Z2RB9VLcv+tY9qRGqqjx+o6dSzS86Xt8GM/npDPoyupBk1OXN1IzLybuza?=
 =?us-ascii?Q?I2C7yY6fdz73pbA2UaIrfPGKUumqGx2Uu943OBDU4Fvh+mqAdkaSQhnnZD4n?=
 =?us-ascii?Q?8WBAk0TLFLKsy6iCKlWnWjbrzMwM4jLQTWr1GnH99efw3TQ8YceAencQdEWD?=
 =?us-ascii?Q?rG/iAjwEOIpQyDtqa/p6+FCRC0XKAeT5aRLTe5KiItCFD0z6xJy1UmtYe0I3?=
 =?us-ascii?Q?B040/U5x0NA8gdacXM4P9C2mOhzA5ckR+PKupmReZxZupKmCKlYnLvzb6u59?=
 =?us-ascii?Q?QDPdTrxvdOcgMsZ11ViIRiBWbt2+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76ad721-6fd4-4420-99b9-08d8ea0f47e3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 13:11:06.0601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NX63QlxtUFrhuTRrvxwvSrYPBxcyZRW75etm0YDRKJW8PVIqiyRlNkL5H5ZBVZV/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5390
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain


Since there's no standard VFS way to get the supported mount options
from userspace, I thought I would do what Ronnie suggested and export
them from a cifs /proc file.
That's the only change since v1, in the 4th patch.

David, maybe this can give your arguments for the need for fsinfo() if
we end up using this in cifs-utils.

I have added some dumb code in userspace to parse it and see if the
option exists and what type it is. This removes the requirement of
having to keep cifs-utils and kernel updated at the same time to use new
options.

Previous intro
=======================================================================
I have some code to use the new mount API from user space.

The kernel changes are just making the code use the fs_context logging
feature.

The sample userspace prog (fsopen.c attached) is just a PoC showing how
mounting is done and how the mount errors are read.

If you change the prog to use a wrong version for example (vers=4.0) you
get this:

    $ gcc -o fsopen fsopen.c
    $ ./fsopen
    fsconfig(sfd, FSCONFIG_SET_STRING, "vers", "4.0", 0): Invalid argument
    kernel mount errors:
    e Unknown vers= option specified: 4.0

The pros are that we process one option at a time and we can fail early
with verbose, helpful messages to the user.
=======================================================================


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=fs_context_log_v2.patches

From bc10ad8b3c157d35c826de406a85d128bd10402d Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Mon, 1 Mar 2021 19:25:00 +0100
Subject: [PATCH 1/4] cifs: make fs_context error logging wrapper

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


From ec1754edf2e459e39237a396abaef73077664f87 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Mon, 1 Mar 2021 19:32:09 +0100
Subject: [PATCH 2/4] cifs: add fs_context param to parsing helpers

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


From 9b3e47778c1a4128ecc1d1ccdc2df9ffc4ff35bc Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Mon, 1 Mar 2021 19:34:02 +0100
Subject: [PATCH 3/4] cifs: log mount errors using cifs_errorf()

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


From 145f76e57197611766d4830ce94be74ff0249d50 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Thu, 18 Mar 2021 13:52:59 +0100
Subject: [PATCH 4/4] cifs: export supported mount options via new mount_params
 /proc file

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifs_debug.c | 49 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 88a7958170ee..0f3e64667a35 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -17,6 +17,7 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#include "fs_context.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
@@ -702,6 +703,7 @@ static const struct proc_ops cifs_lookup_cache_proc_ops;
 static const struct proc_ops traceSMB_proc_ops;
 static const struct proc_ops cifs_security_flags_proc_ops;
 static const struct proc_ops cifs_linux_ext_proc_ops;
+static const struct proc_ops cifs_mount_params_proc_ops;
 
 void
 cifs_proc_init(void)
@@ -726,6 +728,8 @@ cifs_proc_init(void)
 	proc_create("LookupCacheEnabled", 0644, proc_fs_cifs,
 		    &cifs_lookup_cache_proc_ops);
 
+	proc_create("mount_params", 0444, proc_fs_cifs, &cifs_mount_params_proc_ops);
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	proc_create("dfscache", 0644, proc_fs_cifs, &dfscache_proc_ops);
 #endif
@@ -1023,6 +1027,51 @@ static const struct proc_ops cifs_security_flags_proc_ops = {
 	.proc_release	= single_release,
 	.proc_write	= cifs_security_flags_proc_write,
 };
+
+static int cifs_mount_params_proc_show(struct seq_file *m, void *v)
+{
+	const struct fs_parameter_spec *p;
+	const char *type;
+
+	for (p = smb3_fs_parameters; p->name; p++) {
+		/* cannot use switch with pointers... */
+		if (!p->type) {
+			if (p->flags == fs_param_neg_with_no)
+				type = "noflag";
+			else
+				type = "flag";
+		}
+		else if (p->type == fs_param_is_bool)
+			type = "bool";
+		else if (p->type == fs_param_is_u32)
+			type = "u32";
+		else if (p->type == fs_param_is_u64)
+			type = "u64";
+		else if (p->type == fs_param_is_string)
+			type = "string";
+		else
+			type = "unknown";
+
+		seq_printf(m, "%s:%s\n", p->name, type);
+	}
+
+	return 0;
+}
+
+static int cifs_mount_params_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cifs_mount_params_proc_show, NULL);
+}
+
+static const struct proc_ops cifs_mount_params_proc_ops = {
+	.proc_open	= cifs_mount_params_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	/* No need for write for now */
+	/* .proc_write	= cifs_mount_params_proc_write, */
+};
+
 #else
 inline void cifs_proc_init(void)
 {
-- 
2.30.0


--=-=-=
Content-Type: text/x-csrc
Content-Disposition: attachment; filename=fsopen.c

/*
 * PoC for using new mount API for mount.cifs
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

/*
 * For MS_*, MNT_* constants
 */
#include <sys/mount.h>

/*
 * For FSCONFIG_*, FSMOUNT_*, MOVE_* constants
 *
 * TODO: need to add configure check for header availability
 */
#include <linux/mount.h>

/*
 * For AT_* constants
 */
#include <fcntl.h>

/*
 * The new mount API syscalls have currently no wrappers in
 * glibc. Call them via syscall().
 *
 * Wrap in #ifdef to be future-proof once they eventually get wrappers
 *
 * TODO: add configure checks for fsopen symbol -> HAVE_FSOPEN
 */
#ifndef HAVE_FSOPEN
#include <sys/syscall.h>
#ifndef SYS_fsopen
enum {SYS_move_mount=429, SYS_fsopen, SYS_fsconfig, SYS_fsmount};
#endif
int fsopen(const char *fsname, unsigned int flags)
{
	return syscall(SYS_fsopen, fsname, flags);
}
int fsmount(int fd, unsigned int flags, unsigned int mount_attrs)
{
	return syscall(SYS_fsmount, fd, flags, mount_attrs);
}
int fsconfig(int fd, unsigned int cmd, const char *key, const void *value, int aux)
{
	return syscall(SYS_fsconfig, fd, cmd, key, value, aux);
}
int move_mount(int from_dirfd, const char *from_pathname, int to_dirfd, const char *to_pathname, unsigned int flags)
{
	return syscall(SYS_move_mount, from_dirfd, from_pathname, to_dirfd, to_pathname, flags);
}
#endif

/*
 * To get the kernel log emitted after a call, simply read the context fd
 *
 *     "e <message>"
 *            An error message string was logged.
 *
 *     "i <message>"
 *            An informational message string was logged.
 *
 *     "w <message>"
 *            An warning message string was logged.
 *
 *     Messages are removed from the queue as they're read.
 *
 */
void print_context_log(int fd)
{
	char buf[512];
	ssize_t rc;
	int first = 1;

	while (1) {
		memset(buf, 0, sizeof(buf));
		rc = read(fd, buf, sizeof(buf)-2);
		if (rc == 0 || (rc < 0 && errno == ENODATA)) {
			errno = 0;
			break;
		}
		else if (rc < 0) {
			perror("read");
			break;
		}
		if (first) {
			printf("kernel mount errors:\n");
			first = 0;
		}
		printf("%s", buf);
	}
}

#define ASSERT(x)					\
	do {						\
		if (!(x)) {				\
			printf("ASSERT FAIL %s\n", #x); \
			exit(1);			\
		}					\
	} while (0)

#define CHECK(x)				\
	do {					\
		if ((x) < 0) {			\
			perror(#x);		\
			exit(1);		\
		}				\
	} while (0)

#define CHECK_AND_LOG(fd, x)			\
	do {					\
		if ((x) < 0) {			\
			perror(#x);		\
			print_context_log(fd);	\
			exit(1);		\
		}				\
	} while (0)

char *g_mount_params;

/* read whole file in g_mount_params buffer */
void read_mount_params(void)
{
	int fd;
	size_t off;
	ssize_t rc;
	size_t size;

	off = 0;
	size = 2048;
	g_mount_params = malloc(size);
	if (!g_mount_params)
		goto out;

	g_mount_params[off++] = '\n';

	fd = open("/proc/fs/cifs/mount_params", O_RDONLY);
	if (fd < 0)
		goto out;

	do {
		if (size - off <= 1) {
			void *p = realloc(g_mount_params, size*2);
			if (!p)
				goto err;
			size *= 2;
			g_mount_params = p;
		}
		rc = read(fd, g_mount_params+off, size-off-1);
		if (rc < 0)
			goto err;
		off += rc;
		g_mount_params[off] = 0;
	} while (rc > 0);
out:
	if (fd >= 0)
		close(fd);
	printf("%s", g_mount_params);
	return;
err:
	free(g_mount_params);
	g_mount_params = NULL;
	goto out;
}

/* Dumb string search in the buffer */
enum {PARAM_FLAG, PARAM_STRING, PARAM_U32, PARAM_U64};
int param_type(const char *name)
{
	char needle[128] = {0};
	snprintf(needle, sizeof(needle)-1, "\n%s:", name);

	char *p = strstr(g_mount_params, needle);
	if (!p)
		return -1;
	p = strchr(p, ':');
	if (!p)
		return -1;
	if (!*p || !*(p+1) || !*(p+2))
		return -1;

	char *beg = p+1;
	char *end = strchr(beg, '\n');

	if (strncmp(beg, "flag", end-beg) == 0)
		return PARAM_FLAG;
	if (strncmp(beg, "noflag", end-beg) == 0)
		return PARAM_FLAG;
	if (strncmp(beg, "string", end-beg) == 0)
		return PARAM_STRING;
	if (strncmp(beg, "u32", end-beg) == 0)
		return PARAM_U32;
	if (strncmp(beg, "u64", end-beg) == 0)
		return PARAM_U64;
	return -1;
}

int main(void)
{
	int sfd;
	int mfd;

	/*
	 * Test param type detection
	 */
	read_mount_params();
	ASSERT(param_type("non-existing") < 0);
	ASSERT(param_type("ip") == PARAM_STRING);
	ASSERT(param_type("max_channels") == PARAM_U32);
	ASSERT(param_type("mfsymlinks") == PARAM_FLAG);
	ASSERT(param_type("nodfs") == PARAM_FLAG);
	ASSERT(param_type("user_xattr") == PARAM_FLAG);
	ASSERT(param_type("prefixpath") == PARAM_STRING);

	/*
	 * Converting following old-style mount syscall to new mount api
	 *
	 *   mount(
	 *     "//192.168.2.110/data",
	 *     "/mnt/test",
	 *     "cifs",
	 *     0,
	 *     "ip=192.168.2.110,unc=\\\\192.168.2.110\\data,vers=3.0,user=administrator,pass=my-pass"
	 *   )
	 *
	 */

	CHECK(sfd = fsopen("cifs", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "source", "//192.168.2.110/data", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "ip", "192.168.2.110", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "unc", "\\\\192.168.2.110\\data", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "vers", "3.0", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "user", "administrator", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "pass", "my-pass", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0));
	CHECK_AND_LOG(sfd, (mfd = fsmount(sfd, FSMOUNT_CLOEXEC, 0)));
	CHECK(move_mount(mfd, "", AT_FDCWD, "/mnt/test", MOVE_MOUNT_F_EMPTY_PATH));
	return 0;
}

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

--=-=-=--

