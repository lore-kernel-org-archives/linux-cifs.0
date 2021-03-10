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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FE4C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 02:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7707F64FE0
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 02:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhCJCtd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbhCJCtN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Mar 2021 21:49:13 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEA6C06174A;
        Tue,  9 Mar 2021 18:49:12 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id n22so5208307wmc.2;
        Tue, 09 Mar 2021 18:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Kw+LgXQW8KY9KkrizD3jcDkxfwAPNXon1f5R6IB52+g=;
        b=oPDIo9luyaC2qN8Kr/fVdUMDoPfNhZ4YH2j7EJ293mzpPR6KOhAZRknTRIZvnsXI0Y
         tQ3FjeBsViolk70ZaioLYC655pNugmi3/m3ctsuYkgWQKBrZQ0azY+dk3G84WzsaEWc8
         ERpCh2CF/JQxz/0TOaSvmF01WASLTkQGM05KRwJys5Uhg5jK0l05xaOy4Fj53gb3dl8/
         gulR7QEbNi/U5fnLO3dfFc3O2bOptbMrskTJovjyZc0MUE5Pg4eW3uYVI4yO0pAK9R76
         vipb0+23t/QyJHhlEQYWIRO50qvIHmMWt7e5HNh5mw0CRclwbq5vOyzFB968NjID8Vu/
         oS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Kw+LgXQW8KY9KkrizD3jcDkxfwAPNXon1f5R6IB52+g=;
        b=I3MsDtaA4tQCnF5jyNkaYfYgYSoPhnzxTUjEZJs50EnfoB7N9WpZOW4uFu0wYjTvZr
         Ku+vXE7KGMndhFSqSo0ihv+UJtIEt7lEWel095XZhy6ePufPT2/kjN9MZbM0py6fyo4i
         IkOedPCBGCkMlwHQt6E9VOC6NsTvDycik5VpEo36MNL0eqOgcrFKURUtT3bnfBHZ3VOc
         2zoxxyUclZShbaDAQYqOJmhQoW375JPepnXXnInlwFXxMn4rMVndWlaQlz5wkycuth0O
         ucUx03UtyModVtI3BZh7ZAgiLCgCPXimv8PiiS0SXFG1cRxtuJY20/RSF6QrPa0+PXQz
         DkNQ==
X-Gm-Message-State: AOAM532C/hRpWSFDDBTR8fQnKFKCaB9oYDjJXjQkcEZML+1p/6w1iZf5
        HOAe1CVMdERaqR4csseKj340OUCPGsLdNpbqw53+vDsJ9QVcZw==
X-Google-Smtp-Source: ABdhPJzJ/q2iwtHnU9TC7suxba0MSXyI96DH+4J6Tkim+LPmTWQgtdbvsrYiJVJ/HTUp213naewoRW3yEcjYcURoCC8=
X-Received: by 2002:a1c:7fc9:: with SMTP id a192mr842372wmd.15.1615344551337;
 Tue, 09 Mar 2021 18:49:11 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Mar 2021 20:49:00 -0600
Message-ID: <CAH2r5mt9OWkr_sGjYXSEzRghSsOaO9O6sqfHLM2E07Am15ceAA@mail.gmail.com>
Subject: [GIT PULL] cifs fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
a38fd8748464831584a19438cbb3082b5a2dab15:

  Linux 5.12-rc2 (2021-03-05 17:33:41 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc2-smb3

for you to fetch changes up to 04ad69c342fc4de5bd23be9ef15ea7574fb1a87e:

  cifs: do not send close in compound create+close requests
(2021-03-08 21:23:22 -0600)

----------------------------------------------------------------
6 cifs/smb3 fixes, 3 for stable, including some important mulitchannel
crediting fixes, and fix for statfs error handling

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/524
----------------------------------------------------------------
Aurelien Aptel (2):
      cifs: fix credit accounting for extra channel
      cifs: ask for more credit on async read/write code paths

Paulo Alcantara (4):
      cifs: print MIDs in decimal notation
      cifs: change noisy error message to FYI
      cifs: return proper error code in statfs(2)
      cifs: do not send close in compound create+close requests

 fs/cifs/cifs_debug.c |  2 +-
 fs/cifs/cifsfs.c     |  2 +-
 fs/cifs/cifsglob.h   | 19 ++++++++++---------
 fs/cifs/connect.c    | 14 +++++++-------
 fs/cifs/sess.c       |  1 +
 fs/cifs/smb2inode.c  |  1 +
 fs/cifs/smb2misc.c   | 10 +++++-----
 fs/cifs/smb2ops.c    | 10 +++++-----
 fs/cifs/smb2pdu.c    |  6 ++----
 fs/cifs/smb2proto.h  |  3 +--
 fs/cifs/transport.c  |  4 ++--
 11 files changed, 36 insertions(+), 36 deletions(-)

-- 
Thanks,

Steve
