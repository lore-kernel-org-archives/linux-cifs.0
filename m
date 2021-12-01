Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB1BC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Dec 2021 20:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353005AbhLAUpT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Dec 2021 15:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353033AbhLAUpD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Dec 2021 15:45:03 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CA4C0613D7
        for <linux-cifs@vger.kernel.org>; Wed,  1 Dec 2021 12:41:40 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q3so32161662wru.5
        for <linux-cifs@vger.kernel.org>; Wed, 01 Dec 2021 12:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l//lAquFJsJlyejqCexAu+Y+9jr6gTNi1DSeoz57KBw=;
        b=HxBj9PVbjs0YS/rLsqKMCCF+fVLUi6O+F9aRSFhM1G+4HGKfgoDrWSzGdu2h5+K2Iu
         dbBDOhvIwtT1N32vbAFUtL3I3TgZyCLW4jNjX3t3T2KghL1IwmRC/I2haRSMcQxbpJTK
         BAfLN78s8KbjSJxeju+g2TOOOYq3yRrsJ9jNaUCYO3tCZ8b2lMGpUmXBS9HZZenT4ch0
         oRi9PaH90wCb3tKmNa46t+0H7TuYB+ZW2vEBXv5TZZ/pS69t8ZEnUdjSG6UTwGZJdaWz
         CgDOSvsKgQH48WkRV7yFq+N83/Yw3cfFPy5QSz4wH1OrGQjBH6JkuPrL0OfMixSeqHKu
         HQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l//lAquFJsJlyejqCexAu+Y+9jr6gTNi1DSeoz57KBw=;
        b=PRXsGVPTdKdm8nNAgWTr/lCj/08z/Y1qjVuQVUNtRf9MiwKdV2FzG+UzGvmVcEdk1A
         Fcpu6Y7fn2WNlr2HaH6bJfhLH/VgxPAeNpit8d+Dudw5pdrZVAUn56G6N+ULJQxcaHvz
         1i5ReWp/otLpKES+HsQTSNdLbFuq0dPeRW/9ljxiHD4bOgVJnvhnte1cALH7cEmW+qxQ
         phuOSf3O5mA4oYW3Fqk1Hvs/xPM8kAIuhQ8A1cMWbI2yCCLTswV+Gkx16PT8Nwm50w8J
         eEENStRfq0Z6SYTTeZ6osPloEftpvkgOY2nvSQ+8bgb7O97LUCTHbYF9N+asnnU3Scdd
         lEVA==
X-Gm-Message-State: AOAM5310FfEf9HQW9RSzbqUxbwnpt0RhOplcCwIqBQ81ykHyOqUrFbJW
        6d2M2eTC58UmvEqAPLYnPkWKWkgY/lGb+A==
X-Google-Smtp-Source: ABdhPJxz3fCQpjBMfW/NdFU+OOmIFHjJXvhllaMIwrLGz3+CmHPUm79Jyo14au1msyh47nvtImfumA==
X-Received: by 2002:a5d:4a0b:: with SMTP id m11mr9433204wrq.120.1638391299378;
        Wed, 01 Dec 2021 12:41:39 -0800 (PST)
Received: from localhost.localdomain (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id o5sm687492wrx.83.2021.12.01.12.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 12:41:39 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: Remove unused parameter from smb2_get_name()
Date:   Wed,  1 Dec 2021 21:41:19 +0100
Message-Id: <20211201204118.3617544-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The 'share' parameter is no longer used by smb2_get_name() since
commit 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of
share access").

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/ksmbd/smb2pdu.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 125590d5e940..1edb536fbf75 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -610,7 +610,6 @@ static void destroy_previous_session(struct ksmbd_user *user, u64 id)
 
 /**
  * smb2_get_name() - get filename string from on the wire smb format
- * @share:	ksmbd_share_config pointer
  * @src:	source buffer
  * @maxlen:	maxlen of source string
  * @nls_table:	nls_table pointer
@@ -618,8 +617,7 @@ static void destroy_previous_session(struct ksmbd_user *user, u64 id)
  * Return:      matching converted filename on success, otherwise error ptr
  */
 static char *
-smb2_get_name(struct ksmbd_share_config *share, const char *src,
-	      const int maxlen, struct nls_table *local_nls)
+smb2_get_name(const char *src, const int maxlen, struct nls_table *local_nls)
 {
 	char *name;
 
@@ -2513,8 +2511,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 
-		name = smb2_get_name(share,
-				     req->Buffer,
+		name = smb2_get_name(req->Buffer,
 				     le16_to_cpu(req->NameLength),
 				     work->conn->local_nls);
 		if (IS_ERR(name)) {
@@ -5381,8 +5378,7 @@ static int smb2_rename(struct ksmbd_work *work,
 		goto out;
 	}
 
-	new_name = smb2_get_name(share,
-				 file_info->FileName,
+	new_name = smb2_get_name(file_info->FileName,
 				 le32_to_cpu(file_info->FileNameLength),
 				 local_nls);
 	if (IS_ERR(new_name)) {
@@ -5493,8 +5489,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 	if (!pathname)
 		return -ENOMEM;
 
-	link_name = smb2_get_name(share,
-				  file_info->FileName,
+	link_name = smb2_get_name(file_info->FileName,
 				  le32_to_cpu(file_info->FileNameLength),
 				  local_nls);
 	if (IS_ERR(link_name) || S_ISDIR(file_inode(filp)->i_mode)) {
-- 
2.25.1

