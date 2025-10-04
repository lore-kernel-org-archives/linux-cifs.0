Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB21122DFB5
	for <linux-cifs@vger.kernel.org>; Sat,  4 Oct 2025 02:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759544104; cv=none; b=TnVBwisw+31pyHg/bV4JiQIa1/vP7ThhJO9vzsmpxZUg899FShjpPSrjrzKsCjzhfN+86osa1Fhl/NpXWkUYvEzQnZwmfkLqpqblPtzRzw8MqNA6098znCj43/UR/EdQykl3U4IRTG9EOwE97EQu4pROt0sTZZFGEMT10K8SLmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759544104; c=relaxed/simple;
	bh=T0H3iI2Ev65WGFXmvIj0z6oJjKRSN7i7dBfAw/8/a3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aQmo4vaIz7HeyLOKCpN82t/R+hOSuFF8LuYIvPQbiZK99BOuQEu3P7igSW10Pm228KXZKsNmtT69vl8hR2810TVg2V4Cd4wiD2BHrPBT8MtmQrrf9x5EWiKtE8OcSdYkkZes58KFMmOxQgRcFsfVdSq9g1VMZ8qXNMQsBQeI+U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GkchAn9O; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GkchAn9O"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-421b93ee372so1353486f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 03 Oct 2025 19:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759544099; x=1760148899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BOU+uBmrLUiSqdO3SLzf1cDNaG0CZP9TTZtQDC3kNeU=;
        b=GkchAn9Odjia0cKubh1joH3HdidUOA2GgYVg1ljhrOQCkYJ+KcCG7Hcq3tkoXJ0iZC
         WDduyqsU5xzC4fYP7VJQhKCFqvNpQ46cjTaBqquGIcauZ4q5iYUUH/IOlM3a3fFLMJ9g
         Lpf54dDPCAGEqbcyZ8dYqmG7p59NCiwiZpfDK/hd/KnqQUNTqwIRfbTcS5+7x9KSmUyE
         bfGqZKA9+w+GDbpbSW9rVTdG9BLXCppFQ5FnB5ascGsapzvgt0FZvUnQCliQ/jYzAPta
         wFAYK3DOZKGPC8JgEYfXSoV2HoCTz8SzzA0XhtiOTF7JWVQC+D1Y+rhondo3Gyq/HX8r
         4Zkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759544099; x=1760148899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BOU+uBmrLUiSqdO3SLzf1cDNaG0CZP9TTZtQDC3kNeU=;
        b=hhKyeW1XK1GrxtsEY7jyu2kiy7VOdZ9Y/hJSdEEWdn3JxIAoa0O+h1Vps6vgwM3snl
         m0vxcacFOwkEsnjN91NJpr7phf0YV3/2UUj5t+nGfW1nOHqjz8V7S7I7KPnbnTkIJSf/
         is5RnrPqceRYwPVMHZwfY2IS8W9DWxTjty9R7fovJJFvcaU/nj7pdeBzwbQihXFpG6Yl
         upBtGoIAocpqWaW/roNCuP7PoO1F2UbIZhzo4afbXERly6rnrEO81PL/V5GejYwJjuQm
         hZ4YctQZT8ytr/ixlJ/DVjozPlfCKY2bGSr7BpBfEvPwdLh/86rdtlt9zvjumEfn9Fi7
         ttyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuruak/PQsV1d8wzrTIol0rlc3sCzlBKLhmfbDHQCoitVv4b+ki5irj96CFRNHBKH+9Jh0Sp9bBHDo@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe7xjnbnbHk4oPppMI7Y1uzfD8v7nqE3Fi1yNnYkejQJnm1A6U
	3BYiTKd7/RhQppIztD0UZiBI5OYfYZkO57WTPcfQuQvIbJp5iI7EK9Lhv7QLSfZGoEo=
X-Gm-Gg: ASbGncv6ERdrcDMHm0RkGfEnZAdNSQwJVXXuX9L176y0N2xkgo1AtL4K3Mdn8/RvVSO
	3kcERWJOUeyTDHvccztUKn8mgXJJtipVmu1/ivvlU5Op8BRWMu3nBLOTL5F+f6Pml9w9mS1gwme
	nfUiMWkBubFAEOVMXWqZ97U6LK/MQIIQXBUYjp2O2wZhdIiUtLq4jUd8MAxIuBsszbSe6CzvEsW
	Q3BYF/odqYip15QFKUacT1QmsiFFrunnDxTbXaAhP4RRfqbkJ56ST3iTRjQN6OLa8yY1fRKrsGb
	wbnfDYeCWDmux9x+Xv2ISP3EjNzhowOCj5cr/A43taWzuWp4DrN8vBQDi5dF7Gq4kpzrvf3OehM
	+3L1DsBgnIAHR4wwv5Fnd1mIkBLtCWr7AjWr4OI7UJIIZJY5iZF/G
X-Google-Smtp-Source: AGHT+IH/BujYi+UaiXNp2YgtdftuG+uM/sy381rE2UPNyszkwK0HdsYUPe6hZeLj1EuSKTGKFFqr+Q==
X-Received: by 2002:a5d:5d0b:0:b0:3fe:4fa2:8cdc with SMTP id ffacd0b85a97d-425671c3b54mr3006105f8f.60.1759544098889;
        Fri, 03 Oct 2025 19:14:58 -0700 (PDT)
Received: from precision ([2804:7f0:bc01:751:618a:117f:a8e:defe])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1108b8sm63455745ad.26.2025.10.03.19.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 19:14:58 -0700 (PDT)
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
Subject: [PATCH v4] smb: client: batch SRV_COPYCHUNK entries to cut round trips
Date: Fri,  3 Oct 2025 23:11:43 -0300
Message-ID: <20251004021143.230223-1-henrique.carvalho@suse.com>
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

This reduces the number of IOCTL requests for large copies.

While we are at it, rename a couple variables to follow the terminology
used in the specification.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V3 -> V4:
- fix min_t truncation to u32 issue in calc_chunk_count

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



 fs/smb/client/smb2ops.c | 306 +++++++++++++++++++++++++---------------
 fs/smb/client/smb2pdu.h |  16 ++-
 fs/smb/client/trace.h   |   2 +-
 3 files changed, 207 insertions(+), 117 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 058050f744c0..80114292e2c9 100644
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
+	return (u32)umin(need, umin(max_chunks, allowed));
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

