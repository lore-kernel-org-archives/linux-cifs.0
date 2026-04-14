Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E6F3D9DBC
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175174; cv=none; b=OjlwVGxAp4KgouoHj9xj5VI3XapI/J+FDuEFb1CT5eDwEhjkORYUmvuI90u62az4+Ov0AImVZ8F5qDWnBYECShx4UkBVwmUbFiKeDD0WWkI9VazrmUgtkMNbOHqJYBwvfw2g3klTVnBdpsB+vg392TxulywjFpOn64vJsXg9w9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175174; c=relaxed/simple;
	bh=wQe+RhB85yi02jo020KLvcVHTJCqLGplUXNCsaMyMYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HR511kXrAvW19SFomTpwytnim+Dfqgci3Nf+IjmHX0mo2TaLpev3ly52eV713MrwcMXWIKs7fOUGkvq2Ulzy7uToxSNzYpOnfQEbh1CUBozgNyDAwhlpC12uTKbnOGlc+6bp/H9I0smp6Y3g+0qCuHwezSRB7y+JrehEZBYrQvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pgc0cPgm; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pgc0cPgm"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so2087645a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 06:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776175172; x=1776779972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJ/ecoS+iyPaqh9vg50r98KJRrVZjWdsD/kOJ7GPw5M=;
        b=Pgc0cPgmkuu2ENf8dxRlkRrmgXNei4Gq6m55Kc/fYkyUHWezHfQNblbOHwmxEl20w7
         VpZFhIdnlEtRyNy2pUyGTiBFk7oFp3WKv4Jkm7V4oLY2OfGMcDLb2kzRJZXOEtvIqOl5
         f5qE3PNZncXSewspbCGqqtJWIVCW77nVGivnnqJKUQssCXpzkMCgGy0tr8/5twZNu46E
         +lTrZOzTSjXXQekUL9VdIY/kRo2aXHAT/uhii8UHr4sx/nbLDoOHVC3V3fOglRN7C9fS
         wR6teb259lnujgRIFlDU5yYr48KcoB9UD0CuCVytySIa1SSoEQL4PiRZPyhvF2zjBzkp
         puQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776175172; x=1776779972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vJ/ecoS+iyPaqh9vg50r98KJRrVZjWdsD/kOJ7GPw5M=;
        b=k4HkalbX61I1o0yMn9PiD05eXbWSqMskNdNPK6BPiksaRrh+k6biNXhlJtMQGcIl/t
         LL+26f44AZmONzd5KfIfa7kMqMkZCBrgM6srKdZaqELCyRrbzVGcys8Y3C9BnKlb88LR
         L3eF22Un03vFqILM6o159fmgUEPJKg2N29Iw/VE4HiYv6vVSmeVD6Ti/XqmCMS5sG2Pz
         YUCdDAnY8XUpzS4AyujVhgFoaGcK6FiemJ836kFOEpMx4g6BdfgjJNDzm3yGNNKZ9QdN
         445qTGBBO1ozAf2Sg5bQV8sQ2Q4LgOMlF3L5lSPVHOcfc11egxx6B9x2J7gyN17aUbdJ
         2pKA==
X-Gm-Message-State: AOJu0Ywh2RAZlO+MwKlXKpKeWbj5Msi43Lra4G0a8CN1D3zSWTaFcn1z
	DO4ju6ZfMOj71YSHCWqi2rP3U5HemVAM53GVPO9h1/Mh8ybRe71WuhYp+Y4NxFCmI1M=
X-Gm-Gg: AeBDievlrLNeaaAyYLKbBgxvKeqZh/bFvueU5r3Cha6ORES24D5A0FVvOG7A2Mu53uC
	aS3+5mL/kEzsTfNNlmz2qmmrq5FMIxlJ5IqD03ABQlb+0pODvtVLqbOslkDVcb7jeXqmGpZtqW7
	T5l1WVpDxIJFpXiZW4ATYO7k8/2Z77+GQXZO+fBRN4JwmOwaSI6SYEp17/J9u5J10ohlKPjy5DS
	vt12B9slAhearq1PO5Jh4vs6PeH7gPP16NACFDDMHcTv80Zi4EK2NDrXgjymPLcjfYjUfcxFlOq
	mjYh7eEfRbKu21HYaGNdBG0z2iAePhzcra+j+MNGmsKMAxcn6TH4kAYGfKtrO0OD8MEz/4/A73d
	xc/JrLfvh/AAqnoHP5a+JgxoWOB5YNi8hEkeZdN1w2LZniiXl+zIr46kI/DxzaS8tY+v2JNay6K
	EhDhRusT1au1ps53gLBOYRj96W0ZZz53MaaiVgeSq/LXuU5IXlxIKt
X-Received: by 2002:a05:6a21:3296:b0:39c:4af6:4309 with SMTP id adf61e73a8af0-39fe3c01179mr19500517637.12.1776175171649;
        Tue, 14 Apr 2026 06:59:31 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4612e60dasm59779895ad.38.2026.04.14.06.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:59:30 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/7] cifs: invalidate cfid on unlink/rename/rmdir
Date: Tue, 14 Apr 2026 19:29:14 +0530
Message-ID: <20260414135918.279802-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414135918.279802-1-sprasad@microsoft.com>
References: <20260414135918.279802-1-sprasad@microsoft.com>
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

