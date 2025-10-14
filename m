Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501F730F520
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426488; cv=none; b=QQZl3nMSEj6Ms9jdjQr9B2Qg6/zb1YJM121kaP/Cv7NnFXV6U2d4ODIB3H9Ca04WhBMITUvwik1+hiAOFX3QSDA3zHmW8y1tTJ/V+pCgMbzTvTnEDkx+yARYLU93cvbQ5i6hJyG1KC0jaxGbq/OcKrTITvCgaZBqiZdOUZ4iL8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426488; c=relaxed/simple;
	bh=oeqLPDpudEfH9dps5z2KcrSJw2zXBQjtIeVUQecIez4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9z/rxxv+AqKxvTMk5BBxXn3UqrGMHEOhIWi4N/kvuDPErLymvPrt+Greo77gSjVXJF6o90a/ZzJnf6sM/6UBuWWIXqgvNmf5R48zOuwhrIfboCVz2X1kIyX9iRsBXz1Xgw8c0zbYK1gqjwxImqiSPRo1mJfBvQs9WnjoAVENfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f6d/3SMM; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f6d/3SMM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760426483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YMZS34CuxNYb4KbLTws4rtdEbdVJCN1J1LsMMHkOUhQ=;
	b=f6d/3SMMm7qOEnV7/cKAjAaAYriXAB9Iq7RsF7G/orintRmk1svudL9LEcn5QJmrj+zeDy
	8UkEHoSKc27c8ncbOyNFmRLvUdMoXMkHN+CaMseMyQKyCNNLE6LJSO4OTArgyt6nlAAFD3
	GSCR6zjYuHNhIVdMVZmqgblE/y45OjY=
From: chenxiaosong.chenxiaosong@linux.dev
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
	christophe.jaillet@wanadoo.fr,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 07/22] smb: move some duplicate definitions to common/smb2pdu.h
Date: Tue, 14 Oct 2025 15:19:02 +0800
Message-ID: <20251014071917.3004573-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

