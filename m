Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D67AC43334
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jun 2022 20:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiFCUfV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jun 2022 16:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiFCUfV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Jun 2022 16:35:21 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B6E517C0
        for <linux-cifs@vger.kernel.org>; Fri,  3 Jun 2022 13:35:18 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 253KZIUq003077
        for <linux-cifs@vger.kernel.org>; Fri, 3 Jun 2022 15:35:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654288518;
        bh=gDcnU4MEw0cJQkHHeLdmO6TIrrCVdNPzvwd7My4An/o=;
        h=From:To:CC:Subject:Date;
        b=ii6n8Kx/BZCn3rb7wFtpcaHeCpN0CG6s5E055t0endfL6z6r8+i+L8pisrhyzYx2o
         xDv2YOx96F8YOeUyLOzNew5aGXfa3r00kIQeIqAgVDCful9jFbPudd7nuNDr/0SbUJ
         0pO7mASXH4pXcKqhfpPZUgaq1/JF4l3oRTdw2EAA=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 253KZIVY114780
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-cifs@vger.kernel.org>; Fri, 3 Jun 2022 15:35:18 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 3
 Jun 2022 15:35:17 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 3 Jun 2022 15:35:17 -0500
Received: from uda0500628.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 253KZHlU004709;
        Fri, 3 Jun 2022 15:35:17 -0500
From:   Daniel Parks <danielrparks@ti.com>
To:     <linux-cifs@vger.kernel.org>
CC:     Daniel Parks <danielrparks@ti.com>
Subject: [PATCH] cifs-utils: Make automake treat /sbin as exec, not data
Date:   Fri, 3 Jun 2022 15:34:59 -0500
Message-ID: <20220603203459.21422-1-danielrparks@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Otherwise, $(DESTDIR)/sbin doesn't get created until install-data on a
-j1 build and install-exec-hook can fail because it might not exist.

Steps to reproduce this bug:
$ autoreconf -i
$ ./configure
$ mkdir image
$ make DESTDIR=image install -j1

Signed-off-by: Daniel Parks <danielrparks@ti.com>
---
 Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 84dd119..b1444f6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,8 +1,8 @@
 AM_CFLAGS = -Wall -Wextra -D_FORTIFY_SOURCE=2 $(PIE_CFLAGS) $(RELRO_CFLAGS)
 ACLOCAL_AMFLAGS = -I aclocal
 
-root_sbindir = $(ROOTSBINDIR)
-root_sbin_PROGRAMS = mount.cifs
+root_exec_sbindir = $(ROOTSBINDIR)
+root_exec_sbin_PROGRAMS = mount.cifs
 mount_cifs_SOURCES = mount.cifs.c mtab.c resolve_host.c util.c
 mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD)
 include_HEADERS = cifsidmap.h
-- 
2.17.1

