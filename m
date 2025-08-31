Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7113326A1B5;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=gYSX9wB9DSz2PIGwWFPb4Psk6ivtN9F50pgTJdvKggbhc5ewClH/Pa/jPSZye2JtPsz6eVOUU3OjfVFzlAEN6HsGZIdGvSsXrFKKITHV+UmTbjT05tArOotB752i6P+kuKO2nVAyzaRzGVP2SUbc6TCCDfblWWKZLdmloQ1IBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=bf7MNX1yDmW4c/5HyYGIxpycUcryAysX16+cXoiPGH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hlnHeg7wCEY5isom6BXdzuVcYq64nT0taBRW5uYo03oJw+n1OsC6ifRM/5yUNMbjYYMu5L+3UOp0odlrTBH7ljSR+a+g1+aiOLuPiSqdz2hql2eCljKxGvHzK5WgsBnw77Gf+LFQRKWw7frthQQ4xByj0Tp7X4E8BHdelaPC1yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6w09TsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6w09TsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D96C4CEF5;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=bf7MNX1yDmW4c/5HyYGIxpycUcryAysX16+cXoiPGH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6w09TsT9Rg/oxH9nY68HHBbgba+ITmO33hXijm8x/fBWXbFuJzA3rfnmqHPAXqDg
	 QUbhXdLewhTCgC/ndzBCId4sZKp3e1XArHkl2IX4JHvTdguC2K8AI51DYTdKGK0+8Z
	 8WE+FQpygMIkVlJIgjdtUTISPbetzpQ/IMwmi0ZFqeYCjamN8RZmo/GFfTJmgiXuzc
	 rUMh4VQfx38KpcCnzk6uoXa8ZR/B94J3OrbTRmOfJuEumkPsFLiHnurFr9qcf4IubU
	 kzwlxv/DsyqQE21cahQ6D3Zn/n7R7GSJx5z8vDkWr1dj733uH3nmrUsUpDSUDOnq2R
	 e9CSuRfDeVSsg==
Received: by pali.im (Postfix)
	id 7E3691407; Sun, 31 Aug 2025 14:36:33 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/35] cifs: Extend CIFSSMBRenameOpenFile() function for overwrite parameter
Date: Sun, 31 Aug 2025 14:35:41 +0200
Message-Id: <20250831123602.14037-15-pali@kernel.org>
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

Currently CIFSSMBRenameOpenFile() function always overwrite the target
location. This new overwrite parameter allows to specify if the rename
should fail when the target location exists. This new parameter would be
used in follow up changes.

No functional change.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h | 2 +-
 fs/smb/client/cifssmb.c   | 4 ++--
 fs/smb/client/inode.c     | 3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f467b24fd984..f248b18f1cf3 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -470,7 +470,7 @@ int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 		  const char *from_name, const char *to_name,
 		  struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
-				 int netfid, const char *target_name,
+				 int netfid, const char *target_name, bool overwrite,
 				 const struct nls_table *nls_codepage,
 				 int remap_special_chars);
 int CIFSCreateHardLink(const unsigned int xid,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 8d9f6f28c17e..f12bc0f4d0c1 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2313,7 +2313,7 @@ int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
-		int netfid, const char *target_name,
+		int netfid, const char *target_name, bool overwrite,
 		const struct nls_table *nls_codepage, int remap)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
@@ -2353,7 +2353,7 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 	pSMB->DataOffset = cpu_to_le16(offset);
-	rename_info->overwrite = cpu_to_le32(1);
+	rename_info->overwrite = cpu_to_le32(overwrite);
 	rename_info->root_fid  = 0;
 	/* unicode only call */
 	len_of_str = cifsConvertToUTF16((__le16 *)rename_info->target_name,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 2889fa6625af..be8e5e5ca6cd 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1793,6 +1793,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 
 	/* rename the file */
 	rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, sillyname,
+				   true /* overwrite */,
 				   cifs_sb->local_nls,
 				   cifs_remap(cifs_sb));
 	if (rc != 0) {
@@ -1834,6 +1835,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	 */
 undo_rename:
 	CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, dentry->d_name.name,
+				true /* overwrite */,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
 undo_setattr:
 	if (dosattr != origattr) {
@@ -2374,6 +2376,7 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	if (rc == 0) {
 		rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid,
 				(const char *) to_dentry->d_name.name,
+				true /* overwrite */,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
 		CIFSSMBClose(xid, tcon, fid.netfid);
 	}
-- 
2.20.1

