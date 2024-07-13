Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E681870;
	Sat, 13 Jul 2024 03:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720840358; cv=none; b=E97RhZaMfgDUr5hq2lXLNLA0g3EdupECsP4gTtxsy++2b99YrbX9G1xD/A4G4ZgoATcPKuc5Xlh+jgWuxelbL7iJRSW487jweKR48jiYqT1nZ/j9uNAivht0A7+0YTwmIJ0PY4my9PMbb3dakBdIY9L20ZHxl9fwoSVz+9ALV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720840358; c=relaxed/simple;
	bh=QR27xcWmStjlqSAat08CkaXmphu8Ploeo02GNfppi7E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pLMfxKznW9Krfgk4VuQ1POI1Z9XXbMkmo3rwAHU+CgVlxMLPszQWyd/GUmOsGOwA+55axO0/aCT/c2S9NjOAkf2UZN2K4XNpcgP2enXfh6UJ5/UmRRvkYYRTWcEeUPyYACWvZsk/0H5m0/47fo5WoyrtPoeT5B+DDXuKK+/IhDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=AAMItSQN; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="AAMItSQN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720840358; x=1752376358;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tgEH/Tv2YiMTlRqR/V3T8vQ21V48oFRfQ0p3PQbjNpc=;
  b=AAMItSQNlmGCQbyjuIUNhUDOaBa/0kRSnKoA/IAcnN3Zdf/c4c6wxwOI
   7LlM/nFqYwikP7gwRGu0BJcYrPZAQp9VFNVKfYc84S7GgfduYGcgcr5Lg
   Jj0eoEOwhvekcjTBH2OhfHgCBdKyueZYZRYSZW8FgpOseJlh5h2dBHlQk
   I=;
X-IronPort-AV: E=Sophos;i="6.09,204,1716249600"; 
   d="scan'208";a="645781367"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 03:12:36 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:46744]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.113:2525] with esmtp (Farcaster)
 id 7b787d18-0c15-43a1-b3c6-00967d9649a1; Sat, 13 Jul 2024 03:12:34 +0000 (UTC)
X-Farcaster-Flow-ID: 7b787d18-0c15-43a1-b3c6-00967d9649a1
Received: from EX19D021UWA001.ant.amazon.com (10.13.139.24) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sat, 13 Jul 2024 03:12:34 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D021UWA001.ant.amazon.com (10.13.139.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sat, 13 Jul 2024 03:12:33 +0000
Received: from dev-dsk-apanyaki-2b-4798319e.us-west-2.amazon.com (10.2.90.201)
 by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Sat, 13 Jul 2024 03:12:33 +0000
From: Andrew Paniakin <apanyaki@amazon.com>
To: <stable@vger.kernel.org>
CC: Benjamin Herrenschmidt <benh@amazon.com>, Hazem Mohamed Abuelfotoh
	<abuehaze@amazon.com>, Paulo Alcantara <pc@manguebit.com>, Paulo Alcantara
	<pc@cjr.nz>, Steve French <stfrench@microsoft.com>, Andrew Paniakin
	<apanyaki@amazon.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
	<lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey
	<tom@talpey.com>, "open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and
 SMB3)" <linux-cifs@vger.kernel.org>, "moderated list:COMMON INTERNET FILE
 SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 6.1] cifs: use origin fullpath for automounts
Date: Sat, 13 Jul 2024 03:11:47 +0000
Message-ID: <20240713031147.20332-1-apanyaki@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Paulo Alcantara <pc@cjr.nz>

commit 7ad54b98fc1f141cfb70cfe2a3d6def5a85169ff upstream.

Use TCP_Server_Info::origin_fullpath instead of cifs_tcon::tree_name
when building source paths for automounts as it will be useful for
domain-based DFS referrals where the connections and referrals would
get either re-used from the cache or re-created when chasing the dfs
link.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
[apanyaki: backport to v6.1-stable]
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
---
This patch fixes issue reported in
https://lore.kernel.org/regressions/ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com

1. The set_dest_addr function gets ip address differntly. In kernel 6.1
the dns_resolve_server_name_to_ip function returns string instead of
struct sockaddr, this string needs to be converted with
cifs_convert_address then.

