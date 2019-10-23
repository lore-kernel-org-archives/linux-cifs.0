Return-Path: <SRS0=Yjbq=YQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509A1CA9EB9
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 22:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F6E220663
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 22:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sVHezYDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbfJWWzs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Oct 2019 18:55:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46644 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbfJWWzs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Oct 2019 18:55:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id e15so12975506pgu.13
        for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2019 15:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uEWVNeR2W07hTCVyB8RjEut1LPMiDrNPqmTc4HggtgA=;
        b=sVHezYDmrOpFWT+XYbxN7T2sjwiwoOjXP3q5815Sjr7Ah4NHFQkxkpjRH8kaXHIWUl
         CeE9j9zGeY50XoF5/IHbk00WwIRd9WAGCqo4J7rrAAzmf2Ea1RyRfe3QJRUYT5ybaDXD
         /avz2C7glgckP0MCullO0469fVNNe1J31ADA8ru4vaURa2tgw3mh3YsO4LPQh53xLpMG
         2c+VO3ydJNmo4qlVBjF7+LxlsmcrM9JxgYmMTKmh01sKziptj0yQ+cd5kiA+HRghEdAN
         PFkuSk1z0AilJX2OkKoFrkADBJealk0hC9yWyjEi5WFGoIYtIXOqTfynj3drawG+Ai9E
         Pj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uEWVNeR2W07hTCVyB8RjEut1LPMiDrNPqmTc4HggtgA=;
        b=RlCww+qdGw2Cxma2XGFBSYvKaguqRztqJVVUAhTwOfyQyd9bVd7RAKLXyzoIx1/LKM
         nSWcre3nlE0b1TY44WgVpsA3WV8WQuYICnDSYR90sIGcgvcK36zZS9vsQmiVjQf6zo/L
         1fLmOGjMgrI5w+x/I3Ks2bUfGqWD7LL/10ZY4PPNlUOwKm05d9sJ9QZkofSSwnZw8RbO
         IiioXQ/6f1FrgyP8wfKjttw0VoDWOHiUm+ZTeIxg9ACnWnMchP8rfKMDqCwT3hBjqb0c
         0GFgqLbQpF0MjgzL4UgGpuVI8xHwOmvqwb9yjZucB1XCTqCo7u3Nyz0X96QN2kIcQdrU
         b0mg==
X-Gm-Message-State: APjAAAUc4/3fDxKMWA9EIdhlA21mX1toUxW5QKiuqhaa5LozgxQRLCOQ
        WVekYX81I+kU8kUJFlNtZuL8Vv8=
X-Google-Smtp-Source: APXvYqyQza5xaAn+rS1r38WQ2PVl6v78Roxyt70TNylno+7y3tWLxb5oSrZifZ6H2mfX6xuUXXmY8A==
X-Received: by 2002:a63:f40e:: with SMTP id g14mr13067007pgi.62.1571871347758;
        Wed, 23 Oct 2019 15:55:47 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([167.220.2.106])
        by smtp.gmail.com with ESMTPSA id z13sm29022860pfq.121.2019.10.23.15.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 15:55:46 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Subject: [PATCH] CIFS: Fix use after free of file info structures
Date:   Wed, 23 Oct 2019 15:55:40 -0700
Message-Id: <20191023225540.1916-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently the code assumes that if a file info entry belongs
to lists of open file handles of an inode and a tcon then
it has non-zero reference. The recent changes broke that
assumption when putting the last reference of the file info.
There may be a situation when a file is being deleted but
nothing prevents another thread to reference it again
and start using it. This happens because we do not hold
the inode list lock while checking the number of references
of the file info structure. Fix this by doing the proper
locking when doing the check.

Fixes: 487317c99477d ("cifs: add spinlock for the openFileList to cifsInodeInfo")
Fixes: cb248819d209d ("cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a panic")
Cc: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4c1aeb2cf7f5..53dbb6e0d390 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -405,10 +405,11 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 	bool oplock_break_cancelled;
 
 	spin_lock(&tcon->open_file_lock);
-
+	spin_lock(&cifsi->open_file_lock);
 	spin_lock(&cifs_file->file_info_lock);
 	if (--cifs_file->count > 0) {
 		spin_unlock(&cifs_file->file_info_lock);
+		spin_unlock(&cifsi->open_file_lock);
 		spin_unlock(&tcon->open_file_lock);
 		return;
 	}
@@ -421,9 +422,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
-	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
-	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
 	atomic_dec(&tcon->num_local_opens);
 
@@ -440,6 +439,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 		cifs_set_oplock_level(cifsi, 0);
 	}
 
+	spin_unlock(&cifsi->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
 	oplock_break_cancelled = wait_oplock_handler ?
-- 
2.17.1

