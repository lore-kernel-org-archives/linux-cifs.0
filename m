Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FE2C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 21:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 822B160F51
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 21:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhHMVl4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 17:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhHMVl4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Aug 2021 17:41:56 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A3BC061756;
        Fri, 13 Aug 2021 14:41:29 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id x7so17604982ljn.10;
        Fri, 13 Aug 2021 14:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=sYYIdI6NGktMgOa0nVbGx0tN6+SA51z6DngMRqcu1Zs=;
        b=BxjVkDS0Bsca6HzNPUcAA51px+6+RJ/W748R0JRZi0IomNy6JzukeY+qjdoumYcqlO
         GtPb5IJ7ztvAb2eBCJ73tX2h95kdCmVnV8fmYKtgig70TsHWb24c3ke/DGaYdjpqfriG
         DCy+p6T0aGIDAFngFI+TFoGv6psKpp36n+8NMKGrvtbPoSt+zrIp02YdlIi0vjzB2Sg9
         WYlIDgR0tlOBD9VCwToQb2gzbyB6ptFVpM+3RRHOQsiviWsHqgADhlXwpOt4GfAgmx5o
         4eXqmAYGGdHfuPb3efONfCJ6tbWSp/IcFjp9Rv/Nv2RnD7wq6Jy2+We5OBNFEHvaiv6x
         J5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=sYYIdI6NGktMgOa0nVbGx0tN6+SA51z6DngMRqcu1Zs=;
        b=iH6VSAFXmEuvRjbwOs6At3VoEQlKJOtCiBfHMr3g4H2uFIrQLP4s8gQpnzSoeD3+tW
         thcA6qwEXeAJiXzeM2C+EV5RDZC+95J/F+6iQK/FvzCXqrzd0bf1WdXhr9qBBmg4HjkM
         ZEaYtsBtJ3EAB6nBV++5I15mp84nv0t/ui4aI3hfvowMa7letwKzh3usG+g7GaUg7jkH
         6avK6BX2RWmh3RCxp6MPqfKeYebJRaA3YDFiFBgFVDroVQz6w+fxMzFIgJnd3/QsVtlf
         bSdDFVHp0AC3ObRo4ZgQ5MDK7yLZTQHf9GervJFg8MsnFmx9tNFd6j9Y4hXH7PP5Q/GN
         YLXg==
X-Gm-Message-State: AOAM5332m0N0Jz6hJIvvsL3K6I5Wk/i3wAuUTWZG1TgCyVtOs39R9GsS
        JrhoSCrcfRa2naukpSL8y2qH3gC1Pf0xQybL9jI=
X-Google-Smtp-Source: ABdhPJxFvh2hlY2UKYwo1noB2XP0kM8X0yeE73R9IY0JE9I9E+yERVVab6ALhP1OOrr4uykn1gzNtfuzNMnhLzmam7o=
X-Received: by 2002:a2e:a884:: with SMTP id m4mr3264976ljq.406.1628890886140;
 Fri, 13 Aug 2021 14:41:26 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 13 Aug 2021 16:41:15 -0500
Message-ID: <CAH2r5muFb-0+8EXCqBZ=sHCkrsna4+cQ9R1xVWEFHZd1Hogmhw@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
c500bee1c5b2f1d59b1081ac879d73268ab0ff17:

  Linux 5.14-rc4 (2021-08-01 17:04:17 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.14-rc5-smb3-fixes

for you to fetch changes up to 9e992755be8f2d458a0bcbefd19e493483c1dba2:

  cifs: Call close synchronously during unlink/rename/lease break.
(2021-08-12 11:29:58 -0500)

----------------------------------------------------------------
4 CIFS/SMB3 Fixes, all for stable,
- 2 relating to deferred close
- 1 for modefromsid mount option (when idsfromsid not specified)

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/769
----------------------------------------------------------------
Rohith Surabattula (2):
      cifs: Handle race conditions during rename
      cifs: Call close synchronously during unlink/rename/lease break.

Ronnie Sahlberg (1):
      cifs: use the correct max-length for dentry_path_raw()

Shyam Prasad N (1):
      cifs: create sd context must be a multiple of 8

 fs/cifs/cifsglob.h |  5 +++++
 fs/cifs/dir.c      |  2 +-
 fs/cifs/file.c     | 35 +++++++++++++++++------------------
 fs/cifs/inode.c    | 19 +++++++++++++++++--
 fs/cifs/misc.c     | 50 +++++++++++++++++++++++++++++++++++++++-----------
 fs/cifs/smb2pdu.c  |  2 +-
 6 files changed, 80 insertions(+), 33 deletions(-)

-- 
Thanks,

Steve
