Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B20E77343
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Sep 2023 22:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjI2WLl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Sep 2023 18:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjI2WLk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Sep 2023 18:11:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363069C
        for <linux-cifs@vger.kernel.org>; Fri, 29 Sep 2023 15:11:38 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-505748580ceso418104e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 29 Sep 2023 15:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696025496; x=1696630296; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YYkBXlzbeV0e+jPT5Sm8x7fqVnvki8PoMHvpUCfornQ=;
        b=haBWKZ8ncPcZ98OKxHgr+a+WPV2QlEaszrvx3v7cl++fWZBKwT5tvpULqCsD8AWILL
         ANR1cIayYukJhCtGtcgJw0i+ony6rHnZ2VvHMVqLAtnROoym+li+22WIP8i+0Rf0OphW
         tiw35aUF5AfzP7mPcKtkAGJcMHXX5Qllv4UeN3Bc8YZ08EEdUTZVShImjSgSrmI2OIDP
         k7DflKZXwCI9com5H85bqGm+vnY+ugnBsT1mloGL8TM+ZJdy6TbcVG799F5w74NALF1o
         grm4SOMcxJIa155pegtrEtC4NVm8aa16ai9X1+Mb18yyjLwLKKaxBZFwUuCfv7HA5YB3
         87ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696025496; x=1696630296;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YYkBXlzbeV0e+jPT5Sm8x7fqVnvki8PoMHvpUCfornQ=;
        b=vJc+Q4icH7LNkYKToc21sw75bWbUODYAtTMiLkQrluun3vx6ct/34uQalJC735sgUQ
         4anghOeJYJr/11A5/s4ndK0hyXFYYSnaYWDp4mGlvv9JCk8hWuzeY+KgF00Pp/HraxcC
         BuTuwVdQtvHghMIedqOZENq76sQynPr+CDIh5qU83J2pA/vHkY2GZEBBX95RJ6v37o29
         b+HDGODxw0U+Fk0lGQRpKW9M939DGu7YuZiqp58WRsv6kGSUeUmt9OWM2MqKvZAJCLq5
         kKqu9E07AoE4YXscYccHi06JiojK34DG5IXJVIt23ujDcBU2ZxoORtGN2EOdfWm5WOBS
         j7gA==
X-Gm-Message-State: AOJu0Yw0UyDKj7nb3jHlyMmK2wMmZtivX1TmQqbVI8C4m0Te0gluZp1j
        xH/Sh8+FiDOErIweBrUX68ivvT1/iVuLv83LOqaPpgKoV0g=
X-Google-Smtp-Source: AGHT+IFHSp4H8K85z3Z3UG4BGMGrJjSizh8LK8bcEcLbXWhVZvJjrWR1lw6Hw8QmRZ59QBlio9HUDc2jAhIXJQS74zk=
X-Received: by 2002:a05:6512:3089:b0:500:8022:3dc7 with SMTP id
 z9-20020a056512308900b0050080223dc7mr5338889lfd.10.1696025496103; Fri, 29 Sep
 2023 15:11:36 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 29 Sep 2023 17:11:25 -0500
Message-ID: <CAH2r5muVLJV1oqGcGgrgYJynrGS-FwwpvF7wQ=SbW6LfpXY8Xw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.6-rc3-ksmbd-server-fixes

for you to fetch changes up to 73f949ea87c7d697210653501ca21efe57295327:

  ksmbd: check iov vector index in ksmbd_conn_write() (2023-09-21
14:41:06 -0500)

----------------------------------------------------------------
Two SMB3 server fixes for null pointer dereferences
- one for invalid SMB3 request case (fixes issue found in testing the
read compound patch)
- one for handling null iovec error case in response processing

----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: return invalid parameter error response if smb2 request is invalid
      ksmbd: check iov vector index in ksmbd_conn_write()

 fs/smb/server/connection.c | 3 +++
 fs/smb/server/server.c     | 4 +++-
 fs/smb/server/smb2misc.c   | 4 +---
 3 files changed, 7 insertions(+), 4 deletions(-)

-- 
Thanks,

Steve
