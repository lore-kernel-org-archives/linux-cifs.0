Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E45C2B9F4
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 02:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269496112D
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 02:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFWCzF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhFWCzE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 22:55:04 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB93C061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 19:52:45 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x24so1498935lfr.10
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 19:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z42qmxyhov22AUdwiRihb7o2aNV4gBdkCnnOa+ZOupQ=;
        b=GKhZUTBAhoClx2zKJYAwXf7vag5snHFpLAwaT49JRU8ilminoXrum3C4KimfI+8Gbf
         WbUlaTAYyXmp5NzNHaaJ3kqFQlnW7JQab5QrE4ZB638NDWM0hsKq4iMVFWSvZxul6RY0
         IANmkS0kEImu9W5FFKhIYfmpGoU2wjCAwbRQUkVbaI5ZpuQ8BKbvz0nF5YObN0ffOGMp
         AeqsY38n+IzDnjNBEKbQnIHXWgTj3Ii71TBJbHv+iNG6qCju2iApLMKD4QlTt7AINAgP
         +CNHH/z+zainoxx5RLP85X6UBIPM1DsR+yS1qs5ll/Hu+TgCxSbE/mACT69o7ArhZ9CP
         f5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z42qmxyhov22AUdwiRihb7o2aNV4gBdkCnnOa+ZOupQ=;
        b=YmuriG6hD16Pbcuot28xGsFDqWVd9HLMrHMVUH3U/XWS/Q5P00NzSMjQ04Bf4jG3xS
         TGE6it11XW58+r0p9NoYfHWeGiS5BB1jtYjXIuM/jfz6cULuTcnNwfGYhZWwHUd8Q7oG
         S7FkFDhAJ6goYEBjlOzC8a3lou3suaHy3qTl7JgwmTCxuumR7dp9zyj+BrgaiuE3ZCXW
         yk6nrLQRfb1DYhypqUN47I3t5tBc8OI07ztMNNmg9rGhgCuruSmJo745Ix+9HTiUdjkx
         mF13oTw6czn7ZbuocFxK3bmjIdmh3O7BQQtdfyXFbt0bk+DUfXLZvyF/r2MKEZRhdxu/
         mBjw==
X-Gm-Message-State: AOAM530YCCgT/WzEQkWe+5uQh4fx2yyC4IRkXEPEoEJ3s6lVj+wIQAof
        Zeqqd1gtKAvIBTyqRrDa8XbLLD+GgZC9smEJhtk=
X-Google-Smtp-Source: ABdhPJw8rW4CLJeECvuU6oy09GD30OnOKUfAayhtCkrl3PVSwGQTuY3P4MSsvLQA1fiOCAgLmT3x6RZAd/xZf5z2GS4=
X-Received: by 2002:a19:f705:: with SMTP id z5mr5119928lfe.395.1624416764119;
 Tue, 22 Jun 2021 19:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e@epcas1p2.samsung.com>
 <YNF/OpvdMLbIDZiZ@infradead.org> <013001d76734$0cf3bee0$26db3ca0$@samsung.com>
 <87mtriqj6v.fsf@suse.com> <006501d767d9$361eeec0$a25ccc40$@samsung.com>
In-Reply-To: <006501d767d9$361eeec0$a25ccc40$@samsung.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 21:52:33 -0500
Message-ID: <CAH2r5msB8Y8qn+DFV=3g=K791p1ssFJh=+yNOC4bG8iW3K07tw@mail.gmail.com>
Subject: Re: ksmbd mailing list
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We should probably put a few lines in the cifsd and cifs client wiki
pages on samba.org and also in the kernel documentation directory for
each that notes that emails with patches should have a prefix that
indicates whether server or client or utils (e.g. [cifsd] or [ksmbd]
if you prefer, [cifs] for the client and [cifs-utils] for the tools)

On Tue, Jun 22, 2021 at 9:41 PM Namjae Jeon <namjae.jeon@samsung.com> wrote=
:
>
> > "Namjae Jeon" <namjae.jeon@samsung.com> writes:
> > > Add CC: Steve, Ronnie, Aur=C3=A9lien.
> > > Any opinions?
> >
> > I think having only one list would be nice too, but we should ask/docum=
ent to put a [cifsd] tag
> > somewhere in the subject, which is hard to enforce.
> >
> > Case in point, it already gets confusing when people send patches for
> > cifs-utils: we can't always tell it's not for the kernel from the subje=
ct which can confuse people and
> > scripts.
> Thanks for your opinion!
> I will change to specify single list(linux-cifs@vger.kernel.org) in MAINT=
AINERS.
>
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3 SUSE Software S=
olutions Germany GmbH,
> > Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
>
>


--=20
Thanks,

Steve
