Return-Path: <SRS0=rDaF=SF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201ABC4360F
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Apr 2019 18:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1E3520449
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Apr 2019 18:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6pnE2Tj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfDCSEA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Apr 2019 14:04:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36320 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfDCSD7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Apr 2019 14:03:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id z5so7512026pfn.3;
        Wed, 03 Apr 2019 11:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Q9PLwwVzOIDPi/cGX2bBRNrfqlokXfh2QaqRvF0H8kE=;
        b=B6pnE2Tj7LrGboD9n06GciD4cZS1tGg9A8U1zan/ODqIUxs7TslF38ydqkPLz/U2rU
         1JyL2MLf+utgtkeIJSzR2bPIiZyoOiJ9WvjFodBwR8Q4cgZntUQw8qRqDaovWBwJyNhN
         Qq/s18XhSsedcRtsk3wQqOhrs+IuACA2hn2gszptMOkaseLBWQx33/ffmEo6RM+kaH0m
         NzCCFi2x6O2v4pFDjqq7ty1uPMNY+fQPTuKr7ZjiGXJucY6SZMuaN1JYkGKguBL3h1Gf
         jimyNlhId/rN1uft9DIuTedsaNqcOwI1wREIlR/ShHkkqwJfQ4xJNWOsCTGCRuoUNTiT
         ppGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Q9PLwwVzOIDPi/cGX2bBRNrfqlokXfh2QaqRvF0H8kE=;
        b=apeX4TTuc2zG8iI83MioXHyZf+J4c9u94bvgg+9axMdB3B9eCc0vicYVpVJQa/RqgV
         kPeqbfCYnec0V2G9q7WQJpVh0vYCILtzBEBztiFba6g5TukvAKmcTMVD2Z9spfXWT9qz
         nUTcnL4jxKiJSpPfr8VLaMTcIhdYQd9VMNhNZco9kU04y8SLSgHlNj+DGn2gIw9GA/bN
         NDabj6UujKkTKWfDNKA9s6mkzwSpsgBW5hukA7mL9PmgzDjNdCQnQ4ivEzpGYbhiC59H
         4vvg5D3kgabLOI53TO4ifLwxgDjqxisLfRyIikoeu8MNd88KDqDx17tI5+ok8q9XAva1
         5g9g==
X-Gm-Message-State: APjAAAXH33sKpwpgzf5olwEJ21CdyuCc62RhU+NVHGM+NgrQidoKiN9v
        u4IFO/ww7md4e9o4A4lf2lSs/mmbK4a4o27lUyYHnaTe
X-Google-Smtp-Source: APXvYqy/LCaeakEBbGxhp7Vg3XqCtWPy/WXHA5CBk2mF5PqSrqDJnVnKoUQNY77oOJzWHbYc6o5gWvg0XehSwRUeI3M=
X-Received: by 2002:a62:4115:: with SMTP id o21mr782674pfa.153.1554314638671;
 Wed, 03 Apr 2019 11:03:58 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 3 Apr 2019 13:03:47 -0500
Message-ID: <CAH2r5mv70K=Mj7ehKB2iAZc95emcWGYC5eBKOV-1tkD=euyatQ@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
5e7a8ca319268a70a6c7c3c1fde5bea38e1e5539:

  Merge branch 'work.aio' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2019-04-01
08:28:36 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc3-smb3-fixes

for you to fetch changes up to 4811e3096daaa56e145a1d2bec45e2e9fe790729:

  cifs: a smb2_validate_and_copy_iov failure does not mean the handle
is invalid. (2019-04-01 14:33:38 -0500)

----------------------------------------------------------------
four smb3 fixes for stable
- fix an open path where we had an unitialized structure
- fix for snapshot (previous version) enumeration
- allow reconnect timeout on handles to be configurable to better
handle network or server crash

----------------------------------------------------------------
Ronnie Sahlberg (2):
      cifs: fix kref underflow in close_shroot()
      cifs: a smb2_validate_and_copy_iov failure does not mean the
handle is invalid.

Steve French (2):
      smb3: Fix enumerating snapshots to Azure
      SMB3: Allow persistent handle timeout to be configurable on mount

 fs/cifs/cifsfs.c    |  2 ++
 fs/cifs/cifsglob.h  |  8 ++++++++
 fs/cifs/connect.c   | 30 +++++++++++++++++++++++++++++-
 fs/cifs/smb2file.c  |  6 ++++--
 fs/cifs/smb2ops.c   | 68
++++++++++++++++++++++++++++++++++++++++++--------------------------
 fs/cifs/smb2pdu.c   | 49 +++++++++++++++++++++++++++++++++----------------
 fs/cifs/smb2proto.h |  5 +++--
 7 files changed, 121 insertions(+), 47 deletions(-)


-- 
Thanks,

Steve
