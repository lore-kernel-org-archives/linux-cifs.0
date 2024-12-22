Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B82F18CBFB;
	Sun, 22 Dec 2024 13:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734873682; cv=none; b=hRHXWPTUtqom7ie4dEJl+8kusVkqm95A8f9YPEH2SuSq9Vhcd+vsDpGMGOoGAVcOsaF9A5wwtp+iBzA28EYi16yd9PkDb46L7Z1fF4xBIgsfX+MTGa+EQGLiBIVPjWlYiXZ3NIEIIpUPxhjU2EXi3d7k2+prk3rHW+gArvbBAtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734873682; c=relaxed/simple;
	bh=0Apiqfb+mW1FlytI+dSVCzNPl/9NWYiL87JTDyfjZao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2RuGayPiXn4FOAJwbsmT5t6qFNNhlVFEZ1Y7Yg2MfwO3wsNA2WMlFdQhuv7Gbb5nNne6QNcEwiQvCePH97PuinQCT7cf3cFPTcbesVuyMK+gyXEEJ9//pBaE3W5ZO9jRVG+1gDffeBYYI3+rDeKrtPmhXrIEiI1pmhuaRt2OLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5b3OyDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5b3OyDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A419BC4CED6;
	Sun, 22 Dec 2024 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734873682;
	bh=0Apiqfb+mW1FlytI+dSVCzNPl/9NWYiL87JTDyfjZao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5b3OyDyR75Uz1X2IBOxRwlZ2pxDyoqgATeETOdwLRy2bos8Rf4/j66PhFWwZq5Cr
	 U4FkLcspZ/h0qZ4fRHZ0ZPxtUbwm1RdSayIdfpZrmjscaQ2lJz6p6AYcwx0qyePCaW
	 qYPiv5gT1WDIpr9H8+4jTbAxwEJBlWt5+ZbgYtzw+DX2VHh1vD0SzoFh/ceHTpKz1g
	 Q+CG8z4EPfOvNy1j9GyANgOPrphMVY3ZWWAzClMBOwtzWlc2+mHtFpo8E8ONc/7hWW
	 thFnEji7foRVXlsNOqXaKNwDLk4WaBjvXWRDGVP3psvpsqBoMY6LwkinnApwidHcgY
	 QDE04lKIzIVQA==
Received: by pali.im (Postfix)
	id A6803B9A; Sun, 22 Dec 2024 14:21:11 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] cifs: Improve stat() to work also without FILE_READ_ATTRIBUTES
Date: Sun, 22 Dec 2024 14:20:29 +0100
Message-Id: <20241222132029.23431-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222132029.23431-1-pali@kernel.org>
References: <20241005160826.20825-1-pali@kernel.org>
 <20241222132029.23431-1-pali@kernel.org>
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

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifspdu.h   |  1 +
 fs/smb/client/smb2file.c  |  3 +-
 fs/smb/client/smb2glob.h  |  1 +
 fs/smb/client/smb2inode.c | 71 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index ee78bb6741d6..d0e7fbc5cacd 100644
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
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index ff255fdc4532..1476cb824ae4 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -158,7 +158,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	if (smb2_path == NULL)
 		return -ENOMEM;
 
-	if (!(oparms->desired_access & FILE_READ_ATTRIBUTES)) {
+	if (!(oparms->desired_access & FILE_READ_ATTRIBUTES) &&
+	    !(oparms->desired_access & MAXIMUM_ALLOWED)) {
 		oparms->desired_access |= FILE_READ_ATTRIBUTES;
 		retry_without_read_attributes = true;
 	}
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
index e8bb3f8b53f1..379ac3cbad1f 100644
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

