Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AA7296BD0;
	Sun, 12 Oct 2025 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281922; cv=none; b=J92n7NpyajdtYLSkMJKnPsY1jIVA1mjrczVfK8BprQ+yezkK8bJKj/ycRKgn0VCRx41p9fOyJt6EPqNhJedX3UD4pwB+0sbUme0ViuTzv5HtXckG8npStNcoAL06k3Y0/SsHpdsx6cd9lA18MBAjl8u44F4f9IRvZlJVfZ5XbIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281922; c=relaxed/simple;
	bh=h8rXpMFfHIROBKkRmkoCt2Bb21FexDTnSrRb1R1hAAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNtGPDPTbGKZhQVQIaD+8zDF03KT+wQ32M+WOSesGVYMPPqTKz1SbFEfLldS7Col3p/6coYlu3Oa2ZN0p5AyA7GM5Tm7AKFCrrG4TYcUTQuuuWvKM+EafF8IpW3YUoVHJTA5XrbyOBVuA+f2o/xk41KJuYJkYltVhsu5p0/48cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281822t2ae7ab6a
X-QQ-Originating-IP: 2vPsGU0OwO1yRDGYjebapCcIRuF/AAbGjXFKqLDo6WM=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2608946645097381380
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
Subject: [PATCH 08/22] smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:09:01 +0800
Message-ID: <BDC099D2EB3E3711+20251012150915.2992220-9-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: Mw3/skGyA4U5uiJ3cdt52BmWd7SPoXebHY6eva8vqZGPZXtoj63iQOMl
	a1bdsFBnyGoPX6looNaWFDaULxst9V63IXk88sEizK6ZlpgNZg1OrQLdzHH0MkXNimuEUlh
	lUGrql1KVUdfXsBMYEmOjwHvBMkOGC6doTvqbjZnOsmaI/kEC1+z7MBmLDlehrWMRNgpn3O
	S6A+6Ifyk3+9Qeq6bB3ujkqBu8xbp3kAX/nQhyT4xVsJJ51HgDkHNMei+aKCFXxq9RhiN0l
	m+W1foKSYgCsyWUnaMfsO30VxDsbFPvuXHopnYbKTzLSmj9tuE7Tte61WR6gnr+A9Qxm5e4
	J12A0zCzVKrm49Dv6eQCJDXXQD+aZHB1QVUhH2LymIC/NWSmS+eRB4pHnVgva38fyDADbWr
	gsh9JLVLVwYsgbuaLk2PqUPcmFaxY9sHSH/k/xJM9n1xKwlAvhgSKxn+WyhTkpK02y0E3BF
	Nttpb6c55Spg0k+sKKD8dKoAcTfH5QkZVcPlUak/pY0phhWibBuy+eOSLMueD8fRltp0L6S
	0QGzeT8nWTwrlGCQWCB+HroWPA36FCVreGy9yOuY8Ud1hr7rLj55K65qy5IO4q3J8i5VfQY
	ySYyHfrnbbGxpJUPRMyaWrxODvhWOd395sOCfMJ0yZZF2ZvigMUQt5VMvpq1hhKR97bJ8SW
	9/GArEoOH/9lNGichWpjEtFgdKFsLipoPkgFdP6jLQ4Zkx3wXwLdpidsexif0fmQ3v2GL24
	aYnXnYVOwwY8YWFXO3SngfXdX+vj4e4bKydjtvMv7Mvz1oXld2/oADOheH8RHgfCSuQYk+D
	EcZykgcb91qR1PEGyHQJon26Johjmgzl9OFhRONnvZoxTATo8cWJzPi9Xm/GFi4rzP1zjah
	MljI4t3n5QsjitavkzGFS5zGj92p4smupozasuKYtOULWHBoi+CxUIFqoL4Gz2iR2bt7ps9
	lwEG3FiGO8mwdwyzSmipoxD6yESVutUQnsYodVDMfjH9tB1+nh1iExrpOEawYk0bryG447x
	K5WY6aCIu5P1DSpLWsCL13vCZwTT2V12JDUcC0ww==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
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

