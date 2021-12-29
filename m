Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0F7C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Dec 2021 14:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbhL2OQD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Dec 2021 09:16:03 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:43644 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbhL2OP4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Dec 2021 09:15:56 -0500
Received: by mail-pj1-f52.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so20052088pjw.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Dec 2021 06:15:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hbZtDGxI5WAL7LhvXxO9hDHcoG5R1SjLtkFeuejp5IY=;
        b=0w14UZh5Okkm7ZVO6MMs+YNttMxMCuI8i4umBZTwGheppQsY3vyFxJcU1EuL6G2iN7
         EIXAE6GSwluuzddJMeFvdjMbWcQMW14A0+jR6JAZde96ppcwb1cBIyDortndmfhtgMi3
         lpMQ2IrgGFsoOnRT2+uRXx5xYQ586XeNhSRLpIDBCnUl+b+Yxp6cnbcACA2sSsS6fUhY
         m9Gapj8yFs4q0kXJs60MU6XbG3ZlHNfPVbLtAkvDJkpFOvgbFLbXoGOP3BpDhxYZFySA
         LSWoKgQu40aCMDft25lnsmFzFwWED1MmXNJVuqbYs3xfbC0jB/hOmh1eHmQOB/CNoHYO
         doGA==
X-Gm-Message-State: AOAM532M4u4WY14GTNSZ1Ftz3tnjSmq6fa3X9+nJWILLj6ASvE3TceDT
        uwSntFovp3zLlfU7DtKa0Y5CNUe8F9Q=
X-Google-Smtp-Source: ABdhPJxVhtooEdEbrAgGw/sJsqmGFRbeaa05vWYvyL1mzb4xjOZXJ84y/aiEV25mIMOatJuI2Yg4Dg==
X-Received: by 2002:a17:902:dccc:b0:148:b08b:6871 with SMTP id t12-20020a170902dccc00b00148b08b6871mr26925360pll.147.1640787355525;
        Wed, 29 Dec 2021 06:15:55 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id h191sm20547589pge.55.2021.12.29.06.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:15:55 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd-tools: add support for smb2 max credits parameter
Date:   Wed, 29 Dec 2021 23:15:44 +0900
Message-Id: <20211229141544.11729-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add smb2 max credits parameter to adjust maximum credits value to limit
number of outstanding requests.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/configuration.txt | 3 +++
 include/ksmbdtools.h            | 1 +
 include/linux/ksmbd_server.h    | 1 +
 lib/config_parser.c             | 5 +++++
 mountd/ipc.c                    | 1 +
 5 files changed, 11 insertions(+)

diff --git a/Documentation/configuration.txt b/Documentation/configuration.txt
index 5a15ce6..9580bf1 100644
--- a/Documentation/configuration.txt
+++ b/Documentation/configuration.txt
@@ -109,6 +109,9 @@ Define ksmbd configuration parameters list.
 		This boolean parameter controls whether ksmbd will support
 		SMB3 multi-channel. Warn that this is experimental feature
 		which means data can be corrupted under race conditions.
+	- smb2 max credits (default: 8192)
+		This option controls the maximum number of outstanding
+		simultaneous SMB2 operations.
 
 
 * Supported [share] level parameters list:
diff --git a/include/ksmbdtools.h b/include/ksmbdtools.h
index 5a12368..c51673e 100644
--- a/include/ksmbdtools.h
+++ b/include/ksmbdtools.h
@@ -52,6 +52,7 @@ struct smbconf_global {
 	unsigned int		smb2_max_read;
 	unsigned int		smb2_max_write;
 	unsigned int		smb2_max_trans;
+	unsigned int		smb2_max_credits;
 	unsigned int		share_fake_fscaps;
 	unsigned int		gen_subauth[3];
 	char			*krb5_keytab_file;
diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index b1c5e63..647cfee 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -46,6 +46,7 @@ struct ksmbd_startup_request {
 	__u32	smb2_max_trans;
 	__u32	share_fake_fscaps;
 	__u32	sub_auth[3];
+	__u32	smb2_max_credits;
 	__u32	ifc_list_sz;
 	__s8	____payload[];
 };
diff --git a/lib/config_parser.c b/lib/config_parser.c
index ebbe2dd..aa1dbf2 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -548,6 +548,11 @@ static void global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 
 		return;
 	}
+
+	if (!cp_key_cmp(_k, "smb2 max credits")) {
+		global_conf.smb2_max_credits = memparse(_v);
+		return;
+	}
 }
 
 static void fixup_missing_global_group(void)
diff --git a/mountd/ipc.c b/mountd/ipc.c
index 15c59f5..eded431 100644
--- a/mountd/ipc.c
+++ b/mountd/ipc.c
@@ -173,6 +173,7 @@ static int ipc_ksmbd_starting_up(void)
 	ev->smb2_max_trans = global_conf.smb2_max_trans;
 	ev->share_fake_fscaps = global_conf.share_fake_fscaps;
 	memcpy(ev->sub_auth, global_conf.gen_subauth, sizeof(ev->sub_auth));
+	ev->smb2_max_credits = global_conf.smb2_max_credits;
 
 	if (global_conf.server_min_protocol) {
 		strncpy(ev->min_prot,
-- 
2.25.1

