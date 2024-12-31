Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0A01B4236;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684552; cv=none; b=CCpkj6urdyUO+YV2EmLr0jRsestOK6RcXv6It4FFkoEPqor6RQeWH+ZVA7FijcqdXjOCuatV4Y135rf9Mn/BzYOS5idGHRktKoCLMUbWoRwFaN9bC9pmoG7A8yXCyKKTMgB0HjQ6MBKQeiq/jgTX07acZoh/jAvyBJIVE1oPirE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684552; c=relaxed/simple;
	bh=ox+e+7YGWz2v0UmWQWMAc9JFxQV71DFh1C6Wg9eekfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9EO3A/8O5ADw7GkaINVy15gw/km7S9iKq/dkSdTT7MFIZEj+LWmnymUwTL6GPCktf77TMMgqw+Fn0wDC6FoJqS8xYXTYVw+JUF6U1z+OV6VKo/QfpUOC2BtMssgivHsGgtui+JtMNmVb0vUKn7SMdIi/duV1jMkq1dl95qG/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfSZ6y9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfSZ6y9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E09C4CEDF;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684551;
	bh=ox+e+7YGWz2v0UmWQWMAc9JFxQV71DFh1C6Wg9eekfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfSZ6y9Q6zrAq01SItvosH9aNDm1C0ReHOedDEcXPTEyPvnAd4NC3zmmaAMT4m5o/
	 f/IdKBmNxdh7HpCIkF5G/5YQltHxltb4CbxeofywSPXGQx506rJZLibknCPbRNP+Oy
	 G/RWJhSxgxJ3ezGE1Ixa5qdnyNDh60Hz/stPM+3RGyYXrTnDmAWUuaW8+4fmwIlWEw
	 GdvNEdvkjjHnvc22e+O/D4rwerbThwJ2j/gBi9ffW1x4BLTG1ZMltxnsw/IxNU8c7F
	 lKVL1cnbHfhslLcY2k0PDIpeHhE8jnHyun/Wpf7dhFR23F3xzOo5F7BI8SCbXg4kUW
	 YWHSSfSY2Whmg==
Received: by pali.im (Postfix)
	id 41937C2E; Tue, 31 Dec 2024 23:35:41 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] cifs: Improve SMB2+ stat() to work also for paths in DELETE_PENDING state
Date: Tue, 31 Dec 2024 23:35:13 +0100
Message-Id: <20241231223514.15595-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223514.15595-1-pali@kernel.org>
References: <20241231223514.15595-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Paths in DELETE_PENDING state cannot be opened at all. So standard way of
querying path attributes for this case is not possible.

There is an alternative way how to query limited information about file
over SMB2+ dialects without opening file itself. It is by opening the
parent directory, querying specific child with filled search filer and
asking for attributes for that child.

