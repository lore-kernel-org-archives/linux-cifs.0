Return-Path: <SRS0=VDKF=6D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90105C38A30
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Apr 2020 12:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D9382137B
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Apr 2020 12:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/45LPFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgDSMuS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Apr 2020 08:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSMuS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Apr 2020 08:50:18 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85389C061A0C;
        Sun, 19 Apr 2020 05:50:18 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h205so3798967ybg.6;
        Sun, 19 Apr 2020 05:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AYt+mcQK2IJWTQzel0XUtUuuyfI4ZyCNH2D6GWZFNLQ=;
        b=C/45LPFFt2lRvdCPuYYqsGrhrJ/ZHx5w8Nd52F3HprUEMnKgfqCKZ3QfQCkFdsIyWM
         kc5QmbreqqJnkjdUKFX7ihj68kt061NltpxB6g7YE4dFephkO6IOQFJoXF441Ej6tnM4
         3dlpS4nJNUOk8Hr3vRzach1oD0o7DI6/upSHKxN1WGVkc5KnZElHhbdmhMYUyx7Ian5I
         XJkUX6Wc2UlTjNtGPFlVuNbYczOdSTEELb1wywkcbRiCZo9ekXgGnfT1wlB3CJlVd/yy
         arpV2YHE/A6TGeledwjsmX4vqFDCX6J54LMxYe0yBfGjqoBVusWjaGLe68exkDG0H+Xc
         zFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AYt+mcQK2IJWTQzel0XUtUuuyfI4ZyCNH2D6GWZFNLQ=;
        b=AoA4wR2RDZxlpcoFFDSD0zi5VIj0Pag3woEyZVAEc6WeWdZNARYEKthsO4tGCTUiVm
         X5cXmMLhmqBsVI5ovSsOLFa2QwXuX3RT8CWeQCjGkDwABeLc4aQyvHqIh9y2lILrhJ1N
         YzEqO0cynHyGKH01PCMwh/5fYJ7dKRu8sWPyRhu9HGuDPoYUvm4fQTXCvzmjwT3Dd1Ca
         +d5bha0NLQUb7GSawFCN7RARUqMgtkjHmW0aDhOUgBj/mb7+NEdoZDp5/VnNIlER+AcV
         LItiZEcx/POJ0doifc+idbGj1tXj6LjnnDGJ1M4bA67Ob07tAXY5hA2jMiYOWBvRlgkp
         HTTQ==
X-Gm-Message-State: AGi0PuZi/eC/Q8bQZrX9TvL9FSDFI6IB1gn9+FtFDD1Tq1M6i3HjN8R6
        FvYi5rYSpHM9ebRZzJLhp162dyNe5inOD0yeP1WMRMGAauE=
X-Google-Smtp-Source: APiQypL72IVkN6YwuUw+F1LAbcj0ToNYBky9jYSMV4eFnc3omYOfijnKH7ZaDI1B66ZOTfCOX/K3qM9L0LbpaoYIiiE=
X-Received: by 2002:a25:aa0c:: with SMTP id s12mr11835570ybi.183.1587300617572;
 Sun, 19 Apr 2020 05:50:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 19 Apr 2020 07:50:06 -0500
Message-ID: <CAH2r5mu13W-JJoTRnoDTBnPTRjOLRqbDdTeK6NfrfAFS7f+Rbw@mail.gmail.com>
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
8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc-smb3-fixes

for you to fetch changes up to 9692ea9d3288a201df762868a52552b2e07e1c55:

  smb3: remove overly noisy debug line in signing errors (2020-04-16
12:23:40 -0500)

----------------------------------------------------------------
Three small smb3 fixes: two debug related (helping network tracing for
SMB2 mounts, and the other removing an unintended debug line on
signing failures), and one fixing a performance problem with 64K pages

Regression testing results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/344
----------------------------------------------------------------
Jones Syue (1):
      cifs: improve read performance for page size 64KB & cache=strict
& vers=2.1+

Ronnie Sahlberg (1):
      cifs: dump the session id and keys also for SMB2 sessions

Steve French (1):
      smb3: remove overly noisy debug line in signing errors

 fs/cifs/cifssmb.c       |  4 ++++
 fs/cifs/inode.c         |  2 +-
 fs/cifs/smb2pdu.c       | 15 +++++++++++++++
 fs/cifs/smb2transport.c |  4 ++--
 4 files changed, 22 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
