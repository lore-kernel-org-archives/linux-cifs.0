Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A748DC433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Nov 2021 21:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhK0Vsl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Nov 2021 16:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbhK0Vql (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 27 Nov 2021 16:46:41 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F218CC06173E;
        Sat, 27 Nov 2021 13:43:25 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id z8so26217158ljz.9;
        Sat, 27 Nov 2021 13:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=bml/NFEGd+kn2xT1YP9f+ZlUupFkhTxDiEEx32jkgxE=;
        b=JOqkRW43e6TcCGAPFLnBkSQdIfssD9Azf6og3dR9yvmXAI3gVxvJEepM0UnPcx119s
         riYuSjToPNg7lD+NTORkQvucIx3Mpnlky/1tOq19Dso2IHIIiWZkx3I/1liUE/XRuccm
         JtyCvC1z7J78qLsgcDqiIXpTOTlDHU94Pf3EtmjN1suTMUeq+ovf1gAcsKqLbZ1wBKsQ
         1Rpiqt4uOseKaWhdVRdkwoRHu8CXIvQk59W+w1w24S8lKUSytzgDGkQa3B4jvPh+FqNj
         2NKcto9+cj1sQrmhSR+FfUxQusI+rs+HNyuh6qrN7YC2OBkiToOO3apWsvygNxXYRV0Z
         6PVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bml/NFEGd+kn2xT1YP9f+ZlUupFkhTxDiEEx32jkgxE=;
        b=EiXjcq6hnfOS7922mRGC6H5GCa8OQPxRGi2pRq+XrFXsGu7m8EDtq+57HpRT2u2XPa
         BdFuU/UwXy8xBon2SUvme8Sm95qhEriYpFfx25yxB9TFrFWErWEssKujZp6g8pBbsmtH
         t5EO8FuMjJ/v5SUXRAxVPfDUMkhrEIQHqbHuLO7SIvvlYIAHYUTYTUbsiPsQNIiJvbET
         48K+D9DR8weN51j9x7yAZWwIre/jbQhmtt6VAe+qNWBkHAgGMiFLheVVN09gPfYaRFxi
         cMqE5L80oRozlEHS+K8Jvt24UDRuk1mG9hb3VPzsyjtyAamcG6Cag63Z7N28ftESKenM
         5pBg==
X-Gm-Message-State: AOAM533PxTw0PekzVmtj4rfv8NI5OwbAKeQaNt8G6kqQB4LlHJviZTje
        haHxclqdT+J7Bn/JWGLVTrm59COp/0in3gV6oMmYsQVdSAI=
X-Google-Smtp-Source: ABdhPJysnOc964BpO4TupD4dIS0Ool7Gb54XEmp+KMn4jhq00tT7dD+BK4WxxdgF1RtX0iVIVeV4tCSZyBSPMreER1I=
X-Received: by 2002:a2e:7c16:: with SMTP id x22mr40218388ljc.460.1638049403985;
 Sat, 27 Nov 2021 13:43:23 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 27 Nov 2021 15:43:13 -0600
Message-ID: <CAH2r5muqy=YYFYkgZFenPSx0WexNmnp6GYL0qHP2hbyHA--Ckw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.16-rc2-ksmbd-fixes

for you to fetch changes up to 178ca6f85aa3231094467691f5ea1ff2f398aa8d:

  ksmbd: fix memleak in get_file_stream_info() (2021-11-25 00:09:26 -0600)

----------------------------------------------------------------
5 ksmbd server fixes, 4 for stable
- memleak fix
- fix for default data stream on fs that don't support xattr
- error logging fix
- session setup fix
- minor doc cleanup

Regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/96
----------------------------------------------------------------
Christophe JAILLET (1):
      ksmbd: Fix an error handling path in 'smb2_sess_setup()'

Namjae Jeon (3):
      ksmbd: downgrade addition info error msg to debug in smb2_get_info_sec()
      ksmbd: contain default data stream even if xattr is empty
      ksmbd: fix memleak in get_file_stream_info()

Salvatore Bonaccorso (1):
      docs: filesystem: cifs: ksmbd: Fix small layout issues

 Documentation/filesystems/cifs/ksmbd.rst | 10 +++++-----
 fs/ksmbd/smb2pdu.c                       | 30 +++++++++++++++++-------------

-- 
Thanks,

Steve
