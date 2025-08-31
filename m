Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F72D268688;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=llH+E+Q2NXdSi9/TPYWIR3+mbpciKesDONQbpxHiGGn4ZykjT8HJnnTO9qOUeO8IRNHBQq9caDvimuxYGwScWm15tkiyZtKXWIaNlRiWId4b1kx4WxgKgID5SJiMlOuNpQgS/r4OKCSqqYf2PrZGuB5X4L0AajazwK8sigutnTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=u6ubCb8TEYt3r5vCDGsHNbkpi+oiKBa5gvpt/OaLiso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPlwP+vK5a3zV7/sfXCGXl649rx+drvWNiGjHtFf6mQXX7kiJEQ49TiYLsfSxCi6+B210YcpwJhfpbGqgcHlIYlAGdRrSVdYCbZlYnRPgysCby9egdjs3CazrUxpqcF4fSV83HIm7j4CRn94uuFiCsHQM5EyfhvxDYCCjQA3ayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbiD4uh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbiD4uh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC1C4CEF9;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=u6ubCb8TEYt3r5vCDGsHNbkpi+oiKBa5gvpt/OaLiso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbiD4uh0QubSjtDpH2opUr65y70y8EAwcNgKyaN2NIs9UXBsvb3h5dqHFjMur9+NQ
	 uJXzMWLdzRu/ho9x6UUfsUFf1e+K9HOC6pdpivIk1eTnWp2TcR0kbcZPQKg2iUb1Fd
	 F2hKpUNZeUtohBkO7m8AoZLWMkQ3Hvkv/qX1eV44NH7EUWl7Eis4dTVHPdRR19MAfC
	 uuYcNIKDcgcIEXA6TZaMevR+C6TZz7hcd/Y2r/fPi3acmu57f+b1wBOjDCspGLcBTU
	 lUunEj4E7gu2H8lGh+ZBU+cQvYi+JmC7Tc9MpnLN8QDY8zHUvKpUMLNz0Hif1ZE1ZN
	 zTIOV4Bk5POig==
Received: by pali.im (Postfix)
	id 9B37CF96; Sun, 31 Aug 2025 14:36:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 24/35] cifs: Add a new callback set_file_disp() for setting file disposition (delete pending state)
Date: Sun, 31 Aug 2025 14:35:51 +0200
Message-Id: <20250831123602.14037-25-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Implement it for all SMB dialects. It will be used by follow up changes.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |  3 +++
 fs/smb/client/smb1ops.c   |  8 ++++++++
 fs/smb/client/smb2ops.c   | 11 +++++++++++
 fs/smb/client/smb2pdu.c   | 13 +++++++++++++
 fs/smb/client/smb2proto.h |  2 ++
 5 files changed, 37 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0ecf4988664e..7162b9120198 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -426,6 +426,9 @@ struct smb_version_operations {
 	/* set attributes */
 	int (*set_file_info)(struct inode *, const char *, FILE_BASIC_INFO *,
 			     const unsigned int);
+	/* set file disposition (delete pending state) */
+	int (*set_file_disp)(const unsigned int xid, struct cifs_tcon *tcon,
+			     struct cifs_fid *fid, bool delete_pending);
 	int (*set_compression)(const unsigned int, struct cifs_tcon *,
 			       struct cifsFileInfo *);
 	/* check if we can send an echo or nor */
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 73d3dc83faa6..e37104d3c5d7 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1079,6 +1079,13 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	return rc;
 }
 
+static int
+cifs_set_file_disp(const unsigned int xid, struct cifs_tcon *tcon,
+		   struct cifs_fid *fid, bool delete_pending)
+{
+	return CIFSSMBSetFileDisposition(xid, tcon, delete_pending, fid->netfid, current->tgid);
+}
+
 static int
 cifs_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile)
@@ -1391,6 +1398,7 @@ struct smb_version_operations smb1_operations = {
 	.set_path_size = CIFSSMBSetEOF,
 	.set_file_size = CIFSSMBSetFileSize,
 	.set_file_info = smb_set_file_info,
+	.set_file_disp = cifs_set_file_disp,
 	.set_compression = cifs_set_compression,
 	.echo = CIFSSMBEcho,
 	.mkdir = CIFSSMBMkDir,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ad8947434b71..530e66fa4671 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1515,6 +1515,13 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int
+smb2_set_file_disp(const unsigned int xid, struct cifs_tcon *tcon,
+		   struct cifs_fid *fid, bool delete_pending)
+{
+	return SMB2_set_disp(xid, tcon, fid->persistent_fid, fid->volatile_fid, delete_pending);
+}
+
 static int
 SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid,
@@ -5310,6 +5317,7 @@ struct smb_version_operations smb20_operations = {
 	.set_path_size = smb2_set_path_size,
 	.set_file_size = smb2_set_file_size,
 	.set_file_info = smb2_set_file_info,
+	.set_file_disp = smb2_set_file_disp,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
@@ -5413,6 +5421,7 @@ struct smb_version_operations smb21_operations = {
 	.set_path_size = smb2_set_path_size,
 	.set_file_size = smb2_set_file_size,
 	.set_file_info = smb2_set_file_info,
+	.set_file_disp = smb2_set_file_disp,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
@@ -5520,6 +5529,7 @@ struct smb_version_operations smb30_operations = {
 	.set_path_size = smb2_set_path_size,
 	.set_file_size = smb2_set_file_size,
 	.set_file_info = smb2_set_file_info,
+	.set_file_disp = smb2_set_file_disp,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
@@ -5635,6 +5645,7 @@ struct smb_version_operations smb311_operations = {
 	.set_path_size = smb2_set_path_size,
 	.set_file_size = smb2_set_file_size,
 	.set_file_info = smb2_set_file_info,
+	.set_file_disp = smb2_set_file_disp,
 	.set_compression = smb2_set_compression,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index bf588ec99618..e05ddd446467 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5755,6 +5755,19 @@ SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		0, 1, (void **)&buf, &len);
 }
 
+int
+SMB2_set_disp(const unsigned int xid, struct cifs_tcon *tcon,
+	      u64 persistent_fid, u64 volatile_fid, bool delete_pending)
+{
+	__u8 disp = delete_pending;
+	__u8 *buf = &disp;
+	unsigned int len = sizeof(disp);
+
+	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			     current->tgid, FILE_DISPOSITION_INFORMATION,
+			     SMB2_O_INFO_FILE, 0, 1, (void **)&buf, &len);
+}
+
 int
 SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		  const u64 persistent_fid, const u64 volatile_fid,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 6e805ece6a7b..d78ea3a6a5fb 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -249,6 +249,8 @@ extern int SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		       u64 persistent_fid, u64 volatile_fid,
 		       struct smb2_file_full_ea_info *buf, int len);
+extern int SMB2_set_disp(const unsigned int xid, struct cifs_tcon *tcon,
+			 u64 persistent_fid, u64 volatile_fid, bool delete_pending);
 extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 				u64 persistent_fid, u64 volatile_fid);
 extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.20.1

