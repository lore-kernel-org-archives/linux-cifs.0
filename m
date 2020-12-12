Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE489C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F8D023137
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438347AbgLLFfM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgLLFeu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 00:34:50 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0014EC0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:34:07 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id y19so16825261lfa.13
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cAyZPQUK0IQcguK+dUVDa/KqvVAM178O4C/FqBN4Wf0=;
        b=H/zxOKJ0O87O35jQtv3T4Ee6qQrOZyiXzd2tfb37lKxrfRcMOwfzzS8qgczy+C4AWE
         O8uJ/lHCVwB8Z0D0TYFPumZf+PeLgZewF/H3qoOQH0+xdK+25zp7Iu1MtTIQ6g7whGoE
         /Aai2kedkK0CxcXCqZtSiCgGT1/iOnwPO0nOB74M6a++MAJAQNpgyFiwsPeCVfCqhaLx
         IiUA/Qws4C8omj5Xm4kWmt6J2svdzoOXveAvf5tWk21qIoCpZ8dsOpvU2U5ntcEHDPPz
         rSV9Ps7DMc6qPZGgE/pZPVyxWlZPYkEExH+HLTN74ETDVCFmXUBhuBXiCUahgftmDyl9
         ZEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cAyZPQUK0IQcguK+dUVDa/KqvVAM178O4C/FqBN4Wf0=;
        b=td4XGyJMVtM4ycBCJBWsGLrUW4319V2VqJiRee08bcq8EpMP6lqrHYaxk5DMVZi5Nm
         zKW7w1LTqyieMlawuRU9ms3/BM5ODIGXBLy55N6l12v3gOg7WHdSjDowocl37BT0103C
         Gq5s6PzzLRY7lEyMzwFu6OyGPop9s/KCrd3hQxU3d/DiO8nHq/4AKpzIui9T4obDMvQE
         NE90/Z9Z+Ov0Z4ESDOf7SR9vb3Q6Qkhrrc4KEs0wiiOZFjJnFnnhuusI0fmqtuBROeGw
         zXwfdr9Y4dGQa0RQwEQJlZWIHl9eqjrWk+Nsi1eFWokUPaRHkyvWV5ZQEGb/eMDoZjWM
         410w==
X-Gm-Message-State: AOAM5323Kexe+nd+uGUtWqgVVrLAy5EULlf2t7hHtsy2jgAg+uJ7niXT
        VLsZignKzf9Yq2pOeFh8DCxfLvT+K7g9MWpb3Vet3fxglmNJeA==
X-Google-Smtp-Source: ABdhPJyrje/rfMKqE3wNXh3EMMxPxPvkb19Z1sWPdjV4fqnYsv60VCYCwMt4TZR/CKweRgDQJraD3s1Bplby2+eCYKk=
X-Received: by 2002:a2e:9250:: with SMTP id v16mr335816ljg.256.1607751245575;
 Fri, 11 Dec 2020 21:34:05 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 23:33:54 -0600
Message-ID: <CAH2r5mvT6X-R-E+vFVUuGXYzh4BtWCefFsvhJK5EVEZhQt4YWQ@mail.gmail.com>
Subject: [PATCH][CIFS] minor updates to Kconfig
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Correct references to fs/cifs/README which has been replaced by
Documentation/filesystems/admin-guide/cifs/usage.rst, and also
correct a typo.
---
 fs/cifs/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 664ac5c63d39..fe03cbdae959 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -60,9 +60,9 @@ config CIFS_STATS2
    Enabling this option will allow more detailed statistics on SMB
    request timing to be displayed in /proc/fs/cifs/DebugData and also
    allow optional logging of slow responses to dmesg (depending on the
-   value of /proc/fs/cifs/cifsFYI, see fs/cifs/README for more details).
-   These additional statistics may have a minor effect on performance
-   and memory utilization.
+   value of /proc/fs/cifs/cifsFYI). See
Documentation/admin-guide/cifs/usage.rst
+   for more details. These additional statistics may have a minor effect
+   on performance and memory utilization.

    Unless you are a developer or are doing network performance analysis
    or tuning, say N.
@@ -102,10 +102,10 @@ config CIFS_WEAK_PW_HASH
    is enabled in the kernel build, LANMAN authentication will not be
    used automatically. At runtime LANMAN mounts are disabled but
    can be set to required (or optional) either in
-   /proc/fs/cifs (see fs/cifs/README for more detail) or via an
-   option on the mount command. This support is disabled by
-   default in order to reduce the possibility of a downgrade
-   attack.
+   /proc/fs/cifs (see Documentation/admin-guide/cifs/usage.rst for
+   more detail) or via an option on the mount command. This support
+   is disabled by default in order to reduce the possibility of a
+   downgrade attack.

    If unsure, say N.

@@ -196,7 +196,7 @@ config CIFS_SWN_UPCALL
  help
    The Service Witness Protocol (SWN) is used to get notifications
    from a highly available server of resource state changes. This
-   feature enables an upcall mechanism for CIFS which contacts an
+   feature enables an upcall mechanism for CIFS which contacts a
    userspace daemon to establish the DCE/RPC connection to retrieve
    the cluster available interfaces and resource change notifications.
    If unsure, say Y.

-- 
Thanks,

Steve
