Return-Path: <SRS0=KPcv=IF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D32CC433E6
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Mar 2021 03:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 134D465073
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Mar 2021 03:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhCGDOn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Mar 2021 22:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhCGDOU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Mar 2021 22:14:20 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D097C061760
        for <linux-cifs@vger.kernel.org>; Sat,  6 Mar 2021 19:14:20 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id b10so6452472ybn.3
        for <linux-cifs@vger.kernel.org>; Sat, 06 Mar 2021 19:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HRkOMQRE9ZQI6/ecyMTB/3ZUgsI8wz8FW94RV81ANTw=;
        b=OYNMRxe/PYct7DDIEa9A+hQtpu2tyIoKcyZ7viTQndrD8DCszitRbL++sm4Ysn3zD3
         H0XgcSimun6ZTi17ZDE4U1nfy1JGau+83QZGdqYkN2hxGGdU6kMIbfezseppOvxgTXZR
         QuLM3hLwz3R4+G1GitrynnrnBa35lKUnfLDzsegcqLQ5VrHeKWC+V2uo74aQoflwBLMC
         3HJqzNKaW006tniCm/nAk9W3tJ3FhDCtoC2E1+lASqyZUJSzeluz17grEonsH8KhMbvm
         RoLb4k0x4O+3clS6ehbimPrTgqWxlqh9dskV/IC7JNbSEH9jACV8V2tP0osBIc9xMdsO
         sCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HRkOMQRE9ZQI6/ecyMTB/3ZUgsI8wz8FW94RV81ANTw=;
        b=l9tQwLdisK0CWNAq87RjlIxmvHPJdRj4RzJIpbC+rvQP5uZ75xWbIHSFJmSwcp5DEP
         cT6bcwgi4LBWVVhbqfepFhW56UI3NY8azESVYwLYZg8nBNEZESHNOmMNbo5pLEi5KZP9
         f4CaGZGsTe7R+XHQl6VCuhnUi0+CVcVsVikNSFtrvOWqFdfIFzKB2YzWovzfWB72dIB0
         mn7JVNCtQSyWXdEM6y/tKIH54C2k4IGvW9iI0g5aqB8KqJp+t8tQOhR2HBvze5GAZYOZ
         /+zilA8G+71pjSJjVqfX/12gRk1DsOa4Ixs52r5WkZe0lziszj7mrCqQJXMrnIsQ8Ij/
         1FSA==
X-Gm-Message-State: AOAM533s1Pq4WeDhmjD/yIk/uOYzp5dhMGYbtJGJ3NPcCEvgeP1uvgbS
        W+vad8ypMIzR0al6TUpvmua+KTUcgVBK746gJDfx8/Pj/4yjAg==
X-Google-Smtp-Source: ABdhPJzArsC92ufn2ZHEWS/fKBU1KNouBZcydnEG/U1zhJKR8kJ0t3pefWPQMK6S7eTC2l4YK2DUo+BQJMEa1AQWH48=
X-Received: by 2002:a25:9a01:: with SMTP id x1mr25323147ybn.185.1615086859501;
 Sat, 06 Mar 2021 19:14:19 -0800 (PST)
MIME-Version: 1.0
References: <20210305142407.23652-1-aaptel@suse.com> <CAH2r5mufnuA4cavG8JYq2q+-9kY3oHeoQrLyzeXgN2xFQ8P6_w@mail.gmail.com>
In-Reply-To: <CAH2r5mufnuA4cavG8JYq2q+-9kY3oHeoQrLyzeXgN2xFQ8P6_w@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 7 Mar 2021 08:44:08 +0530
Message-ID: <CANT5p=pzh7a9v1q15m056i=cN-MC4W2W2Lx3P68itHzd5EQnnQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: try to pick channel with a minimum of credits
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Spent some time in this code path. Seems like this is more complicated
than I initially thought.
@Aur=C3=A9lien Aptel A few things to consider:
1. What if the credits that will be needed by the request is more than
3 (or any constant). We may still end up returning -EDEADLK to the
user when we don't find enough credits, and there are not enough
in_flight to satisfy the request. Ideally, we should still try other
channels.
2. Echo and oplock use 1 reserved credit each, which the regular
operations can steal, in case of shortage.
3. Reading server->credits without a lock can result in wildly
different values, since some CPU architectures may not update it
atomically. At worse, we may select a channel which may not have
enough credits when we get to it.

