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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF77C433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 01:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D300F610A8
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 01:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhDIBsl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 21:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIBsk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 21:48:40 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35939C061760;
        Thu,  8 Apr 2021 18:48:28 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id r8so7085828lfp.10;
        Thu, 08 Apr 2021 18:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=6NgfgA0s6MnBhC/H7IGMsvIcqRpCu3I9s/mh+o4Drj0=;
        b=tHrgO2/8ybnJ+o1Gqs6ygkjQfj37V9yixDpht/Ts3/v7tjPIQgxd0Nn0JkkTPcXRJm
         tzgmhNfuUyOB1N5ShOgOmhX0i1a8ZU7ukw0Qe4csS6VsUWvmfN8YIXgOoeQFtiZtyRs9
         rifGvUyOQXjKQU/9tD99pjiMngB6VvQyhWmlsFz1I1cWrQ4p1O98i7zDnlAasEnxo226
         zqRKGuUexj5J9/ZY+ZW+zc1D7MZpZVuQrMsnye/KVQrXheucuYBwd/JSLKnyjq5vIQ7B
         IZPnbvsc42fec2xlhM9RwxXhT5tinmdxXYS5oZwnYvtB7PuKgVJVHgcve55FduMpFz7g
         Y+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=6NgfgA0s6MnBhC/H7IGMsvIcqRpCu3I9s/mh+o4Drj0=;
        b=a5BUvVsSY6DYU9Bf3+YORgwbf3PS950zCYDVZSo1MsJAD6XzsFo1RK8h+VPKe3WNDs
         6JL1OSvgaxntbqJXecSc6NrUxkaMfeftyiVjx76jUXZOGcYvb246QRvXjYHRU6XFYDY1
         g2wRIZOQfnU3jjZ7PTDZL1PsEfz7fqZI8BRbTz4o7T8W4igfe5IQVTU7weNuNCUaPYGi
         mHj2HJHYYeJOvUYHV6CJqNRNEg5T15o3F+PEupB6VyDERw0Pm9zicYY5szpmuu/x7PQg
         3k0c1GZM+rgc3ClRKYp737u2a09aztJI0YwbWYvtGdeYUW/RseV2MTTImrYnbDOGimIa
         qB3Q==
X-Gm-Message-State: AOAM531zLDQDaOdS+GGFXCJJOhvNnMZyD8dzo8NId1KfvbX+egomxmyi
        y9pkWWCWvetebef4/CzeicHwymXpUzQgapVIGCrJU9WURm3u2w==
X-Google-Smtp-Source: ABdhPJzL8DeK8OBPYhib6hxQbq6JW02KcvjegbpLKhnUwB0uxSd6hfpXxpJ+LRkx974hjYZDKCGuN5Cj9J30rvCWtB8=
X-Received: by 2002:ac2:4148:: with SMTP id c8mr8094436lfi.307.1617932906642;
 Thu, 08 Apr 2021 18:48:26 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 20:48:16 -0500
Message-ID: <CAH2r5mvZEvGskzcrcd=PbQ7zqAyH0=uDyvVG7vu9XEPM7qJLHA@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
e49d033bddf5b565044e2abe4241353959bc9120:

  Linux 5.12-rc6 (2021-04-04 14:15:36 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc6-smb3

for you to fetch changes up to 0fc9322ab5e1fe6910c9673e1a7ff29f7dd72611:

  cifs: escape spaces in share names (2021-04-07 21:30:27 -0500)

----------------------------------------------------------------
3 cifs/smb3 fixes, 2 for stable, includes a reconnect fix (for case
when server address changed) and fix for proper display of devnames
(when have space or tab).

Test results: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/550
----------------------------------------------------------------
Maciek Borzecki (1):
      cifs: escape spaces in share names

Shyam Prasad N (1):
      cifs: On cifs_reconnect, resolve the hostname again.

Wan Jiabing (1):
      fs: cifs: Remove unnecessary struct declaration

 fs/cifs/Kconfig    |  3 +--
 fs/cifs/Makefile   |  5 +++--
 fs/cifs/cifsfs.c   |  3 ++-
 fs/cifs/cifsglob.h |  2 --
 fs/cifs/connect.c  | 17 ++++++++++++++++-
 5 files changed, 22 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
