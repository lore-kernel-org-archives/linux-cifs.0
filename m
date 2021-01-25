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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E98C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jan 2021 16:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F51225AB
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jan 2021 16:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbhAYQjw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jan 2021 11:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730797AbhAYQjm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jan 2021 11:39:42 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD8DC06174A
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jan 2021 08:39:01 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id x78so13877703ybe.11
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jan 2021 08:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4wrgy3MR1q6wFg3QaVJlUJ5oc8KPtp1fKtFhRDSp8m0=;
        b=Y+NWjbb87a3N4nNQIjk6vOeJ8CTUq6hxQ7bCKkEu1FB69z9tpWGcKRQQKYaYztTsSd
         Kvhpi3pvixM/iDqIsZj4k01vGl2BPsZMRKu5lDoqbCQiIM+bMWvD1hEi0gavTGFqt3PJ
         4iHm2a5pWfzzdY/Cx8sZnbLAAWh+obxocKiiSwRWHfUBYO6D2Pm6GDKZZaQ3WuBhBM3X
         +IC1ytDhDh0Nu3VDx/NOUOIAl6lK0/GHIMJBzm9vun6+QxCj4WtxtOseZBLUr2pfk5HI
         2MPjgtUqx4kmgS1mcKy+iA8lLhOAIF0ULYcbDva1OSx6b4v+G2GIli+iXDLzBjV+V+XR
         p4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4wrgy3MR1q6wFg3QaVJlUJ5oc8KPtp1fKtFhRDSp8m0=;
        b=CkTYG4pqZRfOJKKylONE00dSpz5HiC199e4fnp65aF/MYu83v3+ZdLTgoHgJExSw6f
         0ZcXQQveUnqIvaHIgkL40QeY9jit491yMlTmju7qaBYXkUhajsZRT7QoS+iNlGNxDqaH
         If7K+Dw9ia5i/+jm3TSg40BFNJC/PsacCXPumTNbRM7v+upydKej93z4rWYw+nKAhXBI
         saL+VFvP88qih7owgNfasW+LEqXEb64MEAZU0UcUUDoqV63ld/Dc6lWbTuF0NSullrbe
         xlLroxKk4YUJaEN7MXPwf1VajKbC1LNfs2o6SpxDv7Fc7sf20HStwQC4O1kTk0wH2PNO
         HT+Q==
X-Gm-Message-State: AOAM5326KqQxkR1N1n9nWgnTB40WZBzNxTV3EzoHAECJaCFUiL2lMkI1
        LfS4/lfHDrXVDdxrW2/4Lre/EQII9DbanjwH/az8WYkYVB/VlA==
X-Google-Smtp-Source: ABdhPJwXzXL9ppRck2UAdVr0UGLy2duWN6hFPMRrPDNRiAM66SUIqAwP1GEff5r2saZPlwcwdRWg4qxp1xmZnBDRtrY=
X-Received: by 2002:a25:29c1:: with SMTP id p184mr1906149ybp.34.1611592740676;
 Mon, 25 Jan 2021 08:39:00 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
 <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com>
 <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com> <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com>
In-Reply-To: <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 25 Jan 2021 08:38:49 -0800
Message-ID: <CANT5p=o5pjCLUzLv2=i+T+7XE=0Wxcg3p_TSbAeARAWNzmmgEw@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

Sorry for the late review on this. A few minor comments on __smb_send_rqst(=
):

    if ((total_len > 0) && (total_len !=3D send_length)) { <<<< what's
special about total_len =3D=3D 0? I'm guessing send_length will also be 0
in such a case.
        cifs_dbg(FYI, "partial send (wanted=3D%u sent=3D%zu): terminating
session\n",
             send_length, total_len);
        /*
         * If we have only sent part of an SMB then the next SMB could
         * be taken as the remainder of this one. We need to kill the
         * socket so the server throws away the partial SMB
         */
        server->tcpStatus =3D CifsNeedReconnect;
        trace_smb3_partial_send_reconnect(server->CurrentMid,
                          server->hostname);
    }

