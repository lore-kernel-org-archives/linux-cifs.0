Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91002F9E8
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555626; cv=none; b=ipLwWd5M3IxeralH8MtYe4Jz1L9k6n5j/1ic5OQokIc7CNYGZSaERvKHgLEwP5TukSOuK+reOmZ7uT+IfpCgIs3Y7h+OCkkHFxnSd0IQGKZyfro538tp3N3DDc/fuhMLACf/xTGUg1NDjBPEDEItYiWQ1dBtZD+4rHQxgFbJIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555626; c=relaxed/simple;
	bh=dske+wl4ZXpV2jFDjvKnA76glF3K8yNVhxiHDLvYr1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iye4mFtd3sZimpxuOXh4hV8hC4XzpwgrdsGdmde73fXlsiWrfSEOps7er5fwUX7eOrUWhNYxInNAPZ0kFdORZK0ymOflSUEmYR57MFkf8yPTrU5wgbK7VyDYA2ay/n4DYlPGQnRzeG1U+4KXaPVhaEKLlKMqAOKAXonbaZibicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=plyx17FC; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="plyx17FC"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493b77b150aso9857305e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555623; x=1784160423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j4/k63MlV5hiqJRHxBCiq+ZEAm5pjoGvf58C2kdNmEY=;
        b=plyx17FCEl10y6MevvS6RO/R3LFcd+fzgQbfmG67DDHYJUNPWdUxKXHIMK8JcPjfW5
         832/VBGHZuFkeaYI4sfpX5nuueQ9PIfNww6YsnQH3F0/lOYpmZJPFXLyUvfHLELdrQdo
         rrMgK/94nF6FevY55Sd3tRCVUJS2+ApK40L+SUkmlppWqSc8aMSPTOKCxp5/E4kX7IqK
         Ha8sGSVpUNeCl73+M1Ba3MDnqhM/+kQQKowfGCLztiy4DCNX2CYFesTfGhzlZLIS31V3
         eko2H33A4uHhh+kYh64wC0G+weosQfEuQYhKCbVBcGjiCtLQstW48tqGgHKQKgo7th6B
         aeEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555623; x=1784160423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j4/k63MlV5hiqJRHxBCiq+ZEAm5pjoGvf58C2kdNmEY=;
        b=J/B4I6qkEG9oA2/mP6Wfs583peHaXQQ+7CeNqDZeSYConWvfgUx38OuLftM4ZLVNHM
         Fvn7NXm94I+6lGG2r7YdhOTXGQgfasg0gy8kyd59jG1CZuA/nAhvz1MrA1KIN0WOe/7T
         iPlT1oPdGKL3qrvqyiyYMkQyvf7+FluKNJmUBsWPpYMcLyUBcQF0j7/30+Fbvtq1AxBb
         cZcjpZQDd+Yuj4X9Vwppp54ENhrAAsho2YWBfvYRu2LzT4D6M5aNgf39s1yH7TE/VYDm
         c8L/k9BytB4KCPcMSJTEOsDcte31UElH4qYeDbNTU81FGVhcHvjDuXWHOZSD7EZvE1hY
         8Raw==
X-Forwarded-Encrypted: i=1; AHgh+RqF2qO4AHBBoD4+hAv7gwId9g5yTjzitVa+/oM8IkC+TCPnm6I+oGco+1npvJPJMHYQLfgZ+JSRPAw2@vger.kernel.org
X-Gm-Message-State: AOJu0YxDCjw+i4nWXdlsye9dvfGfIhn5CmJIpIbQOYvu1yOQKJWN+m5b
	kpRYFx+0eCsVT7scx7fDUIhXGHJBefVZkH8r1OADMCNsfjfIY4HL9fags3Imz8JX
