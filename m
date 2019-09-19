Return-Path: <SRS0=OUN2=XO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E40C3A5A6
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Sep 2019 17:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 657E720644
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Sep 2019 17:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vf7MUU5v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391412AbfISRHh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:07:37 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39562 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390733AbfISRHg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Sep 2019 13:07:36 -0400
Received: by mail-io1-f68.google.com with SMTP id a1so9511356ioc.6;
        Thu, 19 Sep 2019 10:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Wl8ag3Biov2tecaZ0wjr4rdybfXjntlGHm+BGYY64wo=;
        b=Vf7MUU5vIn7iBEMFCIdblKOa5k4OkdBAzm5+rtgxylyhdPfT+TIrt0548JT8sV7YI0
         O4AoSoyMhKzIYm/9rdj7FsJk07zIl/F41WX1Oo4iwtTdl7qeDhFxqZ4QlzLDZG/GE2JU
         AGkjo9E1WlSmube7SBWjtXVgY1gz/RFyfnJ0/GJYQP/vE6On0vc3EJcYhAYaaViq/Wld
         s9gws75lauSWl1ujFd9qBwVIZItRHZNAOd/gyUMhvGBkAZhqQZAfzWfqXc6CXbIQDjIb
         exBSA2kQvptw4If3YG8BKvLH+y42/RCI+AVZy82J29sLDmhaV7F6DOsNSDPRIUNCHNUB
         Uu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Wl8ag3Biov2tecaZ0wjr4rdybfXjntlGHm+BGYY64wo=;
        b=W6PBFYcspXYF7SEzL0ivlhgH3RM03WKTt3xM16SnibYxoN0BYNLQrN2K6+I5XcAyGQ
         rLoEogdCRVm5WWwFYbHUyzATlgE61rG7u4U2TjkOGzlJbF+U/I75NTut+EUO8be0e6j1
         Nu2NAqPcwBGpRkTJWA+R3LPN/KgARv7YcMYwaheT4tPJ0bTYL0OBkuhjHVykBVqqm+Ch
         hV1lTC0AbgZrNL53rw+TD8qnPOzzXeiEJRCZuzBK1r6Emxnml20jvFTWEK08yQrVtcbp
         8WGXlfmjrcbw+5rXKx8RYbpZAuAOWVPOoHuT6FPym8rW4rhDGZ3EI+0YkRTZpyKiigjl
         71pg==
X-Gm-Message-State: APjAAAWKDC+yYz0N/+XMjZtKC4hKKH1MJU+4uNeYGwp4U5B1jm7j8wc8
        hPs25Fq7MxycAv6ozPddAxi9Qiaap1vjWuF/Q4dxlkrjFcg=
X-Google-Smtp-Source: APXvYqyE0YJ9hnax8J4ETM0gcJpuGPNAlLg3+lHYStz97BztU6zrrChjLDF4pGBZdXdPJ6+jNzh65FoNUBWmk8sVyhs=
X-Received: by 2002:a6b:c38f:: with SMTP id t137mr9255009iof.137.1568912855689;
 Thu, 19 Sep 2019 10:07:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 19 Sep 2019 12:07:25 -0500
