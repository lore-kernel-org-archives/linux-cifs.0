Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9273C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 22:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C56961057
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 22:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhIFWsH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 18:48:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhIFWsH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 18:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630968421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c89C1BG7sf8eIHe55IUDKhi+lSzNBA8h/V4y47mw8fU=;
        b=gZ78z5ybexLISV/6+I//axEO32QEzvm7qWGt1udFjvxOJJXVEJfbiS+rrIQ9ML0MDqWzFU
        YcEDHycTw2644fZxZDa4ur0/eBJk9TTZKpRxh5FOeERne4GatgFby/Xe/tN+gAu7zMunsC
        E+1GwSZd4BeTv6S8y4EUVQpbFqu5n04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-cZnx2whpOMi5G0rxVkKVag-1; Mon, 06 Sep 2021 18:47:00 -0400
X-MC-Unique: cZnx2whpOMi5G0rxVkKVag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9A291854E27;
        Mon,  6 Sep 2021 22:46:58 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B49C272A4;
        Mon,  6 Sep 2021 22:46:57 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/4] ksmbd: switch to use shared definitions where available
Date:   Tue,  7 Sep 2021 08:46:46 +1000
Message-Id: <20210906224648.2062040-3-lsahlber@redhat.com>
In-Reply-To: <20210906224648.2062040-1-lsahlber@redhat.com>
References: <20210906224648.2062040-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/ksmbd/smb2misc.c   |   1 -
 fs/ksmbd/smb2ops.c    |   1 -
 fs/ksmbd/smb2pdu.c    |   3 +-
 fs/ksmbd/smb2pdu.h    | 176 ------------------------------------------
 fs/ksmbd/smb_common.h |   1 +
 5 files changed, 2 insertions(+), 180 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 66052b5a88ac..6c12ee502a69 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -6,7 +6,6 @@
 
 #include "glob.h"
 #include "nterr.h"
-#include "smb2pdu.h"
 #include "smb_common.h"
 #include "smbstatus.h"
 #include "mgmt/user_session.h"
diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index 197473871aa4..7b7801d9b2b8 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -6,7 +6,6 @@
 
 #include <linux/slab.h>
 #include "glob.h"
-#include "smb2pdu.h"
 
 #include "auth.h"
 #include "connection.h"
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 319b6a8a0db0..87a041d6a0c1 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -13,7 +13,6 @@
 #include <linux/falloc.h>
 
 #include "glob.h"
-#include "smb2pdu.h"
 #include "smbfsctl.h"
 #include "oplock.h"
 #include "smbacl.h"
@@ -8249,7 +8248,7 @@ static void fill_transform_hdr(void *tr_buf, char *old_buf, __le16 cipher_type)
 	memset(tr_buf, 0, sizeof(struct smb2_transform_hdr) + 4);
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
 	tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
-	tr_hdr->Flags = cpu_to_le16(0x01);
+	tr_hdr->Flags = cpu_to_le16(TRANSFORM_FLAG_ENCRYPTED);
 	if (cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
 	    cipher_type == SMB2_ENCRYPTION_AES256_GCM)
 		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index c13b425c0f62..71d1411d97d9 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -10,60 +10,6 @@
 #include "ntlmssp.h"
 #include "smbacl.h"
 
-/*
- * Note that, due to trying to use names similar to the protocol specifications,
- * there are many mixed case field names in the structures below.  Although
- * this does not match typical Linux kernel style, it is necessary to be
- * able to match against the protocol specfication.
- *
- * SMB2 commands
- * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
- * (ie no useful data other than the SMB error code itself) and are marked such.
- * Knowing this helps avoid response buffer allocations and copy in some cases.
- */
-
-/* List of commands in host endian */
-#define SMB2_NEGOTIATE_HE	0x0000
-#define SMB2_SESSION_SETUP_HE	0x0001
-#define SMB2_LOGOFF_HE		0x0002 /* trivial request/resp */
-#define SMB2_TREE_CONNECT_HE	0x0003
-#define SMB2_TREE_DISCONNECT_HE	0x0004 /* trivial req/resp */
-#define SMB2_CREATE_HE		0x0005
-#define SMB2_CLOSE_HE		0x0006
-#define SMB2_FLUSH_HE		0x0007 /* trivial resp */
-#define SMB2_READ_HE		0x0008
-#define SMB2_WRITE_HE		0x0009
-#define SMB2_LOCK_HE		0x000A
-#define SMB2_IOCTL_HE		0x000B
-#define SMB2_CANCEL_HE		0x000C
-#define SMB2_ECHO_HE		0x000D
-#define SMB2_QUERY_DIRECTORY_HE	0x000E
-#define SMB2_CHANGE_NOTIFY_HE	0x000F
-#define SMB2_QUERY_INFO_HE	0x0010
-#define SMB2_SET_INFO_HE	0x0011
-#define SMB2_OPLOCK_BREAK_HE	0x0012
-
-/* The same list in little endian */
-#define SMB2_NEGOTIATE		cpu_to_le16(SMB2_NEGOTIATE_HE)
-#define SMB2_SESSION_SETUP	cpu_to_le16(SMB2_SESSION_SETUP_HE)
-#define SMB2_LOGOFF		cpu_to_le16(SMB2_LOGOFF_HE)
-#define SMB2_TREE_CONNECT	cpu_to_le16(SMB2_TREE_CONNECT_HE)
-#define SMB2_TREE_DISCONNECT	cpu_to_le16(SMB2_TREE_DISCONNECT_HE)
-#define SMB2_CREATE		cpu_to_le16(SMB2_CREATE_HE)
-#define SMB2_CLOSE		cpu_to_le16(SMB2_CLOSE_HE)
-#define SMB2_FLUSH		cpu_to_le16(SMB2_FLUSH_HE)
-#define SMB2_READ		cpu_to_le16(SMB2_READ_HE)
-#define SMB2_WRITE		cpu_to_le16(SMB2_WRITE_HE)
-#define SMB2_LOCK		cpu_to_le16(SMB2_LOCK_HE)
-#define SMB2_IOCTL		cpu_to_le16(SMB2_IOCTL_HE)
-#define SMB2_CANCEL		cpu_to_le16(SMB2_CANCEL_HE)
-#define SMB2_ECHO		cpu_to_le16(SMB2_ECHO_HE)
-#define SMB2_QUERY_DIRECTORY	cpu_to_le16(SMB2_QUERY_DIRECTORY_HE)
-#define SMB2_CHANGE_NOTIFY	cpu_to_le16(SMB2_CHANGE_NOTIFY_HE)
-#define SMB2_QUERY_INFO		cpu_to_le16(SMB2_QUERY_INFO_HE)
-#define SMB2_SET_INFO		cpu_to_le16(SMB2_SET_INFO_HE)
-#define SMB2_OPLOCK_BREAK	cpu_to_le16(SMB2_OPLOCK_BREAK_HE)
-
 /*Create Action Flags*/
 #define FILE_SUPERSEDED                0x00000000
 #define FILE_OPENED            0x00000001
