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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50914C2D0E4
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 22:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1FD0206FB
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 22:00:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6Q2YBj9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbgKXWAY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Nov 2020 17:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731696AbgKXWAY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Nov 2020 17:00:24 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994E0C0613D6;
        Tue, 24 Nov 2020 14:00:23 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id i17so120724ljd.3;
        Tue, 24 Nov 2020 14:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5gc70FHb6SJrsVk8HGw5LrPGq7PHyIY9jYoqow8jBUY=;
        b=a6Q2YBj9PSDjMMqRcXySN3aiphYBDIwvK10RyG8mrKrDWhPCjDzoySYAzEgRnQE0A3
         1+gzxAoj0yuKAajLdKpQWHvTDum3EHaR2FpE5FVnyKuzk4Wv1PdQj3JRCyfBHkCG4Vmp
         JwwSejUMENuRnxu51u126B7Jj5dtyvmqV39NK/xtZi6m3iYZuH6aT2qYanacDeOKK3IK
         MDBs1tRhwGKLL8eXMxfvFmSZnxIHqaE6U9cF9SNLEh5MpnCj69FFQO1TGjF3ZX3qnF+0
         Hsajt8Czqk7sdTuibgk4Enr/IKfIsiYsafGk4awAn1uvMithQQjF/z81gfx83spkLpmS
         jU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5gc70FHb6SJrsVk8HGw5LrPGq7PHyIY9jYoqow8jBUY=;
        b=JGtxKFyNs2P+y6RR2AaMRUOKF/SVEzsLByS08MGv6ODRF5wkQAcv7N4m2oy/aCmQgf
         IvdlmDlSWSAJH2F6DJCoCRdpWWeDO44n4bHCfqVZAwyqtptegAvCgkbCBOMfwezswPUr
         62O4nF1nz04b+dlp2LezlZKMC+DVOdOGZ2m9T+PxqGpuhSWn7Y0FK7vlcQoNYH8ciV8p
         p6FWlY1z4HboKssShE6NaqzlAnX6RF9kmXqvMN7trP/fsuuZKOwBEEcF3hgl2gMGWwTz
         RoHXAZwTweCs3jVy9mUKIPxMBUFXDep0Dn8InyG5LMp8/hAnLB2hDnGQg4c3BG3UUdfp
         ETfg==
X-Gm-Message-State: AOAM53148kw53PpI6vB+O5boQjCv5XNkRmOXV4MZ7HyeHNtJM2O5FnM3
        dUizaPIRajkUqN5x10ip1RUViKCeMFkwx+n8j7k=
X-Google-Smtp-Source: ABdhPJzR+tqoeN5N5YEb70bHvxbccwtXNtT3TqOB8rCU+37OhcHP8rjvYgddqjlHp+AqpGuPhkCGXltlBAmY8CRw+n0=
X-Received: by 2002:a2e:8183:: with SMTP id e3mr139157ljg.267.1606255221843;
 Tue, 24 Nov 2020 14:00:21 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 Nov 2020 16:00:10 -0600
Message-ID: <CAH2r5mvPQWxW2feT+ELLpNR2fNCHqqchauuVoadiGpCwu2bAQg@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
09162bc32c880a791c6c0668ce0745cf7958f576:

  Linux 5.10-rc4 (2020-11-15 16:44:31 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc5-smb3-fixes

for you to fetch changes up to 1254100030b3377e8302f9c75090ab191d73ee7c:

  smb3: Handle error case during offload read path (2020-11-15 23:05:33 -0600)

----------------------------------------------------------------
Four smb3 fixes for stable: one fixes a memleak, the other
three address a problem found with decryption offload that
can cause a use after free.

This PR was delayed due to changes to the cifs/smb3 testing
infrastructure (multiple testing configuration changes and improvements).
There are a few additional cifs/smb3 fixes in progress that can now be finished
and tested that I will send with later PR.

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/437
----------------------------------------------------------------
Namjae Jeon (1):
      cifs: fix a memleak with modefromsid

Rohith Surabattula (3):
      smb3: Call cifs reconnect from demultiplex thread
      smb3: Avoid Mid pending list corruption
      smb3: Handle error case during offload read path

 fs/cifs/cifsacl.c |  1 +
 fs/cifs/smb2ops.c | 88 +++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 74 insertions(+), 15 deletions(-)


-- 
Thanks,

Steve
