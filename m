Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071F26F06F
	for <linux-cifs@vger.kernel.org>; Tue, 20 Feb 2024 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708439175; cv=none; b=P+WOQrTNggbhTrNodk5tUzRD5okwRaKuFOdqBWLtBZqGls+HfhKdBJGPgSkRlShGESH20sx4fsM2ZsQ57Td1zMLv9vo4XblqXQCi0vjDTprqnN+UEfsyJ7zNVq41K4TgyqE8GOmYM+9QfhYNMtrwVOw2TcIDwPO5OpFpgf+DZH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708439175; c=relaxed/simple;
	bh=jy+jo8lwNdgJIRlevswS7InXU97XWX/LUREQ6odmHl4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j40rals7fLDgtZE96c1X1APU1Sc0CBK6+6H9Tc3xSEFXSW0t2Bk67UdBegbezEp29M0dPStbXqL2auZg97kbe8eDdxL17xzlSbuG2bQWA1VYeO2wWRWITYjlMUZUaL7tUfoUFFiZb+iOoPTpHYxUZCSRw4rhbpw/yhj3WmDsvwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=F9LhvEPn; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="F9LhvEPn"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4127109699dso2694255e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Feb 2024 06:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1708439168; x=1709043968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jczxUWfnvImd5BAvRyrStzC8jgH1guyt5q8/skcjuOc=;
        b=F9LhvEPnXWrKUv1xh23+uUEBYLc3aaFHCSBikfy/Pdpu/SOxc9Y6H2tN+roUDuFA8c
         js+dbPaCQ8RWveeJgzxVEXqWjuKmFP6w+9RGYlNFs6R7/8nwjewAnh8bIWk13pMfYPha
         eUrBFc1NRkuYjgpOayt01dcjaqSVfVS5KBNfFMwR9viBZdhYAFZ6eeTENmhFMO1lzoH+
         0CwpzgbsZAKFV8tkK14HNY1pgYRc+QURL+YGZDtCgbj9q1b5VUAYqtkWmPjCqX9hiB7o
         HnkNTY4qg0xUqyfVXszLQzKKTRZALZeEiPWZJtAoq1dPqKCtzhQXFH4WHZxIw2KOW0Yl
         bsmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708439168; x=1709043968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jczxUWfnvImd5BAvRyrStzC8jgH1guyt5q8/skcjuOc=;
        b=IKf7EUFTBnQSuVgCklWbd9vcfpMtD/hV1xaZM9AEEMS05Jl2Dlvjyl6+VeozaZgi0a
         WoKMd2ApkSlvNs8dbDopXOJ6lvaJ5A2U9xgVKspQNNOPcRN6OsWtMWnrUjWgIGFaEGXV
         MkC198wb24UvJwBq6Q54w/EhnWLapafYW9XHNsKchOB79a/nVcFpmFxo3uqVYJt2DSYq
         PxtKr4EHhsXnwngr+jLoA6ki4QecaRWeu8M3h0oKmSG3VO3f9qgMVv1yaSOM9Oz/KtI5
         VSwsWVbgtwS8k4ugzhnJpSRUiO/r3s9lluqZn6+nGHKr4Ou0pghPESVkX3SjG/kYmjH3
         eifg==
X-Gm-Message-State: AOJu0YynoOraEb5HXh9YO8JUKKI2kqiiHwshQpeiksEFP6qNO6E8MZxj
	7FsWOi97a0mVw5CK59bAzz+x5ON4X/5y7Nsq4tLu+8L9eMYgPqV0TraM00gkRrL46cZM7JwgcZl
	g
X-Google-Smtp-Source: AGHT+IFTEaXuD0ZvZUx3PCUnSp+8/wJAuG1JZzQW264HEHDUa0Hu2CKOk+fjFy+tXG8LpF7YJCfCvw==
X-Received: by 2002:a05:600c:4e89:b0:412:610f:c2e7 with SMTP id f9-20020a05600c4e8900b00412610fc2e7mr5262824wmq.41.1708439168604;
        Tue, 20 Feb 2024 06:26:08 -0800 (PST)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id f8-20020a05600c4e8800b0040f0219c371sm15028432wmq.19.2024.02.20.06.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 06:26:08 -0800 (PST)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org