@@ -107,75 +53,10 @@
 /* BB FIXME - analyze following length BB */
 #define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 bct + 2 pad */
 
-#define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe) /* 'B''M''S' */
-#define SMB2_TRANSFORM_PROTO_NUM cpu_to_le32(0x424d53fd)
-
 #define SMB21_DEFAULT_IOSIZE	(1024 * 1024)
 #define SMB3_DEFAULT_IOSIZE	(4 * 1024 * 1024)
 #define SMB3_DEFAULT_TRANS_SIZE	(1024 * 1024)
 
-/*
- * SMB2 Header Definition
- *
- * "MBZ" :  Must be Zero
- * "BB"  :  BugBug, Something to check/review/analyze later
- * "PDU" :  "Protocol Data Unit" (ie a network "frame")
- *
- */
-
-#define __SMB2_HEADER_STRUCTURE_SIZE	64
-#define SMB2_HEADER_STRUCTURE_SIZE				\
-	cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
-
-struct smb2_hdr {
-	__le32 ProtocolId;	/* 0xFE 'S' 'M' 'B' */
-	__le16 StructureSize;	/* 64 */
-	__le16 CreditCharge;	/* MBZ */
-	__le32 Status;		/* Error from server */
-	__le16 Command;
-	__le16 CreditRequest;	/* CreditResponse */
-	__le32 Flags;
-	__le32 NextCommand;
-	__le64 MessageId;
-	union {
-		struct {
-			__le32 ProcessId;
-			__le32  TreeId;
-		} __packed SyncId;
-		__le64  AsyncId;
-	} __packed Id;
-	__le64  SessionId;
-	__u8   Signature[16];
-} __packed;
-
-struct smb2_pdu {
-	struct smb2_hdr hdr;
-	__le16 StructureSize2; /* size of wct area (varies, request specific) */
-} __packed;
-
-#define SMB3_AES_CCM_NONCE 11
-#define SMB3_AES_GCM_NONCE 12
-
-struct smb2_transform_hdr {
-	__le32 ProtocolId;      /* 0xFD 'S' 'M' 'B' */
-	__u8   Signature[16];
-	__u8   Nonce[16];
-	__le32 OriginalMessageSize;
-	__u16  Reserved1;
-	__le16 Flags; /* EncryptionAlgorithm */
-	__le64  SessionId;
-} __packed;
-
-/*
- *	SMB2 flag definitions
- */
-#define SMB2_FLAGS_SERVER_TO_REDIR	cpu_to_le32(0x00000001)
-#define SMB2_FLAGS_ASYNC_COMMAND	cpu_to_le32(0x00000002)
-#define SMB2_FLAGS_RELATED_OPERATIONS	cpu_to_le32(0x00000004)
-#define SMB2_FLAGS_SIGNED		cpu_to_le32(0x00000008)
-#define SMB2_FLAGS_DFS_OPERATIONS	cpu_to_le32(0x10000000)
-#define SMB2_FLAGS_REPLAY_OPERATIONS	cpu_to_le32(0x20000000)
-
 /*
  *	Definitions for SMB2 Protocol Data Units (network frames)
  *
@@ -408,63 +289,6 @@ struct smb2_logoff_rsp {
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
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 2ecbc180ad5c..f15ebb864ead 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -10,6 +10,7 @@
 
 #include "glob.h"
 #include "nterr.h"
+#include "../cifs_common/smb2pdu.h"
 #include "smb2pdu.h"
 
 /* ksmbd's Specific ERRNO */
-- 
2.30.2