2. There's no tmp.leaf_fullpath field in kernel 6.1, it was introduced
later in a1c0d00572fc ("cifs: share dfs connections and supers")

3. __build_path_from_dentry_optional_prefix and
dfs_get_automount_devname were added to fs/smb/client/cifsproto.h
instead of fs/cifs/dfs.h which doesn't exist in 6.1
---
 fs/smb/client/cifs_dfs_ref.c | 34 ++++++++++++++++++++++++++++++++--
 fs/smb/client/cifsproto.h    | 18 ++++++++++++++++++
 fs/smb/client/dir.c          | 21 +++++++++++++++------
 3 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifs_dfs_ref.c b/fs/smb/client/cifs_dfs_ref.c
index 020e71fe1454..876f9a43a99d 100644
--- a/fs/smb/client/cifs_dfs_ref.c
+++ b/fs/smb/client/cifs_dfs_ref.c
@@ -258,6 +258,31 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	goto compose_mount_options_out;
 }
 
+static int set_dest_addr(struct smb3_fs_context *ctx, const char *full_path)
+{
+	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
+	char *str_addr = NULL;
+	int rc;
+
+	rc = dns_resolve_server_name_to_ip(full_path, &str_addr, NULL);
+	if (rc < 0)
+		goto out;
+
+	rc = cifs_convert_address(addr, str_addr, strlen(str_addr));
+	if (!rc) {
+		cifs_dbg(FYI, "%s: failed to convert ip address\n", __func__);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	cifs_set_port(addr, ctx->port);
+	rc = 0;
+
+out:
+	kfree(str_addr);
+	return rc;
+}
+
 /*
  * Create a vfsmount that we can automount
  */
@@ -295,8 +320,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 	ctx = smb3_fc2context(fc);
 
 	page = alloc_dentry_path();
-	/* always use tree name prefix */
-	full_path = build_path_from_dentry_optional_prefix(mntpt, page, true);
+	full_path = dfs_get_automount_devname(mntpt, page);
 	if (IS_ERR(full_path)) {
 		mnt = ERR_CAST(full_path);
 		goto out;
@@ -315,6 +339,12 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 		goto out;
 	}
 
+	rc = set_dest_addr(ctx, full_path);
+	if (rc) {
+		mnt = ERR_PTR(rc);
+		goto out;
+	}
+
 	rc = smb3_parse_devname(full_path, ctx);
 	if (!rc)
 		mnt = fc_mount(fc);
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f37e4da0fe40..6dbc9afd6728 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -57,8 +57,26 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern const char *build_path_from_dentry(struct dentry *, void *);
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix);
 extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
 						    void *page, bool prefix);
+static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	if (unlikely(!server->origin_fullpath))
+		return ERR_PTR(-EREMOTE);
+
+	return __build_path_from_dentry_optional_prefix(dentry, page,
+							server->origin_fullpath,
+							strlen(server->origin_fullpath),
+							true);
+}
+
 static inline void *alloc_dentry_path(void)
 {
 	return __getname();
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 863c7bc3db86..477302157ab3 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -78,14 +78,13 @@ build_path_from_dentry(struct dentry *direntry, void *page)
 						      prefix);
 }
 
-char *
-build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
-				       bool prefix)
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix)
 {
 	int dfsplen;
 	int pplen = 0;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	char dirsep = CIFS_DIR_SEP(cifs_sb);
 	char *s;
 
@@ -93,7 +92,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 		return ERR_PTR(-ENOMEM);
 
 	if (prefix)
-		dfsplen = strnlen(tcon->tree_name, MAX_TREE_SIZE + 1);
+		dfsplen = strnlen(tree, tree_len + 1);
 	else
 		dfsplen = 0;
 
@@ -123,7 +122,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	}
 	if (dfsplen) {
 		s -= dfsplen;
-		memcpy(s, tcon->tree_name, dfsplen);
+		memcpy(s, tree, dfsplen);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
@@ -135,6 +134,16 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	return s;
 }
 
+char *build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					     bool prefix)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
+	return __build_path_from_dentry_optional_prefix(direntry, page, tcon->tree_name,
+							MAX_TREE_SIZE, prefix);
+}
+
 /*
  * Don't allow path components longer than the server max.
  * Don't allow the separator character in a path component.
-- 
2.40.1

