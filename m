Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8B4C19F2D
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 06:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiHKGhc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 02:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiHKGhS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 02:37:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B601071723
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 23:37:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so4247954pjf.2
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 23:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=OuYVPdZi4KWl+dJmjGrQz6VqctL9ddVl0nHKJiTz3Cg=;
        b=j1o/27ka6wIOsqWVr9Q3zqel7ci/qkfQzbYGQkDT+O+3GxTAIsqqm7+rm3H9QQD3YC
         vXcpQ+9m5C24cb5Bq0tG4tMDKy+4lbwCm3kp30SshqHmbvbF8Yx5X6ZXI8IZqjMt1Wmf
         iI+99GhqOaQjF9Bu8r9BPiXMwdA0OaQ8NfeA/wYS8z09U8IPxo3ofocfbMeyQxyk9tnf
         N8PgHaaB6ZgLG3KJWWzPm86iZCko9ZR4MCtIAFVxw8gReMPC+jTWpyjz9YOiVnYgAkJw
         khFyZdHnoCF1gBJHBC9IizHEEjpHAQWcU74LHVKvMgyVgK+z/U24LyA3MB0M1PfBpqoj
         E+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=OuYVPdZi4KWl+dJmjGrQz6VqctL9ddVl0nHKJiTz3Cg=;
        b=nMH3mLmZNLEObyXuaOfpV4WL6bYIly+/7cEgHmHb2OaNJGRX2AKl7W8pRwHlcFPBS9
         s50n9IdbNRLcX3vyAV/R0YGa1VXHicU9qVVm2Ye0i+toAW4bGbww3fQqqiwRs8NIKQEL
         0B1sgltZd7SS2jPq4HNTlMGdKVMjLL+boCJO6dVdiI3VqU3Ty/SAN9FEa12yMhDfXADY
         bqcq0w3G7j/V/YEmrZOTY2cgjAESpzGqgInzNhVV+ZnRwCzxP5+dsUv5Lh7NiDVpIsLc
         uv8blOb+8JSh34ws8auing73Xc/r/lYxB5nXtw2VxArOCbAYl/AwkOb4xgC4/fWeNDUY
         z1lA==
X-Gm-Message-State: ACgBeo01nHZvJ0eawQswnfcdJAw8jL8KB65rUKuXppm1h269LRMLDKZI
        zCpk+OI+fDkbhHUKRMI6gEHNFMijZqY=
X-Google-Smtp-Source: AA6agR5vsXydKNB1L1qpzSW3HBkM4qj8BCi6jLyuPrs80lziQ3E4ij0TXTIQLR9b9diewULvvywXfg==
X-Received: by 2002:a17:90a:d783:b0:1f4:e30b:ece with SMTP id z3-20020a17090ad78300b001f4e30b0ecemr7407965pju.165.1660199836904;
        Wed, 10 Aug 2022 23:37:16 -0700 (PDT)
Received: from localhost.localdomain ([210.217.8.148])
        by smtp.googlemail.com with ESMTPSA id oj7-20020a17090b4d8700b001df264610c4sm11671725pjb.0.2022.08.10.23.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 23:37:16 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v3] ksmbd: remove unnecessary generic_fillattr in smb2_open
Date:   Thu, 11 Aug 2022 15:36:59 +0900
Message-Id: <20220811063659.67248-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove unnecessary generic_fillattr to fix wrong
AllocationSize of SMB2_CREATE response, And
Move the call of ksmbd_vfs_getattr above the place
where stat is needed because of truncate.

This patch fixes wrong AllocationSize of SMB2_CREATE
response. Because ext4 updates inode->i_blocks only
when disk space is allocated, generic_fillattr does
not set stat.blocks properly for delayed allocation.
But ext4 returns the blocks that include the delayed
allocation blocks when getattr is called.

The issue can be reproduced with commands below:

touch ${FILENAME}
xfs_io -c "pwrite -S 0xAB 0 40k" ${FILENAME}
xfs_io -c "stat" ${FILENAME}

40KB are written, but the count of blocks is 8.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
Changes from v1:
 - Update the commit description.
Changes from v2:
 - Fix the commit description and add the way
   to reproduce the issue.

 fs/ksmbd/smb2pdu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 9751cc92c111..d0a0256334ea 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3042,12 +3042,6 @@ int smb2_open(struct ksmbd_work *work)
 	list_add(&fp->node, &fp->f_ci->m_fp_list);
 	write_unlock(&fp->f_ci->m_lock);
 
-	rc = ksmbd_vfs_getattr(&path, &stat);
-	if (rc) {
-		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
-		rc = 0;
-	}
-
 	/* Check delete pending among previous fp before oplock break */
 	if (ksmbd_inode_pending_delete(fp)) {
 		rc = -EBUSY;
@@ -3134,6 +3128,12 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
+	rc = ksmbd_vfs_getattr(&path, &stat);
+	if (rc) {
+		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
+		rc = 0;
+	}
+
 	if (stat.result_mask & STATX_BTIME)
 		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
 	else
@@ -3149,9 +3149,6 @@ int smb2_open(struct ksmbd_work *work)
 
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
-	generic_fillattr(user_ns, file_inode(fp->filp),
-			 &stat);
-
 	rsp->StructureSize = cpu_to_le16(89);
 	rcu_read_lock();
 	opinfo = rcu_dereference(fp->f_opinfo);
-- 
2.25.1

