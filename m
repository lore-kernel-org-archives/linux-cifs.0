Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF193D9DC1
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418499; cv=none; b=oRPeJefqMS04TR64WZDkhKZg4omypz8UJxdXvf0AW2s6tuh1B2XlAehd07pi3lDbIyLOmP7C0UlR6aajjNx6fOXlJL3UjhxMHdUlEy1PEQDGavD8Yxf3QwqUVRfZgSEJYIkFjT53CgDmktqM1cgthEi8Xu4inFODut3ruc3dJkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418499; c=relaxed/simple;
	bh=9SSnAY/UZjvbj7R0rcIVSXBXslifaW03859KdGB7OrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuPgKzI1gZIygFNACXcE9js1fb+dWMCiElglq51KAtg0Zz7Yo/OE1ehBR3nr5VNGxhomejM2tcbOzhNf/eFIxC/Pk6NAT5jI7oEx0OmI6Qq3cFuag9jnm8jK+36X1AJ55Z2YqfjX6gUG7d5TeDXiMsWaJlCdc5sNQXimUJHQd+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ombwk2/R; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ombwk2/R"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so4142606f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418497; x=1784023297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3J8P9gpL4+tY2X3FIem/HTRnl9hsbjK7wkPCVwDKbk8=;
        b=Ombwk2/RtZ/S8BQ4FV43tbLvvyHTa/mNxXdxzSBQfZa5+8c2yOPwCS4jBhK6IJYlX2
         4y8kJlsbAkH23sCmiTJuJAPYNA+JEFR7rfAgYUa3v4M3IHL+9WpNY2zWsG9Xap+ZaLnf
         UITtSK7Ecq2/iWqpOWmGtmUGidTzUky+gCfoDmRJ0V06edHxHg4OXbWWp2tbgpDZmpwu
         jkvx0mcreDA2LWjmH0YHkMbgz8gXDKqpc9Ny8K7MVl6x/Y/GJZUiKQuXPJTLt8pNpNAr
         HeKVFDRryhrqQOq6QvJF3hSH8mDtj0ntTdkI1Ws18j/h4aYrZjntlXdkwg8H2lxu2BDW
         U3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418497; x=1784023297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3J8P9gpL4+tY2X3FIem/HTRnl9hsbjK7wkPCVwDKbk8=;
        b=O9QckfIf7iBaJY23BgiCrTNG+GCbjFhjXl1y528/3Haxhs4z3FxqNYBvma5mJjGf7z
         xe/Fie6Ne2KSE3Xdnb8tuEQIuU72mABaHWAahoYtkYbJGUKEEDuMuCltcPcCBVxnFAvB
         kHkqGoto7V+pr+pBHYYbV8DYBUitaN4SgrffBOXF889IFE9lipEQUvGxgSFtEeJ7DOVb
         ougxqn7owz5JfA5tbUXC7cF8kTKXx31LdmdNNAa8kSdEMTU2PS6VgYBXYibS9Qnnr4gB
         1Pp/ILYlmdP3nar8K6XbWsKgH9x0a1L/z55RSLWg/alASyFeLUFg0rxqpcQaR1pk/SSh
         D19Q==
X-Forwarded-Encrypted: i=1; AHgh+RpD3O+lKIE+TrFGLbT7JANHfrtkql1fItZY6EhYcHRa8xy3wI7V4r24MXMWmGQPTlYlB0EsMGh+N1pR@vger.kernel.org
X-Gm-Message-State: AOJu0YyaiHEgC3NpjmIpucio9OW/E33N1V1RPAL+q773XU5P2iv4Y+mu
	oX+A+h4ZPmDGdcPGeZ4zUZII20v89qUz+BAR6laVupC/Eh79xKppyLoPQVsHabwm
X-Gm-Gg: AfdE7cnssLT15HwPnsA2l/mrkACV/fXr7j9xJ82Q0Y/XCS+1Gk/4STFbM9dX5c+4k18
	zqoBJWbrCNYkWkytoizA94ng1ea7oT5yaTD8ww9CVcEp+AQElfUqODrHZzS4nxOAwO8g2av26l0
	osRmcOH1izCk/Zt07g5iXoUknRI2PminjZH1OHpW53dRc568Um4HH2ddvxJ/uVUexDms0YjmvZN
	4mPZZfxoCXnjx2H8jkJCRiYuR7JKgfCfnJ+tcQDCiCOmvQ0NBVsU7Omwu/lf0ZBh3T7D6i6FZny
	mgCVuw0c8lrUAn9u8p5AkX5yRrIMKDa2seoJBjBhhPZilaprk7nnvUmRBubjyoffFN+MjzzyEwl
	MseY4fqash4KgXIZmkHpWqxag3GF7ZVTheD/uZfEeY92Hebu9G1/3JkJBQux5eWB4nrjHzaBChJ
	sGBZikziUBrrR4P7fOjeZ3ZY2/4K6vvBoCos0=
X-Received: by 2002:a5d:6991:0:b0:477:80fa:f44d with SMTP id ffacd0b85a97d-47de66db347mr3156946f8f.40.1783418496617;
        Tue, 07 Jul 2026 03:01:36 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm32203122f8f.8.2026.07.07.03.01.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:36 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 5/5] ksmbd: implement full-file copy for AAPL ChunkCount=0 COPYCHUNK
