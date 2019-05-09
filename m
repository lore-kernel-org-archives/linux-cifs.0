Return-Path: <SRS0=mIXx=TJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ABAC04AB1
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 15:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A453216C4
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 15:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dd2qZgAl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEIPky (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 May 2019 11:40:54 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:37831 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfEIPkx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 May 2019 11:40:53 -0400
Received: by mail-pg1-f172.google.com with SMTP id e6so1414569pgc.4
        for <linux-cifs@vger.kernel.org>; Thu, 09 May 2019 08:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F6Q/fnAeMeKQ/kTsgVaBOHzjAbukGxki9WPPwOdGTWc=;
        b=dd2qZgAltIUcnvusQ75GR22yTuA0BLOfo6MNw1rHAPj92i1iEogULTrHL1FrIkG4we
         b+jfsDG/vqADQr6S67ko0BJ45AxvfNcf87x/j3Ti414SSK4fbuvsySuUQpMJrhxPHIq/
         dP32oS7953mD414ZnT6uqD/i+Ba4LrpZHY9d9K72ReY8RnickhRfHPLomNbB5zu18iG4
         hASA9izDFRGJhpG7FR7/dNu05J+Z0W/6QjU5jnVxZdTE9JM8+DHO08Yy/mLR2BbkSppq
         LHGVinm6rDWb78G9ctEdHVrsJ9cbo/OA7RgnUAfxBLRj7EPhIhD1KO5UywDEKn/4rdz7
         L49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F6Q/fnAeMeKQ/kTsgVaBOHzjAbukGxki9WPPwOdGTWc=;
        b=FPrBZO/6qNF82JC6dgS3J9+MpwJImF5UfMudQUZ7OUN0XmdnenpXyi8MCYEZ0hjObk
         aIJpwePfmeitQ0FyiP1+9qtQ5OHrM8fiW+ZmvyCCc6Igwve82+n93S30wvCcoqLmKM8d
         nDo29f7ghkfPxGAbh/83/E5Ypl+v9k3an/CCLz6IzLYGLFRkr2MPCyQsnLwuHfxM/3AT
         wGdoo/7j5hrN0cLeF1RaZbcCWktfvhGlPVlJ2gp34sxahDrU0mTwPix6YWxuZFTHYGRH
         /eB1priLI5w19IpLRpIH9rOcvDOFt5zi9YYPhQX4X3FiL30oOkvqkilcHe6Wzv6+MoFp
         10Qw==
X-Gm-Message-State: APjAAAWjZ8GHM3i5mu9Pt67emrAy0vW7A422TlxW0o37cDBkdYDJaAJp
        BtrwkawBxMDlo9ZPf1P22u7C7klRCq61D6+cLso=
X-Google-Smtp-Source: APXvYqzAK4l3qC1QGxx9Z4Czy2fDHqBepIHkoo2zqaPIBsYJfatz5DZkgDwoguvvQvwVvnfLiVSBBO+X7J7i+3tJF+4=
X-Received: by 2002:a63:f806:: with SMTP id n6mr6482570pgh.242.1557416452877;
 Thu, 09 May 2019 08:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190509131420.17d98c62@samba.org> <87a7fvbzwj.fsf@suse.com>
In-Reply-To: <87a7fvbzwj.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 May 2019 10:40:41 -0500
Message-ID: <CAH2r5mtknxvKiXmhJi5RcymzF14PPWLUGwCsYxfVeoTQAriFkg@mail.gmail.com>
Subject: Re: GSoC 2019: welcome Mairo Rufus
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     David Disseldorp <ddiss@samba.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        P Mairo <akoudanilo@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes - Welcome!

On Thu, May 9, 2019 at 7:02 AM Aur=C3=A9lien Aptel via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> David Disseldorp <ddiss@samba.org> writes:
> > I'm very pleased to introduce Mairo Rufus, who joins us as a 2019
> > Google Summer of Code student. Mairo is assigned the task of
> > improving the smbcmp network capture diff utility[1], and will be
> > mentored by Aur=C3=A9lien.
> > Please make him feel welcome.
>
> Welcome! :)
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)
>


--=20
Thanks,

Steve
