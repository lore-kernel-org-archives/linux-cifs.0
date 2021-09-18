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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB75C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 19:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEFA2610A5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 19:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhIRT4V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 15:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbhIRT4U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 15:56:20 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C650C061574;
        Sat, 18 Sep 2021 12:54:56 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id m3so45837105lfu.2;
        Sat, 18 Sep 2021 12:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RrZB+Ei2lfCoA9/8bU/K4ZBMW+6oktVNxlMUCKhSnJw=;
        b=cj5WphHQWjdPD5jH2xweJaJEmIwfmEZYZna4hcZjiqAk6aLILYFVCm//5AOmVHQHLr
         7uS6bSF1KCTP9Q2mqUCgErPmm3hLJD1kDbo05KDFDJVbbwNF3KsseT50Wm+HwEFB/3ut
         oQTydKdGJKjYjtkJRnmZqyL7F0U0hBq6AEilc0bg2qOMTACPdVUGB6bQprN9qQJWXpda
         3wKbtyoeKnfK6LgHBmq1iq76iOrrzApBrZQBGFrLBirRIDeCdoI7HZHmVCDC7p0vq79s
         p3WxKE9G4zSbih6X1ThDMzJRd6dOyDSgudJvkqRmxjicklrkFsIOs703NXUQxToUP6de
         snUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RrZB+Ei2lfCoA9/8bU/K4ZBMW+6oktVNxlMUCKhSnJw=;
        b=dCEp1q7i161DY0LW8kCCX64MNSXOAXoszOTlAArHfUeixXNM/+WC1o7Lo+UgdWWyGr
         mpEmSn6zPemSFtJs+Vrl1ynaQh8wavuyKFDgksIsL2yagVBd6aDaINRVpzHdoyscD01y
         7MYZjkmI4QVfLOzYpdZYBk1OPR8NYKzH6ssN7X6ihfAHiHOqia8GMmIgnqVdm6o4kGly
         Ubmo/QCrcqKJPnkwRK9ep9HSOVzBrx6Bm0xhItQgT2wgfyWxyLWBFLNUD42omFTJHG2z
         Ho2HR/j2ucqjwDY8h0R6MqejsqpSh+fWfdsypFGtrK1TciFM0jKGiHsmdxKF8JVsfO9p
         8WAg==
X-Gm-Message-State: AOAM530CHwgBzVcLau1gbW1wDGufwO1YiXO7NhN1uZjwgYZcVkVuGAGD
        IQRGLnD3x1Yw1xFE5+ldLGO2/RxB0GG2NcFbIknSuMY/Fe0=
X-Google-Smtp-Source: ABdhPJzFt5wHGmmcTU2ckoJwQMcWP1OMhoYl70SRM8RJDbmn64fvL7+8svEq7e+1DMWzyISHAotD8hhFSxFNVhSNfbw=
X-Received: by 2002:ac2:4206:: with SMTP id y6mr13133100lfh.234.1631994894592;
 Sat, 18 Sep 2021 12:54:54 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 18 Sep 2021 14:54:43 -0500
Message-ID: <CAH2r5mtYiadLYKVhkBFo9=a9+y0BK2z20r7dNGrdvRkyzXYJHA@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc1-smb3

for you to fetch changes up to 35866f3f779aef5e7ba84e4d1023fe2e2a0e219e:

  cifs: Not to defer close on file when lock is set (2021-09-17 16:59:41 -0500)

----------------------------------------------------------------
5 cifs/smb3 client fixes:
 - two deferred close fixes (for bugs found with xfstests 478 and 461)
 - a deferred close improvement in rename
- two trivial fixes for incorrect Linux comment formatting of multiple
cifs files (pointed out by automated kernel test robot and checkpatch)

There is one additional deferred close fix and some important
multichannel fixes that are still being reviewed/tested that are not
included in this.
----------------------------------------------------------------
Rohith Surabattula (3):
      cifs: Deferred close performance improvements
      cifs: Fix soft lockup during fsstress
      cifs: Not to defer close on file when lock is set

Steve French (2):
      cifs: remove pathname for file from SPDX header
      cifs: fix incorrect kernel doc comments

 fs/cifs/cache.c                      |  2 +-
 fs/cifs/cifs_debug.c                 |  1 -
 fs/cifs/cifs_fs_sb.h                 |  1 -
 fs/cifs/cifs_ioctl.h                 |  1 -
 fs/cifs/cifs_spnego.c                |  2 +-
 fs/cifs/cifs_spnego.h                |  2 +-
 fs/cifs/cifs_unicode.c               |  1 -
 fs/cifs/cifsacl.c                    |  1 -
 fs/cifs/cifsacl.h                    |  1 -
 fs/cifs/cifsencrypt.c                |  1 -
 fs/cifs/cifsfs.c                     |  1 -
 fs/cifs/cifsfs.h                     |  1 -
 fs/cifs/cifsglob.h                   |  2 +-
 fs/cifs/cifspdu.h                    |  1 -
 fs/cifs/cifsproto.h                  |  4 +++-
 fs/cifs/cifssmb.c                    |  1 -
 fs/cifs/connect.c                    | 13 ++++++++---
 fs/cifs/dir.c                        |  1 -
 fs/cifs/dns_resolve.c                |  1 -
 fs/cifs/dns_resolve.h                |  4 ++--
 fs/cifs/export.c                     |  1 -
 fs/cifs/file.c                       |  3 ++-
 fs/cifs/fscache.c                    |  2 +-
 fs/cifs/fscache.h                    |  2 +-
 fs/cifs/inode.c                      |  7 +++---
 fs/cifs/ioctl.c                      |  3 +--
 fs/cifs/link.c                       |  1 -
 fs/cifs/misc.c                       | 42 +++++++++++++++++++++++++++++++++---
 fs/cifs/netmisc.c                    |  1 -
 fs/cifs/ntlmssp.h                    |  1 -
 fs/cifs/readdir.c                    |  1 -
 fs/cifs/rfc1002pdu.h                 |  1 -
 fs/cifs/sess.c                       |  1 -
 fs/cifs/smb2file.c                   |  1 -
 fs/cifs/smb2glob.h                   |  1 -
 fs/cifs/smb2inode.c                  |  1 -
 fs/cifs/smb2misc.c                   |  1 -
 fs/cifs/smb2pdu.c                    |  1 -
 fs/cifs/smb2pdu.h                    |  1 -
 fs/cifs/smb2proto.h                  |  1 -
 fs/cifs/smb2status.h                 |  1 -
 fs/cifs/smb2transport.c              |  1 -
 fs/cifs/smberr.h                     |  1 -
 fs/cifs/transport.c                  |  1 -
 fs/cifs/winucase.c                   |  1 -
 fs/cifs/xattr.c                      |  1 -
 fs/smbfs_common/smbfsctl.h           |  2 +-
 include/uapi/linux/cifs/cifs_mount.h |  1 -
 48 files changed, 67 insertions(+), 57 deletions(-)
-- 
Thanks,

Steve
