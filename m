Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729452D3ED2
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 06:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776924037; cv=none; b=AffZcG9wbCVN0wokGvxd4VgQee8WQXGO5j+imWnD2KlM2XpV6IN/jV3MevPWVOrbrWvHAKRsfir4mXxYP41NGo2XJIeqoGTn/2Z/6Pr5gE0/W88hBesP9Ko8inol39Kl4uQI4SFaNblQFYHqNfuSLLseDjSWhhwejPTL22yhQUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776924037; c=relaxed/simple;
	bh=Y7S0I53Mg4DYEFQeNIyERr6A6rh3rgmI4+Ci2lA9AwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TdZrGaMEAPmJyFRllua62h75WQEgl8c48rF+KlA9gdwOxbDPtu2nlfxOlCRm/hekxi07cz9uq+opKO7aoQWDJe19HlnSw/OnzJ8U8j2jEHj082GHRgGJ6m6Lgosd7WmQO+pgobE3E0nPSvBYqBHLEwi6oFgNvuyrDAbjtlUO2tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YoFohIOE; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YoFohIOE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776924032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E4OPrLawMRVjhlxBvyuqSTW8+MhzcHg8GcecN28dJmE=;
	b=YoFohIOEB4NFHLZkkPRc9cgVrsKK0/Z7GLcLFTiDXZ+Pu3Ty5D4RVvG+Zvt3zasWsn0F+g
	fmCu2MKtAGGSl+c5ntpuXQpo08t+ud//diJ1Dxx8Uq6uGm8jsCwj/0wsjLIqyKGz/SFTJW
	mcFkl+MjHvQtXJLtAwFVe0mneXZsO/M=
From: Youling Tang <youling.tang@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@chenxiaosong.com,
	gregkh@linuxfoundation.org
Cc: linux-cifs@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/client: fix unaligned reads in wsl_to_fattr()
Date: Thu, 23 Apr 2026 13:59:15 +0800
Message-ID: <20260423055915.695024-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

See MS-FSCC 2.4.16. When multiple FILE_FULL_EA_INFORMATION data elements
are present in the buffer, each MUST be aligned on a 4-byte boundary.

When parsing WSL extended attributes, the code derives the value pointer
at an offset of 7 (SMB2_WSL_XATTR_NAME_LEN + 1) from ea_data, the value
sits at an unaligned offset.

We should use get_unaligned_le32() or get_unaligned_le64() to get
unaligned values.

Link: https://lore.kernel.org/linux-cifs/77013349-ff89-4593-985d-520d967d2638@chenxiaosong.com/
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/reparse.c | 6 +++---
 fs/smb/client/reparse.h | 6 +++---
 fs/smb/client/smb2pdu.h | 1 +
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index cd1e1eaee67a..eebce954c5ce 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1160,7 +1160,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 
 		name = ea->ea_data;
 		nlen = ea->ea_name_length;
-		v = (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1);
+		v = (void *)((u8 *)name + nlen + 1);
 
 		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
 			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
@@ -1168,9 +1168,9 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(fattr->cf_mode) != S_DT(get_unaligned_le32(v)))
 				return false;
-			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			fattr->cf_mode = (umode_t)get_unaligned_le32(v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 0164dc47bdfd..653213a6b7e8 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -23,7 +23,7 @@
 
 static inline dev_t reparse_mkdev(void *ptr)
 {
-	u64 v = le64_to_cpu(*(__le64 *)ptr);
+	u64 v = get_unaligned_le64(ptr);
 
 	return MKDEV(v & 0xffffffff, v >> 32);
 }
@@ -31,7 +31,7 @@ static inline dev_t reparse_mkdev(void *ptr)
 static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 uid = le32_to_cpu(*(__le32 *)ptr);
+	u32 uid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
@@ -41,7 +41,7 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 gid = le32_to_cpu(*(__le32 *)ptr);
+	u32 gid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 30d70097fe2f..6744606dab6c 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -211,6 +211,7 @@ struct compress_ioctl {
  *	BB consider moving to a different header
  */
 
+/* See MS-FSCC 2.4.16 */
 struct smb2_file_full_ea_info { /* encoding of response for level 15 */
 	__le32 next_entry_offset;
 	__u8   flags;
-- 
2.53.0
