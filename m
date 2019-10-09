Return-Path: <SRS0=5iq/=YC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCA9ECE58D
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 04:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F246721835
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 04:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfJIErO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfJIErO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 9 Oct 2019 00:47:14 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3136F18C426F;
        Wed,  9 Oct 2019 04:47:14 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-171.pek2.redhat.com [10.72.12.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30CA95D9CD;
        Wed,  9 Oct 2019 04:47:10 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org, piastryyy@gmail.com, smfrench@gmail.com
Subject: [PATCH] mount.cifs.rst: update prefix mount option description.
Date:   Wed,  9 Oct 2019 10:17:05 +0530
Message-Id: <20191009044705.4807-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 09 Oct 2019 04:47:14 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This option is ignored after kernel v3.10

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 mount.cifs.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index ee5086c..f1a57d1 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -590,7 +590,8 @@ prefixpath=arg
   It's possible to mount a subdirectory of a share. The preferred way to
   do this is to append the path to the UNC when mounting. However, it's
   also possible to do the same by setting this option and providing the
-  path there.
+  path there. This option is provided for backward compatibility.
+  It is ignored after kernel v3.10
 
 vers=arg
   SMB protocol version. Allowed values are:
-- 
2.21.0

