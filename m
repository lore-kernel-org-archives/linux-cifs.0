Return-Path: <SRS0=x7S9=4B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80ABCC352A4
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Feb 2020 02:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F41F206DB
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Feb 2020 02:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2E0NYqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgBMCPA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Feb 2020 21:15:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52085 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729333AbgBMCPA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Feb 2020 21:15:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581560099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=rO7szREJcfZkmDgxwr8h4x/0tpqssKwTXrxyd4hHHOc=;
        b=h2E0NYqUi7H0+sjFmusVqFo3h/5kXdXikm60Qd8xWxIhAZ0N3sgJx7f7tBv6E6fzoDNNtZ
        8BvDJ5gFRPJIVWBl4+7epjpGksbRdAxQ73qpVe+YA/rxD4Dl35hG2FPZ5F/0D0dFzuAfHP
        4D/T2oaXv/wG/8S47Ur9cg4wB7Tid3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-vOtNGfgROAS_V2s1HJmj8g-1; Wed, 12 Feb 2020 21:14:56 -0500
X-MC-Unique: vOtNGfgROAS_V2s1HJmj8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02D9F107ACC5
        for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2020 02:14:56 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A66038D;
        Thu, 13 Feb 2020 02:14:55 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: make sure we do not overflow the max EA buffer size
Date:   Thu, 13 Feb 2020 12:14:47 +1000
Message-Id: <20200213021447.24819-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1752437

Before we add a new EA we should check that this will not overflow
the maximum buffer we have available to read the EAs back.
Otherwise we can get into a situation where the EAs are so big that
we can not read them back to the client and thus we can not list EAs
anymore or delete them.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index baa825f4cec0..3c76f69f4ca7 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1116,7 +1116,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	void *data[1];
 	struct smb2_file_full_ea_info *ea = NULL;
 	struct kvec close_iov[1];
-	int rc;
+	struct smb2_query_info_rsp *rsp;
+	int rc, used_len = 0;
 
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -1139,6 +1140,38 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 							     cifs_sb);
 			if (rc == -ENODATA)
 				goto sea_exit;
+		} else {
+			/* If we are adding a attribute we should first check
+			 * if there will be enough space available to store
+			 * the new EA. If not we should not add it since we
+			 * would not be able to even read the EAs back.
+			 */
+			rc = smb2_query_info_compound(xid, tcon, utf16_path,
+				      FILE_READ_EA,
+				      FILE_FULL_EA_INFORMATION,
+				      SMB2_O_INFO_FILE,
+				      CIFSMaxBufSize -
+				      MAX_SMB2_CREATE_RESPONSE_SIZE -
+				      MAX_SMB2_CLOSE_RESPONSE_SIZE,
+				      &rsp_iov[1], &resp_buftype[1], cifs_sb);
+			if (rc == 0) {
+				rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
+				used_len = rsp->OutputBufferLength;
+			}
+			free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
+			resp_buftype[1] = CIFS_NO_BUFFER;
+			memset(&rsp_iov[1], 0, sizeof(rsp_iov[1]));
+			rc = 0;
+
+			/* Use a fudge factor of 256 bytes in case we collide
+			 * with a different set_EAs command.
+			 */
+			if(CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
+			   MAX_SMB2_CLOSE_RESPONSE_SIZE - 256 <
+			   used_len + ea_name_len + ea_value_len + 1) {
+				rc = -ENOSPC;
+				goto sea_exit;
+			}
 		}
 	}
 
-- 
2.13.6

