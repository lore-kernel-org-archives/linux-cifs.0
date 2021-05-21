Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176D5C47078
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 16:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35716054E
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 16:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhEUQWf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 12:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhEUQWe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 May 2021 12:22:34 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319AEC061574;
        Fri, 21 May 2021 09:21:11 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id w7so11237928lji.6;
        Fri, 21 May 2021 09:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FfxeiWh7K2Up9BlsshUmWOPtaWQbPNOMBgiG3QZnOEY=;
        b=JJPQWdoK/Gu5nqBGahiXXO4eTxnSFYKY1v2QxGwafx9+kn/uDwHbSVrVhyESpjVEVG
         jccgiUD2EWt12WSKkYUcRK9yPXT/dxDr4fv7ALXBXXmL8l8tQNpBvarD1wzsas+N3Ln6
         XW11eymrwsACem7JBGrVp3IRsoDWBoOVoDPZKhb5GGMZqdLZbRpanISueUBWawl3CCGT
         Q/nJr1tcECUi4lvdsr0LrtsaiLBqxbsrYglg0YZkP7quI1JgQMV7SXZarxmx6oMROIuh
         K5umpHZl++qebBV3eqI4p3jYrlOWIOPAATVxtHs3uKrXl7bNBRQnn3kn8yETZp+Qq9fD
         Ms8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FfxeiWh7K2Up9BlsshUmWOPtaWQbPNOMBgiG3QZnOEY=;
        b=c3xEZP0us9pjKBsNhgf4b8AYM9auedHNP6jslwvhCiCkm4BSWe9m8J6O5n6gqY1E9y
         +1at5E3SU99+ij01zGZv1WhscaI9GHXfoeoQZweZ1hqDljKqB70Ag0R48MDaD/iGeAa3
         3de3D6PAt+8MOgYzt98xTwlYagON71xAKvRTJQxVJXJzWuZpqCrrjH63KCkmskFNvjsW
         ncjIzW9Zn3tI0idfs7Qlei5ZKWviWi4Q03h4+jPJKAPBeVoXTDD/kFJCdEayTbv/4pBl
         mqshEzQ9x7pq1VscSCJlHj9fcLIx7VWj1R07Yr4/y0vQOZRU4685sOb28IDLodHEbNSY
         +LuA==
X-Gm-Message-State: AOAM532Q3S2u1w3f1en+L98L7+nKthnFUK5Gc+NCp9pmNSeJmR8nG1Wa
        f5Ys3QnzjfZVYsRHjiMU+QpMZwfNSwJPeoDfg09JkPbatq2PmA==
X-Google-Smtp-Source: ABdhPJxwYXRBfrWP2laq8eo6GCiwH34rZeVkxzlnQ19dcWk+qqpVdBbU9pkmTL3DpWp5saOpsw9QHYTQt99e3h0Gsvw=
X-Received: by 2002:a2e:9e57:: with SMTP id g23mr7392226ljk.148.1621614069367;
 Fri, 21 May 2021 09:21:09 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 May 2021 11:20:58 -0500
Message-ID: <CAH2r5msWo7Z=Z5HPzxgaBzjuDKAL5hQ0cZfJd23k-JhnpzvDpg@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
d07f6ca923ea0927a1024dfccafc5b53b61cfecc:

  Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.13-rc3-smb3

for you to fetch changes up to 9687c85dfbf84a6a37522626b4d5c5191a695e6c:

  Fix KASAN identified use-after-free issue. (2021-05-20 12:20:42 -0500)

----------------------------------------------------------------
7 SMB3 fixes:
- one for stable (for copychunk)
- three others fix problems found in testing handle leases
- a fix for SMB3 compounding found during review and testing to the
kernel server
- two trivial cleanups

A few additional important patches are still in testing and are
not included in this pull request (e.g. a fix for some problems with variable
length strings in dynamic tracing, a problem with getting newer types of
decryption and session keys needed for debugging, a problem that was pointed
out at the recent test event, and some multichannel related reconnect fixes)
----------------------------------------------------------------
Jiapeng Chong (1):
      cifs: Fix inconsistent indenting

Rohith Surabattula (3):
      Fix kernel oops when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
      Defer close only when lease is enabled.
      Fix KASAN identified use-after-free issue.

Ronnie Sahlberg (1):
      cifs: fix memory leak in smb2_copychunk_range

Steve French (1):
      SMB3: incorrect file id in requests compounded with open

wenhuizhang (1):
      cifs: remove deadstore in cifs_close_all_deferred_files()

 fs/cifs/cifsfs.c     |  2 +-
 fs/cifs/cifsglob.h   |  4 ++--
 fs/cifs/file.c       | 46 +++++++++++++++++++++++++---------------------
 fs/cifs/fs_context.c |  2 +-
 fs/cifs/misc.c       | 23 +++++++++++++++++++----
 fs/cifs/smb2ops.c    |  4 ++++
 fs/cifs/smb2pdu.c    |  6 +++---
 7 files changed, 55 insertions(+), 32 deletions(-)


-- 
Thanks,

Steve
