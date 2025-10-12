Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B2E2ECD10;
	Sun, 12 Oct 2025 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285942; cv=none; b=j1kkJgZyUivlWPuxCWahmOWtdFs0UlzD7GKoFVBl6pVTzfIp+Lm1LiJAL7yiiWj2JDu+/OYtyT3Nr6GvSchhX5WiVzX6ExWF8EVHv46UChMWG7cPpiJkkJ8b/YXK5/LTt57YJJyiwuYT5A+vgtSkOzaRZAWMTthrFBgGZpMWnW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285942; c=relaxed/simple;
	bh=h8rXpMFfHIROBKkRmkoCt2Bb21FexDTnSrRb1R1hAAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAmwAeiai44R6Fpm4Mc5xGqM1NusQcosYxdKvdaFXrAAh+KS7aIuo+T9quLuD6Fr45/6SMSj4nLwouVKIro53H33BkGnbR1q7X3JSI8vHzPCYhkHPdQpLW1nf8uOBms+p3lICWo1mdlhBtcFJyICk5D9faIDHsQ6/QbORjCX7Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285910t6236b11d
X-QQ-Originating-IP: +nR27UR9SSIqLNRdQxBagBGmFY8W7YKymp5qBLE3xpY=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 6043280042060759507
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
Subject: [PATCH v2 08/22] smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
Date: Mon, 13 Oct 2025 00:17:35 +0800
Message-ID: <F830E0015A50E7B6+20251012161749.2994033-9-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: MjcRpReXhIb0bbB6nyMEsBfUk3znBikFQPwvwgOrEEHYe6qL+8C7TvWS
	kKVBzc0Aruk96o6nZktFpF40h0WvXRt2cYauGco+2HzvoHkLVntzxFQO6xdrI50CJTQZlqC
	ihaggp06tD5zRGkdg8h2nVBSAR+w+YXu9WqfnUCnvTGCkyQ+B8w33KmkN0SE+18+DZkTDVa
	1NU5ayVt2+TaBoVijLF/dDHklpDUL2swASZfLeyXZIMXppz9uxg8wM/jApx09v1BHKEPb9R
	m716NDm5ZCz+nnBhWG9bTYB4rk0LwcFvJ7BR4WwpvqJyQQx1Sblqk6/sD50yAxCKFmvTt9v
	EoBiR3UeiivKGcUivykqitbKyZYyVcG9Y9CdvhvjQ+u49nVZPLDlRPYCIq8sAonq2S8MGo0
	ra7BcyRKK52El4RGsEqDMS2/x0x4xGLiDYF+y/24uqCrXxy78oy4OnfXus8+pc4qI+9Qf3r
	PqHiKIxTpdmTFsinU3FeKRChnMfoecFPaDPRq9TNN6tmgvduvQiTiAgY85RtWGJmSlXlbJR
	1y9CFRbGlsSwhvZIK2I0bk7soJftr++pedw9vHXBT9Tno0PJnBdvhqUEyMKTzT99RKBVzEj
	iE0DDtW6Ic7i4S/5pgitl/X1K4d0pFDKmtHC6DilTtuYaCqPIqw/h7ykPX3urrXRGxEP+kA
	aEAwF80I4aPPRmVJK/nBlKRUr3jiVpAJn5N6yO36mWhkv1a8mDIaONT1fWBN/rcMys22HT3
	omoM+s8Yyy8uoyD74xqxSXmvojiRKzEB/P1cs5WYrM7TMKigflM3HMvv0+YHwxJD9FBq8ub
	VmHiXITgyjwDMSco3C4I9tVtVGtIklcQWzL4SsKTU+yrFY/+ZhNiJQSEIgF8ilGbdmRCrac
	4v/+Qb1x25eIkSP1JWvHkE7UfwMu2v8RUrvDnI1Uu2CzjeFPtCx1c3lvkEaM6bGM+wwiz1+
	pdU/qcdN5xHLIzxrTzQk9IEW0e9I1uEc7PZQM78e0ccpi73uSytSTbrLAvlSka7XT2HiItR
	WoSIMV6SDMwwVjJ4d5qgbAxF89Sn47G/b1j+ty2zTNpXVO2RtZxKCSQGCnGsFQVLFVV0Xc7
	SI813RXTt4tmSopkgb8rBo=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Rename 4 places:

  - iface_info_ipv4 -> smb_sockaddr_in
  - iface_info_ipv6 -> smb_sockaddr_in6
  - IPv4address -> IPv4Address
  - IPv6address -> IPv6Address

