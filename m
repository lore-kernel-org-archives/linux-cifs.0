Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8DC18C33B;
	Thu,  8 Aug 2024 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723125957; cv=none; b=EOgD/SkgbxdPinHSpLbjcdkku3ofQ7Ui6UZPgVKdvIZfTRf9IId2yQny6pmnmh0c1pABhcFpcPS68d2TawcoSi8v34iTvMFajstu7dQ8wZ813bOSx3UQLLpkRQnmKHpxm8rtlXHPtclhI7j5amQdhFmvbMPq8bSTo3MnEzs3aJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723125957; c=relaxed/simple;
	bh=kyUHaORymwIzOHkL/9H9HnKJbgmkNYjfaKkvTaTc0VE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UvEFr1Yw01/c6FOc/yVjJ3AuKV9tN/yjrYdz2TsqY3qKrLsKXsGqBLliO8VtgTlz8TFzKcnaPGYur6cm3Inu/IypzBK1GpKfGqzdvZCRJdQYoLQHuloSV5PB890s0QTwn6XWHOmDFUJqOlt7RfT2FW5gTern6myqLVBKPJHa3Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WfpgQ10MDz1xty8;
	Thu,  8 Aug 2024 22:04:02 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id E801E1400D4;
	Thu,  8 Aug 2024 22:05:50 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 8 Aug
 2024 22:05:50 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <sfrench@samba.org>, <pc@manguebit.com>, <ronniesahlberg@gmail.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <bharathsm@microsoft.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <yuehaibing@huawei.com>
Subject: [PATCH -next] smb: client: Remove unused extern declarations
Date: Thu, 8 Aug 2024 22:03:32 +0800
Message-ID: <20240808140332.2429467-1-yuehaibing@huawei.com>
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
 dggpemf500002.china.huawei.com (7.185.36.57)

There is no caller and implementations in tree.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 fs/smb/client/cifsfs.h    | 1 -
 fs/smb/client/cifsproto.h | 6 ------
 fs/smb/client/smb2proto.h | 4 ----
 3 files changed, 11 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index ca2bd204bcc5..61ded59b858f 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -106,7 +106,6 @@ extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file *file, struct vm_area_struct *vma);
 extern int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma);
 extern const struct file_operations cifs_dir_ops;
-extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, struct dir_context *ctx);
 
 /* Functions related to dir entries */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 497bf3c447bc..91f0584700e8 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -78,7 +78,6 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 				     struct cifs_sb_info *cifs_sb,
 				     struct cifs_tcon *tcon,
 				     int add_treename);
-extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 char *cifs_build_devname(char *nodename, const char *prepath);
 extern void delete_mid(struct mid_q_entry *mid);
 void __release_mid(struct kref *refcount);
@@ -146,8 +145,6 @@ extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 eof,
 				   bool from_readdir);
-extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
-			    unsigned int bytes_written);
 void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t result,
 				      bool was_async);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
@@ -477,9 +474,6 @@ extern int cifs_query_reparse_point(const unsigned int xid,
 				    const char *full_path,
 				    u32 *tag, struct kvec *rsp,
 				    int *rsp_buftype);
-extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
-			       __u16 fid, char **symlinkinfo,
-			       const struct nls_table *nls_codepage);
 extern int CIFSSMB_set_compression(const unsigned int xid,
 				   struct cifs_tcon *tcon, __u16 fid);
 extern int CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index b208232b12a2..95d8cf93539b 100644
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
-- 
2.34.1