I'm not an expert on kernel socket programming, but if total_len !=3D
sent_length, shouldn't we iterate retrying till they become equal (or
abort if there's no progress)?
I see that we cork the connection before send, and I guess it's
unlikely why only a partial write will occur (Since these are just
in-memory writes).
But what is the reason for reconnecting on partial writes?

smbd_done:
    if (rc < 0 && rc !=3D -EINTR)   <<<<< Not very critical, but
shouldn't we also check for rc !=3D -ERESTARTSYS?
        cifs_server_dbg(VFS, "Error %d sending data on socket to server\n",
             rc);
    else if (rc > 0)
        rc =3D 0;

    return rc;
}

Regards,
Shyam

On Fri, Jan 22, 2021 at 11:34 PM Steve French <smfrench@gmail.com> wrote:
>
> Patch updated with Pavel's suggestion, and added a commit description
> from various comments in this email thread (see attached).
>
>     cifs: do not fail __smb_send_rqst if non-fatal signals are pending
>
>     RHBZ 1848178
>
>     The original intent of returning an error in this function
>     in the patch:
>       "CIFS: Mask off signals when sending SMB packets"
>     was to avoid interrupting packet send in the middle of
>     sending the data (and thus breaking an SMB connection),
>     but we also don't want to fail the request for non-fatal
>     signals even before we have had a chance to try to
>     send it (the reported problem could be reproduced e.g.
>     by exiting a child process when the parent process was in
>     the midst of calling futimens to update a file's timestamps).
>
>     In addition, since the signal may remain pending when we enter the
>     sending loop, we may end up not sending the whole packet before
>     TCP buffers become full. In this case the code returns -EINTR
>     but what we need here is to return -ERESTARTSYS instead to
>     allow system calls to be restarted.
>
>     Fixes: b30c74c73c78 ("CIFS: Mask off signals when sending SMB packets=
")
>     Cc: stable@vger.kernel.org # v5.1+
>     Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e9abb41aa89b..95ef26b555b9 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -338,7 +338,7 @@ __smb_send_rqst(struct TCP_Server_Info *server,
> int num_rqst,
>         if (ssocket =3D=3D NULL)
>                 return -EAGAIN;
>
> -       if (signal_pending(current)) {
> +       if (fatal_signal_pending(current)) {
>                 cifs_dbg(FYI, "signal pending before send request\n");
>                 return -ERESTARTSYS;
>         }
> @@ -429,7 +429,7 @@ __smb_send_rqst(struct TCP_Server_Info *server,
> int num_rqst,
>
>         if (signal_pending(current) && (total_len !=3D send_length)) {
>                 cifs_dbg(FYI, "signal is pending after attempt to send\n"=
);
> -               rc =3D -EINTR;
> +               rc =3D -ERESTARTSYS;
>         }
>
>         /* uncork it */
>
> On Fri, Jan 22, 2021 at 3:46 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Sat, Jan 23, 2021 at 5:47 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > Ronnie,
> > >
> > > I still think that your patch needs additional fix here:
> > >
> > > -----------
> > > /*
> > > * If signal is pending but we have already sent the whole packet to
> > > * the server we need to return success status to allow a correspondin=
g
> > > * mid entry to be kept in the pending requests queue thus allowing
> > > * to handle responses from the server by the client.
> > > *
> > > * If only part of the packet has been sent there is no need to hide
> > > * interrupt because the session will be reconnected anyway, so there
> > > * won't be any response from the server to handle.
> > > */
> > >
> > > if (signal_pending(current) && (total_len !=3D send_length)) {
> > > cifs_dbg(FYI, "signal is pending after attempt to send\n");
> > > rc =3D -EINTR;
> > >         ^^^
> > >         This should be changed to -ERESTARTSYS to allow kernel to
> > > restart a syscall.
> > >
> > > }
> > > -----------
> > >
> > > Since the signal may remain pending when we enter the sending loop, w=
e
> > > may end up not sending the whole packet before TCP buffers become
> > > full. In this case according to the condition above the code returns
> > > -EINTR but what we need here is to return -ERESTARTSYS instead to
> > > allow system calls to be restarted.
> > >
> > > Thoughts?
> >
> > Yes, that is probably a good idea to change too.
> > Steve, can you add this change to my patch?
> >
> >
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D1=87=D1=82, 21 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 14:41, ronni=
e sahlberg <ronniesahlberg@gmail.com>:
> > > >
> > > >
> > > >
> > > > On Thu, Jan 21, 2021 at 10:19 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > > >>
> > > >> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
> > > >>
> > > >> > Pavel Shilovsky <piastryyy@gmail.com> writes:
> > > >> >
> > > >> >> =D0=B2=D1=82, 19 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 22:38,=
 Steve French <smfrench@gmail.com>:
> > > >> >>>
> > > >> >>> The patch won't merge (also has some text corruptions in it). =
 This
> > > >> >>> line of code is different due to commit 6988a619f5b79
> > > >> >>>
> > > >> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
> > > >> >>>  cifs_dbg(FYI, "signal pending before send request\n");
> > > >> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
> > > >> >>>  return -ERESTARTSYS;
> > > >> >>>
> > > >> >>>         if (signal_pending(current)) {
> > > >> >>>                 cifs_dbg(FYI, "signal pending before send requ=
est\n");
> > > >> >>>                 return -ERESTARTSYS;
> > > >> >>>         }
> > > >> >>>
> > > >> >>> See:
> > > >> >>>
> > > >> >>> Author: Paulo Alcantara <pc@cjr.nz>
> > > >> >>> Date:   Sat Nov 28 15:57:06 2020 -0300
> > > >> >>>
> > > >> >>>     cifs: allow syscalls to be restarted in __smb_send_rqst()
> > > >> >>>
> > > >> >>>     A customer has reported that several files in their multi-=
threaded app
> > > >> >>>     were left with size of 0 because most of the read(2) calls=
 returned
> > > >> >>>     -EINTR and they assumed no bytes were read.  Obviously, th=
ey could
> > > >> >>>     have fixed it by simply retrying on -EINTR.
> > > >> >>>
> > > >> >>>     We noticed that most of the -EINTR on read(2) were due to =
real-time
> > > >> >>>     signals sent by glibc to process wide credential changes (=
SIGRT_1),
> > > >> >>>     and its signal handler had been established with SA_RESTAR=
T, in which
> > > >> >>>     case those calls could have been automatically restarted b=
y the
> > > >> >>>     kernel.
> > > >> >>>
> > > >> >>>     Let the kernel decide to whether or not restart the syscal=
ls when
> > > >> >>>     there is a signal pending in __smb_send_rqst() by returnin=
g
> > > >> >>>     -ERESTARTSYS.  If it can't, it will return -EINTR anyway.
> > > >> >>>
> > > >> >>>     Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > > >> >>>     CC: Stable <stable@vger.kernel.org>
> > > >> >>>     Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > >> >>>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > >> >>>
> > > >> >>> On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@red=
hat.com> wrote:
> > > >> >>> >
> > > >> >>> > RHBZ 1848178
> > > >> >>> >
> > > >> >>> > There is no need to fail this function if non-fatal signals =
are
> > > >> >>> > pending when we enter it.
> > > >> >>> >
> > > >> >>> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > >> >>> > ---
> > > >> >>> >  fs/cifs/transport.c | 2 +-
> > > >> >>> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >> >>> >
> > > >> >>> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > >> >>> > index c42bda5a5008..98752f7d2cd2 100644
> > > >> >>> > --- a/fs/cifs/transport.c
> > > >> >>> > +++ b/fs/cifs/transport.c
> > > >> >>> > @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *=
server, int num_rqst,
> > > >> >>> >         if (ssocket =3D=3D NULL)
> > > >> >>> >                 return -EAGAIN;
> > > >> >>> >
> > > >> >>> > -       if (signal_pending(current)) {
> > > >> >>> > +       if (fatal_signal_pending(current)) {
> > > >> >>> >                 cifs_dbg(FYI, "signal is pending before send=
ing any data\n");
> > > >> >>> >                 return -EINTR;
> > > >> >>> >         }
> > > >> >
> > > >> > I've looked up the difference
> > > >> >
> > > >> > static inline int __fatal_signal_pending(struct task_struct *p)
> > > >> > {
> > > >> >       return unlikely(sigismember(&p->pending.signal, SIGKILL));
> > > >> > }
> > > >> >
> > > >> >
> > > >> >> I have been thinking around the same lines. The original intent=
 of
> > > >> >> failing the function here was to avoid interrupting packet send=
 in the
> > > >> >> middle of the packet and not breaking an SMB connection.
> > > >> >> That's also why signals are blocked around smb_send_kvec() call=
s. I
> > > >> >> guess most of the time a socket buffer is not full, so, those
> > > >> >> functions immediately return success without waiting internally=
 and
> > > >> >> checking for pending signals. With this change the code may bre=
ak SMB
> > > >> >
> > > >> > Ah, interesting.
> > > >> >
> > > >> > I looked up the difference between fatal/non-fatal and it seems
> > > >> > fatal_signal_pending() really only checks for SIGKILL, but I wou=
ld
> > > >> > expect ^C (SIGINT) to return quickly as well.
> > > >> >
> > > >> > I thought the point of checking for pending signal early was to =
return
> > > >> > quickly to userspace and not be stuck in some unkillable state.
> > > >> >
> > > >> > After reading your explanation, you're saying the kernel funcs t=
o send
> > > >> > on socket will check for any signal and err early in any case.
> > > >> >
> > > >> > some_syscall() {
> > > >> >
> > > >> >     if (pending_fatal_signal)  <=3D=3D=3D=3D=3D if we ignore non=
-fatal here
> > > >> >         fail_early();
> > > >> >
> > > >> >     block_signals();
> > > >> >     r =3D kernel_socket_send {
> > > >> >         if (pending_signal) <=3D=3D=3D=3D they will be caught he=
re
> > > >> >             return error;
> > > >> >
> > > >> >         ...
> > > >> >     }
> > > >> >     unblock_signals();
> > > >> >     if (r)
> > > >> >         fail();
> > > >> >     ...
> > > >> > }
> > > >> >
> > > >> > So this patch will (potentially) trigger more reconnect (because=
 we
> > > >> > actually send the packet as a vector in a loop) but I'm not sure=
 I
> > > >> > understand why it returns less errors to userspace?
> > > >> >
> > > >> > Also, shouldn't we move the pending_fatal_signal check *inside* =
the blocked
> > > >> > signal section?
> > > >> >
> > > >> > In any case I think we should try to test some of those changes =
given
> > > >> > how we have 3,4 patches trying to tweak it on top of each other.
> > > >>
> > > >> I think it would make sense to have something like
> > > >>
> > > >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > >> index e9abb41aa89b..f7292c14863e 100644
> > > >> --- a/fs/cifs/transport.c
> > > >> +++ b/fs/cifs/transport.c
> > > >> @@ -340,7 +340,7 @@ __smb_send_rqst(struct TCP_Server_Info *server=
, int num_rqst,
> > > >>
> > > >>         if (signal_pending(current)) {
> > > >>                 cifs_dbg(FYI, "signal pending before send request\=
n");
> > > >> -               return -ERESTARTSYS;
> > > >> +               return __fatal_signal_pending(current) ? -EINTR : =
-ERESTARTSYS;
> > > >>         }
> > > >>
> > > >
> > > > That is not sufficient because there are syscalls that are never su=
pposed to fail with -EINTR or -ERESTARTSYS
> > > > and thus will not be restarted by either the kernel or libc.
> > > >
> > > > For example utimensat(). The change to only fail here with -E* for =
a fatal signal (when the process will be killed anyway)
> > > > is to address an issue when IF there are signals pending, any signa=
l, during the utimensat() system call then
> > > > this will lead to us returning -EINTR back to the application. Whic=
h can break some applications such as 'tar'.
> > > >
> > > >
> > > > ronnie s
> > > >
> > > >
> > > >>
> > > >>         /* cork the socket */
> > > >>
> > > >> so that we allow signal handlers to be executed before restarting
> > > >> syscalls when receiving non-fatal signals, otherwise -EINTR.
>
>
>
> --
> Thanks,
>
> Steve



--=20
-Shyam
