Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F01BC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 14:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DC9A2070D
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 14:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfCNOI6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:08:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfCNOI6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Mar 2019 10:08:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64FBA30A9CCC;
        Thu, 14 Mar 2019 14:08:58 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-111.bne.redhat.com [10.64.54.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C51FF5D9C8;
        Thu, 14 Mar 2019 14:08:57 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH] cifs: fix incorrect handling of smb2_set_sparse() return in smb3_simple_falloc
Date:   Fri, 15 Mar 2019 00:08:48 +1000
Message-Id: <20190314140848.11476-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 14 Mar 2019 14:08:58 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smb2_set_sparse does not return -errno, it returns a boolean where
true means success.
Change this to just ignore the return value just like the other callsites.

Additionally add code to handle the case where we must set the file sparse
and possibly also extending it.

Fixes xfstests: generic/236 generic/350 generic/420

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2ops.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 32dde87feaa9..03814b9f113d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2718,6 +2718,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
+	__le64 eof;
 
 	xid = get_xid();
 
@@ -2777,9 +2778,18 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			return rc;
 		}
 
-		rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
+		smb2_set_sparse(xid, tcon, cfile, inode, false);
+		rc = 0;
+	} else {
+		smb2_set_sparse(xid, tcon, cfile, inode, false);
+		rc = 0;
+		if (i_size_read(inode) < off + len) {
+			eof = cpu_to_le64(off + len);
+			rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+					  cfile->fid.volatile_fid, cfile->pid,
+					  &eof);
+		}
 	}
-	/* BB: else ... in future add code to extend file and set sparse */
 
 	if (rc)
 		trace_smb3_falloc_err(xid, cfile->fid.persistent_fid, tcon->tid,
-- 
2.13.6

