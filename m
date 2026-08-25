Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E0B48F857;
	Tue, 25 Aug 2026 23:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699202; cv=none; b=BtpA5/BEDY55K7C5bUs7uwJAk9dq+6LgMdHCQaIUualqVb/lzdOw9R5Wn5yv0NZXfFvdji6SgayQTVISexo8UlfszIiEcWp5M2AGcuEsVsukWau/q1U4hv0RKLDW8vMZbDpBtPQVbetz6GPXky021fq+FU/RmmOuPbMToWz28eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699202; c=relaxed/simple;
	bh=PR/pUpcB5yaE23zjxWP1ZO3tVoiYnuUAEiEPwcupKZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KGwvfzWrChaLHfZlyGsCu/tssRnCvsSxybdvaMKjlq5Xv3SCa7en+e6a/VhoRwBdn94bqDzLojn7kgxDmeceQY/6DFtAKNANBXpNkSlPvM4AuLgQuJuBUwrJz/F4rzh8NR3XBCq3ERkIY+8EgDcxhdfH3i85/L7vBFO32JNmOMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f987Usp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f987Usp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A4F1F00ACA;
	Tue, 25 Aug 2026 23:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699199;
	bh=2fcRQiSc3pci6kKiy80yvqf0h9OfRYTVvHvtZ4XwXqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f987Usp8aLC1Q2mWMarpMCr/PlWh7UHwqGSMt60ElYuC2rk0CJK9YB+0qxckXqTjF
	 ZiRxWfuSToqs7velvFDfnolw/SluOG0SNCMo93Iv3xC5AGcwTBhJ368I0vcGKt+Kzi
	 OQ9WyWoXz3K+YnDjUZU0ireR1fkYmEOAetY5SzO2gn/FQlEXvpsNOSAdKnK64Gp/Qn
	 nnmUKDtfOhfZM8HKUUy2SGn20sjTpjutnYCYHp61xgYwcvPp4Y4KdomwRUTeIanqKr
	 QgUpeTiE+5/fKpY+zLofp5xvX9srgzyldgqqBaiu6/UGheEdgefUHhjLzM7C+m3Kxn
	 L6KbUZlGBDiIA==
Received: by pali.im (Postfix)
	id E047613FE; Wed, 26 Aug 2026 01:06:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] cifs: Extend ->set_EA() callback to allow operate on reparse point
Date: Wed, 26 Aug 2026 01:06:19 +0200
Message-Id: <20260825230622.24617-7-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825230622.24617-1-pali@kernel.org>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Upcoming changes for setting EAs needs to operate on the reparse point
iself. This change extend >set_EA() callback with a new boolean parameter
to allow it.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/cifssmb.c   | 20 +++++++++++++++++++-
 fs/smb/client/smb1proto.h |  3 ++-
 fs/smb/client/smb2ops.c   |  6 ++++--
 fs/smb/client/xattr.c     |  3 ++-
 5 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..c5fdc0138165 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -570,6 +570,7 @@ struct smb_version_operations {
 			const unsigned char *, const unsigned char *, char *,
 			size_t, struct cifs_sb_info *);
 	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
+			bool open_reparse_point,
 			const char *, const void *, const __u16,
 			const struct nls_table *, struct cifs_sb_info *);
 	struct smb_ntsd * (*get_acl)(struct cifs_sb_info *cifssb, struct inode *ino,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index a972950b7e09..371dbfc2780f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3150,6 +3150,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 			rc = CIFSSMBSetEA(xid,
 					  tcon,
 					  full_path,
+					  true /* open reparse point */,
 					  &ea->ea_data[0],
 					  &ea->ea_data[ea->ea_name_length+1],
 					  le16_to_cpu(ea->ea_value_length),
@@ -6297,7 +6298,8 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
-	     const char *fileName, const char *ea_name, const void *ea_value,
+	     const char *fileName, bool open_reparse_point,
+	     const char *ea_name, const void *ea_value,
 	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	     struct cifs_sb_info *cifs_sb)
 {
@@ -6311,6 +6313,22 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
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
+	 * On systems which do not support reparse points, the behavior of both
+	 * "open_reparse_point=true" and "open_reparse_point=false" is same.
+	 */
+	(void)open_reparse_point;
+
 	cifs_dbg(FYI, "In SetEA\n");
 SetEARetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index f0350fa3f173..8a17350fee7c 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -209,7 +209,8 @@ ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 		       const unsigned char *ea_name, char *EAData,
 		       size_t buf_size, struct cifs_sb_info *cifs_sb);
 int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
-		 const char *fileName, const char *ea_name,
+		 const char *fileName, bool open_reparse_point,
+		 const char *ea_name,
 		 const void *ea_value, const __u16 ea_value_len,
 		 const struct nls_table *nls_codepage,
 		 struct cifs_sb_info *cifs_sb);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7d6738ffcb80..d2ba1a3e8ee3 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1179,7 +1179,8 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
-	    const char *path, const char *ea_name, const void *ea_value,
+	    const char *path, bool open_reparse_point,
+	    const char *ea_name, const void *ea_value,
 	    const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	    struct cifs_sb_info *cifs_sb)
 {
@@ -1281,7 +1282,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
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
index 5091f6c0d7fe..93e4cc114d75 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -154,7 +154,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 
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

