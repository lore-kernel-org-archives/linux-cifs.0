Return-Path: <SRS0=TBB8=72=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE9BC433DF
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 20:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452F62078A
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 20:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pugf93PT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgFMUiA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Jun 2020 16:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgFMUiA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Jun 2020 16:38:00 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B15C03E96F;
        Sat, 13 Jun 2020 13:37:58 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id b15so6820237ybg.12;
        Sat, 13 Jun 2020 13:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AZ9uyO5LxI8LoWUZAxFJt6p3px1TqqRJy80ToRtvAhk=;
        b=Pugf93PTICmbMKd8yNKxpurzmuwbv5d2aPXxKBET0NaRWGbZbhQbiXteiLu6PLAgD3
         yZX7Qs1s/7l+mCUlQZW7LQIQaTTfdQ4CZWF3H+cTJuKODUa48o9Q5XUiWM37TfXT6Nxo
         FpoShZPooUFNJZYniWj5ijNYsWe6bZFPL5LpNGPB8A0ANeS45VPURTTz/zYSOsYCKc4s
         oIPbKvyKQrM5LmH0PtDxYBFbGT3ehlUe5n2cS4jEOP+SVuWZKo44Yi90I7gufyxIAMZo
         IJW2jf4JyGdnqD9kPVhqYTEaG/sdQuOY6s0mOpXpcrmKOvusA0ituaM0FgdTfeAKpwrU
         GUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AZ9uyO5LxI8LoWUZAxFJt6p3px1TqqRJy80ToRtvAhk=;
        b=GOYkSJchCqr5lmTq67Ax3kSzjFQ9bTh8Njen3LjihqBKL4iBsQSk6bS/Xp4CQjZAg6
         ulmo7KwZCy8efqLKewbiaeralSpXBEFxoHjNMr+nuItrKl17aQlE8v14nb6WHrdiR+CE
         EJoxl9w5js2fxkuu6MbKQCfvSMimBI7O/GcIL7V9YgjVCPtUhaMQKxZ5kpvABf3ifDbw
         zOcbtmSmU0DFKv1s1eTsnxZJOP78ijNz0ayNhCv3UADnFv8fJKKmAuQJmkhr/eWxe69a
         u27QmJJiLE6dGVNEfXFsf/rfYSZHwvqiL+MrTLHf10mefIE/tGHdFcg28Dz/gn2kSsdc
         faEQ==
X-Gm-Message-State: AOAM532irNJZjwlxmNpLgbqdCmw+1zrgtgF8acjQD2qaobELT+H5Ops6
        H+rzaU7Gx0IT7lk0a6i9aRUzr0QazcCESmKCnRP3NBpzxe0=
X-Google-Smtp-Source: ABdhPJy+xdXBGIW05PTpOS/TGh5pqTgrp2/9g0x3gMwAwaQMr/XjoUbk03eKbvNzco5lqBxc1L5DIAj/J7j5PWPu4Jw=
X-Received: by 2002:a25:6c05:: with SMTP id h5mr19160146ybc.14.1592080676955;
 Sat, 13 Jun 2020 13:37:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 13 Jun 2020 15:37:46 -0500
Message-ID: <CAH2r5msmGMLzqcLvr4M_qUKQRqeozPe_SZZs7eZtwpRr1wp1Qg@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
3803d5e4d3ce2600ffddc16a1999798bc719042d:

  Merge tag '5.8-rc-smb3-fixes-part-1' of
git://git.samba.org/sfrench/cifs-2.6 (2020-06-05 16:40:53 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc-smb3-fixes-part2

for you to fetch changes up to a7a519a4926214ba4161bc30109f4a8d69defb8d:

  smb3: Add debug message for new file creation with idsfromsid mount
option (2020-06-12 16:31:06 -0500)

----------------------------------------------------------------
12 cifs/smb3 fixes, 2 for stable. Adds support for idsfromsid on
create and also for chgrp/chown allowing ability to save owner
information more naturally for some workloads. Improves getattr when
SMB3.1.1 posix extensions are negotiated by using new query info
level.

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/357
----------------------------------------------------------------
Kenneth D'souza (1):
      cifs: Add get_security_type_str function to return sec type.

Namjae Jeon (1):
      smb3: add indatalen that can be a non-zero value to calculation
of credit charge in smb2 ioctl

Steve French (10):
      smb3: extend fscache mount volume coherency check
      smb3: fix typo in mount options displayed in /proc/mounts
      SMB311: Add support for query info using posix extensions (level 100)
      smb311: Add support for SMB311 query info (non-compounded)
      smb311: Add support for lookup with posix extensions query info
      smb311: add support for using info level for posix extensions query
      smb311: Add tracepoints for new compound posix query info
      smb3: allow uid and gid owners to be set on create with
idsfromsid mount option
      cifs: fix chown and chgrp when idsfromsid mount option enabled
      smb3: Add debug message for new file creation with idsfromsid mount option

 fs/cifs/cache.c      |   9 +---
 fs/cifs/cifs_debug.c |   4 +-
 fs/cifs/cifsacl.c    |  79 ++++++++++++++++++++++++------
 fs/cifs/cifsacl.h    |  15 ++++++
 fs/cifs/cifsfs.c     |   2 +-
 fs/cifs/cifsglob.h   |  18 +++++++
 fs/cifs/cifsproto.h  |   3 ++
 fs/cifs/dir.c        |   5 +-
 fs/cifs/file.c       |   5 +-
 fs/cifs/fscache.c    |  17 ++++++-
 fs/cifs/fscache.h    |   9 ++++
 fs/cifs/inode.c      | 185
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/link.c       |   4 +-
 fs/cifs/smb2glob.h   |   1 +
 fs/cifs/smb2inode.c  | 105 ++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c    | 131 ++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/smb2pdu.h    |  27 ++++++++++-
 fs/cifs/smb2proto.h  |   6 +++
 fs/cifs/trace.h      |   3 ++
 19 files changed, 571 insertions(+), 57 deletions(-)


--
Thanks,

Steve
