Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759C5C433DB
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Dec 2020 04:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D03F22AAA
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Dec 2020 04:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgLUEaB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 20 Dec 2020 23:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgLUEaB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 20 Dec 2020 23:30:01 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB649C061248;
        Sun, 20 Dec 2020 20:29:20 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id o19so20583617lfo.1;
        Sun, 20 Dec 2020 20:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JStI0xuBpGOpI7zOXq96FMvyiG0GeAUhmCc26uKz+8E=;
        b=nRKQkOkfpm0DSmD7tBUTQ5tj0sg5VPPkCpku0w8AzpGCblQeTcACj9XeFlfaaO/UQR
         /OXjLBElmt5NJRP9tCpa4h/L7C+hxsSiMH6yEj3IWwUxTtvUxleUri7SQGJoZEAdYtWs
         vFlawncSBfANYYsMoJwZiL/doP/4pwBPHXGsJJ/4F+/OhamMf+vDa99oPc31FoXsd0BO
         yW47vtAiIJ9I+EFM1KyEHQTo0O46nyGKW0zati+ddUmDaOh8pVm9VxhrR/gQ+dXghkHV
         yYhiS0pkkpgbuOcSaV3ZtjPzgcgNXpUozKJPy+w/hAEjm2BcI2h2wZIoGlGTEfhV06rs
         rpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JStI0xuBpGOpI7zOXq96FMvyiG0GeAUhmCc26uKz+8E=;
        b=SVQV2SZ9MUSE510l27LwpbN/nZ+CaIpKvM6FvQWEEVY33x9P2A81kBdBk3n6VKmQjV
         BhhT/na+79HaT26BsHvzFzOjk+xrlH+jOoh01mNyFn2In+kfJSVujg+P6FdxjXbTWdk+
         lqjG3JKVKmAaV32LlnKfsVFwk1tNRXDbdA688DDaXVo3cO0U7ESI5tCJUDUcqeNKzf2B
         AY7fUsXSK3Wdz+NlJvcS8wrcruHX+N6McnNxGBpugE2hfRfI8swDN8b1f9aeloj0DHw8
         d9zjqNlN7nGodvj1SwTn2p8Wc3gKEIq3bZE80epM6kr206gPbErpFy0CxsGO2RIQFsgp
         j+Kw==
X-Gm-Message-State: AOAM530TXt08ihiRzgvKbW0a4cMOAaX6CMWkY9mecPlWMrFOuWcMLtEU
        3BnHO7FKQ32xevespbZ3gr6pJKJBKncy67gA9bKwr/b/p+iChw==
X-Google-Smtp-Source: ABdhPJxoeUhcF3LxV/HGTKG2P5NAiDFsKLXfyLHX1HlUizxqRFhem4HsHZaTMLmk/1EKkKcyPvqoBI5T6HTvNxlTwpQ=
X-Received: by 2002:a2e:8eda:: with SMTP id e26mr5708607ljl.272.1608493663741;
 Sun, 20 Dec 2020 11:47:43 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 20 Dec 2020 13:47:32 -0600
Message-ID: <CAH2r5muaG6M=S-E5xXvTTVUJ4_gXR7MA_aDQfOqLprcWMbBYLw@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
e13300bdaa68f5487000e66baed1ff69bcb510bf:

  Merge tag '5.11-rc-smb3' of git://git.samba.org/sfrench/cifs-2.6
(2020-12-17 17:41:37 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc-smb3-part2

for you to fetch changes up to 9541b81322e60120b299222919957becd7a13683:

  Add SMB 2 support for getting and setting SACLs (2020-12-18 23:32:04 -0600)

----------------------------------------------------------------
Four small CIFS/SMB3 fixes (witness protocol and reconnect related),
and two that add ability to get and set auditing information in the
security descriptor (SACL), which can be helpful not just for backup
scenarios ("smbinfo secdesc" etc.) but also for improving security.

Testing results:
      http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/466
----------------------------------------------------------------
Boris Protopopov (2):
      SMB3: Add support for getting and setting SACLs
      Add SMB 2 support for getting and setting SACLs

Dan Carpenter (3):
      cifs: Delete a stray unlock in cifs_swn_reconnect()
      cifs: Unlock on errors in cifs_swn_reconnect()
      cifs: Re-indent cifs_swn_reconnect()

Samuel Cabrero (1):
      cifs: Avoid error pointer dereference

 fs/cifs/cifs_swn.c  | 73 +++++++++++++++++++++++------------------------
 fs/cifs/cifsacl.c   | 15 ++++++----
 fs/cifs/cifsglob.h  |  4 +--
 fs/cifs/cifspdu.h   |  2 ++
 fs/cifs/cifsproto.h |  4 +--
 fs/cifs/connect.c   |  1 +
 fs/cifs/smb2ops.c   | 35 ++++++++++++++---------
 fs/cifs/smb2pdu.c   |  7 +++--
 fs/cifs/smb2proto.h |  4 +--
 fs/cifs/xattr.c     | 81 +++++++++++++++++++++++++++++++++++++++--------------
 10 files changed, 140 insertions(+), 86 deletions(-)

-- 
Thanks,

Steve
