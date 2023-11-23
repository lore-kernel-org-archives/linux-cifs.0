Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40239D5E
	for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:54 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2802e5ae23bso571021a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700729153; x=1701333953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XfPHPR3pAaoDVv54sKwmTeDH6+NGHRGJF6MhUopaFek=;
        b=VX1YCXW6FafLINvOXhkyTYoq2QKomn2i1U2/frv507/eFMIjudaA7z/MrMz32g9kL/
         uK5+HGPNNwbkjlTwYnkVOhvWYOzZ7xOsG0IH68ZfVxSWRU054RtmGoeyWwlcJRY4+VrC
         PxUHJqieE53ADnNYmBTXQ7W2HRMOqKcT+lrkveNjkpXXy0snGVl3ts3l59h7UiWikl/1
         gX6ywkt0+X4ZLzK5McdFVA+tbglAvbwqI3qLS8DTCwkVu2tZ8MTLZo60BpUjIf4O/TJk
         MO3CEAwyu+rKZU4GcNRSATmI7uRciDeFE9MHyg3ME1j6JHxMy4o1Ku11AjH4ojxpw6nw
         3BYA==
X-Gm-Message-State: AOJu0YxAqepRbFd2Jtdyyp6Xx1GOpxrrnymm2mVAvU8vXuVsD+IC/Qpq
	VQIyZNSpGIainALVxDzapFZzHbCEBms=
X-Google-Smtp-Source: AGHT+IEVCAe/FH+62pRzwM+aR2UBx3sGD88ZiaAiy/YFvMPzma7RPuIfYyNN3IHGaaAj8sewawL5HQ==
X-Received: by 2002:a17:90a:e7ca:b0:27d:3f08:cc21 with SMTP id kb10-20020a17090ae7ca00b0027d3f08cc21mr5427916pjb.5.1700729153239;
        Thu, 23 Nov 2023 00:45:53 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001bc675068e2sm810208plf.111.2023.11.23.00.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 00:45:52 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/6] ksmbd: move oplock handling after unlock parent dir
Date: Thu, 23 Nov 2023 17:45:04 +0900
Message-Id: <20231123084507.35584-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231123084507.35584-1-linkinjeon@kernel.org>
References: <20231123084507.35584-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd should process secound parallel smb2 create request during waiting
oplock break ack. parent lock range that is too large in smb2_open() causes
smb2_open() to be serialized. Move the oplock handling to the bottom of
smb2_open() and make it called after parent unlock. This fixes the failure
of smb2.lease.breaking1 testcase.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 121 +++++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 56 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ac4204955a85..8cc01c3a763b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2691,7 +2691,7 @@ int smb2_open(struct ksmbd_work *work)
 		    *(char *)req->Buffer == '\\') {
 			pr_err("not allow directory name included leading slash\n");
 			rc = -EINVAL;
-			goto err_out1;
+			goto err_out2;
 		}
 
 		name = smb2_get_name(req->Buffer,
@@ -2702,7 +2702,7 @@ int smb2_open(struct ksmbd_work *work)
 			if (rc != -ENOMEM)
 				rc = -ENOENT;
 			name = NULL;
-			goto err_out1;
+			goto err_out2;
 		}
 
 		ksmbd_debug(SMB, "converted name = %s\n", name);
@@ -2710,28 +2710,28 @@ int smb2_open(struct ksmbd_work *work)
 			if (!test_share_config_flag(work->tcon->share_conf,
 						    KSMBD_SHARE_FLAG_STREAMS)) {
 				rc = -EBADF;
-				goto err_out1;
+				goto err_out2;
 			}
 			rc = parse_stream_name(name, &stream_name, &s_type);
 			if (rc < 0)
-				goto err_out1;
+				goto err_out2;
 		}
 
 		rc = ksmbd_validate_filename(name);
 		if (rc < 0)
-			goto err_out1;
+			goto err_out2;
 
 		if (ksmbd_share_veto_filename(share, name)) {
 			rc = -ENOENT;
 			ksmbd_debug(SMB, "Reject open(), vetoed file: %s\n",
 				    name);
-			goto err_out1;
+			goto err_out2;
 		}
 	} else {
 		name = kstrdup("", GFP_KERNEL);
 		if (!name) {
 			rc = -ENOMEM;
-			goto err_out1;
+			goto err_out2;
 		}
 	}
 
@@ -2744,14 +2744,14 @@ int smb2_open(struct ksmbd_work *work)
 		       le32_to_cpu(req->ImpersonationLevel));
 		rc = -EIO;
 		rsp->hdr.Status = STATUS_BAD_IMPERSONATION_LEVEL;
