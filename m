Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36254C38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 15:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiJ1PBz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiJ1PBs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 11:01:48 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E91DEC3D
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 08:01:46 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id i3so4972162pfc.11
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 08:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1DCMlOA6r1LMZNncoBDDkFl+mO/8Ib8OKTb7I2A1Rk=;
        b=zkS9xUS7+oh7hb51KaRwvAyRmDYG/7OV9302EAufcSByGLVxDiuu8a/t2jrE4pvUKR
         sIMXC1vbT09n0oTev9EEVvUbks8fikBhUedyWNpYcJsVs1PYXuL5paOQpsui65SKMEA1
         sISOGfTfbpPKtAvXeozEEmAHwt/4Ds+DOpAWA4JWQNEYQv8eelMmY0dRnEVh+FUPuLTk
         fNGfS0BxIT4lLhNLLiL6/n+uY1sBs5KuUQFTyZ0gi5PqqJxEe8AWaLhWF7Xt/DCQ4qEW
         WktTR/KNNM0tnl3UtyXIqvmYlI62ijkhraVOnNDPsqlfWw4uKsU2d11uJ0qp38MipXj0
         NXQg==
X-Gm-Message-State: ACrzQf38jd8S8jahy7b2rl034fL1snYzF7nsnaa/GTyZWMrAr1HTBnzv
        M8i8y4R1jtayU9MO1/z/cqxlCPLbheU=
X-Google-Smtp-Source: AMsMyM6Z7Ju6cEtKZJTs9AhifDMFpoOdNCEMyretoSjaoI3KSDRfaToA04roytPn/ALL45H2RheJIw==
X-Received: by 2002:a62:584:0:b0:55a:a7a5:b597 with SMTP id 126-20020a620584000000b0055aa7a5b597mr55383413pff.71.1666969305962;
        Fri, 28 Oct 2022 08:01:45 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id t27-20020a63225b000000b00464858cf6b0sm2820051pgm.54.2022.10.28.08.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 08:01:45 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: set SMB2_SESSION_FLAG_ENCRYPT_DATA when enforcing data encryption for this share
Date:   Sat, 29 Oct 2022 00:01:38 +0900
Message-Id: <20221028150138.17155-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently, SMB2_SESSION_FLAG_ENCRYPT_DATA is always set session setup
response. Since this forces data encryption from the client, there is a
problem that data is always encrypted regardless of the use of the cifs
seal mount option. SMB2_SESSION_FLAG_ENCRYPT_DATA should be set according
to KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION flags, and in case of
KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF, encryption mode is turned off for
all connections.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/ksmbd_netlink.h |  1 +
 fs/ksmbd/smb2ops.c       | 10 ++++++++--
 fs/ksmbd/smb2pdu.c       |  8 +++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index ff07c67f4565..b6bd8311e6b4 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -74,6 +74,7 @@ struct ksmbd_heartbeat {
 #define KSMBD_GLOBAL_FLAG_SMB2_LEASES		BIT(0)
 #define KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION	BIT(1)
 #define KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL	BIT(2)
+#define KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF	BIT(3)
 
 /*
  * IPC request for ksmbd server startup
diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index ab23da2120b9..e401302478c3 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -247,8 +247,9 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
 
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION &&
-	    conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION)
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
+	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
+	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
@@ -271,6 +272,11 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
 
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
+	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
+	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
+		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
+
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index d0a0595bb01b..90e2554d757f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -903,7 +903,7 @@ static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
 		return;
 	}
 
-	if (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION))
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF)
 		return;
 
 	for (i = 0; i < cph_cnt; i++) {
@@ -1508,7 +1508,8 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 			return -EINVAL;
 		}
 		sess->enc = true;
-		rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
 		/*
 		 * signing is disable if encryption is enable
 		 * on this session
@@ -1599,7 +1600,8 @@ static int krb5_authenticate(struct ksmbd_work *work)
 			return -EINVAL;
 		}
 		sess->enc = true;
-		rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
 		sess->sign = false;
 	}
 
-- 
2.25.1

