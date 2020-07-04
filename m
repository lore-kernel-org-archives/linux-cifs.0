Return-Path: <SRS0=8YYZ=AP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F8AC433DF
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Jul 2020 03:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2BFA208C7
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Jul 2020 03:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCQdG3Sm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgGDDoV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jul 2020 23:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgGDDoV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Jul 2020 23:44:21 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0300EC061794;
        Fri,  3 Jul 2020 20:44:21 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y13so16316907ybj.10;
        Fri, 03 Jul 2020 20:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=yOpzu2a4BTeDbI4M3JEE9Dpc5QS3zg/zl2GIwbh4czo=;
        b=LCQdG3SmuHJBrZG2CCpfB02smzGeQvQYGKkMRJcPvA9WkmmmIoxEQc7SglHM7bW6rA
         NvXvrz+0EEq49zDX/Vxs04zvUszC61eIZHe8F0SVHUZISdtugsMJh7H3EVN2m/JBV8Dp
         F9mAJz0ktePlY4I8N+hUQ04RsXZSbXT3AXlZh1Me1+Aswd4wrxEiHXzT/nl6RTxfsTrz
         kgcus+FYmHKGjlkcWhYG+RlJ8hAgdqkQYE8ntnr2YyqltIVRkkaZ0AkWMk2o0Prc/CSb
         n4hqu8C+wl5Ob62cho6jTQ1I5RQ5+ZVFTCI5P/YHbGJenyBp2SmLEIb+OkasYac4+QpM
         5i9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=yOpzu2a4BTeDbI4M3JEE9Dpc5QS3zg/zl2GIwbh4czo=;
        b=qS4FGACHlb87F/pv9zsoEzxZhtCk/5WUyNo0opzv9xWMXzDKr+3qx6VSA6mNi1V29u
         hjvAl12YgDGxdsbNBcrxaCPcobA/eGirL8BU2wAfnACPS0H4/2NSYhAxkSuuzx/FZZc9
         XlTU/edl9+mBjT/uB5ij62M0PtDBmIVOJeQd9CPZ9z/lUalg5JbI/ynRkmo0R7sCDmUc
         IBLlPSbRPiBq3QPFzQHP4XlRQOUkdY65nAqci/UThbo7eTGvdVP7CV/yEHj4nBkjz9JF
         AoQQpN/r/uDkghPwSAF3v5jQLb8HGHV0AmcZD6k7wyhwjCUg7uCyndYe3NgzSHo/KYVM
         TZmw==
X-Gm-Message-State: AOAM533D2wnMVtnuvx+4CfSL9/Wb5RgJpQS00Pp78wpW8IxrdIb8706K
        WMpT80PnSkycC1SZgSdqyZSTFabml6Z0TEDNWD2hifc7
X-Google-Smtp-Source: ABdhPJwzp9uvAMJY4gSmmPjGFRYuQyjDwbG99DjKonKdkshT0ZIxPuEcaWCEhiam+4QgKud2rGM7x2Bnzp7az318Noo=
X-Received: by 2002:a25:bc81:: with SMTP id e1mr60463450ybk.375.1593834260097;
 Fri, 03 Jul 2020 20:44:20 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 3 Jul 2020 22:44:08 -0500
Message-ID: <CAH2r5msVSYHHt5y9eCrXJCBiNJEmpkVEF+iHuqTfsM9vQxw+5Q@mail.gmail.com>
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
9ebcfadb0610322ac537dd7aa5d9cbc2b2894c68:

  Linux 5.8-rc3 (2020-06-28 15:00:24 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc3-smb3-fixes

for you to fetch changes up to 19e888678bac8c82206eb915eaf72741b2a2615c:

  cifs: prevent truncation from long to int in wait_for_free_credits
(2020-07-01 20:01:26 -0500)

----------------------------------------------------------------
8 cifs/smb3 fixes, most for when specifying the multiuser mount flag,
5 of the fixes for stable.

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/364
----------------------------------------------------------------
Paul Aurich (6):
      cifs: Display local UID details for SMB sessions in DebugData
      SMB3: Honor 'seal' flag for multiuser mounts
      SMB3: Honor persistent/resilient handle flags for multiuser mounts
      SMB3: Honor lease disabling for multiuser mounts
      SMB3: Honor 'handletimeout' flag for multiuser mounts
      SMB3: Honor 'posix' flag for multiuser mounts

Ronnie Sahlberg (1):
      cifs: prevent truncation from long to int in wait_for_free_credits

Zhang Xiaoxu (1):
      cifs: Fix the target file was deleted when rename failed.

 fs/cifs/cifs_debug.c |  6 +++++-
 fs/cifs/connect.c    | 10 ++++++----
 fs/cifs/inode.c      | 10 ++++++++--
 fs/cifs/transport.c  |  2 +-
 4 files changed, 20 insertions(+), 8 deletions(-)

--
Thanks,

Steve
