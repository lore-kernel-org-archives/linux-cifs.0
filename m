Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DADC4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Jul 2021 21:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE53560EFD
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Jul 2021 21:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhG3VKG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Jul 2021 17:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhG3VKF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 30 Jul 2021 17:10:05 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B05C06175F;
        Fri, 30 Jul 2021 14:09:58 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id h9so14207747ljq.8;
        Fri, 30 Jul 2021 14:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QSur+1PHlTt0wjrwYXzpD7UGhBN9zjUfFcpb+MppDGQ=;
        b=bpj7sleRqb8YAFh9SRbtRKYbJuFddVqeePUbCewjfc001JSv/SfF3qwszqHHkgs66k
         IevmQRt98/ElPaSvw9UxJegTcwBj2yjs0bJO6NHZ/m2ZbsVYdnkZ05aCA6bZnb6X8eo1
         0JSLlYA2Od+QVIxaPeqarS3AFNlGqv9y821Yy69HSAkmpOyr/GyPUBSYFkhYeKekpaAd
         nzbtxniLGW1rBdqQ0PAIHGxbp0EtdsTY+C0ZwS+14rIhX+mnDUueQgkd4BJW8/Q09mVG
         KuybvAZlrCbsLUL3GGswQu68Kj3Y7fbEYP6AsybW5VR5d2acKQdScU/RrWhnyTtXvXZW
         s1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QSur+1PHlTt0wjrwYXzpD7UGhBN9zjUfFcpb+MppDGQ=;
        b=lQtQwchlAC46WhS+iDnVZnNgLxWguED5ad+IKdfLNmr4lMlyOw6PdYuCWi+eP6y2EL
         EZVwJgfVBcFvPYCtsgGWFLAr8b6OLPwHY50Ci0OlgGLYXsuU2QxyVnh5ABih0N/hU+Kx
         sdu6tRD6STc8XB9Esss9NOwCT+IuzWTKmYJrQbrU9pcEhpdwve1G4SYQ37lEDPv99C08
         nS0XXla8dgC8Bja4/GBS1NIg2VPqaw7wPljD+ymsBtNCobtJickZmvVzcbdgRd9Gbtya
         ZDfGocpbNfk4ZU2sEG0JSvhv4yqqtLZ85yXHAtybOaIp+cA7B5JZm4iap8YUrGxmJn/F
         5K1w==
X-Gm-Message-State: AOAM532XDm3l2RsG30zHJZ+TR9WzwDjMwXI8Mfc9bb3zMTfok2gqyqHL
        YsI97ZpvJcxYlZmQQ0xGnSmmTWKomAUtmn1mklI=
X-Google-Smtp-Source: ABdhPJzWSoJeBz+UthApFvEVF3+nMI8DZKoX0r2cqasU5U4FDDWoZHXSBJT4HfenIMA5pS1kZqpA1RBMLOKstugceeA=
X-Received: by 2002:a2e:a884:: with SMTP id m4mr2949152ljq.406.1627679397200;
 Fri, 30 Jul 2021 14:09:57 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 30 Jul 2021 16:09:46 -0500
Message-ID: <CAH2r5msGVA44tK4+9YAm-vrH0sAL8WqPPfdnU5Uk5++jCqoJYQ@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
ff1176468d368232b684f75e82563369208bc371:

  Linux 5.14-rc3 (2021-07-25 15:35:14 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.14-rc3-smb3-fixes

for you to fetch changes up to b946dbcfa4df80ec81b442964e07ad37000cc059:

  cifs: add missing parsing of backupuid (2021-07-28 17:03:24 -0500)

----------------------------------------------------------------
3 cifs/smb3 fixes, including two for stable, and a fix for an
fallocate problem noticed by Clang

----------------------------------------------------------------
Ronnie Sahlberg (1):
      cifs: add missing parsing of backupuid

Steve French (2):
      SMB3: fix readpage for large swap cache
      smb3: rc uninitialized in one fallocate path

 fs/cifs/file.c       | 2 +-
 fs/cifs/fs_context.c | 7 +++++++
 fs/cifs/smb2ops.c    | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
