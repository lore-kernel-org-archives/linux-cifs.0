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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83C9C43333
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 17:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD49B206B5
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 17:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbhAURNu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jan 2021 12:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388555AbhAURMs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jan 2021 12:12:48 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FA5C061756
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jan 2021 09:11:51 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h16so3370590edt.7
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jan 2021 09:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d5pshfO3tsD/FzXKvgANQZhbkBu540LOznVrSmI3SD4=;
        b=OO6uAMLFjvvdYZkvRgZEaLryXb0vJ2S8vugl4ngYzPCnqWeJng0/cIvT0OriS22B8X
         5YUT0DETPee1bTZRzVCRuThO2XUZ66lq9QPyVwDjluFj+JrNnjFLRKGtMIleHdyPhDXf
         XTm32Ze3ocKHO6V019DOynE0kHEay5X/AEN+nOChjuq2XIEaXko1ELrxGlkvX3bxdgQv
         AJDsSdlnRJeZWZjMC2bvyOiuhhcdRzNaQ3GBLEhhxm3QZGUyagJKIPR1bGKvihzPTUxG
         SKKrxmvTac/lTlqo4GW2mZgaacevL1D0GSVIrHPsCDPpHji4L2vneIrAgXVtPuXr88zD
         Ldog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d5pshfO3tsD/FzXKvgANQZhbkBu540LOznVrSmI3SD4=;
        b=cfYCfRSw82FtLEqhh2lmI9k+RuAammZz2JOiuQuE77r2jTKSswJ9MYJxbfn2g1DLTT
         wYOCRFgN6dGYkzvOgNXMeTq+hl4R0MehNd7+iif4umVUQN/2aszK5KSFnRiiFGh5QcGd
         g81XuXod8C+tqKzDf+dsN/GVhQnPX9/PPk0CJ2MdhZRcRX2xmMY0wyFDj2rZUOWSs1LI
         9n+lvH+eVaTkPQHyFnlLsMSoRVVocFapC2aRdWPdA5imoWz4Y5NaqPkYEEn6Xc/gcSab
         Be3Ir8qwxgDi+WKot3CeffNVOQFjAySxBESzaoA/ws8OTlIsvbUh5qQdZpmYYynvtucB
         wlDw==
X-Gm-Message-State: AOAM533MI1VyFuVJXG+/5e9FLoXKw2fmKLVZDnLcdxdgkUzIL4zVhFNF
        4dsV+jJoaiYllfMZmkiS+qgIgTBuo8XNOLatOIOHbUIi6A==
X-Google-Smtp-Source: ABdhPJzdjgAoBhPQ2Qbu9Ih9N3Bx3oRh6fSH3U75ZHCXga27nMuf98KRYaZmWJTCZmbKcCEIWFE6WgtEoX10bqPz3aI=
X-Received: by 2002:aa7:d78e:: with SMTP id s14mr80368edq.329.1611249110334;
 Thu, 21 Jan 2021 09:11:50 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz>
In-Reply-To: <877do6zdqp.fsf@cjr.nz>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 21 Jan 2021 09:11:38 -0800
Message-ID: <CAKywueQAtjAoN1xWrvSS79TVOpBGO8aJS4YU8gr5ud69v5KnOg@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 21 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 04:16, Paulo Alcan=
tara <pc@cjr.nz>:
>
> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>
> > Pavel Shilovsky <piastryyy@gmail.com> writes:
> >
> >> =D0=B2=D1=82, 19 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 22:38, Steve =
French <smfrench@gmail.com>:
> >>>
> >>> The patch won't merge (also has some text corruptions in it).  This
> >>> line of code is different due to commit 6988a619f5b79
> >>>
> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
> >>>  cifs_dbg(FYI, "signal pending before send request\n");
> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
> >>>  return -ERESTARTSYS;
> >>>
> >>>         if (signal_pending(current)) {
> >>>                 cifs_dbg(FYI, "signal pending before send request\n")=
;
> >>>                 return -ERESTARTSYS;
> >>>         }
> >>>
> >>> See:
> >>>
> >>> Author: Paulo Alcantara <pc@cjr.nz>
> >>> Date:   Sat Nov 28 15:57:06 2020 -0300
> >>>
> >>>     cifs: allow syscalls to be restarted in __smb_send_rqst()
> >>>
> >>>     A customer has reported that several files in their multi-threade=
d app
> >>>     were left with size of 0 because most of the read(2) calls return=
ed
> >>>     -EINTR and they assumed no bytes were read.  Obviously, they coul=
d
> >>>     have fixed it by simply retrying on -EINTR.
> >>>
> >>>     We noticed that most of the -EINTR on read(2) were due to real-ti=
me
> >>>     signals sent by glibc to process wide credential changes (SIGRT_1=
),
> >>>     and its signal handler had been established with SA_RESTART, in w=
hich
> >>>     case those calls could have been automatically restarted by the
> >>>     kernel.
> >>>
> >>>     Let the kernel decide to whether or not restart the syscalls when
> >>>     there is a signal pending in __smb_send_rqst() by returning
> >>>     -ERESTARTSYS.  If it can't, it will return -EINTR anyway.
> >>>
> >>>     Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> >>>     CC: Stable <stable@vger.kernel.org>
> >>>     Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >>>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> >>>
> >>> On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@redhat.com=
> wrote:
> >>> >
> >>> > RHBZ 1848178
> >>> >
> >>> > There is no need to fail this function if non-fatal signals are
> >>> > pending when we enter it.
> >>> >
> >>> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >>> > ---
> >>> >  fs/cifs/transport.c | 2 +-
> >>> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >>> >
> >>> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >>> > index c42bda5a5008..98752f7d2cd2 100644
> >>> > --- a/fs/cifs/transport.c
> >>> > +++ b/fs/cifs/transport.c
> >>> > @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server,=
 int num_rqst,
