Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D5BC433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 08:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0DD361446
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 08:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhD2IZy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 04:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhD2IZx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 04:25:53 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B0EC06138B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 01:25:07 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id l7so2166065ybf.8
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WMZ4nuKn9mi/PEI4MSt2Jcs1tpk8vXiLXpuDYceenZY=;
        b=Q3LaCAK5OrYVv1nNbkxdSaqNc2br4SwbEb09Cr7UoGSkpGZsCU+txWZQdD3n9aJtZW
         +5NtQ9wTKkknQlwQOKQrbuf5jUtTo32LiIXHSLhN86QkF9d9VxK1tn8tg8GGjF0NGbse
         U45BmuuKdT8KgDPq0T4HHIgiBBxFiC3CQRf1nOcpHCw+WSh4BcRIwRjp09qZm8sKiLSF
         lMdF4GmPx3/PkjGHtVR4e2I84SAvl+jHXiwlsAdQi2p2tvCVbT2UxlfLmz/bW8hB4A2o
         4UQq8eDMvlNeul8eYukexqGAqRf7LmERHUd0t0i+vF8LzWeAZ+rykwv22CkUnDjS74UY
         UXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WMZ4nuKn9mi/PEI4MSt2Jcs1tpk8vXiLXpuDYceenZY=;
        b=nSKb53no+ogUlvWkpMdWk/KS1Otsn7wMvA4f4YJkhIbIdKNG4HuqRBlFSWKyh1zuY2
         kadNWauNUcSQzITYAgTUY3AWWbyv5MgUrzoHqvSfIfMQLamU1h+sQlCq0ip8BCnuLTXY
         FD4wuYeFEwbxIxsLcAw0TyePaoPwl/4+u0bhCmCDazKn6kfKBEnkjyja/D0w7xjUHy4f
         JcyYyPmbfPYKEcQ4GQy9ar6SmZCHXf8/JPkJQ0uMBZvBJ1KJter6l4wNspaxEl5scaDP
         0VRFms3GILgAvJge9RO96w0G3t+VoDD65gjS6jzSDY77OGFPXCZxELquM+ebTrKNQTjk
         TcXQ==
X-Gm-Message-State: AOAM5315wMpTuJoXC0dMM8EkWrMfwxlGIoTzBq8XbYBxnPrGSLtBimYJ
        iyV8vwHXRxo/gSt7L3GVFCaE/jkNjPXWrUPPZOQrMZk6
X-Google-Smtp-Source: ABdhPJyXD6j+9PfcLneEAfwMbecKlezE9ombV3dt3Kw3K3us5T6cOi0zI8ta7Z5m+6OrSY7pfbOp6qR5JAX00y1SNNs=
X-Received: by 2002:a25:7085:: with SMTP id l127mr47682856ybc.293.1619684706426;
 Thu, 29 Apr 2021 01:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=peB0L90CN1pVDe6uyrbz2=9jTm865N6938i5-ZJN42Bw@mail.gmail.com>
 <87bl9ywhzf.fsf@suse.com> <CAH2r5mtXGJm=GkLVtJYCrO4WY7x5updXmX7Ouoj-fm0UNUrJMw@mail.gmail.com>
 <CAKywueRHcFcvNQVisGUkH45=ttkdLRKK8jrafqbtCu0kjAkQrQ@mail.gmail.com>
In-Reply-To: <CAKywueRHcFcvNQVisGUkH45=ttkdLRKK8jrafqbtCu0kjAkQrQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 29 Apr 2021 13:54:55 +0530
Message-ID: <CANT5p=qfiF96ajzjNEe20uGj-rHTX_RVDejFF4FmKJvbAS5sMA@mail.gmail.com>
Subject: Re: [PATCH] cifs: when out of credits on one channel, retry on another.
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

Thanks for the reviews.

@Aur=C3=A9lien Aptel The issue came up quite frequently during the tests
due to another bug. I've submitted a patch for the fix, so this should
not come up for a day one scenario again.
This could come up when one or more channels if the server stops
giving out credits because it's heavily loaded. In that case, we
should try on one of the other channels rather than simply giving up.

@Pavel Shilovsky I like your approach better, as there should be a lot
less code churn. Let me explore it further.

Regards,
Shyam

On Thu, Apr 29, 2021 at 1:01 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> I agree this is a good idea to retry if a channel is out of credits.
>
> The proposed solution should work for all operations but writepages.
> For writepages there is an internal logic that marks pages and mapping
> with errors:
>
> 2412                 if (!wdata->cfile) {
> 2413                         cifs_dbg(VFS, "No writable handle in
> writepages rc=3D%d\n",
> 2414                                  get_file_rc);
> 2415                         if (is_retryable_error(get_file_rc))
> 2416                                 rc =3D get_file_rc;
> 2417                         else
> 2418                                 rc =3D -EBADF;
> 2419                 } else
> 2420                         rc =3D wdata_send_pages(wdata, nr_pages,
> mapping, wbc);
> 2421
> 2422                 for (i =3D 0; i < nr_pages; ++i)
> 2423                         unlock_page(wdata->pages[i]);
> 2424
> 2425                 /* send failure -- clean up the mess */
> 2426                 if (rc !=3D 0) {
> 2427                         add_credits_and_wake_if(server,
> &wdata->credits, 0);
> 2428                         for (i =3D 0; i < nr_pages; ++i) {
> 2429                                 if (is_retryable_error(rc))
> 2430                                         redirty_page_for_writepage(w=
bc,
> 2431
> wdata->pages[i]);
> 2432                                 else
> 2433                                         SetPageError(wdata->pages[i]=
);
> 2434                                 end_page_writeback(wdata->pages[i]);
> 2435                                 put_page(wdata->pages[i]);
> 2436                         }
> 2437                         if (!is_retryable_error(rc))
> 2438                                 mapping_set_error(mapping, rc);
> 2439                 }
>
>
> What I think we should do instead is to include -EDEADLK into the set
> of retryable errors conditionally to multi-channel being enabled and
> let cifs_writepages itself use its internal retry mechanism.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=81=D1=80, 28 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 08:35, Steve Fre=
nch <smfrench@gmail.com>:
> >
> > We have a simple repro we are looking at now with 4 channels
> >
> > We start with reasonable number of credits but end up with channels 3
> > and 4 reconnecting and only having one credit on reconnect
> >
> > On Wed, Apr 28, 2021 at 10:23 AM Aur=C3=A9lien Aptel <aaptel@suse.com> =
wrote:
> > >
> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > The idea is to retry on -EDEADLK (which we return when we run out o=
f
> > > > credits and we have no requests in flight), so that another channel=
 is
