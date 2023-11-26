Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="eY+czQme"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C87B11F
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 18:55:39 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tm0BG9eGQW5/lpqdrkt6C9rPFQSAAzOgDinpG2VMpOw=;
	b=eY+czQmemRkhY0bCOwt9CY5EZqywNXaQZBJnii2ptW1fGl+g0bqlSTgJZpf86cPwvPERAM
	Pllp/HMxRTQnXK2n+GM3GL4iH+N3QpW3sV3/CJOuZvaVjvA3anHz8b5HMpVrrMJHxuMfyA
	Uvb9Zur3EAACusqwwQbTVUujK72yEB9dDMnD6JwnHaZm6frz9JtmB40eNs98Yn0vNJsydM
	j9zCLIxDeLihOfzmvaj9Zvk50i2shuN95gncyBcjUI6bMV3lbRTzT4kC7mNXLqfwCTfPCQ
	MY+nRzBKLFMHSnHH06ZxSlLp+P5mG4mGaYXiHfcKpTN8sHiUD3JXmRjITiUM5g==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700967337; a=rsa-sha256;
	cv=none;
	b=PEUBsetlkbnPPV+yF7c6pglJz+MJjf2sagGq5SqWnuN0Mqib69MSUNhI1XCiO/tzKMDmH8
	JsJAv5nm8IEN3uxvaEUpJ1Zc2egIMnaJsDT0gKEspws08l5IXBxq0ElNZQ3xwuUknZ2n3A
	qmZpSnF1xlU/jBbSC5uNeoI+h1AwFDF/tXo4c+OvjXPOlObVEidvpTV8UR1bujaK/VEdcM
	5YZgjkdoMy/6g1TEadVCpAKMnsz8NQeSrIO955pMZTShjK7PLp/054nORvlcQ20OSJT4wu
	7A5Z52YiFNISIARd/8+2J45D+DWKv+yXCtxmuX7kEMzpkBw82DIgkFB7OfXAEg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967337; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tm0BG9eGQW5/lpqdrkt6C9rPFQSAAzOgDinpG2VMpOw=;
	b=a4YpGdw1TIRRMZ+6Pop+xUU6y4iFZPj7p2D6KR7UxqW7wC92smMiBPdsRRY0pYx4fnJ0Lb
	xWa5MB//aKptatBoABLwZrlpqXUoiftnf8CqWbQ0mftJNPrgbeBRstX6SMG3wHEXlf+1nm
	vl38BFNp6Af/lpW26TTQif/Edc0rP6QGaavxtu6gZO55lrCwB9H11MNkq4MKZO78BOowqs
	oEy5WAmu4hKv80NoymltSCunAfoRzzgxYjiUMnZ66PUZRLKhcSaYSG5NxGVESJnpaqqUYL
	ZwjPlqtmjIvNTG6sRCGGINgWMJIsFpXVul5waa/CaSKkCoI6ofG1kOnqBxZSQA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 4/9] smb: client: optimise reparse point querying
