Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF7219CCF5;
	Tue,  1 Sep 2026 00:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221131; cv=none; b=PLZnpkv2w6Tol2iQ2ogKEp0ipvH1N+GQ/T3x6s0HtGzKwsWUnk0hOR8AWp81LPlsk4mwH+xyCroyntMop2x8PAa/JMnNh9AgQ7tBt92Yp72zpj/Qga4/2YueKQ7BPwbGVApX1iSb1XGJK65yZdrc9Gk/8OEy+4xyfxyggLojabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221131; c=relaxed/simple;
	bh=wXy+md3V6c/53NjBfGXXfpwk7xqCTaiFCQIuUnUqm54=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=VBtSPftFYWWE+CFOu+vob0aTfdCVQqj0IrzsTzQdwwzuRVDglntlEvKvOL68NQJQjY9wFHc/bkDg+l8KO45zwrBRUlDwu0zvb50HfIrEs3WkITCpx0U8yhqP/XcNENPBmfbGdDSytc3Zyx6XYFH3W504XIYpY6UTvM4X11uHi7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+gAImPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+gAImPl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF534C2BCB8;
	Tue,  1 Sep 2026 00:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788221130;
	bh=wXy+md3V6c/53NjBfGXXfpwk7xqCTaiFCQIuUnUqm54=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=Q+gAImPlmu0MwgBw2FXQVIxkI7q+12ta7L2GNKz9tR4dYRE64EUTK613k+dPetDmp
	 vi9mFMBmMiWh2sbnhy0+9hsWopXBBAQPIjuafIIB5vJZvWydgNFTGKqPRtBLDYkeAS
	 Tf9DGC+4F5XdBvZN/3E73gQzp29oB904gm5LU+EzTKqooGzNb/C2MIhfay9esH0gqb
	 1SG9flchJGqNhDp075hDuocgraeS9altLdiuGUJxHVRgTBFnve9A8asSMpn/5vBMf3
	 /ZxUtlJlCZ7JCqt2z/G3X7c+ZaB4skoyV2zz7RvdtXr4R7v4+tFzShJXJeB5o057kR
	 xY3BKALM3PalQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DAAC624CE;
	Tue,  1 Sep 2026 00:05:30 +0000 (UTC)
From: Alon Shakevsky via B4 Relay <devnull+shakevsky.berkeley.edu@kernel.org>
Date: Tue, 01 Sep 2026 00:05:31 +0000
Subject: [PATCH] ksmbd: validate COPYCHUNK source and target ranges
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-review-ksmbd-copychunk-offsets-v2-v1-1-4a7f598eb9c9@berkeley.edu>
X-B4-Tracking: v=1; b=H4sIAMoWlmoC/yXNywqDMBCF4VeRWXcgCSVoX6V0UZNJnUoTyXipi
 O9ubJcfHP6zgVBmErhVG2SaWTjFAn2pwHXP+CJkXwxGGasapfEc0YK9fFqPLg2r66bYYwpBaBS
 cDSprbK29b641QekMmQJ/fx/3x98ytW9y4xmGfT8Ad8NK+4UAAAA=
X-Change-ID: 20260901-review-ksmbd-copychunk-offsets-v2-062681dd948e
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-kernel@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788221130; l=2533;
 i=shakevsky@berkeley.edu; s=20260829; h=from:subject:message-id;
 bh=zk9ntSxK6KH2GBnQw9ciD278sqGKtMWF34uLWFj0peY=;
 b=yQA1yMpddtk2egLqVHUYN9brG83RmkSNGDeABt7kbCc/rFdF0Pl7zbbN/CwWszVWRlgfpuyxQ
 8MYJPOjQWenDntrG3a+c5HxEROmx4fRFLOTRfeJRyEh5MpcRpDeqM8w
X-Developer-Key: i=shakevsky@berkeley.edu; a=ed25519;
 pk=yWZAM5+fHWudgjDI2F4zjbrSoHRSkvQ4pqpdyFWJUis=
X-Endpoint-Received: by B4 Relay for shakevsky@berkeley.edu/20260829 with
 auth_id=987
X-Original-From: Alon Shakevsky <shakevsky@berkeley.edu>
Reply-To: shakevsky@berkeley.edu

From: Alon Shakevsky <shakevsky@berkeley.edu>

ksmbd_vfs_copy_file_ranges() rejects negative source offsets in the
copy loop, but it does not validate target offsets. It also calculates
lock and overlap endpoints before ensuring that either range fits within
MAX_LFS_FILESIZE.

When the target is an alternate data stream, the buffered path passes a
negative target offset to ksmbd_vfs_stream_write(). Let n be Length and
let -d be TargetOffset, where 0 < d < n <= XATTR_SIZE_MAX. For an empty
stream, the writer allocates n - d bytes, then copies n bytes starting d
bytes before the allocation. An authenticated SMB client can control d
and the source data, overwrite kernel heap memory, and crash the host.

Validate both ranges before lock, overlap, or I/O calculations.

Fixes: 8482150a0743 ("ksmbd: support copychunk for alternate data streams")
Assisted-by: Antiproof:GPT-5.6-Sol
Signed-off-by: Alon Shakevsky <shakevsky@berkeley.edu>
---
 fs/smb/server/vfs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 35123550a5535..3a6f3139c6f52 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -2009,6 +2009,11 @@ static ssize_t ksmbd_vfs_copy_file_range_buffered(struct ksmbd_work *work,
 	return ret;
 }
 
+static bool ksmbd_vfs_copy_range_valid(loff_t offset, size_t len)
+{
+	return offset >= 0 && (loff_t)len <= MAX_LFS_FILESIZE - offset;
+}
+
 int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 			       struct ksmbd_file *src_fp,
 			       struct ksmbd_file *dst_fp,
@@ -2044,6 +2049,10 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 			dst_off = le64_to_cpu(chunks[i].TargetOffset);
 			len = le32_to_cpu(chunks[i].Length);
 
+			if (!ksmbd_vfs_copy_range_valid(src_off, len) ||
+			    !ksmbd_vfs_copy_range_valid(dst_off, len))
+				return -E2BIG;
+
 			if (check_lock_range(src_fp->filp, src_off,
 					     src_off + len - 1, READ))
 				return -EAGAIN;
@@ -2136,7 +2145,8 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 		len = le32_to_cpu(chunks[i].Length);
 		copy_len = len;
 
-		if (src_off < 0)
+		if (!ksmbd_vfs_copy_range_valid(src_off, len) ||
+		    !ksmbd_vfs_copy_range_valid(dst_off, len))
 			return -E2BIG;
 
 		if (src_off > src_file_size || len > src_file_size - src_off) {

---
base-commit: e53a23f960a10bf85ed2c9dbe0c1fc7d09c077ae
change-id: 20260901-review-ksmbd-copychunk-offsets-v2-062681dd948e

Best regards,
--  
Alon Shakevsky <shakevsky@berkeley.edu>


