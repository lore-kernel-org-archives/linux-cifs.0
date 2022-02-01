Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE02C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Feb 2022 12:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbiBAMKr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Feb 2022 07:10:47 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:44761 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237815AbiBAMKq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Feb 2022 07:10:46 -0500
Received: by mail-pj1-f51.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso2244185pjt.3
        for <linux-cifs@vger.kernel.org>; Tue, 01 Feb 2022 04:10:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7bL16LqTMexCIlpqlhEW1iKoicAHpNVXb4rEE58APvA=;
        b=Sb/RA5DJqz4ScUNgj5lT3jon4wvbWfC5kNFuX9ZzVBweUgRlYUoCA7URqiBxC+5AJn
         qGXQ18ktdhxrVuOfhaX2rwlp/kOCjoTGYwdktHUXVU9FSXVJeftOg8lsqBOOF8BDsgrL
         7pJ143SX2q3mEHby15fM+PV5aKSOJNI9MnNcT0RSvlTAXhddxB1g91izRw8rw1En5IWb
         NPtaRL+a2q1BrgVMKbpLilF4VGg5VHTOa+275HUg/47kgwQK8+JSZ3UMRgBiBPVy4rLn
         EvQyQLefeisnI/9uDtjfB/wstZu6KQc4s/9FMYfo1cup+rwMbtrqLwsAo/7DXNo+fDgm
         rp/Q==
X-Gm-Message-State: AOAM532xOH5QopBiI0mNqojgwLrgGYM531rX0YBYJiGj++Ayy1+ZoRgS
        Z5JtsN+32/89hZOiKi6vMelF65uc1RY=
X-Google-Smtp-Source: ABdhPJwoSHymme6V8oBtzo7znbKUPl/WWMW5FAxfPHXfkEbGmZljtlJCQhn09ihD3GjvIVJuRJ5WvQ==
X-Received: by 2002:a17:903:24f:: with SMTP id j15mr25674045plh.89.1643717446319;
        Tue, 01 Feb 2022 04:10:46 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id u19sm22425039pfi.150.2022.02.01.04.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 04:10:46 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add support for key exchange
Date:   Tue,  1 Feb 2022 21:10:32 +0900
Message-Id: <20220201121032.6242-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When mounting cifs client, can see the following warning message.

CIFS: decode_ntlmssp_challenge: authentication has been weakened as server
does not support key exchange

To remove this warning message, Add support for key exchange feature to
ksmbd. This patch decrypts 16-byte ciphertext value sent by the client
using RC4 with session key. The decrypted value is the recovered secondary
key that will use instead of the session key for signing and sealing.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/Kconfig      |  4 ++--
 fs/ksmbd/auth.c | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 7a2b11c0b803..6c7dc1387beb 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -369,8 +369,8 @@ source "fs/ksmbd/Kconfig"
 
 config SMBFS_COMMON
 	tristate
-	default y if CIFS=y
-	default m if CIFS=m
+	default y if CIFS=y || SMB_SERVER=y
+	default m if CIFS=m || SMB_SERVER=m
 
 source "fs/coda/Kconfig"
 source "fs/afs/Kconfig"
diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index dc3d061edda9..21d3630fe980 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -29,6 +29,7 @@
 #include "mgmt/user_config.h"
 #include "crypto_ctx.h"
 #include "transport_ipc.h"
+#include "../smbfs_common/arc4.h"
 
 /*
  * Fixed format data defining GSS header and fixed string
@@ -336,6 +337,29 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 				nt_len - CIFS_ENCPWD_SIZE,
 				domain_name, conn->ntlmssp.cryptkey);
 	kfree(domain_name);
+
+	/* The recovered secondary session key */
+	if (conn->ntlmssp.client_flags & NTLMSSP_NEGOTIATE_KEY_XCH) {
+		struct arc4_ctx *ctx_arc4;
+		unsigned int sess_key_off, sess_key_len;
+
+		sess_key_off = le32_to_cpu(authblob->SessionKey.BufferOffset);
+		sess_key_len = le16_to_cpu(authblob->SessionKey.Length);
+
+		if (blob_len < (u64)sess_key_off + sess_key_len)
+			return -EINVAL;
+
+		ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
+		if (!ctx_arc4)
+			return -ENOMEM;
+
+		cifs_arc4_setkey(ctx_arc4, sess->sess_key,
+				 SMB2_NTLMV2_SESSKEY_SIZE);
+		cifs_arc4_crypt(ctx_arc4, sess->sess_key,
+				(char *)authblob + sess_key_off, sess_key_len);
+		kfree_sensitive(ctx_arc4);
+	}
+
 	return ret;
 }
 
@@ -408,6 +432,9 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
+	if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)
+		flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
+
 	chgblob->NegotiateFlags = cpu_to_le32(flags);
 	len = strlen(ksmbd_netbios_name());
 	name = kmalloc(2 + UNICODE_LEN(len), GFP_KERNEL);
-- 
2.25.1

