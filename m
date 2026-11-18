Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961535;
	b=Tr6b/85kO0E5up+dbbxXDnOmWuCKDgd9pxFnCUmr7djqKfmoktJNqhC8xhHl6ww9YSrw
	 q6AFyspBj44eWhhZqOQtO/YOzZuLxb50tgb9L520iwtLK52orIiba9r7GfD2FLhxZuVpp
	 k3pSh/B7rk3zN5QRS7FRKVabPIRG8decrOHipeDe9yIrjI1om7FvDdvBu8BFvg4RYqZUO
	 ciySp4nDILuznZS2nJJfGRBvfCgOlhKQCY8GDdNAsQz04KQ9Yj3qIuILJhNCSSJtziMON
	 rQq9IIYCIsUiCaHTCRSVJjzttatTWd1Lh2OIz6TDsp1frX0TiCLhjlDs9eKl3DjdEkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961535;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z+N2Sizs3DgoA4nmWWFLDvklML3guJTnnLBvLJVgIbY=;
	b=Pc3JkSpVeuI9B3mQ1PMoxXikU3Wh7cPnhG4XKoLYsdtoMQObV5OjNzjKsEj8JVsiHZcl
	 F1pfaV36c80oKiPOERTQ3Ipen0IbFrSisoXbOeZxMbxGm9Fs8NPXSuNfAkM4MJM1L0LqH
	 sUgcsJ3TA3lN+JgAHffOlXo7umR7eKkE3BbRfxYnH3kBqo141bITyMn6S6caWQsgrl1sU
	 wYkR8tAjqke78wadvBKijxGXzZCv+O1Q7wYzCGFgXxhUtgXB+tUvwZfSZnuRULmH+5FgQ
	 +xmMW/ofRLBNa91atcr8dqEt4wlrs8EFp/co5cjD2xeS+ONTeySl08h8I7dpz4ILNsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bmu20wZ5;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636BB606A881
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 00:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 636BB606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bmu20wZ5
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so322772a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 16:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794961535; x=1795566335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z+N2Sizs3DgoA4nmWWFLDvklML3guJTnnLBvLJVgIbY=;
        b=bmu20wZ5lXC+T9AYEFLwsA8BVxMCihqGCwXzxaskLrCErvzjh5tj7X0bvjyyguw4rc
         Jr8h5t6Cw0yr4ux3uoJFOSZIxPjQlzDA0S8m26Olw1wOm1DIVuPgKIYvlK9KaKo72kvo
         DKylv7wsCVJhOfOAlctpDKpwSCKinK4AZPPpRkXYGBHj5deFtC9C39a2D0pPVLwpm64y
         +kSEXh/oS/T/2outLOKbcJXb+T4dmT1jgqZBESP3zssXr/IDrs4igb1PAtq1D7IFshBu
         4OHdpWngYA6vlyNqcAgTQEN6BCg9w1oYS5bJyJdAeujumT3gUoiJ1+MWpDIuzrdayKLn
         t8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794961535; x=1795566335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z+N2Sizs3DgoA4nmWWFLDvklML3guJTnnLBvLJVgIbY=;
        b=RYysHt0ClpT5jK6mBUwtrE7iQVkOIFKVdFxiIKiOp2tyxVipJMk3xH+1D1unWyZxMx
         P4DpdYepFPNQ9ITDZ/2c9pfQ2nMznunyULvnDTm+8NLtKcu37Si15k5oRzeuiyYriRTX
         tG4pr3a0jyHKrEblgngwRyKKiWvx+Bz5Eh0Mf2EgRL9URsXB4UzDv2qu/WYusUGP1uZU
         yw2hC19w4dePEtS1mbhnGofgoWgvs3F6kUUT8edEIi7kZeAGr5w6JB2HyLDcc6aDZU35
         rSiRRrwXpTrUlVDjM4m4Yv6IwYm0rIM5zNLfJwPFP7bHT92w/KmskMS1NPP4R8x8VuCh
         1dNQ==
