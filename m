Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814684A33
	for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 00:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758067770; cv=none; b=LWdj3sljPrc8qlBZlVFFD7NTA7yJ1RAmqPlD9fNqYsVVWEbXmQLznvpPUFddln9TqHOmA3E7FexSwtw47dXTKKM6/EBBNFCD6vENwswfNMkJdOxMqXENh4pqYr1e3327q9230TrHkSWO/u3w0h06IuCpLg61Rr//QUR5FQL7Ag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758067770; c=relaxed/simple;
	bh=M6kHpqw6+PyDXs+rb7ECeSPhZtbsLnQFu825ef4C68E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ObEN48Iq7N0M7mie4af9ahVc5Xy5UjADgoAUt4wuwcw7Tq0GZmQLZDCrlMdw7rBr7XyC0IMTLaBVeNrP7vr0ukCx7DUIujDLoWAFy3DeVyqiJ2O9AWEy2q+UjrTVdzKCxPpj4jFDjw1XTrrtnloRF+okTHOWLiQX1yB/FyfmgyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NERKN9Tu; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NERKN9Tu"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so4157742f8f.3
        for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 17:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758067766; x=1758672566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=93+b4cYNF/WAbyeC+SRU8+8lFDe3eZsMV1Igov5XjaQ=;
        b=NERKN9TuAJDyj2KDUQaCFsguabY2iBA0eXpr+JY0nU0rKPXGOXAXlcNo/qwZ3H9uvB
         NnJde3lGuRB4yTvEWsGpnm2l4Wf3rI2hGe+AvPsrwgc5jbPFOwRoLdjt60flyg6w0KVV
         9qfMAVVOEUp0rFLnwbS6GaGvaQMo/M5NHxPaU7LgN6Cj6C/1RubaknhzbuE60B1s454q
         iWNJi5NMM7mV+P5/cuLdxM8lEQw4fjfjseNZKKo9fvlsWzzV9JMASooTgjWKcTHta2yG
         ZRbC2SkGDv7XgUZ3QateJ+e3xo70bSw/2v+uFRbBxOyGzrZFGmNyqX49FtIjePCdEdS2
         VsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758067766; x=1758672566;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=93+b4cYNF/WAbyeC+SRU8+8lFDe3eZsMV1Igov5XjaQ=;
        b=laENKfYPU08ki+lMVduwWmhE/aZERjphjSbsnyqvpJRI9xDr9rGPtL5i/SITqmf7dJ
         JWIa4ZfOiqSCz1kJQ+N9V6i0v+FRjQUwCGmhj8j6i+K8C5zjkjRoZlYCAfGpO16ZvhYT
         msCnIjY+x0VI7LnCP0GCn6KRyMzip655X9pDHn87Ykx4XIdqXiU+VmtbV67z25qfFhX5
         ZlkEf/0DrNWvo8a5BUdsQdRrtDe98HmhtRBNHBGGD8KO4S6OfjZK8pgDwoui4Otpo1kA
         acrrrYrllWahMwyoyC/qjfbnj1TzQTd3Y6YuvVEfL5WGd5qYaJNlxde8+2cq/fRhkYtg
         BqTw==
X-Forwarded-Encrypted: i=1; AJvYcCUOnduG0Zp9PpDyUEJlnbirEoLQ2P7WTgnpgNv+5S6DeauMHu01iPlnqoU7g4L9baUm1mIHDs2iOrtE@vger.kernel.org
X-Gm-Message-State: AOJu0YyyxNDjPrx18Jk5Geq2EY1dHJAS9xWGQyhvsARzyuYWCp15avcM
	vpF6y0BpE/kG2LvWavnmMnwH69GrSrlWg3NZG28vLkNtglUOvxrDz7jlGb5KEwonlrk=
X-Gm-Gg: ASbGncv2dZu0m6T6af47WbNLB0w3kgHIdhnCn+N3Y3FYjgSCOSwTJHHGoPBhLkHEg39
	57x+vWaVBJZOjl+ClqzIl97ytMZHIF+FCl6nSwWby1xoIHj9UlTncQFmvIYTuKzloZ/VrltSBCx
	kJBpbTCE/0YREtC5ldnOn/2xxigyObh3qMPyvhRQiQYDR7zD/ZthwuGbgyA8q4gXCM+22U47glV
	wFxLl2QiuMoB5SeIQ5Q1WoXBdAOgbtXepEuz1JKUEV3+0icYDske6kUXQb6vmlC9sxMQopqvG+R
	TBJHNifNlOvsnLz8qhYz/ueNU5nO/edDbvBuMi2LywMpQMaBiX9ZkcYBYfBV56j40D4YfdYI/1f
	c/liDYPaWg+2ejyazAzHy3m/dvs1p1O0=
X-Google-Smtp-Source: AGHT+IGzScVT8JsRMoLbEc0LLgj5I7CH1XIZyOZTI/yjr40acpepOqc3NhOT2cbfqjBl6O8ThpI9nQ==
X-Received: by 2002:a05:6000:310c:b0:3d4:a64:6754 with SMTP id ffacd0b85a97d-3ecdfa4c286mr154046f8f.62.1758067765725;
        Tue, 16 Sep 2025 17:09:25 -0700 (PDT)
Received: from precision ([2804:7f0:bc02:e809:130e:9600:1331:27ad])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2634dbf7abbsm96581765ad.10.2025.09.16.17.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 17:09:24 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] smb: client: batch SRV_COPYCHUNK entries to cut roundtrips
Date: Tue, 16 Sep 2025 21:06:53 -0300
Message-ID: <20250917000653.778603-1-henrique.carvalho@suse.com>
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
V0 -> V1:
* fix potential cc_req leak
* prevent null-ptr deref, set cc_{req,rsp} to NULL
* guard calc_chunk_count() against zero div (crash in xfstests generic/564)
* initialize rc = 0 to avoid uninitialized return on len==0
* improve partial write handling
* use struct_size()
* add documentation

 fs/smb/client/smb2ops.c | 279 ++++++++++++++++++++++++++--------------
 fs/smb/client/smb2pdu.h |  16 ++-
 fs/smb/client/trace.h   |   3 +-
 3 files changed, 197 insertions(+), 101 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e586f3f4b5c9..8b3227a6fdf1 100644
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
+	int rc = 0;
 	unsigned int ret_data_len;
-	struct copychunk_ioctl *pcchunk;
-	struct copychunk_ioctl_rsp *retbuf = NULL;
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
+
+		chunks = 0;
+		copy_bytes = 0;
+		copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);
+		while (copy_bytes_left > 0 && chunks < chunk_count) {
+			chunk = &cc_req->Chunks[chunks++];
 
-	tcon = tlink_tcon(trgtfile->tlink);
+			chunk->SourceOffset = cpu_to_le64(src_off);
+			chunk->TargetOffset = cpu_to_le64(dst_off);
 
-	trace_smb3_copychunk_enter(xid, srcfile->fid.volatile_fid,
-				   trgtfile->fid.volatile_fid, tcon->tid,
-				   tcon->ses->Suid, src_off, dest_off, len);
+			chunk_bytes = umin(copy_bytes_left, tcon->max_bytes_chunk);
 
-	while (len > 0) {
-		pcchunk->SourceOffset = cpu_to_le64(src_off);
-		pcchunk->TargetOffset = cpu_to_le64(dest_off);
-		pcchunk->Length =
-			cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk));
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

