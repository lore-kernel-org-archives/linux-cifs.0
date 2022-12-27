Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F8AC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Dec 2022 15:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiL0PC1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Dec 2022 10:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiL0PC0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Dec 2022 10:02:26 -0500
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927A7F6D
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 07:02:25 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id 124so9036501pfy.0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Dec 2022 07:02:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ywj6EU4AA1Cw2pzzWqR7tX+n2ByZhlBktXfMFwzSTmQ=;
        b=pM71sGC6kDhyeDrfGdC0FbmWAwh2s5jBk3rpHlzLlzWHsOSkcrIeQALIbwiYVImeEO
         d/KFbvZz+m3hVVRN1wUw8ZxIqxlEJQO6LL8aLuYPYFkNTlLJXFCsXiZoLCULF3KbfBul
         +FQLBt/VAHJzmtib9BTT9jTAmn7HmzdKvxL0Rzj1Dpu3wGhRuXXMn5XWxXOn8sHx6xSi
         SFVKL4Telp8+inRjTgWPVC4mqkhCYwHmWExKxaCSWWrxZoHt0Da23lhXmhOd2M5iGfu7
         wQJshaeMzYvynZRij0pD9nUBvj0bLtyEdui5Fx6OPMgMwPw/enWjU2MnDZhEFVwUrVvc
         eyGw==
X-Gm-Message-State: AFqh2ko3UFO+UX3sypxLmaSuPipxzDPB1v56xwWDBGe/dPUE1y+w796n
        9C6jA7044t1ZL+5mw6AmQxKPYewwOLE=
X-Google-Smtp-Source: AMrXdXtDrJ0BmqQAJ04Neo7Ba8+OMYMGfmzYi7f02Vlz9eDYN0CAqSfnDs4CKqgTCxVpfKIPEAVjYQ==
X-Received: by 2002:a05:6a00:d1:b0:580:eb71:40f0 with SMTP id e17-20020a056a0000d100b00580eb7140f0mr13160603pfj.23.1672153344890;
        Tue, 27 Dec 2022 07:02:24 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id a78-20020a621a51000000b0056b6a22d6c9sm8702882pfa.212.2022.12.27.07.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 07:02:24 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd-tools: add max connections parameter to global section
Date:   Wed, 28 Dec 2022 00:02:13 +0900
Message-Id: <20221227150213.9842-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add max connections parameter to limit number of maximum simultaneous
connections.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 include/linux/ksmbd_server.h | 3 ++-
 include/tools.h              | 1 +
 ksmbd.conf.5.in              | 2 +-
 ksmbd.conf.example           | 1 +
 mountd/ipc.c                 | 1 +
 tools/config_parser.c        | 5 +++++
 6 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 8ec004f..64099f2 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -49,7 +49,8 @@ struct ksmbd_startup_request {
 	__u32	sub_auth[3];
 	__u32	smb2_max_credits;
 	__u32	smbd_max_io_size;	/* smbd read write size */
-	__u32   reserved[127];		/* Reserved room */
+	__u32	max_connections;	/* Number of maximum simultaneous connections */
+	__u32   reserved[126];		/* Reserved room */
 	__u32	ifc_list_sz;
 	__s8	____payload[];
 };
diff --git a/include/tools.h b/include/tools.h
index f6f51f8..6ff77b9 100644
--- a/include/tools.h
+++ b/include/tools.h
@@ -53,6 +53,7 @@ struct smbconf_global {
 	unsigned int		smb2_max_trans;
 	unsigned int		smb2_max_credits;
 	unsigned int		smbd_max_io_size;
+	unsigned int		max_connections;
 	unsigned int		share_fake_fscaps;
 	unsigned int		gen_subauth[3];
 	char			*krb5_keytab_file;
diff --git a/ksmbd.conf.5.in b/ksmbd.conf.5.in
index a1dfb4a..3cb237d 100644
--- a/ksmbd.conf.5.in
+++ b/ksmbd.conf.5.in
@@ -172,7 +172,7 @@ Maximum number of simultaneous sessions to all shares.
 
 Default: \fBmax active sessions = 1024\fR \" KSMBD_CONF_DEFAULT_SESS_CAP
 .TP
-\fBmax connections\fR (S)
+\fBmax connections\fR (G)
 Maximum number of simultaneous connections to the share.
 With \fBmax connections = 0\fR, any number of connections may be made.
 
diff --git a/ksmbd.conf.example b/ksmbd.conf.example
index 6ce4ec7..6bfc965 100644
--- a/ksmbd.conf.example
+++ b/ksmbd.conf.example
@@ -30,6 +30,7 @@
 	smbd max io size = 8MB
 	tcp port = 445
 	workgroup = WORKGROUP
+	max connections = 0
 
 	; share parameters for all sections
 	browseable = yes
diff --git a/mountd/ipc.c b/mountd/ipc.c
index 9d4c1ca..382f5ed 100644
--- a/mountd/ipc.c
+++ b/mountd/ipc.c
@@ -175,6 +175,7 @@ static int ipc_ksmbd_starting_up(void)
 	ev->smb2_max_write = global_conf.smb2_max_write;
 	ev->smb2_max_trans = global_conf.smb2_max_trans;
 	ev->smbd_max_io_size = global_conf.smbd_max_io_size;
+	ev->max_connections = global_conf.max_connections;
 	ev->share_fake_fscaps = global_conf.share_fake_fscaps;
 	memcpy(ev->sub_auth, global_conf.gen_subauth, sizeof(ev->sub_auth));
 	ev->smb2_max_credits = global_conf.smb2_max_credits;
diff --git a/tools/config_parser.c b/tools/config_parser.c
index 2dc6b34..5f36606 100644
--- a/tools/config_parser.c
+++ b/tools/config_parser.c
@@ -548,6 +548,11 @@ static gboolean global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		return TRUE;
 	}
 
+	if (!cp_key_cmp(_k, "max connections")) {
+		global_conf.max_connections = memparse(_v);
+		return TRUE;
+	}
+
 	/* At this point, this is an option that must be applied to all shares */
 	return FALSE;
 }
-- 
2.25.1

