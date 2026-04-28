Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3622544A723
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392504; cv=none; b=pniLETDQ7IqqzGGBDaZPACVHpSRElS2VnJ7K6gIWy0JV7Eu0rMjv4+G3vSWDM8ePk/nwTWqYmSZEd6IuPqpOUfOrPVvUdGL15Zzezmn4UmSH5NNXC51t0H79JMuBTBK+jB/Z3YX2DZRop/1hKWbiO4je+Aa/fufbHMgZrpacOeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392504; c=relaxed/simple;
	bh=wQe+RhB85yi02jo020KLvcVHTJCqLGplUXNCsaMyMYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2RljTe2KLtjVcJQ/W3+I4pTTXY1U1lfD3LLMIjH/AFqHd73T0N5KtTuTH4PJ9VFE789FDs5JP4hHxHS9w+8bSvMxYovv/CX4ckIYngBsHlhjuKK3PJ7NVwgoKK6oX38jmfs/l0rvhi48nv/e+WLnFA4I+viyRcMjpRO36s9e9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HO+b/Yk5; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HO+b/Yk5"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2adff872068so57099475ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392502; x=1777997302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJ/ecoS+iyPaqh9vg50r98KJRrVZjWdsD/kOJ7GPw5M=;
        b=HO+b/Yk5aq44ofsL3sAvJPd+/S2jh74VxZDvh1uA+Jcf/WQA5SrEI8jkjlymSUiOAf
         6+uL2hVbSsm3g3hfWG+XyZlSkPWSjzxYkYbkyUX8l9lSQAoKz3umTucUe+M+svL3Qf4P
         eH6BUNDOHnVjFL1hT5Su0gM2FCcqkb9ZzkL8sVdkxyJBeMJ5esPnqRk17WWbVtEIRnBP
         WkRRKApVRHGr1IHGvfl/DwsBtPtMivuN3yyBdmEDrOhhxtH6k3IXr+dcvAJID+yXdVH4
         YKtdHNG9CMDdQiiLerfGDKjqAVJE6Kg/KoIgO/U3kcAxCHWOh+1eb7c2L74JGc+C9hJb
         WPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392502; x=1777997302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vJ/ecoS+iyPaqh9vg50r98KJRrVZjWdsD/kOJ7GPw5M=;
        b=JW//OIQ6fTTXJpkjPRHhvOgoFE0siBcQjTHxjFwo4hQbVyV4OWf45t/FuduAfsuAVA
         9woUwMgX3HKyEqLcYjo3lga91/n8nneRhLIZ3lTOz7qDlcJt6DPms6vFwNJ6OGZJ58a3
         Ny8PwbJsyYWL3ktzsyyPGBEA3+hYR4K8n/ep/8GQQ+mal/qnALcPYOEAXQWpN/TLeB9z
         bFfCbklMl1OL1FTSGYd6qHUGrf7IXaFGvgmYKfTI8xwAnmcq1mPOtbRgiy80+xITY7ZR
         dLAx9fDXTp7q0k+j/QB6CyGOl0q0xivzru3SXxr1tHWx8yTzM9A1up1eHFDCWsKFskAG
         dVKQ==
X-Gm-Message-State: AOJu0YzLbPcYvCvNjuQ+LP/DyBnaVdbZ3/1SzvKgyQZgPxRnN+qLpeQQ
	lcxjN970sdbnHYm8obT9VeHnY2gMZehfk7Wv1jvK66LiUAdacp1j5hlVdQhvJiAG
X-Gm-Gg: AeBDievEqveoGRUdzrsionF1FnyWr281C5jaZnNCI+KtVOArsFZU9nZJVtbzJsIKY5M
	CWWBb/N8KTNVEktD3cDQ8X1wUaEBxmhiJjEgj3WyZllP5aMr3mYmp5SNSyRxKp0lzScnzdd94kY
	/lQ5u/5lHjSyg6AzwJufmeFBkvzOF5lSVrNwgZfZcRzoKD0+5CmzP1sPtrK6e4ey5SQviqKooM8
	RPaxoEjArNpDjbVr0I3Qx06uufBYDAeS2UFfyBMDskvCYDhRz4SQKWwHY4O8fF0M3uFIhcIDist
	YozxBWUSQHkw565RF7gAQnfBn09K6eYHiImfW4uD4XoMUTksLvQbYg/S+Y2htPDoY6eq3HSvb6/
	jsGFDZ8RWHa85xgrtqU2sD0eMo1NiUBdIu0KOBvfeIoSy8NCIgRBfHX8PmfE5WJ5VvbxPPIToG3
	9OziF682j7VXDV2IB7365jw1detGv5IQdXhOJziQdDDzg7IfPNBHx80WX8saBZjDBH
X-Received: by 2002:a17:902:8f94:b0:2b0:6d33:e7c0 with SMTP id d9443c01a7336-2b97c3cbae9mr26324095ad.1.1777392502017;
        Tue, 28 Apr 2026 09:08:22 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:21 -0700 (PDT)
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
Subject: [PATCH v3 03/19] cifs: invalidate cfid on unlink/rename/rmdir
Date: Tue, 28 Apr 2026 21:37:48 +0530
Message-ID: <20260428160804.281745-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
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

