Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67353C7EE23
	for <linux-cifs@archiver.kernel.org>; Sun, 21 May 2023 18:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjEUSJD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 May 2023 14:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjEUSGj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 May 2023 14:06:39 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8585102
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 11:06:37 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96fab30d1e1so230632466b.0
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 11:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1684692396; x=1687284396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMadGmvjqp8xzF2NAhfvAfuBYa9KMMmlXCO3kEDZwAM=;
        b=gn/sLYZphidGrvrDMOxCRbNY8HB6uvZE1TDJyvj5zI1D4eu0GDCGAL1Ax7ihd1UxZV
         BfFKctjP5JYxO2a80fJoAhXhijFT+xt92v1Nna7mMBwlRGO0CwZh+tFyiUQOL6RfIxPS
         uRXgQ94R/JckRuiW0G27YJj1L48k+tXNmv4AI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684692396; x=1687284396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMadGmvjqp8xzF2NAhfvAfuBYa9KMMmlXCO3kEDZwAM=;
        b=HTzDncEtuLcWVxPqnJO4vBUI/Erjdrqcj7PYfGYTbGwGnW3SW/479FfxBYhCULJCiu
         m8yU+Wkk6H7SRl8Uf1i7gYBwM4eIRfbeCQ+5HIFlqjFog8tH3Mu7Du7fvOo6IxFTZc2S
         pajNJCC3M3Lnp3NUT7z7GQSaX+QprCP0rcSOFu95W92WeVwDmD+DHTOcQnPCjlGt+XBa
         F4TohbE1tpJXCPKlSw6K/g+VI7oAQ22TOXzqbatLawFI8NU/f7EMvOZtYzdUZQA75N3v
         KhFaZAGoxD3WGlCowJRowfelVFbRshklBmSv79eDmEcII0KNI0mJcqyRHM5eF+Z36Jrl
         1dLw==
X-Gm-Message-State: AC+VfDwElZm9CieqwoOWmXNCnfjWZ3CtEkerEeet8IZz6AYRVUVDw4Ej
        L6oZTwBT1u33uC2FIw/EvXAaaDb6bsrbxJbg70UC9Q==
X-Google-Smtp-Source: ACHHUZ6mIgR9jEjJCIHXVySuyDCwQMkoXM1Bkz/yx09C+PyhAUoDiOgdDb8g2GGaMQyUjtmyrMJxJg==
X-Received: by 2002:a17:907:6d8f:b0:96f:7d0a:5981 with SMTP id sb15-20020a1709076d8f00b0096f7d0a5981mr5723758ejc.36.1684692396078;
        Sun, 21 May 2023 11:06:36 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id f25-20020a170906825900b0096f6647b5e8sm2177668ejx.64.2023.05.21.11.06.35
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 May 2023 11:06:35 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-510bcd2d6b8so5527935a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 11:06:35 -0700 (PDT)
X-Received: by 2002:a05:6402:3593:b0:513:62de:768a with SMTP id
 y19-20020a056402359300b0051362de768amr2856862edc.19.1684692394687; Sun, 21
 May 2023 11:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msxkE5cPJ-nQCAibJ+x+hO7uSLpasGm81i6DknQ8M5zWg@mail.gmail.com>
In-Reply-To: <CAH2r5msxkE5cPJ-nQCAibJ+x+hO7uSLpasGm81i6DknQ8M5zWg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 21 May 2023 11:06:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiStOAKntvgzZ79aA=Xc0Zz7byoBxBW_As5cmn5cgkuoQ@mail.gmail.com>
Message-ID: <CAHk-=wiStOAKntvgzZ79aA=Xc0Zz7byoBxBW_As5cmn5cgkuoQ@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fixes
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, May 20, 2023 at 10:14=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Four ksmbd server fixes:

This reply is not really directly related to this pull (which I just
did), but more of a reaction to getting the cifs and ksmbd pulls next
to each other again.

We talked about directory layout issues some time ago, and there's
kind of beginnings of it, but it never happened, and the parts that
*did* happen I'm not super-happy about. That "fs/smbfs_common/"
subdirectory is just fairly ugly.

Would you mind horribly to just bite the bullet, and rename things,
and put it all under "smbfs". Something like

    mkdir fs/smbfs
    git mv fs/cifs fs/smbfs/client
    git mv fs/ksmbd fs/smbfs/server
    git mv fs/smbfs_common fs/smbfs/common

plus the required Makefile editing to just make it all build right?

And if you prefer just "fs/smb" over "fs/smbfs", that sounds fine to
me too, but I guess this all really does just the filesystem part
(rather than all the printing and whatever other stuff that smb also
contains).

I dunno. I just feel like the current organization and naming is this
odd half-way state, and we could just fairly easily do the above.

I could do it myself, of course, and git will sort out any rename
issues. But me doing it seems silly when you maintain all three
pieces.

                 Linus
