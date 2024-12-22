Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988C418F2E2;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734880293; cv=none; b=ix2mKn6/sJrLZ1bUgVTc05LXyhG5SSbfuFW/+gI3YqAO0JQKQO9AqtuGG3itxsJzKx4Ouu5FekVX2oNQoFD5e15gVCpYXwsANflH7upRtwhM70LiKN6UJ4bzB3L+9agRKL2LPiCsjbrTwV2ULcU5EP7Qxia13XCdRNOvPwMm4Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734880293; c=relaxed/simple;
	bh=hwBjETRXEAfebMQOElg2PKZncQc90DyWmN1kiPghSB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QRVfG3NStaEQC0++DutR43YG8CbtBOBAWvwCL56aBOhTM6CXD+SbLyrxe7jT8smltNycHXwBaf16YDlzZ88oZsLtv58Ahj9SyRZLvxh1rjqlddsq8NcjJSztbyPW7xXzn4M+hXqVM7roDwG702e1xpzKWG2hZi79FntiqnKRwnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0rTJ2ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0rTJ2ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7CCC4CEDC;
	Sun, 22 Dec 2024 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734880293;
	bh=hwBjETRXEAfebMQOElg2PKZncQc90DyWmN1kiPghSB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0rTJ2icRUtNjuVar+l94F72gQtMQn6zhH1y89ZgtkE6d3VyAD97sj5jAeunGZYpB
	 NVFoqESluV9N3Oo5Qdlv8HrpKI1pBOSvK2uMGVZqZH6VbnBpwyqP5Q0huOGFpEQeS1
	 yFR0eMRzyT3ddGukcA298LkA24KevZIzLddHSfbVO0dN1HwctANHo7KwI5UxWNCKH+
	 OAHLq+tmpj4XYow5eGKCVoPVBGN8a064Mq+gEgOQHC50MePyyKcYBTJkfIQTrlAzpL
	 cBAraJGT22YpbLlNDGQ9COYd0WjEia/+TnHzAl6bWZiHxiRkJeYmN/rrW7DyghUNsf
	 jVSSbLHLLOa5Q==
Received: by pali.im (Postfix)
	id E0E7F982; Sun, 22 Dec 2024 16:11:22 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] cifs: Fix getting and setting SACLs over SMB1
Date: Sun, 22 Dec 2024 16:10:48 +0100
Message-Id: <20241222151051.23917-2-pali@kernel.org>
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

SMB1 callback get_cifs_acl_by_fid() currently ignores its last argument and
therefore ignores request for SACL_SECINFO. Fix this issue by correctly
propagating info argument from get_cifs_acl() and get_cifs_acl_by_fid() to
CIFSSMBGetCIFSACL() function and pass SACL_SECINFO when requested.

For accessing SACLs it is needed to open object with SYSTEM_SECURITY
access. Pass this flag when trying to get or set SACLs.

Same logic is in the SMB2+ code path.

Fixes: 3970acf7ddb9 ("SMB3: Add support for getting and setting SACLs")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsacl.c   | 23 ++++++++++++++---------
 fs/smb/client/cifsproto.h |  2 +-
 fs/smb/client/cifssmb.c   |  4 ++--
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index ba79aa2107cc..b07f3609adec 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1395,7 +1395,7 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 				      const struct cifs_fid *cifsfid, u32 *pacllen,
-				      u32 __maybe_unused unused)
+				      u32 info)
 {
 	struct smb_ntsd *pntsd = NULL;
 	unsigned int xid;
@@ -1407,7 +1407,7 @@ struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 
 	xid = get_xid();
 	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), cifsfid->netfid, &pntsd,
-				pacllen);
+				pacllen, info);
 	free_xid(xid);
 
 	cifs_put_tlink(tlink);
@@ -1419,7 +1419,7 @@ struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 }
 
 static struct smb_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
-		const char *path, u32 *pacllen)
+		const char *path, u32 *pacllen, u32 info)
 {
 	struct smb_ntsd *pntsd = NULL;
 	int oplock = 0;
@@ -1446,9 +1446,12 @@ static struct smb_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 		.fid = &fid,
 	};
 
+	if (info & SACL_SECINFO)
+		oparms.desired_access |= SYSTEM_SECURITY;
+
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (!rc) {
-		rc = CIFSSMBGetCIFSACL(xid, tcon, fid.netfid, &pntsd, pacllen);
+		rc = CIFSSMBGetCIFSACL(xid, tcon, fid.netfid, &pntsd, pacllen, info);
 		CIFSSMBClose(xid, tcon, fid.netfid);
 	}
 
@@ -1472,7 +1475,7 @@ struct smb_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 	if (inode)
 		open_file = find_readable_file(CIFS_I(inode), true);
 	if (!open_file)
-		return get_cifs_acl_by_path(cifs_sb, path, pacllen);
+		return get_cifs_acl_by_path(cifs_sb, path, pacllen, info);
 
 	pntsd = get_cifs_acl_by_fid(cifs_sb, &open_file->fid, pacllen, info);
 	cifsFileInfo_put(open_file);
@@ -1498,10 +1501,12 @@ int set_cifs_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 	tcon = tlink_tcon(tlink);
 	xid = get_xid();
 
-	if (aclflag == CIFS_ACL_OWNER || aclflag == CIFS_ACL_GROUP)
-		access_flags = WRITE_OWNER;
-	else
-		access_flags = WRITE_DAC;
+	if (aclflag & CIFS_ACL_OWNER || aclflag & CIFS_ACL_GROUP)
+		access_flags |= WRITE_OWNER;
+	if (aclflag & CIFS_ACL_SACL)
+		access_flags |= SYSTEM_SECURITY;
+	if (aclflag & CIFS_ACL_DACL)
+		access_flags |= WRITE_DAC;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 467378e23bd7..5aa2769a42f3 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -560,7 +560,7 @@ extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 		const struct nls_table *nls_codepage,
 		struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon,
-			__u16 fid, struct smb_ntsd **acl_inf, __u32 *buflen);
+			__u16 fid, struct smb_ntsd **acl_inf, __u32 *buflen, __u32 info);
 extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
 			struct smb_ntsd *pntsd, __u32 len, int aclflag);
 extern int cifs_do_get_acl(const unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 4ca6022d2cd5..2791c1cbadfa 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3364,7 +3364,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 /* Get Security Descriptor (by handle) from remote server for a file or dir */
 int
 CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
-		  struct smb_ntsd **acl_inf, __u32 *pbuflen)
+		  struct smb_ntsd **acl_inf, __u32 *pbuflen, __u32 info)
 {
 	int rc = 0;
 	int buf_type = 0;
@@ -3387,7 +3387,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 	pSMB->MaxSetupCount = 0;
 	pSMB->Fid = fid; /* file handle always le */
 	pSMB->AclFlags = cpu_to_le32(CIFS_ACL_OWNER | CIFS_ACL_GROUP |
-				     CIFS_ACL_DACL);
+				     CIFS_ACL_DACL | info);
 	pSMB->ByteCount = cpu_to_le16(11); /* 3 bytes pad + 8 bytes parm */
 	inc_rfc1001_len(pSMB, 11);
 	iov[0].iov_base = (char *)pSMB;
-- 
2.20.1

