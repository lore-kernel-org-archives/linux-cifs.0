Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF10C25B06
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 02:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiHLCLr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 22:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiHLCLr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 22:11:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB128A2237
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 19:11:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f28so18016136pfk.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 19:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=7dOghXT81ZbpvDYaG39ipYK8bRhaJI6yG+jntR77toU=;
        b=ZBFE1F//X1oi9G6j6FFNe5ldyswP/yvPrlIhIhXUQwMLJD5itHQyAk0Q8dYGaWON6w
         vcEHgOo9gFbcxa+As92vC5HEWeZm3STSQ/4fRoB7f6R2U2KUXzF133KYOXNu25/pNAws
         6IvGUTHzXJrSX4MUPCiFIwYD16WKWd32xsvBFNuZHB/G0H+62/8Lhu6cnYZvv06O7rtb
         c/+vFTGrBCXSlnBGvKib3cPtq7J3IE/kmPfurAFJHR5+/TSnQ7EpbMWgAxldKtN4hVVT
         EYlg7FxNd6R/hYt8OasisnbNI/DvKe99PmBghPiSNU6wOewTU9+rEP9/uHZS/XUwI1Yv
         UksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=7dOghXT81ZbpvDYaG39ipYK8bRhaJI6yG+jntR77toU=;
        b=B/reB7glz33SVfy/vtm5TmUijptG00JcA8AEIAdZlYMv3VhfQ85DL5woCZummPT/nN
         HA0vlwCNFbBEfaZCVVjQrnoDbjR+pklbkJdjHV8M7wiyF6MKS0LXNfFyjnoqP2NyiNNQ
         G2/Zq5LAsOesdXGwT5dYN7Qs/DH8FGDL0TwNpkxMYUbhPmE/IxNl+neFmsy36pXxvEr8
         HNcq+a3aNBoYqctgMqjvFU5pVwN8qX+c0OJTKF31HgOWyD0oLeCig+NcurL14tywf4HF
         mSlQlQeG72Gcf3UU+C4IgvvcXxv59PdPWFjAEb0h4ee+XNRIeHw4wJKanArgTUkqe7JZ
         h8Pw==
X-Gm-Message-State: ACgBeo2VXq+0jzLJDOofhfB+t+R8MTwQcujUkOyqrdge4cbDp7IdHPt8
        FCGZGFpPRM6g9ugUHiC32ccKUKtNhVeLgg==
X-Google-Smtp-Source: AA6agR6eyXX/LkTSjznn/Qpihq0ZzDWyys/jEWbJDZS4spk+C1+9nGn/NIL0tka9oZO/5EbVx0Q7GQ==
X-Received: by 2002:a63:e741:0:b0:41d:5cc8:224 with SMTP id j1-20020a63e741000000b0041d5cc80224mr1468848pgk.578.1660270304744;
        Thu, 11 Aug 2022 19:11:44 -0700 (PDT)
Received: from localhost.localdomain ([210.217.8.148])
        by smtp.googlemail.com with ESMTPSA id r27-20020aa7989b000000b0052d16416effsm380537pfl.80.2022.08.11.19.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 19:11:44 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4] ksmbd: remove unnecessary generic_fillattr in smb2_open
Date:   Fri, 12 Aug 2022 11:11:32 +0900
Message-Id: <20220812021132.35077-1-hyc.lee@gmail.com>
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
Changes from v3:
 - Delete generic_fillattr.

 fs/ksmbd/smb2pdu.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 9751cc92c111..c41ec3d2abe8 100644
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
@@ -3134,6 +3128,10 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
+	rc = ksmbd_vfs_getattr(&path, &stat);
+	if (rc)
+		goto err_out;
+
 	if (stat.result_mask & STATX_BTIME)
 		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
 	else
@@ -3149,9 +3147,6 @@ int smb2_open(struct ksmbd_work *work)
 
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
-	generic_fillattr(user_ns, file_inode(fp->filp),
-			 &stat);
-
 	rsp->StructureSize = cpu_to_le16(89);
 	rcu_read_lock();
 	opinfo = rcu_dereference(fp->f_opinfo);
-- 
2.25.1

