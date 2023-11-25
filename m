Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="k/GvYtMC"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980B7C5
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 14:08:38 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QjZ7NAVTTYnZYPPVITyN5OKVsVj2BZ/hPg5wcMVea8U=;
	b=k/GvYtMC75vVr8hO4lSs/RSVbLDkZzuGSxuNg4Ri4H2d5ejSl3Wq1QPGbrM7MKd5cP+xlB
	9nWrxj9Os55Ev7RxM6iK+0Soz4bKEMBjfJ5JsS1jkIKk5sV/Zbflo/5GM71x0Gth/QPdEz
	pQ7CwnOJqskUx1qjnJLFavll5ulwf6LhBC15dejzpUi6SNAe5QDd6CaoRKXy+6SfzKomo5
	aZUyQ5b4AkGcgmueTFw0g50RKlv/Y1Gy8bJEG3+b15A8NEbiNz09/gUKN6gBY/p1AMr9lV
	wMVuX1rUHhjkuZT9OeBPFxSR/S5sVrevuTOqQbcFY+RiYR44qcEb+0Ihc/yFUQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700950117; a=rsa-sha256;
	cv=none;
	b=bBECi0xYZm64BzitlE8V91e+U7Ag8HKzI9agyVy0/Ym+gZoZgVRzGTEKWsiqc76J8E1Mlq
	f3bb/l8OwtapFtAAoa+H+Sznu4afXfUo5rFGExcFlaiLydBYRRnOBVPezJsi8L1URX/YYP
	byli0EiAyoUs5bxjVSyFJ/pigTBBJzC0afBs8gHM7MGIizehILiGo8hqCf7lhz5dwpi7qm
	uEcP8sa6tXbUwYCVOs1usYLx9NZYkA7qtHMopQDPYSz1mPfRFwuk9pcuXfO21I1pU/NgvD
	JXRNtYzuzv7d8XGa1jgt4v/RIiqManNapIUw3VzYopwGO7Hh4h/FNRyBcDpPeA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950117; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QjZ7NAVTTYnZYPPVITyN5OKVsVj2BZ/hPg5wcMVea8U=;
	b=mdqpcq6gfl9FV7S9KxWffE2PoVWujmV1VW2FiaRy1pOmE+hRU1skpzai928gtKN5beBC+/
	v4t9D3/4jqrGAJaKS4Wu34GfJiDPSlLXs0ku3vXV0tP0fj6Ie1RQ9J4BzaqkIIFcX1bOwh
	LwuSVxDnEL0v1/EkvJk6M/EvmYGP5bwFW94jmvFXCsPiwA4JsSQQJYxTYSHe+NDDpZA7/y
	rmua9VOOw3g4/VQiE+GVrbFD+4Wf7c6u3+H80Jir8Dp5CujhR47wa+jdX/y/Q2Ogjd2EkA
	WxCRq4pAzrDOAHb2+ohWiYbOI9GlvysoyAYU4zEkDNZZrFtSbtD7uh1J++HwLg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 6/8] smb: client: fix hardlinking of reparse points
Date: Sat, 25 Nov 2023 19:08:11 -0300
Message-ID: <20231125220813.30538-7-pc@manguebit.com>
In-Reply-To: <20231125220813.30538-1-pc@manguebit.com>
References: <20231125220813.30538-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The client was sending an SMB2_CREATE request without setting
OPEN_REPARSE_POINT flag thus failing the entire hardlink operation.

Fix this by setting OPEN_REPARSE_POINT in create options for
SMB2_CREATE request when the source inode is a repase point.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  |  8 +++++---
 fs/smb/client/cifsproto.h |  8 +++++---
 fs/smb/client/cifssmb.c   |  9 +++++----
 fs/smb/client/link.c      |  4 ++--
 fs/smb/client/smb2inode.c | 34 ++++++++++++++++++++++------------
 fs/smb/client/smb2proto.h |  8 +++++---
 6 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7ceea52058ab..50fedc2513c3 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -405,9 +405,11 @@ struct smb_version_operations {
 		      const char *from_name, const char *to_name,
 		      struct cifs_sb_info *cifs_sb);
 	/* send create hardlink request */
-	int (*create_hardlink)(const unsigned int, struct cifs_tcon *,
-			       const char *, const char *,
-			       struct cifs_sb_info *);
+	int (*create_hardlink)(const unsigned int xid,
+			       struct cifs_tcon *tcon,
+			       struct dentry *source_dentry,
+			       const char *from_name, const char *to_name,
+			       struct cifs_sb_info *cifs_sb);
 	/* query symlink target */
 	int (*query_symlink)(const unsigned int xid,
 			     struct cifs_tcon *tcon,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index e680fe46d4e8..afbab86331a1 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -447,9 +447,11 @@ extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
 				 int netfid, const char *target_name,
 				 const struct nls_table *nls_codepage,
 				 int remap_special_chars);
