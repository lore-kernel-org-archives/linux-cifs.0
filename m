Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="G3RH3/Tz"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6734AF
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 18:55:44 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EgIW8fstFVznxdSASa7BvWlx7k+vn8AbW79CjZahdW8=;
	b=G3RH3/Tzrz/+qNH2Xaqy6eRUd8IkhkbozwR6RmJKcSv/PMPStFdwWhle/d5ZTJsqOflC56
	ZyLG/Bdz8E9DLDjERoegbBCOehzw5qrSiPhzsORkHCj+hdlgKUG1MN7dmnE59/TeNq9ScD
	PbGJs67Wj59OGsW+oB/9e1TZTxOllUP3womrokOIZFsjZWRbqBohSl2pPUtdnaQGd7yESb
	U9hZHdisTWoNI1pL+6HpwJ/kCmcDPa37HML2/mdJpcjVclocsGUr8FeKGvA1FVEeQ7Nt/I
	a2uJtTTwoMgGx+ROlU36+Ynyg+ARzqJRo9TmdiZ5R+n5k7OjqnQt+vp0VE8tDg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700967343; a=rsa-sha256;
	cv=none;
	b=mxKDOOr7dTsOY5qdU1Xcns7bcY9KZKvBjk0/DE7DvgtNMAm7wx96TLBaruTcoKzK3B8+L2
	9DXGeswWS0iIsOi6DH73rC0g9/Pt4ouHPDRZOQZxR9Nv9sKd67cxMlYsyTysiAm0Y5pTYo
	EQhDl0ko4U/AMJCX2LJ4Fz6OJD4buYz4h49WcERa2NrWGC1zW7fKmpNFhYVbbkHxdmYZzm
	vfoJIu2I25jbrEXoZqvqqLVB7pU/kloCr0+9+rRIAkuK0aIw7es8ukrcyBidjXDi7vxBHw
	GfKn8j92fFUKzLEBwWEYJJ7k50ZNKv6yKk0kR7j7chwZ81jSASkCFTpSN+TR5w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967343; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EgIW8fstFVznxdSASa7BvWlx7k+vn8AbW79CjZahdW8=;
	b=KY2KcLIuhRIkC76lJg6+T0Hkm1nOFo+huRmzwAS7DkJfLO/C1z8xdEkzLvpq82RPchp8sc
	tunFFV33M0jVcPJsG69vzdi2A30jdBWGg4v4vm3UQKfi2Mwq9S7UlrhsQgT+8LK28TdEsQ
	2J15w3umcbmEavrJkHWKiA0EpRPYi52hGZEyvzFJFbuTPEX0BbGacjbmYw5U4e0zJqtGXG
	tWH6KivNmdG9nGY8HYuKEeCC1I7tJoffZVii8irEqxIOocudmMxbi+mY21lc8EsY+9AmGU
	5yi5+QM23/q0sGpeos3WVW/mr874xZ9Y5OzMB3Vqt1CdBlrl79I4UPQ7l40BWg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 7/9] smb: client: cleanup smb2_query_reparse_point()
Date: Sat, 25 Nov 2023 23:55:08 -0300
Message-ID: <20231126025510.28147-8-pc@manguebit.com>
In-Reply-To: <20231126025510.28147-1-pc@manguebit.com>
References: <20231126025510.28147-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use smb2_compound_op() with SMB2_OP_GET_REPARSE to get reparse point.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2inode.c |  33 ++++++++++
 fs/smb/client/smb2ops.c   | 133 --------------------------------------
 fs/smb/client/smb2proto.h |   6 ++
 3 files changed, 39 insertions(+), 133 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 1a19b0cc34d7..3e8ba41b790d 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1053,3 +1053,36 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	}
 	return rc ? ERR_PTR(rc) : new;
 }
+
+int smb2_query_reparse_point(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     struct cifs_sb_info *cifs_sb,
+			     const char *full_path,
+			     u32 *tag, struct kvec *rsp,
+			     int *rsp_buftype)
+{
+	struct cifs_open_info_data data = {};
+	struct cifsFileInfo *cfile;
+	struct kvec in_iov = { .iov_base = &data, .iov_len = sizeof(data), };
+	int rc;
+
+	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
+
+	cifs_get_readable_path(tcon, full_path, &cfile);
+	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+			      FILE_READ_ATTRIBUTES, FILE_OPEN,
+			      OPEN_REPARSE_POINT, ACL_NO_MODE, &in_iov,
+			      &(int){SMB2_OP_GET_REPARSE}, 1, cfile,
+			      NULL, NULL, NULL, NULL);
+	if (rc)
+		goto out;
+
+	*tag = data.reparse.tag;
+	*rsp = data.reparse.io.iov;
+	*rsp_buftype = data.reparse.io.buftype;
+	memset(&data.reparse.io.iov, 0, sizeof(data.reparse.io.iov));
+	data.reparse.io.buftype = CIFS_NO_BUFFER;
+out:
+	cifs_free_open_info(&data);
+	return rc;
+}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5bbba565ad5c..8d4ba661190c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2981,139 +2981,6 @@ static int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 	return parse_reparse_point(buf, plen, cifs_sb, true, data);
 }
 
