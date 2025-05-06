Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473E6231A32;
	Tue,  6 May 2025 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567434; cv=none; b=T9YWdIgqg1mcZ2WXoMEZ5QBcV7N5BGlkBReqR3j5GeYiNhOsHBf/l1toEgZe8HOHkUsBB05HhgIt7TH+9/huFhwLRAoFh1gFmAbNIDx/N7rfliU5PKwO3HEHxuanhxqz1sVlAAD9ky49DbJ4hUuum+VhMiPDAD9fwsvJF1H1Z6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567434; c=relaxed/simple;
	bh=lKGDZEpyMNovhqenq8sO1+7GPvJ6P5zbVZ+7Njz4rLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mnUXJtjqi7hGY6DtZ5vxWd67QnMYQM+MEU5FRh1MhBvWLn8M1gN+/4she9DFolDQsY784/PAtRIEfBDV0mPlRXNlyAHKKzl6xPdfEI3JutvZqrP+johR5ZqQXQRZrVgcs43qlsBcI+kiyZj4VIxx1Md0z68GH7c9F3LhR01UMRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeFPpnfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeFPpnfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3ED1C4CEE4;
	Tue,  6 May 2025 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567433;
	bh=lKGDZEpyMNovhqenq8sO1+7GPvJ6P5zbVZ+7Njz4rLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeFPpnfDRSZVf51bNd9+9cvDBK0QOqIrhKyb2jQgobE5iX3gl7YWRztWuajo50Vzv
	 y5U/O/+uEVY7/zNKJm/G4FD443Ai2rnp/3kOMqlYmSGg7XxdtGkDQ2JTev8cVKtcOY
	 517NzCPtYSx60+sm3ChY3KCvgkUzTOeqTiJeA71KRujr6Z66Jv/MAzapbltrVC64BC
	 BJzWdXJ8D5xcqJFT3GlAggy9lIvHFZp6MdYUjK7eaiZNEvu7Y8vWgHhxsemrgwb8RK
	 7w4dNLghq05c/7Vk0HaHMM1iCxNecfuIo6czRwBX7l0Eq4OHVlzRyJ9JQLSpLCwwe9
	 zJgK7OKqlIYsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 12/12] cifs: Fix changing times and read-only attr over SMB1 smb_set_file_info() function
Date: Tue,  6 May 2025 17:36:47 -0400
Message-Id: <20250506213647.2983356-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213647.2983356-1-sashal@kernel.org>
References: <20250506213647.2983356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit f122121796f91168d0894c2710b8dd71330a34f8 ]

Function CIFSSMBSetPathInfo() is not supported by non-NT servers and
returns error. Fallback code via open filehandle and CIFSSMBSetFileInfo()
does not work neither because CIFS_open() works also only on NT server.

Therefore currently the whole smb_set_file_info() function as a SMB1
callback for the ->set_file_info() does not work with older non-NT SMB
servers, like Win9x and others.

This change implements fallback code in smb_set_file_info() which will
works with any server and allows to change time values and also to set or
clear read-only attributes.

To make existing fallback code via CIFSSMBSetFileInfo() working with also
non-NT servers, it is needed to change open function from CIFS_open()
(which is NT specific) to cifs_open_file() which works with any server
(this is just a open wrapper function which choose the correct open
function supported by the server).

CIFSSMBSetFileInfo() is working also on non-NT servers, but zero time
values are not treated specially. So first it is needed to fill all time
values if some of them are missing, via cifs_query_path_info() call.

There is another issue, opening file in write-mode (needed for changing
attributes) is not possible when the file has read-only attribute set.
The only option how to clear read-only attribute is via SMB_COM_SETATTR
command. And opening directory is not possible neither and here the
SMB_COM_SETATTR command is the only option how to change attributes.
And CIFSSMBSetFileInfo() does not honor setting read-only attribute, so
for setting is also needed to use SMB_COM_SETATTR command.

Existing code in cifs_query_path_info() is already using SMB_COM_GETATTR as
a fallback code path (function SMBQueryInformation()), so introduce a new
function SMBSetInformation which will implement SMB_COM_SETATTR command.

My testing showed that Windows XP SMB1 client is also using SMB_COM_SETATTR
command for setting or clearing read-only attribute against non-NT server.
So this can prove that this is the correct way how to do it.

With this change it is possible set all 4 time values and all attributes,
including clearing and setting read-only bit on non-NT SMB servers.
Tested against Win98 SMB1 server.

This change fixes "touch" command which was failing when called on existing
file. And fixes also "chmod +w" and "chmod -w" commands which were also
failing (as they are changing read-only attribute).

