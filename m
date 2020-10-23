Return-Path: <SRS0=9U06=D6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F530C388F9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 06:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C7F2074A
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 06:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vJE5btev"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372238AbgJWGM1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898360AbgJWGM1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Oct 2020 02:12:27 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7928C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 23:12:26 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id 184so677875lfd.6
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 23:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0TvMC9T/hpKSnQp9mYBqTCNAwXVo54jXejZpr2xRB0=;
        b=vJE5btevfIVYOS/DEubTrxYxRvDAAIqCrOpu/owBW3OKSlap3z0GBBY7zPeYZwLG7c
         9cbRKO85Rz/tdO3JOO8OhAOBTzYXhnZbjQ2J+mnbjlzXHPY19q26fX2Nqb1ZtkTP0GQs
         4lr6qLSYSoGW1UkqsQEbQ+5+bCO64RoxYje07NnSi/tcnB450ADG8qIHMIDAOFEERhzv
         +r+qxNpWmbDfA8qJ75f7Hc7HZEg8Nn1Kv08nJBchFoPCsUvyGyfGlD/njjZD4UdsBydu
         4me76Ou8lwxb689i0VwPveG0211QFrleDfIPamle9ykQEzpKJ9vjBNuC1bknfmeEX+/o
         eTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0TvMC9T/hpKSnQp9mYBqTCNAwXVo54jXejZpr2xRB0=;
        b=ggGDp0R9D14loh1kUtDjQpkTUTVYh0wo+sevUZi0xFFQIvD1k0xBXthX1NynIQI/01
         f3o0LP6EThW7bYEGJi0dREC6J9v3mpM22Wb9xNQEOToezbezZ4G7ZImwQBKZFczp23qh
         v1eMZJYrIWbmTPhZg7NuaUbfQ7uUs1XKMOV9+yEThJRizdX4Ab2MQk96QRUh12syd+/z
         HEvl22ObdqEjjCrgbTS4cEphC//5Nwpni/aEAASo9VF/4rXnoQ0k5GYYbQ66EUcusmjr
         wiwJR6KltAcZK2RNSZamyoIta5qkMH8qwXBOBVf6AgbLOlwdsKX6Xw5c+8eDixUcF4X/
         oMnA==
X-Gm-Message-State: AOAM5337Iw8luky+ZcZXDUzlIQctTl1x2SOq5FaJneYQWqB+JxClzBWN
        e0EtmgNqYUQNaRlSlshM0YmqW5scayVbsx2mU3sj1RXO0kM=
X-Google-Smtp-Source: ABdhPJzbTNlZVcnpJU6JJeM457X1tdlw8njJyppAZpwX6P3bPb7Y/IPPT0gQ+o7h+e3AbiB3vYXW4P2Wh6ZWWM2+etY=
X-Received: by 2002:a19:c381:: with SMTP id t123mr187612lff.499.1603433545155;
 Thu, 22 Oct 2020 23:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvcYcC19PN4aNXjkDyPsAQ8wgnK-p2ikvhm_zVfTHsF+A@mail.gmail.com>
In-Reply-To: <CAH2r5mvcYcC19PN4aNXjkDyPsAQ8wgnK-p2ikvhm_zVfTHsF+A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Oct 2020 01:12:14 -0500
Message-ID: <CAH2r5mtpCkH7zb8Q=is3a_fwqkswkcnJJ5XJVss10t_sa7KA9g@mail.gmail.com>
Subject: Re: [GIT PULL] cifs/smb3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like a cut-n-paste error (double paste).  Will resend the pull request

