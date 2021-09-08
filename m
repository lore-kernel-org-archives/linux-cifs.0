Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48478C4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 02:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D21361157
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 02:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347187AbhIHCLo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:11:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347174AbhIHCLk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 22:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631067033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vx9lNZkkmdXVpRkxo54GTCTU3JCJXRCZwczpISUE/rI=;
        b=bdTnzjTqADcmcrMzQh5jzuYuA8fbmflRVh+NSQy938taOmIu1g2Ik6jKHwnerf5Aver/W2
        eSp2I/DQI+2Oz4SQQpYvZbcGBCHOSg3qds0t/xOQuEI6PTWQkGVJ0GW02w3Y+4lTkxL139
        /RliGB0ZHpUMl1IqwBsRnWvEfLDNHuY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-43B80jI3PTCOlnVOu_j_cg-1; Tue, 07 Sep 2021 22:10:29 -0400
X-MC-Unique: 43B80jI3PTCOlnVOu_j_cg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFEEC10054F6;
        Wed,  8 Sep 2021 02:10:28 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 928436608B;
        Wed,  8 Sep 2021 02:10:27 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 4/4] cifs: Move SMB2_Create definitions to the shared area
Date:   Wed,  8 Sep 2021 12:10:15 +1000
Message-Id: <20210908021015.2115407-5-lsahlber@redhat.com>
In-Reply-To: <20210908021015.2115407-1-lsahlber@redhat.com>
References: <20210908021015.2115407-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move all SMB2_Create definitions (except contexts) into the shared area.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2misc.c       |   4 +-
 fs/cifs/smb2ops.c        |   8 +-
 fs/cifs/smb2pdu.c        |  13 ++-
 fs/cifs/smb2pdu.h        | 165 --------------------------------
 fs/cifs_common/smb2pdu.h | 201 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 215 insertions(+), 176 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 1c466d7ad7fd..8cfbc6f85867 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -833,8 +833,8 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
 	rc = __smb2_handle_cancelled_cmd(tcon,
 					 le16_to_cpu(hdr->Command),
 					 le64_to_cpu(hdr->MessageId),
-					 rsp->PersistentFileId,
-					 rsp->VolatileFileId);
+					 le64_to_cpu(rsp->PersistentFileId),
+					 le64_to_cpu(rsp->VolatileFileId));
 	if (rc)
 		cifs_put_tcon(tcon);
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c91e64b4dcc4..e71043f87439 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -879,8 +879,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	atomic_inc(&tcon->num_remote_opens);
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
-	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
-	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
+	oparms.fid->persistent_fid = le64_to_cpu(o_rsp->PersistentFileId);
+	oparms.fid->volatile_fid = le64_to_cpu(o_rsp->VolatileFileId);
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
@@ -2389,8 +2389,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "query_dir_first: open failed rc=%d\n", rc);
 		goto qdf_free;
 	}
-	fid->persistent_fid = op_rsp->PersistentFileId;
-	fid->volatile_fid = op_rsp->VolatileFileId;
+	fid->persistent_fid = le64_to_cpu(op_rsp->PersistentFileId);
+	fid->volatile_fid = le64_to_cpu(op_rsp->VolatileFileId);
 
 	/* Anything else than ENODATA means a genuine error */
 	if (rc && rc != -ENODATA) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 502aadbd85cb..6b491f04b450 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2672,11 +2672,13 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	}
 
 	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
-	trace_smb3_posix_mkdir_done(xid, rsp->PersistentFileId, tcon->tid,
+	trace_smb3_posix_mkdir_done(xid, le64_to_cpu(rsp->PersistentFileId),
+				    tcon->tid,
 				    ses->Suid, CREATE_NOT_FILE,
 				    FILE_WRITE_ATTRIBUTES);
 
-	SMB2_close(xid, tcon, rsp->PersistentFileId, rsp->VolatileFileId);
+	SMB2_close(xid, tcon, le64_to_cpu(rsp->PersistentFileId),
+		   le64_to_cpu(rsp->VolatileFileId));
 
 	/* Eventually save off posix specific response info and timestaps */
 
@@ -2943,13 +2945,14 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		}
 		goto creat_exit;
 	} else
