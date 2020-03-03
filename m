Return-Path: <SRS0=S2CZ=4U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEAEC3F2D1
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 20:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0394208C3
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 20:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpjtCMLg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgCCUWn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 15:22:43 -0500
Received: from mail-yw1-f47.google.com ([209.85.161.47]:36786 "EHLO
        mail-yw1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbgCCUWn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 15:22:43 -0500
Received: by mail-yw1-f47.google.com with SMTP id y72so4687538ywg.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2020 12:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TAkK6bk4uP9VyqYT4IT0Yr5ezBih1RCiSQeEBdaRUFU=;
        b=IpjtCMLgA7+Dwiu1qUuUomwjU2rzMRO6aLOmD/lFf5b7hfxHHZEx/iXSFUavcOVhRi
         M5fBlcbE3FeyXo94HIqePonMRW1eMdrWSRElUdkCct608VwBZTvBCbEjraSVOk/fOcfP
         aEZuypTkitlVo3k/t5ycpe4T+H8Y36WWmxGOwpyXbJDW55FID/LKU1T6MEbiG4pxVkcc
         G+cO81GTri3Pw7rqgTYz8HSEX+HvBAJHlMDfKCBBSNvmQT0qx/iIKkcpuwwlybnIaADN
         zBXVqPfgr0L/uO7OHPNxBuuLPmIHj4SQY1RelFs3dkBSv3UatZVwbzddSXXhbDTTz/TU
         7R9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TAkK6bk4uP9VyqYT4IT0Yr5ezBih1RCiSQeEBdaRUFU=;
        b=m62GIVReoBvE0Ycs23N7qGNltdwo+JbF9ufwrAirlWrFuAmDjjdL87eSfyqfwUkH2X
         zfkKX5eaY+QCPLzKU/nGbRnFi3yetEHYIp1VUCmU0xKspvGG86qc1i0KLk8hvq1nunEE
         xr88sG+PvMwsvgxilGbUpo3vshX4r+r+y+vOWWr+usZTalI4fsrTxBdtBlJ/I2fY/OMu
         ej6CK9/jmRD0GTun6nH7/dC1oBewToQabkFbFvfEFNn/vuzWrJMWozN/O5kxa/FjneT3
         m0pBTRcfOqogJYM9xbYT3gtysYehPsI78Wy3YA9c9OOnUF2/UBk3sV8bPUErvagGOqc6
         N8Qg==
X-Gm-Message-State: ANhLgQ3p2LuZ0pMYGKnjD6Akx+G3dIHN4lfx5yTd67bUoFxaIdI+PFHf
        /TcVO02CCHIYk1raeV4CxceZMq77KyCeoF36PnBxLTGD
X-Google-Smtp-Source: ADFU+vs4fHAjXAgcGuaTYxOY34tBdg5PiCELPz54rwcaHcmQqP5fO/71qOpjqjO9ZiUPAHC3W/xkzHGcH3lxpFK72cc=
X-Received: by 2002:a81:6507:: with SMTP id z7mr6226975ywb.77.1583266960867;
 Tue, 03 Mar 2020 12:22:40 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 Mar 2020 14:22:30 -0600
Message-ID: <CAH2r5muzDocCzjYJ_ahYXz3G2e=UA4jmfowbHBMt4iWsu6+yVg@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
f8788d86ab28f61f7b46eb6be375f8a726783636:

  Linux 5.6-rc3 (2020-02-23 16:17:42 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-rc4-smb3-fixes

for you to fetch changes up to fb4b5f13464c468a9c10ae1ab8ba9aa352d0256a:

  cifs: Use #define in cifs_dbg (2020-02-24 14:20:38 -0600)

----------------------------------------------------------------
five small cifs/smb3 fixes, two for stable (one for a reconnect problem
and the other fixes a use case when renaming an open file)

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/320
----------------------------------------------------------------
Aurelien Aptel (1):
      cifs: fix rename() by ensuring source handle opened with DELETE bit

Joe Perches (1):
      cifs: Use #define in cifs_dbg

Paulo Alcantara (SUSE) (1):
      cifs: fix potential mismatch of UNC paths

Ronnie Sahlberg (1):
      cifs: don't leak -EAGAIN for stat() during reconnect

Steve French (1):
      cifs: add missing mount option to /proc/mounts

 fs/cifs/cifs_dfs_ref.c |  2 ++
 fs/cifs/cifsfs.c       |  2 ++
 fs/cifs/cifsglob.h     |  7 +++++++
 fs/cifs/cifsproto.h    |  5 +++--
 fs/cifs/cifssmb.c      |  3 ++-
 fs/cifs/file.c         | 19 ++++++++++++-------
 fs/cifs/inode.c        | 16 ++++++++++------
 fs/cifs/smb1ops.c      |  2 +-
 fs/cifs/smb2inode.c    |  4 ++--
 fs/cifs/smb2ops.c      |  3 ++-
 fs/cifs/smb2pdu.c      |  1 +
 11 files changed, 44 insertions(+), 20 deletions(-)

-- 
Thanks,

Steve
