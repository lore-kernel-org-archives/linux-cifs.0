Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053574;
	b=uHsqBYMMIsrIFaKmeUjQU2AvTWoSNDGYdL/+KgC81i6jekrrcJ1+FrRpcyE9AqFKYROz
	 zhEreK7wuq0szzKEd30fM01qwaimTGyl5YfB8oN3CZ9vmUViDujI7Rv2YeQMQBKxi1QNd
	 g1LYQFvq1oOuj/V8zKli7uZdF+dG8cyPL0FCeWyb8kBWCgzo1KW5Qkw/r0rGP7ttmKAwO
	 /fDdYfHsvuoWc321g/V/YnEDOmoX4/q8HQRPB5TVCUcQy9GBcUPiZVj+ItErGTPSjDDPB
	 voKB18Lv8nj2p4QIo0vn9uThZgwS/ceWoibVxV4AHVSDR8B+f4LApbV8598ZcR1jVRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053574;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=501v5zGSSrJJbT553kHWUYIqeUlxgW8LfMQp2LR/cCc=;
	b=0OldLSaCrijwttYxWR/LHg6mo6rwSkRw+6KW2eZrG96tc0tayk/cEG3+q3dWkBnhwzls
	 56RKA30vvawUD8ASojQ2PN2EgqJz9lq6EYNHSiK4YBfO1dlyuiPKF2903osbfibNgpmy9
	 +ZB2GjDOQJR9IPkgc7RRMrVbcYhLXtpcohHiSrBIYLlVKcGLQ6Xk8PJ8Q3ipXykMh+qEw
	 3/+1NQLtgQErqw6nQ+u5qtuBzNQpGFnt5+l8E+JAJpjHzdyzDaYjV1Q0BI3DMqybeAxlf
	 HTpALucQ/AwzUFaUJL8GOE5gh9KKrqlesZ2gwPEFPmYbcKazuWLLLrz5K7Z4XH2c57Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NsxhbB4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735AD606A32A;
	Mon, 26 Oct 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NsxhbB4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03951F031E3;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053574;
	bh=501v5zGSSrJJbT553kHWUYIqeUlxgW8LfMQp2LR/cCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsxhbB4sWHH8yUJtHtbjhF7zspqyAv7f91r3TOLF5XcE41kbeU2RwD7cNzM38djVo
	 ak0U5KoiA1CdbZtnBXkIRIbiG7iRmaayuTKQELxMzDzvJWL4Ir1m/8clmZS0KeixoV
	 wj6vcpzPCSXwgoid3gzOZqvWoRX7L00Vw8PaTu+j3RH+nYPJ3b98r3f0/nrtl3Ehs2
	 JRZTHJpcpyFvkt0dKm23wmRFNnzS5MvABMEJSXcKalXblbMbuetHlJZQr0ltFjT/0b
	 RXGqt+TIHPAn3lyzsUGBSQKwNNjkrvFYDUuNuJ0Crgc8pO6QbJUn4zvdpm9yCNTucX
	 THDqmqCx2tv4g==
Received: by pali.im (Postfix)
	id 937E0F86; Mon, 26 Oct 2026 23:26:10 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 6/9] cifs: Extend ->set_EA() callback to allow operate on reparse point
Date: Mon, 26 Oct 2026 23:25:57 +0100
Message-Id: <20261026222600.17323-7-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261026222600.17323-1-pali@kernel.org>
References: <20261026222600.17323-1-pali@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
index 5c5b76a9e9fe..d5faef5f3a73 100644
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
index 8bdd81af6d21..07c7d6fa97c4 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3166,6 +3166,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 			rc = CIFSSMBSetEA(xid,
 					  tcon,
 					  full_path,
+					  true /* open reparse point */,
 					  &ea->ea_data[0],
 					  &ea->ea_data[ea->ea_name_length+1],
 					  le16_to_cpu(ea->ea_value_length),
@@ -6322,7 +6323,8 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
-	     const char *fileName, const char *ea_name, const void *ea_value,
+	     const char *fileName, bool open_reparse_point,
+	     const char *ea_name, const void *ea_value,
 	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	     struct cifs_sb_info *cifs_sb)
 {
@@ -6338,6 +6340,22 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	int remap = cifs_remap(cifs_sb);
 	unsigned int total_len;
 
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
index 583ab4c4d773..6de334e222f0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1188,7 +1188,8 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
-	    const char *path, const char *ea_name, const void *ea_value,
+	    const char *path, bool open_reparse_point,
+	    const char *ea_name, const void *ea_value,
 	    const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	    struct cifs_sb_info *cifs_sb)
 {
@@ -1290,7 +1291,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
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

