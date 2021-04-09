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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F23C433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 14:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D486661042
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 14:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhDIOcc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:32:32 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:25524 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231946AbhDIOcb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 10:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617978737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7DBm6MDrZ34b6GKZHoH7PmdrLfadHZamCJCgD6/1BTw=;
        b=dTeW3PMP2+foXj/Zpzm/jmRwVXsM2qpIWodiE4VsbN1GRDSHQ7Fyu3aWzlKse0KnbujcAG
        b8NmQznqkSiFiM88O5QoPdymDyGY185T2l/faF9TKN1n0yaEwmO/+XvHNW0iiAgKPVxCq1
        uNRjARjG9vTfM1anLe2Vmu1JdLMjevE=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-rPkD1HKUPSSEoMYznfD0Xw-2; Fri, 09 Apr 2021 16:32:06 +0200
X-MC-Unique: rPkD1HKUPSSEoMYznfD0Xw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcRkxT6KUxkEaGNgbtPQZH1O1Ysea9z0v9umEtp2BwbCWnWyFipfkWVVqNTLaJjKJqaNTLTKp8nOc2TNA91XCItqWyYmJiSx9tXnKMXD3dBUM5wrH6VUl+GcDACg3GJgBzTn24htFIUz+58jwmlpovF6R27Ci5jg3mKAguz4x78ycANw96Fp7uwqEBoagh22XAcFWEwzCcxTvLKAySSv+OG/23Luo7NUgblcnlRq3k/DZAn9EhSFzMlXkjKy35iDmedaaY5Qx7U9VgM6CRxlW+lJ1KB7hT42eKXjiswrZlvV6HcjyDx0mAMIMJ4F/mT3JnRuv+FXvuLEHM+Y9RALyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3BY0ziaMIBnunZHmR+j61lJVYB5iY3Xh8ZhuMHw+rA=;
 b=R41kXC3qBTMWhHo+qHBxJGz3WdthwJbD8gmZO0Ohd5lftQFc8w50WVpGH7e93M82ctLZQOy4qAweAeZALyAk4eZmL7nyGTCrVRlzX3/rC4F+G7ENPoHWwJG+NDCDuiK5rceDyp7LSqDGMqlHhXi5ymZbYahDi3Ap1590Y2P0H4Hu5udQTJyKHblEjnwwscjJuYKYs8n7RD69ToJetYKJwLtARWzyhOcxcHOnTK/faQVbi2o5JBUUbk4R3zSSiPkP+UzcCIFerz+vcB9XPDuzCy27rNlelJu/cM4g3cEnI5/wUyZETJakTKHNmWEvSHlrLH0/0A+LL5OY9pDctUDDPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2574.eurprd04.prod.outlook.com (2603:10a6:800:57::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 14:31:58 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.035; Fri, 9 Apr 2021
 14:31:58 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>, scabrero@suse.com
CC:     =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: [PATCH v2] cifs: simplify SWN code with dummy funcs instead of ifdefs
Date:   Fri,  9 Apr 2021 16:31:37 +0200
Message-ID: <20210409143137.30683-1-aaptel@suse.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <CAH2r5mvnW1At==3rWAn+Mu7WZ1-jHOmYkkyWjh+axsHoo4Lh4w@mail.gmail.com>
References: <CAH2r5mvnW1At==3rWAn+Mu7WZ1-jHOmYkkyWjh+axsHoo4Lh4w@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:705:3046:69ee:cad4:97e6:ea8f]
X-ClientProxiedBy: ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::14) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3046:69ee:cad4:97e6:ea8f) by ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 14:31:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e155536-6260-4c74-10ce-08d8fb643b18
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2574:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2574D3FB64407F4697F8BBDCA8739@VI1PR0401MB2574.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:64;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UR7JnSQ1CflDjW9MhgkTnZffUpBLzVUZaMW50nHm2AXFmSJM/eeOGDabXo0v?=
 =?us-ascii?Q?kVwiMR9AhIIL9NjWvHVJf/s/f8oXbOR2rKyB5CNaue8LlJw0+M2KE8weRulU?=
 =?us-ascii?Q?2lZz76ONyrB8tqF1QaZSTQ12AgeCK1jN2TOoMChDfPUIm/GkxsqTNnYmKG4b?=
 =?us-ascii?Q?CGSuWy0ooOQKhPiSScDAsojCBJ/UHVEFLyJ92XkFoKs080ga6LBPcjmDdYDG?=
 =?us-ascii?Q?qP6C++Kc1B3+h/M+ZaP9V3QNHHhnHHDTwOywVCHE2uZnPe1nczvrbNbO9mlf?=
 =?us-ascii?Q?rwVc1dHN0hFoAz9Bq5OvnmeHSRdbZ7KNPfJLzaJzk83AwRNRr7GylENph5gx?=
 =?us-ascii?Q?CDOPu7xPjRFst7j3mmz9gW4jNqeu0wUZBQhLHUwtTXnVJ6sd6imFheptJ3RF?=
 =?us-ascii?Q?BUptJ+VfXQBt3Og/gkJn9V0YTN5/wG8vpKiLssd487t48UNQ8D1IFWR6nETD?=
 =?us-ascii?Q?JEr1BHGQ0ZZD9UG1pv2Gsm5qO77/NlWJjh23JbWX9ZvC1Aiz0czT7ent7GFl?=
 =?us-ascii?Q?IxUSsHaUVJyywpmVBC8JbulNqjBfATAeDlFRsHeKQ2lIOttpZatDnuhB4Zie?=
 =?us-ascii?Q?5eTbHClSLQYKaz86Hvocc6VMIkLMm1uz2XyH2KHescxaLa1r0jC4IwTmcJp/?=
 =?us-ascii?Q?eS4qCwSYtZ1ht5ixDxTjdYK0yo9g4nmSNB55qEMFSiVPd1FDxACuK7UEmoLu?=
 =?us-ascii?Q?wqD0xb7T9+CKJjYDN7793qr1LFJexAAorOqpSp8AU2xhEiiV90hU8md2roQ2?=
 =?us-ascii?Q?zMpZOjGLr0mi0Xg3DNiEZi4QannkTrshlbeBQKPK0obqYgyPiLHmpi+LZdII?=
 =?us-ascii?Q?ydchzjI3BgNqUml8gdbtH1iPvRp0LGVKB15bnfoYoSKSiVpLEJ93ZLvGfBy+?=
 =?us-ascii?Q?N9WPYAvda0eaCXAdBDIKQb+x41lKTRNG57HopcU+IKU7YRN2DXXSjmOEEIVI?=
 =?us-ascii?Q?ZYvBk4SvRpMnnJ3Oolhq2LXrM7Im+PT2e4wm2mDcgBI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(39840400004)(366004)(376002)(136003)(346002)(396003)(478600001)(6486002)(38100700001)(66946007)(66476007)(66556008)(6636002)(4326008)(52116002)(86362001)(6496006)(83380400001)(6666004)(16526019)(186003)(8936002)(8676002)(5660300002)(2906002)(36756003)(316002)(1076003)(2616005)(54906003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O2x2HB5PbqX9iPuOSiEQPvcjtZh1E0E3lf7oNK6ScaHnuwrZBLym4sNZtamK?=
 =?us-ascii?Q?0IopAMGpZ6A7w9p70zbImNj4hIAV08gojiCI2NBQ01hUUbO5wardPi/2Dsry?=
 =?us-ascii?Q?2zUDCKYnh2rrz4zeugvLZbkrEFO5/3fEUF77u11rwUJuWb/xKloQ+kAlqLjG?=
 =?us-ascii?Q?1LJ35Vu+xzbQXdI6RVYzH5aicNSncvxE+KFM9Kkk+DgTY3Pcq2tn1MDKtWOE?=
 =?us-ascii?Q?UPzOGDM0bv2KkgeZ/IZXQlGiJkkr40Zd+WT0g8/rFCjDeMG0UBVR2yjeeGyv?=
 =?us-ascii?Q?btNdv+H5rOcbPAYHtLsa4BWhMPyb23n3ky4TIw+LAERYkl1WqU7M5psL3Lxu?=
 =?us-ascii?Q?wuKltB7Ny3f58mmFnPaGB4evazjMHtW+vcQ/t0nba+0O6fx6KI/MjEHzrEBj?=
 =?us-ascii?Q?dyeQdeLm1xKxDeX5TkU5L74d1UG/jeLyTm2g+pYNiYgr5zOMrNCk+gq+y1S0?=
 =?us-ascii?Q?aAzFuH7J9BsUkQkTZaLlzjWcf1fuQkyyPXnpxl0vD3c10bNVOH/eGnKdZP+C?=
 =?us-ascii?Q?XGAshdzpSd2gRtq5+JZjykdtp1VKIt4kYO44gltbsf1cOno6+PkwCGyMMEBW?=
 =?us-ascii?Q?pjcvWIbm/pYDOeFJ71vl3eUpNSRNImfVIVKIGHiqwIAm9yMNLlz7HqgTmk5P?=
 =?us-ascii?Q?zJTfCGPUeaetc8/zrB3en60KWbSUAqe3D5+jp4JM2LGID2eQyynL8JnG1ZIJ?=
 =?us-ascii?Q?FAqp1VzlxEZWST13mioH2ksInxPE8xV9+oHwtTjvGIYD1+gQhnLnZdG5yDAG?=
 =?us-ascii?Q?jOY4W5ury+Pq0Q71HO4fnZ7RqA3VwTG2XyLAOxQiptORiUok8rR3czvm1KtV?=
 =?us-ascii?Q?qzg/3sLh0wqOJxiCKfswzhbX2V2V/qlUQYsnKBd+O4wgxsFeCBalCjGTJJyo?=
 =?us-ascii?Q?IwkCVGMew6hKdTqm7VTyWCo5ylVhbw8r+75Clh1+mvFWs53HMWvjAVGu5Ohn?=
 =?us-ascii?Q?Z4Fmmx3+Y0umvQJnVaXJtqzO8q1y56f4v2hmM0UWgUQoXD3mRo5xJAtr+uep?=
 =?us-ascii?Q?ylwiWskINxjY4sMXxaevK/ee4+iAcQo6UN1lOiX5kP2Qu1ipdzyI6BzLduTC?=
 =?us-ascii?Q?chLiGaI2M2Dse2VvFCoh0GK3GAv5NdnjRZsI3r8U+l03QBmhyX7C0sRw775l?=
 =?us-ascii?Q?JgxLhg++FRMlLbc1nEW44BEXyMpluhg/ozjzf+2OJFSgi1+tmRP6AVEhSrfb?=
 =?us-ascii?Q?jgqYVVYuvpZ0kX4SIk1jB+7K7qFU9hjNTK8DkErN3OyLT3EinZw1TDatgQ7Y?=
 =?us-ascii?Q?J+3S+hutddV5KCrtUQ6VcIYqexAP4+WghkZSzOviXxuMjqRpTa872FginfZe?=
 =?us-ascii?Q?/k8QKSJNjqAZoDLhOy8R9gycKWue+722W5iboJadvJPIMm9q+w/RQPdqXaWq?=
 =?us-ascii?Q?9WufnOkxojYzUCMw0BD8TqyG7Nhv?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e155536-6260-4c74-10ce-08d8fb643b18
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 14:31:58.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqSZGm/9tzz9B+vS3wl20kwREvymI/ihIvVFB15a/8/imC3V0qevhKUwIXj/LkET
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2574
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
changes since v1:
* updated to apply on current for-next


 fs/cifs/cifs_debug.c |  8 +-------
 fs/cifs/cifs_swn.h   | 27 +++++++++++++++++++++++++++
 fs/cifs/cifsfs.c     |  2 --
 fs/cifs/cifsglob.h   |  4 +---
 fs/cifs/connect.c    | 25 ++++---------------------
 5 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 88a7958170ee..d8ae961a510f 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -23,9 +23,7 @@
 #ifdef CONFIG_CIFS_SMB_DIRECT
 #include "smbdirect.h"
 #endif
-#ifdef CONFIG_CIFS_SWN_UPCALL
 #include "cifs_swn.h"
-#endif
=20
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -118,10 +116,8 @@ static void cifs_debug_tcon(struct seq_file *m, struct=
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
@@ -490,10 +486,8 @@ static int cifs_debug_data_proc_show(struct seq_file *=
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
index 5ddd20b62484..1b65ff9e9189 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -656,10 +656,8 @@ cifs_show_options(struct seq_file *s, struct dentry *r=
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
index ec824ab8c5ca..dec0620ccca4 100644
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
index 24668eb006c6..35dbb9c836ea 100644
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
 		if (cifs_sb && cifs_sb->origin_fullpath)
 			/*
@@ -344,9 +338,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 #endif
=20
=20
-#ifdef CONFIG_CIFS_SWN_UPCALL
 		}
-#endif
=20
 		if (cifs_rdma_enabled(server))
 			rc =3D smbd_reconnect(server);
@@ -363,9 +355,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
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
@@ -430,10 +420,8 @@ cifs_echo_request(struct work_struct *work)
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
@@ -2009,7 +1997,6 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 		return;
 	}
=20
-#ifdef CONFIG_CIFS_SWN_UPCALL
 	if (tcon->use_witness) {
 		int rc;
=20
@@ -2019,7 +2006,6 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 					__func__, rc);
 		}
 	}
-#endif
=20
 	list_del_init(&tcon->tcon_list);
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -2181,9 +2167,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_co=
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
@@ -2209,7 +2195,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_co=
ntext *ctx)
 			goto out_fail;
 		}
 	}
-#endif
=20
 	/* If the user really knows what they are doing they can override */
 	if (tcon->share_flags & SMB2_SHAREFLAG_NO_CACHING) {
@@ -3877,9 +3862,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kui=
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

