Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA9CC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 09:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE1360555
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 09:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhKLJds (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbhKLJdr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Nov 2021 04:33:47 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B995C061766;
        Fri, 12 Nov 2021 01:30:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so7119360pjb.1;
        Fri, 12 Nov 2021 01:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JH3t0KNJWhDDYHS11aezG3qhLbT6ok5l8z/cPOu+GDU=;
        b=Je3H/567gu4S2GhyljJPmf1GwwYBkPziCkSmt6Hfq3h07VH/hgDfY7Sarxe/qSVOBX
         TuWWtkkcRQsekJ8o7cEtnMpMVMPWdBkht1wUKOlVCO6WCFNXYGjDdFRPwA9BYyqRfoJb
         GqAGGpBhAUMffTsDNPJEWpXpB4NsGPrb++37ZKLp4u4WhiKzsHivkAaVqxLu3IfcZUtj
         SvsoELl+cR1Y8f2jIwj3JBHfd3+yLYaZBvy28gviJDT8KLl15KB6hwq32E8emredxKXp
         B4+OGajNBpFGqqP0SzaPI3aCGHGczfFavTYEf1VQpHziG4Da+eI+fWo6dmnl+1mltmtT
         yLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JH3t0KNJWhDDYHS11aezG3qhLbT6ok5l8z/cPOu+GDU=;
        b=ArkC0XlxhgsJY81NQ+EuqtHSfs/vd2gWKSa8MPMX19mpzOcXuLNBJAopjfW187It5X
         DW3XzQm+MxIvOPbcGHQ/FETn5JHPK8v1XW3AYWNgm8rSt1ZUD15Wi7eia0KsylrEvhgi
         p1hqoxmFEjSPvricukHe5MlKellypPcRNpIPyRNbXTpkLRtOTleuSd6ql8I+YH6znQiG
         YQXUSD/TVfgEwEIeAqabM0kopGu15DNStUEUraFNy9/eH3Ti9wZ4OTEBbNKllbPiV4bJ
         r8Kfi0tvss6nfL1vW+G3i0MEyUCtRmvV1SFNuVMq1S4REpPJlaDRjSov0JbjN0y+A0Of
         2Cow==
X-Gm-Message-State: AOAM532PHopXfYZpIPf+72E2ij4PuruO2Tew59LUsEydOBsYnpK4WTie
        D15jX9c4WVNixfU+/n5tMZZ4pP++A9I=
X-Google-Smtp-Source: ABdhPJwNZaVMJBDuwZI+/3z9MnV/hKNdaXL6ANa8u2nrFLrUYWdRVZ3gCH0I2z42ER2hR2t4ZvTVzA==
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr15896781pjb.93.1636709457191;
        Fri, 12 Nov 2021 01:30:57 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id pi17sm11657538pjb.34.2021.11.12.01.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 01:30:56 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, chiminghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH] fs:cifs: convert from atomic_t to refcount_t on tlink->tl_count
Date:   Fri, 12 Nov 2021 09:30:51 +0000
Message-Id: <20211112093051.9366-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: chiminghao <chi.minghao@zte.com.cn>

use refcount_t instead of atomic_t
which prevents reference counter overflows.

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
---
 fs/cifs/cifsglob.h | 4 ++--
 fs/cifs/connect.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 41e97df4e0e5..a8edaada0fea 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -8,7 +8,7 @@
  */
 #ifndef _CIFS_GLOB_H
 #define _CIFS_GLOB_H
-
+#include <linux/refcount.h>
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/inet.h>
@@ -1115,7 +1115,7 @@ struct tcon_link {
 #define TCON_LINK_PENDING	1
 #define TCON_LINK_IN_TREE	2
 	unsigned long		tl_time;
-	atomic_t		tl_count;
+	refcount_t		tl_count;
 	struct cifs_tcon	*tl_tcon;
 };
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9637465d23db..4aad8c9acf2e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2318,7 +2318,7 @@ cifs_put_tlink(struct tcon_link *tlink)
 	if (!tlink || IS_ERR(tlink))
 		return;
 
-	if (!atomic_dec_and_test(&tlink->tl_count) ||
+	if (!refcount_dec_and_test(&tlink->tl_count) ||
 	    test_bit(TCON_LINK_IN_TREE, &tlink->tl_flags)) {
 		tlink->tl_time = jiffies;
 		return;
-- 
2.25.1

