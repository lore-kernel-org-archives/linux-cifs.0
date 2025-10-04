Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E9A278158
	for <linux-cifs@vger.kernel.org>; Sat,  4 Oct 2025 02:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759543303; cv=none; b=iYxirFuZMcmi/ysSOWpKXqJeHr2/TXdvkyuDIvKRA6dTFt9IEb8fONIsVtPpcanB0H4rx8cPJM4KAPwrkIQfAqnCLx37ubqvAVsKo77PTRP5lAPMUmqNcf3crxQ63iGaSjy9L0IIDo5JJJoTUDyC1VT4EslAjdm4ZeGcLlemsMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759543303; c=relaxed/simple;
	bh=1SKOI7X78xpeEhrwiWh2N4EVI6yvaPGtFIZJNScoLCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sq6buA7CHfR2OFbxLnNIu1aZkuWmljftOeXTNkLRO42KoMqTFQv/jJivTHZC0HHm6ijWmq+qUXUhpGURJKzdheUldEGE3MTRWuAsd2Lblb0E/jpOrErej6PLIZnH9EK4+Z6aC8VabhA3zVYLH+nLphHqhY8l7FCNAAEMPkXcGaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=StfQPbhx; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="StfQPbhx"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso2137329f8f.3
        for <linux-cifs@vger.kernel.org>; Fri, 03 Oct 2025 19:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759543298; x=1760148098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gAiVtHNJ21lSyZYNVNH+Pv691CGz/8IbCkMQ6GRAYPU=;
        b=StfQPbhxExD50hLeVGBDtRsZGrArYYEz2A8wEtoxcE2X6SV1ZlgCWdnzNEW2HjGcGS
         XxD+ythdWLGl2+Kr+gFWEHXqJGqxO4V435H9AgYJu4qii0Z4Emt8n37WBKyc7i6bS+zO
         lIgtEstQ5uMUadkfQNRoVXzuwy6LYa6YKNMoehzrGj7/RBxQhGaiGXWM/U2d245ITFWN
         TcGb+UubnSVk/v7bVLywChC77mzoG0Tfe5jj5mLXF1Mo0qOV5rR2IUazx5JyLsBMrGxw
         K35jCeh3jbqwvyZQrukTKkKBxHpf2RI/VH1qbEKeNdKosW5dS8Frh5YaLZ8DGAAwD9QO
         9hZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759543298; x=1760148098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gAiVtHNJ21lSyZYNVNH+Pv691CGz/8IbCkMQ6GRAYPU=;
        b=wAezKjA2NZcWCdX/DBdjvYNZjL/TS6lkpNOdlQvMmcddHDQJVMgkyOJp/xMh5TJPfd
         Shj0o8KzYcDX9uAYL8IobHYe02eXh9ELoJX0NTEMB8F4wCql6KtdLRWEwtXmcIlsoIn4
         yX2LqVFC3ga0vafVbOtrJEVFrzTo+TqbrbbUrTwUHVglZmrXpyKNNJHFtrEgeiPFbFfE
         e/VYpeDv3qH5BJOcrloaWRUDJsUFBaxXcGFgpNkig5nlKzu6wQZKM7D5NC8MFIkKP/lr
         SgkWYOSF+H9DoHew6CW1lyXRhNAZqbOzpOrxDCpLc+uAwWMV826bimFiWlCW2uZBt3PD
         0vTw==
X-Forwarded-Encrypted: i=1; AJvYcCVAVExB1PEtre7dzIoXWInYVmbIE6gGFknqC9NjmxdBdUGPyKq70Bj+a0474ZahMTW/YP9v/IvzzR8s@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp6icmWthHnKKtpuKYVVL7z1jkqqoShXYjf9fXlnLfl2EuAkQC
	UDSsjCL5JNPB5dZfdhYFeqT9cPFH84Asv3qWHm5FnzmIyUy/CxIfUcILQXSCOqhj5tY=
