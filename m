Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37D7C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 17:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D6564EB9
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 17:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhCRRzx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 13:55:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:60038 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232481AbhCRRzl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 18 Mar 2021 13:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616090140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iCzBvdiHO00gnuGHcfZ43Jcerr9JLy9+KCKPDNGXeLs=;
        b=k6VkMjskGXu+5OeYzMOKoBVKthbCjtw+CJ+a9ElN5oLDZm+fmAbCQC6hRe3e99ca9Dguva
        ubv+OSMYI6YxwKwOo2t6whf3ANhCqJuGs++x41/REbmPSvJBOiKVUPZQodm1k0tQgDGyWs
        OgHqLudiJQ79/efqGfpavuEJ8JhJ+80=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2051.outbound.protection.outlook.com [104.47.4.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-_461i5UePAyOoqc0YvRYEg-1; Thu, 18 Mar 2021 18:55:39 +0100
X-MC-Unique: _461i5UePAyOoqc0YvRYEg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zo0Lyjrip3g3SO+gYAVeOoVjHvUiVog+Levs9Mb9RKb44oe2rTT4OaJqzfXftjRXiSMG3zPe2Vrb9evjT5G7/tgLtqZwtBSiup3FdadyluhwSh36FNN3wJK/rv1UAI8IWM+xa9qagHzMJ9B8s2LtMKOGrZfHW/E2XE/u8vmCwfott41cfn3au1aoJVhzSeqJopFHAsGZQmIchqjfZW20dO3XQyo4At5m1kBen0KjBl1e0nXTzLLa2O0Gy8uOtrQYiUTihNiRKi756cdTXwkVGy87jbifIaSEBPj07vN6cGOnNs0vB2tbbiBpgSoT6FbfUW/J2WzfQtDjTPwkjtlClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NulHWdj1/4fFXYoHRb4fcSmmhSzMqThkQX0IuxJHpB8=;
 b=gonzbsuh6jiDwPAX6RIvoEyzTigBlP9cpTEoso/VTZSrYXGGS0DwKNebRyy4qj861yupC105/DcWVYFLOZ7+WOagHYoW7KEPrpNKmZo6hgIXu3Whqv7CFFekKr9oB2wxVoz8WVQGoDh9BZk6ZOyZozfWfUFhD/2YLo9qy7Me72sSsR2BuZej+29Cc0qugCXmuyJ9GTC1t+GoOOtDlZ32RSxJRYcLH7s5pdr0n5WmnpmL7KljbBGY0gaePpdlKeng9cqdq1+i2TKgLXOcU8zDMNLj8qOhOsNEqpBYEJMjBgopZ4Mg7/rWzcUX9ryCTGO/aMYwTNjz9wjy1zbuNG6UWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4671.eurprd04.prod.outlook.com (2603:10a6:803:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 17:55:38 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.032; Thu, 18 Mar 2021
 17:55:38 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, scabrero@suse.com,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1] cifs: simplify SWN code with dummy funcs instead of ifdefs
Date:   Thu, 18 Mar 2021 18:55:31 +0100
Message-ID: <20210318175531.30565-1-aaptel@suse.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:700:2866:22c7:97d:4e03:1280]
X-ClientProxiedBy: ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2866:22c7:97d:4e03:1280) by ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 17:55:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7844882-789d-4428-5681-08d8ea3709ac
X-MS-TrafficTypeDiagnostic: VI1PR04MB4671:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB46711E2FD3A4EC157B100E6FA8699@VI1PR04MB4671.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:75;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: okorPUoQvOs4dZ5YiG/T1i0dMWEcgEXL4ONTOMGUVaxdXxnOONafwGKC85su0NEOeQSFgAWlE0IeDK9h6MOwsXbPxxdg5otiFGpoSCQw+Zp4Nvw5q86bgjwDfinZXyLcktRQM5G5vIQnR08JPr3BNoYKxrZCvGM3A2pLgDDirSas+HNZif+fSTuM/TM3ScneHq2X9/E6WAehfMkewdRBY9Uo1nA8xIpXQcA2KZXgwpxlfNXW4Xr9AN0IAwxuXCJLd7xYa4oG2fOqqtTQk9LZcrEHc7IBjOhFZoHcCCy2mbOrM1TMGQlrtX351w80cL/EL3OCnNiRLA5SjIVpSGao1OD6rfh2ihJi3msOh/KkUgz+WJgPW1Kr0VGX1OmHxFrdsyKbUDdbt0+Y31G4dIBgNTwpJ7Ah6Cq4P8lHdmIZd/elCLYq6oC7pLd3PidolWusVPO50Aw2qqcozvmtrmRLbnwH+aaxwY/yiC0LoPANOe/leiHUBUUenI/6n05MMDyrZRnNFtM1g06/QwShfTKHpiOdGHPT+8Nm1GDAulHNJzvOceY6AnDFkxJsp5enk3igkstsqZgfNEaGa72iLfPBGVIsvrcYaDsY3jkt5r7YTb8sFqtJ+uh3D7hV/5TsEgQN4x2TOj2otz2cGrZ+w2+vm5sBmoUa2T36BgCjiN6cTGOAXYY9hd4d4cqmclskJr6saRlW8B8t3goY02N8Oa/Sff/qPlcCnZyxT8w5eYpCPCZ0vUOS6ZnVECskWv3F1kriN53c8SEVZh1CJWf7BssdZTB71HzrwxTG2Lmjvt6Vm6GWW6d35giqMKX3/dG7DQo7FTFWON+C24PDMC6S/pUfJQldTfjvIElpayTNsYUNbusHz1f7P0IeMquzm6QwDsCkFej19w3PmBPcC3poqP5evjljrTTfqt36HgAfYitN8UNBFlDgZjWtCcaFiepQFKWOMTY
 QYusmZmta+BD22j3Ijw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(346002)(136003)(396003)(366004)(376002)(39860400002)(8676002)(6916009)(2616005)(6666004)(8936002)(83380400001)(478600001)(38100700001)(1076003)(4326008)(186003)(6496006)(66556008)(2906002)(86362001)(66946007)(16526019)(36756003)(6486002)(66476007)(107886003)(316002)(52116002)(5660300002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uZaJJYxTNiziui31vLcNXW8Vt8TNooEr6ebbKa3jO+AGaimACBP5TGMjfg32?=
 =?us-ascii?Q?wo1PzzViyqC6nBL5pAurLXFHGS2i7fyAFnVle68FtyF1IsPbgRhhUuECd1ta?=
 =?us-ascii?Q?Bivxiyqod4/pGsBiq4InW3bDzUDyXAtDGYt5W8VX2uukKbrjodIG2XzOgxMy?=
 =?us-ascii?Q?qiP+4WzA0zGWlzgZ8dghKNleU72fbp2o3mCuUkMjRSXb7O/DR+drYtYdZxwd?=
 =?us-ascii?Q?XZ0Ka5winDJ+AeyLdCZGIhB6/g1weCJ+uuFvNQRFMlzVGSUtTOJb5DBHfnli?=
 =?us-ascii?Q?GJaqj5L3PNmO+WLwK1wm5rEAv8z1f/ZmVMXb2Vk4r843GXfHuO09qr4VB5pV?=
 =?us-ascii?Q?YrfTuMoWfVXiQdcmLTrs0UaZA+7r5TmdS3Jpaq3Mda2FiM19tukgIMKtMQ5V?=
 =?us-ascii?Q?WBFlQL9dZ0c2VLflgNLDkC7f3MUSHYpXkjbb/1DPsbu0zAWRZ08tywAH7cbZ?=
 =?us-ascii?Q?jvZ/5waexEGDRWmu+HJtsXmNv+KlpXje/LOyqX7iLbC6Xtr54u/zk+8DS5nU?=
 =?us-ascii?Q?CyBUU9xS634ybsrbI7A12dMzmKeNQZcUEKsAP1Jj12pKQnXwRSqNy0adU1qY?=
 =?us-ascii?Q?l+GQIr+JQLIWsOiF2ulZpfMIbqbE8BBzh5avpH3GB39F1zygvOKExPS8QWvj?=
 =?us-ascii?Q?x644ZQ3dPlCEft2tCayvAU6xGhOuHGbiIUVTXnDelehNJ/OONIjX1b8YnAun?=
 =?us-ascii?Q?4eIDZEiw6zNxakoNQrb7Z1t+6OI74JjJFYi2mSas+ZREYn3Jh4LIp/XKBIFw?=
 =?us-ascii?Q?WXnUXEUCzs5cYt4g+MaXjEA+JWjJ3eHJcFOF6VZ2gYucYZfm2CyCoAEnq/AF?=
 =?us-ascii?Q?VK0VhI1ebesfafOXN/oUnDU/aEqwkIX6K21L//VZFdhmP/yaIXDiCXtECCkx?=
 =?us-ascii?Q?N3uGnNkwP2xwh0UJ8XRRi4OonhBeN5GFK/6tCn8G70j1IYsXfhIP+Z2t7s/Z?=
 =?us-ascii?Q?AtXi5UCYTkMWgsN4kNhF6+pamtE8vGLloGfaUnuLCl7XqDKAOUfevvcA8jLo?=
 =?us-ascii?Q?0vlmoVpOdLKrYsWSqAB3uHvdz49gxrLm8Mnv3at6w4TPNyLM2rImuZLOyEgz?=
 =?us-ascii?Q?XDRNe+OdxrwNC0f89X44CZtmI0lot/dbliuMSfuZiDNta41829YlqpaOPjWB?=
 =?us-ascii?Q?jOowPwAxu3oA/Wwcnfo8sOo95lZsTXpSfWxgFFClDTXipjQi15+PoGnuWL1r?=
 =?us-ascii?Q?iWdYtW5eZNkHG/qjSB52OjdVXKNDJcmvSMOS9xGdsNEZjc4Lz8uueTU6kQxu?=
 =?us-ascii?Q?fhQns1DAdY1kDJLsSHfwJmbJch5Bz0bhaoiJKhMm3LzPbZMJ4c3C5d1cD8hQ?=
 =?us-ascii?Q?PVdHhaOhdEYBsi1axNcCsm8K7iN3iUANpfI5j+nAa0RcgW7O9imkkayqDAEj?=
 =?us-ascii?Q?wgUc7JO5KhMkD7EGrRCbWBLlrojk?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7844882-789d-4428-5681-08d8ea3709ac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 17:55:38.0254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bygcl7teeMyjFpepYRlXD0UEUcPgh26okS+kc1sWOsq0odgry5gZ1K2C6bvhHN8f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4671
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

This commit doesn't change the logic of SWN.

Add dummy implementation of SWN functions when SWN is disabled instead
of using ifdef sections.

The dummy functions get optimized out, this leads to clearer code and
compile time type-checking regardless of config options with no
runtime penalty.

Leave the simple ifdefs section as-is.

A single bitfield (bool foo:1) on its own will use up one int. Move
tcon->use_witness out of ifdefs with the other tcon bitfields.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifs_debug.c |  8 +-------
 fs/cifs/cifs_swn.h   | 27 +++++++++++++++++++++++++++
 fs/cifs/cifsfs.c     |  2 --
 fs/cifs/cifsglob.h   |  4 +---
 fs/cifs/connect.c    | 26 ++++----------------------
 5 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 0f3e64667a35..e19ddfb2b741 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -24,9 +24,7 @@
 #ifdef CONFIG_CIFS_SMB_DIRECT
 #include "smbdirect.h"
 #endif
-#ifdef CONFIG_CIFS_SWN_UPCALL
 #include "cifs_swn.h"
-#endif
=20
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -119,10 +117,8 @@ static void cifs_debug_tcon(struct seq_file *m, struct=
 cifs_tcon *tcon)
 		seq_printf(m, " POSIX Extensions");
 	if (tcon->ses->server->ops->dump_share_caps)
 		tcon->ses->server->ops->dump_share_caps(m, tcon);
-#ifdef CONFIG_CIFS_SWN_UPCALL
 	if (tcon->use_witness)
 		seq_puts(m, " Witness");
-#endif
=20
 	if (tcon->need_reconnect)
 		seq_puts(m, "\tDISCONNECTED ");
@@ -491,10 +487,8 @@ static int cifs_debug_data_proc_show(struct seq_file *=
m, void *v)
=20
 	spin_unlock(&cifs_tcp_ses_lock);
 	seq_putc(m, '\n');
-
-#ifdef CONFIG_CIFS_SWN_UPCALL
 	cifs_swn_dump(m);
-#endif
+
 	/* BB add code to dump additional info such as TCP session info now */
 	return 0;
 }
diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
index 236ecd4959d5..8a9d2a5c9077 100644
--- a/fs/cifs/cifs_swn.h
+++ b/fs/cifs/cifs_swn.h
@@ -7,11 +7,13 @@
=20
 #ifndef _CIFS_SWN_H
 #define _CIFS_SWN_H
+#include "cifsglob.h"
=20
 struct cifs_tcon;
 struct sk_buff;
 struct genl_info;
=20
+#ifdef CONFIG_CIFS_SWN_UPCALL
 extern int cifs_swn_register(struct cifs_tcon *tcon);
=20
 extern int cifs_swn_unregister(struct cifs_tcon *tcon);
@@ -22,4 +24,29 @@ extern void cifs_swn_dump(struct seq_file *m);
=20
 extern void cifs_swn_check(void);
=20
+static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *ser=
ver)
+{
+	if (server->use_swn_dstaddr) {
+		server->dstaddr =3D server->swn_dstaddr;
+		return true;
+	}
+	return false;
+}
+
+static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info *s=
erver)
+{
+	server->use_swn_dstaddr =3D false;
+}
+
+#else
+
+static inline int cifs_swn_register(struct cifs_tcon *tcon) { return 0; }
+static inline int cifs_swn_unregister(struct cifs_tcon *tcon) { return 0; =
}
+static inline int cifs_swn_notify(struct sk_buff *s, struct genl_info *i) =
{ return 0; }
+static inline void cifs_swn_dump(struct seq_file *m) {}
+static inline void cifs_swn_check(void) {}
+static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *ser=
ver) { return false; }
+static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info *s=
erver) {}
+
+#endif /* CONFIG_CIFS_SWN_UPCALL */
 #endif /* _CIFS_SWN_H */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 099ad9f3660b..58b9de3bd106 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -655,10 +655,8 @@ cifs_show_options(struct seq_file *s, struct dentry *r=
