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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A97C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Feb 2021 06:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EC9C64E02
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Feb 2021 06:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhBZGZJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Feb 2021 01:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBZGZI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Feb 2021 01:25:08 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EAEC061574;
        Thu, 25 Feb 2021 22:24:27 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id k12so335900ljg.9;
        Thu, 25 Feb 2021 22:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=60b0NKkE4IS8WeqdaHkGZTCzE12kooB885932AJOIEs=;
        b=e0HslaQ/AwybaSkuUGc4MCNSabaipnTeaWgkptSLNoI23I/B02uWKSUlGXQtnmHVr4
         LWl/I6mB2KtL+Ko1akrg88baTFREWLbJ7AQD4963YFVeN/1ClIL5GACxw6nvKHEc7yz9
         unAEPOGbXx7w97yOTUzJ8ef2WMjvzLtlmmgiIj7R1H9B9AUjYhJhhykxNthf8CM4RdKZ
         uWR5E0Hn39JlGBRbkuVU1TKjAoFYBDdYIpFRpBZSePOORNyi5/85ZsWsdGfbYCT+5Ajg
         /v1cfycqGeSTTzlyxXDG+cnoUoL2oQ4RWfuJbnvn68KOlES552MC9AZOM8Yp44Cd6hmz
         FhHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=60b0NKkE4IS8WeqdaHkGZTCzE12kooB885932AJOIEs=;
        b=lUiREfqWi2pxCDKIhm0bHjGVh5m7YfldWEgyEwE/6gXGxpAU29/orCYkTBTn4BP7oH
         fPduqJwlFVoTugP/97ZciUaprpL2BI9KStqMpHbE09jZF2QsmwAl260lcgq8QtsLvDqs
         ZJx3N3IKgKZnd8J72lSyQXlVXgmA+3MPzw0CWw503aGcc/iOKHAC5ucoSxVJ7neWuzS0
         vJn7Wj5ol+SFdt9saS1O3oFw31L3dJBjCWQV3GCteRVKrZLoZysogp2+FwYYEysF7NN3
         6gKB5//nMZ06FSK0NSlrQWfr/Nb74Qk1A2XLu4WUhiAPEDxN8Z96n3B5k/Bp3ESkgpbE
         6TRw==
X-Gm-Message-State: AOAM531keOnM513YrIEvFI8YDyFj1XbKkaCrvRmp1NYbWHsjTZX9WnPJ
        bsEeycVREIJEI4rpVg295Q0jJDVSGTdwg1XZCqitko/Cacg8Hw==
X-Google-Smtp-Source: ABdhPJwVaa3LlpORKZNkzn5nWVM2AUd3+dpl+2M9SnGBqMSL1kCpT7MHNsEwt4+VcUNI36PLLQcCVl3bwYG4sFETseQ=
X-Received: by 2002:a05:651c:548:: with SMTP id q8mr803473ljp.256.1614320665499;
 Thu, 25 Feb 2021 22:24:25 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 26 Feb 2021 00:24:14 -0600
Message-ID: <CAH2r5mudreWgQdGQPSn++0H6zzY-3fcCZvxga7PcNqt4EDWo9Q@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
f40ddce88593482919761f74910f42f4b84c004b:

  Linux 5.11 (2021-02-14 14:32:24 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-smb3-part1

for you to fetch changes up to 8369dfd7841e70711c53a065ffb8029f24520200:

  cifs: update internal version number (2021-02-25 19:08:11 -0600)

----------------------------------------------------------------
cifs/smb3 fixes:
    - improvements to mode bit conversion, chmod and chown when using
cifsacl mount option
     - two new mount options for controlling attribute caching
     - improvements to crediting and reconnect, improved debugging
     - reconnect fix
     - add SMB3.1.1 dialect to default dialects for vers=3

Still working on a security fix and some multichannel fixes which are
not included in this pull request

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/513
----------------------------------------------------------------
David Howells (1):
      cifs: use discard iterator to discard unneeded network data more
efficiently

Paulo Alcantara (4):
      cifs: fix nodfs mount option
      cifs: fix DFS failover
      cifs: check all path components in resolved dfs target
      cifs: introduce helper for finding referral server to improve
DFS target resolution

Rohith Surabattula (1):
      TCON Reconnect during STATUS_NETWORK_NAME_DELETED

Ronnie Sahlberg (1):
      cifs: fix handling of escaped ',' in the password mount argument

Shyam Prasad N (8):
      cifs: New optype for session operations.
      cifs: Fix in error types returned for out-of-credit situations.
      cifs: Identify a connection by a conn_id.
      cifs: Reformat DebugData and index connections by conn_id.
      cifs: Fix cifsacl ACE mask for group and others.
      cifs: Retain old ACEs when converting between mode bits and ACL.
      cifs: Change SIDs in ACEs while transferring file ownership.
      cifs: If a corrupted DACL is returned by the server, bail out.

Steve French (11):
      smb3: negotiate current dialect (SMB3.1.1) when version 3 or
greater requested
      cifs: fix trivial typo
      cifs: documentation cleanup
      cifs: change confusing field serverName (to ip_addr)
      cifs: clarify hostname vs ip address in /proc/fs/cifs/DebugData
      cifs: cleanup a few le16 vs. le32 uses in cifsacl.c
      cifs: minor simplification to smb2_is_network_name_deleted
      cifs: Add new mount parameter "acdirmax" to allow caching
directory metadata
      cifs: convert revalidate of directories to using directory
metadata cache timeout
      cifs: Add new parameter "acregmax" for distinct file and
directory metadata timeout
      cifs: update internal version number

YueHaibing (1):
      cifs: Fix inconsistent IS_ERR and PTR_ERR

 Documentation/admin-guide/cifs/authors.rst      |   6 +-
 Documentation/admin-guide/cifs/changes.rst      |   5 +-
 Documentation/admin-guide/cifs/introduction.rst |  30 +-
 Documentation/admin-guide/cifs/todo.rst         |  34 ++-
 Documentation/admin-guide/cifs/usage.rst        |   2 +-
 fs/cifs/cifs_debug.c                            | 121 ++++----
 fs/cifs/cifs_swn.c                              |   2 +-
 fs/cifs/cifsacl.c                               | 379 +++++++++++++++++++-----
 fs/cifs/cifsacl.h                               |   4 +-
 fs/cifs/cifsencrypt.c                           |   6 +-
 fs/cifs/cifsfs.c                                |  15 +-
 fs/cifs/cifsfs.h                                |   2 +-
 fs/cifs/cifsglob.h                              |  11 +-
 fs/cifs/cifsproto.h                             |   2 +
 fs/cifs/cifssmb.c                               |   6 +-
 fs/cifs/connect.c                               | 301 ++++++++++---------
 fs/cifs/dfs_cache.c                             |  33 ++-
 fs/cifs/file.c                                  |   2 +-
 fs/cifs/fs_context.c                            |  75 +++--
 fs/cifs/fs_context.h                            |   6 +-
 fs/cifs/inode.c                                 |  23 +-
 fs/cifs/sess.c                                  |   2 +-
 fs/cifs/smb2ops.c                               | 109 +++++--
 fs/cifs/smb2pdu.c                               |  22 +-
 fs/cifs/trace.h                                 |  36 ++-
 fs/cifs/transport.c                             |  63 ++--
 26 files changed, 883 insertions(+), 414 deletions(-)

-- 
Thanks,

Steve
