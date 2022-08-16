Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04A7C25B0F
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Aug 2022 04:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiHPEMl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Aug 2022 00:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiHPELr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Aug 2022 00:11:47 -0400
Received: from smtp.gentoo.org (dev.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDEB361306
        for <linux-cifs@vger.kernel.org>; Mon, 15 Aug 2022 17:43:59 -0700 (PDT)
From:   Sam James <sam@gentoo.org>
To:     Pavel Shilovsky <pshilovsky@samba.org>, linux-cifs@vger.kernel.org
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Sam James <sam@gentoo.org>
Subject: [PATCH 2/2] getcifsacl, setcifsacl: add missing <endian.h> include for le32toh
Date:   Tue, 16 Aug 2022 01:43:35 +0100
Message-Id: <20220816004335.2634169-2-sam@gentoo.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816004335.2634169-1-sam@gentoo.org>
References: <20220816004335.2634169-1-sam@gentoo.org>
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
index b7079ab..0bdc176 100644
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
2.37.2

