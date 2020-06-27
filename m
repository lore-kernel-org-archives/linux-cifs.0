Return-Path: <SRS0=/h7V=AI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4182DC433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Jun 2020 20:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0BE2070A
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Jun 2020 20:11:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZhvRa4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgF0ULO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Jun 2020 16:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgF0ULO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 27 Jun 2020 16:11:14 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5701EC061794;
        Sat, 27 Jun 2020 13:11:14 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id k18so6249993ybm.13;
        Sat, 27 Jun 2020 13:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=u6NosTHu2/5ysLr4vMvB6bDd6QZWpGij0f8MuuSmU5Q=;
        b=mZhvRa4ZVwifZ6UvV+5LIpz5STIWUpGV8OAmL7410umETP63mUuvQX0LsAYe4jvdQ2
         YVOXg6IC6s0fiQycMIZeGUkTCgNdLGEEDhNMitVK3BlDp99xpWubw1nM89tb+YzqudpM
         NKGEwmBr7kpcrQg2O7J3mg1WK87YmEJmnZp7FVpTo1VmjKWe3oZ0YTbYsabfbjq9T9rk
         96AFuLEPPWZNe3szkIreuJmT4NlZcPvLC4pszbvnlf4Q0UJWt7DzSMwMmfiUD0XbBjJf
         OW9E3LLEnMqB6KPuf7Ri5r6tvJG6sMFkomHCcUSCfAtEyp4Cc+V2klZqEX49Pk9d1tf/
         k+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=u6NosTHu2/5ysLr4vMvB6bDd6QZWpGij0f8MuuSmU5Q=;
        b=SvSukpn1eQ7jAbnRgfM2D8hVZ99jn+li78p6E4nzUr2nDFUOwKI7U/FQ41lms8vRbm
         AG+zlHsp/vRD9lEq77leIhUMFJHqWE+v4PJWkdQUQ3qPYiCbdMc6O1PjAnPJSKYuIAdL
         7fFub8MN6DHnl0ubvEyFDNDqBReRhsNtv5zNHunSxNEoHlp9GpkculV6ti/rvb4WGXsR
         8Gcums5ouk0EiyuRPCA6Rm7owXzqY2oLm/ztQGnz2F1CRr3esQYNLjQZmalXHcU5Px3y
         5VZ/38cx+Rcth3jYXD/MBvvr+Nn/Vczto56f3dq07iz2R3eOT0uBQQkAYNlIruXbrijl
         KOfQ==
X-Gm-Message-State: AOAM532RHf9JkGyJao9gjHbUkEBlMjxqRSS7rBBrf7tCNGj1moa1Jw5F
        hFEp17LIV200oBLYhMPOhOvvLaLXSK1gXuyMmIbG1caO
X-Google-Smtp-Source: ABdhPJwq+4PQ9Bouf02cflVm6duDxDCZdak3SDy+S7iznVm132VXtFHypRquARAz7uu+s6EMfqlNbD7bbUqmMAWGRro=
X-Received: by 2002:a25:3bd8:: with SMTP id i207mr14483571yba.167.1593288673051;
 Sat, 27 Jun 2020 13:11:13 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 27 Jun 2020 15:11:00 -0500
Message-ID: <CAH2r5mseacQ-UN7HB8U3KWcJFO5yciGMFPBYLw2GwqhWRD43Xg@mail.gmail.com>
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
48778464bb7d346b47157d21ffde2af6b2d39110:

  Linux 5.8-rc2 (2020-06-21 15:45:29 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc2-smb3-fixes

for you to fetch changes up to bf1028a41eaf0ce39518cbdda34cdb717f16364a:

  cifs: misc: Use array_size() in if-statement controlling expression
(2020-06-23 19:06:27 -0500)

----------------------------------------------------------------
6 cifs/smb3 fixes, 3 for stable.  Fixes xfstests 451, 313 and 316

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/360
----------------------------------------------------------------
Gustavo A. R. Silva (1):
      cifs: misc: Use array_size() in if-statement controlling expression

Xiyu Yang (1):
      cifs: Fix cached_fid refcnt leak in open_shroot

Zhang Xiaoxu (4):
      cifs: Fix double add page to memcg when cifs_readpages
      cifs/smb3: Fix data inconsistent when zero file range
      cifs/smb3: Fix data inconsistent when punch hole
      cifs: update ctime and mtime during truncate

 fs/cifs/file.c    | 11 +++++++----
 fs/cifs/inode.c   |  9 +++++++++
 fs/cifs/misc.c    | 16 +++++++---------
 fs/cifs/smb2ops.c | 12 ++++++++++++
 4 files changed, 35 insertions(+), 13 deletions(-)


--
Thanks,

Steve
