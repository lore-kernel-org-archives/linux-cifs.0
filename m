Return-Path: <SRS0=SjeK=VW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5389CC7618F
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 03:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3356E21852
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 03:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389671AbfGYDJJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Jul 2019 23:09:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389532AbfGYDJJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Jul 2019 23:09:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70CA1307CDFC;
        Thu, 25 Jul 2019 03:09:09 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-100.bne.redhat.com [10.64.54.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6C6419C68;
        Thu, 25 Jul 2019 03:09:08 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: add passthrough for smb2 setinfo
Date:   Thu, 25 Jul 2019 13:08:43 +1000
Message-Id: <20190725030843.9412-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 25 Jul 2019 03:09:09 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add support to send smb2 set-info commands from userspace.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_ioctl.h |  1 +
 fs/cifs/smb2ops.c    | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index 086ddc5108af..6c3bd07868d7 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -46,6 +46,7 @@ struct smb_snapshot_array {
 /* query_info flags */
 #define PASSTHRU_QUERY_INFO	0x00000000
 #define PASSTHRU_FSCTL		0x00000001
+#define PASSTHRU_SET_INFO	0x00000002
 struct smb_query_info {
 	__u32   info_type;
 	__u32   file_info_class;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 592aa11aaf57..fc464dc20b30 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1369,7 +1369,10 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct cifs_fid fid;
 	struct kvec qi_iov[1];
 	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
+	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
 	struct kvec close_iov[1];
+	unsigned int size[2];
+	void *data[2];
 
 	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
@@ -1404,7 +1407,6 @@ smb2_ioctl_query_info(const unsigned int xid,
 
 	memset(&oparms, 0, sizeof(oparms));
 	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES | READ_CONTROL;
 	oparms.disposition = FILE_OPEN;
 	if (is_dir)
 		oparms.create_options = CREATE_NOT_FILE;
@@ -1413,9 +1415,6 @@ smb2_ioctl_query_info(const unsigned int xid,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	/*
-	 * FSCTL codes encode the special access they need in the fsctl code.
-	 */
 	if (qi.flags & PASSTHRU_FSCTL) {
 		switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
 		case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
@@ -1431,6 +1430,10 @@ smb2_ioctl_query_info(const unsigned int xid,
 			oparms.desired_access = GENERIC_WRITE;
 			break;
 		}
+	} else if (qi.flags & PASSTHRU_SET_INFO) {
+		oparms.desired_access = GENERIC_WRITE;
+	} else {
+		oparms.desired_access = FILE_READ_ATTRIBUTES | READ_CONTROL;
 	}
 
 	rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, path);
@@ -1454,6 +1457,24 @@ smb2_ioctl_query_info(const unsigned int xid,
 					     qi.output_buffer_length,
 					     CIFSMaxBufSize);
 		}
+	} else if (qi.flags == PASSTHRU_SET_INFO) {
+		/* Can eventually relax perm check since server enforces too */
+		if (!capable(CAP_SYS_ADMIN))
+			rc = -EPERM;
+		else  {
+			memset(&si_iov, 0, sizeof(si_iov));
+			rqst[1].rq_iov = si_iov;
+			rqst[1].rq_nvec = 1;
+
+			size[0] = 8;
+			data[0] = buffer;
+
+			rc = SMB2_set_info_init(tcon, &rqst[1],
+					COMPOUND_FID, COMPOUND_FID,
+					current->tgid,
+					FILE_END_OF_FILE_INFORMATION,
+					SMB2_O_INFO_FILE, 0, data, size);
+		}
 	} else if (qi.flags == PASSTHRU_QUERY_INFO) {
 		memset(&qi_iov, 0, sizeof(qi_iov));
 		rqst[1].rq_iov = qi_iov;
-- 
2.13.6