> > > > chosen for the next request.
> > >
> > > I agree with the idea.
> > >
> > > Have you been able to test those DEADLK codepaths? If so how, because=
 we
> > > should add buildbot tests I think.
> > >
> > > For the function renaming, there is a precedent in the kernel to use =
a _
> > > prefix for "sub-functions" instead of the _final suffix.
> > >
> > > > This fix mostly introduces a wrapper for all functions which call
> > > > cifs_pick_channel. In the wrapper function, the function is retried
> > > > when the error is -EDEADLK, and uses multichannel.
> > >
> > > I think we should put a limit on the number of retries. If it goes ab=
ove
> > > some reasonable number print a warning and return EDEADLK.
> > >
> > > We could also hide the retry logic loop in a macro to avoid code
> > > duplication when possible. This could get rid of multiple simpler fun=
cs
> > > I think if we use the macro in the caller.
> > >
> > > Something like (feel free to improve/modify):
> > >
> > > #define MULTICHAN_RETRY(chan_count, call) \
> > > ({ \
> > >         int __rc; \
> > >         int __tries =3D 0;
> > >         do { \
> > >                 __rc =3D call; \
> > >                 __tries++; \
> > >         } while (__tries < MULTICHAN_MAX_RETRY && __rc =3D=3D -EDEADL=
K && chan_count > 1) \
> > >         WARN_ON(__tries =3D=3D MULTICHAN_MAX_RETRY); \
> > >         __rc; \
> > > })
> > >
> > >
> > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > ---
> > > >  fs/cifs/file.c      |  96 +++++++++++-
> > > >  fs/cifs/smb2inode.c |  93 ++++++++----
> > > >  fs/cifs/smb2ops.c   | 113 +++++++++++++-
> > > >  fs/cifs/smb2pdu.c   | 359 ++++++++++++++++++++++++++++++++++++++++=
----
> > > >  4 files changed, 593 insertions(+), 68 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > > index 7e97aeabd616..7609b9739ce4 100644
> > > > --- a/fs/cifs/file.c
> > > > +++ b/fs/cifs/file.c
> > > > @@ -2378,7 +2378,7 @@ wdata_send_pages(struct cifs_writedata *wdata=
, unsigned int nr_pages,
> > > >       return rc;
> > > >  }
> > > >
> > > > -static int cifs_writepages(struct address_space *mapping,
> > > > +static int cifs_writepages_final(struct address_space *mapping,
> > > >                          struct writeback_control *wbc)
> > > >  {
> > > >       struct inode *inode =3D mapping->host;
> > > > @@ -2543,6 +2543,21 @@ static int cifs_writepages(struct address_sp=
ace *mapping,
> > > >       return rc;
> > > >  }
> > > >
> > > > +static int cifs_writepages(struct address_space *mapping,
> > > > +                        struct writeback_control *wbc)
> > > > +{
> > > > +     int rc;
> > > > +     struct inode *inode =3D mapping->host;
> > > > +     struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> > > > +     struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> > > > +
> > > > +     do {
> > > > +             rc =3D cifs_writepages_final(mapping, wbc);
> > > > +     } while (tcon->ses->chan_count > 1 && rc =3D=3D -EDEADLK);
> > > > +
> > > > +     return rc;
> > > > +}
> > >
> > > cifs_writepages can issue multiple writes. I suspect it can do some
> > > successful writes before it runs out of credit, and I'm not sure if
> > > individual pages are marked as flushed or not. Basically this func mi=
ght
> > > not be idempotent so that's one codepath that we should definitely tr=
y I
> > > think (unless someone knows more and can explain me).
> > >
> > > Same goes for /some/ of the the other funcs... I think this should be
> > > documented/tried.
> > > >
> > > > +static int
> > > > +smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > > > +              struct cifs_sb_info *cifs_sb, const char *full_path,
> > > > +              __u32 desired_access, __u32 create_disposition,
> > > > +              __u32 create_options, umode_t mode, void *ptr, int c=
ommand,
> > > > +              bool check_open, bool writable_path)
> > > > +{
> > >
> > > I would use an int for flags intead of passing those 2 booleans. This
> > > way adding more flags in the future will be easier, and you can use
> > > named enum or defines in the code instead of true/false which will be
> > > more understandable.
> > >
> > > Cheers,
> > > --
> > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnb=
erg, DE
> > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Regards,
Shyam
