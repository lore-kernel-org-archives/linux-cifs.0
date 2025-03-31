Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492021D516F;
	Mon, 31 Mar 2025 23:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743465159; cv=none; b=KpvfRkQ7OY0ZdABci1tT0134JPpW60bzgTyH4aJs8zzs78ZSaSM9b8d4r0xHYT32gB+zO6klMXxkRHyBSDP46mxBfrm0bXEx+b/PhqguqP+gcEGQDgXXSRrIXgiF1pAZ3LW30R2NMf5XY7caLitQ7Rf8YmZOdMuyHegpBgY9+p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743465159; c=relaxed/simple;
	bh=Sg57offXsIHBWNK+7oN9SDLq90T+Zz2dR0KE6WYXe5Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jAPO2LWFSG1q3qA+SLlMncKVwrB2K7NO59ykuQCJdDJ0eld062deU/szz2AkWHunlv58hSnNHY/PuCa/TnbMEW64DKTOVX0C+FOTmtojey2EdIqoWQ3uanWvirxGwu7m0c/Hk21N/6oOm4uM4OJ3ilOacJrwpRoObTsijiH6vys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=kvTAqs7o; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="kvTAqs7o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743465158; x=1775001158;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L01yvsJ3ehPpvSuIebX8N6gTvSRLh5l18zHWQXoSgv0=;
  b=kvTAqs7ollS6IrBeSk0mDnAMdgABb+dEQqsYpCjb43m7SAlZ4VOqbLU9
   yLob/7suSRELPIOWW+g05N0Utdwvg7EFgwcbmXNB4ugI4unzLtxhZYVtD
   pI3nHy2gz/yWwDv5B5/QHeyUpa7B7dntZ6KhbzCahXhu9/vO98osMlT9C
   M=;
X-IronPort-AV: E=Sophos;i="6.14,291,1736812800"; 
   d="scan'208";a="731601810"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 23:52:33 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:24203]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.0.201:2525] with esmtp (Farcaster)
 id 8fa15dfc-c34c-4c11-a26d-7857e5492504; Mon, 31 Mar 2025 23:52:31 +0000 (UTC)
X-Farcaster-Flow-ID: 8fa15dfc-c34c-4c11-a26d-7857e5492504
Received: from EX19D018EUC004.ant.amazon.com (10.252.51.172) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 31 Mar 2025 23:52:31 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D018EUC004.ant.amazon.com (10.252.51.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 31 Mar 2025 23:52:30 +0000
Received: from email-imr-corp-prod-iad-all-1a-059220b4.us-east-1.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 23:52:30 +0000
Received: from dev-dsk-apanyaki-2b-4798319e.us-west-2.amazon.com (dev-dsk-apanyaki-2b-4798319e.us-west-2.amazon.com [10.2.90.201])
	by email-imr-corp-prod-iad-all-1a-059220b4.us-east-1.amazon.com (Postfix) with ESMTPS id 808E6403A7;
	Mon, 31 Mar 2025 23:52:29 +0000 (UTC)
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
Subject: [PATCH 6.1 V2] cifs: use origin fullpath for automounts
Date: Mon, 31 Mar 2025 23:50:22 +0000
Message-ID: <20250331235023.107494-1-apanyaki@amazon.com>
X-Mailer: git-send-email 2.47.1
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
Please do not include follow-up fix d5a863a153e9 ("cifs: avoid dup
prefix path in dfs_get_automount_devname()"). It works correctly only
when all patches applied in a following order:
1. 7ad54b98fc1f1 ("cifs: use origin fullpath for automounts")
2. a1c0d00572fc ("cifs: share dfs connections and supers")  (not ported to linux-6.1)
3. d5a863a153e9 ("cifs: avoid dup prefix path in dfs_get_automount_devname()")

The reason is that patch a1c0d00572fc ("cifs: share dfs connections and
supers") changes origin_fullpath contents from just a namespace root to
a full path eg. from '//corp.fsxtest.local/namespace/' to
'//corp.fsxtest.local/namespace/folderA/fs1-folder/'. But the prefix
path '/folderA/' is also stored in a cifs superblock info and it was
copied twice. With patch d5a863a153e9 ("cifs: avoid dup prefix path in
dfs_get_automount_devname()") prepath string from superblock info is not
used in path construction and result is correct.


But the patch a1c0d00572fc ("cifs: share dfs connections and supers")
was not ported to linux-6.1, probably because it's a part of huge cifs
driver update series merged in linux-6.2, not just a bug fix. So if we
apply patches in following order:
1. 7ad54b98fc1f1 ("cifs: use origin fullpath for automounts")
2. d5a863a153e9 ("cifs: avoid dup prefix path in dfs_get_automount_devname()")
then constructed fullpath will be '//corp.fsxtest.local/namespace/fs1-folder/'
instead of '//corp.fsxtest.local/namespace/folderA/fs1-folder/' because prefix
path was not copied from the superblock info.

Changelog:
v2:
- added CONFIG_CIFS_DFS_UPCALL wrapper to fix build issue [1]

v1: (updates made to upstream version of this patch)
- set_dest_addr() converts DFS address to sockaddr differently: in
  kernel 6.1 dns_resolve_server_name_to_ip() returns a string which
  needs to be converted to sockaddr with cifs_convert_address().
- removed hunk to init tmp.leaf_fullpath, it was introduced later in
  a1c0d00572fc ("cifs: share dfs connections and supers")
- __build_path_from_dentry_optional_prefix() and
  dfs_get_automount_devname() functions were added to
  fs/smb/client/cifsproto.h instead of fs/cifs/dfs.h as it doesn't exist
  in 6.1
- Link to v1: https://lore.kernel.org/all/20240713031147.20332-1-apanyaki@amazon.com/

Testing:
1. tested that these steps do not work without this backport and work
with it:
- mount DFS namespace root:
  mount -t cifs -o cred=/mnt/creds,noserverino //corp.fsxtest.local
- shutdown the namespace server that is in use
- access DFS link (triggers automount):
  ls /mnt/dfs-namespace/fs1-folder
Reported verbose logs which demonstrate backport correctness in
regression ML thread [2].

2. build kernel with debug options listed in the patch submission
checklist[3], executed cifs test suite of the xfstests [4], no errors.

3. confirmed compilation works with all y/m/n combinations for
CONFIG_CIFS and CONFIG_CIFS_DFS_UPCALL.

4. confirmed allmodconfig and allnoconfig cross-compilation works on
arm, arm64, mips, powerpc, risc.

[1] https://lore.kernel.org/all/aaccd8cc-2bfe-4b2e-b690-be50540f9965@gmail.com/
[2] https://lore.kernel.org/all/Z9cZuBxOscqybcMy@3c06303d853a.ant.amazon.com/
[3] https://www.kernel.org/doc/html/latest/process/submit-checklist.html
[4] https://web.git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

 fs/smb/client/cifs_dfs_ref.c | 34 ++++++++++++++++++++++++++++++++--
 fs/smb/client/cifsproto.h    | 21 +++++++++++++++++++++
 fs/smb/client/dir.c          | 21 +++++++++++++++------
 3 files changed, 68 insertions(+), 8 deletions(-)

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
index f37e4da0fe40..81d2761cd00a 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -57,8 +57,29 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern const char *build_path_from_dentry(struct dentry *, void *);
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix);
 extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
 						    void *page, bool prefix);
+
+#ifdef CONFIG_CIFS_DFS_UPCALL
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
+#endif
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

base-commit: 8e60a714ba3bb083b7321385054fa39ceb876914
-- 
2.43.0

