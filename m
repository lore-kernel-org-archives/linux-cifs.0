Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FD9EEB570
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Sep 2023 23:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343928AbjIHXpk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Sep 2023 19:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343694AbjIHXpj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Sep 2023 19:45:39 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B26133;
        Fri,  8 Sep 2023 16:45:35 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2be5e2a3c86so44046681fa.0;
        Fri, 08 Sep 2023 16:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694216733; x=1694821533; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=obKL7O1pA1jFmqbJ3hxi0ggl2zJe+KnvydcEGbO7HUs=;
        b=hs8o5+YE5GC+hG9jTPmYS8ghu6Z95MuvxabSD+B0vOG1fUbuwzuTeqj7FhydfJVDvh
         uctKw2Tp2VnIvYNxHcQm+s5cQYkascK4HbjhStJ9HWDdTsjpEfRbaT1bAh57sgCWzWc7
         ntQi/pYeZhndcXozAlqYd4KmnCQJtAt/rrRf6Z+of0SNTFwLTohNoMahwn50SyoKJLcq
         9Ovry7XC2dwSnV68Y4u+71oeNtCirRCbEwNvZkPiU0L1g/9Af/MBea4YRqVcPz+DDWlt
         KF+8YNmMS99QU5nuzToSrqJbwJtxCW+anM+hUlBaSTyxi/tMBlEiL3R5H7vITw5L7QiK
         EyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694216733; x=1694821533;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=obKL7O1pA1jFmqbJ3hxi0ggl2zJe+KnvydcEGbO7HUs=;
        b=E0+T0GTG+ExFIBzKg0nRPf534hJ/Yc8rcrwYgzx5tWq6llSTUoT1LBWiAzzUeAfa27
         3r52VP4O0w54bQ5DYmOoybDWI1Wk19NZGBusvnXVBl7q6ST2KiaVNxuhbuPimrDm5DI5
         0xPuMAiv5GjSIBtX2hWvUXe52qNybq1ShWx4NNJMHeABPhGrBk1jXqtm9QuUNppo1GvW
         o0HNYVP+ws7rGyOFQQ8cvVKXe/pihw17TD6SyAAJ6bXSnuRZPvsvydeShzWW5tU4oSBy
         Zi9SKf/EQsQ46AXibv0WSrb1tgYhve60XCsRk8QpjhXZoMFIKNQpOhAH/KeTT8Ecrpyu
         wnlw==
X-Gm-Message-State: AOJu0YwH2tpZBeChrxQBrcev8pe0wNl2I0p1z620Lu37GZAtGdzAiWDq
        ofh552yDLVpmrhELvaWQU+GObzwCbv3S1juHnZHibDRn1lOFUA==
X-Google-Smtp-Source: AGHT+IEdcNwbLflG8mxjbjBNoUztNekjx9hw37toXkvIoCsFDowgUd6vS6f0Qe0fZ1IjEL93wJtaW5CMcawknyzJmCI=
X-Received: by 2002:a05:6512:128b:b0:500:b09f:eb3d with SMTP id
 u11-20020a056512128b00b00500b09feb3dmr2658440lfs.30.1694216732451; Fri, 08
 Sep 2023 16:45:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 8 Sep 2023 18:45:21 -0500
Message-ID: <CAH2r5mt0Wuett3pQhGmynJxSTN2FriXxXT3zU-Qi5sk1uZ+SQg@mail.gmail.com>
Subject: [GIT PULL] ksmbd fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
8ae5d298ef2005da5454fc1680f983e85d3e1622:

  Merge tag '6.6-rc-ksmbd-fixes-part1' of git://git.samba.org/ksmbd
(2023-08-31 15:28:26 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.6-rc-ksmbd

for you to fetch changes up to f5069159f32c8c943e047f22731317463c8e9b84:

  ksmbd: remove experimental warning (2023-09-03 21:06:36 -0500)

----------------------------------------------------------------
one patch to remove unneeded warning
  - after two years, many fixes and much testing, ksmbd is no longer
    experimental

----------------------------------------------------------------
Steve French (1):
      ksmbd: remove experimental warning

 fs/smb/server/Kconfig  | 2 +-
 fs/smb/server/server.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

-- 
Thanks,

Steve
