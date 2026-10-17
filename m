Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAA13D4138
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 03:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208464; cv=none; b=A5dWCTwWFBQUInEUnDTNO3QVx8um9iMfojgwjdI17XBbW8yFrT2Pl3scxTbsUiUSI2yTkkBhwJpd44RpQt99o+b1jiWZdZ9JlWkkSCwtWzFzoRSk5OS9WcES4VVWOBQ9BuIlYJf+zDF0q7lFwafyB7fB6j6mHfnuVLXfJlV+xJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208464; c=relaxed/simple;
	bh=T2ydNBrdSAiQY/mHYN1MfyKAYiXmXfQX8l11uhxEwP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiJH1Ln8i4JgOVrLYCORan2lsadCTkIFwUVLjujXrYzk7DMeYdr8Re+5DuXkWekprFmj/u1TnFWlqcl3TJqte+ZP+4xwul8Q+oOQ3176dVwdE8suCWk2DeP+QmSP3Y2erlm2cs1+jgsLqvwtkjy2G4R6DMTg0GjAkYWhvwSCZhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7nkYha/; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7nkYha/"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3a89f92d7b3so88700a91.2
        for <linux-cifs@vger.kernel.org>; Fri, 16 Oct 2026 20:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792208462; x=1792813262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T/A4ESg/M6eHiPTNzUedDsWmNCisSQL4A05jpFBuAJA=;
        b=U7nkYha/+CPVueRR/rixWZxXAotlKlOONvWn0eqxoODqEn5ULohqd6Rb5YHBOXxwdo
         MJddmK2sZ8fNAmUFG/4g1DCLSIuQmWVMdPKOGF2r5XRy6PMVPbhMpeZiAF0sY3mz09bh
         /7emOb7cfzTKdzvSLg3SyGF/Z5vEtQ1E0MlLg1zFItEbm5svdVMitg8aTCjO96fvXQ5G
         hAUPEJYQAiC4myqXc1rCeO3CM3Bxk61Jc6xvVtU1auv3XRNyBXGGsbabxHFG+ve5GxWc
         xQnpqtNllLCCgffo+PftZGukiDmjtCmYvh6jJhuP3sRcQr5epapXtH4mirH0x6ZFWIjx
         j2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792208462; x=1792813262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T/A4ESg/M6eHiPTNzUedDsWmNCisSQL4A05jpFBuAJA=;
        b=1crdFRzL8/dWVPIbHVQhXJlleLe5IiO1lBW3kwO9LvVx2Ef3E5uJuTXVnzDYnb9Z+B
         Q/IHrYakSURlMpkYVlZSWSKsE4fIvgfo5PzomnuGUoirWROCR9iG63uWDZlIRqHguCYX
         AgwWMMrE2CLksHc/4kH2M5i75FH617ciBT98kWwwJgzE9MjdCSFbWd7dLy+bTlZLFRwW
         3FT+mzPqyYnOUaokqyO39ADyIftI04YiUCHNmaPOUUfwCBYJMB4++n1Im+WU77YfHfGn
         j9kL4xr7s009h3KR5DF+D7TWMozpS69p5tV3OFoOLW88+g5zB82uStN5nvO5Qqddg4zm
         optg==
X-Forwarded-Encrypted: i=1; AKwUvBykQUSxYvjm7rF6UNDLJU3Dx5UDQG1AdqAf6MQ1YvPf5/WeT4hlGW9R6by6k0Qy3Q4yXMhGUs/4snGb@vger.kernel.org
X-Gm-Message-State: AFq9FYJ5v+6idaiQovYowN9d7EaPGZRo0mgSYeUV4WXgKKkuPYLNS6Yw
	9KdiT3ZCbiTznFEhGElaMcWTG6F40/haT2yhvUn+7p/cZuwkEOFBav32
X-Gm-Gg: AYBFou39sd8mzw1bPJ4KWldEDgMXWZsWHCgP4WvSp6vurTp5wYBPnm4tWt6z/Af1O2e
	+kZfF1vEGx1qVgoUoDKTz061SyMN//4pfX5sNVE9rPPF6M3X1JzW4QRQNNhNPjT+7dFfFslDGLZ
	YssZhgVZGEMDD/iXks7Cno8K+nVLHNtlWx9jraiwG6Yva+RV/fWlliPMokcn5NzlAiXafweij/u
	GrT7ET/hbItSzGw7RMRgArz3t785fSbce9TOqT+RDnpDcqwOkqdsi6GIPlrTbwXgrtSkvEjO3p/
	RZELX87K0ZPMwae8jMk3eeRBp8WFSBoKbTmFc0nR2d+KLpwdBB1lSenojSZaaw2lud6n/xv2jc9
	HDZGcghJrG8w3onMZgUpNvoo6ey/qGoaUbaEEL+QY4Sy18UKsgMVpWLMxUEn8AIvEanoJxrqwMZ
	U/JvPQjy8MVRqcuacBOHQAwDP59ZpL6C00NljysRx62JeZFV7kv+aLTEYgTyNoJbI=