oot)
 		seq_printf(s, ",multichannel,max_channels=3D%zu",
 			   tcon->ses->chan_max);
=20
-#ifdef CONFIG_CIFS_SWN_UPCALL
 	if (tcon->use_witness)
 		seq_puts(s, ",witness");
-#endif
=20
 	return 0;
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 31fc8695abd6..26df87a3bcbe 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1070,6 +1070,7 @@ struct cifs_tcon {
 	bool use_resilient:1; /* use resilient instead of durable handles */
 	bool use_persistent:1; /* use persistent instead of durable handles */
 	bool no_lease:1;    /* Do not request leases on files or directories */
+	bool use_witness:1; /* use witness protocol */
 	__le32 capabilities;
 	__u32 share_flags;
 	__u32 maximal_access;
@@ -1094,9 +1095,6 @@ struct cifs_tcon {
 	int remap:2;
 	struct list_head ulist; /* cache update list */
 #endif
-#ifdef CONFIG_CIFS_SWN_UPCALL
-	bool use_witness:1; /* use witness protocol */
-#endif
 };
=20
 /*
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index eec8a2052da2..354b903b3a28 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -62,9 +62,7 @@
 #include "dfs_cache.h"
 #endif
 #include "fs_context.h"
-#ifdef CONFIG_CIFS_SWN_UPCALL
 #include "cifs_swn.h"
-#endif
=20
 extern mempool_t *cifs_req_poolp;
 extern bool disable_legacy_dialects;
@@ -314,12 +312,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
=20
 		mutex_lock(&server->srv_mutex);
=20
-#ifdef CONFIG_CIFS_SWN_UPCALL
-		if (server->use_swn_dstaddr) {
-			server->dstaddr =3D server->swn_dstaddr;
-		} else {
-#endif
=20
+		if (!cifs_swn_set_server_dstaddr(server)) {
 #ifdef CONFIG_CIFS_DFS_UPCALL
 			/*
 			 * Set up next DFS target server (if any) for reconnect. If DFS
@@ -328,10 +322,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			 */
 			reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
 #endif
-
-#ifdef CONFIG_CIFS_SWN_UPCALL
 		}
