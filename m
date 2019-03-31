Return-Path: <SRS0=YreB=SC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B1FC43381
	for <linux-cifs@archiver.kernel.org>; Sun, 31 Mar 2019 23:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B2320870
	for <linux-cifs@archiver.kernel.org>; Sun, 31 Mar 2019 23:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbfCaXxx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 31 Mar 2019 19:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731383AbfCaXxw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 31 Mar 2019 19:53:52 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D72EC3082AC3;
        Sun, 31 Mar 2019 23:53:52 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BFF01001DCB;
        Sun, 31 Mar 2019 23:53:52 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: a smb2_validate_and_copy_iov failure does not mean the handle is invalid.
Date:   Mon,  1 Apr 2019 09:53:44 +1000
Message-Id: <20190331235344.1610-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sun, 31 Mar 2019 23:53:52 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It only means that we do not have a valid cached value for the
file_all_info structure.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7cfafac255aa..728437f8c45d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -733,14 +733,12 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_exit;
-	rc = smb2_validate_and_copy_iov(
+	if (!smb2_validate_and_copy_iov(
 				le16_to_cpu(qi_rsp->OutputBufferOffset),
 				sizeof(struct smb2_file_all_info),
 				&rsp_iov[1], sizeof(struct smb2_file_all_info),
-				(char *)&tcon->crfid.file_all_info);
-	if (rc)
-		goto oshr_exit;
-	tcon->crfid.file_all_info_is_valid = 1;
+				(char *)&tcon->crfid.file_all_info))
+		tcon->crfid.file_all_info_is_valid = 1;
 
  oshr_exit:
 	mutex_unlock(&tcon->crfid.fid_mutex);
-- 
2.13.6

