Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF779C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 04:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE00361A10
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 04:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhJBEQk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 00:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhJBEQj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 00:16:39 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DF3C061775;
        Fri,  1 Oct 2021 21:14:54 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y26so46574853lfa.11;
        Fri, 01 Oct 2021 21:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=0WJaiEYp+rUFVijbsNLGZPoYyXIrZhECmke6cB+EHLE=;
        b=JLLgcOJql9BFUO11fNoaPnNwzIG5ERt684rmOcQcx2Yoc+k5umqIfUDcSKA4i7lON+
         YpwcUhAwa+LJaRh//uGU0oXqqIN4Cx2c/XeSP1h3f+KpuQ36NSZ5szLcMyLfIdRfTNd1
         tqFlg5oH+vvWjzdJxwFBsNBqr4gE82VQHTsKCx6LSCGNC+27h/Vq35dPfrf1lumvm4yt
         5M2kSQ3zK4SWUfLkQDxjZYhCzl5tqsTegjUC7LzB09sam/JaL9epyfdNE59YP6SYwf76
         FCNnb+nbol8jwoTyAj4UkrUuuM6RPWiayuPxohVo649vwGXoMuVXmQCWoo4+VViRX69s
         IR5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=0WJaiEYp+rUFVijbsNLGZPoYyXIrZhECmke6cB+EHLE=;
        b=leSpTiwHnFnOkvWN48o4pW5EW4aLZUFV4rUF6fq9H8+scZ8GuMmKo6FdVALMvQ8IGv
         DTzvXZEtE4AbWh43a1rJQ68YWZxyxo9g6MwwDhGz6f8Wl3JCN0scML+XLM4Z0RvT5apG
         fDO8v7PwvtbrCkLSPf/6bWLGm8SyyyyHhrbBf0dlRtupt6mOqEcx8u34D8unSO0E5E33
         I3ysTb3pvOVh9VrKwQXJROB+Lw5Rb6Y9rS+9ivztOaYJBqXhDoLLgSP+MYPTvFOPI0my
         AufDPknEBs1JohxTLvNalY2J4AHabpld8IloNlRn/r5W+y9TRx7d6bE4r2cZPxClslml
         vGAA==
X-Gm-Message-State: AOAM532MUBw1CoQ98bWpBD2GUDZ7o3uPO87J8E2eEwH2BF4PcjDGznZV
        VkvuUeyqu/6TJyL+xOMqxVQo1j+68lSlc9zRWcnr2yB0mA4=
X-Google-Smtp-Source: ABdhPJwXpVuG+z9GzMJhCk//keVhfxzfAdRkxNJ67wXuwQHzoMVoyK/eGjJ2OIBQkFYps6h/132rOeRqsFwxmoGes4w=
X-Received: by 2002:a05:6512:dd:: with SMTP id c29mr1799335lfp.601.1633148092435;
 Fri, 01 Oct 2021 21:14:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Oct 2021 23:14:41 -0500
Message-ID: <CAH2r5muy3GtTQPoaVXiD_tU-cG4FAQk4SCmmiR8vS4_pWvPanw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server security fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
5816b3e6577eaa676ceb00a848f0fd65fe2adc29:

  Linux 5.15-rc3 (2021-09-26 14:08:19 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.15-rc3-ksmbd-fixes

for you to fetch changes up to 87ffb310d5e8a441721a9d04dfa7c90cd9da3916:

  ksmbd: missing check for NULL in convert_to_nt_pathname()
(2021-09-30 20:00:05 -0500)

----------------------------------------------------------------
Eleven fixes for the ksmbd kernel server, mostly security related:
- an important fix for disabling weak NTLMv1 authentication
- seven security (improved buffer overflow checks) fixes
- fix for wrong infolevel struct used in some getattr/setattr paths
- two small documentation fixes

Regression test results from Linux client to current ksmbd:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/76
----------------------------------------------------------------
Dan Carpenter (1):
      ksmbd: missing check for NULL in convert_to_nt_pathname()

Enzo Matsumiya (1):
      ksmbd: fix documentation for 2 functions

Hyunchul Lee (1):
      ksmbd: add buffer validation for SMB2_CREATE_CONTEXT

Namjae Jeon (7):
      ksmbd: fix invalid request buffer access in compound
      MAINTAINERS: rename cifs_common to smbfs_common in cifs and ksmbd entry
      ksmbd: remove NTLMv1 authentication
      ksmbd: use correct basic info level in set_file_basic_info()
      ksmbd: add request buffer validation in smb2_set_info
      ksmbd: add validation in smb2 negotiate
      ksmbd: fix transform header validation

Ronnie Sahlberg (1):
      ksmbd: remove RFC1002 check in smb2 request

 MAINTAINERS              |   4 +-
 fs/ksmbd/auth.c          | 205 -------------------------------------
 fs/ksmbd/crypto_ctx.c    |  16 ---
 fs/ksmbd/crypto_ctx.h    |   8 --
 fs/ksmbd/misc.c          |  17 ++--
 fs/ksmbd/oplock.c        |  41 ++++++--
 fs/ksmbd/smb2pdu.c       | 256 ++++++++++++++++++++++++++++++++++++-----------
 fs/ksmbd/smb2pdu.h       |   9 ++
 fs/ksmbd/smb_common.c    |  47 +++++----
 fs/ksmbd/smb_common.h    |   8 --
 fs/ksmbd/smbacl.c        |  21 +++-
 fs/ksmbd/transport_tcp.c |   4 +-
 12 files changed, 294 insertions(+), 342 deletions(-)

-- 
Thanks,

Steve
