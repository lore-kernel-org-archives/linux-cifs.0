Return-Path: <SRS0=0I05=7S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AC8C433E0
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 17:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 939A4207D3
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 17:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtQYrUfb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgFERLF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jun 2020 13:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgFERLE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jun 2020 13:11:04 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF6FC08C5C2
        for <linux-cifs@vger.kernel.org>; Fri,  5 Jun 2020 10:11:04 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id j8so5139091ybj.12
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jun 2020 10:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Afz9OwwRNaNIORGffnMXeW6BKrNYUibdqXhT82b1rYE=;
        b=FtQYrUfbFSiZbA3hRL6on0iujzpUTu9Wl6LJRERjxxIFLfaywJ7ZQioy4AyJ1KDTil
         AwQ2lnNzQL7mQ4287FqhTu0Mffx68iccRfSG5rbXxSiOpzXd3DzZNYm1sCcUQt3cjKln
         sWy/6fMnAuopGC8alFCpN5bI4jb/VGkml+Zvb/qaTclabmK/blhpwTlbedoShELQtk7Q
         YDCyFsrkgxDkKjAVORCAy2YvhC3GvkZ9yNFYcSeqvTYE/HZnMsvLtVwmLO01zo764L/o
         ZslHArFseD0TsDm/sAT35rxl0nXEfiiBDr+EzLTGaKsHAGUmB3kq7Q77zpwEfXYAcCnF
         Tkjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Afz9OwwRNaNIORGffnMXeW6BKrNYUibdqXhT82b1rYE=;
        b=gg3bjbwpy3Uvz/FFDDK4wA792GWUhwX2WGCWbnBABLwDPCifTrJ1F3zNdwmt+RNQ6q
         f9vwJv9LWbOAvhDKXDqGusmEZxFaLqehMwziA9GHQHauuv/dNBXSdE5iU2+2zazeQ1HN
         xsI2XuNI6+SKJYyGy2P+jY7ateGTvR4YdGffmVI0TAvUiQITU6PS1cxmPJMpp0Z0u1TS
         f4rQKK1n/UMvVXy+V/wSoQxdic+HGschAAbE/8yx0WsJTB/uUyOqG69MPPDuLkHwyziA
         AVFuJ/HM9Wb+529h2iq6nTejngZtIMzFTYRiSs+eWLcvwVc4ql2TVB6PRQPZ7fy2dtV3
         jahg==
X-Gm-Message-State: AOAM531o1sN4ycipf5+yCJlcp5Ccjq55Z4KM1RA1C3efbMzjZSSSsGeS
        8UVfVf2kf5L8vKcna9dbkipyYajNGMgyaSiTM3rHeTgzdMg=
X-Google-Smtp-Source: ABdhPJz7aOK2sUTULsEAIWjlUkqgy9qN1Vyv5I010iMZW3/aoQ4oVNgKiaY75HHIrFlN8oSt/z6OsW2WsYJ7gPmG+IQ=
X-Received: by 2002:a25:ca45:: with SMTP id a66mr17601483ybg.85.1591377063490;
 Fri, 05 Jun 2020 10:11:03 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Jun 2020 12:10:52 -0500
Message-ID: <CAH2r5mtZ-TLv-rNn_A_KcPR+djGQ9CpfVyvXSj-Uv-s+XiWq3A@mail.gmail.com>
Subject: [GIT PULL] SMB3 updates for 5.8
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162:

  Linux 5.7 (2020-05-31 16:49:15 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc-smb3-fixes-part-1

for you to fetch changes up to 331cc667a99c633abbbebeab4675beae713fb331:

  cifs: update internal module version number (2020-06-04 13:50:55 -0500)

----------------------------------------------------------------
22 changesets, 2 for stable.  Includes big performance improvement for
large i/o when using multichannel, also includes DFS fixes

Build verification results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/353

There are another set of patches still being tested that are not
included in this
pull request (e.g. idfromsid, posix extensions getattr improvements,
mount improvements)
----------------------------------------------------------------
Aurelien Aptel (5):
      cifs: multichannel: move channel selection in function
      cifs: multichannel: always zero struct cifs_io_parms
      cifs: multichannel: move channel selection above transport layer
      cifs: multichannel: use pointer for binding channel
      cifs: multichannel: try to rebind when reconnecting a channel

Colin Ian King (1):
      cifs: remove redundant initialization of variable rc

Joe Perches (1):
      cifs: Standardize logging output

Kenneth D'souza (2):
      cifs: handle "nolease" option for vers=1.0
      cifs: dump Security Type info in DebugData

Paulo Alcantara (3):
      cifs: set up next DFS target before generic_ip_connect()
      cifs: handle hostnames that resolve to same ip in failover
      cifs: get rid of unused parameter in reconn_setup_dfs_targets()

Ronnie Sahlberg (2):
      cifs: reduce stack use in smb2_compound_op
      cifs: move some variables off the stack in smb2_ioctl_query_info

Steve French (8):
      smb3: Add new parm "nodelete"
      cifs: minor fix to two debug messages
      smb3: minor update to compression header definitions
      cifs: fix minor typos in comments and log messages
      smb3: default to minimum of two channels when multichannel specified
      smb3: fix incorrect number of credits when ioctl MaxOutputResponse > 64K
      smb3: remove static checker warning
      cifs: update internal module version number

 fs/cifs/cifs_debug.c  |   6 +
 fs/cifs/cifs_debug.h  | 145 +++++++++---------
 fs/cifs/cifsencrypt.c |   8 +-
 fs/cifs/cifsfs.c      |   2 +
 fs/cifs/cifsfs.h      |   2 +-
 fs/cifs/cifsglob.h    |  20 ++-
 fs/cifs/cifsproto.h   |  36 +++--
 fs/cifs/cifsroot.c    |   6 +-
 fs/cifs/cifssmb.c     |  81 ++++++----
 fs/cifs/connect.c     | 130 ++++++++--------
 fs/cifs/dfs_cache.c   |  14 +-
 fs/cifs/file.c        |  60 ++++----
 fs/cifs/inode.c       |  17 ++-
 fs/cifs/link.c        |   8 +-
 fs/cifs/misc.c        |  60 +++++++-
 fs/cifs/netmisc.c     |   6 +-
 fs/cifs/readdir.c     |  10 +-
 fs/cifs/sess.c        |  55 ++++---
 fs/cifs/smb1ops.c     |   2 +-
 fs/cifs/smb2inode.c   | 137 +++++++++--------
 fs/cifs/smb2misc.c    |  20 +--
 fs/cifs/smb2ops.c     | 168 +++++++++++++--------
 fs/cifs/smb2pdu.c     | 499
++++++++++++++++++++++++++++++++++++++-----------------------
 fs/cifs/smb2pdu.h     |  13 +-
 fs/cifs/smb2proto.h   |  25 +++-
 fs/cifs/smbdirect.c   | 165 ++++++++------------
 fs/cifs/transport.c   |  75 ++++++----
 27 files changed, 1041 insertions(+), 729 deletions(-)

-- 
Thanks,

Steve
