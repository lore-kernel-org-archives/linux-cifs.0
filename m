Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A06C433ED
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 19:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6205F61289
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 19:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbhDZTvw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Apr 2021 15:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241076AbhDZTvv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Apr 2021 15:51:51 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D54C061574
        for <linux-cifs@vger.kernel.org>; Mon, 26 Apr 2021 12:51:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n138so90211317lfa.3
        for <linux-cifs@vger.kernel.org>; Mon, 26 Apr 2021 12:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ZUF6wewKbojkzesC8JnnpAekS6no9z4jIwe+y4LdVks=;
        b=Pi0zIPptnPkljhtLuFL2+zatM+b49XCkwauEaq5UUPlMjaGiVEvj8HsJPCvaatCCV0
         1FSjPv2oEwHLWhfaOkxaIvqpayhOGHmcJmVlOwi08Tj6gf+4wTQlV4M3nMQYJBIVFWl/
         qrqay1oYuqgNkA/VKdkfc37rw/GhS5UcuHOQnEqH1kjHYh5gK+o/jLa6bSGtXYfn+WhG
         bmzX8I4I98jCBPXR1722InjM6eQ3kJJRBaFyh7jG0WkcViZVhTGbdqoIiCMgZtoPheq+
         FfjZW2lk2XK/OmDUZZ+zyVW4UYSuJOEff1SLanCZ1GVj0LMQYGgg02Gr2OxVvDt979w8
         7bCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ZUF6wewKbojkzesC8JnnpAekS6no9z4jIwe+y4LdVks=;
        b=G36OhUYqPqMIA3v/8T606kHJTuZeKXvaIXsAfREKFXgFAbRl1Bi0wCoy1X+TdHPazH
         r9AuyjnA5ftgltIUkuoQ4Ja7QYIQyoVCAFQnbHcDYChXrAA7qgWT9Ip+O4yqSU9gVd/7
         7lVfSurR/81KKocMFGE9BtqfCVxSLt4Gk4zhG4/Qc3RT1MnGLSSkKNbukuSa7Xf2KWPn
         n9sGOhiFoJnhqnTbY7wdshGSB/RM5FSnHf2pISQROy7t9C2VSC7NEC2C33dCRpfeODtU
         1ADIK8y4Oq9yeNX8Juh4YLpJVixKH6ferANeQ8YeQiGuKkHI8oVhStaEPdzx4qE972eR
         H2/A==
X-Gm-Message-State: AOAM530mDVysGR84jQXqYXv/5H4t2Tlt6eKtIUOK1GuzrF1mt20Ts94h
        Ekh96614Cobc+kS1wlgSrtX2rkR7nsLZwfajBzvIS/PIFCU=
X-Google-Smtp-Source: ABdhPJyA9TU7PDWgGK/8KTCmNWRTXEqxF5P3RSZ+bGTDEUO8VhILrMCKA3qra03METjwt/ILm4CMyoS272u/I0eU++w=
X-Received: by 2002:a05:6512:3ca0:: with SMTP id h32mr14519485lfv.184.1619466668279;
 Mon, 26 Apr 2021 12:51:08 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Apr 2021 14:50:57 -0500