X-Forwarded-Encrypted: i=1; AL+hErEdR7xo//QbqbQBbHDZhoIiPTYQkreZs6hJjjFPjiLG4h9iJwhaGLr0+mfav7DrDHG0wNv/PWkMnPga@vger.kernel.org
X-Gm-Message-State: APuU4Z/nl7J9ms6LHlw3L0BTf5qO/qfXfon2yom9L8cR8/KzjxYgHAPz
	iJJrp8BjvofDXOKz18yaZot+kCytx+WsxCb0djAxLrgVeFYBnR+nJBQA
X-Gm-Gg: AZFdTZfiCodsrBK4kx0wjcC80zO0NFv7f0pEHTuQvrM/o5p8lOi6WkNV+uRRdl4M3ef
	6Zx7HqAbVPSasfvISmhvsPhLiMzFfy85HhWKxEUc66Wk8MeGuBDRYH9zJIoA2coyXaasyxq4RHv
	d+WU58x1ZPJGaj82z4Sfi3H7zOF3XZ+VQX89NIj/i82/tRyPQ0HQnWBlcEIKk/hBn1CtK67kzSA
	yL7c6BYHHGhvGXQujNvmD2FjBKE8lf9qUPdzAsvyFhsXOHpdBvOiSjyQjJp2Idi31ZA6TpaNxEq
	BIHjeHEnS+LYrvcIAgYfu11DwqnYtmve2TMg+dzeLkfqTWB/035EaYM+OMKa7ER2Uq5vuRlQcA8
	hwne7zbZXOHmAeo1kbvjwQXcH5t0XayCxaW5APanTjsTzk+0GSLJ39TWfsyWNtdb5huT27Qa0zF
	h4VZEh1hmCA7Fj08EpOaFcvaFhbp9xgdbi+Id/XSbtLXwstpFsgFt9GmBCzi7xYu4kYYzB730HJ
	sT4qmd4pMzZH943KzID5+ziqC6KDdomLL3klQKoR3hbMSfEY7N9NHaXiqBwHkGzKKUqo4iMVwHS
	186/LFWxIQt8zgooQYDtg2T7Ykj722RtYX5abvNRFXHgO8sLq6QJgz0G3qBBVUUmfl5mhagJ8mt
	h/CFZR8zJ5Ms1235EKiirWQR6XmwA/PWavxSfFdPGlboXS9iappoyCdTcBaOeUOFGzum2+8AAa1
	bN2c0bOHRG8njRMq9DRRl2SDfzZbpLbPVnuDlFXcua
X-Received: by 2002:a17:90b:384a:b0:3ac:17c:6e89 with SMTP id 98e67ed59e1d1-3b3d079ffd2mr797101a91.19.1794961534698;
        Tue, 17 Nov 2026 16:25:34 -0800 (PST)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d1c04020sm1212211a91.17.2026.11.17.16.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:25:34 -0800 (PST)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Allen Pais <apais@microsoft.com>,
	Rachel Menge <rachelmenge@linux.microsoft.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Gillian Laming <glaming@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] smb: client: fix busy dentry on unmount from cancelled deferred close
Date: Wed, 18 Nov 2026 00:25:29 +0000
Message-ID: <20261118002529.250616-3-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118002529.250616-1-sidchintamaneni@gmail.com>
References: <20261118002529.250616-1-sidchintamaneni@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When cifs_close_deferred_file(), cifs_close_all_deferred_files(), or
cifs_close_deferred_file_under_dentry() cancels a pending deferred close
via cancel_delayed_work(&cfile->deferred), the cifsFileInfo is moved to
a thread-local stack list (file_head) before open_file_lock is dropped
and _cifsFileInfo_put() is called outside the lock.

