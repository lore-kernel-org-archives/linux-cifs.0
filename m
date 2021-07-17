Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45134C12002
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Jul 2021 00:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29113613EB
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Jul 2021 00:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhGQAUM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Jul 2021 20:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhGQAUM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Jul 2021 20:20:12 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EBCC06175F;
        Fri, 16 Jul 2021 17:17:15 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u14so16388481ljh.0;
        Fri, 16 Jul 2021 17:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JePf1Btub1hmfZtg+ClXKQX7N/9PGylpCuoeIso+ePM=;
        b=H0gbpzrHx9SMTN5EYuV/bld18qmBOGTajfMWX1GXfhRgAzPvaVqh+aIhBlATGxRd2Y
         CtdwW6E4JViC9uO+EZXiuOyoIdpSxIARGb+Oc3kUOMzp6DE9lzn9PvQW8ZSHAOGObFh3
         aapS6VDJWEtf6iXmeiPH/Eou+79B0D9GMI0bX4U5GIpYmSfQKprKjJd0Mk7crUJd6CCD
         5CMX1LGiuQBm6ITSlY0HsB1NumNF9hjTF4Xf0kpxaDLiv3TKjoq8nByXZrwkLDHJdxFy
         4wcM8mOvxSu3WAKAm13977N9UEVa1R3I/EunvaU1sR+CDYD3MuBZZAiy6JsnLZg+uPt1
         HyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JePf1Btub1hmfZtg+ClXKQX7N/9PGylpCuoeIso+ePM=;
        b=kryA0H9r8agN1mXwqYNZxb1vDnArraEXTWhKHhyX/ExDdcAEDWrqzR8Stj/EfNtjXj
         uBO0oN2XQOo+befoAhptkPJohHfR5w3pgs16friDnfXaydVXPjoiGXE2jakeXJ6xnVnf
         08x4P9m8VnbGyqVGyPVW4l0T5b/tl4jI6oFRxM/c9zOUlj544UWdAFRcoLmEGffJcWZl
         dZAPbWvAYBqH80RN7X2zGQ8Vjq3j0kiRDAWggaqs67Si7TNCPgC0uGxTFpawFyiAIhE2
         1B5tkFRFx1tPoid9srUw0ibjWkbdTLX8zeNlx7V+uxt509JGW1TClUzgkBktRGX+/kmb
         oQcg==
X-Gm-Message-State: AOAM531T2XP00uQfJ4D/Dj3Ouf1vBCJdYMdZeCvR+tfSh+iNGQp6sEwv
        LOBZcnM6ptd7N9r6kmp0chZ/wFGjzZ3Z/X0eri8BwxcXDFXW+w==
X-Google-Smtp-Source: ABdhPJy7jRzCFQdpnD68cle1KlIa35M3MgIxukXoVxNWlz9ZDeSJL34eiGxifI7eFlgLHlGQtu2b/GqAf4FN0cK/4uA=
X-Received: by 2002:a2e:901a:: with SMTP id h26mr11010063ljg.218.1626481033816;
 Fri, 16 Jul 2021 17:17:13 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 16 Jul 2021 19:17:01 -0500
Message-ID: <CAH2r5munsckwgOj8BknkB1pu+oktLTDJA8hN1cHbDucQXVJ2Nw@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
e73f0f0ee7541171d89f2e2491130c7771ba58d3:

  Linux 5.14-rc1 (2021-07-11 15:07:40 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.14-rc1-smb3-fixes

for you to fetch changes up to cdc3363065aba2711e51019b3d5787f044f8a133:

  cifs: do not share tcp sessions of dfs connections (2021-07-16 00:21:47 -0500)

----------------------------------------------------------------
8 cifs/smb3 fixes including 3 for stable
3 DFS related fixes, and two to fix problems pointed out by static checkers

Still testing a set of important multichannel fixes which are not
included in this

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/730
----------------------------------------------------------------
Hyunchul Lee (1):
      cifs: fix the out of range assignment to bit fields in
parse_server_interfaces

Paulo Alcantara (2):
      cifs: handle reconnect of tcon when there is no cached dfs referral
      cifs: do not share tcp sessions of dfs connections

Ronnie Sahlberg (1):
      cifs: Do not use the original cruid when following DFS links for
multiuser mounts

Shyam Prasad N (2):
      cifs: use the expiry output of dns_query to schedule next resolution
      cifs: added WARN_ON for all the count decrements

Steve French (2):
      cifs: fix missing null session check in mount
      SMB3.1.1: fix mount failure to some servers when compression enabled

 fs/cifs/cifs_dfs_ref.c |   6 +++++-
 fs/cifs/cifsglob.h     |   7 +++++++
 fs/cifs/connect.c      | 110
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/cifs/dns_resolve.c  |  10 ++++++----
 fs/cifs/dns_resolve.h  |   2 +-
 fs/cifs/misc.c         |   2 +-
 fs/cifs/smb2ops.c      |   6 ++++--
 fs/cifs/smb2pdu.h      |   1 +
 8 files changed, 124 insertions(+), 20 deletions(-)


--
Thanks,

Steve
