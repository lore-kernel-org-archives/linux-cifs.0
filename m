Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3BFCCA47F
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jun 2022 04:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiFXEyz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jun 2022 00:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiFXEyp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jun 2022 00:54:45 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD021C1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jun 2022 21:54:44 -0700 (PDT)
From:   Sam James <sam@gentoo.org>
To:     linux-cifs@vger.kernel.org
Cc:     Sam James <sam@gentoo.org>
Subject: [PATCH 2/2] getcifsacl, setcifsacl: add missing <endian.h> include for le32toh
Date:   Fri, 24 Jun 2022 05:54:32 +0100
Message-Id: <20220624045432.991655-2-sam@gentoo.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624045432.991655-1-sam@gentoo.org>
References: <20220624045432.991655-1-sam@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Needed to fix build on musl libc. It only works by chance on glibc
because of transitive includes (which could break at any time).

Example failure:
```
getcifsacl.c: In function 'print_ace':
getcifsacl.c:284:16: warning: implicit declaration of function 'le16toh' [-Wimplicit-function-declaration]
  284 |         size = le16toh(pace->size);
      |                ^~~~~~~
```

Bug: https://bugs.gentoo.org/842195
Signed-off-by: Sam James <sam@gentoo.org>
---
 getcifsacl.c | 1 +
 setcifsacl.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/getcifsacl.c b/getcifsacl.c
index d69d40a..123d11e 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -23,6 +23,7 @@
 #include "config.h"
 #endif /* HAVE_CONFIG_H */
 
+#include <endian.h>
 #include <string.h>
 #include <getopt.h>
 #include <stdint.h>
diff --git a/setcifsacl.c b/setcifsacl.c
index e925d59..84cd0b3 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -38,6 +38,7 @@
 #include "config.h"
 #endif /* HAVE_CONFIG_H */
 
+#include <endian.h>
 #include <string.h>
 #include <getopt.h>
 #include <stdint.h>
-- 
2.36.1

