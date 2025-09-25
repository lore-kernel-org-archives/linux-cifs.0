Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804191E50E
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810222; cv=none; b=BJTWk7v68+9vckpF+5V5ea8zmSmtwTspF0frfQxcRWLxsDJm2IrPkLBlDTC7zThWcH/42lbye0wAMCz3o4ZFCUnTJmwOj5Lhd0isepdFC3PSuBHLQqDYvxW7mk+rRU+DCyjJapKvVXgCLZm6U0RYS/Ymq2b1a7CgzwZBqHNS6U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810222; c=relaxed/simple;
	bh=+qgaCWcgwTSctAYwei0iagAUtZCeA0YH7nuB23pOaSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nqn9Zhy8hDlDa16zX6OfmTvSRIkiHXsiVMyAE33eeMe3CN4P19g38iCEHxr3QZ0GPgk8vjTDg9dBE8orzHo72eAqXauclXDALBwvDg6GgcwoEEmgKgr4wgZkz/ikavfYkizEStPsfiFksYFizBKKxU3mpmRhQrY0BchXW8gbUvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WjxDMg9b; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WjxDMg9b"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3fa528f127fso783677f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 07:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758810217; x=1759415017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wlHVucfZ+afdbLzqGIHm1dYLPAAXi04+DGZnp1wAPzw=;
        b=WjxDMg9bhJq/EVTqsHV891Px5HVYiivePwRrN2Um7AbfDyG3ZjNN6AzyfYrlI/0qef
         Hwmo3BdDmzoiZ3yRPsm9LZKz9CwdUlY6lSfGWn8jUw7a/CPdJbItLq7kdL28TVCOahFu
         wdUkChxH+6b8Jsl+t7Bfabk4nckdPLyfjO2mEpYHyHz8bgErbYbYnvVz2JEDc2SXc5/+
         34zRF6o1xYQYZjKgfvbs7200E53VsZuUGUsVUR4DXmJEALwR/8Ik2TDdoslOIoAtAm+y
         ERx2FsBTO26yJnn3HVqtC/RD1sDcyYiOtWktg4rfYTzgAoOFx48x/wsih8XTMkVF8WjJ
         4edA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810217; x=1759415017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wlHVucfZ+afdbLzqGIHm1dYLPAAXi04+DGZnp1wAPzw=;
        b=Sv4KrTWVq5Vb/GtvuhJFHwlijjRb0JjiOMfZ5QcH9DBUjL6A7vN+7jh2bDNoVNl8mY
         WHjJH0WlTBtkKcLo5lwVbCCZFpo6KVfmeJadh7736qJFkWyiaFnlxrQ2Do/YFgpkQKF6
         Pnm4yUwwzMUUN8sU+M7wqTM83FcqbmgTUZlon01PGpxRB0XrQOMfwKdYZ0F62U9xwjYg
         xgZqKvO+BREaglD1UIbAK958k/woDW7+0UvoNXdSlr6RuH0z3W4TL74CAhGihGSK7LSs
         5henOSCMcEKP4gnRiCyspbCj1Bj3FUIySkTryyqG5RcLDRNHCi5foNnjxzxu0VySJxqf
         un0g==
X-Forwarded-Encrypted: i=1; AJvYcCV1TnIHwaG5PFEHHK5qJHmVqFAFTkuEsORnrCIjX2F5sF/ZobqU3TAojXTvp4h5nvqI0/uwivj2aeqY@vger.kernel.org
X-Gm-Message-State: AOJu0YyG4qip/246Dvb+pHefn8nDfk8ZhaiSySV2qHBNE2Lj/Pw7vLTZ
	wAh6tnE4xN5cfgAEftIz0vHxGbThW9qBRfi0p8Npk8K9uiSI5MbUzrtsUgkFhVBIxfg=
X-Gm-Gg: ASbGncvffF72o5xzGHLQP9BjIjXg7PqVz92N/zIHxcN1xWBc/Aukyny9D1hFO9yJdSu
	1+apTnPerZEsB5Px6nyRojiRFLrmae1f93xqffWoO3lWf5w5q+P7XhtWJ2LUhKZVX5CVlSYjC0r
	dcSFP7KEOuSUsNMhY7vFIl7Vlcac5Jw+mYXQRx1llP78W/jMSRS7uW8HgNeP2bRL5FJ2D/NgteQ
	WTcbmuFk0Tje7jb/CAwFQ4Trlf+F99OxjneNcWYaJDmQm8w3THDHVmjzxjBFpou00hQ4/+e8yKf
	UHsL33d4n2Vz4J2zycg/YDRJhWugYkz7uDX+WkcP9YsiQ0Q9EVskJ40hInqyeJIQEehm0CsYfIj
	osLa2zwyNqGbYBpm5WG2qu+xIgGbi0ZM=
