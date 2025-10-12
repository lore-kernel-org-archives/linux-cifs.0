Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29752EC0BA;
	Sun, 12 Oct 2025 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286122; cv=none; b=C8DWo+t2dXkvvLZ+vB/yBjPvG8PHWNa+4FgeDFCkbmi5tSqRXwQg0vmXAy+Tddge8n2GCBzhbiSoJ6LJFO+JNzD2HfvCkr3cdM//NWsKeOaRa9aQMTttvpQykUwiD4M7Qt7yi5dI/z4ouJd/Wlfhf9eNjrhQxeau/pPy8a2dW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286122; c=relaxed/simple;
	bh=Xf8YDORNtEKfBSYe5NMLOToggAz3uvjWZVx2WzEpT+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqZjF4VA0UZ2VF1bCdacSL/bRRTKdXxUqA5MyuC6pcCkBqamJIuhixd5AwgkFzuFKL5ICOcYFZM01EhiYp/7HNV0/2M5J9sZoPTunr2InDpYzc9BwqKKFF8zn/zfkk9PrbXjrwcFKJu1JIBtZBp2ofI8dEjapCBO0zmYJypIvLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285940tf6a584fb
X-QQ-Originating-IP: ggSA1ypIriAWwWTqO52sQZkV3I34cugtTii9+Af5Fjo=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 6534208490292261738
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
Subject: [PATCH v2 22/22] smb: move FILE_SYSTEM_POSIX_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:49 +0800
Message-ID: <01E4A7CB87485CD7+20251012161749.2994033-23-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M4sLgBSwLMz8Pjzg3O6ta1IhTityFUhwzWnEKwdcCbfB2mvo199EsooD
	OeLrsf2/lIFFZBTV3OHXTBq5vXznLjpg1YZKEo/Xl/11TtJozsLfQkCdXFT10bOrqOWiCAZ
	oKnyXbry9gUyUpQjyFQvlAoAMwuQlYAG+rvaqxDg8hEf9f9mporurclL8MRff8pPSwfShZi
	e4eeVv9dVs225D5eklx5SCoPsVOc0ErycrQ3ETFoJ4ooSOsu1BS75ISdzO4CwmwVjF9Q6hD
	9LhpL+hicT/GJdccxwROn6XjUWheba9bJm06zZUbW3POJB3mVWd1US+mDR3Vn8iU5CkEOdC
	mOasWg4QTo4eyw3hLxES1485iEVWV7IlGshRYhB/Un1bzJyfWA6PZmiR423YZSDCUEa9pyU
	iXuWuRvMdekwYAeZRzrI3FlHcbcDl25aqDTLhBtBVEc8zqhP8fTPF1YvjeCJklDSdVoYdMX
	h4hKIAhQwtvm7sbv9Dj4Sy8gCCu+c3jS2TBrxOSNHEBJey6/BcjR9+KdQLuz4ev2HJiaLVK
	2WR96fQEALc/YNIJ9aIqEjl6FFE8tHrCd88NjlK4C+wzGhDohnqQqHlpx9Ygc+B7WNqCOO8
	zVBpnAd24dRbng5HeqORtjEsRriAJEnIKMSBFE3VLdB6vxrp4lj77psoZlVFxHyyWm8gtW9
	eA8vxOSv2ayhOAYjs25n2Y1zZtdfCL45AYvMODAlKVw4MRZgjGav+eulCs3fvGOT09UqaWC
	7lYuAPFuUy/Jg3IuTtm/XLVrodTvM2SY12FnjJRyHogL8XTVYLRIofI4bZAjEW5bS2iy/4n
	Gt1PONa8E0Ern0pdwKevvtHKITJvxbEsRCKWhn/uFFYWJwVnt9Gd8nU3RtmYlISjBFiPGsl
	XiZFZ9PU0KMGkrQKPTp3yrWCAJ90sZpX22bGmK5/TNhSw3U4o6vjyerZz67vu0qhEuuBR+V
	8zoK6fI4bi0nMBwUOPFzjA5srGQnYG6+jlaHxtLXwDdNN9gEFv9LEv10DzArEImzRsweoY5
	4A9P6vT+6/rJS2JMcb2S8vMHve8umqIKN5YC8AONilKNjzWKJe/f0zJhTu4/HHO2WgZ/SC5
	8ZU/BYM2X52SNOcIMApvf1gzQOoiiJOJA==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
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

