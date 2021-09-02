Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F73AC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 23:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FDD060FA0
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 23:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345961AbhIBXic (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:38:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235909AbhIBXib (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Sep 2021 19:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630625852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muVXroxhy0MKcumj9Fh0rtsgMbUemtdw424tC5TsQIc=;
        b=O65gY6rflY15eMeI01GRKogPye5zLXlwJ4+/tN4tahO9MorxYEJgeN/mKN6qgaZ47pLioj
        Nau8ouMBrBXbVpBuqkFqo6CPIUIiKe7timZ1T/qAkLOu5MX5ES2YjSxZPUhOAcX1zGt8F3
        wc9pIACNz/Isa4hPms3w3SGujgJhR5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-uWL1qdP8PqOP-KFFvMS_Zg-1; Thu, 02 Sep 2021 19:37:30 -0400
X-MC-Unique: uWL1qdP8PqOP-KFFvMS_Zg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FAC01854E21;
        Thu,  2 Sep 2021 23:37:29 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A0615C23A;
        Thu,  2 Sep 2021 23:37:27 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 3/3] cifs: move smb2 tree_[dis]connect definitions to the shared cifs_common
Date:   Fri,  3 Sep 2021 09:37:16 +1000
Message-Id: <20210902233716.1923306-4-lsahlber@redhat.com>
In-Reply-To: <20210902233716.1923306-1-lsahlber@redhat.com>
References: <20210902233716.1923306-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.h        | 148 -----------------------------------
 fs/cifs_common/smb2pdu.h | 161 ++++++++++++++++++++++++++++++++++++---
 fs/ksmbd/smb2pdu.h       |  57 --------------
 3 files changed, 150 insertions(+), 216 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 51ae5640228b..8f63b983b8a2 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -475,154 +475,6 @@ struct smb2_logoff_rsp {
 	__le16 Reserved;
 } __packed;
 
-/* Flags/Reserved for SMB3.1.1 */
-#define SMB2_TREE_CONNECT_FLAG_CLUSTER_RECONNECT cpu_to_le16(0x0001)
-#define SMB2_TREE_CONNECT_FLAG_REDIRECT_TO_OWNER cpu_to_le16(0x0002)
-#define SMB2_TREE_CONNECT_FLAG_EXTENSION_PRESENT cpu_to_le16(0x0004)
-
-struct smb2_tree_connect_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 9 */
-	__le16 Flags; /* Reserved MBZ for dialects prior to SMB3.1.1 */
-	__le16 PathOffset;
-	__le16 PathLength;
-	__u8   Buffer[1];	/* variable length */
-} __packed;
-
-/* See MS-SMB2 section 2.2.9.2 */
-/* Context Types */
-#define SMB2_RESERVED_TREE_CONNECT_CONTEXT_ID 0x0000
-#define SMB2_REMOTED_IDENTITY_TREE_CONNECT_CONTEXT_ID cpu_to_le16(0x0001)
-
-struct tree_connect_contexts {
-	__le16 ContextType;
-	__le16 DataLength;
-	__le32 Reserved;
-	__u8   Data[];
-} __packed;
-
-/* Remoted identity tree connect context structures - see MS-SMB2 2.2.9.2.1 */
-struct smb3_blob_data {
-	__le16 BlobSize;
-	__u8   BlobData[];
-} __packed;
-
-/* Valid values for Attr */
-#define SE_GROUP_MANDATORY		0x00000001
-#define SE_GROUP_ENABLED_BY_DEFAULT	0x00000002
-#define SE_GROUP_ENABLED		0x00000004
-#define SE_GROUP_OWNER			0x00000008
-#define SE_GROUP_USE_FOR_DENY_ONLY	0x00000010
-#define SE_GROUP_INTEGRITY		0x00000020
-#define SE_GROUP_INTEGRITY_ENABLED	0x00000040
-#define SE_GROUP_RESOURCE		0x20000000
-#define SE_GROUP_LOGON_ID		0xC0000000
-
-/* struct sid_attr_data is SidData array in BlobData format then le32 Attr */
-
-struct sid_array_data {
-	__le16 SidAttrCount;
-	/* SidAttrList - array of sid_attr_data structs */
-} __packed;
-
-struct luid_attr_data {
-
-} __packed;
-
-/*
- * struct privilege_data is the same as BLOB_DATA - see MS-SMB2 2.2.9.2.1.5
- * but with size of LUID_ATTR_DATA struct and BlobData set to LUID_ATTR DATA
- */
-
-struct privilege_array_data {
-	__le16 PrivilegeCount;
-	/* array of privilege_data structs */
-} __packed;
-
-struct remoted_identity_tcon_context {
-	__le16 TicketType; /* must be 0x0001 */
-	__le16 TicketSize; /* total size of this struct */
-	__le16 User; /* offset to SID_ATTR_DATA struct with user info */
-	__le16 UserName; /* offset to null terminated Unicode username string */
-	__le16 Domain; /* offset to null terminated Unicode domain name */
-	__le16 Groups; /* offset to SID_ARRAY_DATA struct with group info */
-	__le16 RestrictedGroups; /* similar to above */
-	__le16 Privileges; /* offset to PRIVILEGE_ARRAY_DATA struct */
-	__le16 PrimaryGroup; /* offset to SID_ARRAY_DATA struct */
-	__le16 Owner; /* offset to BLOB_DATA struct */
-	__le16 DefaultDacl; /* offset to BLOB_DATA struct */
-	__le16 DeviceGroups; /* offset to SID_ARRAY_DATA struct */
-	__le16 UserClaims; /* offset to BLOB_DATA struct */
-	__le16 DeviceClaims; /* offset to BLOB_DATA struct */
-	__u8   TicketInfo[]; /* variable length buf - remoted identity data */
-} __packed;
-
-struct smb2_tree_connect_req_extension {
-	__le32 TreeConnectContextOffset;
-	__le16 TreeConnectContextCount;
-	__u8  Reserved[10];
-	__u8  PathName[]; /* variable sized array */
-	/* followed by array of TreeConnectContexts */
-} __packed;
-
-struct smb2_tree_connect_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 16 */
-	__u8   ShareType;  /* see below */
-	__u8   Reserved;
-	__le32 ShareFlags; /* see below */
-	__le32 Capabilities; /* see below */
-	__le32 MaximalAccess;
-} __packed;
-
-/* Possible ShareType values */
-#define SMB2_SHARE_TYPE_DISK	0x01
-#define SMB2_SHARE_TYPE_PIPE	0x02
-#define	SMB2_SHARE_TYPE_PRINT	0x03
-
-/*
- * Possible ShareFlags - exactly one and only one of the first 4 caching flags
- * must be set (any of the remaining, SHI1005, flags may be set individually
- * or in combination.
- */
-#define SMB2_SHAREFLAG_MANUAL_CACHING			0x00000000
-#define SMB2_SHAREFLAG_AUTO_CACHING			0x00000010
-#define SMB2_SHAREFLAG_VDO_CACHING			0x00000020
-#define SMB2_SHAREFLAG_NO_CACHING			0x00000030
-#define SHI1005_FLAGS_DFS				0x00000001
-#define SHI1005_FLAGS_DFS_ROOT				0x00000002
-#define SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS		0x00000100
-#define SHI1005_FLAGS_FORCE_SHARED_DELETE		0x00000200
-#define SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING		0x00000400
-#define SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM	0x00000800
-#define SHI1005_FLAGS_FORCE_LEVELII_OPLOCK		0x00001000
-#define SHI1005_FLAGS_ENABLE_HASH_V1			0x00002000
-#define SHI1005_FLAGS_ENABLE_HASH_V2			0x00004000
-#define SHI1005_FLAGS_ENCRYPT_DATA			0x00008000
-#define SMB2_SHAREFLAG_IDENTITY_REMOTING		0x00040000 /* 3.1.1 */
-#define SMB2_SHAREFLAG_COMPRESS_DATA			0x00100000 /* 3.1.1 */
-#define SHI1005_FLAGS_ALL				0x0014FF33
-
-/* Possible share capabilities */
-#define SMB2_SHARE_CAP_DFS	cpu_to_le32(0x00000008) /* all dialects */
-#define SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY cpu_to_le32(0x00000010) /* 3.0 */
-#define SMB2_SHARE_CAP_SCALEOUT	cpu_to_le32(0x00000020) /* 3.0 */
-#define SMB2_SHARE_CAP_CLUSTER	cpu_to_le32(0x00000040) /* 3.0 */
-#define SMB2_SHARE_CAP_ASYMMETRIC cpu_to_le32(0x00000080) /* 3.02 */
-#define SMB2_SHARE_CAP_REDIRECT_TO_OWNER cpu_to_le32(0x00000100) /* 3.1.1 */
-
-struct smb2_tree_disconnect_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
-struct smb2_tree_disconnect_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
 /* File Attrubutes */
 #define FILE_ATTRIBUTE_READONLY			0x00000001
 #define FILE_ATTRIBUTE_HIDDEN			0x00000002
