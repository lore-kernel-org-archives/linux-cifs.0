Return-Path: <SRS0=KQhF=3V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E803C33CB3
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Feb 2020 18:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E027206E3
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Feb 2020 18:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJk2X4cA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgBASkn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Feb 2020 13:40:43 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:39435 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgBASkm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Feb 2020 13:40:42 -0500
Received: by mail-il1-f172.google.com with SMTP id f70so9143377ill.6;
        Sat, 01 Feb 2020 10:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Z11+/yeQUB6zTwEssk9IOz1CExq34IGy3Oa8TOXh/Dw=;
        b=LJk2X4cA1MrCsi7mlcIeHVA+FtISyoUCmOSZ9maIXGIt7xpBTTfNjoMb+7Zfz4bnrA
         EZ1rWKDrG8M6+RnNPzPmsHDRYDFKVLaHJ7k9GBgoeIcvfe0DTIcP5YuppQIKDtX0HXeU
         nwajDVdfmYJlRWA8N9cMvMFo/CHKaQIzUohK1cnprQ0yswJlIde47ZlTxGjK2PGY4lYT
         MnR2+lwL95F3jTWPxCKF+y6ydIb4cd1IZWhy+FjENLsKtz8pBBACNOp11SESbRRRC1Ed
         sEaCEFcWIzKyn57dqrXsCeEisvcnPhJ+fglLKkrQX+m2FL5/PYemVrrffeMeYpLto3YM
         RARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Z11+/yeQUB6zTwEssk9IOz1CExq34IGy3Oa8TOXh/Dw=;
        b=bt2UUjXMwzmvilLod3qbu96zmEJDQZNV73fj+XS5iQJ4pLzaMmogs4mWB2wtVv3hV5
         fPO7od+m9hyWL6J/lg3azx+Fcux+JGz09ukZA4rqydx22R1Do2VZBARtLWOJwHddo2I5
         MiaNGINSib6d2UQ7HvrhPwvu7zufMeR6HKouvx1Mjyt8nYwjqWvq7/jYR13aTlypJdUa
         HLjKQ/j74n493hRXPmN6e6unRJQQ7TGmmHewxYsjisz8NZCcK2BMDHoXg0yNi2tB+MyD
         tGcZmczxAXvsvpEzIhV/S/in0DlUcLOQ0tx1t8VvnMOPivb7af/LUMhA80e51zpgo5iZ
         AiQQ==
X-Gm-Message-State: APjAAAVT43hHEouRweENJD7VUry9Fzt9o6xf8f30hUQi/gpksRKAcVJt
        JCZJm82YsykUToWodwvrAK4iOTRf+HeNeAXQr+g=
X-Google-Smtp-Source: APXvYqxHdowNbvOAZgwablQ3gQQL55H32fErt8bUECbN0wCs1Pws7yWJjkaghzNxBt/2ALxYrUhQMOOMAxp3Wh5+Irs=
X-Received: by 2002:a05:6e02:c71:: with SMTP id f17mr14485694ilj.272.1580582441983;
 Sat, 01 Feb 2020 10:40:41 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 Feb 2020 12:40:31 -0600
Message-ID: <CAH2r5mt-Q1_ZBJmC+8jr5gJhr-NmUGG933y0gc+_1DVWTJUVZQ@mail.gmail.com>
Subject: [GIT PULL] small SMB3 fix for stable
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stable <stable@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following change since commit
68353984d63d8d7ea728819dbdb7aecc5f32d360:

  Merge tag '5.6-smb3-fixes-and-dfs-and-readdir-improvements' of
git://git.samba.org/sfrench/cifs-2.6 (2020-01-28 15:34:03 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-rc-small-smb3-fix-for-stable

for you to fetch changes up to b581098482e6f177a4f64ea021fd5a9327ea08d5:

  cifs: update internal module version number (2020-01-31 15:13:22 -0600)

----------------------------------------------------------------
Small SMB3 fix for stable (fixes problem with reconnect for soft mounts)

----------------------------------------------------------------
Ronnie Sahlberg (1):
      cifs: fix soft mounts hanging in the reconnect code

Steve French (1):
      cifs: update internal module version number

 fs/cifs/cifsfs.h  | 2 +-
 fs/cifs/smb2pdu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
