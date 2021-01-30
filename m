Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79821C433DB
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Jan 2021 18:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DE8664E13
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Jan 2021 18:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhA3Sui (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Jan 2021 13:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhA3Suh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Jan 2021 13:50:37 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666D1C061573;
        Sat, 30 Jan 2021 10:49:57 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id q12so17170069lfo.12;
        Sat, 30 Jan 2021 10:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=H5k8qtZJbHuudjGN1CUO70UUJQhJm9pI4Dj/GaUoYRA=;
        b=T7OTs5Aw/tiN9Ls+frYF7Q6d4GBObjNyKTT4VSA5pDbjK0PqTEM+X55c0hzJ/FCnBi
         nARzm8dfSaWbvfVFQmFyXtPMjrCv9oykiN3LNYAuFS45n4RRmqJLG4bZMA3jsDZYbOse
         GSWNF8mwiB5XaDUDm60uzjkFc3SgQsdh3cYhn4LBdcAqd063rpQZrQaA9H7aQK5k+I1k
         sVG0ab2nAlDvt4rdb+s76uC/bwTWiHo7xY1cNsjV9dhqeODM/3tlbmgd4I4WuwwfvB4n
         4tfBf2xuAvr05rhonV80jPI3bmlcNog6bF+9/KAxTJvU2QLlUMwgQGgm3mvvyOk2kvpf
         pgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=H5k8qtZJbHuudjGN1CUO70UUJQhJm9pI4Dj/GaUoYRA=;
        b=HIRtBHdKi6UUBVRgMwCiLOngpoRxgt/hmxeFqc3GK07cF7EZQtgUXwCsCJxQerFzdN
         WJzdiHr8XAFCe+hPJQx01nYQ6lwuwczubbZVsvTmqye5kY00hrzfleibpDaB18/z0mrg
         x5mGlc5gBJPBG8k0sennRt/ePdIoxPFOMvWz6diImZbyktuK+gxKIJBV1zdfTLG1XJ9M
         jXgy2J3627S4/eFRJn/KBxjI3S1hzu7/rtneE89NPLkEBEimlPROySnr85Jzvlt2QiCP
         ylm5qNfRZ4LvtIaAfWIfduCfWdcsqjRnC8o/y1B6W8V8LveONYTO4pIMerPJF2qPd8gI
         mxDg==
X-Gm-Message-State: AOAM532zBgBGKkEoFNGIU12mhO8xHl7mES7eNk/gO18f4Bz7VuOWs0HW
        b7zOOMX23cDQEg2to6JZXHgy5z7X+CYyCnMTt3Zbdxg40LcMEg==
X-Google-Smtp-Source: ABdhPJwSeD3Jr9r+7NiOvMXje6vln1tjUXKUG8sg76Mc9HcgWfICc/HUyuErVla59BHxTKLBiO0cGbOSYxBwwVG3PUs=
X-Received: by 2002:a05:6512:1284:: with SMTP id u4mr5179179lfs.175.1612032595793;
 Sat, 30 Jan 2021 10:49:55 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 Jan 2021 12:49:45 -0600
Message-ID: <CAH2r5mu==FO2Vfk-ppY5Z=e_a5ZU345DhJoLOBBZ02ZsjQ-Zzw@mail.gmail.com>
Subject: [GIT] cifs fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
6ee1d745b7c9fd573fba142a2efdad76a9f1cb04:

  Linux 5.11-rc5 (2021-01-24 16:47:14 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc5-smb3

for you to fetch changes up to 0d4873f9aa4ff8fc1d63a5755395b794d32ce046:

  cifs: fix dfs domain referrals (2021-01-28 21:40:43 -0600)

----------------------------------------------------------------
Four cifs patches found in additional testing of the conversion to the
new mount API. 3 small parm processing ones, and one fixing domain
based DFS referrals

A fix for nested mounts, an additional DFS fix and a security fix are
still being tested (I expect to send those next week).

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/486
----------------------------------------------------------------
Adam Harvey (1):
      cifs: ignore auto and noauto options if given

Ronnie Sahlberg (1):
      cifs: fix dfs domain referrals

Steve French (2):
      cifs: fix mounts to subdirectories of target
      cifs: returning mount parm processing errors correctly

 fs/cifs/cifs_dfs_ref.c | 12 ++++++++----
 fs/cifs/cifsfs.c       |  2 +-
 fs/cifs/cifsproto.h    |  6 ++++--
 fs/cifs/connect.c      | 32 ++++++++++++++++++++++++++------
 fs/cifs/dfs_cache.c    |  8 +++++---
 fs/cifs/fs_context.c   | 41 +++++++++++++++++++++++++++++++++++++----
 6 files changed, 81 insertions(+), 20 deletions(-)

-- 
Thanks,

Steve
