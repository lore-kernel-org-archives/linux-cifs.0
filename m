Return-Path: <SRS0=Gt6D=5Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBBDC43331
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Mar 2020 19:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77CC1212CC
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Mar 2020 19:14:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VoZW0Ohr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgCaTOZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Mar 2020 15:14:25 -0400
Received: from mail-yb1-f180.google.com ([209.85.219.180]:39565 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbgCaTOZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Mar 2020 15:14:25 -0400
Received: by mail-yb1-f180.google.com with SMTP id h205so11773866ybg.6;
        Tue, 31 Mar 2020 12:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qEDQkHPLeBjag5KrgzUdu+CV9F3+/HfTUuhFRdIMiU8=;
        b=VoZW0OhrOUJypx7IZ0N+lU+bliNakfobVwM0U2ksJKEy1x9ZuTibdPUG42nUJsu6iY
         xjJTAwT3JpcRTu61uNvs9jPt6E0OF4F1fxy92q4CwaTUvB0CqC/wnsWh53DN8ibJ66Ds
         vL5VTQvx9qQfdgI8BFv8sfcALsnj20M7lYc7KvcgbfIxWLvwrczyQ65mtv8TuFEFqQl5
         BB/q8zLQ890ksZO/WhemyExMkZy3UrBpMsLLvfONyOvjLoheqgbOPa6Wsq6ms5Pz8GpC
         cAzMcEYRx2CBY1zNy+5qg6iFiyxoQw3rRbJL6QK/kn7croWheAXXWsGmuTmJchwrRWcr
         2Q5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qEDQkHPLeBjag5KrgzUdu+CV9F3+/HfTUuhFRdIMiU8=;
        b=dWLd4WybBBsLfxYX00V1VeirvXwrD1HnmuOecRvlg1NmcFkMD3EM+lzMXKyvmA0DEA
         2gd1YRMMT83mq1d5KyZyx3dI66EFKk2yaV0KPSDubTLtHJSvR8Masg+hHivFpF5xZpq2
         lY7YePK/uwOB6T9vjjQYBnoxsL6dTxFgRlg8fZfoZTV8lltztDj+aCPSr1iqK8YQyrLH
         KPGX1Y+N06+ynNCnDyZwIKe4qpWQcf1TZnvgaJHUh5qzvA94sJevmRktpm+1kgBPzjRI
         xrYREpRrMnzLiC1KH5r2FRQYXRXdTO/8RZFQn804s/EL/DYl1QNMLuWPTo2Ea13VfqfV
         3JxA==
X-Gm-Message-State: ANhLgQ0j1i/xc5SO2NQGPC1q4HNgYUlL1o0fF9SwmRaPaFnpIvzwsU7r
        5dre/9Gp6bFSC3c6D7uqaGBRRw8FPx9/ds5gg3ZcC0GMbxg=
X-Google-Smtp-Source: ADFU+vtWYKu1OKNo3VQrkMEO/7Fo0D36iG67fekBFRPy1in75HUQK1e/OBtUSQjWm3JccVll9FnFmUgP9TFQDpenpao=
X-Received: by 2002:a25:b794:: with SMTP id n20mr10278700ybh.14.1585682063469;
 Tue, 31 Mar 2020 12:14:23 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Mar 2020 14:14:12 -0500
Message-ID: <CAH2r5mud02mFz6HKUZwfWnQ6ZwdRWPgrjeemXG1Zhvas7zjeQQ@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
16fbf79b0f83bc752cee8589279f1ebfe57b3b6e:

  Linux 5.6-rc7 (2020-03-22 18:31:56 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc-smb3-fixes-part1

for you to fetch changes up to f460c502747305258ccc8a028adfa55e2c9d2435:

  cifs: update internal module version number (2020-03-29 16:59:31 -0500)

----------------------------------------------------------------
First part of cifs/smb3 changes for merge window (others are still being tested)

- Addition of SMB3.1.1 POSIX support in readdir
- Fixes
    -  various RDMA (smbdirect) fixes,
    -  fix for flock
    - fallocate fix
    - some improved mount warnings
    - two timestamp related fixes
    - reconnect fix
    - 3 fixes for stable

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/338
----------------------------------------------------------------
Aurelien Aptel (4):
      cifs: rename posix create rsp
      cifs: add smb2 POSIX info level
      cifs: plumb smb2 POSIX dir enumeration
      cifs: add SMB2_open() arg to return POSIX data

Eric Biggers (1):
      cifs: clear PF_MEMALLOC before exiting demultiplex thread

Gustavo A. R. Silva (2):
      cifs: cifspdu.h: Replace zero-length array with flexible-array member
      cifs: smb2pdu.h: Replace zero-length array with flexible-array member

Long Li (3):
      cifs: smbd: Calculate the correct maximum packet size for
segmented SMBDirect send/receive
      cifs: smbd: Check and extend sender credits in interrupt context
      cifs: Allocate encryption header through kmalloc

Murphy Zhou (2):
      cifs: allow unlock flock and OFD lock across fork
      CIFS: check new file size when extending file by fallocate

Paulo Alcantara (SUSE) (1):
      cifs: handle prefix paths in reconnect

Qiujun Huang (1):
      fs/cifs: fix gcc warning in sid_to_id

Stefan Metzmacher (3):
      cifs: call wake_up(&server->response_q) inside of cifs_reconnect()
      cifs: use mod_delayed_work() for &server->reconnect if already queued
      cifs: make use of cap_unix(ses) in cifs_reconnect_tcon()

Steve French (10):
      cifs: do not ignore the SYNC flags in getattr
      smb3: fix performance regression with setting mtime
      cifs: print warning mounting with vers=1.0
      cifs: do d_move in rename
      CIFS: Warn less noisily on default mount
      SMB3: Add new compression flags
      SMB3: Additional compression structures
      SMB3: Minor cleanup of protocol definitions
      smb3: use SMB2_SIGNATURE_SIZE define
      cifs: update internal module version number

Yilu Lin (1):
      CIFS: Fix bug which the return value by asynchronous read is error

 fs/cifs/cifsacl.c       |   5 +-
 fs/cifs/cifsfs.c        |   4 +-
 fs/cifs/cifsfs.h        |   2 +-
 fs/cifs/cifspdu.h       |  19 ++---
 fs/cifs/cifsproto.h     |   5 ++
 fs/cifs/cifssmb.c       |  22 ++++--
 fs/cifs/connect.c       |  89 +++++++--------------
 fs/cifs/dfs_cache.c     |  38 +++++++++
 fs/cifs/dfs_cache.h     |   4 +
 fs/cifs/file.c          |   2 +-
 fs/cifs/inode.c         |  47 +++++++----
 fs/cifs/link.c          |   4 +-
 fs/cifs/misc.c          |  80 +++++++++++++++++++
 fs/cifs/readdir.c       |  82 ++++++++++++++++++++
 fs/cifs/smb2file.c      |   9 ++-
 fs/cifs/smb2ops.c       |  68 ++++++++--------
 fs/cifs/smb2pdu.c       | 202 ++++++++++++++++++++++++++++++++++++++++++------
 fs/cifs/smb2pdu.h       | 138 +++++++++++++++++++++++++--------
 fs/cifs/smb2proto.h     |   7 +-
 fs/cifs/smb2transport.c |   8 +-
 fs/cifs/smbdirect.c     |  41 ++++------
 fs/cifs/smbdirect.h     |   1 -
 fs/cifs/transport.c     |  28 ++++---
 23 files changed, 673 insertions(+), 232 deletions(-)

-- 
Thanks,

Steve
