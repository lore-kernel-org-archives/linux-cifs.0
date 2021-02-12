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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B69C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 18:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978A264E99
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 18:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBLSQw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 13:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhBLSQu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 13:16:50 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4E4C061574;
        Fri, 12 Feb 2021 10:16:10 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u4so130167ljh.6;
        Fri, 12 Feb 2021 10:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AoTuhu3DlTVK1aUQYYk55qO6vEl1oKyV3T843XUxhck=;
        b=Glv51Ob/vsn4WWmCNaOWmJeCG5COQtvDaEMOiAWSzzLAFDNuj6yTgJqNGG3T/jM7Fe
         35YXPG08WR7kYrJywdGs21orfFlWsZl4TA+x2xANT+BaGWq/j+o61DeIGm+PkgnqJygY
         oMFJyuE1JSuEu64A2yolqQCX/w4Wx3XtuA5roDKz/nE2najy8XM//q5p4ZKY4mMpc7EK
         DsCI+S3cZKRvueL0Vpvi66EHGX5vwsRilVW+l12fgHPQCEpga3e9PJpaGoKeaD9HK4eu
         X9M5blKlafBPGjpybG4n7BBsd+spI/gDcS5mHPGt2Ly8DM+8PGNR4b6Jy9aCNzuk/ArI
         axHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AoTuhu3DlTVK1aUQYYk55qO6vEl1oKyV3T843XUxhck=;
        b=tDQtfpdCnQdEi7v0AYVHbAI8mkLaC3z0LW17OwrbVANUV/EW6Jxm/2Z1lCdgAXwb9s
         Ym5/K9B0lNZfaXjxTjfx1xqoxnz3LmiFwc7wv7Yk1VNKofVEHFa8Nl63Wb8ubj+MC4er
         dHQA2hgS7g26vMH1cGNwHHtm++MVdHYM53qjOA+DliuLA2tV0AEIkiJo0NmifvfGUUJE
         YG/muoNK80sXrn9FdpXJBROIJUia+aAHMBlOZPoRRpITsAysEn4CTU9m5rJLR3T/GxZJ
         +6y3jvUFUccz4Aywwvr/vK2hPr2NcllGMlrXLa3ZYPVVNiYSHkrxEht511zJW3HUoGPd
         UieQ==
X-Gm-Message-State: AOAM533k9ZaOgP55k0kP2VQ2mG98rOA0GkQ9G/YmpmSDYXreFTK0litp
        4DsRYsopFZTRCn0Kc/AC1cn/g8R6Z0sdXAM24EY6LF17MQ3ung==
X-Google-Smtp-Source: ABdhPJw2ieYrBRiUpSOzCXO9nQhTYw2BCM3LWRvVolDUXAFenFap0CJ9KrCxbRlx5K71i9LzJJXb3LVYP4DzHSxI7tU=
X-Received: by 2002:a05:651c:548:: with SMTP id q8mr2348931ljp.256.1613153768589;
 Fri, 12 Feb 2021 10:16:08 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Feb 2021 12:15:57 -0600
Message-ID: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
Subject: [GIT PULL] cifs fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
92bf22614b21a2706f4993b278017e437f7785b3:

  Linux 5.11-rc7 (2021-02-07 13:57:38 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc7-smb3

for you to fetch changes up to a738c93fb1c17e386a09304b517b1c6b2a6a5a8b:

  cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting
cifs_sb->prepath. (2021-02-11 11:08:32 -0600)

----------------------------------------------------------------
4 small cifs fixes for the implementation of the new mount API (including
a particularly important one for DFS links) that were found in
additional testing
this week of additional DFS scenarios, and a user testing of an apache container
problem.

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/501
----------------------------------------------------------------
Ronnie Sahlberg (3):
      cifs: fix dfs-links
      cifs: do not disable noperm if multiuser mount option is not provided
      cifs: In the new mount api we get the full devname as source=

Shyam Prasad N (1):
      cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.

 fs/cifs/cifsfs.c     |  2 +-
 fs/cifs/connect.c    |  9 +++++++++
 fs/cifs/fs_context.c | 20 +++++++++++++++++---
 fs/cifs/fs_context.h |  1 +
 4 files changed, 28 insertions(+), 4 deletions(-)


--
Thanks,

Steve
