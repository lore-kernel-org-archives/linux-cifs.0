Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3788B1EB19B
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 07:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901675; cv=none; b=I8mSivKnc930jc6b9FsbxOwgZJ5bcCsLsMo/TFzM9O1Iq2vv/HPKyvkAqpe4oDcQrDfqjvadUBqejiekQ3z3BKbxY/cyNB0TYDzkBihQ07i0CBEqIFm1s8hQOPR+gTsirO5aWujxJY2RBbA8luFhiGgU+K5kQbht7lGmzQjd860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901675; c=relaxed/simple;
	bh=0dp/3RM7+loCtoyLW4pMBr+2Ywhpq9qqHDlPA0TK29s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmhfFp0uHXSwB49/uoLfLPI0sUIHKdBX+i7fHuOAVVz+641Bq6i188dAf2PIc8RlaDmYZ4ZG0hsxlW9uuHQx+d9s6xhMezSq0zj2LxF6F5eZUN7A8H354mSAW/8l8mUl2cYc1Q5Q5TNF0nDNwaTBH0pV+tGdnKfQTW9WIVnn/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KpEF+LtU; arc=none smtp.client-ip=95.215.58.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KpEF+LtU"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0dp/3RM7+loCtoyLW4pMBr+2Ywhpq9qqHDlPA0TK29s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901671; v=1; x=1788506471;
 b=KpEF+LtUhMeQYmIaay7kDjTVGQ2lqTKvoWnKsBQ9Aat5+xIW4/kLTnIATJGRXVX1q0XH55PG
 vQoewXZNuVsxioNwAN4RUZZD+INq+zvKMTJ3K4QisZF1qX/VXqA3DoA7K0VJm1NLQqGvb4qYsdD
 w5OWhFtmNGLiS7QzaQTRArho=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 668120c09f3d3efd;
	Fri, 28 Aug 2026 07:21:10 +0000
X-Mizu-Trace-ID: 668120c09f3d3efd
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 4/7] smb/client: fix data corruption in emulated insert range
Date: Fri, 28 Aug 2026 15:19:32 +0800
Message-ID: <20260828071935.552165-5-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828071935.552165-1-huiwen.he@linux.dev>
References: <20260828071935.552165-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

smb3_insert_range() shifts [off, EOF) right with COPYCHUNK, copying from
low to high offsets. When the ranges overlap, the copy can overwrite
source data that has not yet been copied. For a 1 MiB insert at offset 0:

  offset:    0       1M      2M      3M      4M      5M
  before:   |   A   |   B   |   C   |   D   |
  expected: | hole  |   A   |   B   |   C   |   D   |
  current:  | hole  |   A   |   A   |   A   |   A   | (corrupted)

Let x be the insertion offset, L the total length to move, delta the
insert length, and C the normal chunk size allowed by the server.
Insert range maps

  [x, x + L) -> [x + delta, x + delta + L).

When delta >= L, the complete source and target ranges are disjoint, so
the normal copy order and chunk size are safe:

  offset: 0       4       8      12      16      20      24      28      32
  source: [--S0--][--S1--][--S2--][--S3--]
  target:                                 [--T0--][--T1--][--T2--][--T3--]

When delta < L, the complete source and target ranges overlap, so the
copy must proceed from EOF backwards. There are two subcases.

If delta >= C, each corresponding source and target chunk is disjoint.
The 1 MiB example has L = 4 MiB and delta = C = 1 MiB:

  offset: 0       1M      2M      3M      4M      5M
  source: [--S0--][--S1--][--S2--][--S3--]
  target:         [--T0--][--T1--][--T2--][--T3--]

Copying S0 from [0, 1M) to [1M, 2M) overwrites S1 before it is copied.
Processing chunks from EOF backwards prevents this inter-chunk
overwrite.

