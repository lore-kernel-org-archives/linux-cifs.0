Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B226F2DFA5A
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549839; cv=none; b=k9Wbi51exogsnMpUQdQY1eTWAHYw1KN86WRZHCqKRgirFbmoQh6wt8PKisj7e5Jz7OAtLlwKcgKG3kuVPBeXMvpn5Ts82l2zIce/goq1DUyFqQtsY/Tcqx4nLIaT5CAzsycnyhz2f33tjIUbGeVckeKtX6Pp6H1FvrXOMhfhzaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549839; c=relaxed/simple;
	bh=lm/tK9pKP3kfe8IUsXAzbUd55nvSXO7lhA6B/h/81Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHLfFUAxa9Cb6TAK4DLeZRNXmg4ARYOHMJ+5DGhSNI2BWif1LfmoEa1tZViE5e0aTkiIxFyDr4AtisXarg2mhyryT67X8uKHJ9ZUXcUmgZJmPji97xllCptMVdIjL/OZgvA7fGYnT+yl5D76yhLtj+PzENgL7d1IJX3jKtf2fdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X7JQrhBK; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X7JQrhBK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNMx+mS9oi/4/9XGraq2gniUdtLbevqPEBur+tTV9Xs=;
	b=X7JQrhBKfPPaSVRb+mr72nCWVHWrP7i13jxHw+pEF5KvB5yXvzCLYNScy5itD+bmtLoNMH
	Vvf0fQAXBoSy8j0Pu0yWVhlSdoNS0rxGNbAgNMxZ3fuBcUc0UdOrepH2VE9ojno4saUv1t
	N7QdBg2v2266IashQSDMvqIxRXS5Ggo=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 21/24] smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
Date: Mon, 27 Oct 2025 15:22:03 +0800
Message-ID: <20251027072206.3468578-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

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
index 0f9130ef2e7d..1b9995ebb895 100644
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
index 6def502f68b7..a0f73b183c0e 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -244,19 +244,6 @@ struct network_interface_info_ioctl_rsp {
 	__u8 Buffer[126];
 } __packed;
 
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
index 704096c251b7..2b56a17bccdb 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1440,6 +1440,21 @@ struct smb2_ioctl_rsp {
 	__u8   Buffer[];
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
index 06da751063b5..c1ea4b747625 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7910,7 +7910,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			idev = __in_dev_get_rtnl(netdev);
 			if (!idev)
 				continue;
-			sockaddr_storage->addr4.IPv4address =
+			sockaddr_storage->addr4.IPv4Address =
 						idev_ipv4_address(idev);
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 			ipv4_set = true;
@@ -7918,7 +7918,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		} else {
 			struct inet6_dev *idev6;
 			struct inet6_ifaddr *ifa;
-			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6address;
+			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6Address;
 
 			sockaddr_storage->Family = cpu_to_le16(INTERNETWORKV6);
 			sockaddr_storage->addr6.Port = 0;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 25c20b26315b..fb4df2860481 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -100,19 +100,6 @@ struct create_posix_rsp {
 
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
 #define INTERNETWORK	0x0002
 #define INTERNETWORKV6	0x0017
 
-- 
2.43.0

