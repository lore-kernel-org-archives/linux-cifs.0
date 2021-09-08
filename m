Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48726C433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 06:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC5861154
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 06:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345785AbhIHGri (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Sep 2021 02:47:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346850AbhIHGrh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Sep 2021 02:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631083582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CelyefxjFGhSt3iG2VsD5q3yUtQZFZaAcePJ4ZFen1I=;
        b=MWl+jo85pHz4rEZvuW8f9+ZDBtTEWKN9rhAXoFv1/fj0GjChMWJ6GL/HgJRm/V9D6R4ask
        CrvV+3Y0XjEGIIZBBZvi9R3H8+EsHZZs4eKxNidgStB2t4m2MqB6PeCkQ5DsnRX//CXNaP
        N/ye6d89qS3uVRDXy8JVpBDH9lL7lG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-0vsD7sY-O7eeuHFByNQ74g-1; Wed, 08 Sep 2021 02:46:21 -0400
X-MC-Unique: 0vsD7sY-O7eeuHFByNQ74g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78366501E0;
        Wed,  8 Sep 2021 06:46:20 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E383C100E107;
        Wed,  8 Sep 2021 06:46:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/2] cifs: move IOCTL and structures to the common area
Date:   Wed,  8 Sep 2021 16:46:12 +1000
Message-Id: <20210908064612.2121998-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rendame structures and fields for SMB2 IOCTL to match MS-FSCC and MS-SMB2 and
move the definitions to the common area.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifspdu.h        |   8 --
 fs/cifs/smb2ops.c        |  81 ++++++-------
 fs/cifs/smb2pdu.c        |   4 +-
 fs/cifs/smb2pdu.h        | 239 ---------------------------------------
 fs/cifs_common/smb2pdu.h | 214 +++++++++++++++++++++++++++++++++++
 5 files changed, 258 insertions(+), 288 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index dc920e206336..caa97357e949 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1294,14 +1294,6 @@ typedef struct smb_com_ntransact_rsp {
 	/* parms and data follow */
 } __attribute__((packed)) NTRANSACT_RSP;
 
-/* See MS-SMB 2.2.7.2.1.1 */
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 DestinationOffset;
-	__le32 CopyLength;
-	__u32  Reserved;
-} __packed;
-
 typedef struct smb_com_transaction_ioctl_req {
 	struct smb_hdr hdr;	/* wct = 23 */
 	__u8 MaxSetupCount;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e71043f87439..3a30b76f2f78 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1558,11 +1558,11 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 static int
 SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid,
-		     struct copychunk_ioctl *pcchunk)
+		     struct srv_copychunk_copy *pcchunk)
 {
 	int rc;
 	unsigned int ret_data_len;
-	struct resume_key_req *res_key;
+	struct resume_key_rsp *res_key;
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
 			FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
@@ -1576,7 +1576,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
 		goto req_res_key_exit;
 	}
