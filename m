Return-Path: <SRS0=I8HW=TX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1C2C04AAC
	for <linux-cifs@archiver.kernel.org>; Thu, 23 May 2019 04:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB7620862
	for <linux-cifs@archiver.kernel.org>; Thu, 23 May 2019 04:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbfEWENJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 May 2019 00:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfEWENJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 May 2019 00:13:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03C42308FBB4;
        Thu, 23 May 2019 04:13:09 +0000 (UTC)
Received: from localhost (dhcp-12-130.nay.redhat.com [10.66.12.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E4A458B9;
        Thu, 23 May 2019 04:13:07 +0000 (UTC)
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org, longli@microsoft.com,
        Murphy Zhou <jencce.kernel@gmail.com>
Subject: [PATCH] fs/cifs/smb2pdu.c: fix buffer free in SMB2_ioctl_free
Date:   Thu, 23 May 2019 12:12:43 +0800
Message-Id: <20190523041243.12340-1-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 23 May 2019 04:13:09 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The 2nd buffer could be NULL even if iov_len is not zero. This can
trigger a panic when handling symlinks. It's easy to reproduce with
LTP fs_racer scripts[1] which are randomly craete/delete/link files
and dirs. Fix this panic by checking if the 2nd buffer is padding
before kfree, like what we do in SMB2_open_free.

[1] https://github.com/linux-test-project/ltp/tree/master/testcases/kernel/fs/racer

Fixes: 2c87d6a ("cifs: Allocate memory for all iovs in smb2_ioctl")
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/cifs/smb2pdu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 710ceb8..c36f940 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2619,10 +2619,12 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 void
 SMB2_ioctl_free(struct smb_rqst *rqst)
 {
+	int i;
 	if (rqst && rqst->rq_iov) {
 		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
-		if (rqst->rq_iov[1].iov_len)
-			kfree(rqst->rq_iov[1].iov_base);
+		for (i = 1; i < rqst->rq_nvec; i++)
+			if (rqst->rq_iov[i].iov_base != smb2_padding)
+				kfree(rqst->rq_iov[i].iov_base);
 	}
 }
 
-- 
1.8.3.1