-static int smb2_query_reparse_point(const unsigned int xid,
-				    struct cifs_tcon *tcon,
-				    struct cifs_sb_info *cifs_sb,
-				    const char *full_path,
-				    u32 *tag, struct kvec *rsp,
-				    int *rsp_buftype)
-{
-	struct smb2_compound_vars *vars;
-	int rc;
-	__le16 *utf16_path = NULL;
-	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct cifs_open_parms oparms;
-	struct cifs_fid fid;
-	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
-	int flags = CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst *rqst;
-	int resp_buftype[3];
-	struct kvec *rsp_iov;
-	struct smb2_ioctl_rsp *ioctl_rsp;
-	struct reparse_data_buffer *reparse_buf;
-	u32 plen;
-
-	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
-
-	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
-	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
-
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
-	if (!vars) {
-		rc = -ENOMEM;
-		goto out_free_path;
-	}
-	rqst = vars->rqst;
-	rsp_iov = vars->rsp_iov;
-
-	/*
-	 * setup smb2open - TODO add optimization to call cifs_get_readable_path
-	 * to see if there is a handle already open that we can use
-	 */
-	rqst[0].rq_iov = vars->open_iov;
-	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
-
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.path = full_path,
-		.desired_access = FILE_READ_ATTRIBUTES,
-		.disposition = FILE_OPEN,
-		.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT),
-		.fid = &fid,
-	};
-
-	rc = SMB2_open_init(tcon, server,
-			    &rqst[0], &oplock, &oparms, utf16_path);
-	if (rc)
-		goto query_rp_exit;
-	smb2_set_next_command(tcon, &rqst[0]);
-
-
-	/* IOCTL */
-	rqst[1].rq_iov = vars->io_iov;
-	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
-
-	rc = SMB2_ioctl_init(tcon, server,
-			     &rqst[1], COMPOUND_FID,
-			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
-			     CIFSMaxBufSize -
-			     MAX_SMB2_CREATE_RESPONSE_SIZE -
-			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
-	if (rc)
-		goto query_rp_exit;
-
-	smb2_set_next_command(tcon, &rqst[1]);
-	smb2_set_related(&rqst[1]);
-
-	/* Close */
-	rqst[2].rq_iov = &vars->close_iov;
-	rqst[2].rq_nvec = 1;
-
-	rc = SMB2_close_init(tcon, server,
-			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
-	if (rc)
-		goto query_rp_exit;
-
-	smb2_set_related(&rqst[2]);
-
-	rc = compound_send_recv(xid, tcon->ses, server,
-				flags, 3, rqst,
-				resp_buftype, rsp_iov);
-
-	ioctl_rsp = rsp_iov[1].iov_base;
-
-	/*
-	 * Open was successful and we got an ioctl response.
-	 */
-	if (rc == 0) {
-		/* See MS-FSCC 2.3.23 */
-
-		reparse_buf = (struct reparse_data_buffer *)
-			((char *)ioctl_rsp +
-			 le32_to_cpu(ioctl_rsp->OutputOffset));
-		plen = le32_to_cpu(ioctl_rsp->OutputCount);
-
-		if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
-		    rsp_iov[1].iov_len) {
-			cifs_tcon_dbg(FYI, "srv returned invalid ioctl len: %d\n",
-				 plen);
-			rc = -EIO;
-			goto query_rp_exit;
-		}
-		*tag = le32_to_cpu(reparse_buf->ReparseTag);
-		*rsp = rsp_iov[1];
-		*rsp_buftype = resp_buftype[1];
-		resp_buftype[1] = CIFS_NO_BUFFER;
-	}
-
- query_rp_exit:
-	SMB2_open_free(&rqst[0]);
-	SMB2_ioctl_free(&rqst[1]);
-	SMB2_close_free(&rqst[2]);
-	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
-	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
-	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
-	kfree(vars);
-out_free_path:
-	kfree(utf16_path);
-	return rc;
-}
-
 static struct cifs_ntsd *
 get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
 		    const struct cifs_fid *cifsfid, u32 *pacllen, u32 info)
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 3639588709a2..f08cd5821b55 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -62,6 +62,12 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 				     struct cifs_tcon *tcon,
 				     const char *full_path,
 				     struct kvec *iov);
+int smb2_query_reparse_point(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     struct cifs_sb_info *cifs_sb,
+			     const char *full_path,
+			     u32 *tag, struct kvec *rsp,
+			     int *rsp_buftype);
 int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
-- 
2.43.0