Cc: Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 1/2] ksmbd: replace generic_fillattr with vfs_getattr
Date: Tue, 20 Feb 2024 15:26:00 +0100
Message-Id: <20240220142601.3624584-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use vfs_getattr instead of generic_fillattr in order to call the
fs-specific ->getattr if it exists.
vfs_getattr can return an error, so adapt functions to return the
error to the caller.

This fixes incorrectly filled AllocationSize field in SMB responses
for files on XFS-backed shares.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/smb2pdu.c    | 169 ++++++++++++++++++++++++-------------
 fs/smb/server/smb_common.c |  11 ++-
 fs/smb/server/vfs.c        |  12 ++-
 3 files changed, 128 insertions(+), 64 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0c97d3c86072..1a594753f606 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3828,11 +3828,16 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 		}
 
 		ksmbd_kstat.kstat = &kstat;
-		if (priv->info_level != FILE_NAMES_INFORMATION)
-			ksmbd_vfs_fill_dentry_attrs(priv->work,
-						    idmap,
-						    dent,
-						    &ksmbd_kstat);
+		if (priv->info_level != FILE_NAMES_INFORMATION) {
+			rc = ksmbd_vfs_fill_dentry_attrs(priv->work,
+							 idmap,
+							 dent,
+							 &ksmbd_kstat);
+			if (rc) {
+				dput(dent);
+				continue;
+			}
+		}
 
 		rc = smb2_populate_readdir_entry(priv->work->conn,
 						 priv->info_level,
@@ -4480,6 +4485,7 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	struct smb2_file_basic_info *basic_info;
 	struct kstat stat;
 	u64 time;
+	int ret;
 
 	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
 		pr_err("no right to read the attributes : 0x%x\n",
@@ -4487,9 +4493,13 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 		return -EACCES;
 	}
 
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
+
+
 	basic_info = (struct smb2_file_basic_info *)rsp->Buffer;
-	generic_fillattr(file_mnt_idmap(fp->filp), STATX_BASIC_STATS,
-			 file_inode(fp->filp), &stat);
 	basic_info->CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
 	basic_info->LastAccessTime = cpu_to_le64(time);
@@ -4504,27 +4514,31 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	return 0;
 }
 