-		goto err_out1;
+		goto err_out2;
 	}
 
 	if (req->CreateOptions && !(req->CreateOptions & CREATE_OPTIONS_MASK_LE)) {
 		pr_err("Invalid create options : 0x%x\n",
 		       le32_to_cpu(req->CreateOptions));
 		rc = -EINVAL;
-		goto err_out1;
+		goto err_out2;
 	} else {
 		if (req->CreateOptions & FILE_SEQUENTIAL_ONLY_LE &&
 		    req->CreateOptions & FILE_RANDOM_ACCESS_LE)
@@ -2761,13 +2761,13 @@ int smb2_open(struct ksmbd_work *work)
 		    (FILE_OPEN_BY_FILE_ID_LE | CREATE_TREE_CONNECTION |
 		     FILE_RESERVE_OPFILTER_LE)) {
 			rc = -EOPNOTSUPP;
-			goto err_out1;
+			goto err_out2;
 		}
 
 		if (req->CreateOptions & FILE_DIRECTORY_FILE_LE) {
 			if (req->CreateOptions & FILE_NON_DIRECTORY_FILE_LE) {
 				rc = -EINVAL;
-				goto err_out1;
+				goto err_out2;
 			} else if (req->CreateOptions & FILE_NO_COMPRESSION_LE) {
 				req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);
 			}
@@ -2779,21 +2779,21 @@ int smb2_open(struct ksmbd_work *work)
 		pr_err("Invalid create disposition : 0x%x\n",
 		       le32_to_cpu(req->CreateDisposition));
 		rc = -EINVAL;
-		goto err_out1;
+		goto err_out2;
 	}
 
 	if (!(req->DesiredAccess & DESIRED_ACCESS_MASK)) {
 		pr_err("Invalid desired access : 0x%x\n",
 		       le32_to_cpu(req->DesiredAccess));
 		rc = -EACCES;
-		goto err_out1;
+		goto err_out2;
 	}
 
 	if (req->FileAttributes && !(req->FileAttributes & FILE_ATTRIBUTE_MASK_LE)) {
 		pr_err("Invalid file attribute : 0x%x\n",
 		       le32_to_cpu(req->FileAttributes));
 		rc = -EINVAL;
-		goto err_out1;
+		goto err_out2;
 	}
 
 	if (req->CreateContextsOffset) {
@@ -2801,19 +2801,19 @@ int smb2_open(struct ksmbd_work *work)
 		context = smb2_find_context_vals(req, SMB2_CREATE_EA_BUFFER, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
-			goto err_out1;
+			goto err_out2;
 		} else if (context) {
 			ea_buf = (struct create_ea_buf_req *)context;
 			if (le16_to_cpu(context->DataOffset) +
 			    le32_to_cpu(context->DataLength) <
 			    sizeof(struct create_ea_buf_req)) {
 				rc = -EINVAL;
-				goto err_out1;
+				goto err_out2;
 			}
 			if (req->CreateOptions & FILE_NO_EA_KNOWLEDGE_LE) {
 				rsp->hdr.Status = STATUS_ACCESS_DENIED;
 				rc = -EACCES;
-				goto err_out1;
+				goto err_out2;
 			}
 		}
 
@@ -2821,7 +2821,7 @@ int smb2_open(struct ksmbd_work *work)
 						 SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
-			goto err_out1;
+			goto err_out2;
 		} else if (context) {
 			ksmbd_debug(SMB,
 				    "get query maximal access context\n");
@@ -2832,11 +2832,11 @@ int smb2_open(struct ksmbd_work *work)
 						 SMB2_CREATE_TIMEWARP_REQUEST, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
-			goto err_out1;
+			goto err_out2;
 		} else if (context) {
 			ksmbd_debug(SMB, "get timewarp context\n");
 			rc = -EBADF;
-			goto err_out1;
+			goto err_out2;
 		}
 
 		if (tcon->posix_extensions) {
@@ -2844,7 +2844,7 @@ int smb2_open(struct ksmbd_work *work)
 							 SMB2_CREATE_TAG_POSIX, 16);
 			if (IS_ERR(context)) {
 				rc = PTR_ERR(context);
-				goto err_out1;
+				goto err_out2;
 			} else if (context) {
 				struct create_posix *posix =
 					(struct create_posix *)context;
@@ -2852,7 +2852,7 @@ int smb2_open(struct ksmbd_work *work)
 				    le32_to_cpu(context->DataLength) <
 				    sizeof(struct create_posix) - 4) {
 					rc = -EINVAL;
-					goto err_out1;
+					goto err_out2;
 				}
 				ksmbd_debug(SMB, "get posix context\n");
 