Because tcon->openFileList is shared across superblocks using the same
tree connection, a concurrent operation or unmount on a sibling mount
sharing the tcon can cancel a deferred close work item belonging to a
superblock that is concurrently unmounting. Once cancel_delayed_work()
removes the work from deferredclose_wq, cifs_kill_sb() observes neither
a pending delayed work item on deferredclose_wq nor a non-zero
outstanding_rreq counter, and proceeds to kill_anon_super() before
_cifsFileInfo_put() drops cfile->dentry:

  Thread 1 (umount sb1)            Thread 2 (sibling mount / rename)
  ---------------------            ---------------------------------
                                   cifs_close_all_deferred_files(tcon)
                                     spin_lock(&tcon->open_file_lock)
                                     cancel_delayed_work(&cfile->deferred)
                                     list_add_tail(..., &file_head)
                                     spin_unlock(&tcon->open_file_lock)
  cifs_kill_sb(sb1)
    cifs_close_all_deferred_files_sb()
      [delayed_work_pending == false]
    flush(cifsoplockd_wq)
    flush(deferredclose_wq)
    wait(outstanding_rreq == 0)
    flush(serverclose_wq)
    flush(fileinfo_put_wq)
    kill_anon_super(sb1)
      -> generic_shutdown_super()
         BUG: Dentry still in use (1)
         VFS: Busy inodes after unmount!
                                     _cifsFileInfo_put(cfile, true, false)
                                       dput(cfile->dentry) [too late]

Fix this by incrementing cifs_sb->outstanding_rreq while still holding
open_file_lock whenever cancel_delayed_work(&cfile->deferred) succeeds,
and decrementing it (waking any waiter in cifs_kill_sb()) after
_cifsFileInfo_put() completes.

Fixes: 5efdd9122eff ("smb3: allow deferred close timeout to be configurable")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
---
 fs/smb/client/misc.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 72a986bfaefc4..5072efd0ea568 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -502,15 +502,19 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *cfile = NULL, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
+	struct cifs_sb_info *cifs_sb;
 	LIST_HEAD(file_head);
 
 	if (cifs_inode == NULL)
 		return;
 
+	cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
+
 	spin_lock(&cifs_inode->open_file_lock);
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				atomic_inc(&cifs_sb->outstanding_rreq);
 				spin_lock(&cifs_inode->deferred_lock);
 				cifs_del_deferred_close(cfile);
 				spin_unlock(&cifs_inode->deferred_lock);
@@ -528,11 +532,16 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	}
 	spin_unlock(&cifs_inode->open_file_lock);
 
-	if (failed_cfile)
+	if (failed_cfile) {
 		_cifsFileInfo_put(failed_cfile, false, false);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
+	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		_cifsFileInfo_put(tmp_list->cfile, false, false);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -543,12 +552,15 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
+	struct cifs_sb_info *cifs_sb;
 	LIST_HEAD(file_head);
 
 	spin_lock(&tcon->open_file_lock);
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				cifs_sb = CIFS_SB(d_inode(cfile->dentry)->i_sb);
+				atomic_inc(&cifs_sb->outstanding_rreq);
 				spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 				cifs_del_deferred_close(cfile);
 				spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
@@ -566,11 +578,18 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	if (failed_cfile)
+	if (failed_cfile) {
+		cifs_sb = CIFS_SB(d_inode(failed_cfile->dentry)->i_sb);
 		_cifsFileInfo_put(failed_cfile, true, false);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
+	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
+		cifs_sb = CIFS_SB(d_inode(tmp_list->cfile->dentry)->i_sb);
 		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -618,6 +637,7 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 {
 	struct file_list *tmp_list, *tmp_next_list;
 	struct cifsFileInfo *cfile, *failed_cfile = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	LIST_HEAD(file_head);
 
 	spin_lock(&tcon->open_file_lock);
@@ -625,6 +645,7 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 		if ((cfile->dentry == dentry) &&
 		    delayed_work_pending(&cfile->deferred) &&
 		    cancel_delayed_work(&cfile->deferred)) {
+			atomic_inc(&cifs_sb->outstanding_rreq);
 			spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 			cifs_del_deferred_close(cfile);
 			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
@@ -640,11 +661,16 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	if (failed_cfile)
+	if (failed_cfile) {
 		_cifsFileInfo_put(failed_cfile, true, false);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
+	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-- 
2.43.0