-static void get_file_standard_info(struct smb2_query_info_rsp *rsp,
-				   struct ksmbd_file *fp, void *rsp_org)
+static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
+				  struct ksmbd_file *fp, void *rsp_org)
 {
 	struct smb2_file_standard_info *sinfo;
 	unsigned int delete_pending;
-	struct inode *inode;
 	struct kstat stat;
+	int ret;
 
-	inode = file_inode(fp->filp);
-	generic_fillattr(file_mnt_idmap(fp->filp), STATX_BASIC_STATS, inode, &stat);
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
 
 	sinfo = (struct smb2_file_standard_info *)rsp->Buffer;
 	delete_pending = ksmbd_inode_pending_delete(fp);
 
-	sinfo->AllocationSize = cpu_to_le64(inode->i_blocks << 9);
+	sinfo->AllocationSize = cpu_to_le64(stat.blocks << 9);
 	sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	sinfo->NumberOfLinks = cpu_to_le32(get_nlink(&stat) - delete_pending);
 	sinfo->DeletePending = delete_pending;
 	sinfo->Directory = S_ISDIR(stat.mode) ? 1 : 0;
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_standard_info));
+
+	return 0;
 }
 
 static void get_file_alignment_info(struct smb2_query_info_rsp *rsp,
@@ -4546,11 +4560,11 @@ static int get_file_all_info(struct ksmbd_work *work,
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_file_all_info *file_info;
 	unsigned int delete_pending;
-	struct inode *inode;
 	struct kstat stat;
 	int conv_len;
 	char *filename;
 	u64 time;
+	int ret;
 
 	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
 		ksmbd_debug(SMB, "no right to read the attributes : 0x%x\n",
@@ -4562,8 +4576,10 @@ static int get_file_all_info(struct ksmbd_work *work,
 	if (IS_ERR(filename))
 		return PTR_ERR(filename);
 
-	inode = file_inode(fp->filp);
-	generic_fillattr(file_mnt_idmap(fp->filp), STATX_BASIC_STATS, inode, &stat);
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
 
 	ksmbd_debug(SMB, "filename = %s\n", filename);
 	delete_pending = ksmbd_inode_pending_delete(fp);
@@ -4579,7 +4595,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
 	file_info->AllocationSize =
-		cpu_to_le64(inode->i_blocks << 9);
+		cpu_to_le64(stat.blocks << 9);
 	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	file_info->NumberOfLinks =
 			cpu_to_le32(get_nlink(&stat) - delete_pending);
@@ -4623,10 +4639,10 @@ static void get_file_alternate_info(struct ksmbd_work *work,
 		cpu_to_le32(sizeof(struct smb2_file_alt_name_info) + conv_len);
 }
 
-static void get_file_stream_info(struct ksmbd_work *work,
-				 struct smb2_query_info_rsp *rsp,
-				 struct ksmbd_file *fp,
-				 void *rsp_org)
+static int get_file_stream_info(struct ksmbd_work *work,
+				struct smb2_query_info_rsp *rsp,
+				struct ksmbd_file *fp,
+				void *rsp_org)
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_file_stream_info *file_info;
@@ -4637,9 +4653,13 @@ static void get_file_stream_info(struct ksmbd_work *work,
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
 	int buf_free_len;
 	struct smb2_query_info_req *req = ksmbd_req_buf_next(work);
+	int ret;
+
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
 
-	generic_fillattr(file_mnt_idmap(fp->filp), STATX_BASIC_STATS,
-			 file_inode(fp->filp), &stat);
 	file_info = (struct smb2_file_stream_info *)rsp->Buffer;
 
 	buf_free_len =
@@ -4720,29 +4740,37 @@ static void get_file_stream_info(struct ksmbd_work *work,
 	kvfree(xattr_list);
 
 	rsp->OutputBufferLength = cpu_to_le32(nbytes);
+
+	return 0;
 }
 
-static void get_file_internal_info(struct smb2_query_info_rsp *rsp,
-				   struct ksmbd_file *fp, void *rsp_org)
+static int get_file_internal_info(struct smb2_query_info_rsp *rsp,
+				  struct ksmbd_file *fp, void *rsp_org)
 {
 	struct smb2_file_internal_info *file_info;
 	struct kstat stat;
+	int ret;
+
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
 
-	generic_fillattr(file_mnt_idmap(fp->filp), STATX_BASIC_STATS,
-			 file_inode(fp->filp), &stat);
 	file_info = (struct smb2_file_internal_info *)rsp->Buffer;
 	file_info->IndexNumber = cpu_to_le64(stat.ino);
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_internal_info));
+
+	return 0;
 }
 
 static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 				      struct ksmbd_file *fp, void *rsp_org)
 {
 	struct smb2_file_ntwrk_info *file_info;
-	struct inode *inode;
 	struct kstat stat;
 	u64 time;
+	int ret;
 
 	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
 		pr_err("no right to read the attributes : 0x%x\n",
@@ -4750,11 +4778,13 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 		return -EACCES;
 	}
 
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
+
 	file_info = (struct smb2_file_ntwrk_info *)rsp->Buffer;
 
-	inode = file_inode(fp->filp);
-	generic_fillattr(file_mnt_idmap(fp->filp), STATX_BASIC_STATS, inode, &stat);
-
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
 	file_info->LastAccessTime = cpu_to_le64(time);
@@ -4763,8 +4793,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	time = ksmbd_UnixTimeToNT(stat.ctime);
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->Attributes = fp->f_ci->m_fattr;
-	file_info->AllocationSize =
-		cpu_to_le64(inode->i_blocks << 9);
+	file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
 	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
@@ -4804,14 +4833,17 @@ static void get_file_mode_info(struct smb2_query_info_rsp *rsp,
 		cpu_to_le32(sizeof(struct smb2_file_mode_info));
 }
 
-static void get_file_compression_info(struct smb2_query_info_rsp *rsp,
-				      struct ksmbd_file *fp, void *rsp_org)
+static int get_file_compression_info(struct smb2_query_info_rsp *rsp,
+				     struct ksmbd_file *fp, void *rsp_org)
 {
 	struct smb2_file_comp_info *file_info;
 	struct kstat stat;
+	int ret;
 
-	generic_fillattr(file_mnt_idmap(fp->filp), STATX_BASIC_STATS,
-			 file_inode(fp->filp), &stat);
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
 
 	file_info = (struct smb2_file_comp_info *)rsp->Buffer;
 	file_info->CompressedFileSize = cpu_to_le64(stat.blocks << 9);
@@ -4823,6 +4855,8 @@ static void get_file_compression_info(struct smb2_query_info_rsp *rsp,
 
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_comp_info));
+
+	return 0;
 }
 
 static int get_file_attribute_tag_info(struct smb2_query_info_rsp *rsp,
@@ -4844,7 +4878,7 @@ static int get_file_attribute_tag_info(struct smb2_query_info_rsp *rsp,
 	return 0;
 }
 
-static void find_file_posix_info(struct smb2_query_info_rsp *rsp,
+static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 				struct ksmbd_file *fp, void *rsp_org)
 {
 	struct smb311_posix_qinfo *file_info;
@@ -4852,24 +4886,31 @@ static void find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
 	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
+	struct kstat stat;
 	u64 time;
 	int out_buf_len = sizeof(struct smb311_posix_qinfo) + 32;
+	int ret;
+
+	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (ret)
+		return ret;
 
 	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
-	time = ksmbd_UnixTimeToNT(inode_get_atime(inode));
+	time = ksmbd_UnixTimeToNT(stat.atime);
 	file_info->LastAccessTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(inode_get_mtime(inode));
+	time = ksmbd_UnixTimeToNT(stat.mtime);
 	file_info->LastWriteTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(inode_get_ctime(inode));
+	time = ksmbd_UnixTimeToNT(stat.ctime);
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->DosAttributes = fp->f_ci->m_fattr;
-	file_info->Inode = cpu_to_le64(inode->i_ino);
-	file_info->EndOfFile = cpu_to_le64(inode->i_size);
-	file_info->AllocationSize = cpu_to_le64(inode->i_blocks << 9);
-	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
-	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
-	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
+	file_info->Inode = cpu_to_le64(stat.ino);
+	file_info->EndOfFile = cpu_to_le64(stat.size);
+	file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+	file_info->HardLinks = cpu_to_le32(stat.nlink);
+	file_info->Mode = cpu_to_le32(stat.mode & 0777);
+	file_info->DeviceId = cpu_to_le32(stat.rdev);
 
 	/*
 	 * Sids(32) contain two sids(Domain sid(16), UNIX group sid(16)).
@@ -4882,6 +4923,8 @@ static void find_file_posix_info(struct smb2_query_info_rsp *rsp,
 		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
 
 	rsp->OutputBufferLength = cpu_to_le32(out_buf_len);
+
+	return 0;
 }
 
 static int smb2_get_info_file(struct ksmbd_work *work,
@@ -4930,7 +4973,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		break;
 
 	case FILE_STANDARD_INFORMATION:
-		get_file_standard_info(rsp, fp, work->response_buf);
+		rc = get_file_standard_info(rsp, fp, work->response_buf);
 		break;
 
 	case FILE_ALIGNMENT_INFORMATION:
@@ -4946,11 +4989,11 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		break;
 
 	case FILE_STREAM_INFORMATION:
-		get_file_stream_info(work, rsp, fp, work->response_buf);
+		rc = get_file_stream_info(work, rsp, fp, work->response_buf);
 		break;
 
 	case FILE_INTERNAL_INFORMATION:
-		get_file_internal_info(rsp, fp, work->response_buf);
+		rc = get_file_internal_info(rsp, fp, work->response_buf);
 		break;
 
 	case FILE_NETWORK_OPEN_INFORMATION:
@@ -4974,7 +5017,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		break;
 
 	case FILE_COMPRESSION_INFORMATION:
-		get_file_compression_info(rsp, fp, work->response_buf);
+		rc = get_file_compression_info(rsp, fp, work->response_buf);
 		break;
 
 	case FILE_ATTRIBUTE_TAG_INFORMATION:
@@ -4985,7 +5028,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
 			rc = -EOPNOTSUPP;
 		} else {
-			find_file_posix_info(rsp, fp, work->response_buf);
+			rc = find_file_posix_info(rsp, fp, work->response_buf);
 		}
 		break;
 	default:
@@ -5453,6 +5496,9 @@ int smb2_close(struct ksmbd_work *work)
 	rsp->Reserved = 0;
 
 	if (req->Flags == SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB) {
+		struct kstat stat;
+		int ret;
+
 		fp = ksmbd_lookup_fd_fast(work, volatile_id);
 		if (!fp) {
 			err = -ENOENT;
@@ -5460,17 +5506,24 @@ int smb2_close(struct ksmbd_work *work)
 		}
 
 		inode = file_inode(fp->filp);
+		ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+				  AT_STATX_SYNC_AS_STAT);
+		if (ret) {
+			ksmbd_fd_put(work, fp);
+			goto out;
+		}
+
 		rsp->Flags = SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB;
-		rsp->AllocationSize = S_ISDIR(inode->i_mode) ? 0 :
-			cpu_to_le64(inode->i_blocks << 9);
-		rsp->EndOfFile = cpu_to_le64(inode->i_size);
+		rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
+			cpu_to_le64(stat.blocks << 9);
+		rsp->EndOfFile = cpu_to_le64(stat.size);
 		rsp->Attributes = fp->f_ci->m_fattr;
 		rsp->CreationTime = cpu_to_le64(fp->create_time);
-		time = ksmbd_UnixTimeToNT(inode_get_atime(inode));
+		time = ksmbd_UnixTimeToNT(stat.atime);
 		rsp->LastAccessTime = cpu_to_le64(time);
-		time = ksmbd_UnixTimeToNT(inode_get_mtime(inode));
+		time = ksmbd_UnixTimeToNT(stat.mtime);
 		rsp->LastWriteTime = cpu_to_le64(time);
-		time = ksmbd_UnixTimeToNT(inode_get_ctime(inode));
+		time = ksmbd_UnixTimeToNT(stat.ctime);
 		rsp->ChangeTime = cpu_to_le64(time);
 		ksmbd_fd_put(work, fp);
 	} else {
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 7c98bf699772..fcaf373cc008 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -457,10 +457,13 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 			}
 
 			ksmbd_kstat.kstat = &kstat;
-			ksmbd_vfs_fill_dentry_attrs(work,
-						    idmap,
-						    dentry,
-						    &ksmbd_kstat);
+			rc = ksmbd_vfs_fill_dentry_attrs(work,
+							 idmap,
+							 dentry,
+							 &ksmbd_kstat);
+			if (rc)
+				break;
+
 			rc = fn(conn, info_level, d_info, &ksmbd_kstat);
 			if (rc)
 				break;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index a6961bfe3e13..2e992fadeaa7 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1682,11 +1682,19 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 				struct dentry *dentry,
 				struct ksmbd_kstat *ksmbd_kstat)
 {
+	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
 	u64 time;
 	int rc;
+	struct path path = {
+		.mnt = share_conf->vfs_path.mnt,
+		.dentry = dentry,
+	};
 
-	generic_fillattr(idmap, STATX_BASIC_STATS, d_inode(dentry),
-			 ksmbd_kstat->kstat);
+	rc = vfs_getattr(&path, ksmbd_kstat->kstat,
+			 STATX_BASIC_STATS | STATX_BTIME,
+			 AT_STATX_SYNC_AS_STAT);
+	if (rc)
+		return rc;
 
 	time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->ctime);
 	ksmbd_kstat->create_time = time;
-- 
2.34.1

