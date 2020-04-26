Return-Path: <SRS0=reoz=6K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A11FC54FCB
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Apr 2020 14:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 294162071C
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Apr 2020 14:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g1gufUtj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgDZOYE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Apr 2020 10:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgDZOYE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Apr 2020 10:24:04 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB88C061A0F;
        Sun, 26 Apr 2020 07:24:04 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id a7so2345442ybs.4;
        Sun, 26 Apr 2020 07:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=v+nxHzSn6RRIKSvsGs/i9HYR2TbbasmboUuFVsF8RDE=;
        b=g1gufUtjqrUv8RN0imWn4ul6dAdUrZNtnpfy348wGsFbP5NuuOUUXYZs8F8WpIkKkF
         N1u8amih9R1V69ve6xvKcHEYwdS2QP2UCrZ5SQ5e9qGVT5spl/VYLWQRSEz6M/Z/T1yQ
         tNDIch9u4u/33y2xA4MKtGcefFwDsJjDxHAG9Pu/LN54MLyEQh0sh/K46P41jQi2/Xg2
         fR6W6n7SvS3oCxo66YOkRCRrxtCdABlp+wmUwVJxKBsN+vFhXECkna9eb8jA3v17cc3p
         p6Gwyah8Eth2U+FFZ39Hto5Q5kM8GeP95TzThNbWitgeYo75EfP0WpTaWpp6krvthHuo
         Y5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=v+nxHzSn6RRIKSvsGs/i9HYR2TbbasmboUuFVsF8RDE=;
        b=L7hAbBKgttt9dyKnzNxg7I+FjjlBx9hPPKRaZlLblftuYD6PcwW/0lEtEAtjSoBlYn
         8f/aInWun2+ZQv5nA9nNpmQj/jBy7C2fUREjb5rvirljlf5mgyypX8D/NbmPw7etJ0Pi
         kg89jW35boHaFVaCIfztjnnGFHPvQShVwAVw6eq5vnWNQuId6L8qrIPWWad3NI+A1AQ/
         9Slbok/xac5vvNE9r/jX1kXZg5nXRZpBmyYUhTpR9lMT891WvRSiwjtm61jPe3xZl791
         ew/kJEaJc5pY9tRvApONyaOMafmS7BbOu7nvWSp+jcJaoolQ7l8K5r60sh39TjZnfQX5
         uwaA==
X-Gm-Message-State: AGi0PuYltcgyj9Sr9S/rw6721RKIsxr9pFVA06t9vBOK4RMQV2xryEYw
        K0UpcKdUoQRG52WygxrqJgCKbVawcMPq3TRSVolv0z6V8EY=
X-Google-Smtp-Source: APiQypLK2KTB6MPtOleHAa1EMpJ+w5SuWl4SNiDvfAbY54FmKOQRss+iSpRN7+rnibiLd9DlSkP8N9CJIffDOfSBBhM=
X-Received: by 2002:a25:42ce:: with SMTP id p197mr27532907yba.167.1587911042158;
 Sun, 26 Apr 2020 07:24:02 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 26 Apr 2020 09:23:51 -0500
Message-ID: <CAH2r5mvFb--OkoyHwPeML_CoRH=UfbFLRhUcoGBSKbLgok2VXg@mail.gmail.com>
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
ae83d0b416db002fe95601e7f97f64b59514d936:

  Linux 5.7-rc2 (2020-04-19 14:35:30 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc2-smb3-fixes

for you to fetch changes up to 0fe0781f29dd8ab618999e6bda33c782ebbdb109:

  cifs: fix uninitialised lease_key in open_shroot() (2020-04-22 20:29:11 -0500)

----------------------------------------------------------------
Five cifs/smb3 fixes: two for DFS reconnect failover,  one lease fix
for stable and the others to
fix a missing spinlock during reconnect

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/345
----------------------------------------------------------------
Paulo Alcantara (3):
      cifs: do not share tcons with DFS
      cifs: ensure correct super block for DFS reconnect
      cifs: fix uninitialised lease_key in open_shroot()

Ronnie Sahlberg (1):
      cifs: protect updating server->dstaddr with a spinlock

Steve French (1):
      cifs: minor update to comments around the cifs_tcp_ses_lock mutex

 fs/cifs/cifsglob.h |  3 +-
 fs/cifs/connect.c  |  6 ++++
 fs/cifs/misc.c     | 82 +++++++++++++++++++++++++++++++++++++++++++-----------
 fs/cifs/smb2ops.c  |  5 ++++
 4 files changed, 78 insertions(+), 18 deletions(-)


-- 
Thanks,

Steve
