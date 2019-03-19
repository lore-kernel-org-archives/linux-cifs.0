Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE1BC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 20:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A19082075C
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 20:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paulo.ac header.i=@paulo.ac header.b="lz/1pGnR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfCSUCO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 16:02:14 -0400
Received: from mail.paulo.ac ([51.15.136.203]:34644 "EHLO mail.paulo.ac"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbfCSUCO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 Mar 2019 16:02:14 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2019 16:02:11 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.paulo.ac (Postfix) with ESMTP id 47AA01C0492;
        Tue, 19 Mar 2019 19:55:03 +0000 (UTC)
From:   "Paulo Alcantara (SUSE)" <paulo@paulo.ac>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=paulo.ac; s=201902;
        t=1553025302; bh=JJjIZgmDB6MdFRdp25bonW49dKTXjCpdJOzaZk2Z2cE=;
        h=From:To:Cc:Subject:Date:From;
        b=lz/1pGnROzFOhHIaNPxjz8lUdHjgjNOg1Lqxjwhk3F+pz0WRtjV7QfOA1avET+O1k
         e5kYgZq9YfoJzAmRWiSIl73v+t5ovkx26ECDXtwiytvxESH+bsZ4wyl6LQni14I3V+
         4xsjKVvSxZv5rFSmqptqzp0QQ5/22Wjtjk97P20wtHtGX+m/j53610ffsamnLLSZWB
         SYqci/hSxMKEFhHWQ0XfA9a8lrqh4WZ7cVfTryQClM3+X5/GbyFZVIqpSYhrAtuD4Y
         eta3uvKRDCQd1SeYmJSS6xnYfHKN6NtRp08TNYb0/FOFbA4kIfUkFt+zJEkogDKrWf
         cULz/0cdVptjw==
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, "Paulo Alcantara (SUSE)" <paulo@paulo.ac>
Subject: [PATCH] cifs: Fix DFS cache refresher for DFS links
Date:   Tue, 19 Mar 2019 16:54:29 -0300
Message-Id: <20190319195429.6486-1-paulo@paulo.ac>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As per MS-DFSC, when a DFS cache entry is expired and it is a DFS
link, then a new DFS referral must be sent to root server in order to
refresh the expired entry.

This patch ensures that all new DFS referrals for refreshing the cache
are sent to DFS root.

Signed-off-by: Paulo Alcantara (SUSE) <paulo@paulo.ac>
---
 fs/cifs/cifsproto.h |   9 +++
 fs/cifs/connect.c   |  22 ++++---
 fs/cifs/dfs_cache.c | 140 +++++++++++++++++++++++++++++++++++++++-----
 fs/cifs/dfs_cache.h |   5 +-
 4 files changed, 151 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4f96b3b00a7a..e23234207fc2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -526,12 +526,21 @@ extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
 			const struct nls_table *codepage);
 extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
+
+extern int
+cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
+		       const char *devname, bool is_smb3);
 extern void
 cifs_cleanup_volume_info_contents(struct smb_vol *volume_info);
 
 extern struct TCP_Server_Info *
 cifs_find_tcp_session(struct smb_vol *vol);
 
+extern void cifs_put_smb_ses(struct cifs_ses *ses);
+
+extern struct cifs_ses *
+cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info);
+
 void cifs_readdata_release(struct kref *refcount);
 int cifs_async_readv(struct cifs_readdata *rdata);
 int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a8e9738db691..a23b24bc61a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -322,8 +322,6 @@ static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
-static int cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
-					const char *devname, bool is_smb3);
 static char *extract_hostname(const char *unc);
 
 /*
@@ -2888,8 +2886,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 	return NULL;
 }
 
-static void
-cifs_put_smb_ses(struct cifs_ses *ses)
+void cifs_put_smb_ses(struct cifs_ses *ses)
 {
 	unsigned int rc, xid;
 	struct TCP_Server_Info *server = ses->server;
@@ -3066,7 +3063,7 @@ cifs_set_cifscreds(struct smb_vol *vol __attribute__((unused)),
  * already got a server reference (server refcount +1). See
  * cifs_get_tcon() for refcount explanations.
  */
-static struct cifs_ses *
+struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
 	int rc = -ENOMEM;
@@ -4361,7 +4358,7 @@ static int mount_do_dfs_failover(const char *path,
 }
 #endif
 
-static int
+int
 cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 			const char *devname, bool is_smb3)
 {
@@ -4515,7 +4512,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
 	char *root_path = NULL, *full_path = NULL;
-	char *old_mountdata;
+	char *old_mountdata, *origin_mountdata = NULL;
 	int count;
 
 	rc = mount_get_conns(vol, cifs_sb, &xid, &server, &ses, &tcon);
@@ -4574,6 +4571,14 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 		goto error;
 	}
 
