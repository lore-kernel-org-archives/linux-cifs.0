Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF951F91E3;
	Mon, 22 Sep 2025 19:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570422; cv=none; b=HwlX1oyR/RsYBP9D9YwSr6lQqL1Fh7i8hu6YtPvWO4sRBeffdqVaPw5HqvHA8qSocMULl5JQxspJ0+HBD4Pla9Hm05PxlrEIypxzm7PmWZY3etSOgK0B5IAzBSyop9PUTorUDsU9DfyYcYW+Xcpie3N0GSwxhFTqjUTPxBiuFFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570422; c=relaxed/simple;
	bh=z14lT1vGfcl3Jr0XuHi9nrYEbLukjmNTfpG8MPdE2Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmzCAGmIoaOCv+MI6NAaRwQE7/sICTUDizBOoRbv7Etr3g1lkED4ZB5LIjy18ykqe6LuoxqJRmmuqMtz3rLwcibUBwt6QUfcAxdZgxR4DYkl0T/OjsNs664C7n8NjASe6tkImrOCFGVgjyq6TjadUeRFIye6X7XxVMolCvcex5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSxthfLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSxthfLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05583C4CEF0;
	Mon, 22 Sep 2025 19:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570422;
	bh=z14lT1vGfcl3Jr0XuHi9nrYEbLukjmNTfpG8MPdE2Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSxthfLG35gORvtzFyppBvFqLFxvY1Wja88iNXJASXORqmwCAjEqHn29KqZ0cHcjr
	 gjtqG0C3gauC9ndA64fvJWOhlhdGpmFYOu9QTeXfAltlPrEZBCldqYLQbrYYgYmqIc
	 8g1vpwZhvlfs89bAVOxXIs0jbydtT0I3hgHn5mug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 131/149] smb: client: fix filename matching of deferred files
Date: Mon, 22 Sep 2025 21:30:31 +0200
Message-ID: <20250922192416.177106661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 93ed9a2951308db374cba4562533dde97bac70d3 ]

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
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  4 ++--
 fs/smb/client/inode.c     |  6 +++---
 fs/smb/client/misc.c      | 38 ++++++++++++++++----------------------
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 045227ed4efc9..0dcea9acca544 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -297,8 +297,8 @@ extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
 
 extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
 
-extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
-				const char *path);
+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
+					   struct dentry *dentry);
 
 extern void cifs_mark_open_handles_for_deleted_file(struct inode *inode,
 				const char *path);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 11d442e8b3d62..1703f1285d36d 100644
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
index da23cc12a52ca..dda6dece802ad 100644
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
-
-					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
-					if (tmp_list == NULL)
-						break;
-					tmp_list->cfile = cfile;
-					list_add_tail(&tmp_list->list, &file_head);
-				}
-			}
+		if ((cfile->dentry == dentry) &&
+		    delayed_work_pending(&cfile->deferred) &&
+		    cancel_delayed_work(&cfile->deferred)) {
+			spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+			cifs_del_deferred_close(cfile);
+			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+
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



