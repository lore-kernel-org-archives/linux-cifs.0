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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8932FC71155
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Dec 2020 22:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22FC920870
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Dec 2020 22:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AnKCvc1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgLAWbQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Dec 2020 17:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbgLAW3U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Dec 2020 17:29:20 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D9CC0613CF;
        Tue,  1 Dec 2020 14:28:40 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 142so5874173ljj.10;
        Tue, 01 Dec 2020 14:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=CiTUANgfjfKtdvyzarr1HjDodW8e4dApTwh7hr8NUJw=;
        b=AnKCvc1zdUE/pzHrZsyEifBYMWV4+7iY5ZD3T21/k6rpyaNDslRq+PGU3M/+s8kvs4
         acAsoFD1INeR4N7EC9liMdpztyPaCAvD59iaqfUMFfc2I2mAjCgGAyNtTMgJBXw4QlFM
         CWComiu6F9YNMDPoP5sDsvyD64jdKsE6UCpSOshmHxq+S684U82PZqqmZYmi1PIlTtNh
         CYoYPzXAaBVVyyfkdj1CVqwh2ac+VKk1I/GD/cb5a6C44QST/Ia2QPt+tUHcSGrDhz50
         nUDsck3N+3Hq/QGjIuAfTmLsork5Si5WN7kjf6k651XfA/VUS31FySpR7sYV5QUACz+V
         4dNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=CiTUANgfjfKtdvyzarr1HjDodW8e4dApTwh7hr8NUJw=;
        b=slsB4wYmldODLhfSi4rbMcwpvLO/I9+xtyybCc/jFaRu2SfC6vSJWfpMSGBC1N7y/m
         bvqHxIn0QbenYRtE5wQIKyLZvyew87wtUGX5+FlzATNsYedBuik0VNusgyjPC3rZAI88
         yZerBh4meOFaMUocRJiO8SCLCpMI3zmOs1t9hg+WaTwLBk9Wib7xfDQCio06NryOD+ul
         gPljcDVdJlf+3ZKZrxk0GtxHH52VI+N3ZBSH7UVrKSK6/v1z2mnZJ8l9Ky42EUWnmLq4
         ozcz0f4XI/LfsvWDNWwKB3gD/nHXYUy6/JS/lTtdai4f2XXAMxAR75xq5tEd7Wosys0c
         Rgjw==
X-Gm-Message-State: AOAM532gu7sIm8QVQSkT/CLIQVB03Fi+cfWS+3gRFdlxdGRLzQDXiI9w
        AVTat3Ky/Ox7vlrPKS3WETM9Zm8mLt/4mx6f4BwUTaVxVFc=
X-Google-Smtp-Source: ABdhPJxMqdZExevdBXmhpxkIIqRqn4UUrUJ6ftFmJTHIE5I4fXMrWrwyKr6VDncxUs9eAJ2dXjmBe88Cq0Giq6btcZs=
X-Received: by 2002:a2e:b0c8:: with SMTP id g8mr2376510ljl.331.1606861718835;
 Tue, 01 Dec 2020 14:28:38 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 1 Dec 2020 16:28:27 -0600
Message-ID: <CAH2r5mskHWLCLFOcyNK7ZE64iRs9S9i+wP9g0+UTzy-bkCnWpg@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
b65054597872ce3aefbc6a666385eabdf9e288da:

  Linux 5.10-rc6 (2020-11-29 15:50:50 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc6-smb3-fixes

for you to fetch changes up to 212253367dc7b49ed3fc194ce71b0992eacaecf2:

  cifs: fix potential use-after-free in cifs_echo_request()
(2020-11-30 15:23:45 -0600)

----------------------------------------------------------------
Two smb3 fixes for stable including a use after free fix, and
one for signal handling in read.

Build verification test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/441
----------------------------------------------------------------
Paulo Alcantara (2):
      cifs: allow syscalls to be restarted in __smb_send_rqst()
      cifs: fix potential use-after-free in cifs_echo_request()

 fs/cifs/connect.c   | 2 ++
 fs/cifs/transport.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--
Thanks,

Steve
