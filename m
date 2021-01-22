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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AD7C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jan 2021 22:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19B4423AA1
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jan 2021 22:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbhAVWij (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jan 2021 17:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbhAVTsY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jan 2021 14:48:24 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043A5C06174A
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jan 2021 11:47:42 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g12so9334008ejf.8
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jan 2021 11:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ILyaNiajAiHUuagALTIkzHHzPrCka9r0zrSMwIdlC94=;
        b=TT4AjywqSqejSxEmvzj/H7IH5z/BfyEdPxrly/aRuhOsz0UtPLbP7d6xHOLVkTwaFv
         xTT3Hr5hhgxZsksjEe94VHcWK+i2kJAmJ9UEa/O4AV9hJO9AOYKmhfAP0yVyXX+zHqEb
         ++5u4T0Mw1Olvpu+hH933U3nNcPnpRg7fZKj//FxgF35ICMBmVbeygzqs9HNlTj6/hqf
         SRVFSMN3jmWIAQ4KZ/tinXcNY0fMG/wuYto/3cp/kmGT8a4BafXlBJ+QsljK1o9uase+
         E1WpbBAinYFkVbzDHMqI/UDSD5z1tQs+ZsmS2BWh5D3mfXurSKG+s0GYYB2au+bXNCuF
         wA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ILyaNiajAiHUuagALTIkzHHzPrCka9r0zrSMwIdlC94=;
        b=K1vI58bndo2yl2M2fqXHUKZzYQ/AAcxVaGWg+5emhejQTTLvswYVZulFgWhn/qRrLX
         im/Pke16R4xME2XNW1AOZW1WW5d3jAuMUZfdzLRlgNZ7NNXGux/08FyjsnWOVotSbJ1D
         7HouHFrMqEgmhGua54ww/d2ECyibQWCFzbapcPuwkWtHYHwGq65kwG0LpWA+5hYwq2bG
         BLoaW7+IbiOraxQza19XOQMeGneQOQEwQG4vjUgECTqkxyV9wvZr0tnqd1SMdOSo8N1s
         7Qh15nvbtIoT4oKhRuwCnHUB9+hxEYAjikg4woTnYugGvqKDff6HJDBsFZ7VLb8593px
         VdEg==
X-Gm-Message-State: AOAM532j7f+M+0gZ4qE9w5nBCfUjQCam4WKbBATQd7Pg4kwiZmyutC/0
        Grx4UForbIJwPZQkYyfyXocFA8rS7mjXS0q3LFpSsrr/eQ==
X-Google-Smtp-Source: ABdhPJyQqykMdWD8YfDAZ4N4cGuFR9FpbupM+VxsSRemG/+UMuNnxc5QW3Ziw60C0YdS8Fd6XPfkMJRZtlGG+SHwJp0=
X-Received: by 2002:a17:906:ce49:: with SMTP id se9mr34442ejb.341.1611344860387;
 Fri, 22 Jan 2021 11:47:40 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
In-Reply-To: <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 22 Jan 2021 11:47:28 -0800
Message-ID: <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie,

I still think that your patch needs additional fix here:

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

Since the signal may remain pending when we enter the sending loop, we
may end up not sending the whole packet before TCP buffers become
full. In this case according to the condition above the code returns
-EINTR but what we need here is to return -ERESTARTSYS instead to
allow system calls to be restarted.

Thoughts?

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 21 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 14:41, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
>
>
> On Thu, Jan 21, 2021 at 10:19 PM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>>
>> > Pavel Shilovsky <piastryyy@gmail.com> writes:
>> >
>> >> =D0=B2=D1=82, 19 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 22:38, Steve=
 French <smfrench@gmail.com>:
>> >>>
>> >>> The patch won't merge (also has some text corruptions in it).  This
>> >>> line of code is different due to commit 6988a619f5b79
>> >>>
>> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
>> >>>  cifs_dbg(FYI, "signal pending before send request\n");
>> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
>> >>>  return -ERESTARTSYS;
>> >>>
>> >>>         if (signal_pending(current)) {
>> >>>                 cifs_dbg(FYI, "signal pending before send request\n"=
);
>> >>>                 return -ERESTARTSYS;
>> >>>         }
>> >>>
>> >>> See:
>> >>>
>> >>> Author: Paulo Alcantara <pc@cjr.nz>
>> >>> Date:   Sat Nov 28 15:57:06 2020 -0300
>> >>>
>> >>>     cifs: allow syscalls to be restarted in __smb_send_rqst()
>> >>>
>> >>>     A customer has reported that several files in their multi-thread=
ed app
>> >>>     were left with size of 0 because most of the read(2) calls retur=
ned
>> >>>     -EINTR and they assumed no bytes were read.  Obviously, they cou=
ld
>> >>>     have fixed it by simply retrying on -EINTR.
>> >>>
>> >>>     We noticed that most of the -EINTR on read(2) were due to real-t=
ime
>> >>>     signals sent by glibc to process wide credential changes (SIGRT_=
1),
>> >>>     and its signal handler had been established with SA_RESTART, in =
which
>> >>>     case those calls could have been automatically restarted by the
>> >>>     kernel.
>> >>>
>> >>>     Let the kernel decide to whether or not restart the syscalls whe=
n
>> >>>     there is a signal pending in __smb_send_rqst() by returning
>> >>>     -ERESTARTSYS.  If it can't, it will return -EINTR anyway.
>> >>>
>> >>>     Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>> >>>     CC: Stable <stable@vger.kernel.org>
>> >>>     Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> >>>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>> >>>
>> >>> On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@redhat.co=
m> wrote:
>> >>> >
>> >>> > RHBZ 1848178
>> >>> >
>> >>> > There is no need to fail this function if non-fatal signals are
>> >>> > pending when we enter it.
>> >>> >
>> >>> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> >>> > ---
>> >>> >  fs/cifs/transport.c | 2 +-
>> >>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>> >
>> >>> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> >>> > index c42bda5a5008..98752f7d2cd2 100644
>> >>> > --- a/fs/cifs/transport.c
>> >>> > +++ b/fs/cifs/transport.c
>> >>> > @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server=
, int num_rqst,
>> >>> >         if (ssocket =3D=3D NULL)
>> >>> >                 return -EAGAIN;
>> >>> >
>> >>> > -       if (signal_pending(current)) {
>> >>> > +       if (fatal_signal_pending(current)) {
>> >>> >                 cifs_dbg(FYI, "signal is pending before sending an=
y data\n");
>> >>> >                 return -EINTR;
>> >>> >         }
>> >
>> > I've looked up the difference
>> >
>> > static inline int __fatal_signal_pending(struct task_struct *p)
>> > {
>> >       return unlikely(sigismember(&p->pending.signal, SIGKILL));
>> > }
>> >
>> >
>> >> I have been thinking around the same lines. The original intent of
>> >> failing the function here was to avoid interrupting packet send in th=
e
>> >> middle of the packet and not breaking an SMB connection.
>> >> That's also why signals are blocked around smb_send_kvec() calls. I
>> >> guess most of the time a socket buffer is not full, so, those
>> >> functions immediately return success without waiting internally and
>> >> checking for pending signals. With this change the code may break SMB
>> >
>> > Ah, interesting.
>> >
>> > I looked up the difference between fatal/non-fatal and it seems
>> > fatal_signal_pending() really only checks for SIGKILL, but I would
>> > expect ^C (SIGINT) to return quickly as well.
>> >
>> > I thought the point of checking for pending signal early was to return
>> > quickly to userspace and not be stuck in some unkillable state.
>> >
>> > After reading your explanation, you're saying the kernel funcs to send
>> > on socket will check for any signal and err early in any case.
>> >
>> > some_syscall() {
>> >
>> >     if (pending_fatal_signal)  <=3D=3D=3D=3D=3D if we ignore non-fatal=
 here
>> >         fail_early();
>> >
>> >     block_signals();
>> >     r =3D kernel_socket_send {
>> >         if (pending_signal) <=3D=3D=3D=3D they will be caught here
>> >             return error;
>> >
>> >         ...
>> >     }
>> >     unblock_signals();
>> >     if (r)
>> >         fail();
>> >     ...
>> > }
>> >
>> > So this patch will (potentially) trigger more reconnect (because we
>> > actually send the packet as a vector in a loop) but I'm not sure I
>> > understand why it returns less errors to userspace?
>> >
>> > Also, shouldn't we move the pending_fatal_signal check *inside* the bl=
ocked
>> > signal section?
>> >
>> > In any case I think we should try to test some of those changes given
>> > how we have 3,4 patches trying to tweak it on top of each other.
>>
>> I think it would make sense to have something like
>>
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index e9abb41aa89b..f7292c14863e 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -340,7 +340,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int =
num_rqst,
>>
>>         if (signal_pending(current)) {
>>                 cifs_dbg(FYI, "signal pending before send request\n");
>> -               return -ERESTARTSYS;
>> +               return __fatal_signal_pending(current) ? -EINTR : -EREST=
ARTSYS;
>>         }
>>
>
> That is not sufficient because there are syscalls that are never supposed=
 to fail with -EINTR or -ERESTARTSYS
> and thus will not be restarted by either the kernel or libc.
>
> For example utimensat(). The change to only fail here with -E* for a fata=
l signal (when the process will be killed anyway)
> is to address an issue when IF there are signals pending, any signal, dur=
ing the utimensat() system call then
> this will lead to us returning -EINTR back to the application. Which can =
break some applications such as 'tar'.
>
>
> ronnie s
>
>
>>
>>         /* cork the socket */
>>
>> so that we allow signal handlers to be executed before restarting
>> syscalls when receiving non-fatal signals, otherwise -EINTR.
