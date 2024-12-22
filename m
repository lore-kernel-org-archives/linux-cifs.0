Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3040190054;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734880293; cv=none; b=RZGV1ZO2tyoXDKn+p04vBQAFmMPL5tbHO3tecNFT5D0u0uISYO4m7QeXdPmiAv2lDPEPhC0pczseDfRZ5opTZvhyw6z3wEzYnUDxUO8qgOTtvJinXouZdgpTh+VWCitTB2SNsKj3eWWphyFf4yZqn40SGq0Gey5BKUsgllPa28k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734880293; c=relaxed/simple;
	bh=XQ//vd9aMqG0wrIXFj0REfqyyWPJnL6J2ImYL2qPgwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SYEs8FPLwQYfubs3QIAUQR9ojBc0wSDsPXl3YNf7z4y6UAKxpw8PuL+KIKeNe+pg8YPh8WLTOp1ll9o45j5c4yxh9WN2MYMo0xA2gkwwgODmNtkbqvHgPmT4CmYy2bYmaqUzoBnS27aCNBpCZ77A2XnXrPz/JanvDuXgsQ6+L5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgguiDnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgguiDnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0220FC4CEDD;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734880293;
	bh=XQ//vd9aMqG0wrIXFj0REfqyyWPJnL6J2ImYL2qPgwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgguiDnr1e64ZvX16yH7zL+V7DVTHW7FsWwLDYiA2bGgWP3usf1glmCWkFBmrR6Nm
	 FdL+lV3wkaTY5t5ppZ9uYsK9hlq4j8U56o4T1++huhMIBVhv+dQdGMgvKIkcBgjqUY
	 dhxBsaAtSJEQMkNqHvQsJLmGMcvsRN9Pi8gmgTtU2B8r65mMvotnB2+kggKXqgfYks
	 UzZnjrtVL7rYVOMJ0Y+4PVXJjxfuuOvLNPZI38pZaXIqRIFBLJibsN0PVIP6/T3+XQ
	 FuDfvBxLcHi+vWVK+92rFV1KYsbMzx0rNCIbOYHQ/EdZppKMXJrNLDLzYN28W/NhJR
	 dfaqbVAEVLrDA==
Received: by pali.im (Postfix)
	id 1C4C6B9A; Sun, 22 Dec 2024 16:11:23 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] cifs: Change ->get_acl() API callback to request only for asked info
Date: Sun, 22 Dec 2024 16:10:49 +0100
Message-Id: <20241222151051.23917-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222151051.23917-1-pali@kernel.org>
References: <20241222151051.23917-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently ->get_acl() always request for ONWER, GROUP and DACL, even when
only DACLs was requested. Change API callback to request only information
for which the caller asked. Therefore when only DACLs requested, then SMB
client send DACL-only request.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsacl.c |  4 ++--
 fs/smb/client/cifssmb.c |  3 +--
 fs/smb/client/smb2pdu.c |  4 +---
 fs/smb/client/xattr.c   | 15 +++++++++++----
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index b07f3609adec..1054c62ade6c 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1546,7 +1546,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	int rc = 0;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 	struct smb_version_operations *ops;
-	const u32 info = 0;
+	const u32 info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
 
 	cifs_dbg(NOISY, "converting ACL to mode for %s\n", path);
 
@@ -1600,7 +1600,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	struct tcon_link *tlink;
 	struct smb_version_operations *ops;
 	bool mode_from_sid, id_from_sid;
-	const u32 info = 0;
+	const u32 info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
 	bool posix;
 
 	tlink = cifs_sb_tlink(cifs_sb);
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2791c1cbadfa..2763db49b155 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3386,8 +3386,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
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
index 010eae9d6c47..ccded987f82b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3928,12 +3928,10 @@ SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
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
index 58a584f0b27e..7d49f38f01f3 100644
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
2.20.1

