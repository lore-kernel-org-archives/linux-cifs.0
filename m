Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A330CC10F11
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E5C42075B
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfDKCU1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfDKCU1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Apr 2019 22:20:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0495481F22;
        Thu, 11 Apr 2019 02:20:27 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E5C719C65;
        Thu, 11 Apr 2019 02:20:26 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: Add support for FSCTL passthrough that write data to the server
Date:   Thu, 11 Apr 2019 12:20:17 +1000
Message-Id: <20190411022017.24942-2-lsahlber@redhat.com>
In-Reply-To: <20190411022017.24942-1-lsahlber@redhat.com>
References: <20190411022017.24942-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 11 Apr 2019 02:20:27 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add support to pass a blob to the server in FSCTL passthrough.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c  | 17 +++++++++++++++--
 fs/cifs/smbfsctl.h | 27 +++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 83a100dd2497..bb7522b882ea 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1382,6 +1382,18 @@ smb2_ioctl_query_info(const unsigned int xid,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
+	/*
+	 * FSCTL codes encode the special access they need in the fsctl code.
+	 */
+	if (qi.flags & PASSTHRU_FSCTL) {
+		switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
+		case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
+			oparms.desired_access = FILE_READ_DATA | FILE_WRITE_DATA | FILE_READ_ATTRIBUTES | SYNCHRONIZE;
+			;
+			break;
+		}
+	}
+
 	rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, path);
 	if (rc)
 		goto iqinf_exit;
@@ -1399,8 +1411,9 @@ smb2_ioctl_query_info(const unsigned int xid,
 
 			rc = SMB2_ioctl_init(tcon, &rqst[1],
 					     COMPOUND_FID, COMPOUND_FID,
-					     qi.info_type, true, NULL,
-					     0, CIFSMaxBufSize);
+					     qi.info_type, true, buffer,
+					     qi.output_buffer_length,
+					     CIFSMaxBufSize);
 		}
 	} else if (qi.flags == PASSTHRU_QUERY_INFO) {
 		memset(&qi_iov, 0, sizeof(qi_iov));
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index f996daeea271..9b3459b9a5ce 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -35,6 +35,33 @@
  * below). Additional detail on less common ones can be found in MS-FSCC
  * section 2.3.
  */
+
+/*
+ * FSCTL values are 32 bits and are constructed as
+ * <device 16bits> <access 2bits> <function 12bits> <method 2bits>
+ */
+/* Device */
+#define FSCTL_DEVICE_DFS                 (0x0006 << 16)
+#define FSCTL_DEVICE_FILE_SYSTEM         (0x0009 << 16)
+#define FSCTL_DEVICE_NAMED_PIPE          (0x0011 << 16)
+#define FSCTL_DEVICE_NETWORK_FILE_SYSTEM (0x0014 << 16)
+#define FSCTL_DEVICE_MASK                0xffff0000
+/* Access */
+#define FSCTL_DEVICE_ACCESS_FILE_ANY_ACCESS        (0x00 << 14)
+#define FSCTL_DEVICE_ACCESS_FILE_READ_ACCESS       (0x01 << 14)
+#define FSCTL_DEVICE_ACCESS_FILE_WRITE_ACCESS      (0x02 << 14)
+#define FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS (0x03 << 14)
+#define FSCTL_DEVICE_ACCESS_MASK                   0x0000c000
+/* Function */
+#define FSCTL_DEVICE_FUNCTION_MASK       0x00003ffc
+/* Method */
+#define FSCTL_DEVICE_METHOD_BUFFERED   0x00
+#define FSCTL_DEVICE_METHOD_IN_DIRECT  0x01
+#define FSCTL_DEVICE_METHOD_OUT_DIRECT 0x02
+#define FSCTL_DEVICE_METHOD_NEITHER    0x03
+#define FSCTL_DEVICE_METHOD_MASK       0x00000003
+
+
 #define FSCTL_DFS_GET_REFERRALS      0x00060194
 #define FSCTL_DFS_GET_REFERRALS_EX   0x000601B0
 #define FSCTL_REQUEST_OPLOCK_LEVEL_1 0x00090000
-- 
2.13.6