Date: Sat, 25 Nov 2023 23:55:05 -0300
Message-ID: <20231126025510.28147-5-pc@manguebit.com>
In-Reply-To: <20231126025510.28147-1-pc@manguebit.com>
References: <20231126025510.28147-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reduce number of roundtrips made to server when querying reparse
points in ->query_path_info() by sending a single compound request of
create+get_reparse+get_info+close.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  |  10 ++--
 fs/smb/client/cifsproto.h |   7 +++
 fs/smb/client/inode.c     |   5 +-
 fs/smb/client/smb2glob.h  |   3 +-
 fs/smb/client/smb2inode.c | 121 ++++++++++++++++++++++++++++++--------
 fs/smb/client/trace.h     |   3 +
 6 files changed, 118 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cec8f8d53e2e..4a5b2e363b1d 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -192,6 +192,11 @@ struct cifs_open_info_data {
 		bool symlink;
 	};
 	struct {
+		/* ioctl response buffer */
+		struct {
+			int buftype;
+			struct kvec iov;
+		} io;
 		__u32 tag;
 		union {
 			struct reparse_data_buffer *buf;
@@ -209,11 +214,6 @@ struct cifs_open_info_data {
 	((d)->reparse_point || \
 	 (le32_to_cpu((d)->fi.Attributes) & ATTR_REPARSE))
 
-static inline void cifs_free_open_info(struct cifs_open_info_data *data)
-{
-	kfree(data->symlink_target);
-}
-
 /*
  *****************************************************************
  * Except the CIFS PDUs themselves all the
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 0adeaa84b662..4c5d533d98a3 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -764,4 +764,11 @@ static inline void release_mid(struct mid_q_entry *mid)
 	kref_put(&mid->refcount, __release_mid);
 }
 
+static inline void cifs_free_open_info(struct cifs_open_info_data *data)
+{
+	kfree(data->symlink_target);
+	free_rsp_buf(data->reparse.io.buftype, data->reparse.io.iov.iov_base);
+	memset(data, 0, sizeof(*data));
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 72431cd9530c..e8c94b62c166 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1076,6 +1076,9 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 						      &rsp_iov, &rsp_buftype);
 		if (!rc)
 			iov = &rsp_iov;
+	} else if (data->reparse.io.buftype != CIFS_NO_BUFFER &&
+		   data->reparse.io.iov.iov_base) {
+		iov = &data->reparse.io.iov;
 	}
 
 	rc = -EOPNOTSUPP;
@@ -1095,7 +1098,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		/* Check for cached reparse point data */
 		if (data->symlink_target || data->reparse.buf) {
 			rc = 0;
-		} else if (server->ops->parse_reparse_point) {
+		} else if (iov && server->ops->parse_reparse_point) {
 			rc = server->ops->parse_reparse_point(cifs_sb,
 							      iov, data);
 		}
diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
index ca87a0011c33..a0c156996fc5 100644
--- a/fs/smb/client/smb2glob.h
+++ b/fs/smb/client/smb2glob.h
@@ -35,7 +35,8 @@ enum smb2_compound_ops {
 	SMB2_OP_SET_EOF,
 	SMB2_OP_RMDIR,
 	SMB2_OP_POSIX_QUERY_INFO,
-	SMB2_OP_SET_REPARSE
+	SMB2_OP_SET_REPARSE,
+	SMB2_OP_GET_REPARSE
 };
 
 /* Used when constructing chained read requests. */
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index d662bad3b703..e7af1196779f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -26,6 +26,23 @@
 #include "cached_dir.h"
 #include "smb2status.h"
 
+static struct reparse_data_buffer *reparse_buf_ptr(struct kvec *iov)
+{
+	struct reparse_data_buffer *buf;
+	struct smb2_ioctl_rsp *io = iov->iov_base;
+	u32 len, offs;
+
+	len = le32_to_cpu(io->OutputCount);
+	offs = le32_to_cpu(io->OutputOffset);
+	buf = (struct reparse_data_buffer *)((u8 *)io + offs);
+	if (len + offs > iov->iov_len)
+		return ERR_PTR(-EIO);
+	if (len < sizeof(*buf) ||
+	    len < le16_to_cpu(buf->ReparseDataLength) + sizeof(*buf))
+		return ERR_PTR(-EIO);
+	return buf;
+}
+
 /*
  * note: If cfile is passed, the reference to it is dropped here.
  * So make sure that you do not reuse cfile after return from this func.
@@ -42,8 +59,10 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u8 **extbuf, size_t *extbuflen,
 			    struct kvec *out_iov, int *out_buftype)
 {
+
+	struct reparse_data_buffer *rbuf;
 	struct smb2_compound_vars *vars = NULL;
-	struct kvec *rsp_iov;
+	struct kvec *rsp_iov, *iov;
 	struct smb_rqst *rqst;
 	int rc;
 	__le16 *utf16_path = NULL;
@@ -363,6 +382,21 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			trace_smb3_set_reparse_compound_enter(xid, ses->Suid,
 							      tcon->tid, full_path);
 			break;
+		case SMB2_OP_GET_REPARSE:
+			rqst[num_rqst].rq_iov = vars->io_iov;
+			rqst[num_rqst].rq_nvec = ARRAY_SIZE(vars->io_iov);
+
+			rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+					     COMPOUND_FID, COMPOUND_FID,
+					     FSCTL_GET_REPARSE_POINT,
+					     NULL, 0, CIFSMaxBufSize);
+			if (rc)
+				goto finished;
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst++]);
+			trace_smb3_get_reparse_compound_enter(xid, ses->Suid,
+							      tcon->tid, full_path);
+			break;
 		default:
 			cifs_dbg(VFS, "Invalid command\n");
 			rc = -EINVAL;
@@ -529,6 +563,30 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			}
 			SMB2_ioctl_free(&rqst[num_rqst++]);
 			break;
+		case SMB2_OP_GET_REPARSE:
+			if (!rc) {
+				iov = &rsp_iov[i + 1];
+				idata = in_iov[i].iov_base;
+				idata->reparse.io.iov = *iov;
+				idata->reparse.io.buftype = resp_buftype[i + 1];
+				rbuf = reparse_buf_ptr(iov);
+				if (IS_ERR(rbuf)) {
+					rc = PTR_ERR(rbuf);
+					trace_smb3_set_reparse_compound_err(xid,  ses->Suid,
+									    tcon->tid, rc);
+				} else {
+					idata->reparse.tag = le32_to_cpu(rbuf->ReparseTag);
+					trace_smb3_set_reparse_compound_done(xid, ses->Suid,
+									     tcon->tid);
+				}
+				memset(iov, 0, sizeof(*iov));
+				resp_buftype[i + 1] = CIFS_NO_BUFFER;
+			} else {
+				trace_smb3_set_reparse_compound_err(xid,  ses->Suid,
+								    tcon->tid, rc);
+			}
+			SMB2_ioctl_free(&rqst[num_rqst++]);
+			break;
 		}
 	}
 	SMB2_close_free(&rqst[num_rqst]);
@@ -589,10 +647,11 @@ int smb2_query_path_info(const unsigned int xid,
 	struct cifsFileInfo *cfile;
 	struct cached_fid *cfid = NULL;
 	struct smb2_hdr *hdr;
-	struct kvec in_iov, out_iov[3] = {};
+	struct kvec in_iov[2], out_iov[3] = {};
 	int out_buftype[3] = {};
+	int cmds[2] = { SMB2_OP_QUERY_INFO,  };
 	bool islink;
-	int cmd = SMB2_OP_QUERY_INFO;
+	int i, num_cmds;
 	int rc, rc2;
 
 	data->adjust_tz = false;
@@ -614,14 +673,16 @@ int smb2_query_path_info(const unsigned int xid,
 		return rc;
 	}
 
-	in_iov.iov_base = data;
-	in_iov.iov_len = sizeof(*data);
+	in_iov[0].iov_base = data;
+	in_iov[0].iov_len = sizeof(*data);
+	in_iov[1] = in_iov[0];
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
-			      create_options, ACL_NO_MODE, &in_iov,
-			      &cmd, 1, cfile, NULL, NULL, out_iov, out_buftype);
+			      create_options, ACL_NO_MODE,
+			      in_iov, cmds, 1, cfile,
+			      NULL, NULL, out_iov, out_buftype);
 	hdr = out_iov[0].iov_base;
 	/*
 	 * If first iov is unset, then SMB session was dropped or we've got a
@@ -637,13 +698,19 @@ int smb2_query_path_info(const unsigned int xid,
 		if (rc || !data->reparse_point)
 			goto out;
 
+		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK) {
+			/* symlink already parsed in create response */
+			num_cmds = 1;
+		} else {
+			cmds[1] = SMB2_OP_GET_REPARSE;
+			num_cmds = 2;
+		}
 		create_options |= OPEN_REPARSE_POINT;
-		/* Failed on a symbolic link - query a reparse point info */
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      FILE_READ_ATTRIBUTES, FILE_OPEN,
-				      create_options, ACL_NO_MODE, &in_iov,
-				      &cmd, 1, cfile, NULL, NULL, NULL, NULL);
+				      create_options, ACL_NO_MODE, in_iov, cmds,
+				      num_cmds, cfile, NULL, NULL, NULL, NULL);
 		break;
 	case -EREMOTE:
 		break;
