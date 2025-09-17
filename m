Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CED54690
	for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 19:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758135807; cv=none; b=FXB5VsiNh1KAPx0WqSRkbPZmBshniRQp1wpLBOlxmH4GIcVpH9B9GI35NN7po7V61i2OwcZizCasuwk04w4SeZo8HRIA8OO3mMerdnDC0OfzyQwLfNY3Pjn/AnuicUiNxgaQbW//1yW0XWqpaupN/IOmZCwX/2Y71Jq4wq8kALY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758135807; c=relaxed/simple;
	bh=W2R7E4p9JclOJs44AmY++Je/q1jXLIZsbhLLR9vvhf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bSsJTZIYUDwvYpG8WdjjXnjDezr6uCRc6gDRCBg9mimGPyjwkLAsZJJr03RNc2IQaE3rmc2Pgh8dqPARE5oAcpvPXZwpbgfHkeAllFrOtEfoUICe6Z3sv3MejNnLoo8w7utf3LEIk0zsgAEXuuDiwnL1wJQc+pNV1R94AUSm15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=sphCL0lp; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="sphCL0lp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=yZZxCBgUtmi4GpGVJrcIPikugrd8sTqSp+uuDCFyAiU=; b=sphCL0lpCNdC5xhclTzckMnaBF
	SUt7v0urP1BaWZSdmbh57dXz1DKt6BTBHjy6AhO5iW+bBUPxt011nA1ip4wma1AxCZAC0GG1BMSt7
	qrIUuIK0pO7xOFztYT8zxHY0G8yFEjruFad2QKRBD+0rjlDL69VJLb4aVpAWZta0YZ6ZtNC3heCJn
	HzndjY7101v7hQ1+1WzVq7SG50edbAHbg6uHS4mvKTKrhtv9xpnAKxcUqIsQrLwKrjVC/cC4Gkb7p
	Vg/F0TFfX0s83cSefK/Dd6pULR/SNbH/Jlfqy+mRuhbkW29q+3oJhSlNEAgPUvkE/N/9NsZXC3QM1
	u+slJS6Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uyxR4-00000001btn-3L9B;
	Wed, 17 Sep 2025 16:03:22 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: fix filename matching of deferred files
Date: Wed, 17 Sep 2025 16:03:22 -0300
Message-ID: <20250917190322.765293-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the following case where the client would end up closing both
deferred files (foo.tmp & foo) after unlink(foo) due to strstr() call
in cifs_close_deferred_file_under_dentry():

  fd1 = openat(AT_FDCWD, "foo", O_WRONLY|O_CREAT|O_TRUNC, 0666);
  fd2 = openat(AT_FDCWD, "foo.tmp", O_WRONLY|O_CREAT|O_TRUNC, 0666);
  close(fd1);
  close(fd2);
  unlink("foo");

Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsproto.h |  4 ++--
 fs/smb/client/inode.c     |  6 +++---
 fs/smb/client/misc.c      | 36 +++++++++++++++---------------------
 3 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c34c533b2efa..e8fba98690ce 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -312,8 +312,8 @@ extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
 
 extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
 
-extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
-				const char *path);
+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
+					   struct dentry *dentry);
 
 extern void cifs_mark_open_handles_for_deleted_file(struct inode *inode,
 				const char *path);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 11d442e8b3d6..1703f1285d36 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1984,7 +1984,7 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	}
 
 	netfs_wait_for_outstanding_io(inode);
-	cifs_close_deferred_file_under_dentry(tcon, full_path);
+	cifs_close_deferred_file_under_dentry(tcon, dentry);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
@@ -2538,10 +2538,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		goto cifs_rename_exit;
 	}
 
-	cifs_close_deferred_file_under_dentry(tcon, from_name);
+	cifs_close_deferred_file_under_dentry(tcon, source_dentry);
 	if (d_inode(target_dentry) != NULL) {
 		netfs_wait_for_outstanding_io(d_inode(target_dentry));
-		cifs_close_deferred_file_under_dentry(tcon, to_name);
+		cifs_close_deferred_file_under_dentry(tcon, target_dentry);
 	}
 
 	rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index da23cc12a52c..350542d57249 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -832,33 +832,28 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 		kfree(tmp_list);
 	}
 }
-void
-cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
+
+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
+					   struct dentry *dentry)
 {
-	struct cifsFileInfo *cfile;
 	struct file_list *tmp_list, *tmp_next_list;
-	void *page;
-	const char *full_path;
+	struct cifsFileInfo *cfile;
 	LIST_HEAD(file_head);
 
-	page = alloc_dentry_path();
 	spin_lock(&tcon->open_file_lock);
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
-		full_path = build_path_from_dentry(cfile->dentry, page);
-		if (strstr(full_path, path)) {
-			if (delayed_work_pending(&cfile->deferred)) {
-				if (cancel_delayed_work(&cfile->deferred)) {
-					spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
-					cifs_del_deferred_close(cfile);
-					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+		if (cfile->dentry == dentry &&
+		    delayed_work_pending(&cfile->deferred) &&
+		    cancel_delayed_work(&cfile->deferred)) {
+			spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+			cifs_del_deferred_close(cfile);
+			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
-					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
-					if (tmp_list == NULL)
-						break;
-					tmp_list->cfile = cfile;
-					list_add_tail(&tmp_list->list, &file_head);
-				}
-			}
+			tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
+			if (tmp_list == NULL)
+				break;
+			tmp_list->cfile = cfile;
+			list_add_tail(&tmp_list->list, &file_head);
 		}
 	}
 	spin_unlock(&tcon->open_file_lock);
@@ -868,7 +863,6 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-	free_dentry_path(page);
 }
 
 /*
-- 
2.51.0