-	if (ret_data_len < sizeof(struct resume_key_req)) {
+	if (ret_data_len < sizeof(struct resume_key_rsp)) {
 		cifs_tcon_dbg(VFS, "Invalid refcopy resume key length\n");
 		rc = -EINVAL;
 		goto req_res_key_exit;
@@ -1827,14 +1827,17 @@ smb2_copychunk_range(const unsigned int xid,
 {
 	int rc;
 	unsigned int ret_data_len;
-	struct copychunk_ioctl *pcchunk;
-	struct copychunk_ioctl_rsp *retbuf = NULL;
+	struct srv_copychunk_copy *pcchunk;
+	struct srv_copychunk_response *retbuf = NULL;
 	struct cifs_tcon *tcon;
 	int chunks_copied = 0;
 	bool chunk_sizes_updated = false;
 	ssize_t bytes_written, total_bytes_written = 0;
+	int chunk_size;
 
-	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
+	chunk_size = sizeof(struct srv_copychunk_copy) + sizeof(struct srv_copychunk);
+	
+	pcchunk = kmalloc(chunk_size, GFP_KERNEL);
 
 	if (pcchunk == NULL)
 		return -ENOMEM;
@@ -1852,14 +1855,14 @@ smb2_copychunk_range(const unsigned int xid,
 	/* For now array only one chunk long, will make more flexible later */
 	pcchunk->ChunkCount = cpu_to_le32(1);
 	pcchunk->Reserved = 0;
-	pcchunk->Reserved2 = 0;
+	pcchunk->Chunks[0].Reserved = 0;
 
 	tcon = tlink_tcon(trgtfile->tlink);
 
 	while (len > 0) {
-		pcchunk->SourceOffset = cpu_to_le64(src_off);
-		pcchunk->TargetOffset = cpu_to_le64(dest_off);
-		pcchunk->Length =
+		pcchunk->Chunks[0].SourceOffset = cpu_to_le64(src_off);
+		pcchunk->Chunks[0].TargetOffset = cpu_to_le64(dest_off);
+		pcchunk->Chunks[0].Length =
 			cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
 
 		/* Request server copy to target from src identified by key */
@@ -1868,11 +1871,11 @@ smb2_copychunk_range(const unsigned int xid,
 		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
 			true /* is_fsctl */, (char *)pcchunk,
-			sizeof(struct copychunk_ioctl),	CIFSMaxBufSize,
+			chunk_size, CIFSMaxBufSize,
 			(char **)&retbuf, &ret_data_len);
 		if (rc == 0) {
 			if (ret_data_len !=
-					sizeof(struct copychunk_ioctl_rsp)) {
+					sizeof(struct srv_copychunk_response)) {
 				cifs_tcon_dbg(VFS, "Invalid cchunk response size\n");
 				rc = -EIO;
 				goto cchunk_out;
@@ -1886,7 +1889,7 @@ smb2_copychunk_range(const unsigned int xid,
 			 * Check if server claimed to write more than we asked
 			 */
 			if (le32_to_cpu(retbuf->TotalBytesWritten) >
-			    le32_to_cpu(pcchunk->Length)) {
+			    le32_to_cpu(pcchunk->Chunks[0].Length)) {
 				cifs_tcon_dbg(VFS, "Invalid copy chunk response\n");
 				rc = -EIO;
 				goto cchunk_out;
@@ -1909,7 +1912,7 @@ smb2_copychunk_range(const unsigned int xid,
 				le32_to_cpu(retbuf->ChunkBytesWritten),
 				bytes_written);
 		} else if (rc == -EINVAL) {
-			if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
+			if (ret_data_len != sizeof(struct srv_copychunk_response))
 				goto cchunk_out;
 
 			cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy %d\n",
@@ -2086,8 +2089,8 @@ smb2_duplicate_extents(const unsigned int xid,
 	     FILE_SUPPORTS_BLOCK_REFCOUNTING) == 0)
 		return -EOPNOTSUPP;
 
-	dup_ext_buf.VolatileFileHandle = srcfile->fid.volatile_fid;
-	dup_ext_buf.PersistentFileHandle = srcfile->fid.persistent_fid;
+	dup_ext_buf.VolatileFileHandle = cpu_to_le64(srcfile->fid.volatile_fid);
+	dup_ext_buf.PersistentFileHandle = cpu_to_le64(srcfile->fid.persistent_fid);
 	dup_ext_buf.SourceFileOffset = cpu_to_le64(src_off);
 	dup_ext_buf.TargetFileOffset = cpu_to_le64(dest_off);
 	dup_ext_buf.ByteCount = cpu_to_le64(len);
@@ -2137,7 +2140,7 @@ static int
 smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile)
 {
-	struct fsctl_set_integrity_information_req integr_info;
+	struct fsctl_set_integrity_information integr_info;
 	unsigned int ret_data_len;
 
 	integr_info.ChecksumAlgorithm = cpu_to_le16(CHECKSUM_TYPE_UNCHANGED);
@@ -2149,7 +2152,7 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
 			FSCTL_SET_INTEGRITY_INFORMATION,
 			true /* is_fsctl */,
 			(char *)&integr_info,
-			sizeof(struct fsctl_set_integrity_information_req),
+			sizeof(struct fsctl_set_integrity_information),
 			CIFSMaxBufSize, NULL,
 			&ret_data_len);
 
@@ -3507,7 +3510,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode;
 	struct cifsInodeInfo *cifsi;
 	struct cifsFileInfo *cfile = file->private_data;
-	struct file_zero_data_information fsctl_buf;
+	struct fsctl_set_zero_data fsctl_buf;
 	long rc;
 	unsigned int xid;
 	__le64 eof;
@@ -3544,7 +3547,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
 			(char *)&fsctl_buf,
-			sizeof(struct file_zero_data_information),
+			sizeof(struct fsctl_set_zero_data),
 			0, NULL, NULL);
 	if (rc)
 		goto zero_range_exit;
@@ -3574,7 +3577,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 {
 	struct inode *inode;
 	struct cifsFileInfo *cfile = file->private_data;
-	struct file_zero_data_information fsctl_buf;
+	struct fsctl_set_zero_data fsctl_buf;
 	long rc;
 	unsigned int xid;
 	__u8 set_sparse = 1;
@@ -3606,7 +3609,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
 			true /* is_fctl */, (char *)&fsctl_buf,
-			sizeof(struct file_zero_data_information),
+			sizeof(struct fsctl_set_zero_data),
 			CIFSMaxBufSize, NULL, NULL);
 	free_xid(xid);
 	filemap_invalidate_unlock(inode->i_mapping);
@@ -3661,8 +3664,8 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	loff_t l;
 	int rc;
 
-	in_data.file_offset = cpu_to_le64(off);
-	in_data.length = cpu_to_le64(len);
+	in_data.FileOffset = cpu_to_le64(off);
+	in_data.Length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
 			FSCTL_QUERY_ALLOCATED_RANGES, true,
@@ -3694,13 +3697,13 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			goto out;
 		}
 
-		if (off < le64_to_cpu(tmp_data->file_offset)) {
+		if (off < le64_to_cpu(tmp_data->FileOffset)) {
 			/*
 			 * We are at a hole. Write until the end of the region
 			 * or until the next allocated data,
 			 * whichever comes next.
 			 */
-			l = le64_to_cpu(tmp_data->file_offset) - off;
+			l = le64_to_cpu(tmp_data->FileOffset) - off;
 			if (len < l)
 				l = len;
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
@@ -3717,7 +3720,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		 * until the end of the data or the end of the region
 		 * we are supposed to fallocate, whichever comes first.
 		 */
-		l = le64_to_cpu(tmp_data->length);
+		l = le64_to_cpu(tmp_data->Length);
 		if (len < l)
 			l = len;
 		off += l;
@@ -3972,8 +3975,8 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
 		goto lseek_exit;
 	}
 
-	in_data.file_offset = cpu_to_le64(offset);
-	in_data.length = cpu_to_le64(i_size_read(inode));
+	in_data.FileOffset = cpu_to_le64(offset);
+	in_data.Length = cpu_to_le64(i_size_read(inode));
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
@@ -3999,13 +4002,13 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
 		goto lseek_exit;
 	}
 	if (whence == SEEK_DATA) {
-		offset = le64_to_cpu(out_data->file_offset);
+		offset = le64_to_cpu(out_data->FileOffset);
 		goto lseek_exit;
 	}
-	if (offset < le64_to_cpu(out_data->file_offset))
+	if (offset < le64_to_cpu(out_data->FileOffset))
 		goto lseek_exit;
 
-	offset = le64_to_cpu(out_data->file_offset) + le64_to_cpu(out_data->length);
+	offset = le64_to_cpu(out_data->FileOffset) + le64_to_cpu(out_data->Length);
 
  lseek_exit:
 	free_xid(xid);
@@ -4032,8 +4035,8 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 
 	xid = get_xid();
  again:
-	in_data.file_offset = cpu_to_le64(start);
-	in_data.length = cpu_to_le64(len);
+	in_data.FileOffset = cpu_to_le64(start);
+	in_data.Length = cpu_to_le64(len);
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
@@ -4065,9 +4068,9 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 			flags |= FIEMAP_EXTENT_LAST;
 
 		rc = fiemap_fill_next_extent(fei,
-				le64_to_cpu(out_data[i].file_offset),
-				le64_to_cpu(out_data[i].file_offset),
-				le64_to_cpu(out_data[i].length),
+				le64_to_cpu(out_data[i].FileOffset),
+				le64_to_cpu(out_data[i].FileOffset),
+				le64_to_cpu(out_data[i].Length),
 				flags);
 		if (rc < 0)
 			goto out;
@@ -4078,8 +4081,8 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 	}
 
 	if (!last_blob) {
-		next = le64_to_cpu(out_data[num - 1].file_offset) +
-		  le64_to_cpu(out_data[num - 1].length);
+		next = le64_to_cpu(out_data[num - 1].FileOffset) +
+		  le64_to_cpu(out_data[num - 1].Length);
 		len = len - (next - start);
 		start = next;
 		goto again;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6b491f04b450..8aed32f433e0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3010,8 +3010,8 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	}
 
 	req->CtlCode = cpu_to_le32(opcode);
-	req->PersistentFileId = persistent_fid;
-	req->VolatileFileId = volatile_fid;
+	req->PersistentFileId = cpu_to_le64(persistent_fid);
+	req->VolatileFileId = cpu_to_le64(volatile_fid);
 
 	iov[0].iov_base = (char *)req;
 	/*
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index d06676daaa7d..e273455605ff 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -268,211 +268,6 @@ struct crt_sd_ctxt {
 	struct smb3_sd sd;
 } __packed;
 
-
-#define COPY_CHUNK_RES_KEY_SIZE	24
-struct resume_key_req {
-	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32	ContextLength;	/* MBZ */
-	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
-} __packed;
-
-/* this goes in the ioctl buffer when doing a copychunk request */
-struct copychunk_ioctl {
-	char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32 ChunkCount; /* we are only sending 1 */
-	__le32 Reserved;
-	/* array will only be one chunk long for us */
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length; /* how many bytes to copy */
-	__u32 Reserved2;
-} __packed;
-
-/* this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA */
-struct file_zero_data_information {
-	__le64	FileOffset;
-	__le64	BeyondFinalZero;
-} __packed;
-
-struct copychunk_ioctl_rsp {
-	__le32 ChunksWritten;
-	__le32 ChunkBytesWritten;
-	__le32 TotalBytesWritten;
-} __packed;
-
-/* See MS-FSCC 2.3.29 and 2.3.30 */
-struct get_retrieval_pointer_count_req {
-	__le64 StartingVcn; /* virtual cluster number (signed) */
-} __packed;
-
-struct get_retrieval_pointer_count_rsp {
-	__le32 ExtentCount;
-} __packed;
-
-/*
- * See MS-FSCC 2.3.33 and 2.3.34
- * request is the same as get_retrieval_point_count_req struct above
- */
-struct smb3_extents {
-	__le64 NextVcn;
-	__le64 Lcn; /* logical cluster number */
-} __packed;
-
-struct get_retrieval_pointers_refcount_rsp {
-	__le32 ExtentCount;
-	__u32  Reserved;
-	__le64 StartingVcn;
-	struct smb3_extents extents[];
-} __packed;
-
-struct fsctl_set_integrity_information_req {
-	__le16	ChecksumAlgorithm;
-	__le16	Reserved;
-	__le32	Flags;
-} __packed;
-
-struct fsctl_get_integrity_information_rsp {
-	__le16	ChecksumAlgorithm;
-	__le16	Reserved;
-	__le32	Flags;
-	__le32	ChecksumChunkSizeInBytes;
-	__le32	ClusterSizeInBytes;
-} __packed;
-
-struct file_allocated_range_buffer {
-	__le64	file_offset;
-	__le64	length;
-} __packed;
-
-/* Integrity ChecksumAlgorithm choices for above */
-#define	CHECKSUM_TYPE_NONE	0x0000
-#define	CHECKSUM_TYPE_CRC64	0x0002
-#define CHECKSUM_TYPE_UNCHANGED	0xFFFF	/* set only */
-
-/* Integrity flags for above */
-#define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF	0x00000001
-
-/* Reparse structures - see MS-FSCC 2.1.2 */
-
-/* struct fsctl_reparse_info_req is empty, only response structs (see below) */
-
-struct reparse_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__u8	DataBuffer[]; /* Variable Length */
-} __packed;
-
-struct reparse_guid_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__u8	ReparseGuid[16];
-	__u8	DataBuffer[]; /* Variable Length */
-} __packed;
-
-struct reparse_mount_point_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le16	SubstituteNameOffset;
-	__le16	SubstituteNameLength;
-	__le16	PrintNameOffset;
-	__le16	PrintNameLength;
-	__u8	PathBuffer[]; /* Variable Length */
-} __packed;
-
-#define SYMLINK_FLAG_RELATIVE 0x00000001
-
-struct reparse_symlink_data_buffer {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le16	SubstituteNameOffset;
-	__le16	SubstituteNameLength;
-	__le16	PrintNameOffset;
-	__le16	PrintNameLength;
-	__le32	Flags;
-	__u8	PathBuffer[]; /* Variable Length */
-} __packed;
-
-/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
-
-
-/* See MS-DFSC 2.2.2 */
-struct fsctl_get_dfs_referral_req {
-	__le16 MaxReferralLevel;
-	__u8 RequestFileName[];
-} __packed;
-
-/* DFS response is struct get_dfs_refer_rsp */
-
-/* See MS-SMB2 2.2.31.3 */
-struct network_resiliency_req {
-	__le32 Timeout;
-	__le32 Reserved;
-} __packed;
-/* There is no buffer for the response ie no struct network_resiliency_rsp */
-
-
-struct validate_negotiate_info_req {
-	__le32 Capabilities;
-	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
-	__le16 SecurityMode;
-	__le16 DialectCount;
-	__le16 Dialects[4]; /* BB expand this if autonegotiate > 4 dialects */
-} __packed;
-
-struct validate_negotiate_info_rsp {
-	__le32 Capabilities;
-	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
-	__le16 SecurityMode;
-	__le16 Dialect; /* Dialect in use for the connection */
-} __packed;
-
-#define RSS_CAPABLE	cpu_to_le32(0x00000001)
-#define RDMA_CAPABLE	cpu_to_le32(0x00000002)
-
-#define INTERNETWORK	cpu_to_le16(0x0002)
-#define INTERNETWORKV6	cpu_to_le16(0x0017)
-
-struct network_interface_info_ioctl_rsp {
-	__le32 Next; /* next interface. zero if this is last one */
-	__le32 IfIndex;
-	__le32 Capability; /* RSS or RDMA Capable */
-	__le32 Reserved;
-	__le64 LinkSpeed;
-	__le16 Family;
-	__u8 Buffer[126];
-} __packed;
-
-struct iface_info_ipv4 {
-	__be16 Port;
-	__be32 IPv4Address;
-	__be64 Reserved;
-} __packed;
-
-struct iface_info_ipv6 {
-	__be16 Port;
-	__be32 FlowInfo;
-	__u8   IPv6Address[16];
-	__be32 ScopeId;
-} __packed;
-
-#define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not to file */
-
-struct compress_ioctl {
-	__le16 CompressionState; /* See cifspdu.h for possible flag values */
-} __packed;
-
-struct duplicate_extents_to_file {
-	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
-	__u64 VolatileFileHandle;
-	__le64 SourceFileOffset;
-	__le64 TargetFileOffset;
-	__le64 ByteCount;  /* Bytes to be copied */
-} __packed;
-
 /*
  * Maximum number of iovs we need for an ioctl request.
  * [0] : struct smb2_ioctl_req
@@ -480,40 +275,6 @@ struct duplicate_extents_to_file {
  */
 #define SMB2_IOCTL_IOV_SIZE 2
 
-struct smb2_ioctl_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 57 */
-	__u16 Reserved;
-	__le32 CtlCode;
-	__u64  PersistentFileId; /* opaque endianness */
-	__u64  VolatileFileId; /* opaque endianness */
-	__le32 InputOffset;
-	__le32 InputCount;
-	__le32 MaxInputResponse;
-	__le32 OutputOffset;
-	__le32 OutputCount;
-	__le32 MaxOutputResponse;
-	__le32 Flags;
-	__u32  Reserved2;
-	__u8   Buffer[];
-} __packed;
-
-struct smb2_ioctl_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 57 */
-	__u16 Reserved;
-	__le32 CtlCode;
-	__u64  PersistentFileId; /* opaque endianness */
-	__u64  VolatileFileId; /* opaque endianness */
-	__le32 InputOffset;
-	__le32 InputCount;
-	__le32 OutputOffset;
-	__le32 OutputCount;
-	__le32 Flags;
-	__u32  Reserved2;
-	/* char * buffer[] */
-} __packed;
-
 #define SMB2_LOCKFLAG_SHARED_LOCK	0x0001
 #define SMB2_LOCKFLAG_EXCLUSIVE_LOCK	0x0002
 #define SMB2_LOCKFLAG_UNLOCK		0x0004
