Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9473CC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 16 May 2022 07:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiEPHmj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 May 2022 03:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiEPHmi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 May 2022 03:42:38 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C362BFE
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:37 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id pt3-20020a17090b3d0300b001df448c8d79so2454521pjb.5
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7CCImFy64BjOZQtVCx4CIoi/fHC6Qco9LnOfltlA7X4=;
        b=z9SpiS7X6/2nCcu2VqwJ8TgaxDUnQFIUTxAgx5W0xVIVM8640zn10wWGy7GOLF0y0R
         HyFgHpB21Ua9KaZ6DpJ7yVty43rklMwNYqAunNoqnZ3M8cOUKRlig+XjY5I6toE4X0yY
         tSQyPvSQT0gc6tLAXEl5o24RSNSYcB8eupaoWPbEdkhg/ZtcO8WS21lRvc73gCs0KLOw
         kVNud2SpjEwCeod2y9+5FoxRcr9X/UkomVUKvHRQ7hqBJlTboCqEGQSZAXrkCe0cU9WV
         vbF8u8MmhmS5qmnB2b/9EBoQRr1Yd1AkeX8GDvUYlwuqpIIaGahuQqHPa+QbiTjy6eEY
         88yw==
X-Gm-Message-State: AOAM530rXjevNuY3PwCfcLOQCfLEb0shQ9jGB2OOE9qdYd4TkiQTQ/yN
        pfxb0XKGgJdInIZZAH9DhhNFGjE1G9WiJQ==
X-Google-Smtp-Source: ABdhPJzH8NBvrIQ0XDh7D4TqQ1Gls+80lwGg7ISlPvT4R4isCk5fC+Z9z85XRvpj7XP1D9o8DrQCTg==
X-Received: by 2002:a17:90b:4f91:b0:1cd:3a73:3a5d with SMTP id qe17-20020a17090b4f9100b001cd3a733a5dmr17963442pjb.98.1652686956862;
        Mon, 16 May 2022 00:42:36 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id 64-20020a621443000000b0050dc76281ecsm6101511pfu.198.2022.05.16.00.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 00:42:36 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd-tools: add smbd max io size parameter
Date:   Mon, 16 May 2022 16:42:23 +0900
Message-Id: <20220516074223.28589-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add 'smbd max io size' parameter in ksmbd configuration to adjust
smbd-direct max read/write size.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/configuration.txt | 2 ++
 include/ksmbdtools.h            | 1 +
 include/linux/ksmbd_server.h    | 3 ++-
 lib/config_parser.c             | 5 +++++
 mountd/ipc.c                    | 1 +
 5 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/configuration.txt b/Documentation/configuration.txt
index 9580bf1..47d5f9b 100644
--- a/Documentation/configuration.txt
+++ b/Documentation/configuration.txt
@@ -112,6 +112,8 @@ Define ksmbd configuration parameters list.
 	- smb2 max credits (default: 8192)
 		This option controls the maximum number of outstanding
 		simultaneous SMB2 operations.
+	- smbd io size (default: 8MB)
+		This option controls the maximum read/write size of smb-direct.
 
 
 * Supported [share] level parameters list:
diff --git a/include/ksmbdtools.h b/include/ksmbdtools.h
index c51673e..a46bdbc 100644
--- a/include/ksmbdtools.h
+++ b/include/ksmbdtools.h
@@ -53,6 +53,7 @@ struct smbconf_global {
 	unsigned int		smb2_max_write;
 	unsigned int		smb2_max_trans;
 	unsigned int		smb2_max_credits;
+	unsigned int		smbd_max_io_size;
 	unsigned int		share_fake_fscaps;
 	unsigned int		gen_subauth[3];
 	char			*krb5_keytab_file;
diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 78ae6e7..6705dac 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -47,7 +47,8 @@ struct ksmbd_startup_request {
 	__u32	share_fake_fscaps;
 	__u32	sub_auth[3];
 	__u32	smb2_max_credits;
-	__u32   reserved[128];		/* Reserved room */
+	__u32	smbd_max_io_size;	/* smbd read write size */
+	__u32   reserved[127];		/* Reserved room */
 	__u32	ifc_list_sz;
 	__s8	____payload[];
 };
diff --git a/lib/config_parser.c b/lib/config_parser.c
index 9ce730c..e9d0a7e 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -555,6 +555,11 @@ static gboolean global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		return TRUE;
 	}
 
+	if (!cp_key_cmp(_k, "smbd max io size")) {
+		global_conf.smbd_max_io_size = memparse(_v);
+		return TRUE;
+	}
+
 	/* At this point, this is an option that must be applied to all shares */
 	return FALSE;
 }
diff --git a/mountd/ipc.c b/mountd/ipc.c
index eded431..015268d 100644
--- a/mountd/ipc.c
+++ b/mountd/ipc.c
@@ -171,6 +171,7 @@ static int ipc_ksmbd_starting_up(void)
 	ev->smb2_max_read = global_conf.smb2_max_read;
 	ev->smb2_max_write = global_conf.smb2_max_write;
 	ev->smb2_max_trans = global_conf.smb2_max_trans;
+	ev->smbd_max_io_size = global_conf.smbd_max_io_size;
 	ev->share_fake_fscaps = global_conf.share_fake_fscaps;
 	memcpy(ev->sub_auth, global_conf.gen_subauth, sizeof(ev->sub_auth));
 	ev->smb2_max_credits = global_conf.smb2_max_credits;
-- 
2.25.1

