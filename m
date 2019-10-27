Return-Path: <SRS0=GKCu=YU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372CBCA9EB9
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Oct 2019 02:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5C872084C
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Oct 2019 02:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VbU7oAzv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfJ0CkQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Oct 2019 22:40:16 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:41129 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfJ0CkQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Oct 2019 22:40:16 -0400
Received: by mail-io1-f54.google.com with SMTP id r144so6697622iod.8;
        Sat, 26 Oct 2019 19:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=k/SkguEWaR/BIMPX1syQDkkBF8ZHQnrk1Gdqi+rYaB4=;
        b=VbU7oAzvjZwyxmW163U/fWdn0Y6JI/NlubyNMrwpu+SN6bd2fQ9gbVvUN1fPq0Xa9E
         lwEHqG9C3ST19ksAKAM8Rs45ggi+/TXADWb1rRz9vNeq6ckFYEJJhNio5URbKAij+OdA
         Uv5T2Q7BZL+NdLp30Yy8ktiukMc/fpCF7yq9a6S0dTNYR8zpXt7q0Eva0u4OGiOpBKtG
         fVZX14edBYQFL9M887QmQSE27EApJY/bCBVM0AzwOwHb8p1nsS0NKt2j3dQZyeCoUEIz
         0CghMftsZb0+ux7q7417ghjZGa1AfUhjcSjZ8UNnlEA5t6ag/T/OOl7cFtHFL8zQlXey
         kmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=k/SkguEWaR/BIMPX1syQDkkBF8ZHQnrk1Gdqi+rYaB4=;
        b=qmEeenYHhFO5KyguldcYPMPj7TYfwdv99IhB0pKPFP8RF0iO3oZBtP8MnJxV3Xqcp6
         BpmDjI5jYrqVs6YbHa4pSXJA+AFtoi8UX9FeDw6H9YJ3f7yNrT5ssM7n14uyvaS7X2d3
         JkcXOfCG6LB4obl3gvYqjNSAzqx6rp3+L33SCgcIKCkqVhCHoKnqoQDLv8JwQX1gcund
         pemQYh6cgJ0inoFYd4ze1fyryu/Pl9KPJXyDmlxZbEjdVKIJXXOHoalXLhd9+gngt6vd
         rYKN637Olcrx3JyAKNz4+xpl3arTUoF3nZza5p3kBitM7hEXVHToYZpPnC+n8fyffAJc
         E0Wg==
X-Gm-Message-State: APjAAAXyDwF7ds2/9eQllsriNuyPnKG2lrUnfWU/NUQSNYOuy+pGuIq7
        DaOta4HTz7Q0IMgQKxSklFyRcd4JEwjgOZwDmLN3AUyN9cY=
X-Google-Smtp-Source: APXvYqzzEzmyB7bzYEy6JjOC4LLFcsbk84Iz2RfJ63ncpDyQZ8Vel0i4F7P8NTHDLaIdix2o4K2i12xuMOZfz4w0tNM=
X-Received: by 2002:a6b:fa12:: with SMTP id p18mr2747637ioh.272.1572144015245;
 Sat, 26 Oct 2019 19:40:15 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 26 Oct 2019 21:40:04 -0500
Message-ID: <CAH2r5muwqB-D9=2ZxBkT-T77PkjAHh4TPpsr9vsDZD5nmu9jyw@mail.gmail.com>
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
7d194c2100ad2a6dded545887d02754948ca5241:

  Linux 5.4-rc4 (2019-10-20 15:56:22 -0400)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-rc5-smb3-fixes

for you to fetch changes up to d46b0da7a33dd8c99d969834f682267a45444ab3:

  cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs
(2019-10-24 21:35:04 -0500)

----------------------------------------------------------------
Seven small cifs/smb3 fixes, including three for stable

Buildbot regression test run:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/272
----------------------------------------------------------------
Chuhong Yuan (1):
      cifs: Fix missed free operations

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Paulo Alcantara (SUSE) (1):
      cifs: Handle -EINPROGRESS only when noblockcnt is set

Pavel Shilovsky (2):
      CIFS: Fix retry mid list corruption on reconnects
      CIFS: Fix use after free of file info structures

Roberto Bergantinos Corpas (1):
      CIFS: avoid using MID 0xFFFF

Steve French (1):
      cifs: clarify comment about timestamp granularity for old servers

 fs/cifs/cifsfs.c    |  8 +++++++-
 fs/cifs/cifsglob.h  |  5 +++++
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/connect.c   | 18 +++++++++++++++---
 fs/cifs/file.c      | 29 ++++++++++++++++++-----------
 fs/cifs/inode.c     |  4 ++--
 fs/cifs/smb1ops.c   |  3 +++
 fs/cifs/smb2file.c  |  2 +-
 fs/cifs/transport.c | 42 +++++++++++++++++++++++-------------------
 9 files changed, 75 insertions(+), 37 deletions(-)


-- 
Thanks,

Steve