-extern int CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
-			      const char *from_name, const char *to_name,
-			      struct cifs_sb_info *cifs_sb);
+int CIFSCreateHardLink(const unsigned int xid,
+		       struct cifs_tcon *tcon,
+		       struct dentry *source_dentry,
+		       const char *from_name, const char *to_name,
+		       struct cifs_sb_info *cifs_sb);
 extern int CIFSUnixCreateHardLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const char *fromName, const char *toName,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 43a90e646a7a..5331fda8b013 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2528,10 +2528,11 @@ CIFSUnixCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int
-CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
-		   const char *from_name, const char *to_name,
-		   struct cifs_sb_info *cifs_sb)
+int CIFSCreateHardLink(const unsigned int xid,
+		       struct cifs_tcon *tcon,
+		       struct dentry *source_dentry,
+		       const char *from_name, const char *to_name,
+		       struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	NT_RENAME_REQ *pSMB = NULL;
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 82fb069c6ce4..d86da949a919 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -510,8 +510,8 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 			rc = -ENOSYS;
 			goto cifs_hl_exit;
 		}
-		rc = server->ops->create_hardlink(xid, tcon, from_name, to_name,
-						  cifs_sb);
+		rc = server->ops->create_hardlink(xid, tcon, old_file,
+						  from_name, to_name, cifs_sb);
 		if ((rc == -EIO) || (rc == -EINVAL))
 			rc = -EOPNOTSUPP;
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 956f74328860..1a19b0cc34d7 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -43,6 +43,18 @@ static struct reparse_data_buffer *reparse_buf_ptr(struct kvec *iov)
 	return buf;
 }
 
+static inline __u32 file_create_options(struct dentry *dentry)
+{
+	struct cifsInodeInfo *ci;
+
+	if (dentry) {
+		ci = CIFS_I(d_inode(dentry));
+		if (ci->reparse)
+			return OPEN_REPARSE_POINT;
+	}
+	return 0;
+}
+
 /*
  * note: If cfile is passed, the reference to it is dropped here.
  * So make sure that you do not reuse cfile after return from this func.
@@ -919,15 +931,10 @@ int smb2_rename_path(const unsigned int xid,
 		     const char *from_name, const char *to_name,
 		     struct cifs_sb_info *cifs_sb)
 {
-	struct cifsInodeInfo *ci;
+
 	struct cifsFileInfo *cfile;
-	__u32 co = 0;
+	__u32 co = file_create_options(source_dentry);
 
-	if (source_dentry) {
-		ci = CIFS_I(d_inode(source_dentry));
-		if (ci->reparse)
-			co |= OPEN_REPARSE_POINT;
-	}
 	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
@@ -935,13 +942,16 @@ int smb2_rename_path(const unsigned int xid,
 				  co, DELETE, SMB2_OP_RENAME, cfile);
 }
 
-int
-smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
-		     const char *from_name, const char *to_name,
-		     struct cifs_sb_info *cifs_sb)
+int smb2_create_hardlink(const unsigned int xid,
+			 struct cifs_tcon *tcon,
+			 struct dentry *source_dentry,
+			 const char *from_name, const char *to_name,
+			 struct cifs_sb_info *cifs_sb)
 {
+	__u32 co = file_create_options(source_dentry);
+
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
-				  cifs_sb, 0, FILE_READ_ATTRIBUTES,
+				  cifs_sb, co, FILE_READ_ATTRIBUTES,
 				  SMB2_OP_HARDLINK, NULL);
 }
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 5e68ddc7b422..3639588709a2 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -91,9 +91,11 @@ int smb2_rename_path(const unsigned int xid,
 		     struct dentry *source_dentry,
 		     const char *from_name, const char *to_name,
 		     struct cifs_sb_info *cifs_sb);
-extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
-				const char *from_name, const char *to_name,
-				struct cifs_sb_info *cifs_sb);
+int smb2_create_hardlink(const unsigned int xid,
+			 struct cifs_tcon *tcon,
+			 struct dentry *source_dentry,
+			 const char *from_name, const char *to_name,
+			 struct cifs_sb_info *cifs_sb);
 extern int smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const unsigned char *path,
 			char *pbuf, unsigned int *pbytes_written);
-- 
2.43.0

