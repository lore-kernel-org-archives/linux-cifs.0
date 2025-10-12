Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839312EAB64;
	Sun, 12 Oct 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282653; cv=none; b=cZVC3SDgxtmq7ouWU1AcUAlpmHAYlVOFu5WOaa0IKyQEZGVAS6+068Sz4bbMY6rFuDFAky58cdF+YfPxvZt6sYs4H0ckjqTIAZdSmvdGVfsmUjIFzWJ2Q2y9UMbh5f5cqdsshc29bzixjNRr6cjC/qs+uT46Ji7WWTETGqXqEwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282653; c=relaxed/simple;
	bh=h8rXpMFfHIROBKkRmkoCt2Bb21FexDTnSrRb1R1hAAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCSWEupcWtqi/X2SoxRgs8uVEgAdN6afHRFUn3u3UaCWPI/kl/fBZxfT+1RJgT1mcK9Xeg2ZH3tfRYm8+R4KOZO/EG8NkYFn1aL70VbPR/14M/5j+t8Be5H4dU1Eo4/krpMdbc9F+L0mWFXwO+bv5AO9mijJkNS8ksh/iqlaGNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282603t5077ace3
X-QQ-Originating-IP: VEM1PenpFvzeK7+WyVpTMtx5cIniwc2lST9pSUafnsg=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9079638070132374725
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
Subject: [PATCH RESEND 08/22] smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:22:33 +0800
Message-ID: <E54BB92E4BB7D73F+20251012152247.2992573-9-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: N8viprakw3Bkhm+JKmrqql+XrF7IMP9CNZlZMISchWFCbvHmgZw+7kxe
	0wqmlKSxvi3a2NosL3W/i6n2Gh7ZkrAndbDG3L/VGcTUa288RhUJR1/wJXvDVWOyapg4dZY
	ERQzTvofsmVFcjj/rX9INwREEV4rYW8Qfe4qNPGTDNZUge+I91kvGOqsYPJ2BNqY/nMOMsK
	i3RwSkmnXgb7A5MqpB7mtmLhp+Qil+z9ZDtM9Wn6xqRMcHS0O6kxnWdgdCxKiCBT1I6juG4
	XIn4irTLnq+ICO2BhTK+C2HjVDzv6bSpCqy9RCRlfEKuXm+5DAUaMXr9JwuoIvcfLZW/n51
	uhHi4NxDISCZFFm1gj5LMoGkrBleZ4HCpru7kgtzl9NI9vFhRQNgzxIG5OxAdvIzNLiOzzP
	D+4VigqOF7IOdJcKqZWDbFbrrv2N5tFDAwyfmjJU5HXJTLKP5gqzv0LG66S8iN5edyHfSXk
	M7bTaE+fr+ZdfEP9a3ze8/hCe3sf8A1B2c3GMBc8NWqczrG6wFHGaLTp3+1imyk9yCyZ1mE
	lTqim2oFUrw51R4MKGEVHFjjqMj6EsjeVdUTdPfWZCHpC2Y8GynASWqWueB5Qjh5qH3/uhO
	giYqAzmANlUBY/AfwnHYn2xx/4nQs30/WBXRP3ENScLHzbzDeaIs8R6lbv0mkq0xoTWqnQS
	8FVeVfDDzvBSqwfy9ALoel5FQ5y8JPR0xCgPyddXTs6vySBg46Pr7cL5FU27Nsoid/Muotf
	dsdr+lNxgNnZ3ySd1ubZB2Zzp/AfQg9F2U5SdG0QB+bW1Gb6gDzHrAQviHZcjU2V02EVxB7
	ZNfDboh/YY4QkoR7kleTmyLnsQohXlAU4JhesDRxRhWpcv+4+ViXsWhcqYC+F1GWQvQqd/L
	zogINSmuyMjtSAwVdlhqXyD9/QWLLSBubUcTTwTCOUx2CUsUMLg1Yj/SP5Sje4RDX9C7IGG
	WPuuKSRzV5hYkKDLbIvpsvxE/luDYKImco7gV2QGmq8KXnrkUKUPlak933Cr0zagk733/fr
	qGdy26+LmP+EQ5HTBA2w6+3S5FABDUsc1IgWFh/jiFGXyzJlSi3ICOBSjIll4mhgUiixtzT
	BpQjl9U0iSA3Jqokm+8R8Y=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
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

