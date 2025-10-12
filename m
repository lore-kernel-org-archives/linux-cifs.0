Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C222ECEAB;
	Sun, 12 Oct 2025 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285963; cv=none; b=W/5HN5A8E7AjiVl/cYoWyUKZKmAvusj3fq+n4G6Dx02b2ZHIuvxF1st8vCg/NVAkCCVd2a4IH7T/ZyBM5YVnsAki/GyiaweHLXuMu++vnCuGK8WaqmMU9APzQUJ+XEcKwoFL7eFGQdEJ3Hy4MRaciK2tpiMQD6E+hbIV81uWzY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285963; c=relaxed/simple;
	bh=oeqLPDpudEfH9dps5z2KcrSJw2zXBQjtIeVUQecIez4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5mqN/WnMF39n89A+Crb4TYmnxxOQ743LkixII+bRO7SZjy2f94hcVUPpNaHggIo8S5Ks5tUzjMWlQgzXa8eqF+NzZJ7gx0kYYjIptByoF2VemvfREvfiH/56YuGr5CBvZppVtz69iTwkenaJFXry60GIdu/d7sIJd39Oc0C6xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285908tfcc85a7e
X-QQ-Originating-IP: sBE7flPu5RnDt3kWv+5fMswo5oxc7/tYeaw5VFvv2vM=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:26 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11636649716772728761
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
Subject: [PATCH v2 07/22] smb: move some duplicate definitions to common/smb2pdu.h
Date: Mon, 13 Oct 2025 00:17:34 +0800
Message-ID: <8F07A63856EBEEC0+20251012161749.2994033-8-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: MVocNrGTvdghmwhAmWfZ6PzbPugnkYRQRcFhMQhxk+DYaRBChwWmp2cA
	zBYE6ccIdQC5lzaLw6DP4nXj0ct7RSu3ElSFDFxgcn640gBhEHx5WC4uIIjc8/3A4xyu3FR
	3liu+TeYSr0CNJZ0MxfkmkiuAasjg1NTX9Rm6U/NXlrmHhhcKxevCs87+ey3ozBdC7rz4hU
	PINN2diZPck/qNLh5onfb5fZQ92Pnkwiej2lf2E5UwixWYuo2ATQ+vM9CCjDOJIBp5WJUTA
	helyOU2slf1lMgqFSCyGJOuYzo6iacnHs76YiphMhqUR68sdpEN85+tx4Jo+Z1y4uAEhojJ
	9TvNb613BUaeFH/Vz8qFIL5xAP4cy4Z82Jeval+xRu+2o1kL1k79fyXfILVSg1SRDtG6+nF
	aKH88XBBw/NKbM+pJUKiu2kBZPbNyE8KN+/DOBWMPjiy2eDlPHSjhx64/2rH9m1RP37ZhzL
	mde8QyDUGTV3v3ckvP6e456ObLjpEFeiIOp2x+qJQ7XEo6aZ+qbs85UOkukHsoB1hFR1iFr
	VRXvcROMJY+TLwJ/Yr2iz5iA+818xzRziZfepKPhBWvoQuWMfaqUyiNJGWMNASUjK1MB89k
	LAEAd+j67CixekfuKmpZwzormBDi/mUACrRonnbWa40zZM3FUlOofWQ1x0zmFm4eOJHU85c
	o1qjm04dWvrR4RUqD6zwiLsCRb+Liom7qC0K96IVx1J/RKhRBwvf2nYZ7Ur1LKMJ/diYKEE
	rNuZ1axNy11kkZTk7jsQ5VsVoytWPEh/2ixscrUG2+nk+Y/7FQbMphn9D2H1rvWShweWERm
	e14FbKsGqBQaMZZXhPwr2a0jVn273Qquh1iUfbiRNMmnejaT58NUS7yJ22kjaNLDjcWs14Z
	x1umb4hu94Ofg29Ikzd9ePaf7ETLrKZxFHnQvm9xsoA/7ALXU9wRHJ2bsvR9x1BtEmK2Dz1
	c2OGAeN/9l3xZwFQEn4VMtu/074hl1pXEB2EOXL5+eUbymxVmxjzr894K30YNUoglRnoJJg
	fO5R9MfH/N/s95d8E28doXAPt8MnS6A3Kct96cRPQPXH/5NZBGyQxCP1CT3RQ=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
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

