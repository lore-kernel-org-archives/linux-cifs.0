Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333302EB878;
	Sun, 12 Oct 2025 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282650; cv=none; b=gVhu0Tz8I4eUxUY+iYw4Kslw//JoB8GISp3kI4g91681sPsbENNilF8lQwzX6PCH40GccbDs2m5+xJ6ZDjFsHd8xYGZ3t8SCh7CekafXwpKcR54mdXcwbxZdGOFzCVHHuH5IDZQDIOVBaKFjw8WEvok6l25vWEUuid7XxmcOqm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282650; c=relaxed/simple;
	bh=oeqLPDpudEfH9dps5z2KcrSJw2zXBQjtIeVUQecIez4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMfrGmy7yEv5GPol6JZMJkzO2PGG+YNTCVfRtI6k7GgJGIuD01Q75Pp8lV5mgZi4nx2wjmbtzQ8LCet5xMNXtKMBZDHcIp0E7rgQiHlfuHWBQ3wmiinbZVmB/HWWaBgPMRR7ffsKz+ikYDtZ+GUdjGMo1VcFt2hTkuKpecBEOaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282601tbef24d3a
X-QQ-Originating-IP: y3QXGGGN2Bd81eN1w60s/Uh6s5Sh9nOxABNoIrvCS2Y=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16777466467165042372
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
Subject: [PATCH RESEND 07/22] smb: move some duplicate definitions to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:22:32 +0800
Message-ID: <F444CA1CB7429B2B+20251012152247.2992573-8-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: NX6it18i/RghkOmYx+ex4IqKMbPaw2FTd/Q9qGsroQ2SyjJNqFAJLAUJ
	Gy9XgZ6uN4N/1BCMnEt3cYI5h/up9pJhkI4W0hnNhKz3JlkDjjUeb7A3pms0YPWKPYMCqA3
	FbrrNI/P2TC4mcTVHS1wecRZ3bedgRA/BHvQ0YhY58OwzfWDLtrsl8HZN99a2WPw0E+8vxP
	2slmQ0Ut+F2V2P0vGEAR9lwSh1XjkmEpv8LpX5631LBfCqbUjfGCl4nYINgbmu5O7x8OiRb
	7m3cvwsCC0t/qBTSsDdpHXDHiAbL54jMiJUmh33ZXcsmkIxluOSMKCa1rbE7Y2lDvIb1hfF
	S4pTeA6KYw8QtryNgU6UUIbOBjJkR5yj044b0aLmfX47lAiJf54FTDO9EcUwVEltVNydR6x
	0Z46cQB67ZpXFzDJGuNh/cGge/Gr3FsLB1gMxqRp3M7A7N5/yELemmxf160idv+KEudHXvP
	NcdiRKTPjs0YQFKfYI07ZMAcKl6z7GoLQMtxzwr0Mqw0NRMrKNxiqA/Baft35++R5FQ63sx
	WXuz0O+QO57QaxIAQI3+B0dbgU6vlz7JG4+E0Ndi19StPmo3gQnzLQTAtd/CfYO5F8npdm2
	7FPOZ3PCUaXV/Mfh4EKLj7jZUngXL0G/sHJOCQ5MD1Unu5dxEklAhoIEgp4GjKfZFC4+aka
	lttKKaOdBUDlWz69KTYKafF9VyitVp0PCzj8woYP6pVwdosyCO/hr/xdizf8S3sTA9ziTnV
	z9ljTbTgKN49Cu4L9RtaQXpZyPcO0AZSWia9gftjYNv1DTtW2L3ChnyA5S70bhx24F4LTNt
	RbPj5wQ3yIjm4Vo4syJjFMgoTnNSgDvchrufQp1Mf5v26+IGw/E8A9s1+F2LDyqAxGD3J9+
	eRZW1mfrVep83yJHj1F8bqLgKNa3P8vML9AuwL8/7BQb0UkjsS6roBzeKe6o4Ifv2ptMh/Z
	DsjwMyPvb7RrGe+UELeDP7Y01MExZXwrfrK8mFMbddhbRHMxrQRsgoEqPupa4FkE7d44WjI
	IGPbGK6nt0Fwh1bSujHhIBE7s+NEvOTDehygYS91HzIrtu08UAmsXwo+61b9MsQXcWki1Hn
	Q==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

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

