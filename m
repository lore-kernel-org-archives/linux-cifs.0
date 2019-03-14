Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FDBC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 02:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABD342087C
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 02:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfCNCSt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 22:18:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfCNCSt (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Mar 2019 22:18:49 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 093053001C89;
        Thu, 14 Mar 2019 02:18:49 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-111.bne.redhat.com [10.64.54.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 849F71001DD5;
        Thu, 14 Mar 2019 02:18:47 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix fallocate(mode==0) for extending non-sparse files
Date:   Thu, 14 Mar 2019 12:17:52 +1000
Message-Id: <20190314021752.24891-2-lsahlber@redhat.com>
In-Reply-To: <20190314021752.24891-1-lsahlber@redhat.com>
References: <20190314021752.24891-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 14 Mar 2019 02:18:49 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add support for the case when fallocate(mode==0) and we need to extend a
non-sparse file.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 32dde87feaa9..eee5a27ca95e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2718,6 +2718,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
+	__le64 eof;
 
 	xid = get_xid();
 
@@ -2747,9 +2748,12 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		else if (i_size_read(inode) >= off + len)
 			/* not extending file and already not sparse */
 			rc = 0;
-		/* BB: in future add else clause to extend file */
-		else
-			rc = -EOPNOTSUPP;
+		else {
+			eof = cpu_to_le64(off + len);
+			rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+					  cfile->fid.volatile_fid,
+					  cfile->pid, &eof);
+		}
 		if (rc)
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
-- 
2.13.6

