Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D60BC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 03:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE722085A
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 03:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfCNDnd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 23:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfCNDnd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Mar 2019 23:43:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9220FC066467;
        Thu, 14 Mar 2019 03:43:33 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-111.bne.redhat.com [10.64.54.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 279F4600CD;
        Thu, 14 Mar 2019 03:43:32 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix incorrect handling of smb2_set_sparse() return in smb3_simple_falloc
Date:   Thu, 14 Mar 2019 13:43:25 +1000
Message-Id: <20190314034325.30355-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 14 Mar 2019 03:43:33 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smb2_set_sparse does not return -errno, it returns a boolean where
true means success.
Change this to just ignore the return value just like the other callsites.

Additionally add code to handle the case where we must set the file sparse
and possibly also extending it.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index eee5a27ca95e..fddfbda4f710 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2781,9 +2781,18 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
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