@@ -661,9 +728,8 @@ int smb2_query_path_info(const unsigned int xid,
 	}
 
 out:
-	free_rsp_buf(out_buftype[0], out_iov[0].iov_base);
-	free_rsp_buf(out_buftype[1], out_iov[1].iov_base);
-	free_rsp_buf(out_buftype[2], out_iov[2].iov_base);
+	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
+		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
 	return rc;
 }
 
@@ -678,13 +744,14 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	int rc;
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
-	struct kvec in_iov, out_iov[3] = {};
+	struct kvec in_iov[2], out_iov[3] = {};
 	int out_buftype[3] = {};
 	__u8 *sidsbuf = NULL;
 	__u8 *sidsbuf_end = NULL;
 	size_t sidsbuflen = 0;
 	size_t owner_len, group_len;
-	int cmd = SMB2_OP_POSIX_QUERY_INFO;
+	int cmds[2] = { SMB2_OP_POSIX_QUERY_INFO,  };
+	int i, num_cmds;
 
 	data->adjust_tz = false;
 	data->reparse_point = false;
@@ -695,13 +762,14 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	 * when we already have an open file handle for this. For now this is fast enough
 	 * (always using the compounded version).
 	 */
-	in_iov.iov_base = data;
-	in_iov.iov_len = sizeof(*data);
+	in_iov[0].iov_base = data;
+	in_iov[0].iov_len = sizeof(*data);
+	in_iov[1] = in_iov[0];
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
-			      create_options, ACL_NO_MODE, &in_iov, &cmd, 1,
+			      create_options, ACL_NO_MODE, in_iov, cmds, 1,
 			      cfile, &sidsbuf, &sidsbuflen, out_iov, out_buftype);
 	/*
 	 * If first iov is unset, then SMB session was dropped or we've got a
@@ -718,13 +786,19 @@ int smb311_posix_query_path_info(const unsigned int xid,
 		if (rc || !data->reparse_point)
 			goto out;
 
+		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK) {
+			/* symlink already parsed in create response */
+			num_cmds = 1;
+		} else {
+			cmds[1] = SMB2_OP_GET_REPARSE;
+			num_cmds = 2;
+		}
 		create_options |= OPEN_REPARSE_POINT;