Message-ID: <CAH2r5mvK3_dmwbtH6v0unMEnrdR5Rny+Aki3GnyD=uRU2GH4=w@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
9f4ad9e425a1d3b6a34617b8ea226d56a119a717:

  Linux 5.12 (2021-04-25 13:49:08 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc-smb3-fixes-part1

for you to fetch changes up to a8a6082d4ae29d98129440c4a5de8e6ea3de0983:

  cifs: update internal version number (2021-04-25 23:59:27 -0500)

----------------------------------------------------------------
40 cifs/smb3 changesets, including 4 fixes for stable, and various new features:

- improvements to root directory metadata caching
- addition of new "rasize" mount parameter which can significantly
increase read ahead performance (e.g. copy can be much faster,
especially with multichannel)
- addition of support for insert and collapse range
- improvements to error handling in mount

Additional features still being tested: including the important
performance patches for deferred close ("handle lease" support)
patches, the improved support for fallocate, and some important
improvements to multichannel reconnect behavior are still being tested
and are not included in this pull request.

Reran the regression tests on these 40 on top of recently released 5.12:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/604
----------------------------------------------------------------
Al Viro (7):
      cifs: don't cargo-cult strndup()
      cifs: constify get_normalized_path() properly
      cifs: constify path argument of ->make_node()
      cifs: constify pathname arguments in a bunch of helpers
      cifs: make build_path_from_dentry() return const char *
      cifs: allocate buffer in the caller of build_path_from_dentry()
      cifs: switch build_path_from_dentry() to using dentry_path_raw()

Aurelien Aptel (8):
      cifs: simplify SWN code with dummy funcs instead of ifdefs
      Documentation/admin-guide/cifs: document open_files and dfscache
      cifs: remove old dead code
      cifs: make fs_context error logging wrapper
      cifs: add fs_context param to parsing helpers
      cifs: log mount errors using cifs_errorf()
      cifs: export supported mount options via new mount_params /proc file
      smb2: fix use-after-free in smb2_ioctl_query_info()

David Disseldorp (1):
      cifs: fix leak in cifs_smb3_do_mount() ctx

Eugene Korenevsky (1):
      cifs: fix out-of-bound memory access when calling smb3_notify()
at mount point

Gustavo A. R. Silva (1):
      cifs: cifspdu.h: Replace one-element array with flexible-array member

Jiapeng Chong (1):
      cifs: Remove useless variable

Muhammad Usama Anjum (1):
      cifs: remove unnecessary copies of tcon->crfid.fid

Paul Aurich (1):
      cifs: Return correct error code from smb2_get_enc_key

Ronnie Sahlberg (11):
      cifs: move the check for nohandlecache into open_shroot
      cifs: pass a path to open_shroot and check if it is the root or not
      cifs: rename the *_shroot* functions to *_cached_dir*
      cifs: store a pointer to the root dentry in cifs_sb_info once we
have completed mounting the share
      cifs: Grab a reference for the dentry of the cached directory
during the lifetime of the cache
      cifs: add a function to get a cached dir based on its dentry
      cifs: add a timestamp to track when the lease of the cached dir was taken
      cifs: pass the dentry instead of the inode down to the
revalidation check functions
      cifs: check the timestamp for the cached dirent when deciding on
revalidate
      cifs: add support for FALLOC_FL_COLLAPSE_RANGE
      cifs: add FALLOC_FL_INSERT_RANGE support

Steve French (6):
      cifs: correct comments explaining internal semaphore usage in the module
      smb3: update protocol header definitions based to include new flags
      SMB3: update structures for new compression protocol definitions
      smb3: limit noisy error
      smb3: add rasize mount parameter to improve readahead performance
      cifs: update internal version number

Wan Jiabing (1):
      fs: cifs: Remove repeated struct declaration

jack1.li_cp (1):
      cifs: Fix spelling of 'security'

 Documentation/admin-guide/cifs/usage.rst |   3 +
 fs/cifs/cifs_debug.c                     |  58 +++++++++++++--
 fs/cifs/cifs_dfs_ref.c                   |  14 ++--
 fs/cifs/cifs_fs_sb.h                     |   4 +
 fs/cifs/cifs_swn.h                       |  27 +++++++
 fs/cifs/cifsacl.c                        |   4 +-
 fs/cifs/cifsfs.c                         |  47 ++++++++++--
 fs/cifs/cifsfs.h                         |   2 +-
 fs/cifs/cifsglob.h                       |  32 ++------
 fs/cifs/cifspdu.h                        |   2 +-
 fs/cifs/cifsproto.h                      |  30 ++++----
 fs/cifs/cifssmb.c                        |  52 +------------
 fs/cifs/connect.c                        |  34 ++-------
 fs/cifs/dfs_cache.c                      |  41 ++++++-----
 fs/cifs/dir.c                            | 150
++++++++++++++-----------------------
 fs/cifs/file.c                           |  79 ++++++++++----------
 fs/cifs/fs_context.c                     | 143
++++++++++++++++++++----------------
 fs/cifs/fs_context.h                     |  13 ++--
 fs/cifs/inode.c                          | 140
++++++++++++++++++-----------------
 fs/cifs/ioctl.c                          |  13 ++--
 fs/cifs/link.c                           |  46 +++++++-----
 fs/cifs/misc.c                           |   2 +-
 fs/cifs/readdir.c                        |  15 ++--
 fs/cifs/smb1ops.c                        |   6 +-
 fs/cifs/smb2inode.c                      |  10 +--
 fs/cifs/smb2misc.c                       |   1 +
 fs/cifs/smb2ops.c                        | 195
++++++++++++++++++++++++++++++++++++++-----------
 fs/cifs/smb2pdu.c                        |   2 +-
 fs/cifs/smb2pdu.h                        |  49 +++++++++++--
 fs/cifs/smb2proto.h                      |  16 ++--
 fs/cifs/unc.c                            |   4 +-
 fs/cifs/xattr.c                          |  40 +++++-----
 32 files changed, 724 insertions(+), 550 deletions(-)

-- 
Thanks,

Steve
