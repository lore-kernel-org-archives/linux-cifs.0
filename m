From: Steve French <smfrench@gmail.com>
Subject: [PATCH 3/5] Add Get/Set Integrity Information structure definitions
Date: Sun, 28 Jun 2015 18:36:08 -0500
Message-ID: <1435534570-10864-3-git-send-email-steve.french@primarydata.com>
References: <1435534570-10864-1-git-send-email-steve.french@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, Steve French <smfrench@gmail.com>,
	Steve French <steve.french@primarydata.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1435534570-10864-1-git-send-email-steve.french@primarydata.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Steve French <smfrench@gmail.com>

Signed-off-by: Steve French <steve.french@primarydata.com>
---
 fs/cifs/smb2pdu.h  | 22 ++++++++++++++++++++++
 fs/cifs/smbfsctl.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 8e7bbe5..c302e82 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -621,6 +621,28 @@ struct copychunk_ioctl_rsp {
 	__le32 TotalBytesWritten;
 } __packed;
 
+struct fsctl_set_integrity_information_req {
+	__le16	ChecksumAlgorithm;
+	__le16	Reserved;
+	__le32	Flags;
+} __packed;
+
+struct fsctl_get_integrity_information_rsp {
+	__le16	ChecksumAlgorithm;
+	__le16	Reserved;
+	__le32	Flags;
+	__le32	ChecksumChunkSizeInBytes;
+	__le32	ClusterSizeInBytes;
+} __packed;
+
+/* Integrity ChecksumAlgorithm choices for above */
+#define	CHECKSUM_TYPE_NONE	0x0000
+#define	CHECKSUM_TYPE_CRC64	0x0002
+
+/* Integrity flags for above */
+#define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF	0x00000001
+
+
 struct validate_negotiate_info_req {
 	__le32 Capabilities;
 	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index d098da6..a639d0d 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -75,11 +75,13 @@
 #define FSCTL_QUERY_SPARING_INFO     0x00090138 /* BB add struct */
 #define FSCTL_SET_ZERO_ON_DEALLOC    0x00090194 /* BB add struct */
 #define FSCTL_SET_SHORT_NAME_BEHAVIOR 0x000901B4 /* BB add struct */
+#define FSCTL_GET_INTEGRITY_INFORMATION 0x0009027C
 #define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF /* BB add struct */
 #define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
 #define FSCTL_FILE_LEVEL_TRIM        0x00098208 /* BB add struct */
 #define FSCTL_DUPLICATE_EXTENTS_TO_FILE 0x00098344
 #define FSCTL_SIS_LINK_FILES         0x0009C104
+#define FSCTL_SET_INTEGRITY_INFORMATION 0x0009C280
 #define FSCTL_PIPE_PEEK              0x0011400C /* BB add struct */
 #define FSCTL_PIPE_TRANSCEIVE        0x0011C017 /* BB add struct */
 /* strange that the number for this op is not sequential with previous op */
-- 
2.1.4

