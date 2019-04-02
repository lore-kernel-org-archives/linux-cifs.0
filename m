Return-Path: <SRS0=Apod=SE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BC5C4360F
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 15:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 655D420657
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 15:11:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="glsgvlmD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbfDBPLW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:11:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39572 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732396AbfDBPLV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Apr 2019 11:11:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id i17so6538043pfo.6
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2019 08:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=btPLjsSV6xQnhpe99UB96gl/Y3qI3zTg4Nv7jqS9jHU=;
        b=glsgvlmDWmNVV0HrFRzyyIFgGlj2WuExlQwQpjVRTSTW8C7ODnuPuFnFWKdvA3E5ch
         NJV6rYzV6j2WdcQAc4bl4m1+b0mw8C1JcRQLRG+I2TSnP2JkTIjxcF+3C5KB7uYEM6ww
         Z6qsdKnUwmPW9FdZVGVacw006VKRV5ghcdPCwaaSyYLk3ZtAgtBKB36tsg96w4Imxpgf
         ELf40qkbHw1udVmLNo5hnC79mLpd7ZuJ3kAzCFZRASDRlV+KpcyqEh8QsTMlHs9npLcU
         rY/ANHgD2/+kkS9ZnHfA7ThcMyZkmGaLOvxvu4jKbVP4eYD4hozNvuRvQ6+0uH78flLQ
         KvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=btPLjsSV6xQnhpe99UB96gl/Y3qI3zTg4Nv7jqS9jHU=;
        b=IsRpIoY39rsd5tWi1mDTifxgc1Y6hriB+P+UizcGlQE9FFE298WuuVPpSza6hgu2gS
         uN1IidiZ4MijIrj3tdm5bn+tVymFGDvWut9TBb6oN5kFdh88JBwqFyiQkdbhdc65oc8Y
         RucDPQqGFDEfXW5GcWl664NFhMne5CeWzgUohoKJ/M2z8x4hlKQ+f2NJHL6t2CL0nBJ4
         Bulzmfh/tkR73xhjMlWM0zGhCwJjOtM8SNsc1UlIKRkE3utv2jVNWAuxCbrrX42na1D2
         q/6EAP9kkXv36ivQWGlSif7OId3BdT4g0AIaQbwKZs4FkabOxX5NN13ebE0QjLSGgLBh
         TM2Q==
X-Gm-Message-State: APjAAAXyRscSV/rRMzTNxzAge0YzN+kqOBRAlUtw21Gvygkvru8+d8zQ
        AS7aUoc8ziAZ7AVQVOmHGYg0jvSsR3pmCeyJhqFAww==
X-Google-Smtp-Source: APXvYqxUB2hPQ2pZSAelkL9hIHuVypj7bmPJy9qcpm4yZQY6mcD/wn3nwq4lvHczxVw00C+mr6VWklOSMRyyWfPYCao=
X-Received: by 2002:a62:59cb:: with SMTP id k72mr70999958pfj.111.1554217880288;
 Tue, 02 Apr 2019 08:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190121015159.30188-1-lsahlber@redhat.com> <CAH2r5ms0m1g20vd28jKD6qex1k8Ccs=PgTQhEaeo-66zs8nXWg@mail.gmail.com>
 <CAA_-hQLUTYM+p8z38p=uYpur56sCm7ujNi69+2h2EMsTvR0PLg@mail.gmail.com>
In-Reply-To: <CAA_-hQLUTYM+p8z38p=uYpur56sCm7ujNi69+2h2EMsTvR0PLg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Apr 2019 10:11:08 -0500
Message-ID: <CAH2r5msquCm8QR1VKN11STBQX5p+Vp7ngEwvBgDmERmoNHccGQ@mail.gmail.com>
Subject: Re: [PATCH] Show locallease in /proc/mounts for cifs shares mounted
 with locallease feature.
To:     Kenneth Dsouza <kdsouza@redhat.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I had missed this one.

merged into cifs-2.6.git for-next (target for next merge window, 5.2
unless you think it needs to go in faster for an important user issue)

Let me know if you see any other patches I have missed in for-next

On Mon, Jan 21, 2019 at 7:02 AM Kenneth Dsouza <kdsouza@redhat.com> wrote:
>
> On Mon, Jan 21, 2019 at 1:22 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Makes sense - but don't we need to update the man page as well - I
> > don't see it in there either.
> >
> > And wouldn't hurt to note a use case where it could be helpful?!
> >
>
>  Aur=C3=A9lien has documented the locallease and other mount options in t=
he
> below patch.
> https://git.samba.org/?p=3Dcifs-utils.git;a=3Dcommit;h=3D7325a01abc529d68=
756bae90cf23233392626939
>
>
> > On Sun, Jan 20, 2019 at 7:52 PM Ronnie Sahlberg <lsahlber@redhat.com> w=
rote:
> > >
> > > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> > > ---
> > >  fs/cifs/cifsfs.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index 62d48d486d8f..775cbb39f3b7 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -489,6 +489,8 @@ cifs_show_options(struct seq_file *s, struct dent=
ry *root)
> > >                 seq_puts(s, ",seal");
> > >         if (tcon->nocase)
> > >                 seq_puts(s, ",nocase");
> > > +       if (tcon->local_lease)
> > > +               seq_puts(s, ",locallease");
> > >         if (tcon->retry)
> > >                 seq_puts(s, ",hard");
> > >         else
> > > --
> > > 2.13.6
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
