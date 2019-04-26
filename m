Return-Path: <SRS0=UR+C=S4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FB0C43218
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 00:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D583206C1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 00:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NgV7cv5p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfDZAXx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:23:53 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:45897 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfDZAXx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Apr 2019 20:23:53 -0400
Received: by mail-pf1-f181.google.com with SMTP id e24so735407pfi.12;
        Thu, 25 Apr 2019 17:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=S/3Qlr1bQwkQx5+e+Ed5GckpMASJr8xt7ak7HsSvCtg=;
        b=NgV7cv5pVnyG50KdUhxq2d59Y+rckBCglx1xC+BPsJl43fqIGnYGDeY62NyUIY4j5i
         FbYWHi8b3uR9U49+kLcGi1W6DPU/HmDfpiFutMkZzQv0r7QOGQN9GhKSEdiNcUNmpOXj
         L57qU3Pd0P5msIXkRHX5EMKj4K5mq7/a4UHUr+KMruWW8YbV3dBB7XvyuaoWDIX8sbeB
         uwU0YXUID2oxFeihUtoSX+CVZPeszbLrqtPOph5JGd1COGBQXt4V/Gin4KqTPRy7ns+V
         fY24uCmXvSh6TAqUiofJvjvTZV14zRFaOzjdljREs2osTTTTP4sk6lGsex8D0XZqIDwa
         1qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=S/3Qlr1bQwkQx5+e+Ed5GckpMASJr8xt7ak7HsSvCtg=;
        b=n0vlb3hVfcOUy+zdRGq/ooQpR+ku+Wz5hfDk1F1+R7WdeJjeBbx/nTRtJmSVkqcphh
         ccfRrDMlGQ76M7Kg1TQBBxcufJTCC+NB5KHNl4fXMioReM8xK7tO4wzhD3B6ahBfCL6D
         lQqnCl6Fdjc/wQOq/QcaYerJlZ1tPtQJzNKLyuV8UpkWKx22fWnkxP+RwfmfNNB8f2Tr
         vdMHQbMc+o5SCnkDYe1nx5rhsNDz0YGUfECRb/0js0ZL3UhDZpII4pS8IQElYzu2Vx0e
         AzNA6Y+TgFJjrlh7OEiiPM3l+TMSkoNz5o+XnoKCFfudMgkrJKTz9zNn4ENYWrx+nv59
         fnWw==
X-Gm-Message-State: APjAAAWoyu5OIpKOOhBWjdJp8+mAFG9WyEHIf3P/li+gFweWOHTN/+TR
        qEo/oSU3WrRGGa93JV6ywWNwyBz1G3cRKC8yBhRRQAv7
X-Google-Smtp-Source: APXvYqxNOSZRBUK/FnpFbYNNLPaI8VZBvr9PIFyThoqEVd/eI6k7sYsYf9QYa+nLQgUbESYzUVoMq/SmS/O5DhV8Djw=
X-Received: by 2002:a62:2fc7:: with SMTP id v190mr42307866pfv.10.1556238231885;
 Thu, 25 Apr 2019 17:23:51 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Apr 2019 19:23:40 -0500
Message-ID: <CAH2r5mv8tvPpdbwJCrUeumxUG5G9QGm2j9zn-gWbU2bc3qS=WQ@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
ba25b50d582ff6c6021eee80824134aeb9ab8785:

  Merge tag 'drm-fixes-2019-04-24' of
git://anongit.freedesktop.org/drm/drm (2019-04-23 21:08:52 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc6-smb3-fixes

for you to fetch changes up to 13f5938d8264b5501368523c4513ff26608a33e8:

  cifs: fix page reference leak with readv/writev (2019-04-24 12:33:59 -050=
0)

----------------------------------------------------------------
three small SMB3 fixes (all for stable as well): 2 leaks and a rename bug

----------------------------------------------------------------
Frank Sorenson (1):
      cifs: do not attempt cifs operation on smb2+ rename error

J=C3=A9r=C3=B4me Glisse (1):
      cifs: fix page reference leak with readv/writev

Ronnie Sahlberg (1):
      cifs: fix memory leak in SMB2_read

 fs/cifs/file.c    | 15 +--------------
 fs/cifs/inode.c   |  4 ++++
 fs/cifs/misc.c    | 23 ++++++++++++++++++++++-
 fs/cifs/smb2pdu.c |  1 +
 4 files changed, 28 insertions(+), 15 deletions(-)


--=20
Thanks,

Steve
