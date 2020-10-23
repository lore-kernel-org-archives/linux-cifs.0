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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E032C388F9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 06:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6002074A
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 06:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U74SayG8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898398AbgJWGMk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898360AbgJWGMk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Oct 2020 02:12:40 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82693C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 23:12:38 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z2so695755lfr.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 23:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=vXZwIXseQSqFrAFa4/hONQXAiZ2oOBsQUQZ5epYkIgE=;
        b=U74SayG8+yD43d+K5h1iLgyVC8JpyTz0g43mRL8oBXROxuwIzM9CBf6LNZmvYplFq1
         o0yTizHqK1YCBPGF2cpML+aJUEUQ14d2CR66jA5E+qlG3ZI2xoOTzGXati+KvynILRt9
         3Un1rOVzEpp9w/27c9MUc86iz46xGlANbrkiTQo9WSt8vOJdaYRMT9b2pVOGroAkMNsy
         JlmhqRkrSroF4H0aBv1X3P1/xMLmD6K4VmVWoWwoGLFem5INf3Vm66NmD4QLLmFQvkeX
         jYkIs/Fspzc2aX4Qvip3sZLEWptCTeOOrp69elBJkNKiQxml/QF72gJTMN53iveTF90T
         GhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=vXZwIXseQSqFrAFa4/hONQXAiZ2oOBsQUQZ5epYkIgE=;
        b=Im1RlkS6wGy4BD28pzu6e1v+SFeevzJAGFQjLUIdM3JXKjlpb2B1mIY83mTgozcYO1
         bZohONxXYHxp/727TeCq6nVdOGvDGHJbWfg2i1FdgXXWBo/4+4VaEceNuyRY7vKe36jG
         UjR/9+/84FOgQjvis7OmlZPHeA/q5ofJhV6uJ344mJbKiyoHFFKxsRA4axaRpyzOyX91
         NcBSv04A6rjf5n0GihyOINlAjq59UrF2K6mdSaOgxoGpttPhmof6olRYY1EpPGc/s83z
         p8L46H06lDren8ZC/iDUwiuqj0wBYhhqGLDbDCi4U9qtXBrmvyzDVOWpC2+06dLX1UPF
         3Otw==
X-Gm-Message-State: AOAM531BQGol6bMPFRYvvOILjCf9YIGVc+wfnczPk3wPgxSVtBOeO3uX
        5uVCMJKzRkZP4C7CRkG/F65Y8w+ioqGUpfDtmPE=
X-Google-Smtp-Source: ABdhPJyrOE+ldWAL0lXh8oAy8yZJqQBTzZ113W34gLrf9zqn89FbTjcduDoXnLhphS4d5PK7L9vwFtGzdNKQTNAhieA=
X-Received: by 2002:ac2:46e4:: with SMTP id q4mr240826lfo.48.1603433555660;
 Thu, 22 Oct 2020 23:12:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Oct 2020 01:12:24 -0500
Message-ID: <CAH2r5mtL4c-qdrbfUthaMgZYqwyJ0GLmuLwwuwnCHraC+KP9kA@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
57c176074057531b249cf522d90c22313fa74b0b:

  Convert trailing spaces and periods in path components (2020-10-11
23:57:18 -0500)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc-smb3-fixes-part1

for you to fetch changes up to 13909d96c84afd409bf11aa6c8fbcb1efacb12eb:

  SMB3: add support for recognizing WSL reparse tags (2020-10-22 12:17:59 -0500)

----------------------------------------------------------------
30 cifs/smb3 fixes, including five fixes for stable

Other features included:
- add support for recognizing special file types
(char/block/fifo/symlink) for files created by Linux on WSL (a format
we plan to move to as the default for creating special files on Linux,
as it has advantages over the other current option, the SFU format)
in readdir.
- fix double queries to root directory when directory leases not
supported (e.g. Samba)
- fix querying mode bits (modefromsid mount option) for special file types
- stronger encryption (gcm256), disabled by default until tested more broadly
- allows querying owner when server reports "well known SID" on query
dir with SMB3.1.1 POSIX extensions

Unit test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/405

This PR does not include some additional fixes that are still being
tested but should be available soon:
- for querying owner better on stat with SMB3.1.1 posix extensions
- for querying special file types better in getattr
- some additional small gcm 256 (stronger encryption) fixes
- some important multichannel fixes for low crediting scenarios (flow
control issues)
----------------------------------------------------------------
Colin Ian King (1):
      cifs: make const array static, makes object smaller

Dan Carpenter (1):
      cifs: remove bogus debug code

Rohith Surabattula (2):
      Handle STATUS_IO_TIMEOUT gracefully
      SMB3: Resolve data corruption of TCP server info fields

Ronnie Sahlberg (7):
      cifs: return cached_fid from open_shroot
      cifs: compute full_path already in cifs_readdir()
      cifs: handle -EINTR in cifs_setattr
      cifs: add files to host new mount api
      cifs: move security mount options into fs_context.ch
      cifs: move cache mount options to fs_context.ch
      cifs: move smb version mount options into fs_context.c

Samuel Cabrero (1):
      cifs: Print the address and port we are connecting to in
generic_ip_connect()

Shyam Prasad N (1):
      cifs: Return the error from crypt_message when enc/dec key not found.

Stefan Metzmacher (1):
      cifs: map STATUS_ACCOUNT_LOCKED_OUT to -EACCES

Steve French (15):
      smb3: add defines for new crypto algorithms
      update structure definitions from updated protocol documentation
      SMB3.1.1: add defines for new signing negotiate context
      smb3.1.1: add new module load parm require_gcm_256
      smb3.1.1: add new module load parm enable_gcm_256
      smb3.1.1: print warning if server does not support requested
encryption type
      smb3.1.1: rename nonces used for GCM and CCM encryption
      smb3.1.1: set gcm256 when requested
      smb3.1.1: do not fail if no encryption required but server
doesn't support it
      smb3: add dynamic trace point to trace when credits obtained
      SMB3.1.1: Fix ids returned in POSIX query dir
      smb3: fix stat when special device file and mounted with modefromsid
      smb3: do not try to cache root directory if dir leases not supported
      smb3.1.1: fix typo in compression flag
      SMB3: add support for recognizing WSL reparse tags

 fs/cifs/Makefile        |   2 +-
 fs/cifs/asn1.c          |  16 ++--
 fs/cifs/cifsacl.c       |   5 +-
 fs/cifs/cifsfs.c        |   8 ++
 fs/cifs/cifsglob.h      |  16 +---
 fs/cifs/cifsproto.h     |   2 +
 fs/cifs/connect.c       | 264
++++++++---------------------------------------------------------
 fs/cifs/fs_context.c    | 221
++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/fs_context.h    |  58 +++++++++++++++
 fs/cifs/inode.c         |  13 +++-
 fs/cifs/readdir.c       |  60 ++++++++++-----
 fs/cifs/smb2glob.h      |   1 +
 fs/cifs/smb2inode.c     |  11 +--
 fs/cifs/smb2maperror.c  |   4 +-
 fs/cifs/smb2ops.c       |  83 +++++++++++++++------
 fs/cifs/smb2pdu.c       |  53 ++++++++++---
 fs/cifs/smb2pdu.h       |  90 +++++++++++++++++++---
 fs/cifs/smb2proto.h     |   3 +-
 fs/cifs/smb2transport.c |   8

-- 
Thanks,

Steve
