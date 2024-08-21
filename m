Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39718186616
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 06:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724222953; cv=none; b=J5yzx2ZjjMn0zTXSvo7vqIHHQert842Sz8WmfNG84k1dEHwCZ6qZVxbVzIRYOGKQdxv5PwqP9mq0XOyTaKSPX0Bn5iyKxujbajiIw+C75sY8KNtXU40Ef3M0Sd4GBXJckSoHHMF1RXmMcCXHH2aKDfxSIB27/oVUyx/Mt0MKKvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724222953; c=relaxed/simple;
	bh=YJWqM0aeeaueL08fZdtMD5cu938Xawz7ZIiAHG50QAg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f4Eus8Lx+PB/vSoDImv4+9sJIc366fZsTBXoZRvP+qbnloG9TGe+Mz2r/BXFTiQHv+xBdqqxHSpQkwNLDAP721VFNQHYf+XES59WLWaS1VaZh+7j5wRjbiuTeeRdsHevMIM9BDrbZYygfvstBdxjTNaIc4GSI2673y16YgmsBbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WpcPX5wxSz1S8Cl;
	Wed, 21 Aug 2024 14:49:04 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 821371A0188;
	Wed, 21 Aug 2024 14:49:07 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 21 Aug
 2024 14:49:07 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <sfrench@samba.org>, <pc@manguebit.com>, <ronniesahlberg@gmail.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <bharathsm@microsoft.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<lihongbo22@huawei.com>
Subject: [PATCH -next] smb: use LIST_HEAD() to simplify code
Date: Wed, 21 Aug 2024 14:56:37 +0800
Message-ID: <20240821065637.2294496-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

list_head can be initialized automatically with LIST_HEAD()
instead of calling INIT_LIST_HEAD(). No functional impact.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/smb/client/connect.c  | 3 +--
 fs/smb/client/file.c     | 7 ++-----
 fs/smb/client/misc.c     | 9 +++------
 fs/smb/client/smb2file.c | 4 +---
 4 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index d2307162a2de..72092b53e889 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -997,11 +997,10 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	}
 
 	if (!list_empty(&server->pending_mid_q)) {
-		struct list_head dispose_list;
 		struct mid_q_entry *mid_entry;
 		struct list_head *tmp, *tmp2;
+		LIST_HEAD(dispose_list);
 
-		INIT_LIST_HEAD(&dispose_list);
 		spin_lock(&server->mid_lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1fc66bcf49eb..a5e6c7b63230 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1406,7 +1406,7 @@ void
 cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *open_file, *tmp;
-	struct list_head tmp_list;
+	LIST_HEAD(tmp_list);
 
 	if (!tcon->use_persistent || !tcon->need_reopen_files)
 		return;
@@ -1414,7 +1414,6 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	tcon->need_reopen_files = false;
 
 	cifs_dbg(FYI, "Reopen persistent handles\n");
-	INIT_LIST_HEAD(&tmp_list);
 
 	/* list all files open on tree connection, reopen resilient handles  */
 	spin_lock(&tcon->open_file_lock);
@@ -2097,9 +2096,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
 	struct cifsLockInfo *li, *tmp;
 	__u64 length = cifs_flock_len(flock);
-	struct list_head tmp_llist;
-
-	INIT_LIST_HEAD(&tmp_llist);
+	LIST_HEAD(tmp_llist);
 
 	/*
 	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index c6f11e6f9eb9..dab526191b07 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -751,12 +751,11 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
-	struct list_head file_head;
+	LIST_HEAD(file_head);
 
 	if (cifs_inode == NULL)
 		return;
 
-	INIT_LIST_HEAD(&file_head);
 	spin_lock(&cifs_inode->open_file_lock);
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
@@ -787,9 +786,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *cfile;
 	struct file_list *tmp_list, *tmp_next_list;
-	struct list_head file_head;
+	LIST_HEAD(file_head);
 
-	INIT_LIST_HEAD(&file_head);
 	spin_lock(&tcon->open_file_lock);
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		if (delayed_work_pending(&cfile->deferred)) {
@@ -819,11 +817,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 {
 	struct cifsFileInfo *cfile;
 	struct file_list *tmp_list, *tmp_next_list;
-	struct list_head file_head;
 	void *page;
 	const char *full_path;
+	LIST_HEAD(file_head);
 
-	INIT_LIST_HEAD(&file_head);
 	page = alloc_dentry_path();
 	spin_lock(&tcon->open_file_lock);
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index c23478ab1cf8..bc2b838eab6f 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -196,9 +196,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
 	struct cifsLockInfo *li, *tmp;
 	__u64 length = 1 + flock->fl_end - flock->fl_start;
-	struct list_head tmp_llist;
-
-	INIT_LIST_HEAD(&tmp_llist);
+	LIST_HEAD(tmp_llist);
 
 	/*
 	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
-- 
2.34.1

