Return-Path: <SRS0=rQDn=XQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B89C49ED7
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 11:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 827C621835
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 11:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AL0xJ5Ga"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437768AbfIUL0K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Sep 2019 07:26:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40169 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437746AbfIUL0J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Sep 2019 07:26:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so5316250pgj.7
        for <linux-cifs@vger.kernel.org>; Sat, 21 Sep 2019 04:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=TgDx9tTm1X5XKdSonzCVeavL8DCrqJPhDaQpG8qx2Ac=;
        b=AL0xJ5GaDazDmGKR/IUIOsAE3sDFJzkn/n1UdYQ2m05kCwk3luSBQH+me5Q9R8jRpy
         GVTaK4gsa78PQ4lZxLyzjZdG29usF1DvEYp/PYA+jxbkB0tcvoDSibMfikjiF3Fb8HMP
         Wk3hHJ6Ys9Jme61m7RjwuQdhKMs9Q48sL2cA8GRBG886/2MUC6YhrqaAyWH5Mxuh5Jp6
         HA9jrTneQyWdL8oGdETebUfVNe2v0zmnh8+wln+bxHFHwufC/1yeRa1alcmPiKOuZFPu
         ZQman8oVzLyNCvQn3fM+6jn/4vRf8G4RXZMvRuj2/eM6EGaecnodb8EwR35b56+NKwuw
         elxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=TgDx9tTm1X5XKdSonzCVeavL8DCrqJPhDaQpG8qx2Ac=;
        b=WKOic4gmiZif6Ovbyoce+4C8lHinYE5Nz66amhsSA8pTigPTysg3SUs0bAmqjN64w3
         R1O9fq0MYQ8Udia/9acNiEHaXFHwBKtuRxbcnQVcwlfDGQChboAsUthrCu+1w/kJAT+v
         MeKNO+yFVmnjIkhlBEwizo9G7Bnw0TaBJXe1KiidticE9jfRgdQvg0hncJ+l4Za2i0dp
         dzZ5D0424fVbQ4pL6wJqFEsPSwSitdOK3vqUhnbIEE5WNu6YI08MrsM/umLBkOYb3DWI
         8ATjD3MQ1q5Fd5tWmCXjNMDmjw3IJbD08512YANFZdurwh7/27m1op4mknmlLzHqvfew
         R7tA==
X-Gm-Message-State: APjAAAU8uGMnOVDqAuV99ptaTCdL+fUA/yvswooINEGsUjjoxesXYTcs
        z3hOYPW3Z1OOKHo35N8xiZu19gXn
X-Google-Smtp-Source: APXvYqxsuix+5SxcpCbd6XuJl/N+pmIILuiBwal49xXGe189vbKo+Jlhxzvr4PFJxpzbTqvpTjkMWw==
X-Received: by 2002:a17:90a:8991:: with SMTP id v17mr9507540pjn.127.1569065168696;
        Sat, 21 Sep 2019 04:26:08 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k4sm4870706pjl.9.2019.09.21.04.26.07
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 04:26:08 -0700 (PDT)
Date:   Sat, 21 Sep 2019 19:26:00 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Subject: [PATCH] CIFS: fix max ea value size
Message-ID: <20190921112600.utzouyddp3cdmxhe@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It should not be larger then the slab max buf size. If user
specifies a larger size, it passes this check and goes
straightly to SMB2_set_info_init performing an insecure memcpy.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/cifs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 9076150758d8..db4ba8f6077e 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -31,7 +31,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 
-#define MAX_EA_VALUE_SIZE 65535
+#define MAX_EA_VALUE_SIZE CIFSMaxBufSize
 #define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
 #define CIFS_XATTR_ATTRIB "cifs.dosattrib"  /* full name: user.cifs.dosattrib */
 #define CIFS_XATTR_CREATETIME "cifs.creationtime"  /* user.cifs.creationtime */
-- 
2.21.0

