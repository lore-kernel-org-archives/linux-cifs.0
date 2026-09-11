Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7459F4A5C22
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144625; cv=none; b=AWwtPhBEVxZ06bNwzrx+Mk9ZVgHIzuvFBcdACt9Glnt5uPv+qqQPkLmSzlawiSD7tU0jDq2mYORNdqKlzplMnb1m0FJ9EPMGQ/xRPYuVBKDZEU9CVAcXwLdqwCou0ng2zCDQziT9xQylSdvDLSrZS0ORhGTO/5fe8+SnRGtOCE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144625; c=relaxed/simple;
	bh=uabykUrq5mWvHqjtaPI1rja+RFyS1MsbFPJX5BlQzxA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h3S5dW3W/I3pNPy8rSYm+HfvyH4Fy3UeaAiYewb2lVdEugDqoQVzVq6rlpYiy6X9xwWt5McGC3nYHPubwsJcdYpvoaNA5zPOtrcQE7rWJPc9i+Nf/sCtPbHvMA0CqoT9Yo08R8FzQHZYOjs4R0NX3c2Qlh6u+BQ5XhFojmmOgKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WwbjL/Yc; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="WwbjL/Yc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=0m
	pt+pwzBw0cFGV0f1Vr8cVMgJkFp5gL2+eoYj2GfGg=; b=WwbjL/YcvJGn+2XiUO
	hjNj+/Ld/Don3ej9Y4cE9F2wxCCCVzhGYseDF3Nd4xavn2I1h5QyiiviL5+UrITq
	QzgSZRC4KIpcw8SicD2Zuc/Zi4bcYeIXYgquvOEYLp9JsAV0ii4G92GzWfGFWWXP
	TRN5pvsFGSiR3fGtB6HS58oOk=
Received: from hh.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDnmY37LaRqM4PiOg--.53919S6;
	Sat, 12 Sep 2026 00:36:14 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>,
	Sashiko <sashiko-bot+sashiko@kernel.org>
Subject: [PATCH v2 4/4] ksmbd: report IPv4 and IPv6 addresses independently in iface query
Date: Sat, 12 Sep 2026 00:35:16 +0800
Message-Id: <20260911163516.6403-5-15815827059@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911163516.6403-1-15815827059@163.com>
References: <20260911163516.6403-1-15815827059@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDnmY37LaRqM4PiOg--.53919S6
X-Coremail-Antispam: 1Uf129KBjvJXoW3WF4kJF48Xr4UKr4rAryrWFg_yoWxZrWfpF
	13AFWDAr4UJw1fWw4kJr17Cw1a9rykKay7CFZ3Cw1Skr4YkryfCrs7try7Za48ArWrZF4F
	qr4UZFs0ga18CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jcID7UUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbC8B5O02qkLf7V-QAA3G

From: Henry Hu <huhai@kylinos.cn>

fsctl_query_iface_info_ioctl() appends an entry before checking that a
usable address was found, so it advertises unspecified-address
placeholders: an entry containing 0.0.0.0 when an in_device exists but
has no primary IPv4 address, and an entry containing :: when an
inet6_dev exists but its address list is empty or every address is
tentative or deprecated.

The loop also couples IPv6 reporting to IPv4 success: when
__in_dev_get_rtnl() returns NULL it continues to the next interface,
skipping the IPv6 pass, so an interface without an in_device is dropped
even if it has a usable IPv6 address.

Query IPv4 and IPv6 independently and append an entry only when an
address is found. Factor out the common entry initialization and query
the link speed once per interface instead of once per address family.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Henry Hu <huhai@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 127 ++++++++++++++++++++++------------------
 1 file changed, 70 insertions(+), 57 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ff3a0da7d749..9e1b48ed5bc2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10457,6 +10457,27 @@ static __be32 idev_ipv4_address(struct in_device *idev)
 	return addr;
 }
 
+static struct network_interface_info_ioctl_rsp *
+ksmbd_iface_entry_init(struct smb2_ioctl_rsp *rsp, int nbytes,
+		       struct net_device *netdev, unsigned long long speed)
+{
+	struct network_interface_info_ioctl_rsp *nii_rsp;
+
+	nii_rsp = (struct network_interface_info_ioctl_rsp *)&rsp->Buffer[nbytes];
+	nii_rsp->IfIndex = cpu_to_le32(netdev->ifindex);
+	nii_rsp->Capability = 0;
+	if (netdev->real_num_tx_queues > 1)
+		nii_rsp->Capability |= RSS_CAPABLE;
+	if (ksmbd_rdma_capable_netdev(netdev))
+		nii_rsp->Capability |= RDMA_CAPABLE;
+	nii_rsp->Next = cpu_to_le32(152);
+	nii_rsp->Reserved = 0;
+	nii_rsp->LinkSpeed = cpu_to_le64(speed);
+	memset(nii_rsp->SockAddr_Storage, 0, 128);
+
+	return nii_rsp;
+}
+
 static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 					struct smb2_ioctl_rsp *rsp,
 					unsigned int out_buf_len)