X-Gm-Gg: ASbGncsZotWFwJHRb8h4wnxu168rGKEpJk7PplgCxCfoorNhN2kbzsY/LZ1lPBxqwCZ
	nsnpytcXIzeJDcMWhYRZx84ph7WnzSPv4yKt7pkGF73XdMYCPGt1+/KVI3uaBoNyFzQjsbo+q/O
	U/i9KVQLpiVErRm0B5hhKZCZYFLVwbx/cZRoVbv8Oi7JKA8uQmFXMVAUY0vkfoVD562ITvEc0JA
	/7SYaPlNBVL3Gtm1vLAoZ0tkb+Y3q+BTVliEjaK36yq441R1HDhaDgJ66mg6SyRZv7SZYn7wk8n
	ZPaKsNGNKuX/X+qCmt8DC0n2eGE8XCNS4LlRSVo6j+u9lJruLnzBfSkveL9Hnd7AO1ivvDTBORx
	8bSwu9Le7zMXvnDU6piUup1Tj/GZSsSJhfBeCsgOD1wiD8WoGzUKm5ctLvCDIbL0=
X-Google-Smtp-Source: AGHT+IGZJceZistdew9/svcH4C1LozyV4uJhV1MiQzPITHlSEvWvrx+M4bGmv51Y6fLg5L66tVj5Rg==
X-Received: by 2002:a05:6000:24c6:b0:425:58d0:486d with SMTP id ffacd0b85a97d-425671c110bmr2964317f8f.48.1759543298548;
        Fri, 03 Oct 2025 19:01:38 -0700 (PDT)
