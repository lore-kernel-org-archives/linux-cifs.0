Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53910C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 23:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D3C2070B
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 23:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mw1uKelo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfK0Xto (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Nov 2019 18:49:44 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33558 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfK0Xto (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Nov 2019 18:49:44 -0500
Received: by mail-io1-f65.google.com with SMTP id j13so26952451ioe.0;
        Wed, 27 Nov 2019 15:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=gSj2pWdZX1PdXEy1vq4ly43WymfbEpVIP+x3vEhoi3c=;
        b=Mw1uKeloCBfJYGuEaZeon622BcZkt9xCzt5+HNrdOlgekuf2MCHxl6axxMTaPfZ3ni
         3SEsgCqx9kjqypACw3CNBsF5JB50tsV2Y8/nInyKxozI80sZFbBPMR8eQN7K6B2Pr68J
         Q1Hmv3JnGyx+PqWIIFTpNTUUlvnf9ImukhtnYTR63YX8k+xGi9mQ/gdj5BllaQO5/7x3
         XLmtlWmuDrodlBrBmWCPeN61jkOk92PemxB3QZLFohgmJITVLyZ/KGM8OuQYDNFM62X/
         lckHjqzgw/bSE2sokC9KpJ1Lbz+XRpX/k1ArWUvA0v8r1nmny0BZoTmINWflSl32SIMw
         K14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=gSj2pWdZX1PdXEy1vq4ly43WymfbEpVIP+x3vEhoi3c=;
        b=ax4HWunZWlW6+p2HR5KgcWFKjIUyW5p+HutkEKPYki7RH1uESnznjZghk/t7uxQqss
         oBIrlJF1t3LBBOZC7aGrM404lWqYNzxZpD1i40A/D5FTfezodC7T48Zo9BniezWh8cY7
         EuHpgQl3vCNLaybZoDpscG7mq2aHmEhN+ai2pAWDbQw2cos8IepfuuY1DAyWjtPYJcL8
         qzQDHen6Mzm6BEZ3+uGUt5jKrXhrpEsDKhllW9uJI6BZKMdKr5C97Ryx3oMVdCvoe9nF
         Yfo/5SOYy752W9OoNGHgX8R+Ung4EqFfpF2P7FEWIX6quwv6txobDaBqvbFuermNghdI
         0W/w==
X-Gm-Message-State: APjAAAVnPkcSCOYGvL2F7EYZ/PeEbXq2c2hPNR56KRRDWhddioNuk9+v
        MA5V3r8zYBTkkJj96XakmWz0zjX6TiiomakqVGByEU2O
X-Google-Smtp-Source: APXvYqzqIEUCnQNmhAeENYKBRjkNwhAc2pztWO5oL7JoyJq4EKdOgBnNlcJkCUoc9O/kvCg5QnmcMVtCU0QxrTYoVo8=
X-Received: by 2002:a5d:848c:: with SMTP id t12mr36778001iom.5.1574898583117;
 Wed, 27 Nov 2019 15:49:43 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Nov 2019 17:49:32 -0600
Message-ID: <CAH2r5mtDpwY=MrQ=yN29JeWUqf+ozgYvgnzbnb91VoK8Vg4Zmw@mail.gmail.com>
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
219d54332a09e8d8741c1e1982f5eae56099de85:

  Linux 5.4 (2019-11-24 16:32:01 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.5-rc-smb3-fixes

for you to fetch changes up to 68464b88cc0a735eaacd2c69beffb85d36f25292:

  CIFS: fix a white space issue in cifs_get_inode_info() (2019-11-27
11:31:49 -0600)

----------------------------------------------------------------
Various smb3 fixes (including 12 for stable) and also features
(addition of multichannel support).  This includes the first set of
CIFS/SMB3 changes for 5.5.

Buildbot automated regression testing results (passed):
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/286

There are additional fixes for DFS (global name space) support and
some multichannel enhancements and POSIX fixes that are still being
tested and are not included in
this pull request.
----------------------------------------------------------------
Aurelien Aptel (8):
      cifs: sort interface list by speed
      cifs: add multichannel mount options and data structs
      cifs: add server param
      cifs: switch servers depending on binding state
      CIFS: refactor cifs_get_inode_info()
      cifs: try opening channels after mounting
      cifs: try harder to open new channels
      cifs: dump channel info in DebugData

Dan Carpenter (1):
      cifs: rename a variable in SendReceive()

Dan Carpenter via samba-technical (1):
      CIFS: fix a white space issue in cifs_get_inode_info()

Long Li (7):
      cifs: Don't display RDMA transport on reconnect
      cifs: smbd: Invalidate and deregister memory registration on
re-send for direct I/O
      cifs: smbd: Return -EINVAL when the number of iovs exceeds
SMBDIRECT_MAX_SGE
      cifs: smbd: Add messages on RDMA session destroy and reconnection
      cifs: smbd: Return -ECONNABORTED when trasnport is not in connected state
      cifs: smbd: Only queue work for error recovery on memory registration
      cifs: smbd: Return -EAGAIN when transport is reconnecting

Markus Elfring (3):
      CIFS: Use memdup_user() rather than duplicating its implementation
      CIFS: Use common error handling code in smb2_ioctl_query_info()
      CIFS: Return directly after a failed build_path_from_dentry() in
cifs_do_create()

Paulo Alcantara (SUSE) (5):
      cifs: Fix use-after-free bug in cifs_reconnect()
      cifs: Fix lookup of root ses in DFS referral cache
      cifs: Fix potential softlockups while refreshing DFS cache
      cifs: Fix retrieval of DFS referrals in cifs_mount()
      cifs: Always update signing key of first channel

Pavel Shilovsky (6):
      CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
      CIFS: Close open handle after interrupted close
      CIFS: Fix NULL pointer dereference in mid callback
      CIFS: Do not miss cancelled OPEN responses
      CIFS: Fix SMB2 oplock break processing
      CIFS: Properly process SMB3 lease breaks

Ronnie Sahlberg (4):
      cifs: close the shared root handle on tree disconnect
      smb3: add debug messages for closing unmatched open
      cifs: don't use 'pre:' for MODULE_SOFTDEP
      cifs: move cifsFileInfo_put logic into a work-queue

Steve French (4):
      cifs: add support for flock
      smb3: remove confusing dmesg when mounting with encryption ("seal")
      smb3: dump in_send and num_waiters stats counters by default
      cifs: update internal module version number

YueHaibing (2):
      cifs: remove unused variable 'sid_user'
      CIFS: remove set but not used variables 'cinode' and 'netfid'

 fs/cifs/cifs_debug.c    |  43 +++++++++-
 fs/cifs/cifs_spnego.c   |   2 +-
 fs/cifs/cifsacl.c       |   2 -
 fs/cifs/cifsfs.c        |  44 ++++++++---
 fs/cifs/cifsfs.h        |   3 +-
 fs/cifs/cifsglob.h      |  90 +++++++++++++++------
 fs/cifs/cifsproto.h     |   8 ++
 fs/cifs/connect.c       | 191 +++++++++++++++++++++++++++++++++-----------
 fs/cifs/dfs_cache.c     |   3 +-
 fs/cifs/dir.c           |   6 +-
 fs/cifs/file.c          | 159 +++++++++++++++++++++++++++++--------
 fs/cifs/inode.c         | 333
++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 fs/cifs/misc.c          |  17 +---
 fs/cifs/sess.c          | 230
++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb1ops.c       |   8 +-
 fs/cifs/smb2misc.c      | 175 ++++++++++++++++++++++++----------------
 fs/cifs/smb2ops.c       | 141 +++++++++++++++++++--------------
 fs/cifs/smb2pdu.c       | 168 ++++++++++++++++++++++++++-------------
 fs/cifs/smb2pdu.h       |   2 +-
 fs/cifs/smb2proto.h     |   6 +-
 fs/cifs/smb2transport.c | 165 +++++++++++++++++++++++++++++---------
 fs/cifs/smbdirect.c     |  36 +++++----
 fs/cifs/transport.c     |  37 +++++++--
 23 files changed, 1340 insertions(+), 529 deletions(-)

-- 
Thanks,

Steve
