Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBFD340DB1
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 18:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769885241; cv=none; b=Uc6cHuo9l48X4zlCJddmMNgVGvUjYM2hhbvybgoWs2VJPn/oItGxyXin4XSB//IoKNjtg0sKuey5KCGq5AsP9eRuT7Xl0p3ROpZzORV4+ZUK9OPcd+3Opk5087aA6jMr+6BaiBhWdxv+1zT3fDlgEm7Q1hjVXSSH6+93BW9VtKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769885241; c=relaxed/simple;
	bh=GexA1esZ8rXgcv9tbZyJA5DRdvVuhFKD3hxWBNpfEeA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OFMOvy5wYXZ0jdXFzff1poJujWHlzbssd7h2MEQLZgoSUngKmV2O6BT7MKYuA0/h0qEnm124IJLZOuZKPgzvnRIb1TDgkOvysoOATgcWQIewC1KaG5JblBF5kWBX6bZNhhXA/kqVoPvFxf7ZCoJhMhN8mWcYrZnGQZyYWob4sXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gCxSVrnP; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gCxSVrnP"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a7b47a5460so18929605ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 10:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769885239; x=1770490039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hd/qnYLVO1Wsv2GV7hPybooZwU8uUpLJaZLIXvVL72o=;
        b=gCxSVrnPNTp1SxxZ2AgM6TeZopd84YYLPowJxzz9dcKVU4pqxCF80xl8FmiC5nHyqA
         eOtM+lSEQDubI5+yGJJPsXqJu+2fOwdr3ZMo0J5z3vimohTswAHd8bn4rIHCvgMeqTq+
         iTGUx0OenHaxpuBJMyVUU3RxuyRLhzczESSCInYyKoaDO/vxizyKW7FwEDqrT8Kwh0jZ
         ZfeqQa/lX0K09XmcPduufualM6dRXwtG1yg1hkp/zBh7PXmoBXVvi/XrVCVXG7OM8duz
         ifYnvYsWjA9ZHGa+GVIh8peCqpkm3/FkRqyGZhYVukq2aWOjVKshPReiuGM0zC93ETY2
         2uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769885239; x=1770490039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hd/qnYLVO1Wsv2GV7hPybooZwU8uUpLJaZLIXvVL72o=;
        b=JpcgmYgYux3lqKLBNAH7CgJRTI9FHTHXsNlJXp6PNM+4xn2FsTwFWSjLi7qZs9WqG0
         QwKz/Fs1uPL4CB1RpPgnylCyEium2cdTQXhaT296ljK75Hvt3kpjfZjq5gapJ7jeatfZ
         KLdpuVjIVQ1PlrVptFxEW/QfUqs/pehMJzKkQTXjT2Cha9/nF7wwPhDCSi/47qfa4/uE
         Lljp02rZAcnXy/DQ+E+U4kqpzTOWzmt8tXukEh2waSSWcpAXGOS9nEOSAKK/wSO3jc82
         UfhBwOKU/x9ueeZN0M6T3ErdVQrh/G3LDWrQ1JPJtbyNUmtrRGXf3NSDLU2kFPLmR2P4
         HLSg==
X-Gm-Message-State: AOJu0YxK7FhVrEvBzu7dOyiGjjMRBDNu9sWJbGE8jlZQSeKpZ6DrX4BJ
	6Vyhiyy2BB5SrOR0DErmFgVbVrELYwnzUK2A+KiWPax5BgMerYHBnU/oOfwi4s1W
X-Gm-Gg: AZuq6aJnNEIkprczvsYYdVeJZXs53F6gF5MDYCvwsnGPS94YEqg4bpz0NSSnYLsUCK5
	SfN/1YmijoTHTX8LG/mh1n1wT+Y/4UKYMsy5dx/K12NR0fWxnUrw2/12ZuiW8R+PrxsQasHN28s
	yqvXrMOhDqimKvaWZNSJA4DuHI89NNgzk9ug6j/ZEtTl+7lAp55b4IwcVR/zQt4MkPJCXuY7foS
	OOcTh0cl+1wFbGqA77l2OJP7mHl5lhQQr22ZJ2/4F16EKtRnDqdkEaX+u5VsF/lmochlXrrt4P8
	FsQKWlssgTL3j3S6XxTl1C/Oyy6DptwQ5y0eEZStOc2Kc8cmmphAu+Ke8/QyxMiDOonAwQvb6l5
	VF7SPG18JEY6CGYCC5WFkkMM85dPLAQzYcH78BP1ZzAduiCuBWdg14Mh29EHzHTzXeI7pegyR1e
	ufpk2RKTDbGLNxoS5v8cIwqpKdgYGYxySFzZ9Z1GhXG1BbM11D7vY=
X-Received: by 2002:a17:903:2f86:b0:2a7:a6fa:eddf with SMTP id d9443c01a7336-2a8d99514femr68793995ad.17.1769885238678;
        Sat, 31 Jan 2026 10:47:18 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e4110sm100145285ad.84.2026.01.31.10.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 10:47:18 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: open files should not hold ref on superblock
Date: Sun,  1 Feb 2026 00:16:36 +0530
Message-ID: <20260131184656.972897-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today whenever we deal with a file, in addition to holding
a reference on the dentry, we also get a reference on the
superblock. This happens in two cases:
1. when a new cinode is allocated
2. when an oplock break is being processed

