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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955C9C433DB
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Jan 2021 07:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D1D239D4
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Jan 2021 07:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbhAWHdv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Jan 2021 02:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhAWHdu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Jan 2021 02:33:50 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ECFC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jan 2021 23:33:09 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id v24so10763381lfr.7
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jan 2021 23:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HR5tozveHA6HuqYySlN/YFLtLOoVBdV3gIjMOA4OTQw=;
        b=aj2jgE/VROUmZno0a2e29MLgDtnEI+q+9FsKpIWZ8oOXQIYSTDuvoOv9gVWBYevAuT
         jFXF6nlNvnPGWNqqPT+xMCi4EzbJZM7t5SRTKE536ecSVcSr+hpl2KPWzB//kGxL+rcP
         u8dp7MX6EEipH9YnknZqNezg+xcH1oUXyshs73vrfwoPsxnSohk4C1aQpvkdJSLrYizS
         c6Y5fBbybkE3HoRyuIy0inJnQmT6ws3X2lC6A95KAedN26YSxbk86edvI9VkrLKGyDys
         1EDAI97OX4A7dPXpF2b/Mkuch6c4IgykHb+fZKD/2KxM8oE4Gab9Uz4zFJfAp5uQ2EK1
         xTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HR5tozveHA6HuqYySlN/YFLtLOoVBdV3gIjMOA4OTQw=;
        b=DNhDs5nEEEAzMvGW6fzkJiRHoR8aDlm9NUo1bY1GBlcJa1Z29tG7aa5r3AWpN+Lxz3
         lB88h+keGunZt+9agMcQJk8N/pw1+MYRfORdyvF5wbu7HssM2bTef+0TDvDoaBj53MAS
         IOzTRvtpKCWUCct+xDx4p6Ei+vsELphSQ3/CXyc6MEuHN6LzZlH6FcGIJVrfrPXiQ+vg
         MSFYQ4JCYyPI+PkZHEP3GE1jd0RZAnWwMU+ZuBhwxWuh9Zj0C/9GQGRpsXHs/jSd+Z47
         y/k0HJ/puf/7l2N9hJZigHzC4hgQjBs6Lg1kJB12UfZ3zN4CNX2jvea6MUxExJeoYvVC
         nuyw==
X-Gm-Message-State: AOAM533S+s47hY7/lGoX+JpFqZ5w84Hv/CgIod7AYu8ae0tXr7YMNwt4
        VrNCOXQ53nJx+5Z50mccl4B4L5915y3nC9ayZ6A=
X-Google-Smtp-Source: ABdhPJwa4dpyHc3PpKLLjE5ZzyL67I2IzI5NYuEbIx3++ebc4wDjEKMnG/9ZmELjsdF+gYuuM44a/huw8W6WKfhGjwY=
X-Received: by 2002:a19:645d:: with SMTP id b29mr329820lfj.184.1611387187320;
 Fri, 22 Jan 2021 23:33:07 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
 <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com> <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com>
