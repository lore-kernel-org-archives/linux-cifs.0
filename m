Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47C5156F3B;
	Sat,  5 Oct 2024 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728144582; cv=none; b=uhEEl24QAUUyIy/M1h0wFhJSmV3kbsz5DlmNZdRrEh4Nbse2Xf+59DdxVg1DK23Cv0QZo5KhFJQx0ifOLsHIS1yuNlA0UNBPXQVB9/dvVyJm0IknBhDG0A9BPlBaZvPhQPF3cCYyY2ZcwVYxiNmpWBX3h3h0/DxGaAdKWImSHqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728144582; c=relaxed/simple;
	bh=5IEvUoOqIMl0rwzsavXE/IiShDg86FdqlL87+zGeY+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcMawz4JdGumaLZmzdoh5quKxoL1uQqo1hTpSngmaL/3HFZH8D5td2Q7EfdnsBIot4Y+Va6tWhk4O6m239oNPSLagoOzeM3uCT3R3bY3kUWrS3mej7uziN46I4Fl/Gn9GIbLq1JKagBsn72CJPM/J1mB1PeQHvSSD5lQJ52goOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8UV5E0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8UV5E0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2310C4CEC7;
	Sat,  5 Oct 2024 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728144582;
	bh=5IEvUoOqIMl0rwzsavXE/IiShDg86FdqlL87+zGeY+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8UV5E0ShbVAyuSM3YtJVDEH7p7quruxJCt8jOs+YvvqTt9grtzrXKJte5DADJ65u
	 xsvBE+RhLDXvo9FLa0yUc7Slw3Rdkwa/Yr17PkheRs563cr2IRlZiMb6h4m2ID9Ocp
	 v0YxdGE11mp1dG0Z5fGVsg8UJwK44a6tN7logLYgL8UlrPnPZ6OQD2Sa5Q8oaIEioM
	 Pmyl/bjrkEvh2rAkB+lBHVwYE28hLCmYIzkNQG+dHwZ1rJ612ciw8XVhZzsbnKC6/Z
	 AQohF1iXDo659Rd5T52AmewpGQ6hJTuUOLEStZX+MJB3iHHyPq8MjQaJVz1ifp4/8u
	 QljPsONR2U9nQ==
Received: by pali.im (Postfix)
	id 5075C9F7; Sat,  5 Oct 2024 18:09:36 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cifs: Improve stat() to work also without FILE_READ_ATTRIBUTES
Date: Sat,  5 Oct 2024 18:08:26 +0200
Message-Id: <20241005160826.20825-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005160826.20825-1-pali@kernel.org>
References: <20241005160826.20825-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If SMB2_OP_QUERY_INFO (called when POSIX extensions are not used) failed
with STATUS_ACCESS_DENIED then it means that caller does not have
permission to open the path with FILE_READ_ATTRIBUTES access and therefore
cannot issue SMB2_OP_QUERY_INFO command.

This will result in the -EACCES error from stat() sycall.

There is an alternative way how to query limited information about path but
still suitable for stat() syscall. SMB2 OPEN/CREATE operation returns in
its successful response subset of query information.

So try to open the path without FILE_READ_ATTRIBUTES but with
MAXIMUM_ALLOWED access which will grant the maximum possible access to the
file and the response will contain required query information for stat()
syscall.

This will improve smb2_query_path_info() to query also files which do not
grant FILE_READ_ATTRIBUTES access to caller.

Note that this change depends on the previous change:
"cifs: Do not issue SMB2 CREATE always with FILE_READ_ATTRIBUTES"

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifspdu.h   |  1 +
 fs/smb/client/smb2glob.h  |  1 +
 fs/smb/client/smb2inode.c | 71 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index c3b6263060b0..451465678d01 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -217,6 +217,7 @@
 					  /* of an input/output request       */
 #define SYSTEM_SECURITY       0x01000000  /* The system access control list   */
 					  /* can be read and changed          */
+#define MAXIMUM_ALLOWED       0x02000000
 #define GENERIC_ALL           0x10000000
 #define GENERIC_EXECUTE       0x20000000
 #define GENERIC_WRITE         0x40000000
diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
index 2466e6155136..224495322a05 100644
--- a/fs/smb/client/smb2glob.h
+++ b/fs/smb/client/smb2glob.h
@@ -38,6 +38,7 @@ enum smb2_compound_ops {
 	SMB2_OP_SET_REPARSE,
 	SMB2_OP_GET_REPARSE,
 	SMB2_OP_QUERY_WSL_EA,
+	SMB2_OP_OPEN_QUERY,
 };
 
 /* Used when constructing chained read requests. */
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 06bb6f7fbf0f..a5759facf7eb 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -188,6 +188,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server;
 	int num_rqst = 0, i;
 	int resp_buftype[MAX_COMPOUND];
