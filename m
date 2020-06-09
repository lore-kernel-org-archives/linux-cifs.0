Return-Path: <SRS0=+oFK=7W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28A2C433E1
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 18:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D04206D5
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 18:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgFISBO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Jun 2020 14:01:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56814 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387531AbgFISAu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Jun 2020 14:00:50 -0400
Received: from mail-qk1-f197.google.com ([209.85.222.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <sergiodj@canonical.com>)
        id 1jiiYK-00060T-Vd
        for linux-cifs@vger.kernel.org; Tue, 09 Jun 2020 18:00:49 +0000
Received: by mail-qk1-f197.google.com with SMTP id i82so16796347qke.10
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jun 2020 11:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ocaDnRUtGQ2YcFF4GZqVCrdcfqytno9AvUgi6GIazxQ=;
        b=Esu1OwRCeCzPEhPlvennGMrQyAQihxUo5o8fae2KSY33dKciztqu/BB2cAsHFtotSV
         LiGQwPLJUNH2CdZPgr9X/SIP2gF6bE8eNcD7w38ioYb++rW81AWn37a3FXojgqMmbsVU
         Xuz07f7xeGK758YVLB2VwSr5fVfaVZdCFxOEGk52zatBBEGdkaF+9L9W3RPNh6udzpiz
         M1O5LiLlV00SOIO16xrjfb3F9hZO/mDlqkMV13cC++kygEHOw6V+FTGeQARsag1iLV7t
         0/X1D19JcFU2GjsDHieQlqbAV+FSjLaryuw/IisSgHLrvmNK35O3AZqjfVhM6bZWdOeS
         91Dw==
X-Gm-Message-State: AOAM530/8H7EgXA8mQdQTjH9Fz8M9OyuoGhB38lDww65/JAikMWPDLat
        XJ9OcmrftoNXw1gn7RYYkM9KVmIbM6GqbZ7luQXU5gaWdATuR0/MFtIysydb//+XOy8CxSW66X8
        GlMYpMJlIIxssOJxh3wlZ72JJtehw2KIxnjRjMBQ=
X-Received: by 2002:a05:620a:126c:: with SMTP id b12mr28888351qkl.7.1591725647779;
        Tue, 09 Jun 2020 11:00:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYDKJPlKDvTKES7LkS/gwE7+TfKi1zs8hU2WI1u1JrZS4zgpAs5Or9w9LRoAqovN68SJUhIw==
X-Received: by 2002:a05:620a:126c:: with SMTP id b12mr28888280qkl.7.1591725647028;
        Tue, 09 Jun 2020 11:00:47 -0700 (PDT)
Received: from localhost ([2607:f2c0:ec8c:1367:a936:f5da:48e:c0d2])
        by smtp.gmail.com with ESMTPSA id m82sm10328370qke.3.2020.06.09.11.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 11:00:46 -0700 (PDT)
From:   Sergio Durigan Junior <sergio.durigan@canonical.com>
To:     linux-cifs@vger.kernel.org
Cc:     Sergio Durigan Junior <sergio.durigan@canonical.com>
Subject: [PATCH] Separate binary names using comma in mount.cifs.rst
Date:   Tue,  9 Jun 2020 14:00:44 -0400
Message-Id: <20200609180044.500230-1-sergio.durigan@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

According to lexgrog(1), when a manpage refers to multiple programs
their names should be separated using a comma and a whitespace.  This
helps silence a lintian warning when building cifs-utils on Debian.

Signed-off-by: Sergio Durigan Junior <sergio.durigan@canonical.com>
---
 mount.cifs.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index 354269b..6ad84f1 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -1,6 +1,6 @@
-=====================
-mount.cifs mount.smb3
-=====================
+======================
+mount.cifs, mount.smb3
+======================
 
 --------------------------------------------------
 mount using the Common Internet File System (CIFS)
-- 
2.25.1

