Return-Path: <SRS0=aVrN=3R=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9752AC2D0DB
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jan 2020 18:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7173922522
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jan 2020 18:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUCIggTw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgA1Sbq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Jan 2020 13:31:46 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37742 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgA1Sbm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Jan 2020 13:31:42 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so15539023ioc.4;
        Tue, 28 Jan 2020 10:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=pfg8CyZL9ZGKK72mX+7CP2WJDlDC6K+5sOL3+BSa6oM=;
        b=AUCIggTwR6THZXL9RYK9PBiRPWPOVsBG6j/2Fzdu6W1z6nkl19loxt56Yanbm+6Mgo
         DM9/po8GFTVu3YY30xUIMrE2W5LjJFOcS6Kfda3A8X+fJVO3oNSiqVRcUYriNm/o5gi7
         FDeiZ1WdWrT5qgfnXeoP/0T0MPWBX4BRe5u/2CrkIJtex5VtLGwDpA/uYCiMvnXJFUJn
         9/LqVPKwmLrwNyfduly2b8RZEb0YTtgg1/PJTkriZE4g5+/hBIV4/H7wl+5oqIaPBpXt
         zfUJd+csiXTVsQB7PxzU9DMsaonshBiNEiwx4Q8RGTMM7mfmVoANhbHR5S3cZIlQs3kF
         I4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=pfg8CyZL9ZGKK72mX+7CP2WJDlDC6K+5sOL3+BSa6oM=;
        b=ayH/4J9BTEt3Au5Snk3iERqUpdy3y0oum30LdSRyNgUqotlEPe6ntSiDrXqpSFVrY3
         EY7uFtk6n5N/3mgqewL0fsP7XPC/rXnfTfXnUziGAN4NIPEPm78iywTOaTwfQlDxpvMh
         lSCBxgMwczisaGvAM4JsLGrj2N2C/75RNv6iktV3IODtAw3xDA9K3t9Dvbsz1Q4WAZNK
         oP4YFJF+9YXIqbUQOw+EOzgZmUXsm/mclHc9laKhmWQ4KJoCbvU4rFamcQE+2ExZBrwa
         +0uf32QTbtK5mdyp2bEyfiY6g0yv63Bk8/r1c4uR7AhCZ0BYVupvDV74mSRuy7AahIG6
         EYZA==
X-Gm-Message-State: APjAAAWxZxbPK/rkHehNq+qQlyRBShG9YsPjlE04s2NNeFjrBQXuh6gg
        dXs7GfcgdFCVUH1D6j8C/lMKy7c0FvUbxkNcqdr8XP2PA9s=
X-Google-Smtp-Source: APXvYqxP7sUDkga+f7ZDn6mNEYciBr1Mbee3A6TGvIuta11GXZrHs2lyGi0dFT/9+eCyHlv8xxCj/4WPN32S9QAfa3s=
X-Received: by 2002:a6b:c418:: with SMTP id y24mr13413675ioa.5.1580236301952;
 Tue, 28 Jan 2020 10:31:41 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 28 Jan 2020 12:31:30 -0600
Message-ID: <CAH2r5ms5g+iVOJzQorgSws9tK+aNY7MzsNaMVO_Yx_NYgS9nRQ@mail.gmail.com>
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
d5226fa6dbae0569ee43ecfc08bdcd6770fc4755:

  Linux 5.5 (2020-01-26 16:23:03 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git
tags/5.6-smb3-fixes-and-dfs-and-readdir-improvements

for you to fetch changes up to f1f27ad74557e39f67a8331a808b860f89254f2d:

  CIFS: Fix task struct use-after-free on reconnect (2020-01-26 19:24:17 -0600)

----------------------------------------------------------------
   - Various SMB3/CIFS fixes including 4 for stable.
   - Improvement to fallocate (enables 3 additional xfstests)
   - Fix for file creation when mounting with modefromsid
   - Add ability to backup/restore dos attributes and creation time over SMB3
   - DFS failover and reconnect fixes
   - Performance optimization for readdir (by using SMB3 compounding)

Buildbot automated functional test results:
     http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/312

Note that due to the upcoming SMB3 Test Event (at SNIA SDC next week).
There will likely be more changesets near the end of the merge window
(since we will be testing heavily next week, I held off on some patches
and I expect some additional multichannel patches as well as patches
to enable some additional xfstests).
----------------------------------------------------------------
Boris Protopopov (1):
      CIFS: Add support for setting owner info, dos attributes, and create time

Chen Zhou (1):
      cifs: use PTR_ERR_OR_ZERO() to simplify code

David Howells (1):
      cifs: Don't use iov_iter::type directly

Paulo Alcantara (SUSE) (8):
      cifs: Clean up DFS referral cache
      cifs: Get rid of kstrdup_const()'d paths
      cifs: Introduce helpers for finding TCP connection
      cifs: Merge is_path_valid() into get_normalized_path()
      cifs: Fix potential deadlock when updating vol in cifs_reconnect()
      cifs: Avoid doing network I/O while holding cache lock
      cifs: Fix mount options set in automount
      cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()

Ronnie Sahlberg (6):
      cifs: prepare SMB2_query_directory to be used with compounding
      cifs: create a helper function to parse the query-directory
response buffer
      cifs: use compounding for open and first query-dir for readdir()
      cifs: set correct max-buffer-size for smb2_ioctl_init()
      cifs: fix NULL dereference in match_prepath
      cifs: add support for fallocate mode 0 for non-sparse files

Steve French (2):
      cifs: fix unitialized variable poential problem with network I/O
cache lock patch
      smb3: fix default permissions on new files when mounting with modefromsid

Vincent Whitchurch (1):
      CIFS: Fix task struct use-after-free on reconnect

YueHaibing (2):
      cifs: Fix return value in __update_cache_entry
      cifs: remove set but not used variable 'server'

zhengbin (2):
      fs/cifs/smb2ops.c: use true,false for bool variable
      fs/cifs/cifssmb.c: use true,false for bool variable

 fs/cifs/cifs_dfs_ref.c  |   97 ++---
 fs/cifs/cifsacl.c       |   20 +
 fs/cifs/cifsfs.h        |    3 +
 fs/cifs/cifsglob.h      |    1 +
 fs/cifs/cifsproto.h     |    4 +
 fs/cifs/cifssmb.c       |    4 +-
 fs/cifs/connect.c       |    6 +-
 fs/cifs/dfs_cache.c     | 1112 +++++++++++++++++++++++++----------------------
 fs/cifs/file.c          |    8 +-
 fs/cifs/inode.c         |    4 +-
 fs/cifs/smb2misc.c      |    2 +-
 fs/cifs/smb2ops.c       |  171 +++++---
 fs/cifs/smb2pdu.c       |  182 +++++---
 fs/cifs/smb2pdu.h       |    2 +
 fs/cifs/smb2proto.h     |    5 +
 fs/cifs/smb2transport.c |    2 +
 fs/cifs/transport.c     |    3 +
 fs/cifs/xattr.c         |  128 +++++-
 18 files changed, 1041 insertions(+), 713 deletions(-)


-- 
Thanks,

Steve
