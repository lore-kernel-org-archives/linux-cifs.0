Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302DDC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0068206DF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:37:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3pu81Ai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfCIAhT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:37:19 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35207 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfCIAhT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:37:19 -0500
Received: by mail-lj1-f193.google.com with SMTP id t13so18928864lji.2
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wX/1fNoHhhJy4V8G4sb/f0CeBwDhCQPu496mF2LgvlA=;
        b=N3pu81Ai9UOIJsM8tUr842ceei68d6nZ7ucKB44HpkIZHVBjWe0fNnlPtqnZEPcpNj
         55k7sAKI3sp4Dc+VJIHeiIhRjbt0SIW85XsrZ1GnDbdriNviwZC0cr9YPbU9qzUgitRk
         NgEsRqD5NgrSgAopeJskn0y6TCrgs43t6Ya9p4JUAsYCmL8csMIuMJk+Ocj260rMPRg1
         MS04MkaDWhuujlwYColR8CQciQFWdq9FcDzBfBHpOtd0uqnbvOwcH62yqhIOgv6QJ4I3
         lMPpgXf70i+08G4SiR0wFbEZQmMNRT8wgYKAS4+axVh1jXSqVOkO6gMXWLWmNIoaXEW0
         Y/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wX/1fNoHhhJy4V8G4sb/f0CeBwDhCQPu496mF2LgvlA=;
        b=Nj+fEOs90UggRsYP2bgPmVUQJv9wQVLn1MGcTJrXfe/nWNtZuCoy/47MwRGC49tYgX
         Z6svbIvyZ3MqJdBc1mYd/H4Y35tIPKpGVPRuRWeHOQ3HQwaiZE5I+/bKCymuFcIBYiM0
         hyO5GjxqLs+9PCCYr2NcIevAs5rCguA9XMMcglnd0ov07lUYwX0lkhXKDvWrzfP2Mf7S
         kTjWpcBmpi4kp8g2KersAAZU12RORfGrxzlKrJ+ckMuNZkPr7R3unXGkzi5GsMt1yCBi
         eHEPb/QlvAHaBo005xwD3bHoRSNCFzjVtlJxyw7Zs4hQ0azEXoMh/LNiqH30lHuO8kEq
         3SBQ==
X-Gm-Message-State: APjAAAUhh2PiRxlLW6T1XpFqloovfN0moQj+fkt9uxKdakmcUfZ32MVi
        IrvG1qfxl5P2178OsYU0dEmaWlz71GzM+l8sjQ==
X-Google-Smtp-Source: APXvYqxFN7A7jnSQvDUlNnwAnZ6VH/kq5J8uMyUwn9JDHKNRAoxH67nNcPnf7nVq7BJDehQghPKRzLPfSM5INREhpsE=
X-Received: by 2002:a2e:124e:: with SMTP id t75mr10806376lje.23.1552091836870;
 Fri, 08 Mar 2019 16:37:16 -0800 (PST)
MIME-Version: 1.0
References: <20190219014343.29526-1-kdsouza@redhat.com> <CAH2r5musFyuqHofaeEtjd5ecK95x-60ByZ=Zi=fAXVLMXG=Y9Q@mail.gmail.com>
In-Reply-To: <CAH2r5musFyuqHofaeEtjd5ecK95x-60ByZ=Zi=fAXVLMXG=Y9Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:37:05 -0800
Message-ID: <CAKywueQS75=MytRimPXnXusf6tRmGw539vxF-V-M_Zz9K+dzmg@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl: Do not go to parse_sec_desc if getxattr fails.
To:     Steve French <smfrench@gmail.com>
Cc:     "Kenneth D'souza" <kdsouza@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 18 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 20:40, Steve=
 French <smfrench@gmail.com>:
>
> Reviewed-by: Steve French <stfrench@microsoft.com>
>
> On Mon, Feb 18, 2019 at 7:43 PM Kenneth D'souza <kdsouza@redhat.com> wrot=
e:
> >
> > Add more to the error message by printing the filename and error.
> >
> > Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> > ---
> >  getcifsacl.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/getcifsacl.c b/getcifsacl.c
> > index f08cdea..7f6e673 100644
> > --- a/getcifsacl.c
> > +++ b/getcifsacl.c
> > @@ -399,7 +399,12 @@ cifsacl:
> >                         bufsize +=3D BUFSIZE;
> >                         goto cifsacl;
> >                 } else
> > -                       printf("getxattr error: %d\n", errno);
> > +               {
> > +                       fprintf(stderr, "getxattr failed on %s: %s\n", =
filename, strerror(errno) );
> > +                       free(attrval);
> > +                       ret =3D -1;
> > +                       goto out;
> > +               }
> >         }
> >
> >         parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
> > --
> > 2.20.1
> >
merged, thanks.
--
Best regards,
Pavel Shilovsky
