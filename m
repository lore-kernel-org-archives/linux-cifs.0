Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DE8C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 23:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C97EF60FDA
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 23:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbhIBXih (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:38:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235909AbhIBXig (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Sep 2021 19:38:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630625857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Cd4vdBwgEZrNAHKxnONupzQ2TcPcoD98DrqbcfWI7E=;
        b=RkS8cLeOdYLRQuBERvHfmhc99UebwL3myeShtOLrsRniBvqzakC8vSOR8ra8VZzFJ4fO20
        mk0+Arps/pKmGG9SvGNo1o66ZJDqTUCuG6/zvaBZGCnns21PGy/QCYwong1ecW1gfrZWvb
        85SYuDKKtAUSOFxzlEO0auZAlluHGXU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-Joz9KE2rP3uNBhPpCNXXJQ-1; Thu, 02 Sep 2021 19:37:36 -0400
X-MC-Unique: Joz9KE2rP3uNBhPpCNXXJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3090107ACC7;
        Thu,  2 Sep 2021 23:37:34 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E790C5C23A;
        Thu,  2 Sep 2021 23:37:33 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/3] cifs: create smb2pdu.h to be shared between cifs client and server
Date:   Fri,  3 Sep 2021 09:37:14 +1000
Message-Id: <20210902233716.1923306-2-lsahlber@redhat.com>
In-Reply-To: <20210902233716.1923306-1-lsahlber@redhat.com>
References: <20210902233716.1923306-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create a share smb2pdu.h file and share it between the cifs client and server.
Start by moving the definition of opcode values into this shared
file.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h       |  1 +
 fs/cifs/smb2pdu.h        | 58 -------------------------------
 fs/cifs_common/smb2pdu.h | 74 ++++++++++++++++++++++++++++++++++++++++
 fs/ksmbd/smb2pdu.h       | 54 -----------------------------
 fs/ksmbd/smb_common.h    |  1 +
 5 files changed, 76 insertions(+), 112 deletions(-)
 create mode 100644 fs/cifs_common/smb2pdu.h

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c068f7d8d879..28409c60b6fe 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "smb2pdu.h"
+#include "../cifs_common/smb2pdu.h"
 
 #define CIFS_MAGIC_NUMBER 0xFF534D42      /* the first four bytes of SMB PDUs */
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index e9cac7970b66..09b4db3af21c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -15,64 +15,6 @@
 #include <net/sock.h>
 #include "cifsacl.h"
 
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
-#define SMB2_INTERNAL_CMD	cpu_to_le16(0xFFFF)
-
-#define NUMBER_OF_SMB2_COMMANDS	0x0013
-
 /* 52 transform hdr + 64 hdr + 88 create rsp */
 #define SMB2_TRANSFORM_HEADER_SIZE 52
 #define MAX_SMB2_HDR_SIZE 204
diff --git a/fs/cifs_common/smb2pdu.h b/fs/cifs_common/smb2pdu.h
new file mode 100644
index 000000000000..4c2b3e124071
--- /dev/null
+++ b/fs/cifs_common/smb2pdu.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *   fs/cifs_common/smb2pdu.h
+ *
+ *   Copyright (c) International Business Machines  Corp., 2009, 2013
+ *                 Etersoft, 2012
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ *              Ronnie Sahlberg (lsahlber@redhat.com) 2021
+ *
+ */
+
+#ifndef _COMMON_SMB2PDU_H
+#define _COMMON_SMB2PDU_H
+
+/*
+ * Note that, due to trying to use names similar to the protocol specifications,
+ * there are many mixed case field names in the structures below.  Although
+ * this does not match typical Linux kernel style, it is necessary to be
+ * able to match against the protocol specfication.
+ *
+ * SMB2 commands
+ * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
+ * (ie no useful data other than the SMB error code itself) and are marked such.
+ * Knowing this helps avoid response buffer allocations and copy in some cases.
+ */
+
+/* List of commands in host endian */
+#define SMB2_NEGOTIATE_HE	0x0000
+#define SMB2_SESSION_SETUP_HE	0x0001
+#define SMB2_LOGOFF_HE		0x0002 /* trivial request/resp */
+#define SMB2_TREE_CONNECT_HE	0x0003
+#define SMB2_TREE_DISCONNECT_HE	0x0004 /* trivial req/resp */
+#define SMB2_CREATE_HE		0x0005
+#define SMB2_CLOSE_HE		0x0006
+#define SMB2_FLUSH_HE		0x0007 /* trivial resp */
+#define SMB2_READ_HE		0x0008
+#define SMB2_WRITE_HE		0x0009
+#define SMB2_LOCK_HE		0x000A
+#define SMB2_IOCTL_HE		0x000B
+#define SMB2_CANCEL_HE		0x000C
+#define SMB2_ECHO_HE		0x000D
+#define SMB2_QUERY_DIRECTORY_HE	0x000E
+#define SMB2_CHANGE_NOTIFY_HE	0x000F
+#define SMB2_QUERY_INFO_HE	0x0010
+#define SMB2_SET_INFO_HE	0x0011
+#define SMB2_OPLOCK_BREAK_HE	0x0012
+
+/* The same list in little endian */
+#define SMB2_NEGOTIATE		cpu_to_le16(SMB2_NEGOTIATE_HE)
+#define SMB2_SESSION_SETUP	cpu_to_le16(SMB2_SESSION_SETUP_HE)
+#define SMB2_LOGOFF		cpu_to_le16(SMB2_LOGOFF_HE)
+#define SMB2_TREE_CONNECT	cpu_to_le16(SMB2_TREE_CONNECT_HE)
+#define SMB2_TREE_DISCONNECT	cpu_to_le16(SMB2_TREE_DISCONNECT_HE)
+#define SMB2_CREATE		cpu_to_le16(SMB2_CREATE_HE)
+#define SMB2_CLOSE		cpu_to_le16(SMB2_CLOSE_HE)
+#define SMB2_FLUSH		cpu_to_le16(SMB2_FLUSH_HE)
+#define SMB2_READ		cpu_to_le16(SMB2_READ_HE)
+#define SMB2_WRITE		cpu_to_le16(SMB2_WRITE_HE)
+#define SMB2_LOCK		cpu_to_le16(SMB2_LOCK_HE)
+#define SMB2_IOCTL		cpu_to_le16(SMB2_IOCTL_HE)
+#define SMB2_CANCEL		cpu_to_le16(SMB2_CANCEL_HE)
+#define SMB2_ECHO		cpu_to_le16(SMB2_ECHO_HE)
+#define SMB2_QUERY_DIRECTORY	cpu_to_le16(SMB2_QUERY_DIRECTORY_HE)
+#define SMB2_CHANGE_NOTIFY	cpu_to_le16(SMB2_CHANGE_NOTIFY_HE)
+#define SMB2_QUERY_INFO		cpu_to_le16(SMB2_QUERY_INFO_HE)
+#define SMB2_SET_INFO		cpu_to_le16(SMB2_SET_INFO_HE)
+#define SMB2_OPLOCK_BREAK	cpu_to_le16(SMB2_OPLOCK_BREAK_HE)
+
+#define SMB2_INTERNAL_CMD	cpu_to_le16(0xFFFF)
+
+#define NUMBER_OF_SMB2_COMMANDS	0x0013
+
+#endif				/* _COMMON_SMB2PDU_H */
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index bcec845b03f3..3043f4467522 100644
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
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index eb667d85558e..fbd73b90a013 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -11,6 +11,7 @@
 #include "glob.h"
 #include "nterr.h"
 #include "smb2pdu.h"
+#include "../cifs_common/smb2pdu.h"
 
 /* ksmbd's Specific ERRNO */
 #define ESHARE			50000
-- 
2.30.2

