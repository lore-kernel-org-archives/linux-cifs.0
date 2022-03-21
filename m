Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BCAC433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 16:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350900AbiCUQLR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350859AbiCUQKo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 12:10:44 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A4C3193F
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 09:09:01 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9A16180851;
        Mon, 21 Mar 2022 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1647878939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gtahG5C2jWIq4vJ9FySEQNzX6X+Ihz9qutsozlv3T6I=;
        b=wAPdOqzy8hIJPKk8+lUrVa1uiG5N5UDMk1v4toHMPVj28YlN99EAJsoDfMx1qAKrwIl4Vk
        Zi/WURzcA8/8DsTQCYHG3/3IFalzxAWDpeNlPDL4BAeZiXLQn1NWLU5sf3XBKsjvbxkEwt
        klXR1Gw3O5MyfX7B+uEKV4/bOStOeYYLge2suUCwYxIsv7jPGYkemSoaH84YVSHpevXUZc
        w8CPbn3GNcezr2dhxWWo1qM06K8XoumNA6+pdziHoVpKdaZsBIv/0A9RSbohJkTD4uypXC
        uDvVKNmmtX/tKRJAcCOX/xUcUmK4f1OntgBNRLPxXsCzXfTln4mwAoyrWNLsgA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        linkinjeon@kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/2] cifs: fix bad fids sent over wire
Date:   Mon, 21 Mar 2022 13:08:25 -0300
Message-Id: <20220321160826.30814-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The client used to partially convert the fids to le64, while storing
or sending them by using host endianness.  This broke the client on
big-endian machines.  Instead of converting them to le64, store them
as opaque integers and then avoid byteswapping when sending them over
wire.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2misc.c        |  4 +--
 fs/cifs/smb2ops.c         |  8 ++---
 fs/cifs/smb2pdu.c         | 63 +++++++++++++++++----------------------
 fs/smbfs_common/smb2pdu.h | 24 +++++++--------
 4 files changed, 46 insertions(+), 53 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index b25623e3fe3d..3b7c636be377 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -832,8 +832,8 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
 	rc = __smb2_handle_cancelled_cmd(tcon,
 					 le16_to_cpu(hdr->Command),
 					 le64_to_cpu(hdr->MessageId),
-					 le64_to_cpu(rsp->PersistentFileId),
-					 le64_to_cpu(rsp->VolatileFileId));
+					 rsp->PersistentFileId,
+					 rsp->VolatileFileId);
 	if (rc)
 		cifs_put_tcon(tcon);
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0ecd6e1832a1..c122530e5043 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -900,8 +900,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	atomic_inc(&tcon->num_remote_opens);
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
-	oparms.fid->persistent_fid = le64_to_cpu(o_rsp->PersistentFileId);
-	oparms.fid->volatile_fid = le64_to_cpu(o_rsp->VolatileFileId);
+	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
+	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
@@ -2410,8 +2410,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "query_dir_first: open failed rc=%d\n", rc);
 		goto qdf_free;
 	}
-	fid->persistent_fid = le64_to_cpu(op_rsp->PersistentFileId);
-	fid->volatile_fid = le64_to_cpu(op_rsp->VolatileFileId);
+	fid->persistent_fid = op_rsp->PersistentFileId;
+	fid->volatile_fid = op_rsp->VolatileFileId;
 
 	/* Anything else than ENODATA means a genuine error */
 	if (rc && rc != -ENODATA) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7e7909b1ae11..7e15b0092243 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2734,13 +2734,10 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 		goto err_free_req;
 	}
 
-	trace_smb3_posix_mkdir_done(xid, le64_to_cpu(rsp->PersistentFileId),
-				    tcon->tid,
-				    ses->Suid, CREATE_NOT_FILE,
-				    FILE_WRITE_ATTRIBUTES);
+	trace_smb3_posix_mkdir_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
+				    CREATE_NOT_FILE, FILE_WRITE_ATTRIBUTES);
 
-	SMB2_close(xid, tcon, le64_to_cpu(rsp->PersistentFileId),
-		   le64_to_cpu(rsp->VolatileFileId));
+	SMB2_close(xid, tcon, rsp->PersistentFileId, rsp->VolatileFileId);
 
 	/* Eventually save off posix specific response info and timestaps */
 
@@ -3009,14 +3006,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	} else if (rsp == NULL) /* unlikely to happen, but safer to check */
 		goto creat_exit;
 	else
