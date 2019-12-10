Return-Path: <SRS0=09eL=2A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FB6C43603
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Dec 2019 19:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E817620828
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Dec 2019 19:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaoT3lzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfLJTPB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Dec 2019 14:15:01 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42365 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfLJTPB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Dec 2019 14:15:01 -0500
Received: by mail-lf1-f65.google.com with SMTP id y19so14600972lfl.9;
        Tue, 10 Dec 2019 11:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sssnGQdUpsg/Eg1loSN8PmVozGuxKM7BIKdE0y+0xdU=;
        b=jaoT3lzgDn3ui+a04zf/2bTSL01qab+Ewy7BoghxrMCkeGna0nBVvcrKzV47DEpkLQ
         3Opg/5o+YaKdtLKAie2mVqDILwnUuwT3fb7v3AP/p81Wo9FXplapvF5w9DJMxil3Otnw
         q3Ef57fojlyn3fO4dBYyYqL7dukVW1KQwtoRAXlgNOgMHceMGbiNAgMjHdFmQy582D0f
         D1VnQvxGFgkNdBKYKpIw/rC23AHRfyNmwweVlRhLzN5Ic+eqViUkKttEb8/RqBEAZ5hY
         CgHaUonikmLReKub6qcDhd9lvNlzdsH7gdbvCVSMDnH3uD48aoLpqzBHOGO4z+W5oZLQ
         oDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sssnGQdUpsg/Eg1loSN8PmVozGuxKM7BIKdE0y+0xdU=;
        b=ScSoEgWq9g+/lIc4Q6XAJ0xpUdarsijryB8wkZkYQkHUUpADdrpZP8tHdKlfOHkfqf
         bRXm9g4Kl4DpGh94wEKhSOv3Q4Mi4zfFz1MMSGHieWsxSTnLKtCS4aAFnTBrvSUV1xgH
         XVBJ3DYi6GCEshs3su2F9CdsuuINicEzoFJPolGxVcsb3f2SszY2gZnOOpjeEUQZ1t8M
         jRHhymzdY54IzwvO/griv8Kb8i17kevAUNNJPqhWozZGC+5U1LfrZ29OEeOB6M7x/mbg
         gBHT2HY0K8/k2xNUpeJdXgEJDyLuvbedEJ1Pwxyr1TJ3ERINKu2h5CoYu2oHmWCrhbIP
         L1WA==
X-Gm-Message-State: APjAAAW22RIgnZjCoIvaVXTgVLqEhvB062IU3w0MiGibyty3YxrlGjD+
        7wYmVix0CLyDa+zICVfY4LcgfbW7+nnlIS/GtJUAUMY=
X-Google-Smtp-Source: APXvYqwVC0uMkxeKDt75jcZikSPTeOGIkIwAZb4GtJ8OzcyMuqrwgBZ/F2cPBt4JqC+Q4EXZSHO6gdkQ5VxWE3rg0bA=
X-Received: by 2002:ac2:57cc:: with SMTP id k12mr6119304lfo.36.1576005299289;
 Tue, 10 Dec 2019 11:14:59 -0800 (PST)
MIME-Version: 1.0
References: <20190829050237.GA5161@jagdpanzerIV> <CAKywueRd4d_fojGL+n4BisoibhgkYfN9Wyc_+0=-1sarz4-HZw@mail.gmail.com>
 <20190921223847.GB29065@ZenIV.linux.org.uk> <CAKywueSC=MoBB6t2OeUiyc6+GST2Jgg8FTO-kkXif-pn+1k-cw@mail.gmail.com>
 <20191209003413.GY4203@ZenIV.linux.org.uk>
In-Reply-To: <20191209003413.GY4203@ZenIV.linux.org.uk>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 10 Dec 2019 11:14:48 -0800
Message-ID: <CAKywueTZWUeN85CMDsmV6kJXmjx3kzgTtpegi_ctLN4bMKZtmA@mail.gmail.com>
Subject: Re: build_path_from_dentry_optional_prefix() may schedule from
 invalid context
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=81, 8 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 16:34, Al Viro <vir=
o@zeniv.linux.org.uk>:
>
> On Mon, Sep 30, 2019 at 10:32:16AM -0700, Pavel Shilovsky wrote:
> > =D1=81=D0=B1, 21 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 15:38, A=
l Viro <viro@zeniv.linux.org.uk>:
>
> > > IOW, kindly lose that nonsense.  More importantly, why bother
> > > with that kmalloc()?  Just __getname() in the very beginning
> > > and __putname() on failure (and for freeing the result afterwards).
> > >
> > > What's more, you are open-coding dentry_path_raw(), badly.
> > > The only differences are
> > >         * use of dirsep instead of '/' and
> > >         * a prefix slapped in the beginning.
> > >
> > > I'm fairly sure that
> > >         char *buf =3D __getname();
> > >         char *s;
> > >
> > >         *to_free =3D NULL;
> > >         if (unlikely(!buf))
> > >                 return NULL;
> > >
> > >         s =3D dentry_path_raw(dentry, buf, PATH_MAX);
> > >         if (IS_ERR(s) || s < buf + prefix_len)
> > >                 __putname(buf);
> > >                 return NULL; // assuming that you don't care about de=
tails
> > >         }
> > >
> > >         if (dirsep !=3D '/') {
> > >                 char *p =3D s;
> > >                 while ((p =3D strchr(p, '/')) !=3D NULL)
> > >                         *p++ =3D dirsep;
> > >         }
> > >
> > >         s -=3D prefix_len;
> > >         memcpy(s, prefix, prefix_len);
> > >
> > >         *to_free =3D buf;
> > >         return s;
> > >
> > > would end up being faster, not to mention much easier to understand.
> > > With the caller expected to pass &to_free among the arguments and
> > > __putname() it once it's done.
> > >
> > > Or just do __getname() in the caller and pass it to the function -
> > > in that case freeing (in all cases) would be up to the caller.
> >
> > Thanks for pointing this out. Someone should look at this closely and
> > clean it up.
>
> Could you take a look through vfs.git#misc.cifs?

Looks good. I would only add the same or a similar comment as
fs/hostfs/hostfs_kern.c has when calling dentry_path_raw():

/*
* This function relies on the fact that dentry_path_raw() will place
* the path name at the end of the provided buffer.
*/

Otherwise it is not straightforward at the first glance how the code works.

Acked-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