-		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid,
+		trace_smb3_open_done(xid, le64_to_cpu(rsp->PersistentFileId),
+				     tcon->tid,
 				     ses->Suid, oparms->create_options,
 				     oparms->desired_access);
 
 	atomic_inc(&tcon->num_remote_opens);
-	oparms->fid->persistent_fid = rsp->PersistentFileId;
-	oparms->fid->volatile_fid = rsp->VolatileFileId;
+	oparms->fid->persistent_fid = le64_to_cpu(rsp->PersistentFileId);
+	oparms->fid->volatile_fid = le64_to_cpu(rsp->VolatileFileId);
 	oparms->fid->access = oparms->desired_access;
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f5760346d9c5..d06676daaa7d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -116,120 +116,6 @@ struct share_redirect_error_context_rsp {
 	/* __u8 ResourceName[] */ /* Name of share as counted Unicode string */
 } __packed;
 
-/* File Attrubutes */
-#define FILE_ATTRIBUTE_READONLY			0x00000001
-#define FILE_ATTRIBUTE_HIDDEN			0x00000002
-#define FILE_ATTRIBUTE_SYSTEM			0x00000004
-#define FILE_ATTRIBUTE_DIRECTORY		0x00000010
-#define FILE_ATTRIBUTE_ARCHIVE			0x00000020
-#define FILE_ATTRIBUTE_NORMAL			0x00000080
-#define FILE_ATTRIBUTE_TEMPORARY		0x00000100
-#define FILE_ATTRIBUTE_SPARSE_FILE		0x00000200
-#define FILE_ATTRIBUTE_REPARSE_POINT		0x00000400
-#define FILE_ATTRIBUTE_COMPRESSED		0x00000800
-#define FILE_ATTRIBUTE_OFFLINE			0x00001000
-#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED	0x00002000
-#define FILE_ATTRIBUTE_ENCRYPTED		0x00004000
-#define FILE_ATTRIBUTE_INTEGRITY_STREAM		0x00008000
-#define FILE_ATTRIBUTE_NO_SCRUB_DATA		0x00020000
-
-/* Oplock levels */
-#define SMB2_OPLOCK_LEVEL_NONE		0x00
-#define SMB2_OPLOCK_LEVEL_II		0x01
-#define SMB2_OPLOCK_LEVEL_EXCLUSIVE	0x08
-#define SMB2_OPLOCK_LEVEL_BATCH		0x09
-#define SMB2_OPLOCK_LEVEL_LEASE		0xFF
-/* Non-spec internal type */
-#define SMB2_OPLOCK_LEVEL_NOCHANGE	0x99
-
-/* Desired Access Flags */
-#define FILE_READ_DATA_LE		cpu_to_le32(0x00000001)
-#define FILE_WRITE_DATA_LE		cpu_to_le32(0x00000002)
-#define FILE_APPEND_DATA_LE		cpu_to_le32(0x00000004)
-#define FILE_READ_EA_LE			cpu_to_le32(0x00000008)
-#define FILE_WRITE_EA_LE		cpu_to_le32(0x00000010)
-#define FILE_EXECUTE_LE			cpu_to_le32(0x00000020)
-#define FILE_READ_ATTRIBUTES_LE		cpu_to_le32(0x00000080)
-#define FILE_WRITE_ATTRIBUTES_LE	cpu_to_le32(0x00000100)
-#define FILE_DELETE_LE			cpu_to_le32(0x00010000)
-#define FILE_READ_CONTROL_LE		cpu_to_le32(0x00020000)
-#define FILE_WRITE_DAC_LE		cpu_to_le32(0x00040000)
-#define FILE_WRITE_OWNER_LE		cpu_to_le32(0x00080000)
-#define FILE_SYNCHRONIZE_LE		cpu_to_le32(0x00100000)
-#define FILE_ACCESS_SYSTEM_SECURITY_LE	cpu_to_le32(0x01000000)
-#define FILE_MAXIMAL_ACCESS_LE		cpu_to_le32(0x02000000)
-#define FILE_GENERIC_ALL_LE		cpu_to_le32(0x10000000)
-#define FILE_GENERIC_EXECUTE_LE		cpu_to_le32(0x20000000)
-#define FILE_GENERIC_WRITE_LE		cpu_to_le32(0x40000000)
-#define FILE_GENERIC_READ_LE		cpu_to_le32(0x80000000)
-
-/* ShareAccess Flags */
-#define FILE_SHARE_READ_LE		cpu_to_le32(0x00000001)
-#define FILE_SHARE_WRITE_LE		cpu_to_le32(0x00000002)
-#define FILE_SHARE_DELETE_LE		cpu_to_le32(0x00000004)
-#define FILE_SHARE_ALL_LE		cpu_to_le32(0x00000007)
-
-/* CreateDisposition Flags */
-#define FILE_SUPERSEDE_LE		cpu_to_le32(0x00000000)
-#define FILE_OPEN_LE			cpu_to_le32(0x00000001)
-#define FILE_CREATE_LE			cpu_to_le32(0x00000002)
-#define	FILE_OPEN_IF_LE			cpu_to_le32(0x00000003)
-#define FILE_OVERWRITE_LE		cpu_to_le32(0x00000004)
-#define FILE_OVERWRITE_IF_LE		cpu_to_le32(0x00000005)
-
-/* CreateOptions Flags */
-#define FILE_DIRECTORY_FILE_LE		cpu_to_le32(0x00000001)
-/* same as #define CREATE_NOT_FILE_LE	cpu_to_le32(0x00000001) */
-#define FILE_WRITE_THROUGH_LE		cpu_to_le32(0x00000002)
-#define FILE_SEQUENTIAL_ONLY_LE		cpu_to_le32(0x00000004)
-#define FILE_NO_INTERMEDIATE_BUFFERRING_LE cpu_to_le32(0x00000008)
-#define FILE_SYNCHRONOUS_IO_ALERT_LE	cpu_to_le32(0x00000010)
-#define FILE_SYNCHRONOUS_IO_NON_ALERT_LE	cpu_to_le32(0x00000020)
-#define FILE_NON_DIRECTORY_FILE_LE	cpu_to_le32(0x00000040)
-#define FILE_COMPLETE_IF_OPLOCKED_LE	cpu_to_le32(0x00000100)
-#define FILE_NO_EA_KNOWLEDGE_LE		cpu_to_le32(0x00000200)
-#define FILE_RANDOM_ACCESS_LE		cpu_to_le32(0x00000800)
-#define FILE_DELETE_ON_CLOSE_LE		cpu_to_le32(0x00001000)
-#define FILE_OPEN_BY_FILE_ID_LE		cpu_to_le32(0x00002000)
-#define FILE_OPEN_FOR_BACKUP_INTENT_LE	cpu_to_le32(0x00004000)
-#define FILE_NO_COMPRESSION_LE		cpu_to_le32(0x00008000)
-#define FILE_RESERVE_OPFILTER_LE	cpu_to_le32(0x00100000)
-#define FILE_OPEN_REPARSE_POINT_LE	cpu_to_le32(0x00200000)
-#define FILE_OPEN_NO_RECALL_LE		cpu_to_le32(0x00400000)
-#define FILE_OPEN_FOR_FREE_SPACE_QUERY_LE cpu_to_le32(0x00800000)
-
-#define FILE_READ_RIGHTS_LE (FILE_READ_DATA_LE | FILE_READ_EA_LE \
-			| FILE_READ_ATTRIBUTES_LE)
-#define FILE_WRITE_RIGHTS_LE (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE \
-			| FILE_WRITE_EA_LE | FILE_WRITE_ATTRIBUTES_LE)
-#define FILE_EXEC_RIGHTS_LE (FILE_EXECUTE_LE)
-
-/* Impersonation Levels. See MS-WPO section 9.7 and MSDN-IMPERS */
-#define IL_ANONYMOUS		cpu_to_le32(0x00000000)
-#define IL_IDENTIFICATION	cpu_to_le32(0x00000001)
-#define IL_IMPERSONATION	cpu_to_le32(0x00000002)
-#define IL_DELEGATE		cpu_to_le32(0x00000003)
-
-/* Create Context Values */
-#define SMB2_CREATE_EA_BUFFER			"ExtA" /* extended attributes */
-#define SMB2_CREATE_SD_BUFFER			"SecD" /* security descriptor */
-#define SMB2_CREATE_DURABLE_HANDLE_REQUEST	"DHnQ"
-#define SMB2_CREATE_DURABLE_HANDLE_RECONNECT	"DHnC"
-#define SMB2_CREATE_ALLOCATION_SIZE		"AISi"
-#define SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST "MxAc"
-#define SMB2_CREATE_TIMEWARP_REQUEST		"TWrp"
-#define SMB2_CREATE_QUERY_ON_DISK_ID		"QFid"
-#define SMB2_CREATE_REQUEST_LEASE		"RqLs"
-#define SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2	"DH2Q"
-#define SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2	"DH2C"
-#define SMB2_CREATE_APP_INSTANCE_ID	0x45BCA66AEFA7F74A9008FA462E144D74
-#define SMB2_CREATE_APP_INSTANCE_VERSION 0xB982D0B73B56074FA07B524A8116A010
-#define SVHDX_OPEN_DEVICE_CONTEX	0x9CCBCF9E04C1E643980E158DA1F6EC83
-#define SMB2_CREATE_TAG_POSIX		0x93AD25509CB411E7B42383DE968BCD7C
-
-/* Flag (SMB3 open response) values */
-#define SMB2_CREATE_FLAG_REPARSEPOINT 0x01
-
 /*
  * Maximum number of iovs we need for an open/create request.
  * [0] : struct smb2_create_req
@@ -243,26 +129,6 @@ struct share_redirect_error_context_rsp {
  */
 #define SMB2_CREATE_IOV_SIZE 8
 
