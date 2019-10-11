Return-Path: <SRS0=7m4E=YE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DADC47404
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Oct 2019 20:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCEDC20659
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Oct 2019 20:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S9Y/IZxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfJKUkj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Oct 2019 16:40:39 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:45696 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728976AbfJKUkj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Oct 2019 16:40:39 -0400
Received: by mail-io1-f42.google.com with SMTP id c25so24175515iot.12
        for <linux-cifs@vger.kernel.org>; Fri, 11 Oct 2019 13:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=lNXZEnRIMNmSLJiWUAJd8jmpQMFEguP2CDFA6d0nvJg=;
        b=S9Y/IZxZ2a2L+xtPd7JkAmyHeqNUJoyAv54fVppRx4CC3VPTM86QeQ18P1UWx1vX9l
         qhcix6JTtAK5LPzp3ihEQ9tUOtYclYF73XaBarXR3szTYEDBxQVpCV/t+wOll/7uKZay
         Nw/4zRdjpnZQwGrt3V8cFmmeexNu79dp4x7EOnH2+QAKC7B282RcaaqMUVI/2ihmEyFY
         65y6t7TA6Rbep1fIHcg0k7lxtPr4dB7y6oCvUSELniDloAB/uJM/jRAPWYibwdbtgHSF
         Q7KY6/k6j+ox0ZTcmylOfAKcz0m0R8AduwDstz4RL+QKdc3Erk50MXLHBa2JaTj4TgZL
         am3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=lNXZEnRIMNmSLJiWUAJd8jmpQMFEguP2CDFA6d0nvJg=;
        b=nQlDul6nwaKNrSjPrnCI3DfBWNmkg5PEh0RO6BumeWS1rjdnFmXXHPxKZ4+WrXk5SU
         k4CuCemVTRyMcvBp/tTJWJTCm8O2Pee8Wp1J6GC/rMk+3tLfijZqYkhbPv0wTz7XrMn8
         CG3EPRT0hAJwT9SGiwhiKpeXf9z7Wpep8gUF50YS62djY6qOXeOpeTrj7WXf3sXoiBnK
         Sz2r1Y5CdIXSodaX/5vM3cYvjYdkLGItqsc3jurLL6lA65C9NoIA2Rlu/iqRar+PE6Zt
         qGff2ubR7Xb59fblrwOyD5A6QvI0G3Ydi9gLqCJC86g1zwgD/6x4DwNYIKDuRhz9bv5L
         Levg==
X-Gm-Message-State: APjAAAUNVK7LI9wfEkCROv2JlSRYfO+4UVrAf0evxJ8EGDTJI2XMpGO5
        U1E3OpHuwJCpCxKMuYgFPzSd8gA9txDqM3/TNIf8vntJ
X-Google-Smtp-Source: APXvYqwiD6fJbmim28xM6OKKce+Y7msNSEIQY9nPkFGHzN1p0HzkrExrF1mNFb4LC+zc1RoyHX+e/emK3hNsMy2zv3s=
X-Received: by 2002:a02:cc5b:: with SMTP id i27mr12108660jaq.63.1570826438219;
 Fri, 11 Oct 2019 13:40:38 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Oct 2019 15:40:26 -0500
Message-ID: <CAH2r5mt06W-HjArS-+XMRjuY9FvMrZGWndKn0M8-0tc=jMmG-g@mail.gmail.com>
Subject: [GIT PULL] SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
da0c9ea146cbe92b832f1b0f694840ea8eb33cce:

  Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-rc2-smb3

for you to fetch changes up to 0b3d0ef9840f7be202393ca9116b857f6f793715:

  CIFS: Force reval dentry if LOOKUP_REVAL flag is set (2019-10-09
00:10:50 -0500)

----------------------------------------------------------------
Eight small SMB3 fixes, 4 for stable, and important fix for the recent
regression
introduced by filesystem timestamp range patches.

----------------------------------------------------------------
Austin Kim (1):
      fs: cifs: mute -Wunused-const-variable message

Dave Wysochanski (1):
      cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a panic

Pavel Shilovsky (3):
      CIFS: Gracefully handle QueryInfo errors during open
      CIFS: Force revalidate inode when dentry is stale
      CIFS: Force reval dentry if LOOKUP_REVAL flag is set

Steve French (3):
      smb3: cleanup some recent endian errors spotted by updated sparse
      smb3: remove noisy debug message and minor cleanup
      smb3: Fix regression in time handling

 fs/cifs/cifsfs.c    | 24 ++++++++++++++++--------
 fs/cifs/cifsglob.h  |  2 +-
 fs/cifs/connect.c   |  4 ++--
 fs/cifs/dir.c       |  8 +++++++-
 fs/cifs/file.c      | 33 +++++++++++++++++----------------
 fs/cifs/inode.c     |  4 ++++
 fs/cifs/netmisc.c   |  4 ----
 fs/cifs/smb2pdu.c   | 14 ++++++--------
 fs/cifs/smb2proto.h |  4 ++++
 9 files changed, 57 insertions(+), 40 deletions(-)


-- 
Thanks,

Steve