Message-ID: <CAH2r5mv2X00FCZy9PUVmhTuRtYb+gN-fHbWQQgtH=Vq+gH+O3A@mail.gmail.com>
Subject: [GIT PULL] SMB3 fixes and features
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
4d856f72c10ecb060868ed10ff1b1453943fc6c8:

  Linux 5.3 (2019-09-15 14:19:32 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-smb3-fixes

for you to fetch changes up to 4d6bcba70aeb4a512ead9c9eaf9edc6bbab00b14:

  cifs: update internal module version number (2019-09-16 19:18:39 -0500)

----------------------------------------------------------------
Various cifs/smb3 fixes (including for share deleted cases) and
features including improved encrypted read performance, some new
performance related mount options, cifs.ko network boot support
(additional small patch for ipconfig.c sent to Dave Miller which will
allow enabling this) and various debugging improvements

SMB3 "Buildbot" automated regression test run for this set:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/250

Note that since I am at a test event this week with the Samba team,
and at the annual Storage Developer Conference/SMB3 Plugfest test
event next week a higher than usual number of fixes is expected
later next week as other features in progress get additional testing
and review during these two events.

----------------------------------------------------------------
Aurelien Aptel (3):
      cifs: modefromsid: make room for 4 ACE
      cifs: cifsroot: add more err checking
      cifs: modefromsid: write mode ACE first

Colin Ian King (3):
      fs: cifs: cifsssmb: remove redundant assignment to variable ret
      cifs: remove redundant assignment to variable rc
      cifs: fix dereference on ses before it is null checked

Paulo Alcantara (SUSE) (1):
      cifs: Add support for root file systems

Ronnie Sahlberg (8):
      cifs: fix a comment for the timeouts when sending echos
      cifs: prepare SMB2_Flush to be usable in compounds
      cifs: add passthrough for smb2 setinfo
      cifs: create a helper to find a writeable handle by path name
      cifs: use existing handle for compound_op(OP_SET_INFO) when possible
      cifs: add new debugging macro cifs_server_dbg
      cifs: add a debug macro that prints \\server\share for errors
      cifs: add a helper to find an existing readable handle to a file

Steve French (21):
      cifs: get mode bits from special sid on stat
      cifs: allow chmod to set mode bits using special sid
      smb3: add missing flag definitions
      smb3: Incorrect size for netname negotiate context
      smb3: add mount option to allow forced caching of read only share
      smb3: add some more descriptive messages about share when
mounting cache=ro
      smb3: add mount option to allow RW caching of share accessed by
only 1 client
      smb3: log warning if CSC policy conflicts with cache mount option
      smb3: add dynamic tracepoints for flush and close
      smb3: allow skipping signature verification for perf sensitive
configurations
      smb3: fix signing verification of large reads
      smb3: allow parallelizing decryption of reads
      smb3: enable offload of decryption of large reads via mount option
      smb3: only offload decryption of read responses if multiple requests
      smb3: display max smb3 requests in flight at any one time
      smb3: improve handling of share deleted (and share recreated)
      smb3: allow disabling requesting leases
      smb3: fix unmount hang in open_shroot
      smb3: fix potential null dereference in decrypt offload
      smb3: add missing worker function for SMB3 change notify
      cifs: update internal module version number

YueHaibing (1):
      cifs: remove set but not used variables

zhengbin (1):
      cifs: remove unused variable

 Documentation/filesystems/cifs/cifsroot.txt |  97 ++++++++++
 fs/cifs/Kconfig                             |   8 +
 fs/cifs/Makefile                            |   2 +
 fs/cifs/cifs_debug.c                        |   2 +
 fs/cifs/cifs_debug.h                        |  67 +++++++
 fs/cifs/cifs_fs_sb.h                        |   2 +
 fs/cifs/cifs_ioctl.h                        |   1 +
 fs/cifs/cifsacl.c                           |  81 ++++++--
 fs/cifs/cifsacl.h                           |   2 +-
 fs/cifs/cifsfs.c                            |  28 ++-
 fs/cifs/cifsfs.h                            |   2 +-
 fs/cifs/cifsglob.h                          |  19 +-
 fs/cifs/cifsproto.h                         |   5 +
 fs/cifs/cifsroot.c                          |  94 +++++++++
 fs/cifs/cifssmb.c                           |   2 +-
 fs/cifs/connect.c                           | 152 +++++++++++----
 fs/cifs/dir.c                               |   2 +-
 fs/cifs/file.c                              |  80 +++++++-
 fs/cifs/inode.c                             |  19 +-
 fs/cifs/smb2inode.c                         | 155 +++++++++++----
 fs/cifs/smb2maperror.c                      |   2 +-
 fs/cifs/smb2ops.c                           | 201 ++++++++++++++-----
 fs/cifs/smb2pdu.c                           | 287 ++++++++++++++++++++--------
 fs/cifs/smb2pdu.h                           |   2 +
 fs/cifs/smb2proto.h                         |   4 +
 fs/cifs/smb2transport.c                     |  62 +++---
 fs/cifs/trace.h                             |  38 ++++
 fs/cifs/transport.c                         | 120 ++++++------
 include/linux/root_dev.h                    |   1 +
 29 files changed, 1218 insertions(+), 319 deletions(-)
 create mode 100644 Documentation/filesystems/cifs/cifsroot.txt
 create mode 100644 fs/cifs/cifsroot.c


-- 
Thanks,

Steve
