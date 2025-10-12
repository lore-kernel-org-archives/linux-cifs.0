Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265982EDD7E;
	Sun, 12 Oct 2025 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286074; cv=none; b=UKNL08bVqHJvEs+Nv/AsyAk00Q4JE8noTGyWq0QLTgMVVrsQPLbMyUXvkBRbgnTY/iptzuCUvjH3+LPr52hU4u/4v4idMvKe1VUsiFxVNTylU87HjtzXxrUQjd+29we43hXAjOKvtV9rAeb7beYhjdaB2KM2Ip1bv6RT6OVz5K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286074; c=relaxed/simple;
	bh=9HFwudJ35eQC7DM+YM0J+EEops91L9kfN+PkBQyF7N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8Qu9H9fadZDGUCqamWafdQwe+DOhHJGbhmvt91wh8+LFCt6/zXRw6AU2MM8rn5k5wV4QBEhkGs3Nh/4WaSFRFKg2Db0dVmhkRn6B6tcMPyrUfUyQcjvAzh1JGqfW9MJi26ul0JCNyg/ITKUfgauyU4p6s49t1fOdWJ1VYxGr6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285927tb789d326
X-QQ-Originating-IP: pcxo/70rjxin7I1eumam0esFt8mVKBkt9c1xZIdVXR4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13789738382234321181
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
Subject: [PATCH v2 16/22] smb: move FILE_SYSTEM_DEVICE_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:43 +0800
Message-ID: <32507DF8FDDE3006+20251012161749.2994033-17-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: NP3iUBCWMtGbCK5kR3sKMDJyzhT7gmzbFz2NKvpJU75XvoOlXAMBp5wc
	UiqvLP95aaelJ6nxzkvhiN+6hGitazGyQyLNexzhxwSjIQibqT9hYCeXKne+BLtVHSV1Qjl
	NxuYRjdg3zyhr2Hai5eVtP6ntyxNtj+b/aZBQ5TD6cPY9IZ/GLYq8LMSujD4dmpOssJvUtv
	lwT0zHtNl2JvemS4n59lcrDsd93DaU4/lhrK1H5QpJPCZyJppnlvfDTJ7oO5W+fTvnY3H1z
	PbCXMO057mQpm5RVWzKKo1iR51KxG9AqLgB8VuWO8asoaU905PAtOK/6j8tDcXKa2H8FGX3
	cuUj9xQBSG8736YDdffGRonCk0PdbD5Br5jSmmewOaQptRnpKPLu6BRcQD8WJnJANBz8q9W
	jp/Ug3KzRzAh5hZsEHEfCH9PMYADWO1WHxP72r/9aZnDqe34DRpzJXEdbFeW/yFI8BP92XG
	DVS66MDGUCtqVR9ASW0XLhT6D8ztyB2U93A2wxbesgRusX4tgncRTWAbv/Udfn51nHXUR6o
	ZTaaD2h8XnJC9dU/agTCKCCkyZPC3mWyF8zy6pZXkpj14bn46cJ6s55ywRvaybqgV2pCHda
	ASVWLVtzS3qc5wZaQDMYZ+hehyE3NPVF33aTYF3KsNEWJoX5UfcSOUgEKbtZb9xGQLMC61r
	BgpsCtoNActp7x6wgLnwFcRAxfF/Z7TqDsLfEyuR4rVT4tb+uVc8UZT3aD83K4dDWWYIkb1
	C4u0iatcQL8tYs2T2SfrEQF6bhI6QVyu8AqSVyeQGtQc2ZZHXMM7nAovOnpyu2bphTViI3A
	zM6Vfs4/XSCRIzpDKVlxbecNACkXLhab2AwZ/hPjZo0TbdLBWrPTc6zgWVCk3MPKmuEpvck
	MAaUYv+gJdcsTmIy76rqRG+CgxB3iaao4dFo1YQcqTyXS/GjN1B71//ImqvXteDv2B8toby
	CQi/vttJhfphRu+uVFKNJQ2gll9qocs/kCMURB6fVS6qzGBaQE83kXTc7oX4R1GEsQwWB7r
	0+h6Cox6wwC+FtdhcEk/g4A1Zowr8oNQm8CordubyEq9jToDWNMzjk5HPSS/QCvG6inza6W
	FXI/w/PoTFq
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct filesystem_device_info" to "FILE_SYSTEM_DEVICE_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 5 -----
 fs/smb/common/cifspdu.h    | 6 ++++++
 fs/smb/server/smb2pdu.c    | 4 ++--
 fs/smb/server/smb_common.h | 5 -----
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index a6f7e168961e..17255d7a4615 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1929,11 +1929,6 @@ typedef struct {
 #define FILE_PORTABLE_DEVICE			0x00004000
 #define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
 
-typedef struct {
-	__le32 DeviceType;
-	__le32 DeviceCharacteristics;
-} __attribute__((packed)) FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
-
 /* minimum includes first three fields, and empty FS Name */
 #define MIN_FS_ATTR_INFO_SIZE 12
 
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 560900617be7..055c6577b4e9 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -321,6 +321,12 @@ typedef struct server_negotiate_rsp {
 	__le16 ByteCount;
 } __attribute__((packed)) SERVER_NEGOTIATE_RSP;
 
+/* See MS-CIFS 2.2.8.2.5 */
+typedef struct {
+	__le32 DeviceType;
+	__le32 DeviceCharacteristics;
+} __attribute__((packed)) FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
+
 /* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
 #define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
 #define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a05b04799c0d..41167e7cca77 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5469,9 +5469,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	switch (fsinfoclass) {
 	case FS_DEVICE_INFORMATION:
 	{
-		struct filesystem_device_info *info;
+		FILE_SYSTEM_DEVICE_INFO *info;
 
-		info = (struct filesystem_device_info *)rsp->Buffer;
+		info = (FILE_SYSTEM_DEVICE_INFO *)rsp->Buffer;
 
 		info->DeviceType = cpu_to_le32(FILE_DEVICE_DISK);
 		info->DeviceCharacteristics =
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 016ec93e6df4..86d18a8badff 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -56,11 +56,6 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-struct filesystem_device_info {
-	__le32 DeviceType;
-	__le32 DeviceCharacteristics;
-} __packed; /* device info level 0x104 */
-
 struct filesystem_vol_info {
 	__le64 VolumeCreationTime;
 	__le32 SerialNumber;
-- 
2.43.0