Note that this change depends on following change
"cifs: Improve cifs_query_path_info() and cifs_query_file_info()"
as it require to query all 4 time attribute values.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifspdu.h   |   5 +-
 fs/smb/client/cifsproto.h |   4 ++
 fs/smb/client/cifssmb.c   |  57 +++++++++++++++++++
 fs/smb/client/smb1ops.c   | 112 +++++++++++++++++++++++++++++++++++---
 4 files changed, 166 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index c46d418c1c0c3..ca33f6cd6a800 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1226,10 +1226,9 @@ typedef struct smb_com_query_information_rsp {
 typedef struct smb_com_setattr_req {
 	struct smb_hdr hdr; /* wct = 8 */
 	__le16 attr;
-	__le16 time_low;
-	__le16 time_high;
+	__le32 last_write_time;
 	__le16 reserved[5]; /* must be zero */
-	__u16  ByteCount;
+	__le16 ByteCount;
 	__u8   BufferFormat; /* 4 = ASCII */
 	unsigned char fileName[];
 } __attribute__((packed)) SETATTR_REQ;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 7f97e54686524..d6686f77d4175 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -395,6 +395,10 @@ extern int CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon);
 extern int CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			struct kstatfs *FSData);
 
+extern int SMBSetInformation(const unsigned int xid, struct cifs_tcon *tcon,
+			     const char *fileName, __le32 attributes, __le64 write_time,
+			     const struct nls_table *nls_codepage,
+			     struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *fileName, const FILE_BASIC_INFO *data,
 			const struct nls_table *nls_codepage,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 769950adb7763..b91184ebce02c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5157,6 +5157,63 @@ CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+int
+SMBSetInformation(const unsigned int xid, struct cifs_tcon *tcon,
+		  const char *fileName, __le32 attributes, __le64 write_time,
+		  const struct nls_table *nls_codepage,
+		  struct cifs_sb_info *cifs_sb)
+{
+	SETATTR_REQ *pSMB;
+	SETATTR_RSP *pSMBr;
+	struct timespec64 ts;
+	int bytes_returned;
+	int name_len;
+	int rc;
+
+	cifs_dbg(FYI, "In %s path %s\n", __func__, fileName);
+
+retry:
+	rc = smb_init(SMB_COM_SETATTR, 8, tcon, (void **) &pSMB,
+		      (void **) &pSMBr);
+	if (rc)
+		return rc;
+
+	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
+		name_len =
+			cifsConvertToUTF16((__le16 *) pSMB->fileName,
+					   fileName, PATH_MAX, nls_codepage,
+					   cifs_remap(cifs_sb));
+		name_len++;     /* trailing null */
+		name_len *= 2;
+	} else {
+		name_len = copy_path_name(pSMB->fileName, fileName);
+	}
+	/* Only few attributes can be set by this command, others are not accepted by Win9x. */
+	pSMB->attr = cpu_to_le16(le32_to_cpu(attributes) &
+			(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM | ATTR_ARCHIVE));
+	/* Zero write time value (in both NT and SETATTR formats) means to not change it. */
+	if (le64_to_cpu(write_time) != 0) {
+		ts = cifs_NTtimeToUnix(write_time);
+		pSMB->last_write_time = cpu_to_le32(ts.tv_sec);
+	}
+	pSMB->BufferFormat = 0x04;
+	name_len++; /* account for buffer type byte */
+	inc_rfc1001_len(pSMB, (__u16)name_len);
+	pSMB->ByteCount = cpu_to_le16(name_len);
+
+	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
+			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
+	if (rc)
+		cifs_dbg(FYI, "Send error in %s = %d\n", __func__, rc);
+
+	cifs_buf_release(pSMB);
+
+	if (rc == -EAGAIN)
+		goto retry;
+
+	return rc;
+}
+
 /* Some legacy servers such as NT4 require that the file times be set on
    an open handle, rather than by pathname - this is awkward due to
    potential access conflicts on the open, but it is unavoidable for these
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 1ecb32186b06b..5c5cd5e238272 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -919,6 +919,9 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_fid fid;
 	struct cifs_open_parms oparms;
 	struct cifsFileInfo *open_file;
+	FILE_BASIC_INFO new_buf;
+	struct cifs_open_info_data query_data;
+	__le64 write_time = buf->LastWriteTime;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = NULL;
@@ -926,20 +929,58 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 
 	/* if the file is already open for write, just use that fileid */
 	open_file = find_writable_file(cinode, FIND_WR_FSUID_ONLY);