X-Gm-Gg: AfdE7ckhHB6VVUcjT1SFOXCOlK0QpknVaTUr+Xt5fxLELGt9kptyde/uUg2K8xWtI6Y
	xR2MNM0LbcKt79BhOBQZuUR6iVlcErVWl+CNJ8gZSYDQmCoGYWQ4Lr3onYnl4JdTG9itDV0/dYE
	jV+Pv+eJOCZL13RMCQdS9Rtb+TNQvR9OXuoJ/fZJscXlvtSfKAoc6QMZwPGkcGWq42BYA6Mu2Yy
	DhH2yEJltrOneiYa125uVl80WAs/CYtmpo6KFHAIJeehHqwkPI4lEw6y7OwuixSXfAHXX4Dm0l4
	XJR7KlrR1t8nG+XC/iTll43NNeU0HIw++1Wfo/cNnfH9w/nvNCkYLjU78/PjegLysFjRLbVj6Fx
	HVnWlrRHVdHb7lrHSsYeAcGO+Yx8QckxOTgI5BxneKkdG7ZwwjqtfuxfQO4XB7u8/KF758O4g/T
	dRUwjIY0zWe5T2TIu6PD9kcv7cOSWoPZZEO1U=
X-Received: by 2002:a05:600d:8497:20b0:493:b55f:bca4 with SMTP id 5b1f17b1804b1-493e68cec61mr35049545e9.29.1783555622858;
        Wed, 08 Jul 2026 17:07:02 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm15981925e9.0.2026.07.08.17.07.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:07:02 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 5/6] ksmbd: implement full-file copy for AAPL ChunkCount=0 COPYCHUNK
Date: Thu,  9 Jul 2026 02:06:11 +0200
Message-ID: <20260709000618.66534-6-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000618.66534-1-g.blivet@me.com>
References: <20260709000618.66534-1-g.blivet@me.com>
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
sends ChunkCount=0 expecting the server to copy the whole file/stream
-- so duplicated files are left at their just-created 0 bytes while
the client reports success.

Scope the full-copy fallback to AAPL-negotiated connections on a
Time Machine share (conn->is_aapl && KSMBD_SHARE_FLAG_TIME_MACHINE)
only, so standard non-Apple SMB2 clients, and AAPL-negotiated clients
on ordinary shares, keep the spec-correct query-limits behavior
unchanged.

Re-derived against the copychunk rework in
commit 8afe741dbd67 ("ksmbd: support copychunk for alternate data streams")
and commit 165e5b86fd2c ("ksmbd: handle AAPL stream copy length mismatch"):
both streams and regular files now share a single chunk_count == 0
fast path added right after src_file_size is computed, reusing the
same buffered-copy helper and vfs_copy_file_range()/COPY_FILE_SPLICE
fallback the existing per-chunk loop already uses, rather than the
separate xattr-specific get/setxattr path this used before that
rework.

ChunksWritten/ChunkBytesWritten are 0 in the response: this is a
synthesized whole-file copy, not a response to any chunk descriptor
the client actually sent (it sent none), so there's no real chunk to
report the count/size of. Only TotalBytesWritten is meaningful here.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
v1 -> v2: Re-derived against the copychunk rework that landed upstream
since v1 (commit 8afe741dbd67, commit 165e5b86fd2c), which replaced
the separate xattr-specific stream-copy path this used with a unified
chunk_count == 0 fast path shared by streams and regular files. Also
fixed ChunksWritten/ChunkBytesWritten in the response: v1 reported
ChunksWritten=1 and a nonzero ChunkBytesWritten, describing a chunk
the client never sent (it sent zero); now both are 0, matching a
value actually validated against a real client.

 fs/smb/server/smb2pdu.c | 47 +++++++++++++++++++++++---------
 fs/smb/server/vfs.c     | 59 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ed5b132b8..612f8c8ec 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8934,23 +8934,44 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 		cpu_to_le32(ksmbd_server_side_copy_max_total_size());
 
 	chunk_count = le32_to_cpu(ci_req->ChunkCount);
