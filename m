Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60257139D
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 04:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705637861; cv=pass; b=Wq7IyvqilmKM4VUXk/EGJmblr0SPMpVtElGZbIclP/zPKJ+0pVmCeE5wxdcCqlXqT/LWcvFkDiZaUXNlCP09T/EyhbuteBJXcQPOvbHEJvc+gqOA42+0sZ2PdKzJP6dF7TRKGdbVOBPy4KQtIsUOAnuoAb6iSLQKJzX20rOorKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705637861; c=relaxed/simple;
	bh=ZKvEyeegAkVjTqWwKwY5hq4xB9OKye0Bz/AhTSD2JsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM6j0TIZNxbMU+mRxk+U0fWhvpuHfXNIY+adoISJbP/+7mrLbrcha8S7nUq3VHjBFIEEI9uVl7kqJAovF7rudihUSuNiXGqJrnX1UXHAqqd4ZrELm3frA6X/ZZwLDF3jfVSQXWCaFdbeZ111JTveqHNxDdYC/kmUIRAkaVpODok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=DAXaT2H1; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DAXaT2H1"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1705637321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHy964wVJYJ8EnKxUL00MVp6Ooaa5CzzhTjV8ksQS/w=;
	b=DAXaT2H1cx9+Xoj0eNQPh2pLWspRv71dTFKHQLtmB20pJbNo/r0Q3wFny2WU3mAxAa38gm
	0ykBtKQQLMXWDtXNVPISKS+P7o3RLsMBWkfGkfk2g0KGBQnsjXp9rBCX4arvANZaFHNXGo
	Ntb0yOyzH9R6+GeBapWK9i2xpNRzKT6T1CrkROvfaWYPM+7QBlPgkzy6y9204r/7SRnfzO
	m0g9Tru23C0rQbwzd5dxemTULOqK9QJyLyNvhjhqfChIeCCakc5UCPM5gKCDRt1tEhh4Bo
	gcV/Z+5psF8zxdXYZbK8Nu+LKQh9G9LELLR1E92jckr4YlY4SckdFWpFzDDPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1705637321; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHy964wVJYJ8EnKxUL00MVp6Ooaa5CzzhTjV8ksQS/w=;
	b=LcFJrP0I7zDicRZpyhT03s1CF5YoX3C5WkGWMjY4QYydVLzWQCwFCskPNsjIrOj4O3dIur
	LQS+TnWYs/e322zyyQZbCdswY0yZ7BcIpfZSDrBdf4gXqZ3rWTsgWGfZMXXLx2yLZCqs4P
	E832Jvr8mh779XwaGZ5K8Bb6sOVwja3YOmmPXbss5aR3+SGodtcS9t4ajdDXyB3ypstMVs
	7hhxlyO6TsSMOjaNWTShybWvvwhlTFAmRo76RkPF8qGJQ5S8aQulLC/f4AhZzR2Y546PDw
	He64ycwqJknpVklKPy66PA49SSvO21y4lQx/E0gweIWyuUToGuTxf3Ew3jD1Ng==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1705637321; a=rsa-sha256;
	cv=none;
	b=PK6RhieJnlxh8CdGAcnfj7H4UbNOnIsWUTYp7nz0gYTU7rNQD1Yav6b/2NKUs2m7oSw9fl
	6GTpCDqhFia8/D5lkrWGolYlOBGlUUxWendWkzQlmot65mx2NWzNhwnK2/7ltfH76Iwttf
	IjKSOBNWAcYcjqBm/gF3AmsmJYfDUBC7Lxp2xXOaRusd7wo7SYlfH6lmpQnEM7wF/SQPFy
	fyV5Hh5XRHKKQhuaHIDmP3Yia67joDeGy3bl+oILraOdhgyj19BEHEqk/jL2VArgEY4VT7
	JOlPlkZ7BJfdvrOiIWeD+zYiXI1ljqXLQhW56/93ndr2kr7GPFhjs/n5Ast2tw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/4] smb: client: get rid of smb311_posix_query_path_info()
