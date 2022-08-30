Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA57ECAAD1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 14:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiH3OSB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 10:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiH3OSA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 10:18:00 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF03849B5F
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 07:17:58 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id h13-20020a17090a648d00b001fdb9003787so6648059pjj.4
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 07:17:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tjihmA9Q0aLI3sXupqXaO8n7eAVqAPtfjuh0IVpik00=;
        b=QR++IB7OiqRdM3jrdXSpaRu/2tOSG1HYh+Q3jz2aAnOju17UI3ZJN8JoeIuMSlOBWx
         gInF0p5pR7iG9gCKGpJ9HAtP503pOpkPj5dDf7mGWcU/aRvDN0orlMytwDKM55Rd0NY5
         EhBgRllC4H5osvR46u+nazqMF0SIfFaUEOmB6ol027h/yZX6C6oP1YMnPn4vIYdQ8HpJ
         Vb1su06NkIC57e0FHRDjNFdNowBwxOjGFdmSmWsA2GWfmeDqkb91jSdF/kVf35V0fOWZ
         cJOMGHCLJLaaKe6RNYRafGaRp54hHtSQ9WcI1YOeeD6Q2sPA9YPjwjdtigZWJzegmWDn
         v0gA==
X-Gm-Message-State: ACgBeo3n8pkbLch6SVNnU6+y5AZzZDDPg/EI6jQNMhj0y8b+WX0iHNqx
        J7N3Nvhvuq0jNvqsu4jkv41OLXlPTj4=
X-Google-Smtp-Source: AA6agR53l4cI1b2EqMOhUpib1jVWhiDIKGY1cIs0Idd8eCNrDDQ+vs7ayTru+dRqZ73jTjZ8c4slwg==
X-Received: by 2002:a17:902:ceca:b0:174:c224:826 with SMTP id d10-20020a170902ceca00b00174c2240826mr10065258plg.132.1661869077506;
        Tue, 30 Aug 2022 07:17:57 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id i72-20020a62874b000000b0052e987c64efsm9671172pfe.174.2022.08.30.07.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 07:17:57 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: remove generic_fillattr use in smb2_open()
Date:   Tue, 30 Aug 2022 23:17:32 +0900
Message-Id: <20220830141732.9982-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220830141732.9982-1-linkinjeon@kernel.org>
References: <20220830141732.9982-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Removed the use of unneeded generic_fillattr() in smb2_open().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c49f65146ab3..ad6410874b95 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2761,7 +2761,6 @@ int smb2_open(struct ksmbd_work *work)
 	} else {
 		file_present = true;
 		user_ns = mnt_user_ns(path.mnt);
-		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
 	}
 	if (stream_name) {
 		if (req->CreateOptions & FILE_DIRECTORY_FILE_LE) {
@@ -2770,7 +2769,8 @@ int smb2_open(struct ksmbd_work *work)
 				rsp->hdr.Status = STATUS_NOT_A_DIRECTORY;
 			}
 		} else {
-			if (S_ISDIR(stat.mode) && s_type == DATA_STREAM) {
+			if (file_present && S_ISDIR(d_inode(path.dentry)->i_mode) &&
+			    s_type == DATA_STREAM) {
 				rc = -EIO;
 				rsp->hdr.Status = STATUS_FILE_IS_A_DIRECTORY;
 			}
@@ -2787,7 +2787,8 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (file_present && req->CreateOptions & FILE_NON_DIRECTORY_FILE_LE &&
-	    S_ISDIR(stat.mode) && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
+	    S_ISDIR(d_inode(path.dentry)->i_mode) &&
+	    !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		ksmbd_debug(SMB, "open() argument is a directory: %s, %x\n",
 			    name, req->CreateOptions);
 		rsp->hdr.Status = STATUS_FILE_IS_A_DIRECTORY;
@@ -2797,7 +2798,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (file_present && (req->CreateOptions & FILE_DIRECTORY_FILE_LE) &&
 	    !(req->CreateDisposition == FILE_CREATE_LE) &&
-	    !S_ISDIR(stat.mode)) {
+	    !S_ISDIR(d_inode(path.dentry)->i_mode)) {
 		rsp->hdr.Status = STATUS_NOT_A_DIRECTORY;
 		rc = -EIO;
 		goto err_out;
-- 
2.25.1