In order to maintain the code more easily, move duplicate definitions to
new common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/smb2pdu.h | 24 +++---------------------
 fs/smb/common/smb2pdu.h | 24 ++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  8 ++++----
 fs/smb/server/smb2pdu.h | 17 -----------------
 4 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 101024f8f725..c013560bcfa1 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -135,11 +135,9 @@ struct share_redirect_error_context_rsp {
 
 
 /* See MS-SMB2 2.2.13.2.11 */
-/* Flags */
-#define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
 struct durable_context_v2 {
 	__le32 Timeout;
-	__le32 Flags;
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
 	__u64 Reserved;
 	__u8 CreateGuid[16];
 } __packed;
@@ -157,13 +155,13 @@ struct durable_reconnect_context_v2 {
 		__u64 VolatileFileId;
 	} Fid;
 	__u8 CreateGuid[16];
-	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.12 */
 struct durable_reconnect_context_v2_rsp {
 	__le32 Timeout;
-	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
 } __packed;
 
 struct create_durable_handle_reconnect_v2 {
@@ -263,22 +261,6 @@ struct network_resiliency_req {
 } __packed;
 /* There is no buffer for the response ie no struct network_resiliency_rsp */
 
-#define RSS_CAPABLE	cpu_to_le32(0x00000001)
-#define RDMA_CAPABLE	cpu_to_le32(0x00000002)
-
-#define INTERNETWORK	cpu_to_le16(0x0002)
-#define INTERNETWORKV6	cpu_to_le16(0x0017)
-
-struct network_interface_info_ioctl_rsp {
-	__le32 Next; /* next interface. zero if this is last one */
-	__le32 IfIndex;
-	__le32 Capability; /* RSS or RDMA Capable */
-	__le32 Reserved;
-	__le64 LinkSpeed;
-	__le16 Family;
-	__u8 Buffer[126];
-} __packed;
-
 struct iface_info_ipv4 {
 	__be16 Port;
 	__be32 IPv4Address;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index f79a5165a7cc..25e8ece283c4 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1290,6 +1290,10 @@ struct create_mxac_req {
 	__le64 Timestamp;
 } __packed;
 
+/* See MS-SMB2 2.2.13.2.11 and MS-SMB2 2.2.13.2.12 and MS-SMB2 2.2.14.2.12 */
+/* Flags */
+#define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
+
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
 	struct create_context_hdr ccontext;
@@ -1404,6 +1408,26 @@ struct smb2_ioctl_rsp {
 	__u8   Buffer[];
 } __packed;
 
+/* See MS-SMB2 2.2.32.5 and MS-SMB2 2.2.32.5.1 */
+#define RSS_CAPABLE	cpu_to_le32(0x00000001)
+#define RDMA_CAPABLE	cpu_to_le32(0x00000002)
+#define INTERNETWORK	cpu_to_le16(0x0002)
+#define INTERNETWORKV6	cpu_to_le16(0x0017)
+struct network_interface_info_ioctl_rsp {
+	__le32 Next; /* next interface. zero if this is last one */
+	__le32 IfIndex;
+	__le32 Capability; /* RSS or RDMA Capable */
+	__le32 Reserved;
+	__le64 LinkSpeed;
+	union {
+		char	SockAddr_Storage[128];
+		struct {
+			__le16 Family;
+			__u8 Buffer[126];
+		};
+	};
+} __packed;
+
 /* this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA */
 struct file_zero_data_information {
 	__le64	FileOffset;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8a615e8c600f..169fbec03cfd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7869,9 +7869,9 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
 		nii_rsp->Capability = 0;
 		if (netdev->real_num_tx_queues > 1)
-			nii_rsp->Capability |= cpu_to_le32(RSS_CAPABLE);
+			nii_rsp->Capability |= RSS_CAPABLE;
 		if (ksmbd_rdma_capable_netdev(netdev))
-			nii_rsp->Capability |= cpu_to_le32(RDMA_CAPABLE);
+			nii_rsp->Capability |= RDMA_CAPABLE;
 
 		nii_rsp->Next = cpu_to_le32(152);
 		nii_rsp->Reserved = 0;
@@ -7897,7 +7897,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		if (!ipv4_set) {
 			struct in_device *idev;
 
-			sockaddr_storage->Family = cpu_to_le16(INTERNETWORK);
+			sockaddr_storage->Family = INTERNETWORK;
 			sockaddr_storage->addr4.Port = 0;
 
 			idev = __in_dev_get_rtnl(netdev);
@@ -7913,7 +7913,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			struct inet6_ifaddr *ifa;
 			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6address;
 
-			sockaddr_storage->Family = cpu_to_le16(INTERNETWORKV6);
+			sockaddr_storage->Family = INTERNETWORKV6;
 			sockaddr_storage->addr6.Port = 0;
 			sockaddr_storage->addr6.FlowInfo = 0;
 
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 5163d5241b90..fe92bfeb415a 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -116,8 +116,6 @@ struct create_durable_rsp {
 } __packed;
 
 /* See MS-SMB2 2.2.13.2.11 */
-/* Flags */
-#define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
 struct create_durable_v2_rsp {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
@@ -151,9 +149,6 @@ struct smb_sockaddr_in6 {
 	__be32 ScopeId;
 } __packed;
 
-#define INTERNETWORK	0x0002
-#define INTERNETWORKV6	0x0017
-
 struct sockaddr_storage_rsp {
 	__le16 Family;
 	union {
@@ -162,18 +157,6 @@ struct sockaddr_storage_rsp {
 	};
 } __packed;
 
-#define RSS_CAPABLE	0x00000001
-#define RDMA_CAPABLE	0x00000002
-
-struct network_interface_info_ioctl_rsp {
-	__le32 Next; /* next interface. zero if this is last one */
-	__le32 IfIndex;
-	__le32 Capability; /* RSS or RDMA Capable */
-	__le32 Reserved;
-	__le64 LinkSpeed;
-	char	SockAddr_Storage[128];
-} __packed;
-
 struct file_object_buf_type1_ioctl_rsp {
 	__u8 ObjectId[16];
 	__u8 BirthVolumeId[16];
-- 
2.43.0

