Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88777303A37;
	Thu,  9 Jul 2026 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609555; cv=pass; b=ATKDbsfIWYEv00XILpqkz0u5tLMtYeeZA0bivrpO+G6cgEFrB+X787R5v0UYKDFAKYqIVAOwjqVhghr2ph1xymhYHeddPrV0T6dkMUdN0lQ4vU7dt4hArUfbAi/y0riY9EDh6YBPMN7/pioSRNp/sByAmWVdyGUWqq7jDiH+8RU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609555; c=relaxed/simple;
	bh=lW5w4rJ6lJfUVdUKIE3nxgsB1rp02op0xBZtBbQFAf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qR/9ZUknuAqcrROvtNj7RtezRj9NaL/gaHkSS/JdwwSbbZDagCnqVE0kofg1dVCXHTYPta07kbC4JSC0hJkPX3u8EDeFtrqS/20tZ0MjJWq7fRRKX1Z/T9fSDTUsytivKPLWZehiZKVGLSfUVliaW6EnIym99Snn3LSs7uvrAy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=rfji3g6V; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="rfji3g6V"
ARC-Seal: i=1; a=rsa-sha256; t=1783609538; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=S0b7rZSJ+Jlt4tDf9s8BoSFiHnx4sKNXWp5mvLB/GXIn1TJVzOyRYg5unGXPgjc6FfX38gOeJOtCevKaG1uJ27dl73troFk0ZFhFEkP7ScBg0xRjEtwaZfwZ13lKgQPY6byC69YKwnTqyxrSC/f+b/NUjPFV14ti280OuVgKFx8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783609538; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EXmsW/RhYhGtF833Y5co0f1Tuuz3iA9wVlDONP/0ExM=; 
	b=f1jCib59yeDC9Y1KxRN512AoJmWJHWqV2a0MqPvEryPLBs6hXWBQu0zUw53kracK3m879xDL3J+ia7u3vJeXdv71NDLfHctSqDvYIvd4cT4oEBWkMg1UiUUIBB3eIRdZrUs9+I0z5Nfc7TwqWx8k0zfGOJT4IdTkbUulYctV35Y=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783609538;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EXmsW/RhYhGtF833Y5co0f1Tuuz3iA9wVlDONP/0ExM=;
	b=rfji3g6VLjbqn9Nf+KYThCJhm0JhbijYXr5GTKI4WH1BHkwUee5VzoEtAVU7Lz0i
	jUWDqErhwspme/K55RfxG7UkOBXTLBfQkZtE+FGGacAPKlZIqOVFzQoPMpYVGlWNNco
	YYvLqhZYGZhoP/m8h5Gi6DURwZEFik3ofqmmNUdE=
Received: by mx.zoho.eu with SMTPS id 1783609535703103.42874894345334;
	Thu, 9 Jul 2026 17:05:35 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix integer overflow in set_file_allocation_info()
Date: Thu,  9 Jul 2026 17:05:30 +0200
Message-ID: <20260709150530.44979-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

set_file_allocation_info() converts the client-supplied
FILE_ALLOCATION_INFORMATION::AllocationSize into a 512-byte block
count with:

	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;

AllocationSize is a fully client-controlled __le64 field; the only
validation performed by the caller (smb2_set_info_file(), case
FILE_ALLOCATION_INFORMATION) is that the fixed buffer is at least
sizeof(struct smb2_file_alloc_info) == 8 bytes. The value itself is
never range-checked before this arithmetic.

When AllocationSize is close to U64_MAX (e.g. 0xffffffffffffffff),
"AllocationSize + 511" wraps around mod 2^64 to a small number
(0xffffffffffffffff + 511 = 510), so alloc_blks becomes 0. Since any
existing regular file has stat.blocks > 0, the function then takes
the "shrink" branch and calls:

	ksmbd_vfs_truncate(work, fp, alloc_blks * 512);   /* == 0 */

silently truncating the file to size 0, even though the client asked
to grow the allocation to (what looks like) the maximum possible
size. The trailing "if (size < alloc_blks * 512) i_size_write(inode,
size);" restore is guarded by a comparison that is never true once
alloc_blks == 0, so the truncation is not undone. This lets an
authenticated SMB client that already holds an open handle with
FILE_WRITE_DATA on a file silently truncate that same file to size 0
via a single crafted SET_INFO(FILE_ALLOCATION_INFORMATION) request
advertising a near-U64_MAX AllocationSize, even though the request
asks to grow the file's allocation rather than shrink it. This is a
functional/data-loss bug, not a privilege-boundary
violation: the same client could already truncate the file via
FILE_END_OF_FILE_INFORMATION or a plain write.

Fix it by validating AllocationSize against MAX_LFS_FILESIZE, the
same upper bound the VFS itself uses to reject unrepresentable file
sizes, before doing the "+511" rounding, and rejecting oversized
values with -EINVAL. Bounding AllocationSize to
MAX_LFS_FILESIZE - 511 guarantees the "+511" addition cannot wrap,
and that the subsequent "alloc_blks * 512" values passed to
vfs_fallocate() and ksmbd_vfs_truncate() stay within a representable
loff_t as well.

No legitimate SMB client asks for an allocation size anywhere near
2^64 bytes, so this only rejects a value that was previously
silently misinterpreted as zero.

Runtime-verified on a v6.19 KASAN test stand: sending SET_INFO
(FILE_ALLOCATION_INFORMATION) with AllocationSize = 0xffffffffffffffff
against ksmbd now returns -EINVAL and leaves the target file's size
unchanged, where the unpatched kernel truncated it from 4096 to 0
bytes.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
 fs/smb/server/smb2pdu.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 097f51fc7ed6..324916533669 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6690,6 +6690,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	 */
 
 	loff_t alloc_blks;
+	u64 alloc_size;
 	struct inode *inode;
 	struct kstat stat;
 	int rc;
@@ -6705,7 +6706,19 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	if (rc)
 		return rc;
 
-	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;
+	/*
+	 * AllocationSize is fully client-controlled (the caller only
+	 * validates the fixed 8-byte buffer length). Reject values that
+	 * would overflow the "round up to 512-byte blocks" conversion
+	 * below instead of silently wrapping it to a tiny block count,
+	 * which would truncate the file to a size the client never
+	 * asked for.
+	 */
+	alloc_size = le64_to_cpu(file_alloc_info->AllocationSize);
+	if (alloc_size > MAX_LFS_FILESIZE - 511)
+		return -EINVAL;
+
+	alloc_blks = (alloc_size + 511) >> 9;
 	inode = file_inode(fp->filp);
 
 	if (alloc_blks > stat.blocks) {
-- 
2.50.1 (Apple Git-155)