X-Received: by 2002:a17:90b:4b82:b0:3ac:75d5:7388 with SMTP id 98e67ed59e1d1-3aceebe3f7fmr2409820a91.3.1792208462499;
        Fri, 16 Oct 2026 20:41:02 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac945e7311sm11708667a91.4.2026.10.16.20.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 20:41:02 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 2/2] ksmbd: round SetAllocation to the advertised allocation unit
Date: Sat, 17 Oct 2026 12:40:51 +0900
Message-ID: <20261017034051.72932-3-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261017034051.72932-1-charsyam@gmail.com>
References: <CAKYAXd_50E7cH51hxKi9xWfE3Hjyj0PhwccgsuGX416pEJVs8A@mail.gmail.com>
 <20261017034051.72932-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SetAllocation rounds requests to 512-byte blocks, although
FS_SIZE_INFORMATION advertises the filesystem's f_bsize as its
allocation unit. For example, on a filesystem with a 4 KiB unit, a
1000-byte request can truncate an 8 KiB file to 1024 bytes instead of
4 KiB.

Round the request to the advertised unit and use the same result for
the block-count decision, fallocate, truncate, and the size stored on
the open handle. Validate the unit and rounded size before either
operation. Use DIV_ROUND_UP_ULL() so the calculation works on 32-bit
kernels.

This does not change the existing block-count decision for whether to
call fallocate. In particular, success does not yet guarantee
reservation of holes within the requested range on a sparse file.

Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/smb2pdu.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d06bdc8b23db..6a91f939f3d6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8596,10 +8596,11 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	 * properly with any smb.conf option
 	 */
 
-	loff_t alloc_blks;
-	u64 alloc_size;
+	u64 alloc_size, target, alloc_blks;
+	u32 alloc_unit;
 	struct inode *inode;
 	struct kstat stat;
+	struct kstatfs stfs;
 	int rc;
 
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
@@ -8612,44 +8613,48 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			 AT_STATX_SYNC_AS_STAT);
 	if (rc)
 		return rc;
+	rc = vfs_statfs(&fp->filp->f_path, &stfs);
+	if (rc)
+		return rc;
 
 	/*
-	 * AllocationSize is fully client-controlled (the caller only
-	 * validates the fixed 8-byte buffer length). Reject values that
-	 * would overflow the "round up to 512-byte blocks" conversion
-	 * below instead of silently wrapping it to a tiny block count,
-	 * which would truncate the file to a size the client never
-	 * asked for.
+	 * Use the allocation unit advertised in FS_SIZE_INFORMATION.
+	 * Reject requests that overflow when rounded to a whole unit.
 	 */
 	alloc_size = le64_to_cpu(file_alloc_info->AllocationSize);
-	if (alloc_size > MAX_LFS_FILESIZE - 511)
+	if (stfs.f_bsize <= 0 || (u64)stfs.f_bsize > U32_MAX)
+		return -EINVAL;
+	alloc_unit = stfs.f_bsize;
+	if (alloc_size > MAX_LFS_FILESIZE - (alloc_unit - 1))
 		return -EINVAL;
 
-	alloc_blks = (alloc_size + 511) >> 9;
+	target = DIV_ROUND_UP_ULL(alloc_size, alloc_unit) * alloc_unit;
+	alloc_blks = DIV_ROUND_UP_ULL(target, 512);
 	inode = file_inode(fp->filp);
+	if (target > inode->i_sb->s_maxbytes)
+		return -EFBIG;
 
 	if (alloc_blks > stat.blocks) {
 		smb_break_all_levII_oplock(work, fp, 1);
-		rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
-				   alloc_blks * 512);
+		rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0, target);
 		if (rc && rc != -EOPNOTSUPP) {
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
 	} else if (alloc_blks < stat.blocks &&
-		   alloc_blks * 512 <= i_size_read(inode)) {
+		   target <= i_size_read(inode)) {
 		/*
 		 * Truncate at or below EOF to discard excess allocation.
 		 * Truncating above EOF would extend the file on disk.
 		 */
-		rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
+		rc = ksmbd_vfs_truncate(work, fp, target);
 		if (rc) {
 			pr_err("truncate failed!, err %d\n", rc);
 			return rc;
 		}
 	}
 
-	fp->allocation_size = le64_to_cpu(file_alloc_info->AllocationSize);
+	fp->allocation_size = target;
 	fp->allocation_size_set = true;
 	return 0;
 }
-- 
2.43.0