-struct smb2_create_req {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 57 */
-	__u8   SecurityFlags;
-	__u8   RequestedOplockLevel;
-	__le32 ImpersonationLevel;
-	__le64 SmbCreateFlags;
-	__le64 Reserved;
-	__le32 DesiredAccess;
-	__le32 FileAttributes;
-	__le32 ShareAccess;
-	__le32 CreateDisposition;
-	__le32 CreateOptions;
-	__le16 NameOffset;
-	__le16 NameLength;
-	__le32 CreateContextsOffset;
-	__le32 CreateContextsLength;
-	__u8   Buffer[];
-} __packed;
-
 /*
  * Maximum size of a SMB2_CREATE response is 64 (smb2 header) +
  * 88 (fixed part of create response) + 520 (path) + 208 (contexts) +
@@ -270,37 +136,6 @@ struct smb2_create_req {
  */
 #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
 
-struct smb2_create_rsp {
-	struct smb2_hdr hdr;
-	__le16 StructureSize;	/* Must be 89 */
-	__u8   OplockLevel;
-	__u8   Flag;  /* 0x01 if reparse point */
-	__le32 CreateAction;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 AllocationSize;
-	__le64 EndofFile;
-	__le32 FileAttributes;
-	__le32 Reserved2;
-	__u64  PersistentFileId; /* opaque endianness */
-	__u64  VolatileFileId; /* opaque endianness */
-	__le32 CreateContextsOffset;
-	__le32 CreateContextsLength;
-	__u8   Buffer[1];
-} __packed;
-
-struct create_context {
-	__le32 Next;
-	__le16 NameOffset;
-	__le16 NameLength;
-	__le16 Reserved;
-	__le16 DataOffset;
-	__le32 DataLength;
-	__u8 Buffer[];
-} __packed;
-
 #define SMB2_LEASE_READ_CACHING_HE	0x01
 #define SMB2_LEASE_HANDLE_CACHING_HE	0x02
 #define SMB2_LEASE_WRITE_CACHING_HE	0x04
