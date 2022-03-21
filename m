Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FF2C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 00:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiCUAVl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 20 Mar 2022 20:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbiCUAVk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 20 Mar 2022 20:21:40 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A44D8302A
        for <linux-cifs@vger.kernel.org>; Sun, 20 Mar 2022 17:20:16 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 6737E80851;
        Mon, 21 Mar 2022 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1647822014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SZYkCN02ecu3/rOISPWScoiqfEATCKbLcXyY/vJ+dXg=;
        b=u8wSe0RQ7/HTrjKOQjI4u1MtRT4s5WZbBV7Nekeaelytr3jkS9tH/JRE223+pqOnjAg0rc
        pMOOmEVHoeeFsK91V8Fu2cJcISU4MEoWI3obAZ2agR8rfg8o/OsfVJmgy4jpdWCCy/gYAX
        8joC3V8Se3Nm4FQB+kmtP6G9Wr/HFbZSxxLSdZTcbKcqbRM1ckkqW+otjo4yu9ekJ7w1+I
        IbZQa+dKL8jfqY0lOn/ImjuytGx0V42o6DL2RTpP7GhPLlahtqXBvUVNwcJKu6J2y8Cqqm
        mkRLfep9gb4WwMIJ9Ieb1S5MOL5hPWn+d/EEf0pquGjH6EzkTssN/OrBiPu/wg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     tom@talpey.com, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: fix bad fids sent over wire
Date:   Sun, 20 Mar 2022 21:20:07 -0300
Message-Id: <20220321002007.26903-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The client used to partially convert the fids to le64, while storing
or sending them by using host endianness.  This broke the client on
big-endian machines.  Instead of converting them to le64, store them
verbatim and then avoid byteswapping when sending them over wire.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2misc.c |  4 ++--
 fs/cifs/smb2ops.c  |  8 +++----
 fs/cifs/smb2pdu.c  | 53 ++++++++++++++++++++--------------------------
 3 files changed, 29 insertions(+), 36 deletions(-)

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
index 7e7909b1ae11..178af70331f8 100644
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
@@ -4312,10 +4307,8 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
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
@@ -4615,8 +4608,8 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	req->hdr.Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
-	req->PersistentFileId = cpu_to_le64(io_parms->persistent_fid);
-	req->VolatileFileId = cpu_to_le64(io_parms->volatile_fid);
+	req->PersistentFileId = io_parms->persistent_fid;
+	req->VolatileFileId = io_parms->volatile_fid;
 	req->WriteChannelInfoOffset = 0;
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
-- 
2.35.1

