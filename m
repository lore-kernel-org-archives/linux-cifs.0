Return-Path: <SRS0=suyG=SL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79163C10F0E
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 21:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C562082A
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 21:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfDIVrb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 17:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfDIVra (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Apr 2019 17:47:30 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B056183F44;
        Tue,  9 Apr 2019 21:47:30 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4944719C4F;
        Tue,  9 Apr 2019 21:47:30 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix handle leak in smb2_query_symlink()
Date:   Wed, 10 Apr 2019 07:47:22 +1000
Message-Id: <20190409214722.27472-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 09 Apr 2019 21:47:30 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If we enter smb2_query_symlink() for something that is not a symlink
and where the SMB2_open() would succeed we would never end up
closing this handle and would thus leak a handle on the server.

Fix this by immediately calling SMB2_close() on successfull open.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 83a100dd2497..ab4737e3c31f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2397,6 +2397,8 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, &err_iov,
 		       &resp_buftype);
+	if (!rc)
+		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	if (!rc || !err_iov.iov_base) {
 		rc = -ENOENT;
 		goto free_path;
-- 
2.13.6

