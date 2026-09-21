Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51C72DA759
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 01:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789954900; cv=none; b=gwoCGGYnHZDCBb60TOy4LZbgksG0t7oT77sV1ft17suU8dPxGIvXkiNO+RSfHTzdrRQBNiSvmmc8byzxCmY9w+dYnKJDRypTuUxljMJEEFrTCS0R7F5nQe7H/sW1jU6vHpoinunG2HHK1BdtYigTCBequ2o2QsuhB1EnFR2Ml30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789954900; c=relaxed/simple;
	bh=hxKBXLMLld51nhr9cfCd0QX+wEaDXuckrczQ/YRkZeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiET/Imvf3Skv3wBacMsRcP0D9JzXqvKZcRz9ETwlDE3CrlujQvKUUog7NWc8JDiegGsyaL/jimpNbT8m+jyi6wY7gunGlPqqJk8C389ETq3DZEK06eBZ/g5iSSVwiW+WYSNvO0smBsgkWIN8hVEH1kKVnBDT0RdQQBsnDMdbRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ww8XhQV7; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ww8XhQV7"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hxKBXLMLld51nhr9cfCd0QX+wEaDXuckrczQ/YRkZeM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789954895; v=1; x=1790559695;
 b=Ww8XhQV79tYAJtsT5NkFvOCpgrh/cqW4JQmDKmJduRjJ5M3LGk3OkeczltYIrUsyvFQRg1M4
 COKmpmjApWCdZeozzriixB/51Ui1HQHDCsLBZKzVDxH6uNOE/93eNjnefVqQnUQZVcwBMqXjk+g
 ZWYeRRn69Lve3KDs5eZ3t1Qc=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 21944fafaf5966e3;
	Mon, 21 Sep 2026 01:41:35 +0000
X-Mizu-Trace-ID: 21944fafaf5966e3
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/3] smb/server: update POSIX extension specification references
Date: Mon, 21 Sep 2026 09:41:27 +0800
Message-ID: <20260921014130.147229-2-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921014130.147229-1-zhang.guodong@linux.dev>
References: <20260921014130.147229-1-zhang.guodong@linux.dev>
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