What if we do this...
wait_for_compound_request() can return -EDEADLK when it doesn't get
enough credits, and there are no requests in_flight.
In compound_send_recv(), after we call wait_for_compound_request(), we
can check it's return value. If it's -EDEADLK, we keep calling
cifs_pick_another_channel(ses, bitmask) (bitmask has bits set for
channels already selected and rejected) and
wait_for_compound_request() in a loop till we find a channel which has
enough credits, or we run out of channels; in which case we can return
-EDEADLK.
Makes sense? Do you see a problem with that approach?

Regards,
Shyam

On Fri, Mar 5, 2021 at 9:40 PM Steve French <smfrench@gmail.com> wrote:
>
> The comment caught my attention - is that accurate?  When a channel
> has fewer than 3 credits (assuming we had two reserved for oplock and
> echo), that doesn't mean that there are fewer than 3 credits in flight
> - just that current credits available is lower right?  So the channel
> could still recover as long as current credits + credits in flight is
> at least 3.
>
> +/*
> + * Min number of credits for a channel to be picked.
> + *
> + * Note that once a channel reaches this threshold it will never be
> + * picked again as no credits can be requested from it.
> + */
> +#define CIFS_CHANNEL_MIN_CREDITS 3
>
> On Fri, Mar 5, 2021 at 8:24 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > From: Aurelien Aptel <aaptel@suse.com>
> >
> > Check channel credits to prevent the client from using a starved
> > channel that cannot send anything.
> >
> > Special care must be taken in selecting the minimum value: when
> > channels are created they start off with a small amount that slowly
> > ramps up as the channel gets used. Thus a new channel might never be
> > picked if the min value is too small.
> >
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > ---
> >  fs/cifs/transport.c | 57 ++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 49 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index e90a1d1380b0..7bb1584b3724 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -44,6 +44,14 @@
> >  /* Max number of iovectors we can use off the stack when sending reque=
sts. */
> >  #define CIFS_MAX_IOV_SIZE 8
> >
> > +/*
> > + * Min number of credits for a channel to be picked.
> > + *
> > + * Note that once a channel reaches this threshold it will never be
> > + * picked again as no credits can be requested from it.
> > + */
> > +#define CIFS_CHANNEL_MIN_CREDITS 3
> > +
> >  void
> >  cifs_wake_up_task(struct mid_q_entry *mid)
> >  {
> > @@ -1051,20 +1059,53 @@ cifs_cancelled_callback(struct mid_q_entry *mid=
)
> >  struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
> >  {
> >         uint index =3D 0;
> > +       struct TCP_Server_Info *s;
> >
> >         if (!ses)
> >                 return NULL;
> >
> > -       if (!ses->binding) {
> > -               /* round robin */
> > -               if (ses->chan_count > 1) {
> > -                       index =3D (uint)atomic_inc_return(&ses->chan_se=
q);
> > -                       index %=3D ses->chan_count;
> > -               }
> > -               return ses->chans[index].server;
> > -       } else {
> > +       if (ses->binding)
> >                 return cifs_ses_server(ses);
> > +
> > +       /*
> > +        * Channels are created right after the session is made. The
> > +        * count cannot change after that so it is not racy to check.
> > +        */
> > +       if (ses->chan_count =3D=3D 1)
> > +               return ses->chans[index].server;
> > +
> > +       /* round robin */
> > +       index =3D (uint)atomic_inc_return(&ses->chan_seq);
> > +       index %=3D ses->chan_count;
> > +       s =3D ses->chans[index].server;
> > +
> > +       /*
> > +        * Checking server credits is racy, but getting a slightly
> > +        * stale value should not be an issue here
> > +        */
> > +       if (s->credits <=3D CIFS_CHANNEL_MIN_CREDITS) {
> > +               uint i;
> > +
> > +               cifs_dbg(VFS, "cannot pick conn_id=3D0x%llx not enough =
credits (%u)",
> > +                        s->conn_id,
> > +                        s->credits);
> > +
> > +               /*
> > +                * Look at all other channels starting from the next
> > +                * one and pick first possible channel.
> > +                */
> > +               for (i =3D 1; i < ses->chan_count; i++) {
> > +                       s =3D ses->chans[(index+i) % ses->chan_count].s=
erver;
> > +                       if (s->credits > CIFS_CHANNEL_MIN_CREDITS)
> > +                               return s;
> > +               }
> >         }
> > +
> > +       /*
> > +        * If none are possible, keep the initially picked one, but
> > +        * later on it will block to wait for credits or fail.
> > +        */
> > +       return ses->chans[index].server;
> >  }
> >
> >  int
> > --
> > 2.30.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
