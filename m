Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7264C33C9E
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 01:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E76124658
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 01:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X7iE16ew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgAOBXe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jan 2020 20:23:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27696 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728862AbgAOBXe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Jan 2020 20:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579051413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=tjRyWYPgjpbChzORh+hplaL0f98qTKL3yyJAnPuKxzQ=;
        b=X7iE16ewRsUSdxgbMh7+Y0/Upw+tDVGcg0vah8BnZLKOpF5N+Lg+IzFJ0ft21G/jq49zGq
        OUtxVCYBqVCr3/vo5si1k3FsM56Sv7J+yRdXzOWBRzwalzstjTJsfqekPO/yButPL9uA72
        +hiP8qbsF3/lqgsAhHuRrShkUWBCSJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-ncLmBw3zOqaZmwfKJVA5Ag-1; Tue, 14 Jan 2020 20:23:31 -0500
X-MC-Unique: ncLmBw3zOqaZmwfKJVA5Ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01A246DD59
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 01:23:31 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-61.bne.redhat.com [10.64.54.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89BE010018FF;
        Wed, 15 Jan 2020 01:23:30 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
Date:   Wed, 15 Jan 2020 11:23:21 +1000
Message-Id: <20200115012321.6780-2-lsahlber@redhat.com>
In-Reply-To: <20200115012321.6780-1-lsahlber@redhat.com>
References: <20200115012321.6780-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ 1336264

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6250370c1170..91818f7c1b9c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3106,9 +3106,13 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		else if (i_size_read(inode) >= off + len)
 			/* not extending file and already not sparse */
 			rc = 0;
-		/* BB: in future add else clause to extend file */
-		else
-			rc = -EOPNOTSUPP;
+		/* extend file */
+		else {
+			eof = cpu_to_le64(off + len);
+			rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+					  cfile->fid.volatile_fid, cfile->pid,
+					  &eof);
+		}
 		if (rc)
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
-- 
2.13.6

