Return-Path: <SRS0=WfTT=ZU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AEBAC432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Nov 2019 00:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44B2420880
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Nov 2019 00:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cno79HeP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfK1ASq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Nov 2019 19:18:46 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43200 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfK1ASq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Nov 2019 19:18:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id q16so6508077plr.10
        for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2019 16:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z7WT6TlimMbjtIKwrRX9EAWDAHcZK5Jtg9Ed5895akI=;
        b=Cno79HePthfzjOdsHTW+Fu9qsqzA+S9hkx2SboW3aMnOOWeJZCOM+U/xZUPoFAE1NL
         BRT8ZNq66k7x3blC9fKfmiITWLogocewJ4geo/Rglx4REWa8rQddlqhVc9SDOwyTb3RK
         Cq+zEOn+Les7r3tKEV2T+RrV/ZKm18jtRfmRTWWqCXKVKUeSMKmkSfNE/R8y9uf3E1H1
         JIUy+YUOezSjGNmlxRfHsO1nz4zb2QaCXaoC9wds8hK5j0WkpDTfz9mdvQgBAFGvHaMo
         2g9kpffLi77Drna9dLPA6oTo1roZFNmZTZkpnZbDYgQDdvu+SYCm1j+m4Blg3pdtY0kZ
         b4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z7WT6TlimMbjtIKwrRX9EAWDAHcZK5Jtg9Ed5895akI=;
        b=KtCayFngfMedASbHiB/w/wSRqXEtwGHJTKo5j49D35X7kUzIkwqwg8VX79/2MkBf61
         Q/uHsbc+JRsind45Ic8SPsaENuBdG6N0k9+GAsbelfT3EUhkBII6N0O2hNDIp3hfI1OD
         +LQWRiLeMtv05i6olbYSYvhgNXRBikhwmpu98IH13asCLb8A/Yspmw9hFR7lCN/2x+in
         neqWEP89c6f1PpHcBsKY6TYdcfcbebVgs0GqF7cfZN2eHfQhQKLk9+VMEfgouIHA2vi8
         QMfE9wAQj86lYJt38RrpoRh6B7aRhR0RtprmZMGRlSV89SWjGeoksKSMbCkE4d7A1ysY
         bFwQ==
X-Gm-Message-State: APjAAAXK8eAEbTsskTRaEyswxZtaowXjtrZjtLbPZsGxhGyhJgpTRi7q
        15YwuPRLv83Qxbou6kC2pQ==
X-Google-Smtp-Source: APXvYqzB6+Fok1hA5NV1YullLnlhLamXRgTmZ7EePHi3fSomiQsnE4WhhAovcqRv7w8KYnfODhfl3Q==
X-Received: by 2002:a17:90a:3d01:: with SMTP id h1mr9676957pjc.15.1574900325856;
        Wed, 27 Nov 2019 16:18:45 -0800 (PST)
Received: from ubuntu-vm.mshome.net ([167.220.2.106])
        by smtp.gmail.com with ESMTPSA id f132sm3995439pgc.50.2019.11.27.16.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 16:18:44 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
Date:   Wed, 27 Nov 2019 16:18:39 -0800
Message-Id: <20191128001839.5926-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently when the client creates a cifsFileInfo structure for
a newly opened file, it allocates a list of byte-range locks
with a pointer to the new cfile and attaches this list to the
inode's lock list. The latter happens before initializing all
other fields, e.g. cfile->tlink. Thus a partially initialized
cifsFileInfo structure becomes available to other threads that
walk through the inode's lock list. One example of such a thread
may be an oplock break worker thread that tries to push all
cached byte-range locks. This causes NULL-pointer dereference
in smb2_push_mandatory_locks() when accessing cfile->tlink:

[598428.945633] BUG: kernel NULL pointer dereference, address: 0000000000000038
...
[598428.945749] Workqueue: cifsoplockd cifs_oplock_break [cifs]
[598428.945793] RIP: 0010:smb2_push_mandatory_locks+0xd6/0x5a0 [cifs]
...
[598428.945834] Call Trace:
[598428.945870]  ? cifs_revalidate_mapping+0x45/0x90 [cifs]
[598428.945901]  cifs_oplock_break+0x13d/0x450 [cifs]
[598428.945909]  process_one_work+0x1db/0x380
[598428.945914]  worker_thread+0x4d/0x400
[598428.945921]  kthread+0x104/0x140
[598428.945925]  ? process_one_work+0x380/0x380
[598428.945931]  ? kthread_park+0x80/0x80
[598428.945937]  ret_from_fork+0x35/0x40

Fix this by reordering initialization steps of the cifsFileInfo
structure: initialize all the fields first and then add the new
byte-range lock list to the inode's lock list.

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 520fbe4d42b9..069635ec9d94 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -313,9 +313,6 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile = cfile;
 	cfile->llist = fdlocks;
-	cifs_down_write(&cinode->lock_sem);
-	list_add(&fdlocks->llist, &cinode->llist);
-	up_write(&cinode->lock_sem);
 
 	cfile->count = 1;
 	cfile->pid = current->tgid;
@@ -339,6 +336,10 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		oplock = 0;
 	}
 
+	cifs_down_write(&cinode->lock_sem);
+	list_add(&fdlocks->llist, &cinode->llist);
+	up_write(&cinode->lock_sem);
+
 	spin_lock(&tcon->open_file_lock);
 	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
 		oplock = fid->pending_open->oplock;
-- 
2.17.1

