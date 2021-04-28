Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95347C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 04:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B2C613FF
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 04:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhD1ESg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhD1ESf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Apr 2021 00:18:35 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6435DC061574
        for <linux-cifs@vger.kernel.org>; Tue, 27 Apr 2021 21:17:51 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id l22so63345214ljc.9
        for <linux-cifs@vger.kernel.org>; Tue, 27 Apr 2021 21:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1Z4vfa+ZtZqSg79U0tz8w+mD9UzAe4Gwbz49Kcuqo3E=;
        b=Gd0qS5m0IlBomU+nWrQRLcU5LJ5m7aXcV4gmBCUplZhvY8TiQ5CCzVHRjRwvh9pAer
         ku+wqLWHHkii3kynsLX/JrrdUhJq2cOnGnL/QQ/A5EmEq9mQGN4aqfnHOOdaTCfi4Iph
         F81wpAmtaBMDwL6EC/ToMpJequ9+QrRNxoNL1vmv5sFcGt1cHOghsetFdIwoN51JgfIi
         ur0o6d0ZWxzGXB+iJ/DNS0edk17tPUS7SXEr6Zq2oeBu0VJbKPRefne8U6MnLhRbTMmc
         oLtFEZSgNmau3L4bPh8Eg/62c0WsQMckCMwzQm6zFX1F8Zpg9CTpwuMCeG2Gm9USb3Ks
         kzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1Z4vfa+ZtZqSg79U0tz8w+mD9UzAe4Gwbz49Kcuqo3E=;
        b=YH4sC2BKz9oGUPujKwdx4j0WDc2RaweVKvmUcJmE33buAwpfs1TR2qN+5lvukreDhX
         bnavtnAlbnxngThlMiwS4vnyVyvGSKdx/Clsm6gp+twNustqWL0SS53g3L1tKTLDvIxI
         PwDqIzS8v1dJbapPtQkNM7I/ydTdeMMAEBIrJ01sXDDt/N9vQ8eshdPPTOHbur3BBkds
         U6qVzTR2ulZOlLXHKK0gLXg97NgNteORN828LfraKbaAytUz+BpvksP/GQh1vWiJhEA6
         Qxb3lz39scT58tZS0R/DzeeGYSTeUGFYkbc+SKofslh04WwuIzUjBw9YDoH7Rit0DH2R
         6etQ==
X-Gm-Message-State: AOAM530LAQ3EX3KPF+ovbvmPFqCsoieQaYFyyoPTCAI0P/cQUsKvMwbm
        D0jjvtLmKBJEUe+PbijU94I0LqNGjUaD6ph/WI/3HjkrGso=
X-Google-Smtp-Source: ABdhPJy5nCZeAM4goOEpylC6mO2PX9VvT/IZY5LJTfGVrcU61ZD1vZTGbL33bPjTm6Kp6cIF6cku8vTA0euL6DBnKVk=
X-Received: by 2002:a2e:6e03:: with SMTP id j3mr18748254ljc.218.1619583469596;
 Tue, 27 Apr 2021 21:17:49 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 27 Apr 2021 23:17:38 -0500
Message-ID: <CAH2r5muZOD+d-x4ci=z2Ebi3mkyCUBj286aX+u17SQZ-XDpgMg@mail.gmail.com>
Subject: [PATCH] smb3.1.1: enable negotiating stronger encryption by default
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     linux-cifsd-devel@lists.sourceforge.net,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Now that stronger encryption (gcm256) has been more broadly
tested, and confirmed to work with multiple servers (Windows
and Azure for example), enable it by default.  Although gcm256 is
the second choice we offer (after gcm128 which should be faster),
this change allows mounts to server which are configured to
require the strongest encryption to work (without changing a module
load parameter).

Signed-off-by: Steve French <stfrench@microsoft.com>
Suggested-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4a3867a7cc5b..8a6894577697 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -75,7 +75,7 @@ bool enable_oplocks = true;
 bool linuxExtEnabled = true;
 bool lookupCacheEnabled = true;
 bool disable_legacy_dialects; /* false by default */
-bool enable_gcm_256;  /* false by default, change when more servers
support it */
+bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */

-- 
Thanks,

Steve
