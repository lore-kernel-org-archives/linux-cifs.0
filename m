Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB62374F1;
	Sat, 12 Jul 2025 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752336625; cv=none; b=MZwdkH60UDXlMcIy/IH2jT2QlKdw6hC0xImVuCObXWjipXvbAlbSgLemIIu9e87rtRk22RmfAl6d17t5CW35n9RFuZrgjWgcfXQOVlEOLzUX/xK1WPesx/wgWi75uJnOzXiSkbvnTbfzifyaXMqnFNJ7j74Mx1DzLYErXhJhzm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752336625; c=relaxed/simple;
	bh=2/O65eYxq7Wd0qRjkQpVJjBp+f4MIKQYRhOCgDLlZPE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=g2Q9hB82k/vorpTSjL/5KA8I4GgWhSSo5r6QynOdlO6JnV+hqY7xMpkISmwf+B6yX3kiTpqacp++8hvLe6R20JGDHKCgqrKnJDgVnz4gxOG/AkhMOgoFs3FYRBbT414PDSnduTY0VKQ7fr2inP3vmmgYDWW69mlUFi8zoR3OE1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DE54JFp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DE54JFp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29CFC4CEEF;
	Sat, 12 Jul 2025 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752336625;
	bh=2/O65eYxq7Wd0qRjkQpVJjBp+f4MIKQYRhOCgDLlZPE=;
	h=From:To:Cc:Subject:Date:From;
	b=DE54JFp+s0SeUstaj1/zhSeeK/FxxR9BTxMt/HfI5uZ1WMxfHCo5O3XPBgQLfO6i1
	 U+AwCZJaua1KPB9TgjQgLtbiAYzmEhJu/rEofGgJSTcJynlrrNP8wUDLogotB1nKpB
	 iFGlyfvA49KznCGK7xfX5LS2Z+5Z6K9nbKZ9nENtDKJth62bcmNEd52t+LhywuxUNm
	 XVSbvKK+VbWQjoIlpN9ntHMIrXKjrdozrVzpErUya1jAdv73w1IYA2ZyjD0vUx2UmT
	 vmy3TdtJNUIq13i9T02qtwYnrvLiprvvokhxLSkB7AR2jNmAjO+pbWW1WCA66Nl/Az
	 yVT405rD3sM0A==
Received: by pali.im (Postfix)
	id 82FB37E2; Sat, 12 Jul 2025 18:10:19 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cifs: Extend ->set_EA() callback to allow operate on reparse point
Date: Sat, 12 Jul 2025 18:10:11 +0200
Message-Id: <20250712161012.17622-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Upcoming changes for setting EAs needs to operate on the reparse point
itself. This change extend >set_EA() callback with a new boolean parameter
to allow it.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/cifsproto.h |  3 ++-
 fs/smb/client/cifssmb.c   | 20 +++++++++++++++++++-
 fs/smb/client/smb2ops.c   |  6 ++++--
 fs/smb/client/xattr.c     |  3 ++-
 5 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index fffb1b2dc09f..6a84d5eae578 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -571,6 +571,7 @@ struct smb_version_operations {
 			const unsigned char *, const unsigned char *, char *,
 			size_t, struct cifs_sb_info *);
 	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
+			bool open_reparse_point,
 			const char *, const void *, const __u16,
 			const struct nls_table *, struct cifs_sb_info *);
 	struct smb_ntsd * (*get_acl)(struct cifs_sb_info *cifssb, struct inode *ino,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 4fbd42b98703..e449b33d9bdc 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -567,7 +567,8 @@ extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 			const unsigned char *ea_name, char *EAData,
 			size_t bufsize, struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
-		const char *fileName, const char *ea_name,
+		const char *fileName, bool open_reparse_point,
+		const char *ea_name,
 		const void *ea_value, const __u16 ea_value_len,
 		const struct nls_table *nls_codepage,
 		struct cifs_sb_info *cifs_sb);
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 54183d7dcc85..44b3f7be0f58 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2885,6 +2885,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 			rc = CIFSSMBSetEA(xid,
 					  tcon,
 					  full_path,
+					  true /* open reparse point */,
 					  &ea->ea_data[0],
 					  &ea->ea_data[ea->ea_name_length+1],
 					  le16_to_cpu(ea->ea_value_length),
@@ -5961,7 +5962,8 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
-	     const char *fileName, const char *ea_name, const void *ea_value,
+	     const char *fileName, bool open_reparse_point,
+	     const char *ea_name, const void *ea_value,
 	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	     struct cifs_sb_info *cifs_sb)
 {
@@ -5974,6 +5976,22 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	__u16 params, param_offset, byte_count, offset, count;
 	int remap = cifs_remap(cifs_sb);
 
+	/*
+	 * On NT systems which supports reparse points, the TRANS2_SET_PATH_INFORMATION
+	 * operates on the reparse point itself and not the path location where reparse
+	 * point redirects. So the behavior of TRANS2_SET_PATH_INFORMATION is as if the
+	 * path was opened with OPEN_REPARSE_POINT flag. Hence this SMB1 SetEA function
+	 * implements only the behavior of "open_reparse_point=true" parameter.
+	 *
+	 * TODO: Implement "open_reparse_point=false" support for SMB1 SetEA. For this
+	 * is needed to call NT OPEN without OPEN_REPARSE_POINT flag and then call
+	 * TRANS2_SET_FILE_INFORMATION.
+	 *
+	 * On systems which do not support reparse points, the behavior of of both
+	 * "open_reparse_point=true" and "open_reparse_point=false" is same.
+	 */
+	(void)open_reparse_point;
+
 	cifs_dbg(FYI, "In SetEA\n");
 SetEARetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b2aa802c7521..7ce8472a90dd 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1155,7 +1155,8 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
-	    const char *path, const char *ea_name, const void *ea_value,
+	    const char *path, bool open_reparse_point,
+	    const char *ea_name, const void *ea_value,
 	    const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	    struct cifs_sb_info *cifs_sb)
 {
@@ -1256,7 +1257,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		.path = path,
 		.desired_access = FILE_WRITE_EA,
 		.disposition = FILE_OPEN,
-		.create_options = cifs_create_options(cifs_sb, 0),
+		.create_options = cifs_create_options(cifs_sb,
+				open_reparse_point ? OPEN_REPARSE_POINT : 0),
 		.fid = &fid,
 		.replay = !!(retries),
 	};
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index b88fa04f5792..26193249dbd8 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -155,7 +155,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 
 		if (pTcon->ses->server->ops->set_EA) {
 			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
-				full_path, name, value, (__u16)size,
+				full_path, false /* open reparse point */,
+				name, value, (__u16)size,
 				cifs_sb->local_nls, cifs_sb);
 			if (rc == 0)
 				inode_set_ctime_current(inode);
-- 
2.20.1

