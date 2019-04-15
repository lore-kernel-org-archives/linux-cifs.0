Return-Path: <SRS0=GStD=SR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8158C10F13
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Apr 2019 02:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87EA12075B
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Apr 2019 02:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfDOCOB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 14 Apr 2019 22:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfDOCOB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 14 Apr 2019 22:14:01 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E686C056807;
        Mon, 15 Apr 2019 02:14:01 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9734260123;
        Mon, 15 Apr 2019 02:14:00 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Date:   Mon, 15 Apr 2019 12:13:52 +1000
Message-Id: <20190415021352.30854-2-lsahlber@redhat.com>
In-Reply-To: <20190415021352.30854-1-lsahlber@redhat.com>
References: <20190415021352.30854-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 15 Apr 2019 02:14:01 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SMB2 Ioctl responses from servers may respond with both the request blob from
the client followed by the actual reply blob for ioctls that are bi-directional.

In that case we can not assume that the reply blob comes immediately after the
ioctl response structure.

This fixes FSCTLs such as SMB2:FSCTL_QUERY_ALLOCATED_RANGES

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0b7e2be2a781..2824b97c5869 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1462,12 +1462,19 @@ smb2_ioctl_query_info(const unsigned int xid,
 		io_rsp = (struct smb2_ioctl_rsp *)rsp_iov[1].iov_base;
 		if (le32_to_cpu(io_rsp->OutputCount) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(io_rsp->OutputCount);
+		if (qi.input_buffer_length > 0 &&
+		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length > rsp_iov[1].iov_len) {
+			rc = -EFAULT;
+			goto iqinf_exit;
+		}
 		if (copy_to_user(&pqi->input_buffer_length, &qi.input_buffer_length,
 				 sizeof(qi.input_buffer_length))) {
 			rc = -EFAULT;
 			goto iqinf_exit;
 		}
-		if (copy_to_user(pqi + 1, &io_rsp[1], qi.input_buffer_length)) {
+		if (copy_to_user((char *)pqi + sizeof(struct smb_query_info),
+				 (char *)io_rsp + le32_to_cpu(io_rsp->OutputOffset),
+				 qi.input_buffer_length)) {
 			rc = -EFAULT;
 			goto iqinf_exit;
 		}
-- 
2.13.6

