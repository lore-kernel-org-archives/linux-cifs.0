Return-Path: <SRS0=fS5U=R6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51954C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 23:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EB02075C
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 23:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfC0X6G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 19:58:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbfC0X6G (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Mar 2019 19:58:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24A8B3082E57;
        Wed, 27 Mar 2019 23:58:06 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 742F16013C;
        Wed, 27 Mar 2019 23:58:05 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix kref underflow in close_shroot()
Date:   Thu, 28 Mar 2019 09:57:42 +1000
Message-Id: <20190327235742.6236-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 27 Mar 2019 23:58:06 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix a bug where we used to not initialize the cached fid structure at all
in open_shroot() if the open was successful but we did not get a lease.
This would leave the structure uninitialized and later when we close the handle
we would in close_shroot() try to kref_put() an uninitialized refcount.

Fix this by always initializing this structure when we are about to return
0/success but make the extra kref_get() on the refcount conditional to
whether we got a lease or not.
This extra get() is only used to hold the structure until we get a lease
break from the server at which point we will kref_put() it during lease
processing.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1022a3771e14..4f0fb53cd0de 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -724,14 +724,6 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	else
 		goto oshr_exit;
 
-
-	memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
-	tcon->crfid.tcon = tcon;
-	tcon->crfid.is_valid = true;
-	kref_init(&tcon->crfid.refcount);
-	kref_get(&tcon->crfid.refcount);
-
-
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_exit;
@@ -745,6 +737,20 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	tcon->crfid.file_all_info_is_valid = 1;
 
  oshr_exit:
+	/*
+	 * If we return 0/success then we must also initialize this struct.
+	 * If we got a lease we need to take out an extra get() to keep
+	 * the structure around until we receive the actual lease break.
+	 */
+	if (rc == 0) {
+		memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
+		tcon->crfid.tcon = tcon;
+		tcon->crfid.is_valid = true;
+		kref_init(&tcon->crfid.refcount);
+		if (o_rsp && o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
+			kref_get(&tcon->crfid.refcount);
+	}
+
 	mutex_unlock(&tcon->crfid.fid_mutex);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
-- 
2.13.6