Then move duplicate definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/smb2ops.c |  8 ++++----
 fs/smb/client/smb2pdu.h | 13 -------------
 fs/smb/common/smb2pdu.h | 15 +++++++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h | 13 -------------
 5 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7c392cf5940b..e90ca77d2ac7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -624,8 +624,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	struct network_interface_info_ioctl_rsp *p;
 	struct sockaddr_in *addr4;
 	struct sockaddr_in6 *addr6;
-	struct iface_info_ipv4 *p4;
-	struct iface_info_ipv6 *p6;
+	struct smb_sockaddr_in *p4;
+	struct smb_sockaddr_in6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
 	ssize_t bytes_left;
@@ -685,7 +685,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		 */
 		case INTERNETWORK:
 			addr4 = (struct sockaddr_in *)&tmp_iface.sockaddr;
-			p4 = (struct iface_info_ipv4 *)p->Buffer;
+			p4 = (struct smb_sockaddr_in *)p->Buffer;
 			addr4->sin_family = AF_INET;
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
@@ -697,7 +697,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			break;
 		case INTERNETWORKV6:
 			addr6 =	(struct sockaddr_in6 *)&tmp_iface.sockaddr;
-			p6 = (struct iface_info_ipv6 *)p->Buffer;
+			p6 = (struct smb_sockaddr_in6 *)p->Buffer;
 			addr6->sin6_family = AF_INET6;
 			memcpy(&addr6->sin6_addr, &p6->IPv6Address, 16);
 
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index c013560bcfa1..0be63c00f848 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -261,19 +261,6 @@ struct network_resiliency_req {
 } __packed;
 /* There is no buffer for the response ie no struct network_resiliency_rsp */
 
-struct iface_info_ipv4 {
-	__be16 Port;
-	__be32 IPv4Address;
-	__be64 Reserved;
-} __packed;
-
-struct iface_info_ipv6 {
-	__be16 Port;
-	__be32 FlowInfo;
-	__u8   IPv6Address[16];
-	__be32 ScopeId;
-} __packed;
-
 #define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not to file */
 
 struct compress_ioctl {
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 25e8ece283c4..b01114108d23 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1428,6 +1428,21 @@ struct network_interface_info_ioctl_rsp {
 	};
 } __packed;
 
+/* See MS-SMB2 2.2.32.5.1.1 */
+struct smb_sockaddr_in {
+	__be16 Port;
+	__be32 IPv4Address;
+	__u8   Reserved[8];
+} __packed;
+
+/* See MS-SMB2 2.2.32.5.1.2 */
+struct smb_sockaddr_in6 {
+	__be16 Port;
+	__be32 FlowInfo;
+	__u8   IPv6Address[16];
+	__be32 ScopeId;
+} __packed;
+
 /* this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA */
 struct file_zero_data_information {
 	__le64	FileOffset;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 169fbec03cfd..dd6f1375a833 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7903,7 +7903,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			idev = __in_dev_get_rtnl(netdev);
 			if (!idev)
 				continue;
-			sockaddr_storage->addr4.IPv4address =
+			sockaddr_storage->addr4.IPv4Address =
 						idev_ipv4_address(idev);
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 			ipv4_set = true;
@@ -7911,7 +7911,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		} else {
 			struct inet6_dev *idev6;
 			struct inet6_ifaddr *ifa;
-			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6address;
+			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6Address;
 
 			sockaddr_storage->Family = INTERNETWORKV6;
 			sockaddr_storage->addr6.Port = 0;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index fe92bfeb415a..5a76b706ccd9 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -136,19 +136,6 @@ struct create_posix_rsp {
 
 #define SMB2_0_IOCTL_IS_FSCTL 0x00000001
 
-struct smb_sockaddr_in {
-	__be16 Port;
-	__be32 IPv4address;
-	__u8 Reserved[8];
-} __packed;
-
-struct smb_sockaddr_in6 {
-	__be16 Port;
-	__be32 FlowInfo;
-	__u8 IPv6address[16];
-	__be32 ScopeId;
-} __packed;
-
 struct sockaddr_storage_rsp {
 	__le16 Family;
 	union {
-- 
2.43.0

