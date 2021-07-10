Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F273C07E95
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Jul 2021 17:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F42C6135D
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Jul 2021 17:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhGJRZK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Jul 2021 13:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhGJRZK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Jul 2021 13:25:10 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775E7C0613DD;
        Sat, 10 Jul 2021 10:22:24 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id i5so948705lfe.2;
        Sat, 10 Jul 2021 10:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=6YX7n/0G7hjYNnCmuOR6k6VICUFdkr2zTrzlk9Tos1U=;
        b=CJLAAN46ROcQlzXm7xWXow9DZq+yH8Vd+9w8njKP/9VsFwMIW3IRQR7ZxeOYbZ+AGm
         ttd55Br6bAsQC4JACj2QCrfSXqHEOzRdQUCS2swCO1zQbwWaiIB7Uf7DrICQgFixC0+f
         lrZp/B1UpZkF+8pXGwupE+Z9m6fInCUiKiOG4QJWVAMxczF4q0UYDbbyFA20ESPTuEXq
         jdvXqVPOPIZLHcRSLZZy5Lle6lnw8DFrJB6+1TaO+jKuzOt5PEGUA8sNkm5EvdnocE0/
         LQlhk9wJgzRqz3hX/mhJ9bAv1eLcqRkkoO3d9LfIOz7vqiSGJeDfPsusisMreJifLKU0
         zahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=6YX7n/0G7hjYNnCmuOR6k6VICUFdkr2zTrzlk9Tos1U=;
        b=tiMKIVh7FV4q1gJcK33EQ5A3UFigZXZu7rOEFR2SsL1zzsDC3tzoYGBfUfgw6qt9kz
         47Ni9oVsPVkZmTMeJ9uu+PHbgg4+mYZeqw6MfdVzMhVc43oQmsAnxQBHJ/s1sqWJXex5
         39iXm6iaXxq0F3mpVIfyFD+Wef/b13qScU33z4xDUWSfqdtXLp0v+pTE0lkWEIn2DbHZ
         HyeTg9+cVctbjjk/bnmCekFj4wKTAmopxhxyX4PG9B3yj9+yJRhws6zFuJ+2kB4Foyjl
         BKC1Fi0nGMlFWJ+vymLIzYE7UCIeLlrgU9E83SI+1A+ylyMB+y2zsVF0KEj9VCp2uQ1e
         LeOw==
X-Gm-Message-State: AOAM531wUEchj8cH2JE3QTP3y+6Hq/llwuaEu/ALQQBRLB5JKhnoSsuM
        YpjqfAkpH0O6lFW/7Xyh7nzbxE2Ri20LaDrT3Bw=
X-Google-Smtp-Source: ABdhPJzbcOMG6AdlkGtbwFYxCcKvszc68f7rW1yUk/AFG9a313SUewlr2zAuBKWANS1n6ihBAOirqCs4Cm1LPg/TUWM=
X-Received: by 2002:ac2:5149:: with SMTP id q9mr34423098lfd.313.1625937742681;
 Sat, 10 Jul 2021 10:22:22 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Jul 2021 12:22:09 -0500
Message-ID: <CAH2r5mvVySsTqqQfzZ0q9kR5qmYvmCTf_sybHLWw2UtnPAKpSA@mail.gmail.com>
Subject: [GIT PULL] CIFS Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
bbd91626f71c1582301044f5942751eeb4ca98ba:

  Merge tag '5.14-rc-smb3-fixes-part1' of
git://git.samba.org/sfrench/cifs-2.6 (2021-06-29 20:18:16 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.14-rc-smb3-fixes-part2

for you to fetch changes up to 4d069f6022e938bc51667da637f2483a37a77e19:

  cifs: update internal version number (2021-07-09 13:03:36 -0500)

----------------------------------------------------------------
13 cifs/smb3 fixes. Most are to address minor issues pointed out by
Coverity. Also includes a packet signing enhancement and a mount
improvement.

There is an important set of multichannel fixes still being tested
which is not included yet.

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/711
----------------------------------------------------------------
Paulo Alcantara (1):
      cifs: prevent NULL deref in cifs_compose_mount_options()

Ronnie Sahlberg (1):
      cifs: use helpers when parsing uid/gid mount options and validate them

Steve French (11):
      cifs: make locking consistent around the server session status
      cifs: clarify SMB1 code for UnixCreateHardLink
      CIFS: Clarify SMB1 code for UnixCreateSymLink
      CIFS: Clarify SMB1 code for UnixSetPathInfo
      smb3: fix typo in header file
      CIFS: Clarify SMB1 code for SetFileSize
      CIFS: Clarify SMB1 code for delete
      CIFS: Clarify SMB1 code for rename open file
      CIFS: Clarify SMB1 code for POSIX Lock
      SMB3.1.1: Add support for negotiating signing algorithm
      cifs: update internal version number

 fs/cifs/cifs_dfs_ref.c |  3 ++
 fs/cifs/cifsfs.c       |  4 +++
 fs/cifs/cifsfs.h       |  2 +-
 fs/cifs/cifsglob.h     |  6 +++-
 fs/cifs/cifspdu.h      |  1 +
 fs/cifs/cifssmb.c      | 24 ++++++++------
 fs/cifs/connect.c      |  5 +++
 fs/cifs/fs_context.c   | 24 +++++++++++---
 fs/cifs/fs_context.h   |  1 +
 fs/cifs/smb2pdu.c      | 85 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/cifs/smb2pdu.h      |  7 +++--
 fs/cifs/transport.c    |  2 ++
 12 files changed, 135 insertions(+), 29 deletions(-)

-- 
Thanks,

Steve
