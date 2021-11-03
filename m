Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C20C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 16:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6178D610EA
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 16:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhKCQXP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:23:15 -0400
Received: from alderaan.xwing.info ([79.137.33.81]:57588 "EHLO
        alderaan.xwing.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhKCQXO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Nov 2021 12:23:14 -0400
Received: from bespin.vpn.xwing.info (143.90.7.93.rev.sfr.net [93.7.90.143])
        by alderaan.xwing.info (Postfix) with ESMTPSA id 394B9100049;
        Wed,  3 Nov 2021 17:20:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=xwing.info; s=mail;
        t=1635956437; bh=KyMfWcpstFjbBOIWGNbVfLA5C/Rq0MTkORkIsp1kDbo=;
        h=From:To:Cc:Subject:Date;
        b=BkU+regq0n8xkkw1Sg0CCec5r5izm241/mAATNdqguRIAXY52L5bjV774fY3QDGcJ
         6N0Hg+hYBshtTUFK+nFDpRxpoQzdBQS7RK4jL/yC1GcL+hf3mNESGu42MIhNQx0rYW
         T7tG68mOmityQgfO5wWbYBvyjerR7Hbj49xyFp6I=
From:   Guillaume Castagnino <casta@xwing.info>
To:     linux-cifs@vger.kernel.org
Cc:     Guillaume Castagnino <casta@xwing.info>
Subject: [PATCH] ksmbd-tools: fix unit file
Date:   Wed,  3 Nov 2021 17:20:30 +0100
Message-Id: <20211103162030.183975-1-casta@xwing.info>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Guillaume Castagnino <casta@xwing.info>
---
 ksmbd.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ksmbd.service b/ksmbd.service
index 5717177..3309fa9 100644
--- a/ksmbd.service
+++ b/ksmbd.service
@@ -10,7 +10,7 @@ Group=root
 RemainAfterExit=yes
 ExecStartPre=-/sbin/modprobe ksmbd
 ExecStart=/sbin/ksmbd.mountd -s
-ExecReload=/sbin/ksmbd.control -s && /sbin/ksmbd.mountd
+ExecReload=/bin/sh -c '/sbin/ksmbd.control -s && /sbin/ksmbd.mountd -s'
 ExecStop=/sbin/ksmbd.control -s
 
 [Install]
-- 
2.33.1

