Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFBAC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 09:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA5AA239FF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 09:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbhANJIT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Jan 2021 04:08:19 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:49065 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727258AbhANJIS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Jan 2021 04:08:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ULhhDXO_1610615172;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULhhDXO_1610615172)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Jan 2021 17:06:18 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] fs/cifs: Replace one-element array with flexible-array member.
Date:   Thu, 14 Jan 2021 17:06:11 +0800
Message-Id: <1610615171-68296-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix the following coccicheck warning:

./fs/cifs/smb2pdu.h:1711:8-16: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/
process/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1509:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/
process/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1486:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/
process/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1478:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/
process/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1437:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1429:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/
process/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1389:26-31: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1389:26-31: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1366:6-12: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1330:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1319:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1299:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

./fs/cifs/smb2pdu.h:1284:8-14: WARNING use flexible-array
member instead(https://www.kernel.org/doc/html/latest/process
/deprecated.html#zero-length-and-one-element-arrays)

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 fs/cifs/smb2pdu.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 204a622..7c9ac5d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1289,7 +1289,7 @@ struct smb2_read_plain_req {
 	__le32 RemainingBytes;
 	__le16 ReadChannelInfoOffset;
 	__le16 ReadChannelInfoLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 /* Read flags */
@@ -1304,7 +1304,7 @@ struct smb2_read_rsp {
 	__le32 DataLength;
 	__le32 DataRemaining;
 	__u32  Flags;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 /* For write request Flags field below the following flags are defined: */
@@ -1324,7 +1324,7 @@ struct smb2_write_req {
 	__le16 WriteChannelInfoOffset;
 	__le16 WriteChannelInfoLength;
 	__le32 Flags;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_write_rsp {
@@ -1335,7 +1335,7 @@ struct smb2_write_rsp {
 	__le32 DataLength;
 	__le32 DataRemaining;
 	__u32  Reserved2;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 /* notify flags */
@@ -1371,7 +1371,7 @@ struct smb2_change_notify_rsp {
 	__le16	StructureSize;  /* Must be 9 */
 	__le16	OutputBufferOffset;
 	__le32	OutputBufferLength;
-	__u8	Buffer[1]; /* array of file notify structs */
+	__u8	Buffer[]; /* array of file notify structs */
 } __packed;
 
 #define SMB2_LOCKFLAG_SHARED_LOCK	0x0001
@@ -1394,7 +1394,7 @@ struct smb2_lock_req {
 	__u64  PersistentFileId; /* opaque endianness */
 	__u64  VolatileFileId; /* opaque endianness */
 	/* Followed by at least one */
-	struct smb2_lock_element locks[1];
+	struct smb2_lock_element locks[];
 } __packed;
 
 struct smb2_lock_rsp {
@@ -1434,7 +1434,7 @@ struct smb2_query_directory_req {
 	__le16 FileNameOffset;
 	__le16 FileNameLength;
 	__le32 OutputBufferLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_query_directory_rsp {
@@ -1442,7 +1442,7 @@ struct smb2_query_directory_rsp {
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 /* Possible InfoType values */
@@ -1483,7 +1483,7 @@ struct smb2_query_info_req {
 	__le32 Flags;
 	__u64  PersistentFileId; /* opaque endianness */
 	__u64  VolatileFileId; /* opaque endianness */
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_query_info_rsp {
@@ -1491,7 +1491,7 @@ struct smb2_query_info_rsp {
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 /*
@@ -1514,7 +1514,7 @@ struct smb2_set_info_req {
 	__le32 AdditionalInformation;
 	__u64  PersistentFileId; /* opaque endianness */
 	__u64  VolatileFileId; /* opaque endianness */
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_set_info_rsp {
@@ -1716,7 +1716,7 @@ struct smb2_file_all_info { /* data block encoding of response to level 18 */
 	__le32 Mode;
 	__le32 AlignmentRequirement;
 	__le32 FileNameLength;
-	char   FileName[1];
+	char   FileName[];
 } __packed; /* level 18 Query */
 
 struct smb2_file_eof_info { /* encoding of request for level 10 */
-- 
1.8.3.1