+	/* Save DFS root volume information for DFS refresh worker */
+	origin_mountdata = kstrndup(cifs_sb->mountdata,
+				    strlen(cifs_sb->mountdata), GFP_KERNEL);
+	if (!origin_mountdata) {
+		rc = -ENOMEM;
+		goto error;
+	}
+
 	if (cifs_sb->mountdata != old_mountdata) {
 		/* If we were redirected, reconnect to new target server */
 		mount_put_conns(cifs_sb, xid, server, ses, tcon);
@@ -4682,7 +4687,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	rc = dfs_cache_add_vol(vol, cifs_sb->origin_fullpath);
+	rc = dfs_cache_add_vol(origin_mountdata, vol, cifs_sb->origin_fullpath);
 	if (rc) {
 		kfree(cifs_sb->origin_fullpath);
 		goto error;
@@ -4700,6 +4705,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 error:
 	kfree(full_path);
 	kfree(root_path);
+	kfree(origin_mountdata);
 	mount_put_conns(cifs_sb, xid, server, ses, tcon);
 	return rc;
 }
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 09b7d0d4f6e4..85dc89d3a203 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -2,7 +2,7 @@
 /*
  * DFS referral cache routines
  *
- * Copyright (c) 2018 Paulo Alcantara <palcantara@suse.de>
+ * Copyright (c) 2018-2019 Paulo Alcantara <palcantara@suse.de>
  */
 
 #include <linux/rcupdate.h>
@@ -52,6 +52,7 @@ static struct kmem_cache *dfs_cache_slab __read_mostly;
 struct dfs_cache_vol_info {
 	char *vi_fullpath;
 	struct smb_vol vi_vol;
+	char *vi_mntdata;
 	struct list_head vi_list;
 };
 
@@ -529,6 +530,7 @@ static inline void free_vol(struct dfs_cache_vol_info *vi)
 {
 	list_del(&vi->vi_list);
 	kfree(vi->vi_fullpath);
+	kfree(vi->vi_mntdata);
 	cifs_cleanup_volume_info_contents(&vi->vi_vol);
 	kfree(vi);
 }
@@ -1139,17 +1141,18 @@ static int dup_vol(struct smb_vol *vol, struct smb_vol *new)
  * dfs_cache_add_vol - add a cifs volume during mount() that will be handled by
  * DFS cache refresh worker.
  *
+ * @mntdata: mount data.
  * @vol: cifs volume.
  * @fullpath: origin full path.
  *
  * Return zero if volume was set up correctly, otherwise non-zero.
  */
-int dfs_cache_add_vol(struct smb_vol *vol, const char *fullpath)
+int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol, const char *fullpath)
 {
 	int rc;
 	struct dfs_cache_vol_info *vi;
 
-	if (!vol || !fullpath)
+	if (!vol || !fullpath || !mntdata)
 		return -EINVAL;
 
 	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
@@ -1168,6 +1171,8 @@ int dfs_cache_add_vol(struct smb_vol *vol, const char *fullpath)
 	if (rc)
 		goto err_free_fullpath;
 
+	vi->vi_mntdata = mntdata;
+
 	mutex_lock(&dfs_cache.dc_lock);
 	list_add_tail(&vi->vi_list, &dfs_cache.dc_vol_list);
 	mutex_unlock(&dfs_cache.dc_lock);
@@ -1275,8 +1280,102 @@ static void get_tcons(struct TCP_Server_Info *server, struct list_head *head)
 	spin_unlock(&cifs_tcp_ses_lock);
 }
 
+static inline bool is_dfs_link(const char *path)
+{
+	char *s;
+
+	s = strchr(path + 1, '\\');
+	if (!s)
+		return false;
+	return !!strchr(s + 1, '\\');
+}
+
+static inline char *get_dfs_root(const char *path)
+{
+	char *s, *npath;
+
+	s = strchr(path + 1, '\\');
+	if (!s)
+		return ERR_PTR(-EINVAL);
+
+	s = strchr(s + 1, '\\');
+	if (!s)
+		return ERR_PTR(-EINVAL);
+
+	npath = kstrndup(path, s - path, GFP_KERNEL);
+	if (!npath)
+		return ERR_PTR(-ENOMEM);
+
+	return npath;
+}
+
+/* Find root SMB session out of a DFS link path */
+static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
+				      struct cifs_tcon *tcon, const char *path)
+{
+	char *rpath;
+	int rc;
+	struct dfs_info3_param ref = {0};
+	char *mdata = NULL, *devname = NULL;
+	bool is_smb3 = tcon->ses->server->vals->header_preamble_size == 0;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct smb_vol vol;
+
+	rpath = get_dfs_root(path);
+	if (IS_ERR(rpath))
+		return ERR_CAST(rpath);
+
+	memset(&vol, 0, sizeof(vol));
+
+	rc = dfs_cache_noreq_find(rpath, &ref, NULL);
+	if (rc) {
+		ses = ERR_PTR(rc);
+		goto out;
+	}
+
+	mdata = cifs_compose_mount_options(vi->vi_mntdata, rpath, &ref,
+					   &devname);
+	free_dfs_info_param(&ref);
+
+	if (IS_ERR(mdata)) {
+		ses = ERR_CAST(mdata);
+		mdata = NULL;
+		goto out;
+	}
+
+	rc = cifs_setup_volume_info(&vol, mdata, devname, is_smb3);
+	kfree(devname);
+
+	if (rc) {
+		ses = ERR_PTR(rc);
+		goto out;
+	}
+
+	server = cifs_find_tcp_session(&vol);
+	if (IS_ERR_OR_NULL(server)) {
+		ses = ERR_PTR(-EHOSTDOWN);
+		goto out;
+	}
+	if (server->tcpStatus != CifsGood) {
+		cifs_put_tcp_session(server, 0);
+		ses = ERR_PTR(-EHOSTDOWN);
+		goto out;
+	}
+
+	ses = cifs_get_smb_ses(server, &vol);
+
+out:
+	cifs_cleanup_volume_info_contents(&vol);
+	kfree(mdata);
+	kfree(rpath);
+
+	return ses;
+}
+
 /* Refresh DFS cache entry from a given tcon */