-#endif
=20
 		if (cifs_rdma_enabled(server))
 			rc =3D smbd_reconnect(server);
@@ -348,9 +339,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			if (server->tcpStatus !=3D CifsExiting)
 				server->tcpStatus =3D CifsNeedNegotiate;
 			spin_unlock(&GlobalMid_Lock);
-#ifdef CONFIG_CIFS_SWN_UPCALL
-			server->use_swn_dstaddr =3D false;
-#endif
+			cifs_swn_reset_server_dstaddr(server);
 			mutex_unlock(&server->srv_mutex);
 		}
 	} while (server->tcpStatus =3D=3D CifsNeedReconnect);
@@ -415,10 +404,8 @@ cifs_echo_request(struct work_struct *work)
 		cifs_dbg(FYI, "Unable to send echo request to server: %s\n",
 			 server->hostname);
=20
-#ifdef CONFIG_CIFS_SWN_UPCALL
 	/* Check witness registrations */
 	cifs_swn_check();
-#endif
=20
 requeue_echo:
 	queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
@@ -1994,7 +1981,6 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 		return;
 	}
=20
-#ifdef CONFIG_CIFS_SWN_UPCALL
 	if (tcon->use_witness) {
 		int rc;
=20
@@ -2004,7 +1990,6 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 					__func__, rc);
 		}
 	}
