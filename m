Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11EAC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 12:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69BBF206ED
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 12:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbhAUMSE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jan 2021 07:18:04 -0500
Received: from mx.cjr.nz ([51.158.111.142]:63584 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728429AbhAUMRk (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 21 Jan 2021 07:17:40 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 16D8E7FD23;
        Thu, 21 Jan 2021 12:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1611231412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/a77pFsd8zEqKoP+D62M03PRM70OM6Ff8xg3LmEjvM=;
        b=0GWfVNvwjlpqXxGVZcYJRDRD8LvhwMt+oTaR6NrXRR5IJgm+jp/O6rw1l6+4EKpOzo+W4o
        0CYvGbj2bcy02eJkeMTfi0H/NFM0eBLNf27y4CxGDC2eIAxuQKk4EXFAqJ2FNKjToRieIs
        AJCRVHYBzxI/8idOID7IPbJRlLjADJsxTO1AveOyj9HXg+sMOvs5ndgjU9IrwSLZqjGatC
        A+TSJ/+dzP8oLdCj7QaAuv4oNJHEriSgCZTWqO5X7Gs0+/VNlRgWyi8+zw2UMP7LIS3aUx
        wC9XREA3UCEMKajEsVDWjZqRSdAtNdzp19m0yoEPe+x2RFuK6KVYp6dp5pFgiQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
In-Reply-To: <87y2gmk3ap.fsf@suse.com>
References: <20210120043209.27786-1-lsahlber@redhat.com>
 <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com>
Date:   Thu, 21 Jan 2021 09:16:46 -0300
Message-ID: <877do6zdqp.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:

> Pavel Shilovsky <piastryyy@gmail.com> writes:
>
>> =D0=B2=D1=82, 19 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 22:38, Steve Fr=
ench <smfrench@gmail.com>:
>>>
>>> The patch won't merge (also has some text corruptions in it).  This
>>> line of code is different due to commit 6988a619f5b79
>>>
>>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
>>>  cifs_dbg(FYI, "signal pending before send request\n");
>>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
>>>  return -ERESTARTSYS;
>>>
>>>         if (signal_pending(current)) {
>>>                 cifs_dbg(FYI, "signal pending before send request\n");
>>>                 return -ERESTARTSYS;
>>>         }
>>>
>>> See:
>>>
>>> Author: Paulo Alcantara <pc@cjr.nz>
>>> Date:   Sat Nov 28 15:57:06 2020 -0300
>>>
>>>     cifs: allow syscalls to be restarted in __smb_send_rqst()
>>>
>>>     A customer has reported that several files in their multi-threaded =
app
>>>     were left with size of 0 because most of the read(2) calls returned
>>>     -EINTR and they assumed no bytes were read.  Obviously, they could
>>>     have fixed it by simply retrying on -EINTR.
>>>
>>>     We noticed that most of the -EINTR on read(2) were due to real-time
>>>     signals sent by glibc to process wide credential changes (SIGRT_1),
>>>     and its signal handler had been established with SA_RESTART, in whi=
ch
>>>     case those calls could have been automatically restarted by the
>>>     kernel.
>>>
>>>     Let the kernel decide to whether or not restart the syscalls when
>>>     there is a signal pending in __smb_send_rqst() by returning
>>>     -ERESTARTSYS.  If it can't, it will return -EINTR anyway.
>>>
>>>     Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>>>     CC: Stable <stable@vger.kernel.org>
>>>     Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>>>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>>>
>>> On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@redhat.com> =
wrote:
>>> >
>>> > RHBZ 1848178
>>> >
>>> > There is no need to fail this function if non-fatal signals are
>>> > pending when we enter it.
>>> >
>>> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>>> > ---
>>> >  fs/cifs/transport.c | 2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>>> > index c42bda5a5008..98752f7d2cd2 100644
>>> > --- a/fs/cifs/transport.c
>>> > +++ b/fs/cifs/transport.c
>>> > @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, i=
nt num_rqst,
>>> >         if (ssocket =3D=3D NULL)
>>> >                 return -EAGAIN;
>>> >
>>> > -       if (signal_pending(current)) {
>>> > +       if (fatal_signal_pending(current)) {
>>> >                 cifs_dbg(FYI, "signal is pending before sending any d=
ata\n");
>>> >                 return -EINTR;
>>> >         }
>
> I've looked up the difference
>
> static inline int __fatal_signal_pending(struct task_struct *p)
> {
> 	return unlikely(sigismember(&p->pending.signal, SIGKILL));
> }
>
>
>> I have been thinking around the same lines. The original intent of
>> failing the function here was to avoid interrupting packet send in the
>> middle of the packet and not breaking an SMB connection.
>> That's also why signals are blocked around smb_send_kvec() calls. I
>> guess most of the time a socket buffer is not full, so, those
>> functions immediately return success without waiting internally and
>> checking for pending signals. With this change the code may break SMB
>
> Ah, interesting.
>
> I looked up the difference between fatal/non-fatal and it seems
> fatal_signal_pending() really only checks for SIGKILL, but I would
> expect ^C (SIGINT) to return quickly as well.
>
> I thought the point of checking for pending signal early was to return
> quickly to userspace and not be stuck in some unkillable state.
>
> After reading your explanation, you're saying the kernel funcs to send
> on socket will check for any signal and err early in any case.
>
> some_syscall() {
>
>     if (pending_fatal_signal)  <=3D=3D=3D=3D=3D if we ignore non-fatal he=
re
>         fail_early();
>
>     block_signals();
>     r =3D kernel_socket_send {
>         if (pending_signal) <=3D=3D=3D=3D they will be caught here
>             return error;
>
>         ...
>     }
>     unblock_signals();
>     if (r)
>         fail();
>     ...
> }
>
> So this patch will (potentially) trigger more reconnect (because we
> actually send the packet as a vector in a loop) but I'm not sure I
> understand why it returns less errors to userspace?
>
> Also, shouldn't we move the pending_fatal_signal check *inside* the block=
ed
> signal section?
>
> In any case I think we should try to test some of those changes given
> how we have 3,4 patches trying to tweak it on top of each other.

I think it would make sense to have something like

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e9abb41aa89b..f7292c14863e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -340,7 +340,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num=
_rqst,
=20
 	if (signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
-		return -ERESTARTSYS;
+		return __fatal_signal_pending(current) ? -EINTR : -ERESTARTSYS;
 	}
=20
 	/* cork the socket */

so that we allow signal handlers to be executed before restarting
syscalls when receiving non-fatal signals, otherwise -EINTR.
