Return-Path: <SRS0=8MWe=XX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E85EC4360C
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Sep 2019 21:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB2720866
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Sep 2019 21:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MNzZrXao"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfI1Vgf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 28 Sep 2019 17:36:35 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:36584 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfI1Vgf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 28 Sep 2019 17:36:35 -0400
Received: by mail-io1-f43.google.com with SMTP id b136so27262088iof.3;
        Sat, 28 Sep 2019 14:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5N4/gVVHg8/PXbBpdg5Q+FRK+1aZx3zHcEy4NEqiJd4=;
        b=MNzZrXaoy2TPXpWG4NBGtaMn+r5sli8/zEzYtR0/pRwqIr1TP8ziTcAEBcQ+Sh5+9y
         F71vk79/k8uP50HgzpZi77kMsM9WQqmRiQWvyEeVgkCvA5us50sIwOoWtvNJmMlpO9Ym
         63DrvCmTn2znGGoPu7tPfOyHYpxeWc22Wk88zoWY1yx42/ruDghjrEpRwgZv6SfzNdTP
         TaqIFqodvDCedIg4goJIfNY8b0U/2xxko2DuWXGSM/Isys+eLtA45Sxx/SBho0kAA+P6
         G1BlKMvDnlFG52vO+BmVZnu5uyiQ1oar3ziVrV2Yy8Ozxy0ND7aYHlN31D+CZTnp37dY
         N/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5N4/gVVHg8/PXbBpdg5Q+FRK+1aZx3zHcEy4NEqiJd4=;
        b=BNpj9jgHKsrbI963HJOware+0Lpiix5NqYgFjeBopKytcXFi0apZC4VW5Q/xRYHC9w
         3jIp/JITET/z02VD4gCVKlSHPmOZ8gPIhYwQz+eqKVbXUft3+4dWDOIBzf5SyDklLnpi
         5x0XfJ9UxcdOKRbCA7OYk2X2BUSNlGBhToTpol8/KigXNrdfSLTppZyv56GXEeFPk+yp
         2mEsovv3CY1Q9wynjayNFdDq698sqH0/V/1rRZ3KUEez3Eo5L8gdtgFk7I9BWrxV9i+4
         sKweNr72tWweVEijhpFSRUMZn4TtxiAVVCpPJbNoxWfCshHYe8iEDjf9LUNw3NBF/3kZ
         UiXQ==
X-Gm-Message-State: APjAAAXM5s4WPSJHFHzyVm7UkhvCXYDGu1vgSZXTmx8Z9An6TpZGZ5Eo
        3mXtoAOXhtHwfcVRCGCFlLA03Kq+S+SY2ZRRT4DyrXqDLwE=
X-Google-Smtp-Source: APXvYqxnXaC+9p8LeEm+NJ6+Bo+NYpDLlxh0kkJV07GLJbeIqGODs1GCXkzlOMeua378WEyd73MOTxVHmLfQgzOjfvE=
X-Received: by 2002:a05:6e02:60f:: with SMTP id t15mr12840728ils.3.1569706592677;
 Sat, 28 Sep 2019 14:36:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 28 Sep 2019 16:36:21 -0500
Message-ID: <CAH2r5mu_4C=V=BsNAsEiPQp-rFbV-rYixgkpG1oJzRWdSsbejw@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please update the following changes since commit
4d6bcba70aeb4a512ead9c9eaf9edc6bbab00b14:

  cifs: update internal module version number (2019-09-16 19:18:39 -0500)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-rc-smb3-fixes

for you to fetch changes up to a016e2794fc3a245a91946038dd8f34d65e53cc3:

  CIFS: Fix oplock handling for SMB 2.1+ protocols (2019-09-26 16:42:44 -0500)

----------------------------------------------------------------
Fixes from the recent SMB3 Test events and Storage Developer
Conference (held the last two weeks).

9 smb3 patches including an important patch needed for viewing SMB3
encrypted traffic in wireshark for debugging, and 3 patches for stable

Buildbot SMB3 regression tests passed:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/253

Additional fixes from last week to better handle some newly discovered
reparse points, and a fix the create/mkdir path for setting the mode
more atomically (in SMB3 Create security descriptor context), and one
for path name processing are still being tested so are not included in
this PR.

----------------------------------------------------------------
Murphy Zhou (1):
      CIFS: fix max ea value size

Pavel Shilovsky (1):
      CIFS: Fix oplock handling for SMB 2.1+ protocols

Steve French (5):
      smb3: allow decryption keys to be dumped by admin for debugging
      smb3: fix leak in "open on server" perf counter
      smb3: Add missing reparse tags
      smb3: pass mode bits into create calls
      smb3: missing ACL related flags

zhengbin (2):
      fs/cifs/smb2pdu.c: Make SMB2_notify_init static
      fs/cifs/sess.c: Remove set but not used variable 'capabilities'

 fs/cifs/cifs_ioctl.h |  9 +++++++++
 fs/cifs/cifsacl.h    | 81
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/cifsglob.h   |  6 ++++--
 fs/cifs/cifsproto.h  |  3 ++-
 fs/cifs/cifssmb.c    |  3 ++-
 fs/cifs/inode.c      |  3 ++-
 fs/cifs/ioctl.c      | 29 +++++++++++++++++++++++++++++
 fs/cifs/sess.c       |  3 +--
 fs/cifs/smb2inode.c  | 34 +++++++++++++++++++---------------
 fs/cifs/smb2ops.c    | 10 ++++++++++
 fs/cifs/smb2pdu.c    | 23 ++++++++++++++++++++++-
 fs/cifs/smb2proto.h  |  3 ++-
 fs/cifs/smbfsctl.h   | 11 +++++++++++
 fs/cifs/xattr.c      |  2 +-
 14 files changed, 194 insertions(+), 26 deletions(-)


-- 
Thanks,

Steve