-	if (chunk_count == 0)
+	/*
+	 * ChunkCount=0 is the standard SMB2 "query my copy limits" request
+	 * (no data copied) -- but macOS Finder's Cmd+D duplicate sends
+	 * FSCTL_SRV_COPYCHUNK with ChunkCount=0 meaning "copy the whole
+	 * file", relying on the AAPL-negotiated server to do a full copy
+	 * instead. Keep the standard no-op behavior for everyone else.
+	 *
+	 * Gate on the TIME_MACHINE share flag, not just conn->is_aapl:
+	 * that flag alone has ambiguous provenance -- the pre-existing
+	 * narrow UniqueId=0 path can also set it on ordinary,
+	 * non-Time-Machine shares, and this series' stated design keeps
+	 * every AAPL-driven behavior opt-in per share.
+	 */
+	if (chunk_count == 0 &&
+	    !(work->conn->is_aapl &&
+	      test_share_config_flag(work->tcon->share_conf,
+				     KSMBD_SHARE_FLAG_TIME_MACHINE)))
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
index 7f7e73915..61d02322c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1858,6 +1858,65 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 		src_file_size = i_size_read(file_inode(src_fp->filp));
 	}
 
+	/*
+	 * macOS Finder's Cmd+D duplicate sends FSCTL_SRV_COPYCHUNK with
+	 * ChunkCount=0 meaning "copy the whole file/stream", not the
+	 * standard SMB2 "query my copy limits, no data" semantics --
+	 * fsctl_copychunk() only reaches here with chunk_count == 0 for
+	 * AAPL-negotiated connections, so this doesn't affect compliant
+	 * non-Apple clients. Without this, the destination stays at its
+	 * just-created 0 bytes / empty stream: the for loop below is a
+	 * no-op when chunk_count is 0, since it never has an iteration to
+	 * treat as "copy everything".
+	 */
+	if (chunk_count == 0 && work->conn->is_aapl) {
+		loff_t off = 0;
+
+		while (off < src_file_size) {
+			size_t remaining = src_file_size - off;
+			ssize_t copied;
+
+			/* Same source/destination offset here: an in-place,
+			 * same-inode copy at matching offsets is a degenerate
+			 * no-op range, not a real overlap, but vfs_copy_file_range
+			 * still doesn't support streams -- route those (and the
+			 * same-inode case defensively) through the buffered path.
+			 */
+			if (ksmbd_stream_fd(src_fp) || ksmbd_stream_fd(dst_fp) ||
+			    file_inode(src_fp->filp) == file_inode(dst_fp->filp)) {
+				copied = ksmbd_vfs_copy_file_range_buffered(work, src_fp, dst_fp,
+									    off, off, remaining);
+			} else {
+				copied = vfs_copy_file_range(src_fp->filp, off,
+							     dst_fp->filp, off,
+							     remaining, 0);
+				if (copied == -EOPNOTSUPP || copied == -EXDEV)
+					copied = vfs_copy_file_range(src_fp->filp, off,
+								     dst_fp->filp, off,
+								     remaining,
+								     COPY_FILE_SPLICE);
+			}
+			if (copied < 0)
+				return copied;
+			if (copied == 0)
+				break;
+			off += copied;
+		}
+
+		/*
+		 * This is a synthesized whole-file copy, not a response to
+		 * any chunk descriptor the client actually sent (it sent
+		 * none -- chunk_count is 0). Report zero chunks/chunk-bytes
+		 * rather than inventing a chunk that doesn't correspond to
+		 * anything in the request; only total_size_written (bytes
+		 * actually copied) is meaningful here.
+		 */
+		*chunk_count_written = 0;
+		*chunk_size_written = 0;
+		*total_size_written = off;
+		return 0;
+	}
+
 	for (i = 0; i < chunk_count; i++) {
 		bool stream_len_mismatch = false;
 		size_t copy_len;
-- 
2.43.0

