Return-Path: <SRS0=LGzZ=YH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E31ECE587
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 08:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C925C206A3
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 08:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfJNI70 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:59:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730354AbfJNI70 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Oct 2019 04:59:26 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3995F10F09;
        Mon, 14 Oct 2019 08:59:26 +0000 (UTC)
Received: from idlethread.redhat.com (ovpn-116-87.ams2.redhat.com [10.36.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DB3660C05;
        Mon, 14 Oct 2019 08:59:24 +0000 (UTC)
From:   Roberto Bergantinos Corpas <rbergant@redhat.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH] CIFS: avoid using MID 0xFFFF
Date:   Mon, 14 Oct 2019 10:59:23 +0200
Message-Id: <20191014085923.14967-1-rbergant@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 14 Oct 2019 08:59:26 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

According to MS-CIFS specification MID 0xFFFF should not be used by the
CIFS client, but we actually do. Besides, this has proven to cause races
leading to oops between SendReceive2/cifs_demultiplex_thread. On SMB1,
MID is a 2 byte value easy to reach in CurrentMid which may conflict with
an oplock break notification request coming from server

Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
---
 fs/cifs/smb1ops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index c4e75afa3258..c8d96230cbd2 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -183,6 +183,9 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 	/* we do not want to loop forever */
 	last_mid = cur_mid;
 	cur_mid++;
+	/* avoid 0xFFFF MID */
+	if (cur_mid == 0xffff)
+		cur_mid++;
 
 	/*
 	 * This nested loop looks more expensive than it is.
-- 
2.14.5