> >>> >         if (ssocket =3D=3D NULL)
> >>> >                 return -EAGAIN;
> >>> >
> >>> > -       if (signal_pending(current)) {
> >>> > +       if (fatal_signal_pending(current)) {
> >>> >                 cifs_dbg(FYI, "signal is pending before sending any=
 data\n");
> >>> >                 return -EINTR;
> >>> >         }
> >
> > I've looked up the difference
> >
> > static inline int __fatal_signal_pending(struct task_struct *p)
> > {
> >       return unlikely(sigismember(&p->pending.signal, SIGKILL));
> > }
> >
> >
> >> I have been thinking around the same lines. The original intent of
> >> failing the function here was to avoid interrupting packet send in the
> >> middle of the packet and not breaking an SMB connection.
> >> That's also why signals are blocked around smb_send_kvec() calls. I
> >> guess most of the time a socket buffer is not full, so, those
> >> functions immediately return success without waiting internally and
> >> checking for pending signals. With this change the code may break SMB
> >
> > Ah, interesting.
> >
> > I looked up the difference between fatal/non-fatal and it seems
> > fatal_signal_pending() really only checks for SIGKILL, but I would
> > expect ^C (SIGINT) to return quickly as well.
> >
> > I thought the point of checking for pending signal early was to return
> > quickly to userspace and not be stuck in some unkillable state.
> >
> > After reading your explanation, you're saying the kernel funcs to send
> > on socket will check for any signal and err early in any case.
> >
> > some_syscall() {
> >
> >     if (pending_fatal_signal)  <=3D=3D=3D=3D=3D if we ignore non-fatal =
here
> >         fail_early();
> >
> >     block_signals();
> >     r =3D kernel_socket_send {
> >         if (pending_signal) <=3D=3D=3D=3D they will be caught here
> >             return error;

As far as I understood, pending signal checking only happens if TCP
buffers are full and the kernel is waiting for the free space there to
put SMB packet. Otherwise TCP send returns immediately without waiting
and checking for signals. See:

https://elixir.bootlin.com/linux/latest/source/net/ipv4/tcp.c#L1404
https://elixir.bootlin.com/linux/latest/source/net/core/stream.c#L137

> >
> >         ...
> >     }
> >     unblock_signals();
> >     if (r)
> >         fail();
> >     ...
> > }
> >
> > So this patch will (potentially) trigger more reconnect (because we
> > actually send the packet as a vector in a loop) but I'm not sure I
> > understand why it returns less errors to userspace?

There are many situations when there is a non-fatal signal pending
before entering __smb_send_rqst() which won't result in being stuck
waiting for a free space in TCP buffers (most times there is a space).
So, with Ronnie's patch we allow signal to still be pending while we
are sending an SMB packet. If TCP buffers become full in the middle,
then yes, we will return the interrupt failure to the caller.

> >
> > Also, shouldn't we move the pending_fatal_signal check *inside* the blo=
cked
> > signal section?

We most likely should, but I would avoid doing this for stable kernels
to play safe.

> >
> > In any case I think we should try to test some of those changes given
> > how we have 3,4 patches trying to tweak it on top of each other.

Agree. I also think we should amend Ronnies' patch with the change to
the following place:

-----------
/*
* If signal is pending but we have already sent the whole packet to
* the server we need to return success status to allow a corresponding
* mid entry to be kept in the pending requests queue thus allowing
* to handle responses from the server by the client.
*
* If only part of the packet has been sent there is no need to hide
* interrupt because the session will be reconnected anyway, so there
* won't be any response from the server to handle.
*/

if (signal_pending(current) && (total_len !=3D send_length)) {
cifs_dbg(FYI, "signal is pending after attempt to send\n");
rc =3D -EINTR;
        ^^^
        This should be changed to -ERESTARTSYS to allow kernel to
restart a syscall.

}
-----------

> I think it would make sense to have something like
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e9abb41aa89b..f7292c14863e 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -340,7 +340,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int n=
um_rqst,
>
>         if (signal_pending(current)) {
>                 cifs_dbg(FYI, "signal pending before send request\n");
> -               return -ERESTARTSYS;
> +               return __fatal_signal_pending(current) ? -EINTR : -ERESTA=
RTSYS;
>         }
>
>         /* cork the socket */
>
> so that we allow signal handlers to be executed before restarting
> syscalls when receiving non-fatal signals, otherwise -EINTR.

Even if this is fatal signal, what harm is to return -ERESTARTSYS
unconditionally? It seems that the signal will be handled and the
process will be terminated anyway.

--
Best regards,
Pavel Shilovsky
