Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D0A1DE4EF
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 12:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772628403; cv=none; b=UWKawxSTGryHY/urg11B7GgaVJtCD4Vk35DLszUNVSC3xEH9rd0vJQSwP6Lmcy8OFxCaKat1ZjmL9Rq0Jg98z5vcIZXlG3Z8AFmCI4W+RUAApTlsVcLNMkyliCsFO6wgrmLMXbt3OzJiaJp4z1c9hUB3mmEIxXIo18AxZs8vGI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772628403; c=relaxed/simple;
	bh=X+cEgUYdBhzqmXNgOKBSdS0OGCTtnGXepLLe79iZaaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a6rlFohEuudZ97/tCljJjJjWxUeLh5u/O3o/hUiLeHbGcEdMLNbmhnCRLJ1cvErWiYU31VaSn86tvfYdhs3vPqxIkOHB8d6ia2tOoAyQGBvZ7Sy+1HOb+GMTHGjlH37ome8vIicAX+Ykf30DHUTRluBs+qGNY+31a2ezaH0axqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SFYDrWoQ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFYDrWoQ"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-823c56765fdso3502451b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 04:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772628401; x=1773233201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PRHZvjbEn20Mjv6PiYHb8lOHhFpRFIdSlhpdu6s0ORg=;
        b=SFYDrWoQx1xs6xU+za7BEh8unzwo9BFEWcqiUMMvX4J2mcu0h4hR2M3SLR6QPTt6Cw
         xqmXDPHLt3emOwkdhD81zTZFMuDZqOVZLYO3T6JoA6rbzSiZialtDq/jarkiJLvmC4fY
         yW03ppKeuV0QFB0CYgUWChuij7xYQ/xcdhJXkx1MejI2kaNXeF704hLJ7tKG6pk5MquB
         S4UtI90IBJ0nFKURaHCnbMWjrL9DtNChgzDcrbqKXhAzTHkYPTi41n3UvXdGzBA63st5
         4lfEVWhNsthfmzsx2BO5KRJs0hopq5RD9Q2rv0x71CjPLeno4DWNxT9L6rg9/2+FQCxj
         +ueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772628401; x=1773233201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRHZvjbEn20Mjv6PiYHb8lOHhFpRFIdSlhpdu6s0ORg=;
        b=N+Di17tUS8+fBt4rrNhz6pdGNwFxSua7oEdxOKrbwQw4/M5JcGCv6bLwRl/5dhqIJZ
         UrUYMnHaLB10OeLlJ+mUEkLDNVkcwsEsplZ1OF37eCwpGr9hXmmKUcWpGAhlQt2NSQVf
         f1dPgHyWX0DVEV8m5XORf6TcFbb1Hi5CzDsWqTgrFn+ZyhoDk545rBqnhJGZl29YrU/0
         0JWiUsA/gUAb25Si2OiN6oZPrtMQ0Qb2CqiShu92bAVHoU+sYXMXj42aHfa8x5gbFVtU
         qI22hBSySdK05bHJvmcwJGYSBNAFryRQQAifUhNMxSwXpsLZPt0DSamRXgX6WgInUibZ
         N0og==
X-Gm-Message-State: AOJu0YzfuZPYBP1t1HnUqsnoWFweOPz8R/SifC7ofgLzvcqzUWlz1G3H
	amutccVwH7wHrbApsQDEf1TWKH+uR7MNZTimJ6AW6bpDExT+YCX7AhKZzmde25EcNcU=
X-Gm-Gg: ATEYQzxKlpFenU6tCGV7lELC+Ybfd5DGC9dvjKCxP8+deNW9zyMxDJJVRTXX6FGnEUF
	ecLdbX8Loy/a25UbpXDyBWTPWEjcc7cx17P0lczUJ9/XpciUuGm7BScP9OLLbxaHkZefKzUuYcd
	OAkEQjcU/6dV3H8QvVrSwzw0TRUDzqf4+7gaMiV2UaMXctDOLrCqpJWTtkKGJ1MLiM+XsnHtYvD
	mNODFO8FlXY3zQQsd2S7RGG1/NMC8cUkhOFio8JKjW7mWNx1In0M4hMHjm8k7YmQKQShtvMAcf0
	YwG9UoOn0RwDg+m0Y8keURDjUDZMnP6MBqQQTU7OrMmELXtnus8o9H0rU7+rijALifgoZecBIcI
	6njt8EbuCNj1MfegICHC1OwSCi2RdBbYxEsRsCSbtGDssgyQ4uHui3almIOLZCD38PAVdDUUgdG
	2Df/VVGJoRRX2Fsxqf0zPxG/0FmoLxt+6MiBjOaN+yswO1ThO+kjg=
X-Received: by 2002:a05:6a20:7f96:b0:38d:ec8c:7e55 with SMTP id adf61e73a8af0-3982df0e577mr1836844637.32.1772628400796;
        Wed, 04 Mar 2026 04:46:40 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7377062904sm1836317a12.30.2026.03.04.04.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 04:46:40 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: open files should not hold ref on superblock
Date: Wed,  4 Mar 2026 18:15:53 +0530
Message-ID: <20260304124629.1616108-1-sprasad@microsoft.com>
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

The reasoning for holding the superblock ref was to make sure
that when umount happens, if there are users of inodes and
dentries, it does not try to clean them up and wait for the
last ref to superblock to be dropped by last of such users.

But the side effect of doing that is that umount silently drops
a ref on the superblock and we could have deferred closes and
lease breaks still holding these refs.

