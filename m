Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01F9C0650E
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 21:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A184F20838
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 21:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfGFVpw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 17:45:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfGFVpw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 6 Jul 2019 17:45:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B26C63082E0F;
        Sat,  6 Jul 2019 21:45:51 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-27.bne.redhat.com [10.64.54.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14C0280DD;
        Sat,  6 Jul 2019 21:45:50 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: refactor and clean up arguments in the reparse point parsing
Date:   Sun,  7 Jul 2019 07:45:42 +1000
Message-Id: <20190706214542.1505-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 06 Jul 2019 21:45:51 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 66 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c4047ad7b43f..4b0b14946343 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2383,11 +2383,6 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
 	/* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
 	len = le16_to_cpu(symlink_buf->ReparseDataLength);
 
-	if (len + sizeof(struct reparse_data_buffer) > plen) {
-		cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
-		return -EINVAL;
-	}
-
 	if (le64_to_cpu(symlink_buf->InodeType) != NFS_SPECFILE_LNK) {
 		cifs_dbg(VFS, "%lld not a supported symlink type\n",
 			le64_to_cpu(symlink_buf->InodeType));
@@ -2437,22 +2432,38 @@ parse_reparse_symlink(struct reparse_symlink_data_buffer *symlink_buf,
 }
 
 static int
-parse_reparse_point(struct reparse_symlink_data_buffer *buf,
-		      u32 plen, char **target_path,
-		      struct cifs_sb_info *cifs_sb)
+parse_reparse_point(struct reparse_data_buffer *buf,
+		    u32 plen, char **target_path,
+		    struct cifs_sb_info *cifs_sb)
 {
-	/* See MS-FSCC 2.1.2 */
-	if (le32_to_cpu(buf->ReparseTag) == IO_REPARSE_TAG_NFS)
-		return parse_reparse_posix((struct reparse_posix_data *)buf,
-			plen, target_path, cifs_sb);
-	else if (le32_to_cpu(buf->ReparseTag) == IO_REPARSE_TAG_SYMLINK)
-		return parse_reparse_symlink(buf, plen, target_path,
-					cifs_sb);
+	if (plen < sizeof(struct reparse_data_buffer)) {
+		cifs_dbg(VFS, "reparse buffer is too small. Must be "
+			 "at least 8 bytes but was %d\n", plen);
+		return -EIO;
+	}
 
-	cifs_dbg(VFS, "srv returned invalid symlink buffer tag:%d\n",
-		le32_to_cpu(buf->ReparseTag));
+	if (plen < le16_to_cpu(buf->ReparseDataLength) +
+	    sizeof(struct reparse_data_buffer)) {
+		cifs_dbg(VFS, "srv returned invalid reparse buf "
+			 "length: %d\n", plen);
+		return -EIO;
+	}
 
-	return -EIO;
+	/* See MS-FSCC 2.1.2 */
+	switch (le32_to_cpu(buf->ReparseTag)) {
+	case IO_REPARSE_TAG_NFS:
+		return parse_reparse_posix(
+			(struct reparse_posix_data *)buf,
+			plen, target_path, cifs_sb);
+	case IO_REPARSE_TAG_SYMLINK:
+		return parse_reparse_symlink(
+			(struct reparse_symlink_data_buffer *)buf,
+			plen, target_path, cifs_sb);
+	default:
+		cifs_dbg(VFS, "srv returned unknown symlink buffer "
+			 "tag:0x%08x\n", le32_to_cpu(buf->ReparseTag));
+		return -EOPNOTSUPP;
+	}
 }
 
 #define SMB2_SYMLINK_STRUCT_SIZE \
@@ -2581,23 +2592,8 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 			goto querty_exit;
 		}
 
-		if (plen < 8) {
-			cifs_dbg(VFS, "reparse buffer is too small. Must be "
-				 "at least 8 bytes but was %d\n", plen);
-			rc = -EIO;
-			goto querty_exit;
-		}
-
-		if (plen < le16_to_cpu(reparse_buf->ReparseDataLength) + 8) {
-			cifs_dbg(VFS, "srv returned invalid reparse buf "
-				 "length: %d\n", plen);
-			rc = -EIO;
-			goto querty_exit;
-		}
-
-		rc = parse_reparse_point(
-			(struct reparse_symlink_data_buffer *)reparse_buf,
-			plen, target_path, cifs_sb);
+		rc = parse_reparse_point(reparse_buf, plen, target_path,
+					 cifs_sb);
 		goto querty_exit;
 	}
 
-- 
2.13.6

