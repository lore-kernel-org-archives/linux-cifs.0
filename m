Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811E1C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Nov 2021 22:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhKSWsZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Nov 2021 17:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhKSWsY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Nov 2021 17:48:24 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54647C061574;
        Fri, 19 Nov 2021 14:45:22 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id z34so49889371lfu.8;
        Fri, 19 Nov 2021 14:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=o7PYM/POMbkFgEGERrs2p7W3SneqKePL4lTZvoe08Z8=;
        b=Osl++2pU3nmCqKLS9ZQ4VEWQfNqhTJSFdbJyNwVPjbWj65h6e6RfKErYieBsWrgMVs
         ha2hty2KuGqmhmrkq/u1OQFPyWB70KZcTBipol5o/HAsseldc+c5sqNEJ5hJi4SuxmD6
         qE4p9+1eLBMZPZBnsPDtg/0p9NJOIRkLNbyc5QfpIOImKMGwZzQDDDOhBfOXhGj4xI+W
         GwJSXQNAKp5mC5GyOQVue31tyo7Ls2CFQ7EKYYrJTkzVW1yBEjoeBqJBY21oBpiZGT2D
         salsC51lehz7WrlXRTaSuXU3Bgqr9JN5/2oKuyWfYHT/qlvh5c+VXmtLLyQBN/N3IQJH
         GDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=o7PYM/POMbkFgEGERrs2p7W3SneqKePL4lTZvoe08Z8=;
        b=1A9/+dQGqLJl2qFFVWoEMwHd9arE9fIO/WlK0e2IclUQ9KvCaSbAUqYwc131rbqPgn
         0z1sp4fLH1wU/0mmBpwwUn9mWf2oV27ed2hP9d3S3KYZwFNkTOCCjx5fBA18NBDSQKws
         M5N0YXn0J74jixk7lYgww2QpyFf9aOTOyhdGCKUt+6+LeOtKVvuERyajabiSvChco3Mt
         cfIzg7wW2oHkoz/mRLa7Iu17QZtFdrIjIRI5y0erZ5nuz5IyilgI7sQU/tYYmNor+uI8
         Wef3v2YFFp+z1cpPWhGng3B/hdi0kofpFK5XAubNZPTTBYrPg1KcFC0WxUpsidJ3GTIv
         tGew==
X-Gm-Message-State: AOAM533JFwRqvMFOdD+ozwnSGLEgp9B0i1da/WNeErR0MUbaGoB0hy8D
        vs2MYYeSoS9gyZUAhqQzLfc6R5UVxAsMfdLDGxaaO50ehss=
X-Google-Smtp-Source: ABdhPJxj9TeKK9B1GEIJRFMDCiHXuFlBaMXlL0gQpCE42FL9om5buBHV0MhrUIk8bHjLnE0q377W+L99K7P7Odc4WI4=
X-Received: by 2002:a05:651c:154a:: with SMTP id y10mr28536808ljp.314.1637361920656;
 Fri, 19 Nov 2021 14:45:20 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Nov 2021 16:45:10 -0600
Message-ID: <CAH2r5mvH+e=5dxKsmnKVYttaQk=7u+KO0uucQ+z4fxH9RemwhQ@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:

  Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc1-smb3-fixes

for you to fetch changes up to 8ae87bbeb5d1bfd4ddf2f73f72be51d02d6be2eb:

  cifs: introduce cifs_ses_mark_for_reconnect() helper (2021-11-16
10:57:08 -0600)

----------------------------------------------------------------
3 small cifs/smb3 fixes, 2 to address minor coverity issues and one cleanup

----------------------------------------------------------------
Paulo Alcantara (1):
      cifs: introduce cifs_ses_mark_for_reconnect() helper

Steve French (2):
      cifs: move debug print out of spinlock
      cifs: protect srv_count with cifs_tcp_ses_lock

 fs/cifs/cifs_swn.c  | 16 ++--------------
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/connect.c   | 16 +++-------------
 fs/cifs/dfs_cache.c |  7 +------
 fs/cifs/sess.c      | 15 ++++++++++++++-
 5 files changed, 21 insertions(+), 34 deletions(-)


-- 
Thanks,

Steve
