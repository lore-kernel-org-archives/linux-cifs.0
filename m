Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93545C25B0D
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Aug 2022 04:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiHPEMQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Aug 2022 00:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiHPELo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Aug 2022 00:11:44 -0400
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDDE361302
        for <linux-cifs@vger.kernel.org>; Mon, 15 Aug 2022 17:43:59 -0700 (PDT)
From:   Sam James <sam@gentoo.org>
To:     Pavel Shilovsky <pshilovsky@samba.org>, linux-cifs@vger.kernel.org
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Sam James <sam@gentoo.org>
Subject: [PATCH 1/2] getcifsacl, setcifsacl: add missing <linux/limits.h> include for XATTR_SIZE_MAX
Date:   Tue, 16 Aug 2022 01:43:34 +0100
Message-Id: <20220816004335.2634169-1-sam@gentoo.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Needed to build on musl. It only works on glibc because of transitive includes
(which could break in future).

Example failure:
```
getcifsacl.c: In function 'getcifsacl':
getcifsacl.c:429:24: error: 'XATTR_SIZE_MAX' undeclared (first use in this function)
  429 |         if (bufsize >= XATTR_SIZE_MAX) {
      |                        ^~~~~~~~~~~~~~
```

Bug: https://bugs.gentoo.org/842195
Signed-off-by: Sam James <sam@gentoo.org>
---
 getcifsacl.c | 1 +
 setcifsacl.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/getcifsacl.c b/getcifsacl.c
index 1c01062..d69d40a 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -34,6 +34,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <ctype.h>
+#include <linux/limits.h>
 #include <sys/xattr.h>
 #include "cifsacl.h"
 #include "idmap_plugin.h"
diff --git a/setcifsacl.c b/setcifsacl.c
index d832cec..b7079ab 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -48,6 +48,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <ctype.h>
+#include <linux/limits.h>
 #include <sys/xattr.h>
 
 #include "cifsacl.h"
-- 
2.37.2