-#endif
=20
 	list_del_init(&tcon->tcon_list);
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -2166,9 +2151,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_co=
ntext *ctx)
 		}
 		tcon->use_resilient =3D true;
 	}
-#ifdef CONFIG_CIFS_SWN_UPCALL
+
 	tcon->use_witness =3D false;
-	if (ctx->witness) {
+	if (IS_ENABLED(CONFIG_CIFS_SWN_UPCALL) && ctx->witness) {
 		if (ses->server->vals->protocol_id >=3D SMB30_PROT_ID) {
 			if (tcon->capabilities & SMB2_SHARE_CAP_CLUSTER) {
 				/*
@@ -2194,7 +2179,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_co=
ntext *ctx)
 			goto out_fail;
 		}
 	}
-#endif
=20
 	/* If the user really knows what they are doing they can override */
 	if (tcon->share_flags & SMB2_SHAREFLAG_NO_CACHING) {
@@ -3862,9 +3846,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kui=
d_t fsuid)
 	ctx->sectype =3D master_tcon->ses->sectype;
 	ctx->sign =3D master_tcon->ses->sign;
 	ctx->seal =3D master_tcon->seal;
-#ifdef CONFIG_CIFS_SWN_UPCALL
 	ctx->witness =3D master_tcon->use_witness;
-#endif
=20
 	rc =3D cifs_set_vol_auth(ctx, master_tcon->ses);
 	if (rc) {
--=20
2.30.0

