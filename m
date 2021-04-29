Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDADFC433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 17:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7AC761001
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 17:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhD2RiQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 13:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbhD2RiQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 13:38:16 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B2CC06138B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 10:37:29 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id s9so19519588ljj.6
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 10:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zla1wiboWKW5nnUQEoImByulWqdSBzQIDQS48w0btSQ=;
        b=Qgcv5/dHErYtgJAdVjd/2X7d52otZP7NZ8PU8YewBhjttTZgpTawyYjglf17fdtxUh
         QZJW8XkUuTTJE8Fqj2ZLfIHlpta9DV0aAyUrJ1/Z4TJsDGReBj9IUFwsA5MriZ4qwJQ9
         G5Rpmve/nnTDs7RzU+nX36wDcM3+Chksy3FArPl9gzzO2dKGn/ZuBiBlzc4qJVSbc+4P
         qD0kLhvOa890dh49Grdqe/mvLh93Xc+NBPVVkiZaJvfRbZI/hKjgzyJE8VJN2CQepeI5
         dXl27bQ00tCaHwBQSZxshKRebOO63gH62+2kIj+HcBVSZsPk/tJFeZvga92rsxK1gPwB
         rVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zla1wiboWKW5nnUQEoImByulWqdSBzQIDQS48w0btSQ=;
        b=jTLas+b8zQmYBpopq9JvAHQ0oPwFpi0TnJsMTVsjSJzGd2CS7h8WY3rqrRyPZyxF6J
         /4y4gHsT0lZ/dXOvMhKM7wXKEvhw559oPxj7btpYgPq3Q30DJ/Ld/MT04R453eJb6Ktj
         njkTzDaGwKgpGXbsACvOdLgUpeyKu8oWFneipMwbXjJjBAQSJSJP/2jSUzpY/wwuHe64
         tz+QXcDq+vdRk0jynryrwiH8MCS8qA9uFDyVdMVT78WbkrKR69YtGNdK0mA1lHhtxow6
         TFVoC8NHq0eu6pTpgt5YKYRFcApx+t9v7T9G2CjmGW81gT8rF38n5eUIFLMfPH+WeWz/
         CPyQ==
X-Gm-Message-State: AOAM533n++XYZle46TIKvdqOxawwqyUF29yp4wH6ifEOesS3p3BnZ5Js
        v6SwHnS4ygAJPJRAtMx4VnyjbiUh6JTGW7cEE641tBii
X-Google-Smtp-Source: ABdhPJzQm2782mFztY8FKT9tJoL1XABFou2XeX8mZhPUQHy+F+GHW5JGtK+QvW9/d0+x3o5PgI+00xTZgfNT0CJ6ySo=
X-Received: by 2002:a2e:3208:: with SMTP id y8mr568941ljy.477.1619717847258;
 Thu, 29 Apr 2021 10:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qykPGoWwtfSdXe9BsXp083M9-7zaAXJgkPok0Onp6Zow@mail.gmail.com>
 <87zgxhuxdd.fsf@suse.com> <CANT5p=ojeaoyifJ-6bxc0mGnAnYqgUH5=W8exhjf=8Hjfat5Eg@mail.gmail.com>
 <CANT5p=oeCf3VeyFECPeUrnGwQM71pehj=o0t25z-+hWmpY+bSg@mail.gmail.com>
In-Reply-To: <CANT5p=oeCf3VeyFECPeUrnGwQM71pehj=o0t25z-+hWmpY+bSg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Apr 2021 12:37:16 -0500
Message-ID: <CAH2r5muj4gSPnaaPeWyXWgE7dCU=r-TFtS8044gZAvw1mJ6tZA@mail.gmail.com>
Subject: Re: [PATCH] cifs: detect dead connections only when echoes are enabled.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This also reminds me ... perhaps we should increase the echo timeout
when using multichannel, so we don't unnecessarily increase traffic to
the server. Thoughts?

Currently SMB_ECHO_INTERVAL_DEFAULT is 60 seconds