If delta < C, the source and target ranges of a normal chunk also
overlap. For example, with L = 16, delta = 2 and C = 4:

  offset: 0   2   4   6   8  10  12  14  16  18
  source: [--S0--][--S1--][--S2--][--S3--]
  target:     [--T0--][--T1--][--T2--][--T3--]

Here S0 and T0 overlap over [2,4), S1 and T1 over [6,8), and so on.
Backward ordering cannot control how the server copies bytes inside one
descriptor, so the chunk size must be limited to delta.

Fix this by copying overlapping right shifts from EOF backwards. Limit
the chunk size to delta when delta < C so that each chunk's source and
target ranges do not overlap. Using larger chunks would require a way to
identify servers that safely handle overlapping COPYCHUNK descriptors.

Therefore:

  delta >= L:
    keep the normal copy order and chunk size

  delta < L:
    delta >= C: copy backwards and keep the normal chunk size
    delta <  C: copy backwards and limit the chunk size to delta

Only the delta < C subcase requires reducing the chunk size for data
integrity.

Reproducer:

  bash -c '
          MNT=/mnt/scratch

          # Generate four 1 MiB random blocks: [A][B][C][D].
          dd if=/dev/urandom of=/tmp/src bs=1M count=4 status=none

          # With C = 1 MiB, test delta = C and delta < C.
          for delta in 1M 1K; do
                  truncate -s 0 /tmp/expected
                  truncate -s "$delta" /tmp/expected
                  cat /tmp/src >> /tmp/expected

                  cp /tmp/src "$MNT/file"
                  fallocate --insert-range -o 0 -l "$delta" "$MNT/file"

                  if cmp -s /tmp/expected "$MNT/file"; then
                          echo "delta=$delta: OK"
                  else
                          echo "delta=$delta: CORRUPTED"
                  fi
          done
  '

The corruption reproduces with Samba and ksmbd, while Windows handles
the overlapping COPYCHUNK ranges safely.

The 1 MiB case tests delta >= C, while the 1 KiB case tests delta < C.
Before this change, the reproducer reports:

  delta=1M: CORRUPTED
  delta=1K: CORRUPTED

