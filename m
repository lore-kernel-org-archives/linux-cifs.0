Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05453C433DB
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Mar 2021 16:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE78061964
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Mar 2021 16:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCTQRY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Mar 2021 12:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCTQRY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 Mar 2021 12:17:24 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE330C061574;
        Sat, 20 Mar 2021 09:17:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id a198so14698755lfd.7;
        Sat, 20 Mar 2021 09:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MjE8p8N6AtPJDpjXiZiJj0taGnUvpDrOn3GR8Bz5Jq0=;
        b=pdgc8nLLZlAQ+Sh900ZiHpWCImI587k43qprKp7qpwcyqBPEsYDcsRHy4H1s+Gu2OE
         IYAknTO9G91lsw0antFasThFJcdtjym54WK633zowikjgq+1J1/MxjhIeK01aI0DLuj1
         oYRuF5OJ04H9BG96F3QsQa2QsymQuJvkMoGyJtYklHy8wzCN/HsWSQ1C1SLyUFhHq2DR
         RAo3mtEeKx15A753kb0gMxAPjiA5pAcAQzVbvNFlcQjavC+TNT8s2NDOmq7pBPR0qtzY
         xaLJ8GAtxNgDlvYVM2dvi3AuQAB0Fyn8qnmf+l2i3md2Ik1E1XWQgfITmTdhvEhb/ihT
         Mlng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MjE8p8N6AtPJDpjXiZiJj0taGnUvpDrOn3GR8Bz5Jq0=;
        b=e/cP1i4uUcptGcqaD5hQLf2tv66hecoKuQHDfP4IDhBhi/p8tVRfm3wx16PGLvxvDA
         rW7AUH+WoETF6Ldq25X5aTJqQN9YG1OAzJYHD6xEh2O8KP31Zn0u29JWv42FDCotVJBv
         jTuVf3gjouZCRpNwOyLZR2Tp7kA/pu0XUejdPKXYHhMxoiCMjUh05jem8LoqrCeNQGN6
         ESNdnvZu2fDrr2cD1HGGoVSjVmf1NjlNAkJBziwS5gkKSLi0jpscRX7/3tK9hEj0i3ES
         4QlmAk7r06626vWZERODivXD2DvW7PsCP+T4BkDH7H2ZzabwaCWp371fpnArcX9Nh47E
         7alQ==
X-Gm-Message-State: AOAM5306JOeil1ppJ5vogimeOKOKN4j1dU+4QWWprDkQinKetRXEl89o
        fdpBUEPoosBsxt4wEB8VIlVcAAdf7pbU6tWJSZ3k5rLoDjL+dw==
X-Google-Smtp-Source: ABdhPJwFn/b0MVFEepvQaUa9qOAcI7i+QWH0OFcXEM7mh0QqbMKL8AoasqOPlfavWSMaHnD/LroEml12txZ9kDBfO3E=
X-Received: by 2002:a19:3f04:: with SMTP id m4mr3905483lfa.395.1616257041813;
 Sat, 20 Mar 2021 09:17:21 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 20 Mar 2021 11:17:10 -0500
Message-ID: <CAH2r5msU=QjVKHq_qYNOqwtLFctqU6E6cM9nBUw934Zb7YR9Hw@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
1e28eed17697bcf343c6743f0028cc3b5dd88bf0:

  Linux 5.12-rc3 (2021-03-14 14:41:02 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc3-smb3

for you to fetch changes up to 65af8f0166f4d15e61c63db498ec7981acdd897f:

  cifs: fix allocation size on newly created files (2021-03-19 11:51:31 -0500)

----------------------------------------------------------------
5 cifs/smb3 fixes, 3 for stable, including an important ACL fix and
security signature fix

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/530
----------------------------------------------------------------
Aurelien Aptel (1):
      cifs: warn and fail if trying to use rootfs without the config option

Liu xuzhi (1):
      fs/cifs/: fix misspellings using codespell tool

Shyam Prasad N (1):
      cifs: update new ACE pointer after populate_new_aces.

Steve French (1):
      cifs: fix allocation size on newly created files

Vincent Whitchurch (1):
      cifs: Fix preauth hash corruption

 fs/cifs/cifs_swn.c   |  2 +-
 fs/cifs/cifsacl.c    |  9 ++++++---
 fs/cifs/fs_context.c |  6 ++++--
 fs/cifs/inode.c      | 10 +++++++++-
 fs/cifs/transport.c  |  7 ++++++-
 5 files changed, 26 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
