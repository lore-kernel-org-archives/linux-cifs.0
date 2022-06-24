Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A618CCA473
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jun 2022 04:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiFXEyy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jun 2022 00:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiFXEyp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jun 2022 00:54:45 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17CF2AC60
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jun 2022 21:54:43 -0700 (PDT)
From:   Sam James <sam@gentoo.org>
To:     linux-cifs@vger.kernel.org
Cc:     Sam James <sam@gentoo.org>
Subject: [PATCH 1/2] getcifsacl, setcifsacl: add missing <linux/limits.h> include for XATTR_SIZE_MAX
Date:   Fri, 24 Jun 2022 05:54:31 +0100
Message-Id: <20220624045432.991655-1-sam@gentoo.org>
X-Mailer: git-send-email 2.36.1
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
index 9840b14..e925d59 100644
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
2.36.1

