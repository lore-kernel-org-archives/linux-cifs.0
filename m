Return-Path: <SRS0=queM=VN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3A0C76191
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 03:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A7F220693
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 03:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfGPDQ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Jul 2019 23:16:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbfGPDQ0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 15 Jul 2019 23:16:26 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4CA459440;
        Tue, 16 Jul 2019 03:16:26 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-77.bne.redhat.com [10.64.54.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27CE25C21A;
        Tue, 16 Jul 2019 03:16:25 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: flush before set-info if we have writeable handles
Date:   Tue, 16 Jul 2019 13:16:18 +1000
Message-Id: <20190716031618.7436-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 16 Jul 2019 03:16:26 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Servers can defer destaging any data and updating the mtime until close().
This means that if we do a setinfo to modify the mtime while other handles
are open for write the server may overwrite our setinfo timestamps when
if flushes the file on close() of the writeable handle.

To avoid this we add an explicit flush() before any attempts to use setinfo
and update the mtime IF we have writeable handles open.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 278405d26c47..a32a993077ea 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -516,7 +516,11 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	int rc;
+	struct cifsInodeInfo *cifsi;
+	struct cifsFileInfo *wrcfile;
 
 	if ((buf->CreationTime == 0) && (buf->LastAccessTime == 0) &&
 	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0) &&
@@ -527,7 +531,18 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 
-	rc = smb2_compound_op(xid, tlink_tcon(tlink), cifs_sb, full_path,
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
+	cifsi = CIFS_I(inode);
+	wrcfile = find_writable_file(cifsi, false);
+	if (wrcfile) {
+		filemap_write_and_wait(inode->i_mapping);
+		server->ops->flush(xid, tcon, &wrcfile->fid);
+		cifsFileInfo_put(wrcfile);
+	}
+
+	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, buf,
 			      SMB2_OP_SET_INFO);
 	cifs_put_tlink(tlink);
-- 
2.13.6

