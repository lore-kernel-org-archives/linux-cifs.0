Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F37C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5C6860C3E
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242624AbhIGI0p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 04:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242568AbhIGI0n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 04:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631003137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zODqJ5tGKYYP9eCJEHE32fPzkLQK99dsl3QPKag82NA=;
        b=aFNHX8wR/ZjvquqFd9HxAFOscMq1VLw6pyrS/mzqlT6P2z+wz/sDlyAPoJJBSbeD+LuTLv
        awfGaW4vzfP7vZagFcJCr1kGaQ2TnCk7FarcOSomvbkHjaAUhabLCCMKQ2mfW+Y701QftH
        FQycg2Q0iVXs1hHnBBS9lKciFH7yN84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-ZSSxKN0TNnWITyKfCCf2NA-1; Tue, 07 Sep 2021 04:25:35 -0400
X-MC-Unique: ZSSxKN0TNnWITyKfCCf2NA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 557E68145E5;
        Tue,  7 Sep 2021 08:25:34 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AE795D6A8;
        Tue,  7 Sep 2021 08:25:32 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/4] cifs: Move more definitions into the shared area
Date:   Tue,  7 Sep 2021 18:25:20 +1000
Message-Id: <20210907082523.2087981-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move SMB2_SessionSetup, SMB2_Close, SMB2_Read, SMB2_Write and
SMB2_ChangeNotify commands into cifs_common/smb2pdu.h

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c        |  60 +++++-----
 fs/cifs/smb2pdu.h        | 197 --------------------------------
 fs/cifs_common/smb2pdu.h | 241 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 274 insertions(+), 224 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 21e1c5bf6fc6..facbc0ebd355 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1261,7 +1261,7 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 		 * if reconnect, we need to send previous sess id
 		 * otherwise it is 0
 		 */
-		req->PreviousSessionId = sess_data->previous_session;
+		req->PreviousSessionId = cpu_to_le64(sess_data->previous_session);
 		req->Flags = 0; /* MBZ */
 	}
 
@@ -3236,8 +3236,8 @@ SMB2_close_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	if (rc)
 		return rc;
 
-	req->PersistentFileId = persistent_fid;
-	req->VolatileFileId = volatile_fid;
+	req->PersistentFileId = cpu_to_le64(persistent_fid);
+	req->VolatileFileId = cpu_to_le64(volatile_fid);
 	if (query_attrs)
 		req->Flags = SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB;
 	else
@@ -3823,8 +3823,8 @@ SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
 	if (rc)
 		return rc;
 
-	req->PersistentFileId = persistent_fid;
-	req->VolatileFileId = volatile_fid;
+	req->PersistentFileId = cpu_to_le64(persistent_fid);
+	req->VolatileFileId = cpu_to_le64(volatile_fid);
 
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
@@ -3890,7 +3890,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	unsigned int remaining_bytes, int request_type)
 {
 	int rc = -EACCES;
-	struct smb2_read_plain_req *req = NULL;
+	struct smb2_read_req *req = NULL;
 	struct smb2_hdr *shdr;
 	struct TCP_Server_Info *server = io_parms->server;
 
@@ -3905,8 +3905,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	shdr = &req->hdr;
 	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
-	req->PersistentFileId = io_parms->persistent_fid;
-	req->VolatileFileId = io_parms->volatile_fid;
+	req->PersistentFileId = cpu_to_le64(io_parms->persistent_fid);
+	req->VolatileFileId = cpu_to_le64(io_parms->volatile_fid);
 	req->ReadChannelInfoOffset = 0; /* reserved */
 	req->ReadChannelInfoLength = 0; /* reserved */
 	req->Channel = 0; /* reserved */
@@ -3940,7 +3940,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		if (need_invalidate)
 			req->Channel = SMB2_CHANNEL_RDMA_V1;
 		req->ReadChannelInfoOffset =
-			cpu_to_le16(offsetof(struct smb2_read_plain_req, Buffer));
+			cpu_to_le16(offsetof(struct smb2_read_req, Buffer));
 		req->ReadChannelInfoLength =
 			cpu_to_le16(sizeof(struct smbd_buffer_descriptor_v1));
 		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
@@ -3966,8 +3966,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 			 */
 			shdr->SessionId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
 			shdr->Id.SyncId.TreeId = cpu_to_le32(0xFFFFFFFF);
-			req->PersistentFileId = 0xFFFFFFFFFFFFFFFF;
-			req->VolatileFileId = 0xFFFFFFFFFFFFFFFF;
+			req->PersistentFileId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
+			req->VolatileFileId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
 		}
 	}
 	if (remaining_bytes > io_parms->length)
