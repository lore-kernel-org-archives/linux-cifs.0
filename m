Return-Path: <SRS0=fTzl=XL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AEAC4CEC7
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 02:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D87D821479
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 02:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbfIPC2w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Sep 2019 22:28:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:40218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727873AbfIPC2v (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 15 Sep 2019 22:28:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8B14AAE91;
        Mon, 16 Sep 2019 02:28:50 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 1/2] cifs: modefromsid: make room for 4 ACE
Date:   Mon, 16 Sep 2019 04:28:36 +0200
Message-Id: <20190916022837.32418-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

when mounting with modefromsid, we end up writing 4 ACE in a security
descriptor that only has room for 3, thus triggering an out-of-bounds
write. fix this by changing the min size of a security descriptor.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsacl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index dd95a6fa24bf..eb428349f29a 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -45,7 +45,7 @@
  */
 #define DEFAULT_SEC_DESC_LEN (sizeof(struct cifs_ntsd) + \
 			      sizeof(struct cifs_acl) + \
-			      (sizeof(struct cifs_ace) * 3))
+			      (sizeof(struct cifs_ace) * 4))
 
 /*
  * Maximum size of a string representation of a SID:
-- 
2.16.4

