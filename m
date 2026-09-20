Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879E63D566F
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 05:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789883827; cv=none; b=NWBa82ez1o9jddhcrTQzt8ZwX5g9W95SjHk0ULho1ygYPwrqTl7lZtwoMP1X4WZYgVxSFejW3kyx89bQqMKMWNklZo6qvDOL+9Od27ILTE4evMy+poH5Mx7sGxPpKSCKXLpUhGyodwDagokqE9yDWIjcDbrH05u/UjlS3767LLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789883827; c=relaxed/simple;
	bh=hxKBXLMLld51nhr9cfCd0QX+wEaDXuckrczQ/YRkZeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLfqQPFN3xUDBqTjSlHwwYkBJG6Xevh/ATGNBHxo7El9fyM4DA1K3/nasL/Pp5fj3+tMC5N3AJo4pT0Et/6/aT1f/orG+QgH6ukcjQ9FZGZKvA2L22qU/XBGXrS4uQOFy8F1gejy1URMsxrZKGaWBul1vQwVmBpqcL6B6s24gEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FLqxIr+/; arc=none smtp.client-ip=91.218.175.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FLqxIr+/"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hxKBXLMLld51nhr9cfCd0QX+wEaDXuckrczQ/YRkZeM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789883822; v=1; x=1790488622;
 b=FLqxIr+/RlViU43zpDUOwnmW90jxYoJgMWewNvYiwxYj3gIZselCGr1U9FSLdmhO2slC+sFK
 0omMXoJuoRRrEELdM773Y7IljTo4wkAXYBsZpZUfChy5sHhV8GLWbl/UP0LcO2DHNQjoVMmv+G/
 Kker/MhFOE8tv0bu6/TjyHSY=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ae84987a000af740;
	Sun, 20 Sep 2026 05:57:02 +0000
X-Mizu-Trace-ID: ae84987a000af740
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/3] smb/server: update POSIX extension specification references
Date: Sun, 20 Sep 2026 13:56:51 +0800
Message-ID: <20260920055653.114794-2-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920055653.114794-1-zhang.guodong@linux.dev>
References: <20260920055653.114794-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

The POSIX extension specifications have now been published:
https://smb3posix.org/

Suggested-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/server/smb2pdu.h | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 95c89087553b..40d61745ef41 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -156,8 +156,7 @@ struct create_durable_rsp {
 } __packed;
 
 /*
- * See POSIX-SMB2 2.2.14.2.16
- * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
+ * See POSIX-SMB2 2.1.3.2.1
  */
 struct create_posix_rsp {
 	struct create_context_hdr ccontext;
@@ -349,6 +348,7 @@ struct create_sd_buf_req {
 	struct smb_ntsd ntsd;
 } __packed;
 
+/* See POSIX-FSCC 2.2.1 */
 struct smb2_posix_info {
 	__le32 NextEntryOffset;
 	__u32 Ignored;
@@ -362,20 +362,18 @@ struct smb2_posix_info {
 	__le64 Inode;
 	__le32 DeviceId;
 	__le32 Zero;
-	/* beginning of POSIX Create Context Response */
+	/*
+	 * Beginning of POSIX Create Context Response
+	 * See POSIX-SMB2 2.1.3.2.1
+	 */
 	__le32 HardLinks;
 	__le32 ReparseTag;
 	__le32 Mode;
 	/* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
 	u8 SidBuffer[32];
+	/* End of POSIX Create Context Response */
 	__le32 name_len;
 	u8 name[];
-	/*
-	 * var sized owner SID
-	 * var sized group SID
-	 * le32 filenamelength
-	 * u8  filename[]
-	 */
 } __packed;
 
 /* functions */
-- 
2.55.0