Date: Tue,  7 Jul 2026 12:01:28 +0200
Message-ID: <20260707100129.47563-6-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100129.47563-1-g.blivet@me.com>
References: <20260707100129.47563-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

fsctl_copychunk() treats FSCTL_SRV_COPYCHUNK with ChunkCount=0 as the
standard SMB2 "query my copy limits, don't copy anything" request and
returns success without ever looking up the file handles. That's
correct for compliant SMB2 clients, but macOS Finder's Cmd+D duplicate
sends ChunkCount=0 expecting the server to copy the whole file -- so
duplicated files (and streams) are left at their just-created 0 bytes
while the client reports success.

Scope the full-copy fallback to AAPL-negotiated connections
(conn->is_aapl) only, so standard non-Apple SMB2 clients keep the
spec-correct query-limits behavior unchanged. Handles both the main
data fork (loop over vfs_copy_file_range, since file size doesn't fit
in a single wire chunk's 32-bit Length field) and the ADS
stream-to-stream path (report the actual xattr bytes copied instead
of always reporting 0 when there's no real chunk list to sum).

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 38 +++++++++++++++++++++++++-------------
 fs/smb/server/vfs.c     | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 63beb2bcd..8546cbda0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8843,23 +8843,35 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 		cpu_to_le32(ksmbd_server_side_copy_max_total_size());
 
 	chunk_count = le32_to_cpu(ci_req->ChunkCount);
-	if (chunk_count == 0)
+	/*
+	 * ChunkCount=0 is the standard SMB2 "query my copy limits" request
+	 * (no data copied) -- but macOS Finder's Cmd+D duplicate sends
+	 * FSCTL_SRV_COPYCHUNK with ChunkCount=0 meaning "copy the whole
+	 * file", relying on the AAPL-negotiated server to do a full copy
+	 * instead. Keep the standard no-op behavior for everyone else.
+	 */
+	if (chunk_count == 0 && !work->conn->is_aapl)
 		goto out;
 	total_size_written = 0;
+	i = 0;
 
-	/* verify the SRV_COPYCHUNK_COPY packet */
-	if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
-	    input_count < struct_size(ci_req, Chunks, chunk_count)) {
-		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
-		return -EINVAL;
-	}
+	if (chunk_count) {
+		/* verify the SRV_COPYCHUNK_COPY packet */
+		if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
+		    input_count < struct_size(ci_req, Chunks, chunk_count)) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			return -EINVAL;
+		}
 
-	chunks = &ci_req->Chunks[0];
-	for (i = 0; i < chunk_count; i++) {
-		if (le32_to_cpu(chunks[i].Length) == 0 ||
-		    le32_to_cpu(chunks[i].Length) > ksmbd_server_side_copy_max_chunk_size())
-			break;
-		total_size_written += le32_to_cpu(chunks[i].Length);
+		chunks = &ci_req->Chunks[0];
+		for (i = 0; i < chunk_count; i++) {
+			if (le32_to_cpu(chunks[i].Length) == 0 ||
+			    le32_to_cpu(chunks[i].Length) > ksmbd_server_side_copy_max_chunk_size())
+				break;
+			total_size_written += le32_to_cpu(chunks[i].Length);
+		}
+	} else {
+		chunks = &ci_req->Chunks[0];
 	}
 
 	if (i < chunk_count ||
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index be93a8ec9..222e8b63d 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1854,6 +1854,13 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 				return sret;
 		}
 
+		if (chunk_count == 0) {
+			/* AAPL full-stream-copy request: report actual bytes copied. */
+			*chunk_count_written = 1;
+			*total_size_written = buf_len;
+			return 0;
+		}
+
 		/*
 		 * macOS reuses the main file's chunk list for stream copies,
 		 * so req_total equals the file size, not the stream size.
@@ -1868,6 +1875,40 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 
 	smb_break_all_levII_oplock(work, dst_fp, 1);
 
+	/*
+	 * macOS Finder's Cmd+D duplicate sends FSCTL_SRV_COPYCHUNK with
+	 * ChunkCount=0 meaning "copy the whole file", not the standard
+	 * SMB2 "query my copy limits, no data" semantics -- fsctl_copychunk()
+	 * only reaches here with chunk_count == 0 for AAPL-negotiated
+	 * connections, so this doesn't affect compliant non-Apple clients.
+	 * Without this, the destination stays at its just-created 0 bytes.
+	 */
+	if (chunk_count == 0) {
+		loff_t size = i_size_read(file_inode(src_fp->filp));
+		loff_t off = 0;
+
+		while (off < size) {
+			ssize_t copied = vfs_copy_file_range(src_fp->filp, off,
+							     dst_fp->filp, off,
+							     size - off, 0);
+			if (copied == -EOPNOTSUPP || copied == -EXDEV)
+				copied = vfs_copy_file_range(src_fp->filp, off,
+							      dst_fp->filp, off,
+							      size - off,
+							      COPY_FILE_SPLICE);
+			if (copied < 0)
+				return copied;
+			if (copied == 0)
+				break;
+			off += copied;
+		}
+
+		*chunk_count_written = 1;
+		*chunk_size_written = (unsigned int)min_t(loff_t, size, UINT_MAX);
+		*total_size_written = off;
+		return 0;
+	}
+
 	if (!work->tcon->posix_extensions) {
 		for (i = 0; i < chunk_count; i++) {
 			src_off = le64_to_cpu(chunks[i].SourceOffset);
-- 
2.43.0