X-Google-Smtp-Source: AGHT+IH4ISw/NyiWsuX7vyNIF9HUEilk8kpR8RCcZAKtKhs3jagHW+FKbJ4zkCU67csH+74GgX6aeg==
X-Received: by 2002:adf:9dcd:0:b0:3fa:ebaf:4c53 with SMTP id ffacd0b85a97d-40f6a1a909bmr2430937f8f.29.1758810216670;
        Thu, 25 Sep 2025 07:23:36 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:781b:d1e0:cce1:50f4:d7cd])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c53bba30sm2343164a12.4.2025.09.25.07.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 07:23:36 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org,
	dan.carpenter@linaro.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2] smb: client: batch SRV_COPYCHUNK entries to cut roundtrips
Date: Thu, 25 Sep 2025 11:19:20 -0300
Message-ID: <20250925141920.166230-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_copychunk_range() used to send a single SRV_COPYCHUNK per
SRV_COPYCHUNK_COPY IOCTL.

Implement variable Chunks[] array in struct copychunk_ioctl and fill it
with struct copychunk (MS-SMB2 2.2.31.1.1), bounded by server-advertised
limits.

This reduces the number of IOCTLs requests for large copies.

While we are at it, rename a couple variables to follow the terminology
used in the specification.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2:
- initialize ret_data_len to 0

 fs/smb/client/smb2ops.c | 281 ++++++++++++++++++++++++++--------------
 fs/smb/client/smb2pdu.h |  16 ++-
 fs/smb/client/trace.h   |   3 +-
 3 files changed, 198 insertions(+), 102 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e586f3f4b5c9..c469120bb4f6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1806,140 +1806,231 @@ smb2_ioctl_query_info(const unsigned int xid,
 	return rc;
 }
 
+/*
+ * calc_chunk_count - calculates the number chunks to be filled in the Chunks[]
+ * array of struct copychunk_ioctl
+ *
+ * @tcon: destination file tcon
+ * @bytes_left: how many bytes are left to copy
+ *
+ * Return: maximum number of chunks with which Chunks[] can be filled.
+ */
+static inline u32
+calc_chunk_count(struct cifs_tcon *tcon, u64 bytes_left)
+{
+	if (!tcon->max_bytes_chunk || !tcon->max_bytes_copy || !tcon->max_chunks)
+		return 0;
+
+	return min_t(u32, DIV_ROUND_UP_ULL(bytes_left, tcon->max_bytes_chunk),
+		     umin(tcon->max_chunks,
+			  DIV_ROUND_UP(tcon->max_bytes_copy, tcon->max_bytes_chunk)));
+}
+
+/*
+ * smb2_copychunk_range - server-side copy of data range
+ *
+ * @xid: transaction id
+ * @src_file: source file
+ * @dst_file: destination file
+ * @src_off: source file byte offset
+ * @len: number of bytes to copy
+ * @dst_off: destination file byte offset
+ *
+ * Obtains a resume key for @src_file and issues FSCTL_SRV_COPYCHUNK_WRITE
+ * IOCTLs, splitting the request into chunks limited by tcon->max_*.
+ *
+ * Return: @len on success; negative errno on failure.
+ */
 static ssize_t
 smb2_copychunk_range(const unsigned int xid,
-			struct cifsFileInfo *srcfile,
-			struct cifsFileInfo *trgtfile, u64 src_off,
-			u64 len, u64 dest_off)
+		     struct cifsFileInfo *src_file,
+		     struct cifsFileInfo *dst_file,
+		     u64 src_off,
+		     u64 len,
+		     u64 dst_off)
 {
-	int rc;
-	unsigned int ret_data_len;
-	struct copychunk_ioctl *pcchunk;
-	struct copychunk_ioctl_rsp *retbuf = NULL;
+	int rc = 0;
+	unsigned int ret_data_len = 0;
+	struct copychunk_ioctl *cc_req = NULL;
+	struct copychunk_ioctl_rsp *cc_rsp = NULL;
 	struct cifs_tcon *tcon;
-	int chunks_copied = 0;
-	bool chunk_sizes_updated = false;
-	ssize_t bytes_written, total_bytes_written = 0;
+	struct copychunk *chunk;
+	u32 chunks, chunk_count, chunk_bytes;
+	u32 copy_bytes, copy_bytes_left;
+	u32 chunks_written, bytes_written;
+	u64 total_bytes_left = len;
+	u64 src_off_prev, dst_off_prev;
+	u32 retries = 0;
+
+	tcon = tlink_tcon(dst_file->tlink);
+
+	trace_smb3_copychunk_enter(xid, src_file->fid.volatile_fid,
+				   dst_file->fid.volatile_fid, tcon->tid,
+				   tcon->ses->Suid, src_off, dst_off, len);
+
+retry:
+	chunk_count = calc_chunk_count(tcon, total_bytes_left);
+	if (!chunk_count) {
+		rc = -EOPNOTSUPP;
+		goto cchunk_out;
+	}
 
-	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
-	if (pcchunk == NULL)
-		return -ENOMEM;
+	cc_req = kzalloc(struct_size(cc_req, Chunks, chunk_count), GFP_KERNEL);
+	if (!cc_req) {
+		rc = -ENOMEM;
+		goto cchunk_out;
+	}
 
-	cifs_dbg(FYI, "%s: about to call request res key\n", __func__);
 	/* Request a key from the server to identify the source of the copy */
-	rc = SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
-				srcfile->fid.persistent_fid,
-				srcfile->fid.volatile_fid, pcchunk);
+	rc = SMB2_request_res_key(xid,
+				  tlink_tcon(src_file->tlink),
+				  src_file->fid.persistent_fid,
+				  src_file->fid.volatile_fid,
+				  cc_req);
 