Received: from precision ([2804:7f0:bc01:751:618a:117f:a8e:defe])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b01f9cd56sm6184236b3a.2.2025.10.03.19.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 19:01:37 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v3] smb: client: batch SRV_COPYCHUNK entries to cut roundtrips
Date: Fri,  3 Oct 2025 22:59:05 -0300
Message-ID: <20251004015905.198696-1-henrique.carvalho@suse.com>
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
V2 -> V3:
- guard against potential "Invented loads" in calc_chunk_count
  (see https://lwn.net/Articles/793253/#Invented%20Loads -- please
  let me know if I'm misunderstanding the concept)
- improved comments and variable naming in calc_chunk_count
- minor documentation improvement
- stop log flooding (reported by Paulo Alcantara): return early on rc &&
  rc != -EINVAL right after SMB2_ioctl; only validate cc_rsp size when
  rc == 0 or rc == -EINVAL
- restructure code; drop *_iter trace; fix a comment typo (per Enzo Matsumiya)
- downgrade debug level from VFS to FYI on -EINVAL (per Steve French)

V1 -> V2:
- initialize ret_data_len to 0 (per Dan Carpenter)

 fs/smb/client/smb2ops.c | 306 +++++++++++++++++++++++++---------------
 fs/smb/client/smb2pdu.h |  16 ++-
 fs/smb/client/trace.h   |   2 +-
 3 files changed, 207 insertions(+), 117 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 058050f744c0..d1d6028ad748 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1803,140 +1803,226 @@ smb2_ioctl_query_info(const unsigned int xid,
 	return rc;
 }
 
+/**
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
+	u32 max_chunks = READ_ONCE(tcon->max_chunks);
+	u32 max_bytes_copy = READ_ONCE(tcon->max_bytes_copy);
+	u32 max_bytes_chunk = READ_ONCE(tcon->max_bytes_chunk);
+	u64 need;
+	u32 allowed;
+
+	if (!max_bytes_chunk || !max_bytes_copy || !max_chunks)
+		return 0;
+
+	/* chunks needed for the remaining bytes */
+	need = DIV_ROUND_UP_ULL(bytes_left, max_bytes_chunk);
+	/* chunks allowed per cc request */
+	allowed = DIV_ROUND_UP(max_bytes_copy, max_bytes_chunk);
+
+	return min_t(u32, need, umin(max_chunks, allowed));
+}
+
+/**
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
+		goto out;
+	}
 
-	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
-	if (pcchunk == NULL)
-		return -ENOMEM;
+	cc_req = kzalloc(struct_size(cc_req, Chunks, chunk_count), GFP_KERNEL);
+	if (!cc_req) {
+		rc = -ENOMEM;
+		goto out;
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
-		goto cchunk_out;
+		goto out;
 
-	/* For now array only one chunk long, will make more flexible later */
-	pcchunk->ChunkCount = cpu_to_le32(1);
-	pcchunk->Reserved = 0;
-	pcchunk->Reserved2 = 0;
+	while (total_bytes_left > 0) {
 
-	tcon = tlink_tcon(trgtfile->tlink);
+		/* Store previous offsets to allow rewind */
+		src_off_prev = src_off;
+		dst_off_prev = dst_off;
 
-	trace_smb3_copychunk_enter(xid, srcfile->fid.volatile_fid,
-				   trgtfile->fid.volatile_fid, tcon->tid,
-				   tcon->ses->Suid, src_off, dest_off, len);
+		chunks = 0;
+		copy_bytes = 0;
+		copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);
+		while (copy_bytes_left > 0 && chunks < chunk_count) {
+			chunk = &cc_req->Chunks[chunks++];
 
-	while (len > 0) {
-		pcchunk->SourceOffset = cpu_to_le64(src_off);
-		pcchunk->TargetOffset = cpu_to_le64(dest_off);
-		pcchunk->Length =
-			cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk));
+			chunk->SourceOffset = cpu_to_le64(src_off);
+			chunk->TargetOffset = cpu_to_le64(dst_off);
+
+			chunk_bytes = umin(copy_bytes_left, tcon->max_bytes_chunk);
+
+			chunk->Length = cpu_to_le32(chunk_bytes);
+			/* Buffer is zeroed, no need to set chunk->Reserved = 0 */
+
+			src_off += chunk_bytes;
+			dst_off += chunk_bytes;
+
+			copy_bytes_left -= chunk_bytes;
+			copy_bytes += chunk_bytes;
+		}
+
+		cc_req->ChunkCount = cpu_to_le32(chunks);
+		/* Buffer is zeroed, no need to set cc_req->Reserved = 0 */
 
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
+		if (rc && rc != -EINVAL)
+			goto out;
+
+		if (unlikely(ret_data_len != sizeof(*cc_rsp))) {
+			cifs_tcon_dbg(VFS, "Copychunk invalid response: size %u/%zu\n",
+				      ret_data_len, sizeof(*cc_rsp));
+			rc = -EIO;
+			goto out;
+		}
+
+		bytes_written = le32_to_cpu(cc_rsp->TotalBytesWritten);
+		chunks_written = le32_to_cpu(cc_rsp->ChunksWritten);
+		chunk_bytes = le32_to_cpu(cc_rsp->ChunkBytesWritten);
+
 		if (rc == 0) {
-			if (ret_data_len !=
-					sizeof(struct copychunk_ioctl_rsp)) {
-				cifs_tcon_dbg(VFS, "Invalid cchunk response size\n");
-				rc = -EIO;
-				goto cchunk_out;
-			}
-			if (retbuf->TotalBytesWritten == 0) {
-				cifs_dbg(FYI, "no bytes copied\n");
-				rc = -EIO;
-				goto cchunk_out;
-			}
-			/*
-			 * Check if server claimed to write more than we asked
-			 */
-			if (le32_to_cpu(retbuf->TotalBytesWritten) >
-			    le32_to_cpu(pcchunk->Length)) {
-				cifs_tcon_dbg(VFS, "Invalid copy chunk response\n");
+			/* Check if server claimed to write more than we asked */
+			if (unlikely(!bytes_written || bytes_written > copy_bytes ||
+				     !chunks_written || chunks_written > chunks)) {
+				cifs_tcon_dbg(VFS, "Copychunk invalid response: bytes written %u/%u, chunks written %u/%u\n",
+					      bytes_written, copy_bytes, chunks_written, chunks);
 				rc = -EIO;
-				goto cchunk_out;
+				goto out;
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
-
-			cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy %d\n",
-				le32_to_cpu(retbuf->ChunksWritten),
-				le32_to_cpu(retbuf->ChunkBytesWritten),
-				le32_to_cpu(retbuf->TotalBytesWritten));
 
-			/*
-			 * Check if this is the first request using these sizes,
-			 * (ie check if copy succeed once with original sizes
-			 * and check if the server gave us different sizes after
-			 * we already updated max sizes on previous request).
-			 * if not then why is the server returning an error now
-			 */
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
+			total_bytes_left -= bytes_written;
+			continue;
+		}
 
-			/* No need to change MaxChunks since already set to 1 */
-			chunk_sizes_updated = true;
-		} else
-			goto cchunk_out;
+		/*
+		 * Check if server is not asking us to reduce size.
+		 *
+		 * Note: As per MS-SMB2 2.2.32.1, the values returned
+		 * in cc_rsp are not strictly lower than what existed
+		 * before.
+		 */
+		if (bytes_written < tcon->max_bytes_copy) {
+			cifs_tcon_dbg(FYI, "Copychunk MaxBytesCopy updated: %u -> %u\n",
+				      tcon->max_bytes_copy, bytes_written);
+			tcon->max_bytes_copy = bytes_written;
+		}
+
+		if (chunks_written < tcon->max_chunks) {
+			cifs_tcon_dbg(FYI, "Copychunk MaxChunks updated: %u -> %u\n",
+				      tcon->max_chunks, chunks_written);
+			tcon->max_chunks = chunks_written;
+		}
+
+		if (chunk_bytes < tcon->max_bytes_chunk) {
+			cifs_tcon_dbg(FYI, "Copychunk MaxBytesChunk updated: %u -> %u\n",
+				      tcon->max_bytes_chunk, chunk_bytes);
+			tcon->max_bytes_chunk = chunk_bytes;
+		}
+
+		/* reset to last offsets */
+		if (retries++ < 2) {
+			src_off = src_off_prev;
+			dst_off = dst_off_prev;
+			kfree(cc_req);
+			cc_req = NULL;
+			goto retry;
+		}
+
+		break;
 	}
 
