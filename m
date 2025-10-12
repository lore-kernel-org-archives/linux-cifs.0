Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC55B2D7814;
	Sun, 12 Oct 2025 15:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282146; cv=none; b=HjWYQj2xYmRpYFbom2gY5nmXFGa4oHCmEUqOHTku0HWCI0yL0y0kq6YNAqx+aFP4V9yHigeNo19ippU+MHCwkkK+q2lauOub6d+Ho2r707vwlcanCzPm7JmxLDpg4Msc4NGlAd7pUp10xDO7H6b1bsSBTRAFhCmx9zZmr00SOTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282146; c=relaxed/simple;
	bh=Xf8YDORNtEKfBSYe5NMLOToggAz3uvjWZVx2WzEpT+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFZBLlwWnBKdFcDna4GWKy0Q2uITu4TieuU7zz55rl4S8F+lAAi3/tsux44e9aKMM8X+8H5Jy35HrlYmcC1tu1cSoqMtQJC6VGa+WUX8aRMcFFnMxqMqbcs16Pa1G2bbl8O0bUPtwed4b5ROl0l3wX0m8JdYGn/3liZ9vpFI5ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281854t649e598b
X-QQ-Originating-IP: t2iYRrmfbAzIz6LLFoW8zbJCqK90/3jYCzsloHhDGI0=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:53 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 14456546733879225036
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 22/22] smb: move FILE_SYSTEM_POSIX_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:15 +0800
Message-ID: <BAD128CECF6CEF50+20251012150915.2992220-23-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MjgrMiwCCJklvnP89b1VoWtIgI+JAZqJlW4zCrRRAR8LGAGfay7GDltd
	Xq9fK0oLUbN20cmcxuIgTF5tSTgJRH9jqztEIpDr6ZNwvCntmAqDm35aBefspJl50+sGuJN
	RG8kKEY4dVz9XMkAv3ALytvPhKkl3vMhUJWxoJ4FrvLhmkfjbAFIWu72Gd5zE8S2sO7zAqI
	jyGOcdhw/gDeHhUAJUSQIo1saWm/wk+eYINxPRj73jFKE9nas0v0+peRHVkD2bXeLvBvV9K
	dRYa1k9EOS9KWBvsBXDJ98aFfMJ8SSajAxPy18T4TGERReOqUH4B3SbI/5dgmG4YrxAk5Vc
	x1cm5cMmEZwMP8yBpeGWAW/IYOJwT4Zu9Hd67sk590VXZED+OlRqurzwrO6YvT+gtDitJAt
	tWasMydW48hlKl0ad6cASO10MIW7++AFdmqe7GM0K7CygDwTcYTbuLcmEN8k1rVgYN3sgAW
	4pZ7doRRwyXX62+LCG3XhSqh6aZpll1CpDK36Ebcmv0njUaSU63D5NI6/Au4kIYjZ1XPoR5
	EG3+c5e0rCR/pyjsPlPyIqdFC/SdqXWztAR5kDu4DvTwN+ULPhWs9LdzCmO4IXwrLW3748e
	SBjmuXiiMP+gSOUBVF/2uHqtbpREKmKABGFnYWzYNdeqpXXI5VKDE0nZ8Fh17/cRfYQFenh
	y3C9HLznzUie1zi8Rx6fmeeCGYk7n1Y+lwwyKmKehvUAJwNylq9KHtZfa+V/J+iL91FiU2e
	x02x25uXsQ6sWSA7YrSmdm+ZXwzVFfPaZumn4vq6P3Krn0rlW5FX9S2lisRL78mhYAY+LJ+
	eo6LTk+xalaJ8UX7Dw17uUsZNQYOSEfC8/ZU67TtGJFXoMkaEPL0s7K3GeePzk41TbdJEgp
	MkT1ZrlhLKMMdmbT541EaR5xNmFu6/aamT43Y5L12K8j1SZhjhDVm9IrEenRbsySx7zo7c1
	/wqJu/wG2exjmKyq921afzeX+LR9OxlwIcT8pRtb0vLpl4f+H/lffhS46ZpB843OEuRCvGW
	ZP6CeJPHT0vYFwrwRGsnQrRmfnHd4WXM6hitWEEw==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct filesystem_posix_info" to "FILE_SYSTEM_POSIX_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 22 ----------------------
 fs/smb/common/cifspdu.h    | 23 +++++++++++++++++++++++
 fs/smb/server/smb2pdu.c    |  4 ++--
 fs/smb/server/smb_common.h | 23 -----------------------
 4 files changed, 25 insertions(+), 47 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 68e3af176add..ab23a233153a 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1866,28 +1866,6 @@ typedef struct {
 
 #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for new QFSInfo */
 
-typedef struct {
-	/* For undefined recommended transfer size return -1 in that field */
-	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
-	__le32 BlockSize;
-    /* The next three fields are in terms of the block size.
-	(above). If block size is unknown, 4096 would be a
-	reasonable block size for a server to report.
-	Note that returning the blocks/blocksavail removes need
-	to make a second call (to QFSInfo level 0x103 to get this info.
-	UserBlockAvail is typically less than or equal to BlocksAvail,
-	if no distinction is made return the same value in each */
-	__le64 TotalBlocks;
-	__le64 BlocksAvail;       /* bfree */
-	__le64 UserBlocksAvail;   /* bavail */
-    /* For undefined Node fields or FSID return -1 */
-	__le64 TotalFileNodes;
-	__le64 FreeFileNodes;
-	__le64 FileSysIdentifier;   /* fsid */
-	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
-	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
-} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
-
 /* DeviceType Flags */
 #define FILE_DEVICE_CD_ROM              0x00000002
 #define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index b4ca0c36cf84..853e03f395be 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -329,6 +329,29 @@ typedef struct {
 	__le32 BytesPerSector;
 } __attribute__((packed)) FILE_SYSTEM_INFO;	/* size info, level 0x103 */
 