-	/* Note: request_res_key sets res_key null only if rc !=0 */
+	/* Note: request_res_key sets res_key null only if rc != 0 */
 	if (rc)
 		goto cchunk_out;
 
-	/* For now array only one chunk long, will make more flexible later */
-	pcchunk->ChunkCount = cpu_to_le32(1);
-	pcchunk->Reserved = 0;
-	pcchunk->Reserved2 = 0;
+	while (total_bytes_left > 0) {
+
+		/* Store previous offsets to allow rewind */
+		src_off_prev = src_off;
+		dst_off_prev = dst_off;
+
+		trace_smb3_copychunk_iter(xid, src_file->fid.volatile_fid,
+					  dst_file->fid.volatile_fid, tcon->tid,
+					  tcon->ses->Suid, src_off, dst_off, len);
 
-	tcon = tlink_tcon(trgtfile->tlink);
+		chunks = 0;
+		copy_bytes = 0;
+		copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);
+		while (copy_bytes_left > 0 && chunks < chunk_count) {
+			chunk = &cc_req->Chunks[chunks++];
 
-	trace_smb3_copychunk_enter(xid, srcfile->fid.volatile_fid,
-				   trgtfile->fid.volatile_fid, tcon->tid,
-				   tcon->ses->Suid, src_off, dest_off, len);
+			chunk->SourceOffset = cpu_to_le64(src_off);
+			chunk->TargetOffset = cpu_to_le64(dst_off);
 
-	while (len > 0) {
-		pcchunk->SourceOffset = cpu_to_le64(src_off);
-		pcchunk->TargetOffset = cpu_to_le64(dest_off);
-		pcchunk->Length =
-			cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk));
+			chunk_bytes = umin(copy_bytes_left, tcon->max_bytes_chunk);
+
+			chunk->Length = cpu_to_le32(chunk_bytes);
+			chunk->Reserved = 0;
+
+			src_off += chunk_bytes;
+			dst_off += chunk_bytes;
+
+			copy_bytes_left -= chunk_bytes;
+			copy_bytes += chunk_bytes;
+		}
+
+		cc_req->ChunkCount = cpu_to_le32(chunks);
+		/* Buffer is zeroed, no need to set pcchunk->Reserved = 0 */
 
 		/* Request server copy to target from src identified by key */
