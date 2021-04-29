Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F71C433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 12:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7604D613F4
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 12:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhD2MaQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 08:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhD2MaO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 08:30:14 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB85CC06138B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 05:29:27 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id y2so76146714ybq.13
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 05:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cGMUWTEGzHVEUhHxhB3mAkueIaLLtA5gUrlgFPv3M9s=;
        b=EUfiz9hIE9R752Kcoy7AKXHU9eLVWi3bNWN+PKyMjVYpaB2B8R4d4K92UcQ0c6AU95
         ZLrTvdcdrI0PngTDVFbDpvVF4zD0yQ9h0pm3rlP43g0IDDP5XqtNG3f9+1KpA2VPDKuu
         8CNE3TpCQyw049/T0FB4ry8XRsdzex5iViNuuHJSdsL0FJDcLjogJXCbbFHWHWmmMskr
         AUgQsedkTUrP4ltyveE4udPLgXWr8ZV4mhQo1n2ZhtuLw01gzcZ0Sf1szwNzIKk3RZ3j
         qaSnSIJaENmG8KiTaeHGnCkZ4mqiWwMrwmtTGA/YLEXiZmUz0h+DE7mfXP2SrHz/f1oi
         1O+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cGMUWTEGzHVEUhHxhB3mAkueIaLLtA5gUrlgFPv3M9s=;
        b=rHIhquwoes1dD33tt2gPi6ym3ndzmZtn61nxVlealK6J57e2dh7dApC+tz13ziOCS4
         9mTx+Wqk6olgYaFNVERtuM4Jwtu6Wy8TLIgfirSG0q3FvJAWN0pUchJMp0HV0zbpa3VL
         saHjUI+mxJRUxM++kxqoN4iHxoB5u236Qx7CiGvRozUzvWRsXQBGWUtfbfOeUaigScN7
         LTcs5ENhklnfNTi1gmGMwRVRrCTCjSBfwo9m21KHByYT8lei//EJaSq/02tAAK1JJr+r
         tlG/IRyee+u+3dmZuFoUzuRuKkWW6PqwfVxSBMIverNg8nD8kDnuaZMaK0wGLZFttzrZ
         3Bpg==
X-Gm-Message-State: AOAM531PgAh58ZfXvtuUWmij5+xvuoGfDlEQ/0VeI4x5iILFoCAkRnxg
        niLbFRQS7H+VpKEH7GxGroIyCyMbCB3Ye9gS40g3JzPVw7Y=
X-Google-Smtp-Source: ABdhPJw1duLVWYCslxneR7cczcFevCkypX4ZKt/BUorSmVYrhCjIXjyLqXbY2+mznAZ+f3Bwz+QlgRbzwwqoviwcc8A=
X-Received: by 2002:a05:6902:526:: with SMTP id y6mr38057918ybs.331.1619699366209;
 Thu, 29 Apr 2021 05:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qykPGoWwtfSdXe9BsXp083M9-7zaAXJgkPok0Onp6Zow@mail.gmail.com>
 <87zgxhuxdd.fsf@suse.com>
In-Reply-To: <87zgxhuxdd.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 29 Apr 2021 17:59:15 +0530
Message-ID: <CANT5p=ojeaoyifJ-6bxc0mGnAnYqgUH5=W8exhjf=8Hjfat5Eg@mail.gmail.com>
Subject: Re: [PATCH] cifs: detect dead connections only when echoes are enabled.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aur=C3=A9lien,

Replies below...

On Thu, Apr 29, 2021 at 5:16 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
>
> Hi Shyam,
>
> Ok so I ended up looking at a lot of code to check this... And I'm still
> unsure.
>
> First, it looks like server->echoes is only used for smb2 and there is
> a generic server->ops->can_echo() you can use that just returns
> server->echoes it for smb2.
Agree. I can use can_echo() instead.

