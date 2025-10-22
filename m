Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA461CD2C
	for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 00:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177667; cv=none; b=Ls+y9DBDxPrOHTNWZdD268nOlmkm2ELEycWbC4qcOtH1MIO4w6UEVbUtCXTvkqvZQrAuyp5TZXQRED8mYrUAy9dkOBWJIxc1Kli/TQ/2MGIr3xUOZkl3pNBQg3rJJUiezOSWXrXaIi1TldhYcQ3MQ5kZWNQ7U33qxKKx4GUaDrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177667; c=relaxed/simple;
	bh=viUrZiXtuCdJdjTSbRkRaTQ8uiewrNUBtXc6bTCzvwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YYwCG3yUOoWjJt/bQsR3rjuMtUPtsCTWj4+Dr7ZKbJlDZSko8/YgzhH/7+NiuDcsZFus+Od0JWutNkvJv+SPAD75HzpTOHUNhMUWP9toXrSEFJjSMhHEe1QqHRRXLbPfT8JIJCzU3q/+IpRRFHenTVL6ENJUp8gy5y06HZNZISM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=KZd4aU9C; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="KZd4aU9C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=D7qJzGAceYFItXNlelcqgE5jtHtS289KdPv+1x2XXz0=; b=KZd4aU9CuM2Cr+twuzShqxzmt3
	pxEkYqbfhKzcB37UQupyMcSM0Odw12O23x181GoZ3zJgf0uspHry3cDoiRDI3evSJmgP/l3c2Qvll
	6DsXrBFR/XfMOq5PYHNEHlmAmy6nQe1wasaw89ZWCR4JY0aYA1uEyt6I3F9vU/soNYrLCeJc4iuJb
	xafCRnwYJvSggvSioOdQ2G2jbduuf+NYPWtjwW5RUtliHKRT7WvmDKHlwY6kcb92bjvASJRcWrN6i
	UemvZzMqL0rAmjAXZgcYuFapl3F1SYEjoAAV5yy2tdLL18kiTf4C4JZfoJXNlzKDCwHmyDv9zWpXU
	hbYuk9vA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vBiUD-00000000Cm7-2zWd;
	Wed, 22 Oct 2025 20:43:21 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Anoop C S <anoopcs@samba.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Xiaoli Feng <xifeng@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix cifs_close_deferred_file_under_dentry()
Date: Wed, 22 Oct 2025 20:43:21 -0300
Message-ID: <20251022234321.279422-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dentry passed in cifs_close_deferred_file_under_dentry() could
have been unhashed from its parents hash list and then looked up
again, so matching @cfile->dentry with @dentry would no longer work.
This would then fail to close the deferred file prior to renaming or
unlinking it.

Fix this by matching filenames instead of dentry pointers.

This problem can be reproduced with LTP rename14 testcase:

  rename14 0 TINFO : Using /mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1 as
  tmpdir (unknown filesystem)
  rename14    1  TPASS  :  Test Passed
  rename14 0 TWARN : tst_tmpdir.c:347: tst_rmdir:
  rmobj(/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1) failed:
  unlink(/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1/.__smb0021) failed;
  errno=2: ENOENT
  <<<execution_status>>>
  initiation_status="ok"
  duration=5 termination_type=exited termination_id=4 corefile=no
  cutime=0 cstime=587
  <<<test_end>>>
  INFO: ltp-pan reported some tests FAIL
  LTP Version: 20250930-14-g9bb94efa3
         ###############################################################
              Done executing testcases.
              LTP Version:  20250930-14-g9bb94efa3
         ###############################################################
  -------------------------------------------
  INFO: runltp script is deprecated, try kirk
  https://github.com/linux-test-project/kirk
  -------------------------------------------
  rm: cannot remove '/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1': Directory not empty

Reported-by: Anoop C S <anoopcs@samba.org>
Fixes: 93ed9a295130 ("smb: client: fix filename matching of deferred files")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Xiaoli Feng <xifeng@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsproto.h | 2 +-
 fs/smb/client/inode.c     | 6 +++---
 fs/smb/client/misc.c      | 8 ++++++--
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index fb1813cbe0eb..65abbb5041b8 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -314,7 +314,7 @@ extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
 extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
 
 void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
-					   struct dentry *dentry);
+					   const char *full_path);
 
 extern void cifs_mark_open_handles_for_deleted_file(struct inode *inode,
 				const char *path);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 098a79b7a959..1a4369abba32 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1984,7 +1984,7 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	}
 
 	netfs_wait_for_outstanding_io(inode);
-	cifs_close_deferred_file_under_dentry(tcon, dentry);
+	cifs_close_deferred_file_under_dentry(tcon, full_path);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
@@ -2553,10 +2553,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		goto cifs_rename_exit;
 	}
 
-	cifs_close_deferred_file_under_dentry(tcon, source_dentry);
+	cifs_close_deferred_file_under_dentry(tcon, from_name);
 	if (d_inode(target_dentry) != NULL) {
 		netfs_wait_for_outstanding_io(d_inode(target_dentry));
-		cifs_close_deferred_file_under_dentry(tcon, target_dentry);
+		cifs_close_deferred_file_under_dentry(tcon, to_name);
 	}
 
 	rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 340c44dc7b5b..0b1b25c6e0cc 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -834,15 +834,18 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 }
 
 void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
-					   struct dentry *dentry)
+					   const char *full_path)
 {
 	struct file_list *tmp_list, *tmp_next_list;
+	void *page = alloc_dentry_path();
 	struct cifsFileInfo *cfile;
 	LIST_HEAD(file_head);
 
 	spin_lock(&tcon->open_file_lock);
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
-		if ((cfile->dentry == dentry) &&
+		const char *path = build_path_from_dentry(cfile->dentry, page);
+
+		if (!IS_ERR(path) && !strcmp(full_path, path) &&
 		    delayed_work_pending(&cfile->deferred) &&
 		    cancel_delayed_work(&cfile->deferred)) {
 			spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
@@ -863,6 +866,7 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
+	free_dentry_path(page);
 }
 
 /*
-- 
2.51.0

