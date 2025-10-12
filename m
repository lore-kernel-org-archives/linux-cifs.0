Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D322EC541;
	Sun, 12 Oct 2025 15:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.54.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282681; cv=none; b=ZuCZ2Z8/gU01jQ05RqlPQZH2XTr/sU3ngV9UBDpfpZuPHU6kIbMrWTBBhzTSC+KyzBMriimbkXsVGhD6rR6CeuUZZdIi1HJpYlqq0/JScqIlOXKRzb5+nK6Jm8zyo9rYVa6UyeQmXo3+Fx0x0Dzy3SssRT317QcQ4HIlgZvgI4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282681; c=relaxed/simple;
	bh=Y9wrdmUvcRzPjtXYSUCxLg+ZW9FFrwdIQIEu9DqTqJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAvgY5JDFgTOEn7oayKne0pp0olkXZ2rp+PHmkqlQOgN05r8i6iBuivS9+oKrU23bLHIV5GX5UurVkme6seB1t28/mZc6LfhOts27DN2w9pwcNeYuOucm02vdN5mB1a6aIgirRzQYtZBm7mR0KWlj65iaYD37qWnG1CXXs5I5YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.54.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282608ta3a44a83
X-QQ-Originating-IP: +JS9k5Gx5nL9UGzAb5m572L5KDZNC6Wt+Ap79wazYk8=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:27 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3089997548282611321
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
Subject: [PATCH RESEND 11/22] smb: move smb2_file_network_open_info to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:22:36 +0800
Message-ID: <C0AE180503D37CB6+20251012152247.2992573-12-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: N++dizDpbYWyi9iZFCCTHLNFaFKqmlD8SxowQAtxfY4+MV1wLkdAj6MC
	3av94ZUaaeEPWKbI/2ispSyFMxsjHKILICTCZfSecDyauF5o4tNFJSHukJ0unRUVhG1xeTl
	ZCgI7lbgmmfu8vVTZ50bupJw1b9LnkRsUeG9qODdxGbmkhS/kOacszyhNQ1B49T25T8Ivme
	3nG1h+jeuYjZhxYXZDvdPhNz7N5htDxQfrK0IRCfJDo4fZhyd48mrFi4TAgWIqpF1JHHGNJ
	Via4WphPCz7Q3nqz0bFJ4WPG/1L3sLVVN2bo4zQ3OT52S2HcisUccDQG7Z06fjsZ7kK89fc
	v46xpzQJbEem6NnbexsJ9cD/nuwhTymJ4fyAGiyMYcNB5zY2VaMHg+c6n40BxxaIHFqUlER
	8f90/4bY7Kk4jaaxW9hwsAaMOmX7P0qE0Vepjuho/1rXSQcCm5LsmJZm6ow7wO0PzEZFUUr
	PJNlufNLt/KItuFaJAIJ/36YziIKUpkhJT/O/3eOWld0e0I3/5MnZkY3kmSvNRlyfYvS4d8
	2axgTkRFd/WHNFgkhjih6qnFV3pRMsuznXAT9kmzRsih1N9a+IlzDjdRIREDShHykCLXJXI
	SG4LgoYhd7JsHxeAywPr/feZ6c2wZnhP26N7nzWFM5Okv98KZ+Q8jlOhhjZg3ieYbi5AQTC
	gf7LP+CzGo9kN1usa2aJDatkg95hXwGhSadjjXyIfGUefvd6286eNnO0gaqrFYhYvRvveSH
	AYHj34IW/1MglKODkcRF8bO/F8xN+JPa8l0o37lv/00KibnKqEdcmnbghJB2MBvycAGuf/n
	SOpXiP6YfOUjU+jY5qWsy6R6h4FWGWKpfeN7suly+3d05hh6UG2ShKViak4VtJwW+CV9xqP
	J1X8LbAv5WQrwJp84q3dQ6YflDRDEf2Z98+dnDaFpgl2ZwNNqXVPgMEnzr1XKQ7FlAXoVRE
	IRom5mrFNXVg/a95BjSuWbiAnzoGtKzKZHAojgew42j7FQPnZtSGY+I9ME4VJMENxSFpzUe
	ltCqKX/RfBGAWzqvBS458ZfDeG3YOUdELBhSxY1OFlQE/dsfumVMd0xChlUGdDO5J9e44pH
	N7OT7OvNuF5zezZTLkKWcJJBj+oJbwHNw==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename smb2_file_ntwrk_info to smb2_file_network_open_info,
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.h | 13 -------------
 fs/smb/common/smb2pdu.h | 14 ++++++++++++++
 fs/smb/server/smb2pdu.c |  6 +++---
 fs/smb/server/smb2pdu.h | 11 -----------
 4 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 77dceca20240..70976a212128 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -262,19 +262,6 @@ struct smb2_file_reparse_point_info {
 	__le32 Tag;
 } __packed;
 
-struct smb2_file_network_open_info {
-	struct_group_attr(network_open_info, __packed,
-		__le64 CreationTime;
-		__le64 LastAccessTime;
-		__le64 LastWriteTime;
-		__le64 ChangeTime;
-		__le64 AllocationSize;
-		__le64 EndOfFile;
-		__le32 Attributes;
-	);
-	__le32 Reserved;
-} __packed; /* level 34 Query also similar returned in close rsp and open rsp */
-
 /* See MS-FSCC 2.4.21 */
 struct smb2_file_id_information {
 	__le64	VolumeSerialNumber;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 15932ee05c98..f5c8c72b8959 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1971,6 +1971,20 @@ struct smb2_lease_ack {
 	__le64 LeaseDuration;
 } __packed;
 
+/* See MS-FSCC 2.4.34 */
+struct smb2_file_network_open_info {
+	struct_group_attr(network_open_info, __packed,
+		__le64 CreationTime;
+		__le64 LastAccessTime;
+		__le64 LastWriteTime;
+		__le64 ChangeTime;
+		__le64 AllocationSize;
+		__le64 EndOfFile;
+		__le32 Attributes;
+	);
+	__le32 Reserved;
+} __packed; /* level 34 Query also similar returned in close rsp and open rsp */
+
 #define OP_BREAK_STRUCT_SIZE_20		24
 #define OP_BREAK_STRUCT_SIZE_21		36
 #endif				/* _COMMON_SMB2PDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 200bce13b467..a46d4ddade9e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5126,7 +5126,7 @@ static int get_file_internal_info(struct smb2_query_info_rsp *rsp,
 static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 				      struct ksmbd_file *fp, void *rsp_org)
 {
-	struct smb2_file_ntwrk_info *file_info;
+	struct smb2_file_network_open_info *file_info;
 	struct kstat stat;
 	u64 time;
 	int ret;
@@ -5142,7 +5142,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	if (ret)
 		return ret;
 
-	file_info = (struct smb2_file_ntwrk_info *)rsp->Buffer;
+	file_info = (struct smb2_file_network_open_info *)rsp->Buffer;
 
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
@@ -5161,7 +5161,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	}
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb2_file_ntwrk_info));
+		cpu_to_le32(sizeof(struct smb2_file_network_open_info));
 	return 0;
 }
 
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 3d000c5d964b..8c8e775b601e 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -245,17 +245,6 @@ struct smb2_file_stream_info {
 	char   StreamName[];
 } __packed;
 
-struct smb2_file_ntwrk_info {
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 AllocationSize;
-	__le64 EndOfFile;
-	__le32 Attributes;
-	__le32 Reserved;
-} __packed;
-
 struct smb2_file_standard_info {
 	__le64 AllocationSize;
 	__le64 EndOfFile;
-- 
2.43.0