+
 	if (open_file) {
 		fid.netfid = open_file->fid.netfid;
 		netpid = open_file->pid;
 		tcon = tlink_tcon(open_file->tlink);
-		goto set_via_filehandle;
+	} else {
+		tlink = cifs_sb_tlink(cifs_sb);
+		if (IS_ERR(tlink)) {
+			rc = PTR_ERR(tlink);
+			tlink = NULL;
+			goto out;
+		}
+		tcon = tlink_tcon(tlink);
 	}
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
-		rc = PTR_ERR(tlink);
-		tlink = NULL;
-		goto out;
+	/*
+	 * Non-NT servers interprets zero time value in SMB_SET_FILE_BASIC_INFO
+	 * over TRANS2_SET_FILE_INFORMATION as a valid time value. NT servers
+	 * interprets zero time value as do not change existing value on server.
+	 * API of ->set_file_info() callback expects that zero time value has
+	 * the NT meaning - do not change. Therefore if server is non-NT and
+	 * some time values in "buf" are zero, then fetch missing time values.
+	 */
+	if (!(tcon->ses->capabilities & CAP_NT_SMBS) &&
+	    (!buf->CreationTime || !buf->LastAccessTime ||
+	     !buf->LastWriteTime || !buf->ChangeTime)) {
+		rc = cifs_query_path_info(xid, tcon, cifs_sb, full_path, &query_data);
+		if (rc) {
+			if (open_file) {
+				cifsFileInfo_put(open_file);
+				open_file = NULL;
+			}
+			goto out;
+		}
+		/*
+		 * Original write_time from buf->LastWriteTime is preserved
+		 * as SMBSetInformation() interprets zero as do not change.
+		 */
+		new_buf = *buf;
+		buf = &new_buf;
+		if (!buf->CreationTime)
+			buf->CreationTime = query_data.fi.CreationTime;
+		if (!buf->LastAccessTime)
+			buf->LastAccessTime = query_data.fi.LastAccessTime;
+		if (!buf->LastWriteTime)
+			buf->LastWriteTime = query_data.fi.LastWriteTime;
+		if (!buf->ChangeTime)
+			buf->ChangeTime = query_data.fi.ChangeTime;
 	}
-	tcon = tlink_tcon(tlink);
+
+	if (open_file)
+		goto set_via_filehandle;
 
 	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, buf, cifs_sb->local_nls,
 				cifs_sb);
@@ -960,8 +1001,45 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 		.fid = &fid,
 	};
 
-	cifs_dbg(FYI, "calling SetFileInfo since SetPathInfo for times not supported by this server\n");
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	if (S_ISDIR(inode->i_mode) && !(tcon->ses->capabilities & CAP_NT_SMBS)) {
+		/* Opening directory path is not possible on non-NT servers. */
+		rc = -EOPNOTSUPP;
+	} else {
+		/*
+		 * Use cifs_open_file() instead of CIFS_open() as the
+		 * cifs_open_file() selects the correct function which
+		 * works also on non-NT servers.
+		 */
+		rc = cifs_open_file(xid, &oparms, &oplock, NULL);
+		/*
+		 * Opening path for writing on non-NT servers is not
+		 * possible when the read-only attribute is already set.
+		 * Non-NT server in this case returns -EACCES. For those
+		 * servers the only possible way how to clear the read-only
+		 * bit is via SMB_COM_SETATTR command.
+		 */
+		if (rc == -EACCES &&
+		    (cinode->cifsAttrs & ATTR_READONLY) &&
+		     le32_to_cpu(buf->Attributes) != 0 && /* 0 = do not change attrs */
+		     !(le32_to_cpu(buf->Attributes) & ATTR_READONLY) &&
+		     !(tcon->ses->capabilities & CAP_NT_SMBS))
+			rc = -EOPNOTSUPP;
+	}
+
+	/* Fallback to SMB_COM_SETATTR command when absolutelty needed. */
+	if (rc == -EOPNOTSUPP) {
+		cifs_dbg(FYI, "calling SetInformation since SetPathInfo for attrs/times not supported by this server\n");
+		rc = SMBSetInformation(xid, tcon, full_path,
+				       buf->Attributes != 0 ? buf->Attributes : cpu_to_le32(cinode->cifsAttrs),
+				       write_time,
+				       cifs_sb->local_nls, cifs_sb);
+		if (rc == 0)
+			cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
+		else
+			rc = -EACCES;
+		goto out;
+	}
+
 	if (rc != 0) {
 		if (rc == -EIO)
 			rc = -EINVAL;
@@ -969,6 +1047,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	}
 
 	netpid = current->tgid;
+	cifs_dbg(FYI, "calling SetFileInfo since SetPathInfo for attrs/times not supported by this server\n");
 
 set_via_filehandle:
 	rc = CIFSSMBSetFileInfo(xid, tcon, buf, fid.netfid, netpid);
@@ -979,6 +1058,21 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 		CIFSSMBClose(xid, tcon, fid.netfid);
 	else
 		cifsFileInfo_put(open_file);
+
+	/*
+	 * Setting the read-only bit is not honered on non-NT servers when done
+	 * via open-semantics. So for setting it, use SMB_COM_SETATTR command.
+	 * This command works only after the file is closed, so use it only when
+	 * operation was called without the filehandle.
+	 */
+	if (open_file == NULL &&
+	    !(tcon->ses->capabilities & CAP_NT_SMBS) &&
+	    le32_to_cpu(buf->Attributes) & ATTR_READONLY) {
+		SMBSetInformation(xid, tcon, full_path,
+				  buf->Attributes,
+				  0 /* do not change write time */,
+				  cifs_sb->local_nls, cifs_sb);
+	}
 out:
 	if (tlink != NULL)
 		cifs_put_tlink(tlink);
-- 
2.39.5

