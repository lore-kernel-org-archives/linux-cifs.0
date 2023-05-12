Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9155C77B7F
	for <linux-cifs@archiver.kernel.org>; Fri, 12 May 2023 19:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbjELTVX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 May 2023 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238509AbjELTVW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 May 2023 15:21:22 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFFF729B;
        Fri, 12 May 2023 12:21:21 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4eed764a10cso11581181e87.0;
        Fri, 12 May 2023 12:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683919279; x=1686511279;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MAf9SaDWTdarAzCYCfsyt3lnD/b/cooKNRhsZnbbUbg=;
        b=VoD1G4nCwO+L9mlhAcZflbvzJ7LWLEWPiWkhPowZEetA74tQvxy1p5njXAeVfuPk+f
         a0HlF5JKfxenfJxZ7xgTcRL/FfJptBHvBG9bceXXvKhoMLKIUFkseCOMHrYwbhiS8BCI
         szR2FhS7oyfoQRNifeXIKiFte3clykXmPwMZUrtfX5UJncw/Lf5+leFicIxu+Euh0JVx
         rYaBHTpCICBmfI+spSoomVLlGhSXZ3tFT7+aGQ+eG7+z0a/yu00qKFnI+RP3kC3yH5H1
         FK+y3b645KG6hUSOQy58XTtn2aATE5Vi7frC+EIupa8fKUdb/sNv4Z4mZoXu0/zriKcp
         W8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683919279; x=1686511279;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MAf9SaDWTdarAzCYCfsyt3lnD/b/cooKNRhsZnbbUbg=;
        b=ku+snrvRP0QYvezJafuFej61GAz23hBf38GQPHNOFtfexOEtiGmDVN7WRab2BYs0wv
         RtvS+/Pb9XSYum7TdRySPaeKbt/n34w/vgPupPKINkl2BqvdzmtqDEu+aF0iLDqkr3Ln
         XwSJhO14K/djk3kQABlYemHg74JMXZHAKwcA1hDUKveddtt4NBKKd6zSCMQ2MsyKsEui
         +8dkCyRvsFzWLpoFWHPJud/llLHjcZo8oGGK1wnALBWuOAO17DPNs/HOLitHJgFvcB6V
         fsYgrI0b7jv8QgKIVRM9vJ9XOXIpjPUaqJCRvaSPHi1n8d5mf35VyRBCaFoaBWCWdECq
         jtDA==
X-Gm-Message-State: AC+VfDzgMlgpg4ZIT9512ED3mmmbJKXFcj45Xs3KTXU8sQEdc43eNura
        mMyKlljZ/QQvaU8wwb2c+6s96mpHDbXENu9guI5caWwvtJ448Q==
X-Google-Smtp-Source: ACHHUZ4A7muQ9/gC30kZZtHTrCgLOJ5NNDx7XIX3isDaPLR9fSwjxeYZE7pkmSMl3Rekp9FrKT83gcdqgnIzYamF2DE=
X-Received: by 2002:ac2:4a76:0:b0:4f1:26da:54ab with SMTP id
 q22-20020ac24a76000000b004f126da54abmr4174350lfp.51.1683919278800; Fri, 12
 May 2023 12:21:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 May 2023 14:21:05 -0500
Message-ID: <CAH2r5mv21PgfmG7N=mV33QMsAmF4eeV=A77sXrPLNSbMR=79FQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
ac9a78681b921877518763ba0e89202254349d1b:

  Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.4-rc1-smb3-client-fixes

for you to fetch changes up to d39fc592ef8ae9a89c5e85c8d9f760937a57d5ba:

  cifs: release leases for deferred close handles when freezing
(2023-05-10 17:48:30 -0500)

----------------------------------------------------------------
6 smb3 client fixes, most also for stable
- fix for copy_file_range bug for very large files that are multiples of rsize
- do not ignore "isolated transport" flag if set on share
- set rasize default better
- three fixes related to shutdown and freezing (fixes 4 xfstests, and
closes deferred handles faster in some places that were missed)
----------------------------------------------------------------
Pawel Witek (1):
      cifs: fix pcchunk length type in smb2_copychunk_range

Steve French (5):
      do not reuse connection if share marked as isolated
      smb3: improve parallel reads of large files
      SMB3: force unmount was failing to close deferred close files
      smb3: fix problem remounting a share after shutdown
      cifs: release leases for deferred close handles when freezing

 fs/cifs/cifsfs.c  | 18 +++++++++++++++++-
 fs/cifs/connect.c |  7 +++++++
 fs/cifs/smb2ops.c |  2 +-
 fs/cifs/smb2pdu.c |  3 +++
 4 files changed, 28 insertions(+), 2 deletions(-)

--
Thanks,

Steve
