Return-Path: <SRS0=CJ3z=R3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BC1C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Mar 2019 03:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8383A2148D
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Mar 2019 03:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WjqjT6xo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbfCXDWp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Mar 2019 23:22:45 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35928 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbfCXDWp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Mar 2019 23:22:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id r124so4109478pgr.3;
        Sat, 23 Mar 2019 20:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=KO+3rvZu/kJfj/ArLqPP1z8RXrglHfj3nXMZ+AJWNh8=;
        b=WjqjT6xoLUZV35C0NkXHCjFaGwwr8FlCKSn6teO+PNaVFTSzk9O+pvGhKmmsnLZHQW
         UWF146hrPJrQPcJKUVVlJ7GE5fsLo2Vg7LNHliuZv+PSndyr02okWp45QvVqa6gZvZHF
         lI1FK9TB8V6kG7Yz/0fzGB+O7o7GcyGUz9jrhQlOuE3M/VMeCKzbzymUBOpQyZ010BQ6
         2aQbZLydhdQdbQdMYO64qKS9ayZfGJgIZkko9WaD4K6wvEcSRGF/eieU/O01rw7+K7Am
         SgInD3hxcOf2zgCIG8ahFsxNukde1k+EsFNSOZxESAk9Uel7kedz5Q7J9L/A8bFV9LTl
         C0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KO+3rvZu/kJfj/ArLqPP1z8RXrglHfj3nXMZ+AJWNh8=;
        b=tf6Ah5QQK+qbsM+cpmD98+QaOapL3VWVg5e4Dh8ctK5XjJiWjeqgsDdynfJ4O3ND/R
         r0r7I3TLfo/hxOGqbHZZubn5juxvhPcYlVw8pLyMl6QngBiMgy1uqfAzAd+oUMy62eRT
         6kyD1goWt2KzHWsodosiLtbzXgFiNNAJ3LJN5CxLnWIDzQ5XnsmZun2+1f7yACEtANeT
         q2C7hE2Yg9ZGiwg0kpGEZYPbozAXB7hheNAWWwnL3HdS0zLWdDM9F5viDvWO/gBTqvLJ
         MtTa6izT6WLfGHwH9ndRNM4uKJ9364sfXdFwwTv+J8ja537s1SB1kDT3NPb6CpX6qYXR
         HaOQ==
X-Gm-Message-State: APjAAAVe+y4CYuvpnevU1KLyARFCVguhvqLVqP9vI3/BaZQ053aXLBhe
        +H1ATuAMY+pcf1D9vP8HSlVy9rphZ3XMEOkSmCSkbrng
X-Google-Smtp-Source: APXvYqzOfApq2XBol34V2Dg8ptjvEy1YZPODuxOuRXeghbAsiY7wGgIAUaGh11r2sgsDzChjY2mokFauNwffCAAoQ4o=
X-Received: by 2002:a17:902:2b8b:: with SMTP id l11mr18529399plb.18.1553397764632;
 Sat, 23 Mar 2019 20:22:44 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 23 Mar 2019 22:22:33 -0500
Message-ID: <CAH2r5musNnYwS04DgN5W8yZMDvZG1UhLraOo_qsRjA8nVudacA@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
a5ed1e96cafde5ba48638f486bfca0685dc6ddc9:

  Merge tag 'powerpc-5.1-3' of
git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
(2019-03-22 14:15:11 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc1-cifs-smb3-fixes

for you to fetch changes up to cf7d624f8dcc9b833a8489208b6ef6dcc5dd308b:

  cifs: update internal module version number (2019-03-22 22:43:04 -0500)

----------------------------------------------------------------
- two fixes for stable for guest mount problems with smb3.1.1
- two fixes for crediting (SMB3 flow control) on resent requests
- a byte range lock leak fix
- two fixes for incorrect rc mappings
----------------------------------------------------------------
Long Li (2):
      CIFS: Fix an issue with re-sending wdata when transport returning -EAGAIN
      CIFS: Fix an issue with re-sending rdata when transport returning -EAGAIN

Paulo Alcantara (SUSE) (1):
      cifs: Fix slab-out-of-bounds when tracing SMB tcon

Ronnie Sahlberg (1):
      cifs: allow guest mounts to work for smb3.11

Steve French (3):
      fix incorrect error code mapping for OBJECTID_NOT_FOUND
      SMB3: Fix SMB3.1.1 guest mounts to Samba
      cifs: update internal module version number

Xiaoli Feng (1):
      cifs: fix that return -EINVAL when do dedupe operation

 fs/cifs/cifsfs.c       |   2 +-
 fs/cifs/cifsfs.h       |   2 +-
 fs/cifs/file.c         | 148
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 fs/cifs/smb2maperror.c |   3 ++-
 fs/cifs/smb2pdu.c      |  11 +++++++--
 fs/cifs/trace.h        |   6 ++---
 6 files changed, 102 insertions(+), 70 deletions(-)


-- 
Thanks,

Steve
