Return-Path: <SRS0=9D0L=XN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A15AC4CEC4
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Sep 2019 17:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1265921897
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Sep 2019 17:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tHeHkEaD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfIRR65 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Sep 2019 13:58:57 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44876 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfIRR65 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Sep 2019 13:58:57 -0400
Received: by mail-lf1-f66.google.com with SMTP id q11so306736lfc.11
        for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2019 10:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2TOCR6CjifybQQWjmdVjJ+0VrD8tH3RreILxB1lNrIQ=;
        b=tHeHkEaDPBCp/sN1OlZifiOg3ZmkMdsWzCYFm7rm3MV2jmsUjteLPPml060C+6e/4p
         jv5BULE45uCFIjo/qnva2fifhHbj88XW/r/kfinadGMwzyGE4TLKGUnj0nyPkwAho4rB
         69NLG3nJfq1s7UW1OCJXXJ1vS3gXMGAQS625hKVv7GKz+k6PLCaVnxQFwQnykDtl0P6m
         /xNeY7BwU1bOH+8KRJPTEZWnUMZPgdxMjaxDJnLmss/hJCteYBTVfkUOB7NeEP5OtA5y
         WnvKz1SrPiSNDqXezlrmJusFgMSxKvqozy/TDyxmTlS50vGzLImH6pb2MNW8GQA/JFgm
         rBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2TOCR6CjifybQQWjmdVjJ+0VrD8tH3RreILxB1lNrIQ=;
        b=NnJBoiDXaS7jpeVM0HrBOKdDu+qF+vNcjCObRaeV7Jc3YJ7oRTvotB+9gg7EFwBH5c
         2ltczRlCpTQ0RCWcTCkRLiQYVWVajwPACIEGk8EwSYJGt2ldiPQVeqZQFZWoqtJZKxf/
         F8glnzkE8FnzeAHwdcxsefHvWlZvI67B2tE4lGwck/23JLex0pbalGBywCoRgY/FQMq+
         wDuQCdhfaJ1CxlwA6JUriQYN/EagABLPDCHrHoxrkkXhax53sMXeR5mD2jv/AOrfJFbn
         ylW9Q9/9ZrYbdlYXbqSSPFMS4Nb7DmHQi+I2eGgbRirb0y+zvjuEsPzDY+f4dNai3Yd3
         lZZw==
X-Gm-Message-State: APjAAAXqHN9z4HQXylNFufursNx7Dt7DWp0CsiuhdKK04hhbVwx8qJX5
        VS5rIyHbrN8anj0yE2yHmKTa0/fXln8bjgfZhA==
X-Google-Smtp-Source: APXvYqxZGj9qO7QkQlz1e5LjXmgW1IBGFljpjiKXUZn2WyTW0hvkSHYzc/LmUSTQ0D/8zLWwEihojoPRM0/I53h5pW0=
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr2844311lfp.15.1568829535311;
 Wed, 18 Sep 2019 10:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
 <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
 <CAE78Er8KYhRts+zKNsP6_11ZVA0kaTrtjvZPhdLAkHqDXhKOWA@mail.gmail.com>
 <87pnkh7jh2.fsf@suse.com> <CAE78Er_ea5mtp-6VxyNPzCSDuPym7cXcD3=Udcpv=jGo80XhZg@mail.gmail.com>
 <CAKywueT2mr1i3Y6iNQOzXEc1CePMozfvoJUz=TJAmbnskdofhw@mail.gmail.com>
 <CAE78Er97k7O-GDGdMtp0qXtQ-q-1nS_d1AE6HHH+Kz6PV_G2uQ@mail.gmail.com>
 <CAE78Er_L5fY31JdVaSUgbd7uyXpMAb+81adcVFD3GBQfMeWX0g@mail.gmail.com> <CAN05THRrUB0T5Zho+HjbmTzp4X6-Sx+N+QqaV5A4SDHrkqKWTA@mail.gmail.com>
In-Reply-To: <CAN05THRrUB0T5Zho+HjbmTzp4X6-Sx+N+QqaV5A4SDHrkqKWTA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 18 Sep 2019 10:58:44 -0700
Message-ID: <CAKywueRr6n3LwgS3w3rhLHq-GedX2SnxdRFaauZqZdfoNoWyjg@mail.gmail.com>
Subject: Re: Frequent reconnections / session startups?
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     James Wettenhall <james.wettenhall@monash.edu>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 17 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 23:49, ronni=
e sahlberg <ronniesahlberg@gmail.com>:
>
> On Wed, Sep 18, 2019 at 4:16 PM James Wettenhall
> <james.wettenhall@monash.edu> wrote:
> >
> > Thanks Pavel,
> >
> > We've been running Kernel v5.2.14 over the past week (updated using
> > Ukuu) and it seems to have improved the situation considerably.
>
> Thank you for the feedback.
> This is very good news.
>
>
> >
> > I assume that the "nohandlecache" mount option recommendation was just =
for v5.0.

Glad to know that the situation have improved for your workload.
Thanks for the feedback.

v5.2 kernel has many fixes preventing reconnects that's probably why
you stopped observing the original problem. The latter haven't been
completely fixed yet in v5.2.y yet. We have a patch in for-next that
aims to fix it but it haven't been sent to the mainline yet, see

https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dcommitdiff;h=3D96d9f7ed=
00b86104bf03adeffc8980897e9694ab.

Once it is there, it should be automatically picked up for backporting
to all active stable kernels it applies to.

In the meantime, If you start hitting the issue again, please try
mount option "nohandlecache" as a workaround.

--
Best regards,
Pavel Shilovsky