>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Hi,
> >
> > Recently, some xfstests and later some manual testing on multi-channel
> > revealed that we detect unresponsive servers on some of the channels
> > to the same server.
> >
> > The issue is seen when a channel is setup and sits idle without any
> > traffic. Generally, we enable echoes and oplocks on a channel during
> > the first request, based on the number of credits available on the
> > channel. So on idle channels, we trip in our logic to check server
> > unresponsiveness.
>
> That makes sense but while looking at the code I see we always queue
> echo request in cifs_get_tcp_session(), which is called when adding a
> channel.
>
> cifs_ses_add_channel() {
>         ctx.echo_interval =3D ses->server->echo_interval / HZ;
>
>         chan->server =3D cifs_get_tcp_session(&ctx);
>
>         rc =3D cifs_negotiate_protocol(xid, ses) {
>                 server->tcpStatus =3D CifsGood;
>         }
>
>         rc =3D cifs_setup_session(xid, ses, cifs_sb->local_nls);
> }
>
> cifs_get_tcp_session() {
>
>         INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
>
>         tcp_ses->tcpStatus =3D CifsNeedNegotiate;
>
>         tcp_ses->lstrp =3D jiffies;
>
>         if (ctx->echo_interval >=3D SMB_ECHO_INTERVAL_MIN &&
>                 ctx->echo_interval <=3D SMB_ECHO_INTERVAL_MAX)
>                 tcp_ses->echo_interval =3D ctx->echo_interval * HZ;
>         else
>                 tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DEFAULT * HZ=
;
>
>         queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_inte=
rval);
> }
>
> cifs_echo_request() {
>
>         if (server->tcpStatus =3D=3D CifsNeedNegotiate)
>                 echo_interval =3D 0; <=3D=3D=3D branch taken
>         else
>                 echo_interval =3D server->echo_interval;
>
>         if (server->tcpStatus not in {NeedReconnect, Exiting, New}
>            && server->can_echo()
>            && jiffies > server->lstrp + echo_interval - HZ)
>         {
>                 server->echo();
>         }
>
>         queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interv=
al);
>         =3D=3D=3D> echo_interval =3D 0 so calls itself immediatly
> }
>
> SMB2_echo() {
>         if (server->tcpStatus =3D=3D CifsNeedNegotiate) {
>                 /* No need to send echo on newly established connections =
*/
>                 mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
>                 =3D=3D=3D=3D> calls smb2_reconnect_server() immediatly if=
 NeedNego
>                 return rc;
>         }
>
> }
>
> smb2_reconnect_server() {
>         // channel has no TCONs so it does essentially nothing
> }
>
> server_unresponsive() {
>         if (server->tcpStatus in {Good, NeedNegotiate}
>            && jiffies > server->lstrp + 3 * server->echo_interval)
>         {
>                 cifs_server_dbg(VFS, "has not responded in %lu seconds. R=
econnecting...\n",
>                          (3 * server->echo_interval) / HZ);
>                 cifs_reconnect(server);
>                 return true;
>         }
>         return false;
> }
>
> So it looks to me that cifs_get_tcp_session() starts the
> cifs_echo_request() work, which calls itself with no delay in an
> infinite loop doing nothing (that's probably bad...) until session_setup
> succeeds, after which the delay between the self-call is set.

Perhaps we think that 1 sec is too much for us to complete negotiate?
But echo_interval of 0 looks bad.

Ideally, we should queue echo work only when session setup is complete.
What do you think?

>
> During session_setup():
>
> * last response time (lstrp) gets updated
>
> * sending/recv requests should interact with the server
>   credits and call change_conf(), which should enable server->echoes
>   =3D=3D> is that part not working?
It's working. But since these channels are idle, change_conf is not
called for these channels.
So echoes=3Dfalse till there's some activity on the channel.

>
> Once enabled, the echo_request workq will finally send the echo on the
> wire, which should -/+ 1 credit and update lstrp.
>
> > Attached a one-line fix for this. Have tested it in my environment.
> > Another approach to fix this could be to enable echoes during
> > initialization of a server struct. Or soon after the session setup.
> > But I felt that this approach is better. Let me know if you feel
> > otherwise.
>
> I think the idea of your change is ok but there's probably also an issue
> in crediting in session_setup()/change_conf() if echoes is not enabled
> at this point no?
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Regards,
Shyam