On Thu, Apr 29, 2021 at 10:48 AM Shyam Prasad N <nspmangalore@gmail.com> wr=
ote:
>
> Attaching updated patch with can_echo() instead of referencing echoes dir=
ectly.
> I'll submit another patch for the other changes.
>
> Regards,
> Shyam
>
> On Thu, Apr 29, 2021 at 5:59 PM Shyam Prasad N <nspmangalore@gmail.com> w=
rote:
> >
> > Hi Aur=C3=A9lien,
> >
> > Replies below...
> >
> > On Thu, Apr 29, 2021 at 5:16 PM Aur=C3=A9lien Aptel <aaptel@suse.com> w=
rote:
> > >
> > >
> > > Hi Shyam,
> > >
> > > Ok so I ended up looking at a lot of code to check this... And I'm st=
ill
> > > unsure.
> > >
> > > First, it looks like server->echoes is only used for smb2 and there i=
s
> > > a generic server->ops->can_echo() you can use that just returns
> > > server->echoes it for smb2.
> > Agree. I can use can_echo() instead.
> >
> > >
> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > Hi,
> > > >
> > > > Recently, some xfstests and later some manual testing on multi-chan=
nel
> > > > revealed that we detect unresponsive servers on some of the channel=
s
> > > > to the same server.
> > > >
> > > > The issue is seen when a channel is setup and sits idle without any
> > > > traffic. Generally, we enable echoes and oplocks on a channel durin=
g
> > > > the first request, based on the number of credits available on the
> > > > channel. So on idle channels, we trip in our logic to check server
> > > > unresponsiveness.
> > >
> > > That makes sense but while looking at the code I see we always queue
> > > echo request in cifs_get_tcp_session(), which is called when adding a
> > > channel.
> > >
> > > cifs_ses_add_channel() {
> > >         ctx.echo_interval =3D ses->server->echo_interval / HZ;
> > >
> > >         chan->server =3D cifs_get_tcp_session(&ctx);
> > >
> > >         rc =3D cifs_negotiate_protocol(xid, ses) {
> > >                 server->tcpStatus =3D CifsGood;
> > >         }
> > >
> > >         rc =3D cifs_setup_session(xid, ses, cifs_sb->local_nls);
> > > }
> > >
> > > cifs_get_tcp_session() {
> > >
> > >         INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
> > >
> > >         tcp_ses->tcpStatus =3D CifsNeedNegotiate;
> > >
> > >         tcp_ses->lstrp =3D jiffies;
> > >
> > >         if (ctx->echo_interval >=3D SMB_ECHO_INTERVAL_MIN &&
> > >                 ctx->echo_interval <=3D SMB_ECHO_INTERVAL_MAX)
> > >                 tcp_ses->echo_interval =3D ctx->echo_interval * HZ;
> > >         else
> > >                 tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DEFAULT =
* HZ;
> > >
> > >         queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_=
interval);
> > > }
> > >
> > > cifs_echo_request() {
> > >
> > >         if (server->tcpStatus =3D=3D CifsNeedNegotiate)
> > >                 echo_interval =3D 0; <=3D=3D=3D branch taken
> > >         else
> > >                 echo_interval =3D server->echo_interval;
> > >
> > >         if (server->tcpStatus not in {NeedReconnect, Exiting, New}
> > >            && server->can_echo()
> > >            && jiffies > server->lstrp + echo_interval - HZ)
> > >         {
> > >                 server->echo();
> > >         }
> > >
> > >         queue_delayed_work(cifsiod_wq, &server->echo, server->echo_in=
terval);
> > >         =3D=3D=3D> echo_interval =3D 0 so calls itself immediatly
> > > }
> > >
> > > SMB2_echo() {
> > >         if (server->tcpStatus =3D=3D CifsNeedNegotiate) {
> > >                 /* No need to send echo on newly established connecti=
ons */
> > >                 mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
> > >                 =3D=3D=3D=3D> calls smb2_reconnect_server() immediatl=
y if NeedNego
> > >                 return rc;
> > >         }
> > >
> > > }
> > >
> > > smb2_reconnect_server() {
> > >         // channel has no TCONs so it does essentially nothing
> > > }
> > >
> > > server_unresponsive() {
> > >         if (server->tcpStatus in {Good, NeedNegotiate}
> > >            && jiffies > server->lstrp + 3 * server->echo_interval)
> > >         {
> > >                 cifs_server_dbg(VFS, "has not responded in %lu second=
s. Reconnecting...\n",
> > >                          (3 * server->echo_interval) / HZ);
> > >                 cifs_reconnect(server);
> > >                 return true;
> > >         }
> > >         return false;
> > > }
> > >
> > > So it looks to me that cifs_get_tcp_session() starts the
> > > cifs_echo_request() work, which calls itself with no delay in an
> > > infinite loop doing nothing (that's probably bad...) until session_se=
tup
> > > succeeds, after which the delay between the self-call is set.
> >
> > Perhaps we think that 1 sec is too much for us to complete negotiate?
> > But echo_interval of 0 looks bad.
> >
> > Ideally, we should queue echo work only when session setup is complete.
> > What do you think?
> >
> > >
> > > During session_setup():
> > >
> > > * last response time (lstrp) gets updated
> > >
> > > * sending/recv requests should interact with the server
> > >   credits and call change_conf(), which should enable server->echoes
> > >   =3D=3D> is that part not working?
> > It's working. But since these channels are idle, change_conf is not
> > called for these channels.
> > So echoes=3Dfalse till there's some activity on the channel.
> >
> > >
> > > Once enabled, the echo_request workq will finally send the echo on th=
e
> > > wire, which should -/+ 1 credit and update lstrp.
> > >
> > > > Attached a one-line fix for this. Have tested it in my environment.
> > > > Another approach to fix this could be to enable echoes during
> > > > initialization of a server struct. Or soon after the session setup.
> > > > But I felt that this approach is better. Let me know if you feel
> > > > otherwise.
> > >
> > > I think the idea of your change is ok but there's probably also an is=
sue
> > > in crediting in session_setup()/change_conf() if echoes is not enable=
d
> > > at this point no?
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
> > Regards,
> > Shyam
>
>
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