This code change allows these code paths to use a ref on the
dentry (and hence the inode). That way, umount is
ensured to clean up SMB client resources when it's the last
ref on the superblock (For ex: when same objects are shared).

The code change also moves the call to close all the files in
deferred close list to the umount code path.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsfs.c    |  4 ++--
 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/connect.c   |  2 ++
 fs/smb/client/file.c      | 11 -----------
 fs/smb/client/misc.c      | 36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a3dc7cb1ab541..277dabd982cbd 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -331,10 +331,11 @@ static void cifs_kill_sb(struct super_block *sb)
 
 	/*
 	 * We need to release all dentries for the cached directories
-	 * before we kill the sb.
+	 * and close all deferred file handles before we kill the sb.
 	 */
 	if (cifs_sb->root) {
 		close_all_cached_dirs(cifs_sb);
+		cifs_close_all_deferred_files_sb(cifs_sb);
 
 		/* finally release root dentry */
 		dput(cifs_sb->root);
@@ -865,7 +866,6 @@ static void cifs_umount_begin(struct super_block *sb)
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	cifs_close_all_deferred_files(tcon);
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f8c0615d4ee42..5feaeac16b0c5 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -302,6 +302,8 @@ extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
 
 extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
 
+extern void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb);
+
 void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
 					   struct dentry *dentry);
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ce620503e9f70..31745ef692390 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4149,6 +4149,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	if (cifs_sb->master_tlink) {
 		tcon = cifs_sb->master_tlink->tl_tcon;
 		if (tcon) {
+			cifs_close_all_deferred_files(tcon);
 			spin_lock(&tcon->sb_list_lock);
 			list_del_init(&cifs_sb->tcon_sb_link);
 			spin_unlock(&tcon->sb_list_lock);
@@ -4163,6 +4164,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 		rb_erase(node, root);
 
 		spin_unlock(&cifs_sb->tlink_tree_lock);
+		cifs_close_all_deferred_files(tlink->tl_tcon);
 		cifs_put_tlink(tlink);
 		spin_lock(&cifs_sb->tlink_tree_lock);
 	}
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 7ff5cc9c5c5b7..0b80b11a9864d 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -712,8 +712,6 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	mutex_init(&cfile->fh_mutex);
 	spin_lock_init(&cfile->file_info_lock);
 
-	cifs_sb_active(inode->i_sb);
-
 	/*
 	 * If the server returned a read oplock and we have mandatory brlocks,
 	 * set oplock level to None.
@@ -768,7 +766,6 @@ static void cifsFileInfo_put_final(struct cifsFileInfo *cifs_file)
 	struct inode *inode = d_inode(cifs_file->dentry);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsLockInfo *li, *tmp;
-	struct super_block *sb = inode->i_sb;
 
 	/*
 	 * Delete any outstanding lock records. We'll lose them when the file
@@ -786,7 +783,6 @@ static void cifsFileInfo_put_final(struct cifsFileInfo *cifs_file)
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
-	cifs_sb_deactive(sb);
 	kfree(cifs_file->symlink_target);
 	kfree(cifs_file);
 }
@@ -3163,12 +3159,6 @@ void cifs_oplock_break(struct work_struct *work)
 	__u64 persistent_fid, volatile_fid;
 	__u16 net_fid;
 
-	/*
-	 * Hold a reference to the superblock to prevent it and its inodes from
-	 * being freed while we are accessing cinode. Otherwise, _cifsFileInfo_put()
-	 * may release the last reference to the sb and trigger inode eviction.
-	 */
-	cifs_sb_active(sb);
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
@@ -3241,7 +3231,6 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
-	cifs_sb_deactive(sb);
 }
 
 static int cifs_swap_activate(struct swap_info_struct *sis,
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 9529fa385938e..dfeb1faff8568 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -28,6 +28,11 @@
 #include "fs_context.h"
 #include "cached_dir.h"
 
+struct tcon_list {
+	struct list_head entry;
+	struct cifs_tcon *tcon;
+};
+
 /* The xid serves as a useful identifier for each incoming vfs request,
    in a similar way to the mid which is useful to track each sent smb,
    and CurrentXid can also provide a running counter (although it
@@ -171,6 +176,7 @@ tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 	}
 	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count, trace);
 	free_cached_dirs(tcon->cfids);
+
 	atomic_dec(&tconInfoAllocCount);
 	kfree(tcon->nativeFileSystem);
 	kfree_sensitive(tcon->password);
@@ -840,6 +846,36 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	}
 }
 
+void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb)
+{
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
+	struct tcon_list *tmp_list, *q;
+	LIST_HEAD(tcon_head);
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR(tcon))
+			continue;
+		tmp_list = kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
+		if (tmp_list == NULL)
+			break;
+		tmp_list->tcon = tcon;
+		list_add_tail(&tmp_list->entry, &tcon_head);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	list_for_each_entry_safe(tmp_list, q, &tcon_head, entry) {
+		cifs_close_all_deferred_files(tmp_list->tcon);
+		list_del(&tmp_list->entry);
+		kfree(tmp_list);
+	}
+}
+
 void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 					   struct dentry *dentry)
 {
-- 
2.43.0