-cchunk_out:
-	kfree(pcchunk);
-	kfree(retbuf);
-	if (rc)
+out:
+	kfree(cc_req);
+	kfree(cc_rsp);
+	if (rc) {
+		trace_smb3_copychunk_err(xid, src_file->fid.volatile_fid,
+					 dst_file->fid.volatile_fid, tcon->tid,
+					 tcon->ses->Suid, src_off, dst_off, len, rc);
 		return rc;
-	else
-		return total_bytes_written;
+	} else {
+		trace_smb3_copychunk_done(xid, src_file->fid.volatile_fid,
+					  dst_file->fid.volatile_fid, tcon->tid,
+					  tcon->ses->Suid, src_off, dst_off, len);
+		return len;
+	}
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
index fd650e2afc76..28e00c34df1c 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -266,7 +266,7 @@ DEFINE_EVENT(smb3_copy_range_err_class, smb3_##name, \
 	TP_ARGS(xid, src_fid, target_fid, tid, sesid, src_offset, target_offset, len, rc))
 
 DEFINE_SMB3_COPY_RANGE_ERR_EVENT(clone_err);
-/* TODO: Add SMB3_COPY_RANGE_ERR_EVENT(copychunk_err) */
+DEFINE_SMB3_COPY_RANGE_ERR_EVENT(copychunk_err);
 
 DECLARE_EVENT_CLASS(smb3_copy_range_done_class,
 	TP_PROTO(unsigned int xid,
-- 
2.50.1