@@ -10471,7 +10492,12 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
-		bool ipv4_set = false;
+		struct inet6_ifaddr *ifa;
+		struct inet6_dev *idev6;
+		struct in_device *idev;
+		struct in6_addr ip6 = { };
+		bool have_ip6 = false;
+		__be32 ip4 = 0;
 
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
@@ -10482,25 +10508,6 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		flags = netif_get_flags(netdev);
 		if (!(flags & IFF_RUNNING))
 			continue;
-ipv6_retry:
-		if (out_buf_len <
-		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
-			rtnl_unlock();
-			return -ENOSPC;
-		}
-
-		nii_rsp = (struct network_interface_info_ioctl_rsp *)
-				&rsp->Buffer[nbytes];
-		nii_rsp->IfIndex = cpu_to_le32(netdev->ifindex);
-
-		nii_rsp->Capability = 0;
-		if (netdev->real_num_tx_queues > 1)
-			nii_rsp->Capability |= RSS_CAPABLE;
-		if (ksmbd_rdma_capable_netdev(netdev))
-			nii_rsp->Capability |= RDMA_CAPABLE;
-
-		nii_rsp->Next = cpu_to_le32(152);
-		nii_rsp->Reserved = 0;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd) &&
 		    cmd.base.speed && cmd.base.speed != SPEED_UNKNOWN) {
@@ -10510,60 +10517,66 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 				    "speed is unknown, defaulting to 1Gb/sec");
 			speed = SPEED_1000;
 		}
-
 		speed *= 1000000;
-		nii_rsp->LinkSpeed = cpu_to_le64(speed);
 
-		sockaddr_storage = (struct sockaddr_storage_rsp *)
-					nii_rsp->SockAddr_Storage;
-		memset(sockaddr_storage, 0, 128);
+		/*
+		 * Query IPv4 and IPv6 independently; emit an entry only when a
+		 * usable address exists, so an interface missing one family is
+		 * still reported for the other and 0.0.0.0 / :: placeholders are
+		 * never advertised.
+		 */
+		idev = __in_dev_get_rtnl(netdev);
+		if (idev)
+			ip4 = idev_ipv4_address(idev);
 
-		if (!ipv4_set) {
-			struct in_device *idev;
+		idev6 = __in6_dev_get(netdev);
+		if (idev6) {
+			rcu_read_lock();
+			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
+				if (ifa->flags & (IFA_F_TENTATIVE | IFA_F_DEPRECATED))
+					continue;
+				memcpy(&ip6, ifa->addr.s6_addr, sizeof(ip6));
+				have_ip6 = true;
+				break;
+			}
+			rcu_read_unlock();
+		}
 
+		if (ip4) {
+			if (out_buf_len <
+			    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
+				rtnl_unlock();
+				return -ENOSPC;
+			}
+
+			nii_rsp = ksmbd_iface_entry_init(rsp, nbytes, netdev, speed);
+			sockaddr_storage = (struct sockaddr_storage_rsp *)nii_rsp->SockAddr_Storage;
 			sockaddr_storage->Family = INTERNETWORK;
 			sockaddr_storage->addr4.Port = 0;
-
-			idev = __in_dev_get_rtnl(netdev);
-			if (!idev)
-				continue;
-			sockaddr_storage->addr4.IPv4Address =
-						idev_ipv4_address(idev);
+			sockaddr_storage->addr4.IPv4Address = ip4;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
-			ipv4_set = true;
-			goto ipv6_retry;
-		} else {
-			struct inet6_dev *idev6;
-			struct inet6_ifaddr *ifa;
-			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6Address;
+		}
+
+		if (have_ip6) {
+			if (out_buf_len <
+			    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
+				rtnl_unlock();
+				return -ENOSPC;
+			}
 
+			nii_rsp = ksmbd_iface_entry_init(rsp, nbytes, netdev, speed);
+			sockaddr_storage = (struct sockaddr_storage_rsp *)nii_rsp->SockAddr_Storage;
 			sockaddr_storage->Family = INTERNETWORKV6;
 			sockaddr_storage->addr6.Port = 0;
 			sockaddr_storage->addr6.FlowInfo = 0;
-
-			idev6 = __in6_dev_get(netdev);
-			if (!idev6)
-				continue;
-
-			rcu_read_lock();
-			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
-				if (ifa->flags & (IFA_F_TENTATIVE |
-							IFA_F_DEPRECATED))
-					continue;
-				memcpy(ipv6_addr, ifa->addr.s6_addr, 16);
-				break;
-			}
-			rcu_read_unlock();
+			memcpy(sockaddr_storage->addr6.IPv6Address, ip6.s6_addr, 16);
 			sockaddr_storage->addr6.ScopeId = 0;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
 	}
 	rtnl_unlock();
 
-	/*
-	 * nii_rsp may point to an entry not included in nbytes if the IPv4
-	 * or IPv6 device lookup failed. Clear Next in the last returned entry.
-	 */
+	/* Clear Next of the last committed entry to terminate the list. */
 	if (nbytes > 0) {
 		nii_rsp = (struct network_interface_info_ioctl_rsp *)
 			  &rsp->Buffer[nbytes - sizeof(*nii_rsp)];
-- 
2.25.1

