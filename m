Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A66BC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jan 2022 01:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344465AbiAFB4u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jan 2022 20:56:50 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:43584 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344458AbiAFB4t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jan 2022 20:56:49 -0500
Received: by mail-pg1-f173.google.com with SMTP id 8so1238139pgc.10
        for <linux-cifs@vger.kernel.org>; Wed, 05 Jan 2022 17:56:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ffBSPrUImTbJ+YFt33Xhk4zDXI4zu4mjUmSwW5arrq0=;
        b=ZuyFTGGkeHu1M1wKB42ST7eAohrCwkli2rAbcC3IjJHIFCswI4fX0gMGNamk2/W34B
         +OB+10SvpBKBKiNDJ/aR0WK4SLQzIo3ccCOogICPcg8TYWTKGFLybNGwbO5oAJxITYWT
         Cnfu9x0sIcHZ0XslfqF3aNgfEKsVIaeVpR+niUWmvb8jVDeCd7IOVbpLXJsqrQ/vh9P5
         2Efw+B//S6tF+tleh8YOXdpAvjjLkslM9f/gJ7NgtEOkTLHntzJqtYtH3FgOkR3M1LAn
         dWCmLuC7xjQjP5ht02MEyaBvHsrrPo85BcypqyzJHi6vjEsLSqQVLlPAr1lCngLrtDIn
         iHag==
X-Gm-Message-State: AOAM530pPeJt++r4b5NEFnQYbAFhVTm6DphZUEa2H+8osDpopv047MLg
        FNgCR6Fpg7VgYg8Hov2RAU3W4eOkl00=
X-Google-Smtp-Source: ABdhPJxPwSCILEFs9Ac0WhnpyYCTPGmOVxMl/RL5zXSMPx4Jn8tduCymNm+cgiGVuujGEQJylANIVw==
X-Received: by 2002:a62:5211:0:b0:4bc:c949:ae8d with SMTP id g17-20020a625211000000b004bcc949ae8dmr11626403pfb.26.1641434208728;
        Wed, 05 Jan 2022 17:56:48 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id 72sm326968pfu.70.2022.01.05.17.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 17:56:48 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH] ksmbd: add reserved room in ipc request/response
Date:   Thu,  6 Jan 2022 10:56:39 +0900
Message-Id: <20220106015639.23006-1-linkinjeon@kernel.org>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/ksmbd/ksmbd_netlink.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index a5c2861792ae..71bfb7de4472 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -104,6 +104,7 @@ struct ksmbd_startup_request {
 					 */
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
 	__u32	smb2_max_credits;	/* MAX credits */
+	__u32	reserved[128];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
@@ -114,7 +115,7 @@ struct ksmbd_startup_request {
  * IPC request to shutdown ksmbd server.
  */
 struct ksmbd_shutdown_request {
-	__s32	reserved;
+	__s32	reserved[16];
 };
 
 /*
@@ -123,6 +124,7 @@ struct ksmbd_shutdown_request {
 struct ksmbd_login_request {
 	__u32	handle;
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ]; /* user account name */
+	__u32	reserved[16];				/* Reserved room */
 };
 
 /*
@@ -136,6 +138,7 @@ struct ksmbd_login_response {
 	__u16	status;
 	__u16	hash_sz;			/* hash size */
 	__s8	hash[KSMBD_REQ_MAX_HASH_SZ];	/* password hash */
+	__u32	reserved[16];			/* Reserved room */
 };
 
 /*
@@ -144,6 +147,7 @@ struct ksmbd_login_response {
 struct ksmbd_share_config_request {
 	__u32	handle;
 	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME]; /* share name */
+	__u32	reserved[16];		/* Reserved room */
 };
 
 /*
@@ -158,6 +162,7 @@ struct ksmbd_share_config_response {
 	__u16	force_directory_mode;
 	__u16	force_uid;
 	__u16	force_gid;
+	__u32	reserved[128];		/* Reserved room */
 	__u32	veto_list_sz;
 	__s8	____payload[];
 };
@@ -188,6 +193,7 @@ struct ksmbd_tree_connect_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
 	__s8	share[KSMBD_REQ_MAX_SHARE_NAME];
 	__s8	peer_addr[64];
+	__u32	reserved[16];		/* Reserved room */
 };
 
 /*
@@ -197,6 +203,7 @@ struct ksmbd_tree_connect_response {
 	__u32	handle;
 	__u16	status;
 	__u16	connection_flags;
+	__u32	reserved[16];		/* Reserved room */
 };
 
 /*
@@ -205,6 +212,7 @@ struct ksmbd_tree_connect_response {
 struct ksmbd_tree_disconnect_request {
 	__u64	session_id;	/* session id */
 	__u64	connect_id;	/* tree connection id */
+	__u32	reserved[16];	/* Reserved room */
 };
 
 /*
@@ -213,6 +221,7 @@ struct ksmbd_tree_disconnect_request {
 struct ksmbd_logout_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ]; /* user account name */
 	__u32	account_flags;
+	__u32	reserved[16];				/* Reserved room */
 };
 
 /*
-- 
2.25.1

