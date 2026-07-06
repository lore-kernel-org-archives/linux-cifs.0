Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69803C6A39;
	Mon,  6 Jul 2026 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363739; cv=none; b=Rg42Dz/AWURj48cwICu0oleLWA2WzgnI5uwYv/JelsWciq6KF3IFqed2b5usaT1kWgiW1KAxM79/J4xjj+RS58VEDbefxRFrSX7QN+OSPtP3ct7RWz0wRwGnOtTkSi2FcBRMn2jkFi7zQ5iPQL2zYyRI1woew901ta8ExUDCUg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363739; c=relaxed/simple;
	bh=QPXOq9+Wn++DQGOwk7fudl/5o/Dfy64otWotitCKa5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r4dWgURkWufgOvPuC7wkwQHG1L/wko8To6aasMDlgh83PaxMsakfBRf7oLDstD/Y+fBvqi+nBOqJw8TBXRIqQh2SGmdKoo/eziPuH9Y6vYQbE9psE9nEGTugTRR+o2ICwxq6VEvstZ1qigFhRfgPp3Hi1cEbMW/UjeTZU3kBW6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hViDEQpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hViDEQpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB721F01559;
	Mon,  6 Jul 2026 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363720;
	bh=dKgbVMk191BvLt4ssQa5jm4rZWYgszgggbxHrpKfDs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hViDEQprB9+U/Ok6Ws4fDqZoMBu2nmlKEUvhVxva/i15dYvayXYdo2bEPyZ5PWT59
	 ULEOU7IBq4gali9yV+ucU9+NVJdBQ/fPGnfxvU8Xun6V/jddz2HU2VaOOv1hxXEU2+
	 GBOVyqKxddYW90CmnVopQZMcfvTzWRkadpOnYJu7/k+wagc9VoVBPPlCGPBjFwOgVH
	 +OMSbnWrXf5fRfA3MACz93f5Mb/vHAwGb4h31JLnadrA0oLINVOl5jtMJnsx3TS8zx
	 ju8mACEFLZ1q86TGT3TyJN9Soxu4J4gz/cFhv/nw6ZYCojrg51ogFktb9CvTgVHy7F
	 1QUcBSLq/ZY7w==
Received: by pali.im (Postfix)
	id 595601067; Mon,  6 Jul 2026 20:48:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 08/11] cifs: Extend ->set_EA() callback to allow operate on reparse point
Date: Mon,  6 Jul 2026 20:48:16 +0200
Message-Id: <20260706184819.22124-9-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260706184819.22124-1-pali@kernel.org>
References: <20260706184819.22124-1-pali@kernel.org>
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
index 99f9e6dca62b..36a2e807f1c9 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -569,6 +569,7 @@ struct smb_version_operations {
 			const unsigned char *, const unsigned char *, char *,
 			size_t, struct cifs_sb_info *);
 	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
+			bool open_reparse_point,
 			const char *, const void *, const __u16,
 			const struct nls_table *, struct cifs_sb_info *);
 	struct smb_ntsd * (*get_acl)(struct cifs_sb_info *cifssb, struct inode *ino,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index a2f3a1582cee..e2c3b76cc0e8 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3138,6 +3138,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 			rc = CIFSSMBSetEA(xid,
 					  tcon,
 					  full_path,
+					  true /* open reparse point */,
 					  &ea->ea_data[0],
 					  &ea->ea_data[ea->ea_name_length+1],
 					  le16_to_cpu(ea->ea_value_length),
@@ -6285,7 +6286,8 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
-	     const char *fileName, const char *ea_name, const void *ea_value,
+	     const char *fileName, bool open_reparse_point,
+	     const char *ea_name, const void *ea_value,
 	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	     struct cifs_sb_info *cifs_sb)
 {
@@ -6299,6 +6301,22 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
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
index 06e9322a762a..4f7eefa7a683 100644
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