On Fri, Oct 23, 2020 at 12:09 AM Steve French <smfrench@gmail.com> wrote:
>
> Please pull the following changes since commit
> 57c176074057531b249cf522d90c22313fa74b0b:
>
>   Convert trailing spaces and periods in path components (2020-10-11
> 23:57:18 -0500)
>
> are available in the Git repository at:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc-smb3-fixes-part1
>
> for you to fetch changes up to 13909d96c84afd409bf11aa6c8fbcb1efacb12eb:
>
>   SMB3: add support for recognizing WSL reparse tags (2020-10-22 12:17:59 -0500)
>
> ----------------------------------------------------------------
> 30 cifs/smb3 fixes, including five fixes for stable
>
> Other features included:
> - add support for recognizing special file types
> (char/block/fifo/symlink) for files created by Linux on WSL (a format
> we plan to move to as the default for creating special files on Linux,
> as it has advantages over the other current option, the SFU format)
> in readdir.
> - fix double queries to root directory when directory leases not
> supported (e.g. Samba)
> - fix querying mode bits (modefromsid mount option) for special file types
> - stronger encryption (gcm256), disabled by default until tested more broadly
> - allows querying owner when server reports "well known SID" on query
> dir with SMB3.1.1 POSIX extensions
>
> Unit test results:
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/405
>
> This PR does not include some additional fixes that are still being
> tested but should be available soon:
> - for querying owner better on stat with SMB3.1.1 posix extensions
> - for querying special file types better in getattr
> - some additional small gcm 256 (stronger encryption) fixes
> - some important multichannel fixes for low crediting scenarios (flow
> control issues)
> ----------------------------------------------------------------
> Colin Ian King (1):
>       cifs: make const array static, makes object smaller
>
> Dan Carpenter (1):
>       cifs: remove bogus debug code
>
> Rohith Surabattula (2):
>       Handle STATUS_IO_TIMEOUT gracefully
>       SMB3: Resolve data corruption of TCP server info fields
>
> Ronnie Sahlberg (7):
>       cifs: return cached_fid from open_shroot
>       cifs: compute full_path already in cifs_readdir()
>       cifs: handle -EINTR in cifs_setattr
>       cifs: add files to host new mount api
>       cifs: move security mount options into fs_context.ch
>       cifs: move cache mount options to fs_context.ch
>       cifs: move smb version mount options into fs_context.c
>
> Samuel Cabrero (1):
>       cifs: Print the address and port we are connecting to in
> generic_ip_connect()
>
> Shyam Prasad N (1):
>       cifs: Return the error from crypt_message when enc/dec key not found.
>
> Stefan Metzmacher (1):
>       cifs: map STATUS_ACCOUNT_LOCKED_OUT to -EACCES
>
> Steve French (15):
>       smb3: add defines for new crypto algorithms
>       update structure definitions from updated protocol documentation
>       SMB3.1.1: add defines for new signing negotiate context
>       smb3.1.1: add new module load parm require_gcm_256
>       smb3.1.1: add new module load parm enable_gcm_256
>       smb3.1.1: print warning if server does not support requested
> encryption type
>       smb3.1.1: rename nonces used for GCM and CCM encryption
>       smb3.1.1: set gcm256 when requested
>       smb3.1.1: do not fail if no encryption required but server
> doesn't support it
>       smb3: add dynamic trace point to trace when credits obtained
>       SMB3.1.1: Fix ids returned in POSIX query dir
>       smb3: fix stat when special device file and mounted with modefromsid
>       smb3: do not try to cache root directory if dir leases not supported
>       smb3.1.1: fix typo in compression flag
>       SMB3: add support for recognizing WSL reparse tags
>
>  fs/cifs/Makefile        |   2 +-
>  fs/cifs/asn1.c          |  16 ++--
>  fs/cifs/cifsacl.c       |   5 +-
>  fs/cifs/cifsfs.c        |   8 ++
>  fs/cifs/cifsglob.h      |  16 +---
>  fs/cifs/cifsproto.h     |   2 +
>  fs/cifs/connect.c       | 264
> ++++++++---------------------------------------------------------
>  fs/cifs/fs_context.c    | 221
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/fs_context.h    |  58 +++++++++++++++
>  fs/cifs/inode.c         |  13 +++-
>  fs/cifs/readdir.c       |  60 ++++++++++-----
>  fs/cifs/smb2glob.h      |   1 +
>  fs/cifs/smb2inode.c     |  11 +--
>  fs/cifs/smb2maperror.c  |   4 +-
>  fs/cifs/smb2ops.c       |  83 +++++++++++++++------
>  fs/cifs/smb2pdu.c       |  53 ++++++++++---
>  fs/cifs/smb2pdu.h       |  90 +++++++++++++++++++---
>  fs/cifs/smb2proto.h     |   3 +-
>  fs/cifs/smb2transport.c |   8 The following changes since commit
> 57c176074057531b249cf522d90c22313fa74b0b:
>
>   Convert trailing spaces and periods in path components (2020-10-11
> 23:57:18 -0500)
>
> are available in the Git repository at:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc-smb3-fixes-part1
>
> for you to fetch changes up to 13909d96c84afd409bf11aa6c8fbcb1efacb12eb:
>
>   SMB3: add support for recognizing WSL reparse tags (2020-10-22 12:17:59 -0500)
>
> ----------------------------------------------------------------
> 30 cifs/smb3 fixes, including five for stable
>
> ----------------------------------------------------------------
> Colin Ian King (1):
>       cifs: make const array static, makes object smaller
>
> Dan Carpenter (1):
>       cifs: remove bogus debug code
>
> Rohith Surabattula (2):
>       Handle STATUS_IO_TIMEOUT gracefully
>       SMB3: Resolve data corruption of TCP server info fields
>
> Ronnie Sahlberg (7):
>       cifs: return cached_fid from open_shroot
>       cifs: compute full_path already in cifs_readdir()
>       cifs: handle -EINTR in cifs_setattr
>       cifs: add files to host new mount api
>       cifs: move security mount options into fs_context.ch
>       cifs: move cache mount options to fs_context.ch
>       cifs: move smb version mount options into fs_context.c
>
> Samuel Cabrero (1):
>       cifs: Print the address and port we are connecting to in
> generic_ip_connect()
>
> Shyam Prasad N (1):
>       cifs: Return the error from crypt_message when enc/dec key not found.
>
> Stefan Metzmacher (1):
>       cifs: map STATUS_ACCOUNT_LOCKED_OUT to -EACCES
>
> Steve French (15):
>       smb3: add defines for new crypto algorithms
>       update structure definitions from updated protocol documentation
>       SMB3.1.1: add defines for new signing negotiate context
>       smb3.1.1: add new module load parm require_gcm_256
>       smb3.1.1: add new module load parm enable_gcm_256
>       smb3.1.1: print warning if server does not support requested
> encryption type
>       smb3.1.1: rename nonces used for GCM and CCM encryption
>       smb3.1.1: set gcm256 when requested
>       smb3.1.1: do not fail if no encryption required but server
> doesn't support it
>       smb3: add dynamic trace point to trace when credits obtained
>       SMB3.1.1: Fix ids returned in POSIX query dir
>       smb3: fix stat when special device file and mounted with modefromsid
>       smb3: do not try to cache root directory if dir leases not supported
>       smb3.1.1: fix typo in compression flag
>       SMB3: add support for recognizing WSL reparse tags
>
>  fs/cifs/Makefile        |   2 +-
>  fs/cifs/asn1.c          |  16 ++--
>  fs/cifs/cifsacl.c       |   5 +-
>  fs/cifs/cifsfs.c        |   8 ++
>  fs/cifs/cifsglob.h      |  16 +---
>  fs/cifs/cifsproto.h     |   2 +
>  fs/cifs/connect.c       | 264
> ++++++++---------------------------------------------------------
>  fs/cifs/fs_context.c    | 221
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/fs_context.h    |  58 +++++++++++++++
>  fs/cifs/inode.c         |  13 +++-
>  fs/cifs/readdir.c       |  60 ++++++++++-----
>  fs/cifs/smb2glob.h      |   1 +
>  fs/cifs/smb2inode.c     |  11 +--
>  fs/cifs/smb2maperror.c  |   4 +-
>  fs/cifs/smb2ops.c       |  83 +++++++++++++++------
>  fs/cifs/smb2pdu.c       |  53 ++++++++++---
>  fs/cifs/smb2pdu.h       |  90 +++++++++++++++++++---
>  fs/cifs/smb2proto.h     |   3 +-
>  fs/cifs/smb2transport.c |   8 +-
>  fs/cifs/trace.h         |  18 +++--
>  fs/cifs/transport.c     |   5 +-
>  21 files changed, 600 insertions(+), 341 deletions(-)
>  create mode 100644 fs/cifs/fs_context.c
>  create mode 100644 fs/cifs/fs_context.h+-
>  fs/cifs/trace.h         |  18 +++--
>  fs/cifs/transport.c     |   5 +-
>  21 files changed, 600 insertions(+), 341 deletions(-)
>  create mode 100644 fs/cifs/fs_context.c
>  create mode 100644 fs/cifs/fs_context.h
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