+typedef struct {
+	/* For undefined recommended transfer size return -1 in that field */
+	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
+	__le32 BlockSize;
+	/* The next three fields are in terms of the block size.
+	 * (above). If block size is unknown, 4096 would be a
+	 * reasonable block size for a server to report.
+	 * Note that returning the blocks/blocksavail removes need
+	 * to make a second call (to QFSInfo level 0x103 to get this info.
+	 * UserBlockAvail is typically less than or equal to BlocksAvail,
+	 * if no distinction is made return the same value in each
+	 */
+	__le64 TotalBlocks;
+	__le64 BlocksAvail;       /* bfree */
+	__le64 UserBlocksAvail;   /* bavail */
+	/* For undefined Node fields or FSID return -1 */
+	__le64 TotalFileNodes;
+	__le64 FreeFileNodes;
+	__le64 FileSysIdentifier;   /* fsid */
+	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
+	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
+} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
+
 /* See MS-CIFS 2.2.8.2.5 */
 typedef struct {
 	__le32 DeviceType;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 065e0daaa91b..d49cd1ad1d70 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5626,14 +5626,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_POSIX_INFORMATION:
 	{
-		struct filesystem_posix_info *info;
+		FILE_SYSTEM_POSIX_INFO *info;
 
 		if (!work->tcon->posix_extensions) {
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
 			path_put(&path);
 			return -EOPNOTSUPP;
 		} else {
-			info = (struct filesystem_posix_info *)(rsp->Buffer);
+			info = (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
 			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
 			info->BlockSize = cpu_to_le32(stfs.f_bsize);
 			info->TotalBlocks = cpu_to_le64(stfs.f_blocks);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 4f48dbf9c13b..d349b3443219 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -107,29 +107,6 @@ struct file_id_both_directory_info {
 	char FileName[];
 } __packed;
 
-struct filesystem_posix_info {
-	/* For undefined recommended transfer size return -1 in that field */
-	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
-	__le32 BlockSize;
-	/* The next three fields are in terms of the block size.
-	 * (above). If block size is unknown, 4096 would be a
-	 * reasonable block size for a server to report.
-	 * Note that returning the blocks/blocksavail removes need
-	 * to make a second call (to QFSInfo level 0x103 to get this info.
-	 * UserBlockAvail is typically less than or equal to BlocksAvail,
-	 * if no distinction is made return the same value in each
-	 */
-	__le64 TotalBlocks;
-	__le64 BlocksAvail;       /* bfree */
-	__le64 UserBlocksAvail;   /* bavail */
-	/* For undefined Node fields or FSID return -1 */
-	__le64 TotalFileNodes;
-	__le64 FreeFileNodes;
-	__le64 FileSysIdentifier;   /* fsid */
-	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
-	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
-} __packed;
-
 struct smb_version_ops {
 	u16 (*get_cmd_val)(struct ksmbd_work *swork);
 	int (*init_rsp_hdr)(struct ksmbd_work *swork);
-- 
2.43.0

