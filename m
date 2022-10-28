Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03DEFA3741
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 15:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiJ1PBN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJ1PBL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 11:01:11 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386CDB1B88
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 08:01:10 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id j12so5074796plj.5
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 08:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kn1+VOGO2cL2eItnHc9xgteyl6NjR1zLsqJ4AIqc1fY=;
        b=LY14qgKypdNLyffmiZN4FWita979oUUAL9JFTm95TFk0VuZ0snrpbbHVj0ArTeDrSr
         sRrBv8Ush0IdN3PABpkGJbdyd3l9QLCM5NyxwGxdP4ZDg17HQHUqEOlEWJylFboa8+Uw
         TIzGytYM+tPt6mFlYH6fvFGQNJDWonz4w/rldZcDe25tZr1nPDPuL/zOhAoyYIvjcq5V
         4BPqJJnHmBwhKpBtY5pewAIwlE5GuZh7Aokx1IY1ufW3V1NnrlicuMns/S7SmWEurHbg
         ljDsPwPWewZ1O2N73mXiUP9Hzkpdy/iBgXftQ92yPRtqkju0VR/NEmXHakSaqIxJSAdX
         tbLg==
X-Gm-Message-State: ACrzQf2bBLupIM83HGRQ0mATYA0ssd9GddvEh3Qa7Y1FpTJf6JGAT8YL
        4CtwE25yIW3mlhdtBpQNryU1xhCf4WE=
X-Google-Smtp-Source: AMsMyM5z5K3Ym+wj0pWb5KbOyohkOpLCUtmL6vA9Jnf7I3AxEyAN6N7RhYS5OcL0EHXkRFAz5n5f+g==
X-Received: by 2002:a17:90b:1bc9:b0:20d:b990:5028 with SMTP id oa9-20020a17090b1bc900b0020db9905028mr16019946pjb.111.1666969269367;
        Fri, 28 Oct 2022 08:01:09 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id d16-20020a170903231000b00186b04776b0sm2180764plh.118.2022.10.28.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 08:01:08 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd-tools: add 'server smb encrypt' parameter in ksmbd.conf
Date:   Sat, 29 Oct 2022 00:00:49 +0900
Message-Id: <20221028150049.17081-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add 'server smb encrypt' parameter in ksmbd.conf to control data
encryption mode with 3 options(off, desired, required).

- Setting it to off globally will completely disable the encryption feature
for all connections.
- Setting it to desired on a share will turn on data encryption for this
share for clients that support encryption.
- Setting it to required on a share will enforce data encryption for
  this share. i.e. clients that do not support encryption will be denied
access to the share

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 include/linux/ksmbd_server.h |  1 +
 ksmbd.conf.5.in              |  9 ++++++---
 tools/config_parser.c        | 12 +++++++++---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 643e2cd..8ec004f 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -28,6 +28,7 @@ struct ksmbd_heartbeat {
 #define KSMBD_GLOBAL_FLAG_SMB2_LEASES		(1 << 0)
 #define KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION	(1 << 1)
 #define KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL	(1 << 2)
+#define KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION_OFF	(1 << 3)
 
 struct ksmbd_startup_request {
 	__u32	flags;
diff --git a/ksmbd.conf.5.in b/ksmbd.conf.5.in
index 90bdfc0..fe4174c 100644
--- a/ksmbd.conf.5.in
+++ b/ksmbd.conf.5.in
@@ -280,10 +280,13 @@ Maximum length that may be used in a SMB2 WRITE request sent by a client.
 
 Default: \fBsmb2 max write = 4MB\fR \" SMB3_DEFAULT_IOSIZE
 .TP
-\fBsmb3 encryption\fR (G)
-Use of SMB3 encryption is allowed.
+\fBserver smb encrypt\fR (G)
+A remote client is allowed or required to use SMB encryption.
+Setting it to \fBoff\fR globally will completely disable the encryption feature for all connections.
+Setting it to \fBdesired\fR on a share will turn on data encryption for this share for clients that support encryption.
+Setting it to \fBrequired\fR on a share will enforce data encryption for this share. i.e. clients that do not support encryption will be denied access to the share.
 
-Default: \fBsmb3 encryption = no\fR
+Default: \fBserver smb encrypt = desired\fR
 .TP
 \fBsmbd max io size\fR (G)
 Maximum read/write size of SMB-Direct.
diff --git a/tools/config_parser.c b/tools/config_parser.c
index 7df0606..9b731e3 100644
--- a/tools/config_parser.c
+++ b/tools/config_parser.c
@@ -509,11 +509,17 @@ static gboolean global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		return TRUE;
 	}
 
-	if (!cp_key_cmp(_k, "smb3 encryption")) {
-		if (cp_get_group_kv_bool(_v))
+	if (!cp_key_cmp(_k, "server smb encrypt")) {
+		if (!cp_key_cmp(_v, "required")) {
 			global_conf.flags |= KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION;
-		else
+			global_conf.flags &= ~KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION_OFF;
+		} else if (!cp_key_cmp(_v, "off")) {
+			global_conf.flags |= KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION_OFF;
 			global_conf.flags &= ~KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION;
+		} else if (!cp_key_cmp(_v, "desired")) {
+			global_conf.flags &= ~KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION;
+			global_conf.flags &= ~KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION_OFF;
+		}
 
 		return TRUE;
 	}
-- 
2.25.1

