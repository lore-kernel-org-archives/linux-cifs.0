Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8174FC8C9;
	Mon,  7 Sep 2026 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793265; cv=none; b=o/B9dTOgpQiuAHNs+d0Sr+tLl+4bIHr7uvU/fiV+RDVVlyEsnk1SDOsbdUV8IgGZysGvPreZMPoCnY8jgELqRI3J6CVOnvgVsfxYMYNysH9QXdAONM3FPUHRWHETifBy/YAZXzWNnqo33YbD3e7gajw8K49Z1ZbPG7l5jbK/AQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793265; c=relaxed/simple;
	bh=nH4I2BbI0pO8aO31QRbedOvEApUBst+DyyU4XYBH0xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrHK8B06Alfoi3chVLLc6Kw0yhNsESnhBeWqzUFOEhSecgosKR/5dKD5nXkCBScVUpQ+nwgNZScplUZHLJ6L0GgW7kDJsjFVGEdAXZcNqlCXNxnzqiR5CI0baaoXzMNgCs5lcu0TNJLiUiHHey7FMBUG2UjDa0tVpNFCJlu5xgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmHtjdxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmHtjdxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5895E1F00A3E;
	Mon,  7 Sep 2026 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793264;
	bh=XXXsX29GUUi+P3U4m9AlUMG2qIIAga816UKUwJUnPxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmHtjdxhzzzfZXcgivuNbPqP9W0sqT+6D7M0V2gCrhSZMzRu0ABu59LWgmlcZz1qV
	 /aeiCWKZxNApuqezW25/9RNtnwRjPIpVSgwmzwKXgYMWRdaAncW2jdO1GVSv10Wp9q
	 I7Y5nI25hxZm3ZNmggcUBvFuy6LTmRfFVqstRiIhV7/SgQnZFv16wAmlq3bWLdk2ZS
	 5fJvVfDm8piBGltPQRsytTgfDPXX020tW8kXRimoLd/oL9ixAqkCagiZ9iY8m6H27i
	 FdTELkxvePIie1Ce+YYcLBVgvfEgbBuRMf/uZ7JM6p9z3uxsWMsO/PO4dlMZPvUa2o
	 gVTqb8TDNEwQA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 3/6] cifs: Remove dead function prototypes
Date: Mon,  7 Sep 2026 11:00:56 -0400
Message-ID: <20260907150059.3712249-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907150059.3712249-1-sashal@kernel.org>
References: <2026090303-ashamed-silver-ed5c@gregkh>
 <20260907150059.3712249-1-sashal@kernel.org>
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
Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  6 ------
 fs/smb/client/smb2proto.h | 12 ------------
 2 files changed, 18 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 7965a751d35c0..1f71a0977469f 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -81,7 +81,6 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 				     struct cifs_sb_info *cifs_sb,
 				     struct cifs_tcon *tcon,
 				     int add_treename);
-extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 char *cifs_build_devname(char *nodename, const char *prepath);
 extern void delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid);
@@ -151,8 +150,6 @@ extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 eof,
 				   bool from_readdir);
-extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
-			    unsigned int bytes_written);
 void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t result,
 				      bool was_async);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
@@ -181,8 +178,6 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
 extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				struct cifs_ses *ses,
 				void **request_buf);
-extern enum securityEnum select_sectype(struct TCP_Server_Info *server,
-				enum securityEnum requested);
 extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 			  struct TCP_Server_Info *server,
 			  const struct nls_table *nls_cp);
@@ -639,7 +634,6 @@ int cifs_try_adding_channels(struct cifs_ses *ses);
 bool is_server_using_iface(struct TCP_Server_Info *server,
 			   struct cifs_server_iface *iface);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
-void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
 int
 cifs_ses_get_chan_index(struct cifs_ses *ses,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index c0d9728977e80..20cf8a739559c 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -47,15 +47,11 @@ extern int smb2_calc_signature(struct smb_rqst *rqst,
 extern int smb3_calc_signature(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server,
 				bool allocate_crypto);
-extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
 extern bool smb2_is_valid_oplock_break(char *buffer,
 				       struct TCP_Server_Info *srv);
 extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 				 struct mid_q_entry *mid);
-extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
-				struct cifs_sb_info *cifs_sb, const char *path,
-				__u32 *reparse_tag);
 struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 				     struct super_block *sb,
 				     const unsigned int xid,
@@ -310,19 +306,11 @@ extern int smb2_query_info_compound(const unsigned int xid,
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
 int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname);
-int smb2_make_nfs_node(unsigned int xid, struct inode *inode,
-		       struct dentry *dentry, struct cifs_tcon *tcon,
-		       const char *full_path, umode_t mode, dev_t dev);
 
 #endif			/* _SMB2PROTO_H */
-- 
2.53.0

