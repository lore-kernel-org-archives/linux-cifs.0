Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F326B4F6478;
	Mon,  7 Sep 2026 15:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794094; cv=none; b=ZfUTXvz9/c7QtcUFQO6Qa+jZOPBHahXGGGJNkj+w/eKGknoafSVwx3eurmW8nUpbghSFsR9zncAvNj3W2xRKVGTYgIEelpXwiV6uwWIcuBlHlNe6xFZ6sR1wQA61mR073QIsHIqvl9Kb5G72udNn2QRgzqaFaQBUyR3IpbMvF34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794094; c=relaxed/simple;
	bh=yAR4EiyEnlq4TjPm+At6gis4564Lc76r4UCISJGBzZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s11ecwY3BpybLpr5GIVxDwQ0OXJw+CPbijAdL+66iu4snMJ8Ja2th2DjO3VpxgV8m2QGHscLPtA+Z28VJ63ShaO4gsDcBgROFX+tltoiyutCNRL8TCHslBoqrRbYK+DkFEfvwXDs1Bvl+IX1ZTAH3aTHUrFCHgc6v/FTFFWTQXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzM4df+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzM4df+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2681A1F00A3D;
	Mon,  7 Sep 2026 15:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788794092;
	bh=LWueyqD3z82l70XP3IVFv9ghU743LBJcsfzQZI3xqII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzM4df+yaEqG1PtbRTMOCylvcmEYEKSpYowQBPdEdDp6lBJJln2QgwBqqgde0icti
	 S5kEWzIaMFWcklVCbiufsO/5nYgYooRJIpSairDJJ0ipOEmKi7I9TCa54+xuEgeZJj
	 cPFxTtttk/FObiBHjo3VSCm9X+ZlnxP6kwjkh74tI3NFwaJqwQm4JJ6J4bu3mLnDq7
	 Rd3M1Ll71PDPQvVPVyMD3BPF3wCz2/H4BHQI60etaSgpEFcO8fBKcxypPfJngCRYDZ
	 PSd1AijdnEWaSOcbK9s3AgCoLypqZJL04iOus7J+nAvBUyfJcXk5XhxRPQ1iWTCKNj
	 tYJBkEXfQQ53w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 2/4] cifs: Remove dead function prototypes
Date: Mon,  7 Sep 2026 11:14:47 -0400
Message-ID: <20260907151449.3749114-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907151449.3749114-1-sashal@kernel.org>
References: <2026090335-figure-bright-e488@gregkh>
 <20260907151449.3749114-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9146c7e53fa8e5024e0f61d67129afd45a179a3b ]

Remove a bunch of dead function prototypes.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  6 ------
 fs/smb/client/smb2proto.h | 12 ------------
 2 files changed, 18 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index ab4cda81dfb7a..15c6630340255 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -82,7 +82,6 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 				     struct cifs_sb_info *cifs_sb,
 				     struct cifs_tcon *tcon,
 				     int add_treename);
-extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 char *cifs_build_devname(char *nodename, const char *prepath);
 extern void delete_mid(struct mid_q_entry *mid);
 void __release_mid(struct kref *refcount);
@@ -166,8 +165,6 @@ extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 eof,
 				   bool from_readdir);
-extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
-			    unsigned int bytes_written);
 void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t result);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
 extern int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
@@ -194,8 +191,6 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
 extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				struct cifs_ses *ses,
 				void **request_buf);
-extern enum securityEnum select_sectype(struct TCP_Server_Info *server,
-				enum securityEnum requested);
 extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 			  struct TCP_Server_Info *server,
 			  const struct nls_table *nls_cp);
@@ -646,7 +641,6 @@ void cifs_free_hash(struct shash_desc **sdesc);
 
 int cifs_try_adding_channels(struct cifs_ses *ses);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
-void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
 int
 cifs_ses_get_chan_index(struct cifs_ses *ses,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 9ee80157b550b..92e6b93d72c49 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -41,15 +41,11 @@ extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
 extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 						__u64 ses_id, __u32  tid);
-extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
 extern bool smb2_is_valid_oplock_break(char *buffer,
 				       struct TCP_Server_Info *srv);
 extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 				 struct mid_q_entry *mid);
-extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
-				struct cifs_sb_info *cifs_sb, const char *path,
-				__u32 *reparse_tag);
 struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 				     struct super_block *sb,
 				     const unsigned int xid,
@@ -302,17 +298,9 @@ extern int smb2_query_info_compound(const unsigned int xid,
 				    struct kvec *rsp, int *buftype,
 				    struct cifs_sb_info *cifs_sb);
 /* query path info from the server using SMB311 POSIX extensions*/
-int smb311_posix_query_path_info(const unsigned int xid,
-				 struct cifs_tcon *tcon,
-				 struct cifs_sb_info *cifs_sb,
-				 const char *full_path,
-				 struct cifs_open_info_data *data);
 int posix_info_parse(const void *beg, const void *end,
 		     struct smb2_posix_info_parsed *out);
 int posix_info_sid_size(const void *beg, const void *end);
-int smb2_make_nfs_node(unsigned int xid, struct inode *inode,
-		       struct dentry *dentry, struct cifs_tcon *tcon,
-		       const char *full_path, umode_t mode, dev_t dev);
 int smb2_rename_pending_delete(const char *full_path,
 			       struct dentry *dentry,
 			       const unsigned int xid);
-- 
2.53.0