diff --git a/fs/cifs_common/smb2pdu.h b/fs/cifs_common/smb2pdu.h
index 4c2b3e124071..5f9e55bcbcbe 100644
--- a/fs/cifs_common/smb2pdu.h
+++ b/fs/cifs_common/smb2pdu.h
@@ -1,15 +1,4 @@
 /* SPDX-License-Identifier: LGPL-2.1 */
-/*
- *   fs/cifs_common/smb2pdu.h
- *
- *   Copyright (c) International Business Machines  Corp., 2009, 2013
- *                 Etersoft, 2012
- *   Author(s): Steve French (sfrench@us.ibm.com)
- *              Pavel Shilovsky (pshilovsky@samba.org) 2012
- *              Ronnie Sahlberg (lsahlber@redhat.com) 2021
- *
- */
-
 #ifndef _COMMON_SMB2PDU_H
 #define _COMMON_SMB2PDU_H
 
@@ -71,4 +60,154 @@
 
 #define NUMBER_OF_SMB2_COMMANDS	0x0013
 
+
+/* See MS-SMB2 section 2.2.9.2 */
+/* Context Types */
+#define SMB2_RESERVED_TREE_CONNECT_CONTEXT_ID 0x0000
+#define SMB2_REMOTED_IDENTITY_TREE_CONNECT_CONTEXT_ID cpu_to_le16(0x0001)
+
+struct tree_connect_contexts {
+	__le16 ContextType;
+	__le16 DataLength;
+	__le32 Reserved;
+	__u8   Data[];
+} __packed;
+
+/* Remoted identity tree connect context structures - see MS-SMB2 2.2.9.2.1 */
+struct smb3_blob_data {
+	__le16 BlobSize;
+	__u8   BlobData[];
+} __packed;
+
+/* Valid values for Attr */
+#define SE_GROUP_MANDATORY		0x00000001
+#define SE_GROUP_ENABLED_BY_DEFAULT	0x00000002
+#define SE_GROUP_ENABLED		0x00000004
+#define SE_GROUP_OWNER			0x00000008
+#define SE_GROUP_USE_FOR_DENY_ONLY	0x00000010
+#define SE_GROUP_INTEGRITY		0x00000020
+#define SE_GROUP_INTEGRITY_ENABLED	0x00000040
+#define SE_GROUP_RESOURCE		0x20000000
+#define SE_GROUP_LOGON_ID		0xC0000000
+
+/* struct sid_attr_data is SidData array in BlobData format then le32 Attr */
+
+struct sid_array_data {
+	__le16 SidAttrCount;
+	/* SidAttrList - array of sid_attr_data structs */
+} __packed;
+
+struct luid_attr_data {
+
+} __packed;
+
+/*
+ * struct privilege_data is the same as BLOB_DATA - see MS-SMB2 2.2.9.2.1.5
+ * but with size of LUID_ATTR_DATA struct and BlobData set to LUID_ATTR DATA
+ */
+
+struct privilege_array_data {
+	__le16 PrivilegeCount;
+	/* array of privilege_data structs */
+} __packed;
+
+struct remoted_identity_tcon_context {
+	__le16 TicketType; /* must be 0x0001 */
+	__le16 TicketSize; /* total size of this struct */
+	__le16 User; /* offset to SID_ATTR_DATA struct with user info */
+	__le16 UserName; /* offset to null terminated Unicode username string */
+	__le16 Domain; /* offset to null terminated Unicode domain name */
+	__le16 Groups; /* offset to SID_ARRAY_DATA struct with group info */
+	__le16 RestrictedGroups; /* similar to above */
+	__le16 Privileges; /* offset to PRIVILEGE_ARRAY_DATA struct */
+	__le16 PrimaryGroup; /* offset to SID_ARRAY_DATA struct */
+	__le16 Owner; /* offset to BLOB_DATA struct */
+	__le16 DefaultDacl; /* offset to BLOB_DATA struct */
+	__le16 DeviceGroups; /* offset to SID_ARRAY_DATA struct */
+	__le16 UserClaims; /* offset to BLOB_DATA struct */
+	__le16 DeviceClaims; /* offset to BLOB_DATA struct */
+	__u8   TicketInfo[]; /* variable length buf - remoted identity data */
+} __packed;
+
+struct smb2_tree_connect_req_extension {
+	__le32 TreeConnectContextOffset;
+	__le16 TreeConnectContextCount;
+	__u8  Reserved[10];
+	__u8  PathName[]; /* variable sized array */
+	/* followed by array of TreeConnectContexts */
+} __packed;
+
+/* Flags/Reserved for SMB3.1.1 */
+#define SMB2_TREE_CONNECT_FLAG_CLUSTER_RECONNECT cpu_to_le16(0x0001)
+#define SMB2_TREE_CONNECT_FLAG_REDIRECT_TO_OWNER cpu_to_le16(0x0002)
+#define SMB2_TREE_CONNECT_FLAG_EXTENSION_PRESENT cpu_to_le16(0x0004)
+
+struct smb2_tree_connect_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 9 */
+	__le16 Flags;		/* Flags in SMB3.1.1 */
+	__le16 PathOffset;
+	__le16 PathLength;
+	__u8   Buffer[1];	/* variable length */
+} __packed;
+
+/* Possible ShareType values */
+#define SMB2_SHARE_TYPE_DISK	0x01
+#define SMB2_SHARE_TYPE_PIPE	0x02
+#define	SMB2_SHARE_TYPE_PRINT	0x03
+
+/*
+ * Possible ShareFlags - exactly one and only one of the first 4 caching flags
+ * must be set (any of the remaining, SHI1005, flags may be set individually
+ * or in combination.
+ */
+#define SMB2_SHAREFLAG_MANUAL_CACHING			0x00000000
+#define SMB2_SHAREFLAG_AUTO_CACHING			0x00000010
+#define SMB2_SHAREFLAG_VDO_CACHING			0x00000020
+#define SMB2_SHAREFLAG_NO_CACHING			0x00000030
+#define SHI1005_FLAGS_DFS				0x00000001
+#define SHI1005_FLAGS_DFS_ROOT				0x00000002
+#define SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS		0x00000100
+#define SHI1005_FLAGS_FORCE_SHARED_DELETE		0x00000200
+#define SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING		0x00000400
+#define SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM	0x00000800
+#define SHI1005_FLAGS_FORCE_LEVELII_OPLOCK		0x00001000
+#define SHI1005_FLAGS_ENABLE_HASH_V1			0x00002000
+#define SHI1005_FLAGS_ENABLE_HASH_V2			0x00004000
+#define SHI1005_FLAGS_ENCRYPT_DATA			0x00008000
+#define SMB2_SHAREFLAG_IDENTITY_REMOTING		0x00040000 /* 3.1.1 */
+#define SMB2_SHAREFLAG_COMPRESS_DATA			0x00100000 /* 3.1.1 */
+#define SHI1005_FLAGS_ALL				0x0014FF33
+
+/* Possible share capabilities */
+#define SMB2_SHARE_CAP_DFS	cpu_to_le32(0x00000008) /* all dialects */
+#define SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY cpu_to_le32(0x00000010) /* 3.0 */
+#define SMB2_SHARE_CAP_SCALEOUT	cpu_to_le32(0x00000020) /* 3.0 */
+#define SMB2_SHARE_CAP_CLUSTER	cpu_to_le32(0x00000040) /* 3.0 */
+#define SMB2_SHARE_CAP_ASYMMETRIC cpu_to_le32(0x00000080) /* 3.02 */
+#define SMB2_SHARE_CAP_REDIRECT_TO_OWNER cpu_to_le32(0x00000100) /* 3.1.1 */
+
+struct smb2_tree_connect_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 16 */
+	__u8   ShareType;	/* see below */
+	__u8   Reserved;
+	__le32 ShareFlags;	/* see below */
+	__le32 Capabilities;	/* see below */
+	__le32 MaximalAccess;
+} __packed;
+
+struct smb2_tree_disconnect_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+struct smb2_tree_disconnect_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+
 #endif				/* _COMMON_SMB2PDU_H */
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 3043f4467522..6e9d6565ed28 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -364,63 +364,6 @@ struct smb2_logoff_rsp {
 	__le16 Reserved;
 } __packed;
 