diff --git a/fs/cifs_common/smb2pdu.h b/fs/cifs_common/smb2pdu.h
index 0d9c3ebdb773..7ccadcbe684b 100644
--- a/fs/cifs_common/smb2pdu.h
+++ b/fs/cifs_common/smb2pdu.h
@@ -784,5 +784,206 @@ struct smb2_change_notify_rsp {
 } __packed;
 
 
+/*
+ * SMB2_CREATE  See MS-SMB2 section 2.2.13
+ */
+/* Oplock levels */
+#define SMB2_OPLOCK_LEVEL_NONE		0x00
+#define SMB2_OPLOCK_LEVEL_II		0x01
+#define SMB2_OPLOCK_LEVEL_EXCLUSIVE	0x08
+#define SMB2_OPLOCK_LEVEL_BATCH		0x09
+#define SMB2_OPLOCK_LEVEL_LEASE		0xFF
+/* Non-spec internal type */
+#define SMB2_OPLOCK_LEVEL_NOCHANGE	0x99
+
+/* Impersonation Levels. See MS-WPO section 9.7 and MSDN-IMPERS */
+#define IL_ANONYMOUS		cpu_to_le32(0x00000000)
+#define IL_IDENTIFICATION	cpu_to_le32(0x00000001)
+#define IL_IMPERSONATION	cpu_to_le32(0x00000002)
+#define IL_DELEGATE		cpu_to_le32(0x00000003)
+
+/* File Attrubutes */
+#define FILE_ATTRIBUTE_READONLY			0x00000001
+#define FILE_ATTRIBUTE_HIDDEN			0x00000002
+#define FILE_ATTRIBUTE_SYSTEM			0x00000004
+#define FILE_ATTRIBUTE_DIRECTORY		0x00000010
+#define FILE_ATTRIBUTE_ARCHIVE			0x00000020
+#define FILE_ATTRIBUTE_NORMAL			0x00000080
+#define FILE_ATTRIBUTE_TEMPORARY		0x00000100
+#define FILE_ATTRIBUTE_SPARSE_FILE		0x00000200
+#define FILE_ATTRIBUTE_REPARSE_POINT		0x00000400
+#define FILE_ATTRIBUTE_COMPRESSED		0x00000800
+#define FILE_ATTRIBUTE_OFFLINE			0x00001000
+#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED	0x00002000
+#define FILE_ATTRIBUTE_ENCRYPTED		0x00004000
+#define FILE_ATTRIBUTE_INTEGRITY_STREAM		0x00008000
+#define FILE_ATTRIBUTE_NO_SCRUB_DATA		0x00020000
+#define FILE_ATTRIBUTE__MASK			0x00007FB7
+
+#define FILE_ATTRIBUTE_READONLY_LE              cpu_to_le32(0x00000001)
+#define FILE_ATTRIBUTE_HIDDEN_LE		cpu_to_le32(0x00000002)
+#define FILE_ATTRIBUTE_SYSTEM_LE		cpu_to_le32(0x00000004)
+#define FILE_ATTRIBUTE_DIRECTORY_LE		cpu_to_le32(0x00000010)
+#define FILE_ATTRIBUTE_ARCHIVE_LE		cpu_to_le32(0x00000020)
+#define FILE_ATTRIBUTE_NORMAL_LE		cpu_to_le32(0x00000080)
+#define FILE_ATTRIBUTE_TEMPORARY_LE		cpu_to_le32(0x00000100)
+#define FILE_ATTRIBUTE_SPARSE_FILE_LE		cpu_to_le32(0x00000200)
+#define FILE_ATTRIBUTE_REPARSE_POINT_LE		cpu_to_le32(0x00000400)
+#define FILE_ATTRIBUTE_COMPRESSED_LE		cpu_to_le32(0x00000800)
+#define FILE_ATTRIBUTE_OFFLINE_LE		cpu_to_le32(0x00001000)
+#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED_LE	cpu_to_le32(0x00002000)
+#define FILE_ATTRIBUTE_ENCRYPTED_LE		cpu_to_le32(0x00004000)
+#define FILE_ATTRIBUTE_INTEGRITY_STREAM_LE	cpu_to_le32(0x00008000)
+#define FILE_ATTRIBUTE_NO_SCRUB_DATA_LE		cpu_to_le32(0x00020000)
+#define FILE_ATTRIBUTE_MASK_LE			cpu_to_le32(0x00007FB7)
+
+/* Desired Access Flags */
+#define FILE_READ_DATA_LE		cpu_to_le32(0x00000001)
+#define FILE_LIST_DIRECTORY_LE		cpu_to_le32(0x00000001)
+#define FILE_WRITE_DATA_LE		cpu_to_le32(0x00000002)
+#define FILE_APPEND_DATA_LE		cpu_to_le32(0x00000004)
+#define FILE_ADD_SUBDIRECTORY_LE	cpu_to_le32(0x00000004)
+#define FILE_READ_EA_LE			cpu_to_le32(0x00000008)
+#define FILE_WRITE_EA_LE		cpu_to_le32(0x00000010)
+#define FILE_EXECUTE_LE			cpu_to_le32(0x00000020)
+#define FILE_DELETE_CHILD_LE		cpu_to_le32(0x00000040)
+#define FILE_READ_ATTRIBUTES_LE		cpu_to_le32(0x00000080)
+#define FILE_WRITE_ATTRIBUTES_LE	cpu_to_le32(0x00000100)
+#define FILE_DELETE_LE			cpu_to_le32(0x00010000)
+#define FILE_READ_CONTROL_LE		cpu_to_le32(0x00020000)
+#define FILE_WRITE_DAC_LE		cpu_to_le32(0x00040000)
+#define FILE_WRITE_OWNER_LE		cpu_to_le32(0x00080000)
+#define FILE_SYNCHRONIZE_LE		cpu_to_le32(0x00100000)
+#define FILE_ACCESS_SYSTEM_SECURITY_LE	cpu_to_le32(0x01000000)
+#define FILE_MAXIMAL_ACCESS_LE		cpu_to_le32(0x02000000)
+#define FILE_GENERIC_ALL_LE		cpu_to_le32(0x10000000)
+#define FILE_GENERIC_EXECUTE_LE		cpu_to_le32(0x20000000)
+#define FILE_GENERIC_WRITE_LE		cpu_to_le32(0x40000000)
+#define FILE_GENERIC_READ_LE		cpu_to_le32(0x80000000)
+#define DESIRED_ACCESS_MASK             cpu_to_le32(0xF21F01FF)
+
+
+#define FILE_READ_DESIRED_ACCESS_LE     (FILE_READ_DATA_LE        |	\
+					 FILE_READ_EA_LE          |     \
+					 FILE_GENERIC_READ_LE)
+#define FILE_WRITE_DESIRE_ACCESS_LE     (FILE_WRITE_DATA_LE       |	\
+					 FILE_APPEND_DATA_LE      |	\
+					 FILE_WRITE_EA_LE         |	\
+					 FILE_WRITE_ATTRIBUTES_LE |	\
+					 FILE_GENERIC_WRITE_LE)
+
+/* ShareAccess Flags */
+#define FILE_SHARE_READ_LE		cpu_to_le32(0x00000001)
+#define FILE_SHARE_WRITE_LE		cpu_to_le32(0x00000002)
+#define FILE_SHARE_DELETE_LE		cpu_to_le32(0x00000004)
+#define FILE_SHARE_ALL_LE		cpu_to_le32(0x00000007)
+
+/* CreateDisposition Flags */
+#define FILE_SUPERSEDE_LE		cpu_to_le32(0x00000000)
+#define FILE_OPEN_LE			cpu_to_le32(0x00000001)
+#define FILE_CREATE_LE			cpu_to_le32(0x00000002)
+#define	FILE_OPEN_IF_LE			cpu_to_le32(0x00000003)
+#define FILE_OVERWRITE_LE		cpu_to_le32(0x00000004)
+#define FILE_OVERWRITE_IF_LE		cpu_to_le32(0x00000005)
+#define FILE_CREATE_MASK_LE             cpu_to_le32(0x00000007)
+
+#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
+			| FILE_READ_ATTRIBUTES)
+#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
+			| FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
+#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
+
+/* CreateOptions Flags */
+#define FILE_DIRECTORY_FILE_LE		cpu_to_le32(0x00000001)
+/* same as #define CREATE_NOT_FILE_LE	cpu_to_le32(0x00000001) */
+#define FILE_WRITE_THROUGH_LE		cpu_to_le32(0x00000002)
+#define FILE_SEQUENTIAL_ONLY_LE		cpu_to_le32(0x00000004)
+#define FILE_NO_INTERMEDIATE_BUFFERING_LE cpu_to_le32(0x00000008)
+#define FILE_NON_DIRECTORY_FILE_LE	cpu_to_le32(0x00000040)
+#define FILE_COMPLETE_IF_OPLOCKED_LE	cpu_to_le32(0x00000100)
+#define FILE_NO_EA_KNOWLEDGE_LE		cpu_to_le32(0x00000200)
+#define FILE_RANDOM_ACCESS_LE		cpu_to_le32(0x00000800)
+#define FILE_DELETE_ON_CLOSE_LE		cpu_to_le32(0x00001000)
+#define FILE_OPEN_BY_FILE_ID_LE		cpu_to_le32(0x00002000)
+#define FILE_OPEN_FOR_BACKUP_INTENT_LE	cpu_to_le32(0x00004000)
+#define FILE_NO_COMPRESSION_LE		cpu_to_le32(0x00008000)
+#define FILE_OPEN_REPARSE_POINT_LE	cpu_to_le32(0x00200000)
+#define FILE_OPEN_NO_RECALL_LE		cpu_to_le32(0x00400000)
+#define CREATE_OPTIONS_MASK_LE          cpu_to_le32(0x00FFFFFF)
+
+#define FILE_READ_RIGHTS_LE (FILE_READ_DATA_LE | FILE_READ_EA_LE \
+			| FILE_READ_ATTRIBUTES_LE)
+#define FILE_WRITE_RIGHTS_LE (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE \
+			| FILE_WRITE_EA_LE | FILE_WRITE_ATTRIBUTES_LE)
+#define FILE_EXEC_RIGHTS_LE (FILE_EXECUTE_LE)
+
+/* Create Context Values */
+#define SMB2_CREATE_EA_BUFFER			"ExtA" /* extended attributes */
+#define SMB2_CREATE_SD_BUFFER			"SecD" /* security descriptor */
+#define SMB2_CREATE_DURABLE_HANDLE_REQUEST	"DHnQ"
+#define SMB2_CREATE_DURABLE_HANDLE_RECONNECT	"DHnC"
+#define SMB2_CREATE_ALLOCATION_SIZE		"AISi"
+#define SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST "MxAc"
+#define SMB2_CREATE_TIMEWARP_REQUEST		"TWrp"
+#define SMB2_CREATE_QUERY_ON_DISK_ID		"QFid"
+#define SMB2_CREATE_REQUEST_LEASE		"RqLs"
+#define SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2	"DH2Q"
+#define SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2	"DH2C"
+#define SMB2_CREATE_TAG_POSIX          "\x93\xAD\x25\x50\x9C\xB4\x11\xE7\xB4\x23\x83\xDE\x96\x8B\xCD\x7C"
+
+/* Flag (SMB3 open response) values */
+#define SMB2_CREATE_FLAG_REPARSEPOINT 0x01
+
+struct create_context {
+	__le32 Next;
+	__le16 NameOffset;
+	__le16 NameLength;
+	__le16 Reserved;
+	__le16 DataOffset;
+	__le32 DataLength;
+	__u8 Buffer[];
+} __packed;
+
+struct smb2_create_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 57 */
+	__u8   SecurityFlags;
+	__u8   RequestedOplockLevel;
+	__le32 ImpersonationLevel;
+	__le64 SmbCreateFlags;
+	__le64 Reserved;
+	__le32 DesiredAccess;
+	__le32 FileAttributes;
+	__le32 ShareAccess;
+	__le32 CreateDisposition;
+	__le32 CreateOptions;
+	__le16 NameOffset;
+	__le16 NameLength;
+	__le32 CreateContextsOffset;
+	__le32 CreateContextsLength;
+	__u8   Buffer[];
+} __packed;
+
+struct smb2_create_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 89 */
+	__u8   OplockLevel;
+	__u8   Flags;  /* 0x01 if reparse point */
+	__le32 CreateAction;
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 AllocationSize;
+	__le64 EndofFile;
+	__le32 FileAttributes;
+	__le32 Reserved2;
+	__le64  PersistentFileId;
+	__le64  VolatileFileId;
+	__le32 CreateContextsOffset;
+	__le32 CreateContextsLength;
+	__u8   Buffer[1];
+} __packed;
+
 
 #endif				/* _COMMON_SMB2PDU_H */
-- 
2.30.2

