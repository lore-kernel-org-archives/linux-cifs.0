Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C526AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jan 2022 01:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344457AbiAFB5O (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jan 2022 20:57:14 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:35338 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344476AbiAFB5L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jan 2022 20:57:11 -0500
Received: by mail-pf1-f174.google.com with SMTP id v11so1274389pfu.2
        for <linux-cifs@vger.kernel.org>; Wed, 05 Jan 2022 17:57:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Bjdep1oJfAG+oTG14Wf01Aa8UhhjWpNU9UPSp/Uhew=;
        b=NOkrBQ3r8q+GuAx3z4EM/1q1MQpteNqgepon6gLpN2k8Li7JaUtcv2dyvXYx/XPXAS
         IgBVoCdds/mTFrPaDbro9nZow01MqWKnyX7xlEV5ehL8TOnw3Azqfg9QrKCjl1aUrGmi
         giFHsucr8GsLAeJfKfOwv0F19a7GY000VWlZvprVw4y655lga0LS+z849ybCwIGt1SF1
         z13lsraYLpKLf033EPYAPfI6GlfY8wBuDmmK2mOtP/+3kSZV68AW4ltTj3IgjyENtgor
         lr032vYMZl0pY36/SCTb3+kcxvGT8hutHc97tr1XEaLkPq5iGqyxJeugwd3hGAIh19Vf
         NhLA==
X-Gm-Message-State: AOAM531uCgp/sWrZMknjpTD9gOhFM9/i8xlic+yX2rCbtPnJAT2wuIKP
        HfE/302bFS1J7sQAF5vf5F0wWchEzQQ=
X-Google-Smtp-Source: ABdhPJxSsi0MnjBsiYMaoDGw8CPe94Ure2g3e/KSFeTuMYp60C7xjgjG2Uaeo/iAtEOsm4AbBLyv/w==
X-Received: by 2002:a63:6d4f:: with SMTP id i76mr50042065pgc.611.1641434230489;
        Wed, 05 Jan 2022 17:57:10 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id lk10sm4106872pjb.20.2022.01.05.17.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 17:57:10 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd-tools: add reserved room in ipc request/response
Date:   Thu,  6 Jan 2022 10:57:02 +0900
Message-Id: <20220106015702.23063-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Whenever new parameter is added to smb configuration, It is possible
to break the execution of the IPC daemon by mismatch size of
request/response. This patch tries to reserve space in ipc request/response
in advance to prevent that.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 include/linux/ksmbd_server.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 647cfee..78ae6e7 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -47,6 +47,7 @@ struct ksmbd_startup_request {
 	__u32	share_fake_fscaps;
 	__u32	sub_auth[3];
 	__u32	smb2_max_credits;
+	__u32   reserved[128];		/* Reserved room */
 	__u32	ifc_list_sz;
 	__s8	____payload[];
 };
@@ -54,12 +55,13 @@ struct ksmbd_startup_request {
 #define KSMBD_STARTUP_CONFIG_INTERFACES(s)	((s)->____payload)
 
 struct ksmbd_shutdown_request {
-	__s32	reserved;
+	__s32	reserved[16];
 };
 
 struct ksmbd_login_request {
 	__u32	handle;
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
+	__u32   reserved[16];		/* Reserved room */
 };
 
 struct ksmbd_login_response {
@@ -70,11 +72,13 @@ struct ksmbd_login_response {
 	__u16	status;
 	__u16	hash_sz;
 	__s8	hash[KSMBD_REQ_MAX_HASH_SZ];
+	__u32   reserved[16];		/* Reserved room */
 };
 
 struct ksmbd_share_config_request {
 	__u32	handle;
 	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
+	__u32   reserved[16];		/* Reserved room */
 };
 
 struct ksmbd_share_config_response {
@@ -86,6 +90,7 @@ struct ksmbd_share_config_response {
 	__u16	force_directory_mode;
 	__u16	force_uid;
 	__u16	force_gid;
+	__u32   reserved[128];		/* Reserved room */
 	__u32	veto_list_sz;
 	__s8	____payload[];
 };
@@ -108,22 +113,26 @@ struct ksmbd_tree_connect_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
 	__s8	share[KSMBD_REQ_MAX_SHARE_NAME];
 	__s8	peer_addr[64];
+	__u32   reserved[16];		/* Reserved room */
 };
 
 struct ksmbd_tree_connect_response {
 	__u32	handle;
 	__u16	status;
 	__u16	connection_flags;
+	__u32   reserved[16];		/* Reserved room */
 };
 
 struct ksmbd_tree_disconnect_request {
 	__u64	session_id;
 	__u64	connect_id;
+	__u32   reserved[16];		/* Reserved room */
 };
 
 struct ksmbd_logout_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
 	__u32	account_flags;
+	__u32   reserved[16];		/* Reserved room */
 };
 
 struct ksmbd_rpc_command {
-- 
2.25.1