-struct smb2_tree_connect_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 9 */
-	__le16 Reserved;	/* Flags in SMB3.1.1 */
-	__le16 PathOffset;
-	__le16 PathLength;
-	__u8   Buffer[1];	/* variable length */
-} __packed;
-
-struct smb2_tree_connect_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 16 */
-	__u8   ShareType;  /* see below */
-	__u8   Reserved;
-	__le32 ShareFlags; /* see below */
-	__le32 Capabilities; /* see below */
-	__le32 MaximalAccess;
-} __packed;
-
-/* Possible ShareType values */
-#define SMB2_SHARE_TYPE_DISK	0x01
-#define SMB2_SHARE_TYPE_PIPE	0x02
-#define	SMB2_SHARE_TYPE_PRINT	0x03
-
-/*
- * Possible ShareFlags - exactly one and only one of the first 4 caching flags
- * must be set (any of the remaining, SHI1005, flags may be set individually
- * or in combination.
- */
-#define SMB2_SHAREFLAG_MANUAL_CACHING			0x00000000
-#define SMB2_SHAREFLAG_AUTO_CACHING			0x00000010
-#define SMB2_SHAREFLAG_VDO_CACHING			0x00000020
-#define SMB2_SHAREFLAG_NO_CACHING			0x00000030
-#define SHI1005_FLAGS_DFS				0x00000001
-#define SHI1005_FLAGS_DFS_ROOT				0x00000002
-#define SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS		0x00000100
-#define SHI1005_FLAGS_FORCE_SHARED_DELETE		0x00000200
-#define SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING		0x00000400
-#define SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM	0x00000800
-#define SHI1005_FLAGS_FORCE_LEVELII_OPLOCK		0x00001000
-#define SHI1005_FLAGS_ENABLE_HASH			0x00002000
-
-/* Possible share capabilities */
-#define SMB2_SHARE_CAP_DFS	cpu_to_le32(0x00000008)
-
-struct smb2_tree_disconnect_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
-struct smb2_tree_disconnect_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
 #define ATTR_READONLY_LE	cpu_to_le32(ATTR_READONLY)
 #define ATTR_HIDDEN_LE		cpu_to_le32(ATTR_HIDDEN)
 #define ATTR_SYSTEM_LE		cpu_to_le32(ATTR_SYSTEM)
-- 
2.30.2