@@ -4144,7 +4144,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 {
 	struct smb_rqst rqst;
 	int resp_buftype, rc;
-	struct smb2_read_plain_req *req = NULL;
+	struct smb2_read_req *req = NULL;
 	struct smb2_read_rsp *rsp = NULL;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
@@ -4178,19 +4178,22 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		if (rc != -ENODATA) {
 			cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
 			cifs_dbg(VFS, "Send error in read = %d\n", rc);
-			trace_smb3_read_err(xid, req->PersistentFileId,
+			trace_smb3_read_err(xid,
+					    le64_to_cpu(req->PersistentFileId),
 					    io_parms->tcon->tid, ses->Suid,
 					    io_parms->offset, io_parms->length,
 					    rc);
 		} else
-			trace_smb3_read_done(xid, req->PersistentFileId,
-				    io_parms->tcon->tid, ses->Suid,
-				    io_parms->offset, 0);
+			trace_smb3_read_done(xid,
+					     le64_to_cpu(req->PersistentFileId),
+					     io_parms->tcon->tid, ses->Suid,
+					     io_parms->offset, 0);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 		cifs_small_buf_release(req);
 		return rc == -ENODATA ? 0 : rc;
 	} else
-		trace_smb3_read_done(xid, req->PersistentFileId,
+		trace_smb3_read_done(xid,
+				     le64_to_cpu(req->PersistentFileId),
 				    io_parms->tcon->tid, ses->Suid,
 				    io_parms->offset, io_parms->length);
 
@@ -4332,8 +4335,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	shdr = (struct smb2_hdr *)req;
 	shdr->Id.SyncId.ProcessId = cpu_to_le32(wdata->cfile->pid);
 
-	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
-	req->VolatileFileId = wdata->cfile->fid.volatile_fid;
+	req->PersistentFileId = cpu_to_le64(wdata->cfile->fid.persistent_fid);
+	req->VolatileFileId = cpu_to_le64(wdata->cfile->fid.volatile_fid);
 	req->WriteChannelInfoOffset = 0;
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
@@ -4430,7 +4433,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 			     wdata, flags, &wdata->credits);
 
 	if (rc) {
-		trace_smb3_write_err(0 /* no xid */, req->PersistentFileId,
+		trace_smb3_write_err(0 /* no xid */,
+				     le64_to_cpu(req->PersistentFileId),
 				     tcon->tid, tcon->ses->Suid, wdata->offset,
 				     wdata->bytes, rc);
 		kref_put(&wdata->refcount, release);
@@ -4483,8 +4487,8 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	req->hdr.Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
-	req->PersistentFileId = io_parms->persistent_fid;
-	req->VolatileFileId = io_parms->volatile_fid;
+	req->PersistentFileId = cpu_to_le64(io_parms->persistent_fid);
+	req->VolatileFileId = cpu_to_le64(io_parms->volatile_fid);
 	req->WriteChannelInfoOffset = 0;
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
@@ -4512,7 +4516,8 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
-		trace_smb3_write_err(xid, req->PersistentFileId,
+		trace_smb3_write_err(xid,
+				     le64_to_cpu(req->PersistentFileId),
 				     io_parms->tcon->tid,
 				     io_parms->tcon->ses->Suid,
 				     io_parms->offset, io_parms->length, rc);
@@ -4520,10 +4525,11 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 		cifs_dbg(VFS, "Send error in write = %d\n", rc);
 	} else {
 		*nbytes = le32_to_cpu(rsp->DataLength);
-		trace_smb3_write_done(xid, req->PersistentFileId,
-				     io_parms->tcon->tid,
-				     io_parms->tcon->ses->Suid,
-				     io_parms->offset, *nbytes);
+		trace_smb3_write_done(xid,
+				      le64_to_cpu(req->PersistentFileId),
+				      io_parms->tcon->tid,
+				      io_parms->tcon->ses->Suid,
+				      io_parms->offset, *nbytes);
 	}
 
 	cifs_small_buf_release(req);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 61060a0618b4..f5760346d9c5 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -116,48 +116,6 @@ struct share_redirect_error_context_rsp {
 	/* __u8 ResourceName[] */ /* Name of share as counted Unicode string */
 } __packed;
 
-/* Flags */
-#define SMB2_SESSION_REQ_FLAG_BINDING		0x01
-#define SMB2_SESSION_REQ_FLAG_ENCRYPT_DATA	0x04
-
-struct smb2_sess_setup_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* Must be 25 */
-	__u8   Flags;
-	__u8   SecurityMode;
-	__le32 Capabilities;
-	__le32 Channel;
-	__le16 SecurityBufferOffset;
-	__le16 SecurityBufferLength;
-	__u64 PreviousSessionId;
-	__u8   Buffer[1];	/* variable length GSS security buffer */
-} __packed;
-
-/* Currently defined SessionFlags */
-#define SMB2_SESSION_FLAG_IS_GUEST	0x0001
-#define SMB2_SESSION_FLAG_IS_NULL	0x0002
-#define SMB2_SESSION_FLAG_ENCRYPT_DATA	0x0004
-struct smb2_sess_setup_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* Must be 9 */
-	__le16 SessionFlags;
-	__le16 SecurityBufferOffset;
-	__le16 SecurityBufferLength;
-	__u8   Buffer[1];	/* variable length GSS security buffer */
-} __packed;
-
-struct smb2_logoff_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
-struct smb2_logoff_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
 /* File Attrubutes */
 #define FILE_ATTRIBUTE_READONLY			0x00000001
 #define FILE_ATTRIBUTE_HIDDEN			0x00000002
@@ -721,161 +679,6 @@ struct smb2_ioctl_rsp {
 	/* char * buffer[] */
 } __packed;
 
-/* Currently defined values for close flags */
-#define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
-struct smb2_close_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 24 */
-	__le16 Flags;
-	__le32 Reserved;
-	__u64  PersistentFileId; /* opaque endianness */
-	__u64  VolatileFileId; /* opaque endianness */
-} __packed;
-
-/*
- * Maximum size of a SMB2_CLOSE response is 64 (smb2 header) + 60 (data)
- */
-#define MAX_SMB2_CLOSE_RESPONSE_SIZE 124
-
-struct smb2_close_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* 60 */
-	__le16 Flags;
-	__le32 Reserved;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 AllocationSize;	/* Beginning of FILE_STANDARD_INFO equivalent */
-	__le64 EndOfFile;
-	__le32 Attributes;
-} __packed;
-
-struct smb2_flush_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 24 */
-	__le16 Reserved1;
-	__le32 Reserved2;
-	__u64  PersistentFileId; /* opaque endianness */
-	__u64  VolatileFileId; /* opaque endianness */
-} __packed;
-
-struct smb2_flush_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;
-	__le16 Reserved;
-} __packed;
-
-/* For read request Flags field below, following flag is defined for SMB3.02 */
-#define SMB2_READFLAG_READ_UNBUFFERED	0x01
-#define SMB2_READFLAG_REQUEST_COMPRESSED 0x02 /* See MS-SMB2 2.2.19 */
-
-/* Channel field for read and write: exactly one of following flags can be set*/
-#define SMB2_CHANNEL_NONE	cpu_to_le32(0x00000000)
-#define SMB2_CHANNEL_RDMA_V1	cpu_to_le32(0x00000001) /* SMB3 or later */
-#define SMB2_CHANNEL_RDMA_V1_INVALIDATE cpu_to_le32(0x00000002) /* >= SMB3.02 */
-#define SMB2_CHANNEL_RDMA_TRANSFORM cpu_to_le32(0x00000003) /* >= SMB3.02, only used on write */
-
-/* SMB2 read request without RFC1001 length at the beginning */
-struct smb2_read_plain_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* Must be 49 */
-	__u8   Padding; /* offset from start of SMB2 header to place read */
-	__u8   Flags; /* MBZ unless SMB3.02 or later */
-	__le32 Length;
-	__le64 Offset;
-	__u64  PersistentFileId; /* opaque endianness */
-	__u64  VolatileFileId; /* opaque endianness */
-	__le32 MinimumCount;
-	__le32 Channel; /* MBZ except for SMB3 or later */
-	__le32 RemainingBytes;
-	__le16 ReadChannelInfoOffset;
-	__le16 ReadChannelInfoLength;
-	__u8   Buffer[1];
-} __packed;
-
-/* Read flags */
-#define SMB2_READFLAG_RESPONSE_NONE	0x00000000
-#define SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM	0x00000001
-
-struct smb2_read_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* Must be 17 */
-	__u8   DataOffset;
-	__u8   Reserved;
-	__le32 DataLength;
-	__le32 DataRemaining;
-	__u32  Flags;
-	__u8   Buffer[1];
-} __packed;
-
-/* For write request Flags field below the following flags are defined: */
-#define SMB2_WRITEFLAG_WRITE_THROUGH	0x00000001	/* SMB2.1 or later */
-#define SMB2_WRITEFLAG_WRITE_UNBUFFERED	0x00000002	/* SMB3.02 or later */
-
-struct smb2_write_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* Must be 49 */
-	__le16 DataOffset; /* offset from start of SMB2 header to write data */
-	__le32 Length;
-	__le64 Offset;
-	__u64  PersistentFileId; /* opaque endianness */
-	__u64  VolatileFileId; /* opaque endianness */
-	__le32 Channel; /* MBZ unless SMB3.02 or later */
-	__le32 RemainingBytes;
-	__le16 WriteChannelInfoOffset;
-	__le16 WriteChannelInfoLength;
-	__le32 Flags;
-	__u8   Buffer[1];
-} __packed;
-
-struct smb2_write_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize; /* Must be 17 */
-	__u8   DataOffset;
-	__u8   Reserved;
-	__le32 DataLength;
-	__le32 DataRemaining;
-	__u32  Reserved2;
-	__u8   Buffer[1];
-} __packed;
-
-/* notify flags */
-#define SMB2_WATCH_TREE			0x0001
-
-/* notify completion filter flags. See MS-FSCC 2.6 and MS-SMB2 2.2.35 */
-#define FILE_NOTIFY_CHANGE_FILE_NAME		0x00000001
-#define FILE_NOTIFY_CHANGE_DIR_NAME		0x00000002
-#define FILE_NOTIFY_CHANGE_ATTRIBUTES		0x00000004
-#define FILE_NOTIFY_CHANGE_SIZE			0x00000008
-#define FILE_NOTIFY_CHANGE_LAST_WRITE		0x00000010
-#define FILE_NOTIFY_CHANGE_LAST_ACCESS		0x00000020
-#define FILE_NOTIFY_CHANGE_CREATION		0x00000040
-#define FILE_NOTIFY_CHANGE_EA			0x00000080
-#define FILE_NOTIFY_CHANGE_SECURITY		0x00000100
-#define FILE_NOTIFY_CHANGE_STREAM_NAME		0x00000200
-#define FILE_NOTIFY_CHANGE_STREAM_SIZE		0x00000400
-#define FILE_NOTIFY_CHANGE_STREAM_WRITE		0x00000800
-
-struct smb2_change_notify_req {
-	struct smb2_hdr hdr;
-	__le16	StructureSize;
-	__le16	Flags;
-	__le32	OutputBufferLength;
-	__u64	PersistentFileId; /* opaque endianness */
-	__u64	VolatileFileId; /* opaque endianness */
-	__le32	CompletionFilter;
-	__u32	Reserved;
-} __packed;
-
-struct smb2_change_notify_rsp {
-	struct smb2_hdr hdr;
-	__le16	StructureSize;  /* Must be 9 */
-	__le16	OutputBufferOffset;
-	__le32	OutputBufferLength;
-	__u8	Buffer[1]; /* array of file notify structs */
-} __packed;
-
 #define SMB2_LOCKFLAG_SHARED_LOCK	0x0001
 #define SMB2_LOCKFLAG_EXCLUSIVE_LOCK	0x0002
 #define SMB2_LOCKFLAG_UNLOCK		0x0004