Implement this fallback when standard case in smb2_query_path_info fails
with STATUS_DELETE_PENDING error and stat was asked for path which is not
top level one (because top level does not have parent directory at all).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |   1 +
 fs/smb/client/smb2glob.h  |   1 +
 fs/smb/client/smb2inode.c | 171 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 170 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 06ad727e824b..1338b3473ef3 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2329,6 +2329,7 @@ struct smb2_compound_vars {
 	struct smb_rqst rqst[MAX_COMPOUND];
 	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec qi_iov;
+	struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
 	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
 	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
 	struct kvec close_iov;
diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
index 224495322a05..1cb219605e75 100644
--- a/fs/smb/client/smb2glob.h
+++ b/fs/smb/client/smb2glob.h
@@ -39,6 +39,7 @@ enum smb2_compound_ops {
 	SMB2_OP_GET_REPARSE,
 	SMB2_OP_QUERY_WSL_EA,
 	SMB2_OP_OPEN_QUERY,
+	SMB2_OP_QUERY_DIRECTORY,
 };
 
 /* Used when constructing chained read requests. */
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index b6342b043073..1a8a2f83a3d9 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -190,6 +190,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype[MAX_COMPOUND];
 	struct smb2_create_rsp *create_rsp = NULL;
 	struct smb2_query_info_rsp *qi_rsp = NULL;
+	struct smb2_query_directory_req *qd_rqst = NULL;
+	struct smb2_query_directory_rsp *qd_rsp = NULL;
 	struct cifs_open_info_data *idata;
 	struct inode *inode = NULL;
 	int flags = 0;
@@ -344,6 +346,39 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			trace_smb3_posix_query_info_compound_enter(xid, ses->Suid,
 								   tcon->tid, full_path);
 			break;
+		case SMB2_OP_QUERY_DIRECTORY:
+			rqst[num_rqst].rq_iov = &vars->qd_iov[0];
+			rqst[num_rqst].rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
+
+			rc = SMB2_query_directory_init(xid,
+						       tcon,
+						       server,
+						       &rqst[num_rqst],
+						       cfile ? cfile->fid.persistent_fid : COMPOUND_FID,
+						       cfile ? cfile->fid.volatile_fid : COMPOUND_FID,
+						       0,
+						       (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ?
+						        SMB_FIND_FILE_ID_FULL_DIR_INFO :
+						        SMB_FIND_FILE_FULL_DIRECTORY_INFO);
+			if (!rc) {
+				/*
+				 * Change the default search wildcard pattern '*'
+				 * to the requested file name stored in in_iov[i]
+				 * and request for only one single entry.
+				 */
+				qd_rqst = rqst[num_rqst].rq_iov[0].iov_base;
+				qd_rqst->Flags |= SMB2_RETURN_SINGLE_ENTRY;
+				qd_rqst->FileNameLength = cpu_to_le16(in_iov[i].iov_len);
+				rqst[num_rqst].rq_iov[1] = in_iov[i];
+			}
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
+				goto finished;
+			}
+			num_rqst++;
+			break;
 		case SMB2_OP_DELETE:
 			trace_smb3_delete_enter(xid, ses->Suid, tcon->tid, full_path);
 			break;
@@ -716,6 +751,55 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				trace_smb3_posix_query_info_compound_done(xid, ses->Suid,
 									  tcon->tid);
 			break;
+		case SMB2_OP_QUERY_DIRECTORY:
+			if (rc == 0) {
+				qd_rsp = (struct smb2_query_directory_rsp *)
+					rsp_iov[i + 1].iov_base;
+				rc = smb2_validate_iov(le16_to_cpu(qd_rsp->OutputBufferOffset),
+						       le32_to_cpu(qd_rsp->OutputBufferLength),
+						       &rsp_iov[i + 1],
+						       (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ?
+						        sizeof(SEARCH_ID_FULL_DIR_INFO) :
+						        sizeof(FILE_FULL_DIRECTORY_INFO));
+			}
+			if (rc == 0) {
+				/*
+				 * Both SEARCH_ID_FULL_DIR_INFO and FILE_FULL_DIRECTORY_INFO
+				 * have same member offsets except the UniqueId and FileName.
+				 */
+				SEARCH_ID_FULL_DIR_INFO *si = (SEARCH_ID_FULL_DIR_INFO *)qd_rsp->Buffer;
+				idata = in_iov[i + 1].iov_base;
+				idata->fi.CreationTime = si->CreationTime;
+				idata->fi.LastAccessTime = si->LastAccessTime;
+				idata->fi.LastWriteTime = si->LastWriteTime;
+				idata->fi.ChangeTime = si->ChangeTime;
+				idata->fi.Attributes = si->ExtFileAttributes;
+				idata->fi.AllocationSize = si->AllocationSize;
+				idata->fi.EndOfFile = si->EndOfFile;
+				idata->fi.EASize = si->EaSize;
+				/*
+				 * UniqueId is present only in struct SEARCH_ID_FULL_DIR_INFO.
+				 * It is not present in struct FILE_FULL_DIRECTORY_INFO.
+				 * struct SEARCH_ID_FULL_DIR_INFO was requested only when
+				 * CIFS_MOUNT_SERVER_INUM is set.
+				 */
+				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+					idata->fi.IndexNumber = si->UniqueId;
+				if (le32_to_cpu(idata->fi.NumberOfLinks) == 0)
+					idata->fi.NumberOfLinks = cpu_to_le32(1); /* dummy value */
+				idata->fi.DeletePending = 0;
+				idata->fi.Directory = !!(le32_to_cpu(si->ExtFileAttributes) & ATTR_DIRECTORY);
+			}
+			SMB2_query_directory_free(&rqst[num_rqst++]);
+			if (rc)
+				trace_smb3_query_dir_err(xid,
+							 cfile ? cfile->fid.persistent_fid : COMPOUND_FID,
+							 tcon->tid, ses->Suid, 0, 0, rc);
+			else
+				trace_smb3_query_dir_done(xid,
+							  cfile ? cfile->fid.persistent_fid : COMPOUND_FID,
+							  tcon->tid, ses->Suid, 0, 0);
+			break;
 		case SMB2_OP_DELETE:
 			if (rc)
 				trace_smb3_delete_err(xid,  ses->Suid, tcon->tid, rc);
@@ -894,6 +978,7 @@ int smb2_query_path_info(const unsigned int xid,
 	struct cifs_open_parms oparms;
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *parent_cfile;
 	struct cached_fid *cfid = NULL;
 	struct smb2_hdr *hdr;
 	struct kvec in_iov[3], out_iov[3] = {};
@@ -1085,9 +1170,9 @@ int smb2_query_path_info(const unsigned int xid,
 		break;
 	case -EREMOTE:
 		break;
-	default:
-		if (hdr->Status != STATUS_OBJECT_NAME_INVALID)
-			break;
+	}
+
+	if (hdr->Status == STATUS_OBJECT_NAME_INVALID) {
 		rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
 						     full_path, &islink);
 		if (rc2) {
@@ -1096,6 +1181,86 @@ int smb2_query_path_info(const unsigned int xid,
 		}
 		if (islink)
 			rc = -EREMOTE;
+	} else if (hdr->Status == STATUS_DELETE_PENDING && full_path[0]) {
+		/*
+		 * If SMB2 OPEN/CREATE fails with STATUS_DELETE_PENDING error,
+		 * it means that the path is in delete pending state and it is
+		 * not possible to open it until some other client clears delete
+		 * pending state or all other clients close all opened handles
+		 * to that path.
+		 *
+		 * There is an alternative way how to query limited information
+		 * about path which is in delete pending state still suitable
+		 * for the stat() syscall. It is by opening the parent directory,
+		 * querying specific child with filled search filer and asking
+		 * for attributes for that child.
+		 */
+
+		char *parent_path;
+		const char *basename;
+		__le16 *basename_utf16;
+		int basename_utf16_len;
+
+		basename = strrchr(full_path, CIFS_DIR_SEP(cifs_sb));
+		if (basename) {
+			parent_path = kstrndup(full_path, basename - full_path, GFP_KERNEL);
+			basename++;
+		} else {
+			parent_path = kstrdup("", GFP_KERNEL);
+			basename = full_path;
+		}
+
+		if (!parent_path) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		basename_utf16 = cifs_convert_path_to_utf16(basename, cifs_sb);
+		if (!basename_utf16) {
+			kfree(parent_path);
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		basename_utf16_len = 2 * UniStrnlen((wchar_t *)basename_utf16, PATH_MAX);
+
+retry_query_directory:
+		for (i = 0; i < ARRAY_SIZE(out_buftype); i++) {
+			free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
+			out_buftype[i] = 0;
+			out_iov[i].iov_base = NULL;
+		}
+
+		num_cmds = 1;
+		cmds[0] = SMB2_OP_QUERY_DIRECTORY;
+		in_iov[0].iov_base = basename_utf16;
+		in_iov[0].iov_len = basename_utf16_len;
+		in_iov[1].iov_base = data;
+		in_iov[1].iov_len = sizeof(*data);
+		oparms = CIFS_OPARMS(cifs_sb, tcon, parent_path, FILE_READ_DATA,
+				     FILE_OPEN, CREATE_NOT_FILE, ACL_NO_MODE);
+		cifs_get_readable_path(tcon, parent_path, &parent_cfile);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, parent_path,
+				      &oparms, in_iov, cmds, num_cmds,
+				      parent_cfile, out_iov, out_buftype, NULL);
+		if (rc == -EOPNOTSUPP && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+			/*
+			 * If querying of server inode numbers is not supported
+			 * but is enabled, then disable it and try again.
+			 */
+			cifs_autodisable_serverino(cifs_sb);
+			goto retry_query_directory;
+		}
+
+		kfree(parent_path);
+		kfree(basename_utf16);
+
+		hdr = out_iov[0].iov_base;
+		if (!hdr || out_buftype[0] == CIFS_NO_BUFFER)
+			goto out;
+
+		/* As we are in code path for STATUS_DELETE_PENDING, set DeletePending. */
+		data->fi.DeletePending = 1;
 	}
 
 out:
-- 
2.20.1

