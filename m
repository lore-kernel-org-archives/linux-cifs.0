Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB24C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Nov 2021 04:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhKYEg7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Nov 2021 23:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhKYEe6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Nov 2021 23:34:58 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C1DC061574;
        Wed, 24 Nov 2021 20:31:47 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id b40so12927264lfv.10;
        Wed, 24 Nov 2021 20:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VRoQ21xNOMCXQxdsfT2vab5LJBpfbK3eYlNpXVueB2U=;
        b=g9l2WgCCh5qRTN5lFziqKTBDpz804n/3NmSsrd5hNfoiU7NV1ErzIQtUbKO5679w04
         /ustHZ5Bj48A5G2wyAz9EG+66YO2nGeT6BkC9EpS96kIaub5AZgQGfnmDmM3lI6i0Qch
         v5VEIXRLS9t6NXQ1HIZMb/A0145lty5hpOslwL4v151XKgw8eHxlpbPzihuseICOI1RK
         hmetHk9Ls8ZxZpjXRb04BINgMdZ7VnyzQ0A8Es/NNUExDKjzvnHViCPBJgcrrM+OIr0O
         ylzkMpL41A7X+fHK5+y86SThhB7Rj77FQM7xBP1QXQySz3DaYkLYm9fVgGw/RdM5rq7P
         AWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VRoQ21xNOMCXQxdsfT2vab5LJBpfbK3eYlNpXVueB2U=;
        b=JkuaaXUCNvU/BDEAznHKudojY+0KjbJFzWNWb5k/8uHwj1AOxkL0Z4MBHluelDeqij
         6MgQkNRbfpEdIrcLIoEzTtVG6WW7gk6ORQwxChFZ23Z423vE2ALNBFD9GVw9WRMlifaW
         HfQlnwVQ/OkhgiyqYRsqiTw4RlR2ZPN3HeiCescza/AqeNEetS3lYxY/ijltcbhwSMAN
         dtrvCszsWjXJsazHYR//MNSYYwX2soUi4A+YhJyaYlI5ypLIi0RBNZfpNvGXOWBL4YIj
         LFNh0D7HCPNj+OTwVLYJLRlKQeYuZx03/vfcdjsFBwdgRjA3ECUl3iIQ9i/Jk+DUyiwl
         co/A==
X-Gm-Message-State: AOAM531mmPej9sdX7eZhDrJBu+UQNBLA8kaMwuQ5PLRldt+nhjYBQkS2
        v0Ha6xau63OIFtxofY9gP1LIj7a87UqADoc2//OBHfEBKhM=
X-Google-Smtp-Source: ABdhPJy5kzdmfy9094L+ibPW6zW2ZCqfAf3Pxle6FuAgambnyIMQdUMIcoaxzY/XQs+gEKchOv+u0a1pgRfH3TjPEY0=
X-Received: by 2002:a05:6512:3fa4:: with SMTP id x36mr20789685lfa.320.1637814705608;
 Wed, 24 Nov 2021 20:31:45 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Nov 2021 22:31:34 -0600
Message-ID: <CAH2r5mstBrgQYtmmV36BB_MAUqxy4dAKWzuMTmHcjXLjge4Epw@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc2-smb3-fixes

for you to fetch changes up to 0b03fe6d3ae21a7769d867ccdce33737eb348454:

  cifs: update internal version number (2021-11-23 10:07:15 -0600)

----------------------------------------------------------------
4 small cifs/smb3 fixes:
- 2 multichannel fixes
- 1 to fix problem noted by kernel test robot
- update internal version number

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/842
----------------------------------------------------------------
Shyam Prasad N (2):
      cifs: nosharesock should be set on new server
      cifs: populate server_hostname for extra channels

Steve French (2):
      smb2: clarify rc initialization in smb2_reconnect
      cifs: update internal version number

 fs/cifs/cifsfs.h  | 2 +-
 fs/cifs/connect.c | 7 ++++---
 fs/cifs/sess.c    | 1 +
 fs/cifs/smb2pdu.c | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
