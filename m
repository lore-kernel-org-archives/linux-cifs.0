Return-Path: <SRS0=dcBc=7I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E312C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 26 May 2020 03:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1BA220787
	for <linux-cifs@archiver.kernel.org>; Tue, 26 May 2020 03:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgEZDyS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 May 2020 23:54:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48126 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725265AbgEZDyS (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 May 2020 23:54:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A4FCF576A447F12E9862
        for <linux-cifs@vger.kernel.org>; Tue, 26 May 2020 11:54:15 +0800 (CST)
Received: from DESKTOP-FKFNUOQ.china.huawei.com (10.67.101.2) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 26 May 2020 11:54:13 +0800
From:   <lizhe67@huawei.com>
To:     <linux-cifs@vger.kernel.org>
Subject: [PATCH] cifs-utils: fix probabilistic compiling error
Date:   Tue, 26 May 2020 11:54:11 +0800
Message-ID: <20200526035411.102588-1-lizhe67@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.101.2]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: lizhe <lizhe67@huawei.com>

When we compile cifs-utils, we may probabilistic
encounter install error like:
cd ***/sbin && ln -sf mount.cifs mount.smb3
***/sbin: No such file or directory

The reason of this problem is that if we compile
cifs-utils using multithreading, target
'install-sbinPROGRAMS' may be built after
target 'install-exec-hook' of the main Makefile.
Target 'install-sbinPROGRAMS' will copy the
executable file 'mount.cifs' to the $(ROOTSBINDIR),
which target 'install-exec-hook' will do the
'ln' command on.

This patch add the dependency of target
'install-exec-hook' to ensure the correct order
of the compiling.

Signed-off-by: lizhe <lizhe67@huawei.com>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index fe9cd34..f0a69e9 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -118,7 +118,7 @@ endif
 
 SUBDIRS = contrib
 
-install-exec-hook:
+install-exec-hook: install-sbinPROGRAMS
 	(cd $(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
 
 install-data-hook:
-- 
2.12.3


