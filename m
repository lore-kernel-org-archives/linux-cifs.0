Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D81280CF6;
	Mon,  5 May 2025 22:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483319; cv=none; b=PJHXGLLwfFt3gWMlKe4pHG9R75tMYTEV4BaCZq7bvaE+X3NJ0tcMHlc+M9RT2wXfocvfYCk2LgkCeWTgXdFOm0qnwyc7BzKYFNQFnn3RR2vW3pLy/tgKW2/if5tblq/I5YBik089PRNXj7+po5ig0yZQeGarZBpgUiO9rk7okHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483319; c=relaxed/simple;
	bh=ORxGjFZHTBdKZjdWk+4Ls/NkXY4ai1J1HNwWoQyQhmo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhr8IxXJMw6tIj/Qy08vtUc0snN2JEHTsNN8L9ZkzoziOo5Yzbj3QxOI87GQPhmWwjJk6VszWznTxmgpLyBhS//wTQAhTkW8SFq6T7nN0bG32hXs1Jv0Ptt236TcjngmGHjES4AxbhPJLVBZ3QYW4PKGd2DJfJvXFowBNvf+VIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VluthK+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VluthK+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28683C4CEEE;
	Mon,  5 May 2025 22:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483319;
	bh=ORxGjFZHTBdKZjdWk+4Ls/NkXY4ai1J1HNwWoQyQhmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VluthK+xPqu39sOimL4Rbs8ymhuDaoO1xlFD2T0HnSMrQgNeNSUQUbGPxglV3SCIQ
	 IRRhKvCBXLryQ2C8RhP7sdxJoGo0z4khrQSyCIBXoKDaLFo0owMUXfzVeLCXA1rXs/
	 AsPAlnUn3xpl3Yfnu9P/oorKu69nc+4JJP+kCx5vY1mqz19Ye6G4P+9ImzYlnwrC6e
	 VEfzrpHwKDXdj0f5hcy2Gc8TefLJWD6IOXuGZwpKx6UAa3eWgl7fD6Hptq0XV2UVZr
	 bUJXoTnlaRA7CTRoY647XRaa+LKM4xS8pF0LWgoNjNNt64ZqI4ucURjGGKt6xc1xC/
	 g62xPr7Kn167Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 030/642] cifs: Fix getting DACL-only xattr system.cifs_acl and system.smb3_acl
Date: Mon,  5 May 2025 18:04:06 -0400
Message-Id: <20250505221419.2672473-30-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit ad9364a6835c45c52f47587ffbe0577bb7cd4c5b ]

Currently ->get_acl() callback always create request for OWNER, GROUP and
DACL, even when only DACLs was requested by user. Change API callback to
request only information for which the caller asked. Therefore when only
DACLs requested, then SMB client will prepare and send DACL-only request.

This change fixes retrieving of "system.cifs_acl" and "system.smb3_acl"
xattrs to contain only DACL structure as documented.

Note that setting/changing of "system.cifs_acl" and "system.smb3_acl"
xattrs already takes only DACL structure and ignores all other fields.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c |  4 ++--
 fs/smb/client/cifssmb.c |  3 +--
 fs/smb/client/smb2pdu.c |  4 +---
 fs/smb/client/xattr.c   | 15 +++++++++++----
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index f9d577f2d59bb..63b3b1290bed2 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1565,7 +1565,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	int rc = 0;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 	struct smb_version_operations *ops;
-	const u32 info = 0;
+	const u32 info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
 
 	cifs_dbg(NOISY, "converting ACL to mode for %s\n", path);
 
@@ -1619,7 +1619,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	struct tcon_link *tlink;
 	struct smb_version_operations *ops;
 	bool mode_from_sid, id_from_sid;
-	const u32 info = 0;
+	const u32 info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
 	bool posix;
 
 	tlink = cifs_sb_tlink(cifs_sb);
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c2abe79f0dd3b..e90811f321944 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3416,8 +3416,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 	/* BB TEST with big acls that might need to be e.g. larger than 16K */
 	pSMB->MaxSetupCount = 0;
 	pSMB->Fid = fid; /* file handle always le */
-	pSMB->AclFlags = cpu_to_le32(CIFS_ACL_OWNER | CIFS_ACL_GROUP |
-				     CIFS_ACL_DACL | info);
+	pSMB->AclFlags = cpu_to_le32(info);
 	pSMB->ByteCount = cpu_to_le16(11); /* 3 bytes pad + 8 bytes parm */
 	inc_rfc1001_len(pSMB, 11);
 	iov[0].iov_base = (char *)pSMB;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 163b8fea47e8a..044ace0bcde74 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3909,12 +3909,10 @@ SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	       u64 persistent_fid, u64 volatile_fid,
 	       void **data, u32 *plen, u32 extra_info)
 {
-	__u32 additional_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
-				extra_info;
 	*plen = 0;
 
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
-			  0, SMB2_O_INFO_SECURITY, additional_info,
+			  0, SMB2_O_INFO_SECURITY, extra_info,
 			  SMB2_MAX_BUFFER_SIZE, MIN_SEC_DESC_LEN, data, plen);
 }
 
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 58a584f0b27e9..7d49f38f01f3e 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -320,10 +320,17 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 		if (pTcon->ses->server->ops->get_acl == NULL)
 			goto out; /* rc already EOPNOTSUPP */
 
-		if (handler->flags == XATTR_CIFS_NTSD_FULL) {
-			extra_info = SACL_SECINFO;
-		} else {
-			extra_info = 0;
+		switch (handler->flags) {
+		case XATTR_CIFS_NTSD_FULL:
+			extra_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO | SACL_SECINFO;
+			break;
+		case XATTR_CIFS_NTSD:
+			extra_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
+			break;
+		case XATTR_CIFS_ACL:
+		default:
+			extra_info = DACL_SECINFO;
+			break;
 		}
 		pacl = pTcon->ses->server->ops->get_acl(cifs_sb,
 				inode, full_path, &acllen, extra_info);
-- 
2.39.5

