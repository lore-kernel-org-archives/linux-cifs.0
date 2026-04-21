Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D524386576
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 06:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776753615; cv=none; b=JKosQgcnu8n7zaXJeB4Mr9lJeWxVYOXYZNw6TEHKLGG2vDq9GXJyr5N8wS/leUxhhvbTohrE3Dp/X3pqVV4R27dHdcQQGbeIqESXlYXVDjIcrv8a8mIZWPad6NarkoxpMrD9lqcF4ikGRvAuBLm4U84n3VJM+lxgOalXhUNSNbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776753615; c=relaxed/simple;
	bh=wQe+RhB85yi02jo020KLvcVHTJCqLGplUXNCsaMyMYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gR0iy9BZfvaXCxU+MdnvNMmBIsDJ40Hp5V5JoZTwGdNTuvguNs7E2I5Rlm3yuc6QL5kT0F/q9sBETGc5GfrNt5ruudunMdX7QDSMuohnUHm7wY2Kq5HP3mt8xem+6+A6tjhdvIZ9SHt5HFVUHPpQREz86n9kp3Pf6T0d+WzkHbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P3tNBUjv; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3tNBUjv"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c795f441ff7so2736953a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 23:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776753614; x=1777358414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJ/ecoS+iyPaqh9vg50r98KJRrVZjWdsD/kOJ7GPw5M=;
        b=P3tNBUjvHk7/yyiD6NN4wksXextE7m1w5/1e4LRaS+DxsbcB0/IOyJIown9dIUrGXg
         KUnGkX+OWg71JBivNPefsDqM2kwsO/t2qr3ke5ql1HltxWXKqXv6auOtL8BXb/MFyTWo
         EXcaVCJQ93u6QXjCgclmrDMyY2O3iignPMzjaZhslz+FWa/e8tKMqa8yLJOF3Su2bF94
         rkNfQlgGrH84ctGEKaSpVmevdoBYtN6fmbDT1nrVt+24j3LtgE7W62VKyzC6MkML8pGA
         PVcIcZvjUriElTeIK75Q3JH+EnO+mEhZ4qCvShy1iEuqAX1XgY23JOg55pQN77XLbnls
         N5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776753614; x=1777358414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vJ/ecoS+iyPaqh9vg50r98KJRrVZjWdsD/kOJ7GPw5M=;
        b=QdnE8R7JcUhHpR48A8UuXZEGQTxn9vpWGvMj2ZxKm0Wyh5LPOH2F2IFb4sS6xZp2zj
         pdBbe45IaDWu+RqR4OVncOvOS1pHlTNh97Vfl8W+YBxFGAMLz0t068C6vRdrZxoh/UxK
         r3DTWNP3cV7LpFgxMSTx3aRavlDOkJR7Ih4alGAJiRbtZzmxp6LuynJY36pV8M2HrY5c
         t7+9bY5wqq+vZtACvp/RFursDhPvVkfZ5e6AbO8dKMNntPUba2elrUvS2CjCEOIWJqO3
         1F3HPWieh+b4OF/FlvZVxpn1ccuNYOfZrpHxrDKSkRW8HL4co6jDfWx9suEKYE9mS+JM
         MDIw==
X-Gm-Message-State: AOJu0YxLsFCqng47Ykagm+sPuhFfI0kKHoDkt+Kk4x5xHrINUx/J1q+e
	ZuEpI9lNmU+cKJAbcaz1VC/6A4fjB2zLR3HocpK+TbO1BwGWkkXaL6r9QNarwSkPHH0=
X-Gm-Gg: AeBDietZ9lI3xXY6Q8tYWqZ9R9aTfsR/GUByyDp+LJFA4rRZNWx3tpauhj/vwSHflG2
	paRKt5GQ33V+fBm0QvF1OcVs7EO2yWfQr8fbluCYhH5gvhX30NY/FJqsnyS00ndL0GUUyZHeMa9
	fBBZIFz8+MAZjfv59ut/ugl56ADQMGOToCtnkQDIehtNlrJqs3mZIJGPYPCFrjEeI0zHInmxW4E
	mMNuTD23NnH4dwE5JftxhqH+Po7LxWFNo0oUpXD6noDOiBTUYEpkHSuDQVQ1tjBqXCZV0qq9scg
	xZnRQ223DpI08XaJUJ/XjDsyrMj3LjhC0j5ClKU5J54dgIvMZEvBPMf/0qWXtuc4BnWlCFf5L/C
	o8dR93U5n1fmarqsbxY6U2GEmodTyIF+UBhjFRgb9UuqOkRVdvOAvu9eVm0Oy4rsuz1XEeAkDgu
	XytOue+MatVebk64fN2TezxixpD8ZisjEOlu+pQJKn1xo7pjG3MUILmWTRxhuvQ4bI
