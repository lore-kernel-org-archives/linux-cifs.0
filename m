Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA013A450F
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894355; cv=none; b=SZsGyxGj1ebo4Pv5CBg9mcckvaRhAPAraZprGtQPjLnRKVu3CZFs2E3wGwyWcSnMmyTQMMkfVm/wRq9iimOHElm6E6woDOxYRV5AKNBRMdyVcT35c3fccvEu/Bvo5FlsVJJUB3dJrDaA3pnT0m6sd5byUR4fpFrJSkJpxuZUXeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894355; c=relaxed/simple;
	bh=gJ360rH6npbRMPBvo3Sn/usFtSq+nTwQItX08m5UZEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT2qlmPabOd4YHOAawODcs4Zub0cZ2RFahcCuJmx0zs1Ao7Ad2dxWcs6tTZquIsScPP7ni5D87R/2pMccGClsc4mtO6lw8GrfRmkUYZ/0pOMRT3Be7aXyMCT0Ez31nhQ5408lPfit0LecDeaM3oSRl5ES5DoBnZSTL6v9bXBj0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=K38vJW+R; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="K38vJW+R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DaUbHYjeQBgJ+4715MIZrw5Ph6z+7c1uGy293vBobhA=;
	b=K38vJW+RbaQN23diTyU6CFPk0XoyGt87fcYt5VvQDZSBJBlsysuHBVxbfzLD4Uvx2C+LRL
	iINAI4FeuyJBNCzYZaiuEmYtQ6iLcnCLde9JGQk87J88hLI/CRrhyw3sMDU7WyYaJRbNZe
	R/dstFmcqa2Vi2wKf4G0ots5LgWRuIhIYs44bBWoKCXBpgE2oR3l6hjxvoNBkc9qNbDye4
	blz0KO4xUyIa70LKzoeDNm6/FCBSSObiI5Wy7nzP9Hko3cpHT+mMQYmsxf82g/f9tA6vho
	HNX6LIlgfpEoysnaqfKWeBrMZIl6ayPeRUwpBKMns5PkFZXe4yL6b/juBguTGQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/9] smb/client: close cached notify handles on closedir
Date: Wed,  1 Jul 2026 08:25:00 +0000
Message-ID: <20260701082507.786487-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
References: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

This patch was split out to make it easier to review.

Add storage for a change-notify FID in cifsFileInfo and close it from
the directory release path. This gives notify users a per-open lifetime
for the extra handle without changing how smb3_notify opens it yet.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h |  4 ++++
 fs/smb/client/file.c     | 30 ++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 99f9e6dca62b..1250518997fb 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1459,6 +1459,10 @@ struct cifsFileInfo {
 	int count;
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
+	struct mutex notify_fid_mutex;
+	struct cifs_fid notify_fid;
+	struct tcon_link *notify_tlink;
+	bool has_notify_fid:1;
 	struct cifs_search_info srch_inf;
 	struct work_struct oplock_break; /* work for oplock breaks */
 	struct work_struct put; /* work for the final part of _put */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index f1e854f381d9..6cb4068fe06e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -671,6 +671,7 @@ struct cifsFileInfo *cifs_new_dir_fileinfo(struct file *file,
 
 	spin_lock_init(&cfile->file_info_lock);
 	mutex_init(&cfile->fh_mutex);
+	mutex_init(&cfile->notify_fid_mutex);
 	cfile->invalidHandle = true;
 	cfile->tlink = cifs_get_tlink(tlink);
 
@@ -733,6 +734,7 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	INIT_WORK(&cfile->serverclose, serverclose_work);
 	INIT_DELAYED_WORK(&cfile->deferred, smb2_deferred_work_close);
 	mutex_init(&cfile->fh_mutex);
+	mutex_init(&cfile->notify_fid_mutex);
 	spin_lock_init(&cfile->file_info_lock);
 
 	/*
@@ -1548,6 +1550,32 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	}
 }
 
+static void cifs_close_notify_fid(unsigned int xid, struct cifsFileInfo *cfile)
+{
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+	int rc = 0;
+
+	mutex_lock(&cfile->notify_fid_mutex);
+	if (!cfile->has_notify_fid)
+		goto unlock;
+
+	tcon = tlink_tcon(cfile->notify_tlink);
+	server = tcon->ses->server;
+	if (server->ops->close_dir)
+		rc = server->ops->close_dir(xid, tcon, &cfile->notify_fid);
+	else if (server->ops->close)
+		rc = server->ops->close(xid, tcon, &cfile->notify_fid);
+
+	cifs_dbg(FYI, "Closing cached notify handle with rc %d\n", rc);
+	cfile->has_notify_fid = false;
+	cifs_put_tlink(cfile->notify_tlink);
+	cfile->notify_tlink = NULL;
+
+unlock:
+	mutex_unlock(&cfile->notify_fid_mutex);
+}
+
 int cifs_closedir(struct inode *inode, struct file *file)
 {
 	int rc = 0;
@@ -1567,6 +1595,8 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	server = tcon->ses->server;
 
 	cifs_dbg(FYI, "Freeing private data in close dir\n");
+	cifs_close_notify_fid(xid, cfile);
+
 	spin_lock(&cfile->file_info_lock);
 	if (server->ops->dir_needs_close(cfile)) {
 		cfile->invalidHandle = true;
-- 
2.54.0