-		trace_smb3_open_done(xid, le64_to_cpu(rsp->PersistentFileId),
-				     tcon->tid,
-				     ses->Suid, oparms->create_options,
-				     oparms->desired_access);
+		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
+				     oparms->create_options, oparms->desired_access);
 
 	atomic_inc(&tcon->num_remote_opens);
-	oparms->fid->persistent_fid = le64_to_cpu(rsp->PersistentFileId);
-	oparms->fid->volatile_fid = le64_to_cpu(rsp->VolatileFileId);
+	oparms->fid->persistent_fid = rsp->PersistentFileId;
+	oparms->fid->volatile_fid = rsp->VolatileFileId;
 	oparms->fid->access = oparms->desired_access;
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
@@ -3313,8 +3308,8 @@ SMB2_close_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	if (rc)
 		return rc;
 
-	req->PersistentFileId = cpu_to_le64(persistent_fid);
-	req->VolatileFileId = cpu_to_le64(volatile_fid);
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
 	if (query_attrs)
 		req->Flags = SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB;
 	else
@@ -3677,8 +3672,8 @@ SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
 	if (rc)
 		return rc;
 
-	req->PersistentFileId = cpu_to_le64(persistent_fid);
-	req->VolatileFileId = cpu_to_le64(volatile_fid);
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
 	/* See note 354 of MS-SMB2, 64K max */
 	req->OutputBufferLength =
 		cpu_to_le32(SMB2_MAX_BUFFER_SIZE - MAX_SMB2_HDR_SIZE);
@@ -3951,8 +3946,8 @@ SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
 	if (rc)
 		return rc;
 
-	req->PersistentFileId = cpu_to_le64(persistent_fid);
-	req->VolatileFileId = cpu_to_le64(volatile_fid);
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
 
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
@@ -4033,8 +4028,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	shdr = &req->hdr;
 	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
-	req->PersistentFileId = cpu_to_le64(io_parms->persistent_fid);
-	req->VolatileFileId = cpu_to_le64(io_parms->volatile_fid);
+	req->PersistentFileId = io_parms->persistent_fid;
+	req->VolatileFileId = io_parms->volatile_fid;
 	req->ReadChannelInfoOffset = 0; /* reserved */
 	req->ReadChannelInfoLength = 0; /* reserved */
 	req->Channel = 0; /* reserved */
@@ -4094,8 +4089,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 			 */
 			shdr->SessionId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
 			shdr->Id.SyncId.TreeId = cpu_to_le32(0xFFFFFFFF);
-			req->PersistentFileId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
-			req->VolatileFileId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
+			req->PersistentFileId = (u64)-1;
+			req->VolatileFileId = (u64)-1;
 		}
 	}
 	if (remaining_bytes > io_parms->length)
@@ -4307,21 +4302,19 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 			cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
 			cifs_dbg(VFS, "Send error in read = %d\n", rc);
 			trace_smb3_read_err(xid,
-					    le64_to_cpu(req->PersistentFileId),
+					    req->PersistentFileId,
 					    io_parms->tcon->tid, ses->Suid,
 					    io_parms->offset, io_parms->length,
 					    rc);
 		} else
-			trace_smb3_read_done(xid,
-					     le64_to_cpu(req->PersistentFileId),
-					     io_parms->tcon->tid, ses->Suid,
-					     io_parms->offset, 0);
+			trace_smb3_read_done(xid, req->PersistentFileId, io_parms->tcon->tid,
+					     ses->Suid, io_parms->offset, 0);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 		cifs_small_buf_release(req);
 		return rc == -ENODATA ? 0 : rc;
 	} else
 		trace_smb3_read_done(xid,
-				     le64_to_cpu(req->PersistentFileId),
+				    req->PersistentFileId,
 				    io_parms->tcon->tid, ses->Suid,
 				    io_parms->offset, io_parms->length);
 
@@ -4463,8 +4456,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	shdr = (struct smb2_hdr *)req;
 	shdr->Id.SyncId.ProcessId = cpu_to_le32(wdata->cfile->pid);
 
