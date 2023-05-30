Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65188C77B73
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 13:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjE3NAA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 09:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjE3M7p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 08:59:45 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45A41A2
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d1e96c082so3188105b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 05:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685451501; x=1688043501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMg3SYDPiX3TDwfss9cOOfBTrY4uHuVF7yjcXuPY58s=;
        b=Ff2VVQh+lV2D7JNLaeibpsB51HqlI07mZunl3k87ii+Gv7pD070rWZTL8HujMdPU6e
         K4RQcR8VRH9TPHdB78IGXfiLq1aL8FhNFZWLFvgKXQVJKtSmn3XzsXBibqmoIjYZvAOl
         X2bM4t6mNm0yPOFUhB8FVEoqBh8O0Hhs5cuktUBa0AU5h1Gfr99NKgAlHNbvw9mqckTk
         +ZnPqJ/gdDQPpMxDdlijo6XiHVj9swbVHQ7oLYHw49KTXmwz5lyiQ8uCPRyeg3J5DHCY
         m7cq01GFJkFIkmvN317Er0ubp5hlXP4FILHzghace3e/oPmOiaUtFH0Bg3xg5ZrE2Okd
         FjFA==
X-Gm-Message-State: AC+VfDwWIMYpByNFD7l2GyllLoP9qsMtnSjs0DQ/q2NPzR4pdUCydVsR
        Pi8Tc9X1BCOBenSJG7kf8EiPINOGWT0=
X-Google-Smtp-Source: ACHHUZ7ih376uDQYejzIQR4xACdEL2k0PZnrE6cuKinRze845ShQqbOR6NOOQNiJKSvDbrYY85hLVw==
X-Received: by 2002:a05:6a00:a8e:b0:644:18fe:91cc with SMTP id b14-20020a056a000a8e00b0064418fe91ccmr2908520pfl.12.1685451500842;
        Tue, 30 May 2023 05:58:20 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c17-20020aa78c11000000b0063afb08afeesm1605007pfd.67.2023.05.30.05.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 05:58:20 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] ksmbd: fix posix_acls and acls dereferencing possible ERR_PTR()
Date:   Tue, 30 May 2023 21:57:56 +0900
Message-Id: <20230530125757.12910-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530125757.12910-1-linkinjeon@kernel.org>
References: <20230530125757.12910-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dan reported the following error message:

fs/smb/server/smbacl.c:1296 smb_check_perm_dacl()
    error: 'posix_acls' dereferencing possible ERR_PTR()
fs/smb/server/vfs.c:1323 ksmbd_vfs_make_xattr_posix_acl()
    error: 'posix_acls' dereferencing possible ERR_PTR()
fs/smb/server/vfs.c:1830 ksmbd_vfs_inherit_posix_acl()
    error: 'acls' dereferencing possible ERR_PTR()

__get_acl() returns a mix of error pointers and NULL. This change it
with IS_ERR_OR_NULL().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 fs/smb/server/vfs.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 6d6cfb6957a9..0a5862a61c77 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1290,7 +1290,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
 		posix_acls = get_inode_acl(d_inode(path->dentry), ACL_TYPE_ACCESS);
-		if (posix_acls && !found) {
+		if (!IS_ERR_OR_NULL(posix_acls) && !found) {
 			unsigned int id = -1;
 
 			pa_entry = posix_acls->a_entries;
@@ -1314,7 +1314,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 				}
 			}
 		}
-		if (posix_acls)
+		if (!IS_ERR_OR_NULL(posix_acls))
 			posix_acl_release(posix_acls);
 	}
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 6f302919e9f7..f9fb778247e7 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1321,7 +1321,7 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(struct mnt_idmap *id
 		return NULL;
 
 	posix_acls = get_inode_acl(inode, acl_type);
-	if (!posix_acls)
+	if (IS_ERR_OR_NULL(posix_acls))
 		return NULL;
 
 	smb_acl = kzalloc(sizeof(struct xattr_smb_acl) +
@@ -1830,7 +1830,7 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 		return -EOPNOTSUPP;
 
 	acls = get_inode_acl(parent_inode, ACL_TYPE_DEFAULT);
-	if (!acls)
+	if (IS_ERR_OR_NULL(acls))
 		return -ENOENT;
 	pace = acls->a_entries;
 
-- 
2.25.1