-static void do_refresh_tcon(struct dfs_cache *dc, struct cifs_tcon *tcon)
+static void do_refresh_tcon(struct dfs_cache *dc, struct dfs_cache_vol_info *vi,
+			    struct cifs_tcon *tcon)
 {
 	int rc = 0;
 	unsigned int xid;
@@ -1285,6 +1384,7 @@ static void do_refresh_tcon(struct dfs_cache *dc, struct cifs_tcon *tcon)
 	struct dfs_cache_entry *ce;
 	struct dfs_info3_param *refs = NULL;
 	int numrefs = 0;
+	struct cifs_ses *root_ses = NULL, *ses;
 
 	xid = get_xid();
 
@@ -1306,13 +1406,24 @@ static void do_refresh_tcon(struct dfs_cache *dc, struct cifs_tcon *tcon)
 	if (!cache_entry_expired(ce))
 		goto out;
 
-	if (unlikely(!tcon->ses->server->ops->get_dfs_refer)) {
+	/* If it's a DFS Link, then use root SMB session for refreshing it */
+	if (is_dfs_link(npath)) {
+		ses = root_ses = find_root_ses(vi, tcon, npath);
+		if (IS_ERR(ses)) {
+			rc = PTR_ERR(ses);
+			root_ses = NULL;
+			goto out;
+		}
+	} else {
+		ses = tcon->ses;
+	}
+
+	if (unlikely(!ses->server->ops->get_dfs_refer)) {
 		rc = -EOPNOTSUPP;
 	} else {
-		rc = tcon->ses->server->ops->get_dfs_refer(xid, tcon->ses, path,
-							   &refs, &numrefs,
-							   dc->dc_nlsc,
-							   tcon->remap);
+		rc = ses->server->ops->get_dfs_refer(xid, ses, path, &refs,
+						     &numrefs, dc->dc_nlsc,
+						     tcon->remap);
 		if (!rc) {
 			mutex_lock(&dfs_cache_list_lock);
 			ce = __update_cache_entry(npath, refs, numrefs);
@@ -1323,9 +1434,11 @@ static void do_refresh_tcon(struct dfs_cache *dc, struct cifs_tcon *tcon)
 				rc = PTR_ERR(ce);
 		}
 	}
-	if (rc)
-		cifs_dbg(FYI, "%s: failed to update expired entry\n", __func__);
+
 out:
+	if (root_ses)
+		cifs_put_smb_ses(root_ses);
+
 	free_xid(xid);
 	free_normalized_path(path, npath);
 }
@@ -1333,9 +1446,6 @@ static void do_refresh_tcon(struct dfs_cache *dc, struct cifs_tcon *tcon)
 /*
  * Worker that will refresh DFS cache based on lowest TTL value from a DFS
  * referral.
- *
- * FIXME: ensure that all requests are sent to DFS root for refreshing the
- * cache.
  */
 static void refresh_cache_worker(struct work_struct *work)
 {
@@ -1356,7 +1466,7 @@ static void refresh_cache_worker(struct work_struct *work)
 			goto next;
 		get_tcons(server, &list);
 		list_for_each_entry_safe(tcon, ntcon, &list, ulist) {
-			do_refresh_tcon(dc, tcon);
+			do_refresh_tcon(dc, vi, tcon);
 			list_del_init(&tcon->ulist);
 			cifs_put_tcon(tcon);
 		}
diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
index 22f366514f3a..76c732943f5f 100644
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -2,7 +2,7 @@
 /*
  * DFS referral cache routines
  *
- * Copyright (c) 2018 Paulo Alcantara <palcantara@suse.de>
+ * Copyright (c) 2018-2019 Paulo Alcantara <palcantara@suse.de>
  */
 
 #ifndef _CIFS_DFS_CACHE_H
@@ -43,7 +43,8 @@ dfs_cache_noreq_update_tgthint(const char *path,
 extern int dfs_cache_get_tgt_referral(const char *path,
 				      const struct dfs_cache_tgt_iterator *it,
 				      struct dfs_info3_param *ref);
-extern int dfs_cache_add_vol(struct smb_vol *vol, const char *fullpath);
+extern int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol,
+			const char *fullpath);
 extern int dfs_cache_update_vol(const char *fullpath,
 				struct TCP_Server_Info *server);
 extern void dfs_cache_del_vol(const char *fullpath);
-- 
2.21.0