diff --git a/fs/cifs_common/smb2pdu.h b/fs/cifs_common/smb2pdu.h
index 7ccadcbe684b..cef46a6213fb 100644
--- a/fs/cifs_common/smb2pdu.h
+++ b/fs/cifs_common/smb2pdu.h
@@ -985,5 +985,219 @@ struct smb2_create_rsp {
 	__u8   Buffer[1];
 } __packed;
 
+/*
+ * SMB2_IOCTL  See MS-SMB2 section 2.2.31
+ */
+
+struct duplicate_extents_to_file {
+	__le64 PersistentFileHandle;
+	__le64 VolatileFileHandle;
+	__le64 SourceFileOffset;
+	__le64 TargetFileOffset;
+	__le64 ByteCount;  /* Bytes to be copied */
+} __packed;
+
+struct validate_negotiate_info_req {
+	__le32 Capabilities;
+	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
+	__le16 SecurityMode;
+	__le16 DialectCount;
+	__le16 Dialects[];
+} __packed;
+
+struct validate_negotiate_info_rsp {
+	__le32 Capabilities;
+	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
+	__le16 SecurityMode;
+	__le16 Dialect;
+} __packed;
+
+#define COPY_CHUNK_RES_KEY_SIZE	24
+
+struct resume_key_rsp {
+	__u8   ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
+	__le32 ContextLength;	/* MBZ */
+	__u8   Context[4];	/* ignored, Windows sets to 4 bytes of zero */
+} __packed;
+
+struct srv_copychunk {
+	__le64 SourceOffset;
+	__le64 TargetOffset;
+	__le32 Length;
+	__le32 Reserved;
+} __packed;
+
+struct srv_copychunk_copy {
+	char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
+	__le32 ChunkCount;
+	__le32 Reserved;
+	struct srv_copychunk Chunks[];
+} __packed;
+
+struct srv_copychunk_response {
+	__le32 ChunksWritten;
+	__le32 ChunkBytesWritten;
+	__le32 TotalBytesWritten;
+} __packed;
+
+struct fsctl_set_zero_data {
+	__le64	FileOffset;
+	__le64	BeyondFinalZero;
+} __packed;
+
+/* Integrity ChecksumAlgorithm choices */
+#define	CHECKSUM_TYPE_NONE	0x0000
+#define	CHECKSUM_TYPE_CRC64	0x0002
+#define CHECKSUM_TYPE_UNCHANGED	0xFFFF	/* set only */
+
+/* Integrity flags */
+#define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF	0x00000001
+
+struct fsctl_set_integrity_information {
+	__le16	ChecksumAlgorithm;
+	__le16	Reserved;
+	__le32	Flags;
+} __packed;
+
+struct fsctl_get_integrity_information {
+	__le16	ChecksumAlgorithm;
+	__le16	Reserved;
+	__le32	Flags;
+	__le32	ChecksumChunkSizeInBytes;
+	__le32	ClusterSizeInBytes;
+} __packed;
+
+struct file_allocated_range_buffer {
+	__le64	FileOffset;
+	__le64	Length;
+} __packed;
+
+struct reparse_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__le16	Reserved;
+	__u8	DataBuffer[]; /* Variable Length */
+} __packed;
+
+struct reparse_guid_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__le16	Reserved;
+	__u8	ReparseGuid[16];
+	__u8	DataBuffer[]; /* Variable Length */
+} __packed;
+
+struct reparse_mount_point_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__le16	Reserved;
+	__le16	SubstituteNameOffset;
+	__le16	SubstituteNameLength;
+	__le16	PrintNameOffset;
+	__le16	PrintNameLength;
+	__u8	PathBuffer[]; /* Variable Length */
+} __packed;
+
+#define SYMLINK_FLAG_RELATIVE 0x00000001
+
+/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
+/* MS-FSCC 2.1.2.4 */
+struct reparse_symlink_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__le16	Reserved;
+	__le16	SubstituteNameOffset;
+	__le16	SubstituteNameLength;
+	__le16	PrintNameOffset;
+	__le16	PrintNameLength;
+	__le32	Flags;
+	__u8	PathBuffer[]; /* Variable Length */
+} __packed;
+
+/* See MS-DFSC 2.2.2 */
+struct fsctl_get_dfs_referral_req {
+	__le16 MaxReferralLevel;
+	__u8 RequestFileName[];
+} __packed;
+
+/* DFS response is struct get_dfs_refer_rsp */
+
+/* See MS-SMB2 2.2.31.3 */
+struct network_resiliency_req {
+	__le32 Timeout;
+	__le32 Reserved;
+} __packed;
+/* There is no buffer for the response ie no struct network_resiliency_rsp */
+
+#define RSS_CAPABLE	cpu_to_le32(0x00000001)
+#define RDMA_CAPABLE	cpu_to_le32(0x00000002)
+
+#define INTERNETWORK	cpu_to_le16(0x0002)
+#define INTERNETWORKV6	cpu_to_le16(0x0017)
+
+struct network_interface_info_ioctl_rsp {
+	__le32 Next; /* next interface. zero if this is last one */
+	__le32 IfIndex;
+	__le32 Capability; /* RSS or RDMA Capable */
+	__le32 Reserved;
+	__le64 LinkSpeed;
+	__le16 Family;
+	__u8 Buffer[126];
+} __packed;
+
+struct iface_info_ipv4 {
+	__be16 Port;
+	__be32 IPv4Address;
+	__be64 Reserved;
+} __packed;
+
+struct iface_info_ipv6 {
+	__be16 Port;
+	__be32 FlowInfo;
+	__u8   IPv6Address[16];
+	__be32 ScopeId;
+} __packed;
+
+#define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not to file */
+
+struct compress_ioctl {
+	__le16 CompressionState; /* See cifspdu.h for possible flag values */
+} __packed;
+
+
+struct smb2_ioctl_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 57 */
+	__le16 Reserved;
+	__le32 CtlCode;
+	__le64 PersistentFileId;
+	__le64 VolatileFileId;
+	__le32 InputOffset;
+	__le32 InputCount;
+	__le32 MaxInputResponse;
+	__le32 OutputOffset;
+	__le32 OutputCount;
+	__le32 MaxOutputResponse;
+	__le32 Flags;
+	__le32 Reserved2;
+	__u8   Buffer[];
+} __packed;
+
+struct smb2_ioctl_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 57 */
+	__le16 Reserved;
+	__le32 CtlCode;
+	__le64 PersistentFileId;
+	__le64 VolatileFileId;
+	__le32 InputOffset;
+	__le32 InputCount;
+	__le32 OutputOffset;
+	__le32 OutputCount;
+	__le32 Flags;
+	__le32 Reserved2;
+	__u8   Buffer[];
+} __packed;
+
 
 #endif				/* _COMMON_SMB2PDU_H */
-- 
2.30.2