X-Received: by 2002:a05:6a20:12c7:b0:3a1:1120:7971 with SMTP id adf61e73a8af0-3a11120834amr9191071637.18.1776753613406;
        Mon, 20 Apr 2026 23:40:13 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7977031729sm10032811a12.25.2026.04.20.23.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 23:40:12 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/7] cifs: invalidate cfid on unlink/rename/rmdir
Date: Tue, 21 Apr 2026 12:09:51 +0530
Message-ID: <20260421063955.99164-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260421063955.99164-1-sprasad@microsoft.com>
References: <20260421063955.99164-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we do not invalidate the cached_dirent or the entire
parent cfid when a dentry in a dir has been removed/moved.

This change invalidates the parent cfid so that we don't serve
directory contents from the cache.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/inode.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 888f9e35f14b8..e077df844c819 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -28,6 +28,23 @@
 #include "cached_dir.h"
 #include "reparse.h"
 
+static void cifs_invalidate_cached_dir(struct cifs_tcon *tcon,
+				       struct dentry *parent)
+{
+	struct cached_fid *parent_cfid = NULL;
+
+	if (!tcon || !parent)
+		return;
+
+	if (!open_cached_dir_by_dentry(tcon, parent, &parent_cfid)) {
+		mutex_lock(&parent_cfid->dirents.de_mutex);
+		parent_cfid->dirents.is_valid = false;
+		parent_cfid->dirents.is_failed = true;
+		mutex_unlock(&parent_cfid->dirents.de_mutex);
+		close_cached_dir(parent_cfid);
+	}
+}
+
 /*
  * Set parameters for the netfs library
  */
@@ -322,7 +339,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 				fattr->cf_uid = uid;
 		}
 	}
-	
+
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 	if (!(sbflags & CIFS_MOUNT_OVERR_GID)) {
 		u64 id = le64_to_cpu(info->Gid);
@@ -2067,6 +2084,9 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 		cifs_set_file_info(inode, attrs, xid, full_path, origattr);
 
 out_reval:
+	if (!rc && dentry->d_parent)
+		cifs_invalidate_cached_dir(tcon, dentry->d_parent);
+
 	if (inode) {
 		cifs_inode = CIFS_I(inode);
 		cifs_inode->time = 0;	/* will force revalidate to get info
@@ -2378,7 +2398,6 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	}
 
 	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
-	cifs_put_tlink(tlink);
 
 	cifsInode = CIFS_I(d_inode(direntry));
 
@@ -2388,6 +2407,8 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 		i_size_write(d_inode(direntry), 0);
 		clear_nlink(d_inode(direntry));
 		spin_unlock(&d_inode(direntry)->i_lock);
+		if (direntry->d_parent)
+			cifs_invalidate_cached_dir(tcon, direntry->d_parent);
 	}
 
 	/* force revalidate to go get info when needed */
@@ -2402,6 +2423,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 
 	inode_set_ctime_current(d_inode(direntry));
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	cifs_put_tlink(tlink);
 
 rmdir_exit:
 	free_dentry_path(page);
@@ -2501,6 +2523,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	struct dentry *source_parent;
+	struct dentry *target_parent;
 	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
@@ -2532,6 +2556,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
+	source_parent = source_dentry->d_parent ? dget(source_dentry->d_parent) : NULL;
+	target_parent = target_dentry->d_parent ? dget(target_dentry->d_parent) : NULL;
 	server = tcon->ses->server;
 
 	page1 = alloc_dentry_path();
@@ -2668,11 +2694,21 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	}
 
 	/* force revalidate to go get info when needed */
+	if (!rc) {
+		cifs_invalidate_cached_dir(tcon, source_parent);
+		if (target_parent != source_parent)
+			cifs_invalidate_cached_dir(tcon, target_parent);
+	}
+
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
 	if (rehash)
 		d_rehash(target_dentry);
+	if (target_parent)
+		dput(target_parent);
+	if (source_parent)
+		dput(source_parent);
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);
-- 
2.43.0