In-Reply-To: <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 23 Jan 2021 01:32:56 -0600
Message-ID: <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e58a0c05b98c504b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e58a0c05b98c504b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Patch updated with Pavel's suggestion, and added a commit description
from various comments in this email thread (see attached).

    cifs: do not fail __smb_send_rqst if non-fatal signals are pending

    RHBZ 1848178

    The original intent of returning an error in this function
    in the patch:
      "CIFS: Mask off signals when sending SMB packets"
    was to avoid interrupting packet send in the middle of
    sending the data (and thus breaking an SMB connection),
    but we also don't want to fail the request for non-fatal
    signals even before we have had a chance to try to
    send it (the reported problem could be reproduced e.g.
    by exiting a child process when the parent process was in
    the midst of calling futimens to update a file's timestamps).

    In addition, since the signal may remain pending when we enter the
    sending loop, we may end up not sending the whole packet before
    TCP buffers become full. In this case the code returns -EINTR
    but what we need here is to return -ERESTARTSYS instead to
    allow system calls to be restarted.

    Fixes: b30c74c73c78 ("CIFS: Mask off signals when sending SMB packets")
    Cc: stable@vger.kernel.org # v5.1+
    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e9abb41aa89b..95ef26b555b9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -338,7 +338,7 @@ __smb_send_rqst(struct TCP_Server_Info *server,
int num_rqst,
        if (ssocket =3D=3D NULL)
                return -EAGAIN;

-       if (signal_pending(current)) {
+       if (fatal_signal_pending(current)) {
                cifs_dbg(FYI, "signal pending before send request\n");
                return -ERESTARTSYS;
        }
@@ -429,7 +429,7 @@ __smb_send_rqst(struct TCP_Server_Info *server,
int num_rqst,

        if (signal_pending(current) && (total_len !=3D send_length)) {
                cifs_dbg(FYI, "signal is pending after attempt to send\n");
-               rc =3D -EINTR;
+               rc =3D -ERESTARTSYS;
        }

        /* uncork it */

On Fri, Jan 22, 2021 at 3:46 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Sat, Jan 23, 2021 at 5:47 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Ronnie,
> >
> > I still think that your patch needs additional fix here:
> >
> > -----------
> > /*
> > * If signal is pending but we have already sent the whole packet to
> > * the server we need to return success status to allow a corresponding
> > * mid entry to be kept in the pending requests queue thus allowing
> > * to handle responses from the server by the client.
> > *
> > * If only part of the packet has been sent there is no need to hide
> > * interrupt because the session will be reconnected anyway, so there
> > * won't be any response from the server to handle.
> > */
> >
> > if (signal_pending(current) && (total_len !=3D send_length)) {
> > cifs_dbg(FYI, "signal is pending after attempt to send\n");
> > rc =3D -EINTR;
> >         ^^^
> >         This should be changed to -ERESTARTSYS to allow kernel to
> > restart a syscall.
> >
> > }
> > -----------
> >
> > Since the signal may remain pending when we enter the sending loop, we
> > may end up not sending the whole packet before TCP buffers become
> > full. In this case according to the condition above the code returns
> > -EINTR but what we need here is to return -ERESTARTSYS instead to
> > allow system calls to be restarted.
> >
> > Thoughts?
>
> Yes, that is probably a good idea to change too.
> Steve, can you add this change to my patch?
>
>
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D1=87=D1=82, 21 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 14:41, ronnie =
sahlberg <ronniesahlberg@gmail.com>:
> > >
> > >
> > >
> > > On Thu, Jan 21, 2021 at 10:19 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > >>
> > >> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
> > >>
> > >> > Pavel Shilovsky <piastryyy@gmail.com> writes:
> > >> >
> > >> >> =D0=B2=D1=82, 19 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 22:38, S=
teve French <smfrench@gmail.com>:
> > >> >>>
> > >> >>> The patch won't merge (also has some text corruptions in it).  T=
his
> > >> >>> line of code is different due to commit 6988a619f5b79
> > >> >>>
> > >> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
> > >> >>>  cifs_dbg(FYI, "signal pending before send request\n");
> > >> >>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
> > >> >>>  return -ERESTARTSYS;
> > >> >>>
> > >> >>>         if (signal_pending(current)) {
> > >> >>>                 cifs_dbg(FYI, "signal pending before send reques=
t\n");
> > >> >>>                 return -ERESTARTSYS;
> > >> >>>         }
> > >> >>>
> > >> >>> See:
> > >> >>>
> > >> >>> Author: Paulo Alcantara <pc@cjr.nz>
> > >> >>> Date:   Sat Nov 28 15:57:06 2020 -0300
> > >> >>>
> > >> >>>     cifs: allow syscalls to be restarted in __smb_send_rqst()
> > >> >>>
> > >> >>>     A customer has reported that several files in their multi-th=
readed app
> > >> >>>     were left with size of 0 because most of the read(2) calls r=
eturned
> > >> >>>     -EINTR and they assumed no bytes were read.  Obviously, they=
 could
> > >> >>>     have fixed it by simply retrying on -EINTR.
> > >> >>>
> > >> >>>     We noticed that most of the -EINTR on read(2) were due to re=
al-time
> > >> >>>     signals sent by glibc to process wide credential changes (SI=
GRT_1),
> > >> >>>     and its signal handler had been established with SA_RESTART,=
 in which
> > >> >>>     case those calls could have been automatically restarted by =
the
> > >> >>>     kernel.
> > >> >>>
> > >> >>>     Let the kernel decide to whether or not restart the syscalls=
 when
> > >> >>>     there is a signal pending in __smb_send_rqst() by returning
> > >> >>>     -ERESTARTSYS.  If it can't, it will return -EINTR anyway.
> > >> >>>
> > >> >>>     Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > >> >>>     CC: Stable <stable@vger.kernel.org>
> > >> >>>     Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > >> >>>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > >> >>>
> > >> >>> On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@redha=
t.com> wrote:
> > >> >>> >
> > >> >>> > RHBZ 1848178
> > >> >>> >
> > >> >>> > There is no need to fail this function if non-fatal signals ar=
e
> > >> >>> > pending when we enter it.
> > >> >>> >
> > >> >>> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > >> >>> > ---
> > >> >>> >  fs/cifs/transport.c | 2 +-
> > >> >>> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >> >>> >
> > >> >>> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > >> >>> > index c42bda5a5008..98752f7d2cd2 100644
> > >> >>> > --- a/fs/cifs/transport.c
> > >> >>> > +++ b/fs/cifs/transport.c
> > >> >>> > @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *se=
rver, int num_rqst,
> > >> >>> >         if (ssocket =3D=3D NULL)
> > >> >>> >                 return -EAGAIN;
> > >> >>> >
> > >> >>> > -       if (signal_pending(current)) {
> > >> >>> > +       if (fatal_signal_pending(current)) {
> > >> >>> >                 cifs_dbg(FYI, "signal is pending before sendin=
g any data\n");
> > >> >>> >                 return -EINTR;
> > >> >>> >         }
> > >> >
> > >> > I've looked up the difference
> > >> >
> > >> > static inline int __fatal_signal_pending(struct task_struct *p)
> > >> > {
> > >> >       return unlikely(sigismember(&p->pending.signal, SIGKILL));
> > >> > }
> > >> >
> > >> >
> > >> >> I have been thinking around the same lines. The original intent o=
f
> > >> >> failing the function here was to avoid interrupting packet send i=
n the
> > >> >> middle of the packet and not breaking an SMB connection.
> > >> >> That's also why signals are blocked around smb_send_kvec() calls.=
 I
> > >> >> guess most of the time a socket buffer is not full, so, those
> > >> >> functions immediately return success without waiting internally a=
nd
> > >> >> checking for pending signals. With this change the code may break=
 SMB
> > >> >
> > >> > Ah, interesting.
> > >> >
> > >> > I looked up the difference between fatal/non-fatal and it seems
> > >> > fatal_signal_pending() really only checks for SIGKILL, but I would
> > >> > expect ^C (SIGINT) to return quickly as well.
> > >> >
> > >> > I thought the point of checking for pending signal early was to re=
turn
> > >> > quickly to userspace and not be stuck in some unkillable state.
> > >> >
> > >> > After reading your explanation, you're saying the kernel funcs to =
send
> > >> > on socket will check for any signal and err early in any case.
> > >> >
> > >> > some_syscall() {
> > >> >
> > >> >     if (pending_fatal_signal)  <=3D=3D=3D=3D=3D if we ignore non-f=
atal here
> > >> >         fail_early();
> > >> >
> > >> >     block_signals();
> > >> >     r =3D kernel_socket_send {
> > >> >         if (pending_signal) <=3D=3D=3D=3D they will be caught here
> > >> >             return error;
> > >> >
> > >> >         ...
> > >> >     }
> > >> >     unblock_signals();
> > >> >     if (r)
> > >> >         fail();
> > >> >     ...
> > >> > }
> > >> >
> > >> > So this patch will (potentially) trigger more reconnect (because w=
e
> > >> > actually send the packet as a vector in a loop) but I'm not sure I
> > >> > understand why it returns less errors to userspace?
> > >> >
> > >> > Also, shouldn't we move the pending_fatal_signal check *inside* th=
e blocked
> > >> > signal section?
> > >> >
> > >> > In any case I think we should try to test some of those changes gi=
ven
> > >> > how we have 3,4 patches trying to tweak it on top of each other.
> > >>
> > >> I think it would make sense to have something like
> > >>
> > >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > >> index e9abb41aa89b..f7292c14863e 100644
> > >> --- a/fs/cifs/transport.c
> > >> +++ b/fs/cifs/transport.c
> > >> @@ -340,7 +340,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, =
int num_rqst,
> > >>
> > >>         if (signal_pending(current)) {
> > >>                 cifs_dbg(FYI, "signal pending before send request\n"=
);
> > >> -               return -ERESTARTSYS;
> > >> +               return __fatal_signal_pending(current) ? -EINTR : -E=
RESTARTSYS;
> > >>         }
> > >>
> > >
> > > That is not sufficient because there are syscalls that are never supp=
osed to fail with -EINTR or -ERESTARTSYS
> > > and thus will not be restarted by either the kernel or libc.
> > >
> > > For example utimensat(). The change to only fail here with -E* for a =
fatal signal (when the process will be killed anyway)
> > > is to address an issue when IF there are signals pending, any signal,=
 during the utimensat() system call then
> > > this will lead to us returning -EINTR back to the application. Which =
can break some applications such as 'tar'.
> > >
> > >
> > > ronnie s
> > >
> > >
> > >>
> > >>         /* cork the socket */
> > >>
> > >> so that we allow signal handlers to be executed before restarting
> > >> syscalls when receiving non-fatal signals, otherwise -EINTR.



--=20
Thanks,

Steve

--000000000000e58a0c05b98c504b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-do-not-fail-__smb_send_rqst-if-non-fatal-signal.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-do-not-fail-__smb_send_rqst-if-non-fatal-signal.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kk9e8qaq0>
X-Attachment-Id: f_kk9e8qaq0

RnJvbSAyMTRhNWVhMDgxZTc3MzQ2ZTQ5NjNkZDZkMjBjNTUzOWZmOGI2YWU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFRodSwgMjEgSmFuIDIwMjEgMDg6MjI6NDggKzEwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBkbyBub3QgZmFpbCBfX3NtYl9zZW5kX3Jxc3QgaWYgbm9uLWZhdGFsIHNpZ25hbHMgYXJl
CiBwZW5kaW5nCgpSSEJaIDE4NDgxNzgKClRoZSBvcmlnaW5hbCBpbnRlbnQgb2YgcmV0dXJuaW5n
IGFuIGVycm9yIGluIHRoaXMgZnVuY3Rpb24KaW4gdGhlIHBhdGNoOgogICJDSUZTOiBNYXNrIG9m
ZiBzaWduYWxzIHdoZW4gc2VuZGluZyBTTUIgcGFja2V0cyIKd2FzIHRvIGF2b2lkIGludGVycnVw
dGluZyBwYWNrZXQgc2VuZCBpbiB0aGUgbWlkZGxlIG9mCnNlbmRpbmcgdGhlIGRhdGEgKGFuZCB0
aHVzIGJyZWFraW5nIGFuIFNNQiBjb25uZWN0aW9uKSwKYnV0IHdlIGFsc28gZG9uJ3Qgd2FudCB0
byBmYWlsIHRoZSByZXF1ZXN0IGZvciBub24tZmF0YWwKc2lnbmFscyBldmVuIGJlZm9yZSB3ZSBo
YXZlIGhhZCBhIGNoYW5jZSB0byB0cnkgdG8Kc2VuZCBpdCAodGhlIHJlcG9ydGVkIHByb2JsZW0g
Y291bGQgYmUgcmVwcm9kdWNlZCBlLmcuCmJ5IGV4aXRpbmcgYSBjaGlsZCBwcm9jZXNzIHdoZW4g
dGhlIHBhcmVudCBwcm9jZXNzIHdhcyBpbgp0aGUgbWlkc3Qgb2YgY2FsbGluZyBmdXRpbWVucyB0
byB1cGRhdGUgYSBmaWxlJ3MgdGltZXN0YW1wcykuCgpJbiBhZGRpdGlvbiwgc2luY2UgdGhlIHNp
Z25hbCBtYXkgcmVtYWluIHBlbmRpbmcgd2hlbiB3ZSBlbnRlciB0aGUKc2VuZGluZyBsb29wLCB3
ZSBtYXkgZW5kIHVwIG5vdCBzZW5kaW5nIHRoZSB3aG9sZSBwYWNrZXQgYmVmb3JlClRDUCBidWZm
ZXJzIGJlY29tZSBmdWxsLiBJbiB0aGlzIGNhc2UgdGhlIGNvZGUgcmV0dXJucyAtRUlOVFIKYnV0
IHdoYXQgd2UgbmVlZCBoZXJlIGlzIHRvIHJldHVybiAtRVJFU1RBUlRTWVMgaW5zdGVhZCB0bwph
bGxvdyBzeXN0ZW0gY2FsbHMgdG8gYmUgcmVzdGFydGVkLgoKRml4ZXM6IGIzMGM3NGM3M2M3OCAo
IkNJRlM6IE1hc2sgb2ZmIHNpZ25hbHMgd2hlbiBzZW5kaW5nIFNNQiBwYWNrZXRzIikKQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2NS4xKwpTaWduZWQtb2ZmLWJ5OiBSb25uaWUgU2FobGJl
cmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBz
aGlsb3ZAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5j
aEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvdHJhbnNwb3J0LmMgfCA0ICsrLS0KIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy90cmFuc3BvcnQuYyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKaW5kZXggZTlhYmI0MWFh
ODliLi45NWVmMjZiNTU1YjkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhbnNwb3J0LmMKKysrIGIv
ZnMvY2lmcy90cmFuc3BvcnQuYwpAQCAtMzM4LDcgKzMzOCw3IEBAIF9fc21iX3NlbmRfcnFzdChz
dHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIGludCBudW1fcnFzdCwKIAlpZiAoc3NvY2tl
dCA9PSBOVUxMKQogCQlyZXR1cm4gLUVBR0FJTjsKIAotCWlmIChzaWduYWxfcGVuZGluZyhjdXJy
ZW50KSkgeworCWlmIChmYXRhbF9zaWduYWxfcGVuZGluZyhjdXJyZW50KSkgewogCQljaWZzX2Ri
ZyhGWUksICJzaWduYWwgcGVuZGluZyBiZWZvcmUgc2VuZCByZXF1ZXN0XG4iKTsKIAkJcmV0dXJu
IC1FUkVTVEFSVFNZUzsKIAl9CkBAIC00MjksNyArNDI5LDcgQEAgX19zbWJfc2VuZF9ycXN0KHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgaW50IG51bV9ycXN0LAogCiAJaWYgKHNpZ25h
bF9wZW5kaW5nKGN1cnJlbnQpICYmICh0b3RhbF9sZW4gIT0gc2VuZF9sZW5ndGgpKSB7CiAJCWNp
ZnNfZGJnKEZZSSwgInNpZ25hbCBpcyBwZW5kaW5nIGFmdGVyIGF0dGVtcHQgdG8gc2VuZFxuIik7
Ci0JCXJjID0gLUVJTlRSOworCQlyYyA9IC1FUkVTVEFSVFNZUzsKIAl9CiAKIAkvKiB1bmNvcmsg
aXQgKi8KLS0gCjIuMjcuMAoK
--000000000000e58a0c05b98c504b--
