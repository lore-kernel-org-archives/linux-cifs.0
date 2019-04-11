Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC2EC10F14
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 23:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 102BB20869
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 23:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfDKX4b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Apr 2019 19:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfDKX4b (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Apr 2019 19:56:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22066C049E24;
        Thu, 11 Apr 2019 23:56:31 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B06525D704;
        Thu, 11 Apr 2019 23:56:30 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: zero-range does not require the file is sparse
Date:   Fri, 12 Apr 2019 09:56:23 +1000
Message-Id: <20190411235623.26659-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 11 Apr 2019 23:56:31 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove the conditional to fail zero-range if the file is not flagged as sparse.
You can still zero out a range in SMB2 even for non-sparse files.

Tested with stock windows16 server.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ca952dc3ec75..56e85f46cd82 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2664,18 +2664,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			return rc;
 		}
 
-	/*
-	 * Must check if file sparse since fallocate -z (zero range) assumes
-	 * non-sparse allocation
-	 */
-	if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)) {
-		rc = -EOPNOTSUPP;
-		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
-			      ses->Suid, offset, len, rc);
-		free_xid(xid);
-		return rc;
-	}
-
 	cifs_dbg(FYI, "offset %lld len %lld", offset, len);
 
 	fsctl_buf.FileOffset = cpu_to_le64(offset);
-- 
2.13.6