diff --git a/fs/cifs_common/smb2pdu.h b/fs/cifs_common/smb2pdu.h
index a1f661a1b89d..0d9c3ebdb773 100644
--- a/fs/cifs_common/smb2pdu.h
+++ b/fs/cifs_common/smb2pdu.h
@@ -544,4 +544,245 @@ struct smb2_negotiate_rsp {
 } __packed;
 
 
+/*
+ * SMB2_SESSION_SETUP  See MS-SMB2 section 2.2.5
+ */
+/* Flags */
+#define SMB2_SESSION_REQ_FLAG_BINDING		0x01
+#define SMB2_SESSION_REQ_FLAG_ENCRYPT_DATA	0x04
+
+struct smb2_sess_setup_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 25 */
+	__u8   Flags;
+	__u8   SecurityMode;
+	__le32 Capabilities;
+	__le32 Channel;
+	__le16 SecurityBufferOffset;
+	__le16 SecurityBufferLength;
+	__le64 PreviousSessionId;
+	__u8   Buffer[1];	/* variable length GSS security buffer */
+} __packed;
+
+/* Currently defined SessionFlags */
+#define SMB2_SESSION_FLAG_IS_GUEST        0x0001
+#define SMB2_SESSION_FLAG_IS_GUEST_LE     cpu_to_le16(0x0001)
+#define SMB2_SESSION_FLAG_IS_NULL         0x0002
+#define SMB2_SESSION_FLAG_IS_NULL_LE      cpu_to_le16(0x0002)
+#define SMB2_SESSION_FLAG_ENCRYPT_DATA    0x0004
+#define SMB2_SESSION_FLAG_ENCRYPT_DATA_LE cpu_to_le16(0x0004)
+
+struct smb2_sess_setup_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 9 */
+	__le16 SessionFlags;
+	__le16 SecurityBufferOffset;
+	__le16 SecurityBufferLength;
+	__u8   Buffer[1];	/* variable length GSS security buffer */
+} __packed;
+
+
+/*
+ * SMB2_LOGOFF  See MS-SMB2 section 2.2.7
+ */
+struct smb2_logoff_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+struct smb2_logoff_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+
+/*
+ * SMB2_CLOSE  See MS-SMB2 section 2.2.15
+ */
+/* Currently defined values for close flags */
+#define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
+struct smb2_close_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 24 */
+	__le16 Flags;
+	__le32 Reserved;
+	__le64  PersistentFileId; /* opaque endianness */
+	__le64  VolatileFileId; /* opaque endianness */
+} __packed;
+
+/*
+ * Maximum size of a SMB2_CLOSE response is 64 (smb2 header) + 60 (data)
+ */
+#define MAX_SMB2_CLOSE_RESPONSE_SIZE 124
+
+struct smb2_close_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* 60 */
+	__le16 Flags;
+	__le32 Reserved;
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 AllocationSize;	/* Beginning of FILE_STANDARD_INFO equivalent */
+	__le64 EndOfFile;
+	__le32 Attributes;
+} __packed;
+
+
+/*
+ * SMB2_READ  See MS-SMB2 section 2.2.19
+ */
+/* For read request Flags field below, following flag is defined for SMB3.02 */
+#define SMB2_READFLAG_READ_UNBUFFERED	0x01
+#define SMB2_READFLAG_REQUEST_COMPRESSED 0x02 /* See MS-SMB2 2.2.19 */
+
+/* Channel field for read and write: exactly one of following flags can be set*/
+#define SMB2_CHANNEL_NONE               cpu_to_le32(0x00000000)
+#define SMB2_CHANNEL_RDMA_V1            cpu_to_le32(0x00000001)
+#define SMB2_CHANNEL_RDMA_V1_INVALIDATE cpu_to_le32(0x00000002)
+#define SMB2_CHANNEL_RDMA_TRANSFORM     cpu_to_le32(0x00000003)
+
+/* SMB2 read request without RFC1001 length at the beginning */
+struct smb2_read_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 49 */
+	__u8   Padding; /* offset from start of SMB2 header to place read */
+	__u8   Flags; /* MBZ unless SMB3.02 or later */
+	__le32 Length;
+	__le64 Offset;
+	__le64  PersistentFileId;
+	__le64  VolatileFileId;
+	__le32 MinimumCount;
+	__le32 Channel; /* MBZ except for SMB3 or later */
+	__le32 RemainingBytes;
+	__le16 ReadChannelInfoOffset;
+	__le16 ReadChannelInfoLength;
+	__u8   Buffer[1];
+} __packed;
+
+/* Read flags */
+#define SMB2_READFLAG_RESPONSE_NONE            cpu_to_le32(0x00000000)
+#define SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM  cpu_to_le32(0x00000001)
+
+struct smb2_read_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 17 */
+	__u8   DataOffset;
+	__u8   Reserved;
+	__le32 DataLength;
+	__le32 DataRemaining;
+	__le32 Flags;
+	__u8   Buffer[1];
+} __packed;
+
+
+/*
+ * SMB2_WRITE  See MS-SMB2 section 2.2.21
+ */
+/* For write request Flags field below the following flags are defined: */
+#define SMB2_WRITEFLAG_WRITE_THROUGH	0x00000001	/* SMB2.1 or later */
+#define SMB2_WRITEFLAG_WRITE_UNBUFFERED	0x00000002	/* SMB3.02 or later */
+
+struct smb2_write_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 49 */
+	__le16 DataOffset; /* offset from start of SMB2 header to write data */
+	__le32 Length;
+	__le64 Offset;
+	__le64  PersistentFileId; /* opaque endianness */
+	__le64  VolatileFileId; /* opaque endianness */
+	__le32 Channel; /* MBZ unless SMB3.02 or later */
+	__le32 RemainingBytes;
+	__le16 WriteChannelInfoOffset;
+	__le16 WriteChannelInfoLength;
+	__le32 Flags;
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_write_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 17 */
+	__u8   DataOffset;
+	__u8   Reserved;
+	__le32 DataLength;
+	__le32 DataRemaining;
+	__u32  Reserved2;
+	__u8   Buffer[1];
+} __packed;
+
+
+/*
+ * SMB2_FLUSH  See MS-SMB2 section 2.2.17
+ */
+struct smb2_flush_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 24 */
+	__le16 Reserved1;
+	__le32 Reserved2;
+	__le64  PersistentFileId;
+	__le64  VolatileFileId;
+} __packed;
+
+struct smb2_flush_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;
+	__le16 Reserved;
+} __packed;
+
+
+/*
+ * SMB2_NOTIFY  See MS-SMB2 section 2.2.35
+ */
+/* notify flags */
+#define SMB2_WATCH_TREE			0x0001
+
+/* notify completion filter flags. See MS-FSCC 2.6 and MS-SMB2 2.2.35 */
+#define FILE_NOTIFY_CHANGE_FILE_NAME		0x00000001
+#define FILE_NOTIFY_CHANGE_DIR_NAME		0x00000002
+#define FILE_NOTIFY_CHANGE_ATTRIBUTES		0x00000004
+#define FILE_NOTIFY_CHANGE_SIZE			0x00000008
+#define FILE_NOTIFY_CHANGE_LAST_WRITE		0x00000010
+#define FILE_NOTIFY_CHANGE_LAST_ACCESS		0x00000020
+#define FILE_NOTIFY_CHANGE_CREATION		0x00000040
+#define FILE_NOTIFY_CHANGE_EA			0x00000080
+#define FILE_NOTIFY_CHANGE_SECURITY		0x00000100
+#define FILE_NOTIFY_CHANGE_STREAM_NAME		0x00000200
+#define FILE_NOTIFY_CHANGE_STREAM_SIZE		0x00000400
+#define FILE_NOTIFY_CHANGE_STREAM_WRITE		0x00000800
+
+/* SMB2 Notify Action Flags */
+#define FILE_ACTION_ADDED                       0x00000001
+#define FILE_ACTION_REMOVED                     0x00000002
+#define FILE_ACTION_MODIFIED                    0x00000003
+#define FILE_ACTION_RENAMED_OLD_NAME            0x00000004
+#define FILE_ACTION_RENAMED_NEW_NAME            0x00000005
+#define FILE_ACTION_ADDED_STREAM                0x00000006
+#define FILE_ACTION_REMOVED_STREAM              0x00000007
+#define FILE_ACTION_MODIFIED_STREAM             0x00000008
+#define FILE_ACTION_REMOVED_BY_DELETE           0x00000009
+
+struct smb2_change_notify_req {
+	struct smb2_hdr hdr;
+	__le16	StructureSize;
+	__le16	Flags;
+	__le32	OutputBufferLength;
+	__le64	PersistentFileId; /* opaque endianness */
+	__le64	VolatileFileId; /* opaque endianness */
+	__le32	CompletionFilter;
+	__u32	Reserved;
+} __packed;
+
+struct smb2_change_notify_rsp {
+	struct smb2_hdr hdr;
+	__le16	StructureSize;  /* Must be 9 */
+	__le16	OutputBufferOffset;
+	__le32	OutputBufferLength;
+	__u8	Buffer[1]; /* array of file notify structs */
+} __packed;
+
+
+
 #endif				/* _COMMON_SMB2PDU_H */
-- 
2.30.2