Date: Fri, 19 Jan 2024 01:08:28 -0300
Message-ID: <20240119040829.18428-3-pc@manguebit.com>
In-Reply-To: <20240119040829.18428-1-pc@manguebit.com>
References: <20240119040829.18428-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Merge smb311_posix_query_path_info into ->query_path_info() to get rid
of duplicate code.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
---
 fs/smb/client/inode.c     |   4 +-
 fs/smb/client/smb2inode.c | 115 +++++++++++---------------------------
 2 files changed, 36 insertions(+), 83 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cedffaad86ae..f0989484f2c6 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1312,6 +1312,7 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 				  const unsigned int xid)
 {
 	struct cifs_open_info_data tmp_data = {};
+	struct TCP_Server_Info *server;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
@@ -1322,12 +1323,13 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
 	/*
 	 * 1. Fetch file metadata if not provided (data)
 	 */
 	if (!data) {
-		rc = smb311_posix_query_path_info(xid, tcon, cifs_sb,
+		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
 						  full_path, &tmp_data);
 		data = &tmp_data;
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index f38cdc38f10c..a652200540c8 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -678,7 +678,7 @@ int smb2_query_path_info(const unsigned int xid,
 	struct smb2_hdr *hdr;
 	struct kvec in_iov[2], out_iov[3] = {};
 	int out_buftype[3] = {};
-	int cmds[2] = { SMB2_OP_QUERY_INFO,  };
+	int cmds[2];
 	bool islink;
 	int i, num_cmds;
 	int rc, rc2;
@@ -686,20 +686,36 @@ int smb2_query_path_info(const unsigned int xid,
 	data->adjust_tz = false;
 	data->reparse_point = false;
 
-	if (strcmp(full_path, ""))
-		rc = -ENOENT;
-	else
-		rc = open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
-	/* If it is a root and its handle is cached then use it */
-	if (!rc) {
-		if (cfid->file_all_info_is_valid) {
-			memcpy(&data->fi, &cfid->file_all_info, sizeof(data->fi));
+	/*
+	 * BB TODO: Add support for using cached root handle in SMB3.1.1 POSIX.
+	 * Create SMB2_query_posix_info worker function to do non-compounded
+	 * query when we already have an open file handle for this. For now this
+	 * is fast enough (always using the compounded version).
+	 */
+	if (!tcon->posix_extensions) {
+		if (*full_path) {
+			rc = -ENOENT;
 		} else {
-			rc = SMB2_query_info(xid, tcon, cfid->fid.persistent_fid,
-					     cfid->fid.volatile_fid, &data->fi);
+			rc = open_cached_dir(xid, tcon, full_path,
+					     cifs_sb, false, &cfid);
 		}
-		close_cached_dir(cfid);
-		return rc;
+		/* If it is a root and its handle is cached then use it */
+		if (!rc) {
+			if (cfid->file_all_info_is_valid) {
+				memcpy(&data->fi, &cfid->file_all_info,
+				       sizeof(data->fi));
+			} else {
+				rc = SMB2_query_info(xid, tcon,
+						     cfid->fid.persistent_fid,
+						     cfid->fid.volatile_fid,
+						     &data->fi);
+			}
+			close_cached_dir(cfid);
+			return rc;
+		}
+		cmds[0] = SMB2_OP_QUERY_INFO;
+	} else {
+		cmds[0] = SMB2_OP_POSIX_QUERY_INFO;
 	}
 
 	in_iov[0].iov_base = data;
@@ -722,6 +738,10 @@ int smb2_query_path_info(const unsigned int xid,
 	switch (rc) {
 	case 0:
 	case -EOPNOTSUPP:
+		/*
+		 * BB TODO: When support for special files added to Samba
+		 * re-verify this path.
+		 */
 		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
 		if (rc || !data->reparse_point)
 			goto out;
@@ -761,75 +781,6 @@ int smb2_query_path_info(const unsigned int xid,
 	return rc;
 }
 
-int smb311_posix_query_path_info(const unsigned int xid,
-				 struct cifs_tcon *tcon,
-				 struct cifs_sb_info *cifs_sb,
-				 const char *full_path,
-				 struct cifs_open_info_data *data)
-{
-	int rc;
-	__u32 create_options = 0;
-	struct cifsFileInfo *cfile;
-	struct kvec in_iov[2], out_iov[3] = {};
-	int out_buftype[3] = {};
-	int cmds[2] = { SMB2_OP_POSIX_QUERY_INFO,  };
-	int i, num_cmds;
-
-	data->adjust_tz = false;
-	data->reparse_point = false;
-
-	/*
-	 * BB TODO: Add support for using the cached root handle.
-	 * Create SMB2_query_posix_info worker function to do non-compounded query
-	 * when we already have an open file handle for this. For now this is fast enough
-	 * (always using the compounded version).
-	 */
-	in_iov[0].iov_base = data;
-	in_iov[0].iov_len = sizeof(*data);
-	in_iov[1] = in_iov[0];
-
-	cifs_get_readable_path(tcon, full_path, &cfile);
-	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-			      FILE_READ_ATTRIBUTES, FILE_OPEN,
-			      create_options, ACL_NO_MODE, in_iov,
-			      cmds, 1, cfile, out_iov, out_buftype);
-	/*
-	 * If first iov is unset, then SMB session was dropped or we've got a
-	 * cached open file (@cfile).
-	 */
-	if (!out_iov[0].iov_base || out_buftype[0] == CIFS_NO_BUFFER)
-		goto out;
-
-	switch (rc) {
-	case 0:
-	case -EOPNOTSUPP:
-		/* BB TODO: When support for special files added to Samba re-verify this path */
-		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
-		if (rc || !data->reparse_point)
-			goto out;
-
-		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK) {
-			/* symlink already parsed in create response */
-			num_cmds = 1;
-		} else {
-			cmds[1] = SMB2_OP_GET_REPARSE;
-			num_cmds = 2;
-		}
-		create_options |= OPEN_REPARSE_POINT;
-		cifs_get_readable_path(tcon, full_path, &cfile);
-		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				      FILE_READ_ATTRIBUTES, FILE_OPEN,
-				      create_options, ACL_NO_MODE, in_iov,
-				      cmds, num_cmds, cfile, NULL, NULL);
-		break;
-	}
-
-out:
-	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
-		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
-	return rc;
-}
-
 int
 smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
 	   struct cifs_tcon *tcon, const char *name,
-- 
2.43.0

