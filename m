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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBD0C432BE
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Aug 2021 05:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C14D60ED8
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Aug 2021 05:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhH3Fti (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Aug 2021 01:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhH3Fti (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Aug 2021 01:49:38 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E18C061575;
        Sun, 29 Aug 2021 22:48:44 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m18so14785161lfl.10;
        Sun, 29 Aug 2021 22:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=h6S1rlsuhQbbfaHSm0DcTq2usBWQ0P+C1lfcBqs7THk=;
        b=HRqs6fFqwgiAASLA7HMs8CUA1JrGF+jhmv/z64PoGj6np49yf/Hl3Bra7AwI4B4mGF
         s3h03mEszT4pbCPF7Puw3cTSpZqQcCXB+p4wOR+VMHANjRf/Iq6yy0ZemYBSzaRIoY+m
         giZgqrA6e6bdndPM3VqYPibE6XuNIZKGxnBvn/e6SO4PMuz2+g5PKOUrVG6PRzqhBt6L
         PXSCATFVLsypGl5ZWtTkSgXj2eGBWDIfFUbVsivKXk+xLv0JFgqtDNSkVM+ioU/aqCxM
         9NTgTShQtxDJGBps/qMZejvTDVIr2Au/3Vu54y4JT+cOYHMbRKghrcR4HarQXXWzwtML
         FQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=h6S1rlsuhQbbfaHSm0DcTq2usBWQ0P+C1lfcBqs7THk=;
        b=HLLj0RPAGbc9yzF0f11NWCa6nUg3HURQZet/WTi1yLJydI3G3++IZ+k8b4H7cc8Dpr
         ZMtynVMwLAWyiWjjKGbtvN38w/oLNUlHi6IuFG4g1Q/vNsJNcv0e/D283kshzL+RZbZA
         CXGesXMN83WkY2Hfm3j1EVC2ZX+I10Q4YYHAuZweJTEmEVp7vZtco0G2KDeRbkWAygGf
         W+B4r8bdR6EZqblbJAZiHzV4ETPqNBTq6zvZy1siqLhicWIrstnLZeaDYiGWXsj9omLN
         Ptd3zdl3vO9uhkkC0nFx0KNMvj3Ns+yg36yR+KT+SyUVqyBwz9g9SvIT0kiNeRL1SkM8
         ZUqg==
X-Gm-Message-State: AOAM53170LDjZO72Lhcvz8udqFQ7V4uJWX925xcjzqu5ACXySnUHWESR
        3wwDFni0txy5LGLyH3ToKCySWLHakrqXplVh4e+c/KE19kg=
X-Google-Smtp-Source: ABdhPJyEMOqW9hRCT7wE/paD34dFNcJyzGQtlqdvXb3TClR0gBFbheyVAOsgOXsaTpIl74cjxqwpxZMnczgzM06t29I=
X-Received: by 2002:a19:c7c3:: with SMTP id x186mr12895274lff.175.1630302522939;
 Sun, 29 Aug 2021 22:48:42 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Aug 2021 00:48:32 -0500
Message-ID: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
e22ce8eb631bdc47a4a4ea7ecf4e4ba499db4f93:

  Linux 5.14-rc7 (2021-08-22 14:24:56 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc-smb3-fixes-part1

for you to fetch changes up to 3998f0b8bc49ec784990971dc1f16bf367b19078:

  cifs: Do not leak EDEADLK to dgetents64 for
STATUS_USER_SESSION_DELETED (2021-08-25 16:08:38 -0500)

----------------------------------------------------------------
11 cifs/smb3 client fixes:
- mostly restructuring to allow disabling less secure algorithms (this
will allow eventual removing rc4 and md4 from general use in the
kernel)
- 4 fixes, including 2 for stable
- enable r/w support with fscache and cifs.ko

Am working on a larger set of changes (the usual ... multichannel,
auth and signing improvements), but wanted to get these in earlier to
reduce chance of merge conflicts
later in the merge window.
----------------------------------------------------------------
Ding Hui (1):
      cifs: fix wrong release in sess_alloc_buffer() failed path

Len Baker (1):
      CIFS: Fix a potencially linear read overflow

Ronnie Sahlberg (4):
      cifs: remove support for NTLM and weaker authentication algorithms
      cifs: fork arc4 and create a separate module for it for cifs and
other users
      cifs: create a MD4 module and switch cifs.ko to use it
      cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED

Shyam Prasad N (1):
      cifs: enable fscache usage even for files opened as rw

Steve French (4):
      smb3: fix posix extensions mount option
      oid_registry: Add OIDs for missing Spnego auth mechanisms to Macs
      cifs: cifs_md4 convert to SPDX identifier
      cifs: add cifs_common directory to MAINTAINERS file

 MAINTAINERS                  |   1 +
 fs/Kconfig                   |   7 ++
 fs/Makefile                  |   1 +
 fs/cifs/Kconfig              |  30 -------
 fs/cifs/cifs_debug.c         |  11 ---
 fs/cifs/cifs_swn.c           |   2 -
 fs/cifs/cifs_unicode.c       |   9 +-
 fs/cifs/cifsencrypt.c        |  89 +-------------------
 fs/cifs/cifsfs.c             |   8 --
 fs/cifs/cifsglob.h           |  32 +------
 fs/cifs/cifspdu.h            |  28 -------
 fs/cifs/cifsproto.h          |  10 ---
 fs/cifs/cifssmb.c            | 107 +-----------------------
 fs/cifs/connect.c            |  32 -------
 fs/cifs/file.c               |  15 +++-
 fs/cifs/fs_context.c         |  25 ++----
 fs/cifs/fs_context.h         |   3 -
 fs/cifs/fscache.c            |  41 +++++++--
 fs/cifs/fscache.h            |  23 ++++++
 fs/cifs/inode.c              |   6 ++
 fs/cifs/readdir.c            |  23 +++++-
 fs/cifs/sess.c               | 257
+--------------------------------------------------------
 fs/cifs/smb2maperror.c       |   1 -
 fs/cifs/smbencrypt.c         | 139 +++----------------------------
 fs/cifs_common/Makefile      |   7 ++
 fs/cifs_common/arc4.h        |  23 ++++++
 fs/cifs_common/cifs_arc4.c   |  87 +++++++++++++++++++
 fs/cifs_common/cifs_md4.c    | 197 +++++++++++++++++++++++++++++++++++++++++++
 fs/cifs_common/md4.h         |  27 ++++++
 include/linux/oid_registry.h |   7 ++
 30 files changed, 485 insertions(+), 763 deletions(-)
 create mode 100644 fs/cifs_common/Makefile
 create mode 100644 fs/cifs_common/arc4.h
 create mode 100644 fs/cifs_common/cifs_arc4.c
 create mode 100644 fs/cifs_common/cifs_md4.c
 create mode 100644 fs/cifs_common/md4.h


-- 
Thanks,

Steve