After this change, it passes against both ksmbd and Samba:

  delta=1M: OK
  delta=1K: OK

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2ops.c | 132 ++++++++++++++++++++++++++++++++--------
 1 file changed, 106 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1eff607a1e74..6f17d83c0aec 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1839,31 +1839,31 @@ smb2_ioctl_query_info(const unsigned int xid,
  *
  * @tcon: destination file tcon
  * @bytes_left: how many bytes are left to copy
+ * @chunk_size: maximum size of a single chunk
  *
  * Return: maximum number of chunks with which Chunks[] can be filled.
  */
 static inline u32
-calc_chunk_count(struct cifs_tcon *tcon, u64 bytes_left)
+calc_chunk_count(struct cifs_tcon *tcon, u64 bytes_left, u32 chunk_size)
 {
 	u32 max_chunks = READ_ONCE(tcon->max_chunks);
 	u32 max_bytes_copy = READ_ONCE(tcon->max_bytes_copy);
-	u32 max_bytes_chunk = READ_ONCE(tcon->max_bytes_chunk);
 	u64 need;
 	u32 allowed;
 
-	if (!max_bytes_chunk || !max_bytes_copy || !max_chunks)
+	if (!chunk_size || !max_bytes_copy || !max_chunks)
 		return 0;
 
 	/* chunks needed for the remaining bytes */
-	need = DIV_ROUND_UP_ULL(bytes_left, max_bytes_chunk);
+	need = DIV_ROUND_UP_ULL(bytes_left, chunk_size);
 	/* chunks allowed per cc request */
-	allowed = DIV_ROUND_UP(max_bytes_copy, max_bytes_chunk);
+	allowed = DIV_ROUND_UP(max_bytes_copy, chunk_size);
 
 	return (u32)umin(need, umin(max_chunks, allowed));
 }
 
 /**
- * smb2_copychunk_range - server-side copy of data range
+ * __smb2_copychunk_range - server-side copy of data range
  *
  * @xid: transaction id
  * @src_file: source file
@@ -1875,15 +1875,15 @@ calc_chunk_count(struct cifs_tcon *tcon, u64 bytes_left)
  * Obtains a resume key for @src_file and issues FSCTL_SRV_COPYCHUNK_WRITE
  * IOCTLs, splitting the request into chunks limited by tcon->max_*.
  *
- * Return: @len on success; negative errno on failure.
+ * Return: 0 on success; negative errno on failure.
  */
-static ssize_t
-smb2_copychunk_range(const unsigned int xid,
-		     struct cifsFileInfo *src_file,
-		     struct cifsFileInfo *dst_file,
-		     u64 src_off,
-		     u64 len,
-		     u64 dst_off)
+static int
+__smb2_copychunk_range(const unsigned int xid,
+		       struct cifsFileInfo *src_file,
+		       struct cifsFileInfo *dst_file,
+		       u64 src_off,
+		       u64 len,
+		       u64 dst_off)
 {
 	int rc = 0;
 	unsigned int ret_data_len = 0;
@@ -1891,12 +1891,14 @@ smb2_copychunk_range(const unsigned int xid,
 	struct copychunk_ioctl_rsp *cc_rsp = NULL;
 	struct cifs_tcon *tcon;
 	struct srv_copychunk *chunk;
-	u32 chunks, chunk_count, chunk_bytes;
+	u32 chunks, chunk_count, chunk_bytes, chunk_size;
 	u32 copy_bytes, copy_bytes_left;
 	u32 chunks_written, bytes_written;
 	u64 total_bytes_left = len;
 	u64 src_off_prev, dst_off_prev;
+	u64 max_chunk = 0;
 	u32 retries = 0;
+	bool reverse = false;
 
 	tcon = tlink_tcon(dst_file->tlink);
 
@@ -1904,8 +1906,50 @@ smb2_copychunk_range(const unsigned int xid,
 				   dst_file->fid.volatile_fid, tcon->tid,
 				   tcon->ses->Suid, src_off, dst_off, len);
 
+	/*
+	 * Same-file left shifts are safe in forward order. For a right shift,
+	 * let L be the copy length, delta the distance between the source and
+	 * destination, and C the normal chunk size:
+	 *
+	 *   delta >= L:      copy forwards using C
+	 *   delta < L:
+	 *     delta >= C:    copy backwards using C
+	 *     delta < C:     copy backwards with chunks limited to delta
+	 *
+	 * Copying backwards prevents one chunk from overwriting data needed by
+	 * a later chunk. Limiting the chunk size to delta prevents an individual
+	 * chunk from overlapping itself.
+	 * This limit can be removed once all supported servers handle overlapping
+	 * descriptors safely.
+	 *
+	 * A small right shift over a large range may therefore require many
+	 * chunks.
+	 */
+	if (src_file == dst_file && dst_off > src_off) {
+		u64 delta = dst_off - src_off;
+
+		if (delta < len) {
+			reverse = true;
+			max_chunk = delta;
+		}
+	}
+
+	/*
+	 * A backward copy walks the offsets down from the end of the range.
+	 * Do this once, outside the retry loop, so a retry does not move the
+	 * offsets again.
+	 */
+	if (reverse) {
+		src_off += len;
+		dst_off += len;
+	}
+
 retry:
-	chunk_count = calc_chunk_count(tcon, total_bytes_left);
+	chunk_size = READ_ONCE(tcon->max_bytes_chunk);
+	if (max_chunk && max_chunk < chunk_size)
+		chunk_size = (u32)max_chunk;
+
+	chunk_count = calc_chunk_count(tcon, total_bytes_left, chunk_size);
 	if (!chunk_count) {
 		rc = -EOPNOTSUPP;
 		goto out;
@@ -1946,16 +1990,21 @@ smb2_copychunk_range(const unsigned int xid,
 		while (copy_bytes_left > 0 && chunks < chunk_count) {
 			chunk = &cc_req->Chunks[chunks++];
 
+			chunk_bytes = umin(copy_bytes_left, chunk_size);
+			if (reverse) {
+				src_off -= chunk_bytes;
+				dst_off -= chunk_bytes;
+			}
+
 			chunk->SourceOffset = cpu_to_le64(src_off);
 			chunk->TargetOffset = cpu_to_le64(dst_off);
-
-			chunk_bytes = umin(copy_bytes_left, tcon->max_bytes_chunk);
-
 			chunk->Length = cpu_to_le32(chunk_bytes);
 			/* Buffer is zeroed, no need to set chunk->Reserved = 0 */
 
-			src_off += chunk_bytes;
-			dst_off += chunk_bytes;
+			if (!reverse) {
+				src_off += chunk_bytes;
+				dst_off += chunk_bytes;
+			}
 
 			copy_bytes_left -= chunk_bytes;
 			copy_bytes += chunk_bytes;
@@ -2003,6 +2052,18 @@ smb2_copychunk_range(const unsigned int xid,
 				goto out;
 			}
 
+			/*
+			 * A successful COPYCHUNK should copy every descriptor (MS-SMB2
+			 * 3.3.5.15.6). Reject a short backward copy because the rewind
+			 * below only supports forward copying.
+			 */
+			if (unlikely(reverse && bytes_written < copy_bytes)) {
+				cifs_tcon_dbg(VFS, "Copychunk short write %u/%u (reverse)\n",
+					      bytes_written, copy_bytes);
+				rc = -EIO;
+				goto out;
+			}
+
 			/* Partial write: rewind */
 			if (bytes_written < copy_bytes) {
 				u32 delta = copy_bytes - bytes_written;
@@ -2064,10 +2125,27 @@ smb2_copychunk_range(const unsigned int xid,
 		trace_smb3_copychunk_done(xid, src_file->fid.volatile_fid,
 					  dst_file->fid.volatile_fid, tcon->tid,
 					  tcon->ses->Suid, src_off, dst_off, len);
-		return len;
+		return 0;
 	}
 }
 
+static ssize_t
+smb2_copychunk_range(const unsigned int xid,
+		     struct cifsFileInfo *src_file,
+		     struct cifsFileInfo *dst_file,
+		     u64 src_off,
+		     u64 len,
+		     u64 dst_off)
+{
+	int rc;
+
+	rc = __smb2_copychunk_range(xid, src_file, dst_file, src_off, len,
+				    dst_off);
+	if (rc)
+		return rc;
+	return len;
+}
+
 static int
 smb2_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
 		struct cifs_fid *fid)
@@ -3992,7 +4070,6 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	u64 count;
 	loff_t old_eof, new_eof;
 
 	xid = get_xid();
@@ -4011,8 +4088,6 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	if (rc)
 		goto out;
 
-	count = old_eof - off;
-
 	/* SET_ZERO_DATA creates a hole only in a sparse file. */
 	rc = smb2_set_sparse(xid, tcon, cfile, inode, true);
 	if (rc)
@@ -4036,7 +4111,12 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	spin_unlock(&inode->i_lock);
 	fscache_resize_cookie(cifs_inode_cookie(inode), i_size_read(inode));
 
-	rc = smb2_copychunk_range(xid, cfile, cfile, off, count, off + len);
+	/*
+	 * Move [off, old_eof) right by len. The helper copies backwards if the
+	 * source and destination ranges overlap.
+	 */
+	rc = __smb2_copychunk_range(xid, cfile, cfile, off, old_eof - off,
+				    off + len);
 	if (rc < 0)
 		goto out_2;
 	spin_lock(&inode->i_lock);
-- 
2.43.0