-		/* Failed on a symbolic link - query a reparse point info */
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      FILE_READ_ATTRIBUTES, FILE_OPEN,
-				      create_options, ACL_NO_MODE, &in_iov, &cmd, 1,
-				      cfile, &sidsbuf, &sidsbuflen, NULL, NULL);
+				      create_options, ACL_NO_MODE, in_iov, cmds,
+				      num_cmds, cfile, &sidsbuf, &sidsbuflen, NULL, NULL);
 		break;
 	}
 
@@ -749,9 +823,8 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	}
 
 	kfree(sidsbuf);
-	free_rsp_buf(out_buftype[0], out_iov[0].iov_base);
-	free_rsp_buf(out_buftype[1], out_iov[1].iov_base);
-	free_rsp_buf(out_buftype[2], out_iov[2].iov_base);
+	for (i = 0; i < ARRAY_SIZE(out_buftype); i++)
+		free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
 	return rc;
 }
 
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 34f507584274..522fa387fcfd 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -371,6 +371,7 @@ DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(rmdir_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_eof_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_info_compound_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_reparse_compound_enter);
+DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(get_reparse_compound_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(delete_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(mkdir_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(tdis_enter);
@@ -409,6 +410,7 @@ DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(rmdir_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_eof_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_info_compound_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_reparse_compound_done);
+DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(get_reparse_compound_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(delete_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(mkdir_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(tdis_done);
@@ -453,6 +455,7 @@ DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(rmdir_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_eof_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_info_compound_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_reparse_compound_err);
+DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(get_reparse_compound_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(mkdir_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(delete_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(tdis_err);
-- 
2.43.0