-	req->PersistentFileId = cpu_to_le64(wdata->cfile->fid.persistent_fid);
-	req->VolatileFileId = cpu_to_le64(wdata->cfile->fid.volatile_fid);
+	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
+	req->VolatileFileId = wdata->cfile->fid.volatile_fid;
 	req->WriteChannelInfoOffset = 0;
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
@@ -4562,7 +4555,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 
 	if (rc) {
 		trace_smb3_write_err(0 /* no xid */,
-				     le64_to_cpu(req->PersistentFileId),
+				     req->PersistentFileId,
 				     tcon->tid, tcon->ses->Suid, wdata->offset,
 				     wdata->bytes, rc);
 		kref_put(&wdata->refcount, release);
@@ -4615,8 +4608,8 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	req->hdr.Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
-	req->PersistentFileId = cpu_to_le64(io_parms->persistent_fid);
-	req->VolatileFileId = cpu_to_le64(io_parms->volatile_fid);
+	req->PersistentFileId = io_parms->persistent_fid;
+	req->VolatileFileId = io_parms->volatile_fid;
 	req->WriteChannelInfoOffset = 0;
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
@@ -4645,7 +4638,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	if (rc) {
 		trace_smb3_write_err(xid,
-				     le64_to_cpu(req->PersistentFileId),
+				     req->PersistentFileId,
 				     io_parms->tcon->tid,
 				     io_parms->tcon->ses->Suid,
 				     io_parms->offset, io_parms->length, rc);
@@ -4654,7 +4647,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	} else {
 		*nbytes = le32_to_cpu(rsp->DataLength);
 		trace_smb3_write_done(xid,
-				      le64_to_cpu(req->PersistentFileId),
+				      req->PersistentFileId,
 				      io_parms->tcon->tid,
 				      io_parms->tcon->ses->Suid,
 				      io_parms->offset, *nbytes);
diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
index 38b8fc514860..6653b4be4556 100644
--- a/fs/smbfs_common/smb2pdu.h
+++ b/fs/smbfs_common/smb2pdu.h
@@ -608,8 +608,8 @@ struct smb2_close_req {
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Flags;
 	__le32 Reserved;
-	__le64  PersistentFileId; /* opaque endianness */
-	__le64  VolatileFileId; /* opaque endianness */
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
 } __packed;
 
 /*
@@ -653,8 +653,8 @@ struct smb2_read_req {
 	__u8   Flags; /* MBZ unless SMB3.02 or later */
 	__le32 Length;
 	__le64 Offset;
-	__le64  PersistentFileId;
-	__le64  VolatileFileId;
+	__u64  PersistentFileId;
+	__u64  VolatileFileId;
 	__le32 MinimumCount;
 	__le32 Channel; /* MBZ except for SMB3 or later */
 	__le32 RemainingBytes;
@@ -692,8 +692,8 @@ struct smb2_write_req {
 	__le16 DataOffset; /* offset from start of SMB2 header to write data */
 	__le32 Length;
 	__le64 Offset;
-	__le64  PersistentFileId; /* opaque endianness */
-	__le64  VolatileFileId; /* opaque endianness */
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
 	__le32 Channel; /* MBZ unless SMB3.02 or later */
 	__le32 RemainingBytes;
 	__le16 WriteChannelInfoOffset;
@@ -722,8 +722,8 @@ struct smb2_flush_req {
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Reserved1;
 	__le32 Reserved2;
-	__le64  PersistentFileId;
-	__le64  VolatileFileId;
+	__u64  PersistentFileId;
+	__u64  VolatileFileId;
 } __packed;
 
 struct smb2_flush_rsp {
@@ -769,8 +769,8 @@ struct smb2_change_notify_req {
 	__le16	StructureSize;
 	__le16	Flags;
 	__le32	OutputBufferLength;
-	__le64	PersistentFileId; /* opaque endianness */
-	__le64	VolatileFileId; /* opaque endianness */
+	__u64	PersistentFileId; /* opaque endianness */
+	__u64	VolatileFileId; /* opaque endianness */
 	__le32	CompletionFilter;
 	__u32	Reserved;
 } __packed;
@@ -978,8 +978,8 @@ struct smb2_create_rsp {
 	__le64 EndofFile;
 	__le32 FileAttributes;
 	__le32 Reserved2;
-	__le64  PersistentFileId;
-	__le64  VolatileFileId;
+	__u64  PersistentFileId;
+	__u64  VolatileFileId;
 	__le32 CreateContextsOffset;
 	__le32 CreateContextsLength;
 	__u8   Buffer[1];
-- 
2.35.1