@@ -2864,7 +2864,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (ksmbd_override_fsids(work)) {
 		rc = -ENOMEM;
-		goto err_out1;
+		goto err_out2;
 	}
 
 	rc = ksmbd_vfs_kern_path_locked(work, name, LOOKUP_NO_SYMLINKS,
@@ -3177,11 +3177,6 @@ int smb2_open(struct ksmbd_work *work)
 
 	fp->attrib_only = !(req->DesiredAccess & ~(FILE_READ_ATTRIBUTES_LE |
 			FILE_WRITE_ATTRIBUTES_LE | FILE_SYNCHRONIZE_LE));
-	if (!S_ISDIR(file_inode(filp)->i_mode) && open_flags & O_TRUNC &&
-	    !fp->attrib_only && !stream_name) {
-		smb_break_all_oplock(work, fp);
-		need_truncate = 1;
-	}
 
 	/* fp should be searchable through ksmbd_inode.m_fp_list
 	 * after daccess, saccess, attrib_only, and stream are
@@ -3197,13 +3192,39 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	rc = ksmbd_vfs_getattr(&path, &stat);
+	if (rc)
+		goto err_out;
+
+	if (stat.result_mask & STATX_BTIME)
+		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
+	else
+		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
+	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
+		fp->f_ci->m_fattr =
+			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
+
+	if (!created)
+		smb2_update_xattrs(tcon, &path, fp);
+	else
+		smb2_new_xattrs(tcon, &path, fp);
+
+	if (file_present || created)
+		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
+
+	if (!S_ISDIR(file_inode(filp)->i_mode) && open_flags & O_TRUNC &&
+	    !fp->attrib_only && !stream_name) {
+		smb_break_all_oplock(work, fp);
+		need_truncate = 1;
+	}
+
 	share_ret = ksmbd_smb_check_shared_mode(fp->filp, fp);
 	if (!test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_OPLOCKS) ||
 	    (req_op_level == SMB2_OPLOCK_LEVEL_LEASE &&
 	     !(conn->vals->capabilities & SMB2_GLOBAL_CAP_LEASING))) {
 		if (share_ret < 0 && !S_ISDIR(file_inode(fp->filp)->i_mode)) {
 			rc = share_ret;
-			goto err_out;
+			goto err_out1;
 		}
 	} else {
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
@@ -3213,7 +3234,7 @@ int smb2_open(struct ksmbd_work *work)
 				    name, req_op_level, lc->req_state);
 			rc = find_same_lease_key(sess, fp->f_ci, lc);
 			if (rc)
-				goto err_out;
+				goto err_out1;
 		} else if (open_flags == O_RDONLY &&
 			   (req_op_level == SMB2_OPLOCK_LEVEL_BATCH ||
 			    req_op_level == SMB2_OPLOCK_LEVEL_EXCLUSIVE))
@@ -3224,12 +3245,18 @@ int smb2_open(struct ksmbd_work *work)
 				      le32_to_cpu(req->hdr.Id.SyncId.TreeId),
 				      lc, share_ret);
 		if (rc < 0)
-			goto err_out;
+			goto err_out1;
 	}
 
 	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)
 		ksmbd_fd_set_delete_on_close(fp, file_info);
 
+	if (need_truncate) {
+		rc = smb2_create_truncate(&fp->filp->f_path);
+		if (rc)
+			goto err_out1;
+	}
+
 	if (req->CreateContextsOffset) {
 		struct create_alloc_size_req *az_req;
 
@@ -3237,7 +3264,7 @@ int smb2_open(struct ksmbd_work *work)
 					SMB2_CREATE_ALLOCATION_SIZE, 4);
 		if (IS_ERR(az_req)) {
 			rc = PTR_ERR(az_req);
-			goto err_out;
+			goto err_out1;
 		} else if (az_req) {
 			loff_t alloc_size;
 			int err;
@@ -3246,7 +3273,7 @@ int smb2_open(struct ksmbd_work *work)
 			    le32_to_cpu(az_req->ccontext.DataLength) <
 			    sizeof(struct create_alloc_size_req)) {
 				rc = -EINVAL;
-				goto err_out;
+				goto err_out1;
 			}
 			alloc_size = le64_to_cpu(az_req->AllocationSize);
 			ksmbd_debug(SMB,
@@ -3264,30 +3291,13 @@ int smb2_open(struct ksmbd_work *work)
 		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID, 4);
 		if (IS_ERR(context)) {
 			rc = PTR_ERR(context);
-			goto err_out;
+			goto err_out1;
 		} else if (context) {
 			ksmbd_debug(SMB, "get query on disk id context\n");
 			query_disk_id = 1;
 		}
 	}
 
-	rc = ksmbd_vfs_getattr(&path, &stat);
-	if (rc)
-		goto err_out;
-
-	if (stat.result_mask & STATX_BTIME)
-		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
-	else
-		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
-	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
-		fp->f_ci->m_fattr =
-			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
-
-	if (!created)
-		smb2_update_xattrs(tcon, &path, fp);
-	else
-		smb2_new_xattrs(tcon, &path, fp);
-
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
 	rsp->StructureSize = cpu_to_le16(89);
@@ -3394,14 +3404,13 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 err_out:
-	if (file_present || created)
+	if (rc && (file_present || created))
 		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
 
-	if (fp && need_truncate)
-		rc = smb2_create_truncate(&fp->filp->f_path);
-
-	ksmbd_revert_fsids(work);
 err_out1:
+	ksmbd_revert_fsids(work);
+
+err_out2:
 	if (!rc) {
 		ksmbd_update_fstate(&work->sess->file_table, fp, FP_INITED);
 		rc = ksmbd_iov_pin_rsp(work, (void *)rsp, iov_len);
-- 
2.25.1

