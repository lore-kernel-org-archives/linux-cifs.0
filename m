Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F99F2F0C6C;
	Sun, 12 Oct 2025 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.54.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282761; cv=none; b=JlkxdHOd0xCpkTJ6BEeTu995FBoEFL8oI9+fnzU89dNU8ajk8OpT9UyUXyha2tw8zR7AHZF4F+Xe8jcnfrUqFLzDyqK0IKiffbS84rbTlHf/pg9g7NlcdoY30/e66dcNIP6v7ppC+77pGoi9UAm7K3ypAxsQx+uskPmtt1OlM68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282761; c=relaxed/simple;
	bh=Xf8YDORNtEKfBSYe5NMLOToggAz3uvjWZVx2WzEpT+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nv7z8jk/iSxUupLEn84GWrqIzs97eGvEduM0knMq365yVjJmVhd3o0GpZcIoau+WNaKUCMQpSN679MbkLJkcSgaxNzeqViTx/3FYKWmG2VXVyMw3joymcH9UgmHiFjWH9f2JOJgkeT25cYvbot4NYphOfZCum9tlhhZIZps4lV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.54.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282629tbf4c5cb0
X-QQ-Originating-IP: 5SGCKhkRl8o0teKelFHXzFZeJNX9UiTuZn4jUU0iWFU=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:48 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3610118573702564460
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
Subject: [PATCH RESEND 22/22] smb: move FILE_SYSTEM_POSIX_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:47 +0800
Message-ID: <BA90919578D537D7+20251012152247.2992573-23-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: ORS1Yo0/LNyiRYH6RX/w/X2A2eao6SVupk3Y3+m95eBGUn6ahqlH12Cp
	TZn8OZj+I1r4h1kB/HnMDhR+ydyhOw88ry1Ylzg8WAuEFi2nUlH2HZfIH3fsDFxKFxa5wWm
	bUxPmSJx/a9SIx3ut50dh3ROV46hZz01ac8eqNGeyjRDPMfEBxknD40EDG7+G9uaLUQxt0G
	/DOYxPUdS8zxnCvGAgh0f+///XlXpbBz7clNV4bSVJ+F6+FtlwXJbdUoOkvPkRO8yVZ91Ze
	65+0niMBOACXjLHdEleuT9D/mMhk/ppE2MVTxH5dBjXKy4e2/V+5wdSIpPK1GnisoGBKb7k
	7w3MRhS2qCIvgMeMxm/YzJZ0EajgKGSNIJoYMmGskpwT3EoOH6rBNDIPZ7X2KW8MA0Rx5Mu
	vJo7yKTiv2OhKhQzcOVUiRx4avVG7Su2Gv3Dc8lV8tC3bHn8JMMAZUFdeoK/TosQVdOslXD
	FzXpgKOs8w26QdaDIGK8dB9BF+uoY63jAzuaeasMfhdq2PHWtB+xkhjdoB1fbWaJutzOJ6c
	3+5AsvgDkDzn54+uFXVa6EOV3cl5jsm13nFLwdmvRC+xm/AYgzEM75vT0tJqz5NbaB3H/9J
	4sC/P9xenc4NyiTjPmGDtpMrBlBNOowTE1nSoEI6VBHOevaOG4jQko59EaQI+Vv8oPABMUn
	iARUNqx57bJEO09f0qFz6m+uDvRs4DQB/sSc1zt0mNWSHfd5gx6js/DOdaN5DeYhqP5bSuY
	UK3INdbQMHpbZuYC0IFV2G5v5EBYBEDWX+GDzn/vaMuOkBtHFBfYYFr2zIHmCIZSnejskrq
	h37mXcSbLsxNiiKdY9so9RgXleqk0Lzzp2nZhOy71GqthrzR1UDUT/6Md4lwRa/cHWRO0av
	aWjFAKvDo6MCN2RysIEnboJVfk7YTLx2eLioDwx1dy4SVMzmYPo4N+PfL/CcYCz6EVfHdFo
	6da9SvWfVFffoTsm5N5mS22fe2knCHNktyoWE4j3ST04DQjcwJsZXFFpRvbhmq7PhxOGmFM
	V0sGXku4+aqq7JA9RRJSV3Z3soBO5XsTgmqpgMDOJo3B4XquppLp4qVuSv2xNUS6TqrOE7i
	7z9bNDMUEdnOvu+sVEn7fgoVIoyZACJ5sUvtzfxdq1v9QlAzunOBE7Qp1Hd51sC7Q==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

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

