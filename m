Return-Path: <SRS0=dv7Q=VG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E031C606B0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 08:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4112D214AF
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 08:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfGIIlX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Jul 2019 04:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbfGIIlW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Jul 2019 04:41:22 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD76D30001D8;
        Tue,  9 Jul 2019 08:41:22 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-113.bne.redhat.com [10.64.54.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10C6F5DA62;
        Tue,  9 Jul 2019 08:41:21 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix parsing of symbolic link error response
Date:   Tue,  9 Jul 2019 18:41:11 +1000
Message-Id: <20190709084111.10788-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 09 Jul 2019 08:41:22 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1672539

In smb2_query_symlink(), if we are parsing the error buffer but it is not something
we recognize as a symlink we should return -EINVAL and not -ENOENT.
I.e. the entry does exist, it is just not something we recognize.

Additionally, add check to verify that that the errortag and the reparsetag all make sense.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 14 ++++++++++----
 fs/cifs/smb2pdu.h |  2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4b0b14946343..e704e04891fb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2605,26 +2605,32 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	err_buf = err_iov.iov_base;
 	if (le32_to_cpu(err_buf->ByteCount) < sizeof(struct smb2_symlink_err_rsp) ||
 	    err_iov.iov_len < SMB2_SYMLINK_STRUCT_SIZE) {
-		rc = -ENOENT;
+		rc = -EINVAL;
+		goto querty_exit;
+	}
+
+	symlink = (struct smb2_symlink_err_rsp *)err_buf->ErrorData;
+	if (le32_to_cpu(symlink->SymLinkErrorTag) != SYMLINK_ERROR_TAG ||
+	    le32_to_cpu(symlink->ReparseTag) != IO_REPARSE_TAG_SYMLINK) {
+		rc = -EINVAL;
 		goto querty_exit;
 	}
 
 	/* open must fail on symlink - reset rc */
 	rc = 0;
-	symlink = (struct smb2_symlink_err_rsp *)err_buf->ErrorData;
 	sub_len = le16_to_cpu(symlink->SubstituteNameLength);
 	sub_offset = le16_to_cpu(symlink->SubstituteNameOffset);
 	print_len = le16_to_cpu(symlink->PrintNameLength);
 	print_offset = le16_to_cpu(symlink->PrintNameOffset);
 
 	if (err_iov.iov_len < SMB2_SYMLINK_STRUCT_SIZE + sub_offset + sub_len) {
-		rc = -ENOENT;
+		rc = -EINVAL;
 		goto querty_exit;
 	}
 
 	if (err_iov.iov_len <
 	    SMB2_SYMLINK_STRUCT_SIZE + print_offset + print_len) {
-		rc = -ENOENT;
+		rc = -EINVAL;
 		goto querty_exit;
 	}
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 458bad01ca74..7e2e782f8edd 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -166,6 +166,8 @@ struct smb2_err_rsp {
 	__u8   ErrorData[1];  /* variable length */
 } __packed;
 
+#define SYMLINK_ERROR_TAG 0x4c4d5953
+
 struct smb2_symlink_err_rsp {
 	__le32 SymLinkLength;
 	__le32 SymLinkErrorTag;
-- 
2.13.6