+	struct smb2_create_rsp *create_rsp = NULL;
 	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct cifs_open_info_data *idata;
 	struct inode *inode = NULL;
@@ -265,7 +266,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	num_rqst++;
 	rc = 0;
 
-	for (i = 0; i < num_cmds; i++) {
+	i = 0;
+
+	/* Skip the leading explicit OPEN operation */
+	if (num_cmds > 0 && cmds[0] == SMB2_OP_OPEN_QUERY)
+		i++;
+
+	for (; i < num_cmds; i++) {
 		/* Operation */
 		switch (cmds[i]) {
 		case SMB2_OP_QUERY_INFO:
@@ -637,6 +644,26 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		tcon->need_reconnect = true;
 	}
 
+	if (rc == 0 && num_cmds > 0 && cmds[0] == SMB2_OP_OPEN_QUERY) {
+		create_rsp = rsp_iov[0].iov_base;
+		idata = in_iov[0].iov_base;
+		idata->fi.CreationTime = create_rsp->CreationTime;
+		idata->fi.LastAccessTime = create_rsp->LastAccessTime;
+		idata->fi.LastWriteTime = create_rsp->LastWriteTime;
+		idata->fi.ChangeTime = create_rsp->ChangeTime;
+		idata->fi.Attributes = create_rsp->FileAttributes;
+		idata->fi.AllocationSize = create_rsp->AllocationSize;
+		idata->fi.EndOfFile = create_rsp->EndofFile;
+		if (le32_to_cpu(idata->fi.NumberOfLinks) == 0)
+			idata->fi.NumberOfLinks = cpu_to_le32(1); /* dummy value */
+		idata->fi.DeletePending = 0;
+		idata->fi.Directory = !!(le32_to_cpu(create_rsp->FileAttributes) & ATTR_DIRECTORY);
+
+		/* smb2_parse_contexts() fills idata->fi.IndexNumber */
+		rc = smb2_parse_contexts(server, &rsp_iov[0], &oparms->fid->epoch,
+					 oparms->fid->lease_key, &oplock, &idata->fi, NULL);
+	}
+
 	for (i = 0; i < num_cmds; i++) {
 		switch (cmds[i]) {
 		case SMB2_OP_QUERY_INFO:
@@ -934,6 +961,48 @@ int smb2_query_path_info(const unsigned int xid,
 	case 0:
 		rc = parse_create_response(data, cifs_sb, full_path, &out_iov[0]);
 		break;
+	case -EACCES:
+		/*
+		 * If SMB2_OP_QUERY_INFO (called when POSIX extensions are not used) failed with
+		 * STATUS_ACCESS_DENIED then it means that caller does not have permission to
+		 * open the path with FILE_READ_ATTRIBUTES access and therefore cannot issue
+		 * SMB2_OP_QUERY_INFO command.
+		 *
+		 * There is an alternative way how to query limited information about path but still
+		 * suitable for stat() syscall. SMB2 OPEN/CREATE operation returns in its successful
+		 * response subset of query information.
+		 *
+		 * So try to open the path without FILE_READ_ATTRIBUTES but with MAXIMUM_ALLOWED
+		 * access which will grant the maximum possible access to the file and the response
+		 * will contain required query information for stat() syscall.
+		 */
+
+		if (tcon->posix_extensions)
+			break;
+
+		for (i = 0; i < ARRAY_SIZE(out_buftype); i++) {
+			free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
+			out_buftype[i] = 0;
+			out_iov[i].iov_base = NULL;
+		}
+
+		num_cmds = 1;
+		cmds[0] = SMB2_OP_OPEN_QUERY;
+		in_iov[0].iov_base = data;
+		in_iov[0].iov_len = sizeof(*data);
+		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, MAXIMUM_ALLOWED,
+				     FILE_OPEN, create_options, ACL_NO_MODE);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				      &oparms, in_iov, cmds, num_cmds,
+				      cfile, out_iov, out_buftype, NULL);
+
+		hdr = out_iov[0].iov_base;
+		if (!hdr || out_buftype[0] == CIFS_NO_BUFFER)
+			goto out;
+
+		if (!rc)
+			rc = parse_create_response(data, cifs_sb, full_path, &out_iov[0]);
+		break;
 	case -EOPNOTSUPP:
 		/*
 		 * BB TODO: When support for special files added to Samba
-- 
2.20.1

