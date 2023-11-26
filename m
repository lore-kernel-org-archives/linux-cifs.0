Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="O22dcbAg"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E5ABC
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 18:55:46 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1C5xoA5wo/q0gEaKrWEa7U+Sb37nssqsMD214plax2k=;
	b=O22dcbAgCFEewFZ4SVaMRnz9shOcMMiAUCgk0U6v7ABMlMXhGl2ZLMqWUzkbP7JGODDw7P
	4W0r/wEnDEKWltfpycUiaCunrDYxWr/Q17nQHy5eDmGpoDBKJofNULaMq6MVD/ns7D/XdZ
	4TbIHqgeVdoWdZ3oHG5kPoNBaWnW48gisIvPT1oUL97pusVGHef6lQ5YSKWKZRrwxT/9Yb
	i9JO1gZyD93HF7oW8Q1J/MAgVOLixVERa9svmJaZk303OQGaX6uqe0a8OpTtaj9hfXIQsm
	HLSre152gYPFXHufHcNJcWFnRin5y/oQMfRPdY8CHEbDpPV5d8oH8hdThmMeqA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700967345; a=rsa-sha256;
	cv=none;
	b=Z/qVHGmioFUbypmWHKmEoee1XoD09sWlFgjCm3owr5g+bkJwvvlv5rAs7k/ucJgjKlzwD9
	MRq9aA8ucc6kDbkqLXYNNIKa97bOkJbKf0/RIZiEdfzy+uhH9tIYmjv/bf8pP0AXS19R6b
	tNeqIvcudzynrGZC0Du/92yQ9zYagsn11f5BOzMWkGJlEZKmC9cvAOkpb+QqqWw5ZjrDvK
	z6ccNhWUpQsGfTGq42CnfNlwxI0IY+YYhayIpyn0LiE2N/ygVlRlJF4yQy+WHGxywtTm0v
	K3pqC7N0jud87rA/ofl5O/bpWGDLUYUaRQo8Vip/dkBKA0o6YCJ3/eflbLM4iQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967345; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1C5xoA5wo/q0gEaKrWEa7U+Sb37nssqsMD214plax2k=;
	b=ZA/Wg4r8TXM/2VBpVXHBM/hsEfcHWdxv42NpLPL0/Xyi6quYrvMNPrHIb8ZTjB1V3StLc3
	mKRlXb2DcJFk2Ou/vycUyzPL2lqW05WXApy2K55hcocCLadD/hbIBLtSd5rPzh7BnZ7K3A
	h53TIu4qTnYeiu7QL7dtTkQdUIPp+vaVXLD4AhkQuCDT01o0Sk8CPyouKZrNOM0LhqSE5O
	37eqACbGlDXbK64gGbKgsV5ubmc3gW2r/ZB9RDZVzZJwSjI8wYd3xegXTOoRVHwsTfZiQS
	pXqPCPDA6hEkE/r5DlI+hgPggfZz3ioLOiYxLo12Lp5qzTJEAJL/nvEW4WsTUg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 8/9] smb: client: optimise dentry revalidation for reparse points
Date: Sat, 25 Nov 2023 23:55:09 -0300
Message-ID: <20231126025510.28147-9-pc@manguebit.com>
In-Reply-To: <20231126025510.28147-1-pc@manguebit.com>
References: <20231126025510.28147-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the positive dentry is known to be a reparse point already, save a
roundtrip in smb2_query_path_info() and smb311_posix_query_path_info()
by sending compound request with OPEN_REPARSE_POINT.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/inode.c     | 15 +++++++++++----
 fs/smb/client/smb2inode.c | 11 ++++++++---
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 111e60e5e260..d7d19cdb3c8c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1142,6 +1142,8 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 	 */
 
 	if (!data) {
+		if (*inode && CIFS_I(*inode)->reparse)
+			tmp_data.reparse_point = true;
 		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
 						  full_path, &tmp_data);
 		data = &tmp_data;
@@ -1301,6 +1303,7 @@ int cifs_get_inode_info(struct inode **inode,
 
 static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 				  struct cifs_fattr *fattr,
+				  struct inode **inode,
 				  const char *full_path,
 				  struct super_block *sb,
 				  const unsigned int xid)
@@ -1322,6 +1325,8 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 	 * 1. Fetch file metadata if not provided (data)
 	 */
 	if (!data) {
+		if (*inode && CIFS_I(*inode)->reparse)
+			tmp_data.reparse_point = true;
 		rc = smb311_posix_query_path_info(xid, tcon, cifs_sb,
 						  full_path, &tmp_data,
 						  &owner, &group);
@@ -1390,7 +1395,7 @@ int smb311_posix_get_inode_info(struct inode **inode,
 		return 0;
 	}
 
-	rc = smb311_posix_get_fattr(data, &fattr, full_path, sb, xid);
+	rc = smb311_posix_get_fattr(data, &fattr, inode, full_path, sb, xid);
 	if (rc)
 		goto out;
 
@@ -1537,10 +1542,12 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	}
 
 	convert_delimiter(path, CIFS_DIR_SEP(cifs_sb));
-	if (tcon->posix_extensions)
-		rc = smb311_posix_get_fattr(NULL, &fattr, path, sb, xid);
-	else
+	if (tcon->posix_extensions) {
+		rc = smb311_posix_get_fattr(NULL, &fattr, &inode,
+					    path, sb, xid);
+	} else {
 		rc = cifs_get_fattr(NULL, sb, xid, NULL, &fattr, &inode, path);
+	}
 
 iget_root:
 	if (!rc) {
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 3e8ba41b790d..9d1b043b8356 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -667,7 +667,6 @@ int smb2_query_path_info(const unsigned int xid,
 	int rc, rc2;
 
 	data->adjust_tz = false;
-	data->reparse_point = false;
 
 	if (strcmp(full_path, ""))
 		rc = -ENOENT;
@@ -689,6 +688,9 @@ int smb2_query_path_info(const unsigned int xid,
 	in_iov[0].iov_len = sizeof(*data);
 	in_iov[1] = in_iov[0];
 
+	if (data->reparse_point)
+		goto open_reparse;
+
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
@@ -714,6 +716,7 @@ int smb2_query_path_info(const unsigned int xid,
 			/* symlink already parsed in create response */
 			num_cmds = 1;
 		} else {
+open_reparse:
 			cmds[1] = SMB2_OP_GET_REPARSE;
 			num_cmds = 2;
 		}
@@ -766,8 +769,6 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	int i, num_cmds;
 
 	data->adjust_tz = false;
-	data->reparse_point = false;
-
 	/*
 	 * BB TODO: Add support for using the cached root handle.
 	 * Create SMB2_query_posix_info worker function to do non-compounded query
@@ -778,6 +779,9 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	in_iov[0].iov_len = sizeof(*data);
 	in_iov[1] = in_iov[0];
 
+	if (data->reparse_point)
+		goto open_reparse;
+
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
@@ -802,6 +806,7 @@ int smb311_posix_query_path_info(const unsigned int xid,
 			/* symlink already parsed in create response */
 			num_cmds = 1;
 		} else {
+open_reparse:
 			cmds[1] = SMB2_OP_GET_REPARSE;
 			num_cmds = 2;
 		}
-- 
2.43.0