Ideally, we should ensure that all of these users of inodes and
dentries are cleaned up at the time of umount, which is what this
code is doing.

This code change allows these code paths to use a ref on the
dentry (and hence the inode). That way, umount is
ensured to clean up SMB client resources when it's the last
ref on the superblock (For ex: when same objects are shared).

The code change also moves the call to close all the files in
deferred close list to the umount code path. It also waits for
oplock_break workers to be flushed before calling
kill_anon_super (which eventually frees up those objects).

Fixes: 24261fc23db9 ("cifs: delay super block destruction until all cifsFileInfo objects are gone")
Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_oplock_break")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsfs.c    |  7 +++++--
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/file.c      | 11 ----------
 fs/smb/client/misc.c      | 42 +++++++++++++++++++++++++++++++++++++++
 fs/smb/client/trace.h     |  2 ++
 5 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 99b04234a08e6..fcc56481d6cf2 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -330,10 +330,14 @@ static void cifs_kill_sb(struct super_block *sb)
 
 	/*
 	 * We need to release all dentries for the cached directories
-	 * before we kill the sb.
+	 * and close all deferred file handles before we kill the sb.
 	 */
 	if (cifs_sb->root) {
 		close_all_cached_dirs(cifs_sb);
+		cifs_close_all_deferred_files_sb(cifs_sb);
+
+		/* Wait for all pending oplock breaks to complete */
+		flush_workqueue(cifsoplockd_wq);
 
 		/* finally release root dentry */
 		dput(cifs_sb->root);
@@ -864,7 +868,6 @@ static void cifs_umount_begin(struct super_block *sb)
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	cifs_close_all_deferred_files(tcon);
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 96d6b5325aa33..800a7e418c326 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -261,6 +261,7 @@ void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
 
 void cifs_close_all_deferred_files(struct cifs_tcon *tcon);
 
+void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb);
 void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 					   struct dentry *dentry);
 
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 18f31d4eb98de..fb4f9aafe1386 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -711,8 +711,6 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	mutex_init(&cfile->fh_mutex);
 	spin_lock_init(&cfile->file_info_lock);
 
-	cifs_sb_active(inode->i_sb);
-
 	/*
 	 * If the server returned a read oplock and we have mandatory brlocks,
 	 * set oplock level to None.
@@ -767,7 +765,6 @@ static void cifsFileInfo_put_final(struct cifsFileInfo *cifs_file)
 	struct inode *inode = d_inode(cifs_file->dentry);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsLockInfo *li, *tmp;
-	struct super_block *sb = inode->i_sb;
 
 	/*
 	 * Delete any outstanding lock records. We'll lose them when the file
@@ -785,7 +782,6 @@ static void cifsFileInfo_put_final(struct cifsFileInfo *cifs_file)
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
-	cifs_sb_deactive(sb);
 	kfree(cifs_file->symlink_target);
 	kfree(cifs_file);
 }
@@ -3165,12 +3161,6 @@ void cifs_oplock_break(struct work_struct *work)
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
 
@@ -3255,7 +3245,6 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
-	cifs_sb_deactive(sb);
 }
 
 static int cifs_swap_activate(struct swap_info_struct *sis,
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 22cde46309fe0..318533210648d 100644
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
@@ -550,6 +555,43 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
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
+		tmp_list = kmalloc_obj(struct tcon_list, GFP_ATOMIC);
+		if (tmp_list == NULL)
+			break;
+		tmp_list->tcon = tcon;
+		/* Take a reference on tcon to prevent it from being freed */
+		spin_lock(&tcon->tc_lock);
+		++tcon->tc_count;
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_get_close_defer_files);
+		spin_unlock(&tcon->tc_lock);
+		list_add_tail(&tmp_list->entry, &tcon_head);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	list_for_each_entry_safe(tmp_list, q, &tcon_head, entry) {
+		cifs_close_all_deferred_files(tmp_list->tcon);
+		list_del(&tmp_list->entry);
+		cifs_put_tcon(tmp_list->tcon, netfs_trace_tcon_ref_put_close_defer_files);
+		kfree(tmp_list);
+	}
+}
+
 void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 					   struct dentry *dentry)
 {
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 9228f95cae2bd..acfbb63086ea2 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -176,6 +176,7 @@
 	EM(netfs_trace_tcon_ref_get_cached_laundromat,	"GET Ch-Lau") \
 	EM(netfs_trace_tcon_ref_get_cached_lease_break,	"GET Ch-Lea") \
 	EM(netfs_trace_tcon_ref_get_cancelled_close,	"GET Cn-Cls") \
+	EM(netfs_trace_tcon_ref_get_close_defer_files,	"GET Cl-Def") \
 	EM(netfs_trace_tcon_ref_get_dfs_refer,		"GET DfsRef") \
 	EM(netfs_trace_tcon_ref_get_find,		"GET Find  ") \
 	EM(netfs_trace_tcon_ref_get_find_sess_tcon,	"GET FndSes") \
@@ -187,6 +188,7 @@
 	EM(netfs_trace_tcon_ref_put_cancelled_close,	"PUT Cn-Cls") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
 	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
+	EM(netfs_trace_tcon_ref_put_close_defer_files,	"PUT Cl-Def") \
 	EM(netfs_trace_tcon_ref_put_mnt_ctx,		"PUT MntCtx") \
 	EM(netfs_trace_tcon_ref_put_dfs_refer,		"PUT DfsRfr") \
 	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
-- 
2.43.0

