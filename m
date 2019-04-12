Return-Path: <SRS0=lstS=SO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694E2C10F13
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 03:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FB5620674
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 03:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfDLDFp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Apr 2019 23:05:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfDLDFp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Apr 2019 23:05:45 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B52B30821F7;
        Fri, 12 Apr 2019 03:05:45 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2431117A9F;
        Fri, 12 Apr 2019 03:05:44 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Date:   Fri, 12 Apr 2019 13:05:34 +1000
Message-Id: <20190412030534.23402-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 12 Apr 2019 03:05:45 +0000 (UTC)
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
 fs/cifs/smb2ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0b7e2be2a781..768f35ea63cf 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1467,7 +1467,9 @@ smb2_ioctl_query_info(const unsigned int xid,
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