-		kfree(retbuf);
-		retbuf = NULL;
-		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
-			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
-			(char *)pcchunk, sizeof(struct copychunk_ioctl),
-			CIFSMaxBufSize, (char **)&retbuf, &ret_data_len);
+		kfree(cc_rsp);
+		cc_rsp = NULL;
+		rc = SMB2_ioctl(xid, tcon, dst_file->fid.persistent_fid,
+			dst_file->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
+			(char *)cc_req, struct_size(cc_req, Chunks, chunks),
+			CIFSMaxBufSize, (char **)&cc_rsp, &ret_data_len);
+
+		if (ret_data_len != sizeof(struct copychunk_ioctl_rsp)) {
+			cifs_tcon_dbg(VFS, "Copychunk invalid response: response size does not match expected size\n");
+			rc = -EIO;
+			goto cchunk_out;
+		}
+
 		if (rc == 0) {
-			if (ret_data_len !=
-					sizeof(struct copychunk_ioctl_rsp)) {
-				cifs_tcon_dbg(VFS, "Invalid cchunk response size\n");
+			bytes_written = le32_to_cpu(cc_rsp->TotalBytesWritten);
+			if (bytes_written == 0) {
+				cifs_tcon_dbg(VFS, "Copychunk invalid response: no bytes copied\n");
 				rc = -EIO;
 				goto cchunk_out;
 			}
-			if (retbuf->TotalBytesWritten == 0) {
-				cifs_dbg(FYI, "no bytes copied\n");
+			/* Check if server claimed to write more than we asked */
+			if (bytes_written > copy_bytes) {
+				cifs_tcon_dbg(VFS, "Copychunk invalid response: unexpected value for TotalBytesWritten\n");
 				rc = -EIO;
 				goto cchunk_out;
 			}
-			/*
-			 * Check if server claimed to write more than we asked
-			 */
-			if (le32_to_cpu(retbuf->TotalBytesWritten) >
-			    le32_to_cpu(pcchunk->Length)) {
-				cifs_tcon_dbg(VFS, "Invalid copy chunk response\n");
+
+			chunks_written = le32_to_cpu(cc_rsp->ChunksWritten);
+			if (chunks_written > chunks) {
+				cifs_tcon_dbg(VFS, "Copychunk invalid response: Invalid num chunks written\n");
 				rc = -EIO;
 				goto cchunk_out;
 			}
-			if (le32_to_cpu(retbuf->ChunksWritten) != 1) {
-				cifs_tcon_dbg(VFS, "Invalid num chunks written\n");
-				rc = -EIO;
-				goto cchunk_out;
+
+			/* Partial write: rewind */
+			if (bytes_written < copy_bytes) {
+				u32 delta = copy_bytes - bytes_written;
+
+				src_off -= delta;
+				dst_off -= delta;
 			}
-			chunks_copied++;
-
-			bytes_written = le32_to_cpu(retbuf->TotalBytesWritten);
-			src_off += bytes_written;
-			dest_off += bytes_written;
-			len -= bytes_written;
-			total_bytes_written += bytes_written;
-
-			cifs_dbg(FYI, "Chunks %d PartialChunk %d Total %zu\n",
-				le32_to_cpu(retbuf->ChunksWritten),
-				le32_to_cpu(retbuf->ChunkBytesWritten),
-				bytes_written);
-			trace_smb3_copychunk_done(xid, srcfile->fid.volatile_fid,
-				trgtfile->fid.volatile_fid, tcon->tid,
-				tcon->ses->Suid, src_off, dest_off, len);
-		} else if (rc == -EINVAL) {
-			if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
-				goto cchunk_out;
 
-			cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy %d\n",
-				le32_to_cpu(retbuf->ChunksWritten),
-				le32_to_cpu(retbuf->ChunkBytesWritten),
-				le32_to_cpu(retbuf->TotalBytesWritten));
+			total_bytes_left -= bytes_written;
 
+		} else if (rc == -EINVAL) {
 			/*
-			 * Check if this is the first request using these sizes,
-			 * (ie check if copy succeed once with original sizes
-			 * and check if the server gave us different sizes after
-			 * we already updated max sizes on previous request).
-			 * if not then why is the server returning an error now
+			 * Check if server is not asking us to reduce size.
+			 *
+			 * Note: As per MS-SMB2 2.2.32.1, the values returned
+			 * in cc_rsp are not strictly lower than what existed
+			 * before.
+			 *
 			 */
-			if ((chunks_copied != 0) || chunk_sizes_updated)
-				goto cchunk_out;
-
-			/* Check that server is not asking us to grow size */
-			if (le32_to_cpu(retbuf->ChunkBytesWritten) <
-					tcon->max_bytes_chunk)
-				tcon->max_bytes_chunk =
-					le32_to_cpu(retbuf->ChunkBytesWritten);
-			else
-				goto cchunk_out; /* server gave us bogus size */
+			if (le32_to_cpu(cc_rsp->ChunksWritten) < tcon->max_chunks) {
+				cifs_tcon_dbg(VFS, "Copychunk MaxChunks updated: %u -> %u\n",
+					      tcon->max_chunks,
+					      le32_to_cpu(cc_rsp->ChunksWritten));
+				tcon->max_chunks = le32_to_cpu(cc_rsp->ChunksWritten);
+			}
+			if (le32_to_cpu(cc_rsp->ChunkBytesWritten) < tcon->max_bytes_chunk) {
+				cifs_tcon_dbg(VFS, "Copychunk MaxBytesChunk updated: %u -> %u\n",
+					      tcon->max_bytes_chunk,
+					      le32_to_cpu(cc_rsp->ChunkBytesWritten));
+				tcon->max_bytes_chunk = le32_to_cpu(cc_rsp->ChunkBytesWritten);
+			}
+			if (le32_to_cpu(cc_rsp->TotalBytesWritten) < tcon->max_bytes_copy) {
+				cifs_tcon_dbg(VFS, "Copychunk MaxBytesCopy updated: %u -> %u\n",
+					      tcon->max_bytes_copy,
+					      le32_to_cpu(cc_rsp->TotalBytesWritten));
+				tcon->max_bytes_copy = le32_to_cpu(cc_rsp->TotalBytesWritten);
+			}
 
-			/* No need to change MaxChunks since already set to 1 */
-			chunk_sizes_updated = true;
-		} else
+			trace_smb3_copychunk_err(xid, src_file->fid.volatile_fid,
+						 dst_file->fid.volatile_fid, tcon->tid,
+						 tcon->ses->Suid, src_off, dst_off, len, rc);
+
+			/* Rewind */
+			if (retries++ < 2) {
+				src_off = src_off_prev;
+				dst_off = dst_off_prev;
+				kfree(cc_req);
+				cc_req = NULL;
+				goto retry;
+			} else
+				goto cchunk_out;
+		} else { /* Unexpected */
+			trace_smb3_copychunk_err(xid, src_file->fid.volatile_fid,
+						 dst_file->fid.volatile_fid, tcon->tid,
+						 tcon->ses->Suid, src_off, dst_off, len, rc);
 			goto cchunk_out;
+		}
 	}
 
+	trace_smb3_copychunk_done(xid, src_file->fid.volatile_fid,
+				  dst_file->fid.volatile_fid, tcon->tid,
+				  tcon->ses->Suid, src_off, dst_off, len);
+
 cchunk_out:
-	kfree(pcchunk);
-	kfree(retbuf);
+	kfree(cc_req);
+	kfree(cc_rsp);
 	if (rc)
 		return rc;
 	else
-		return total_bytes_written;
+		return len;
 }
 
 static int
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 3c09a58dfd07..101024f8f725 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -201,16 +201,20 @@ struct resume_key_req {
 	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
+
+struct copychunk {
+	__le64 SourceOffset;
+	__le64 TargetOffset;
+	__le32 Length;
+	__le32 Reserved;
+} __packed;
+
 /* this goes in the ioctl buffer when doing a copychunk request */
 struct copychunk_ioctl {
 	char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32 ChunkCount; /* we are only sending 1 */
+	__le32 ChunkCount;
 	__le32 Reserved;
-	/* array will only be one chunk long for us */
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length; /* how many bytes to copy */
-	__u32 Reserved2;
+	struct copychunk Chunks[];
 } __packed;
 
 struct copychunk_ioctl_rsp {
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index fd650e2afc76..63871321b464 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -266,7 +266,7 @@ DEFINE_EVENT(smb3_copy_range_err_class, smb3_##name, \
 	TP_ARGS(xid, src_fid, target_fid, tid, sesid, src_offset, target_offset, len, rc))
 
 DEFINE_SMB3_COPY_RANGE_ERR_EVENT(clone_err);
-/* TODO: Add SMB3_COPY_RANGE_ERR_EVENT(copychunk_err) */
+DEFINE_SMB3_COPY_RANGE_ERR_EVENT(copychunk_err);
 
 DECLARE_EVENT_CLASS(smb3_copy_range_done_class,
 	TP_PROTO(unsigned int xid,
@@ -319,6 +319,7 @@ DEFINE_SMB3_COPY_RANGE_DONE_EVENT(copychunk_enter);
 DEFINE_SMB3_COPY_RANGE_DONE_EVENT(clone_enter);
 DEFINE_SMB3_COPY_RANGE_DONE_EVENT(copychunk_done);
 DEFINE_SMB3_COPY_RANGE_DONE_EVENT(clone_done);
+DEFINE_SMB3_COPY_RANGE_DONE_EVENT(copychunk_iter);
 
 
 /* For logging successful read or write */
-- 
2.50.1

