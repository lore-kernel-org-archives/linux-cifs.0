Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2ABC433ED
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 16:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7A760FD9
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 16:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhEAQl0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 May 2021 12:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhEAQlX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 May 2021 12:41:23 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1284EC06174A
        for <linux-cifs@vger.kernel.org>; Sat,  1 May 2021 09:40:32 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id t94so2009907ybi.3
        for <linux-cifs@vger.kernel.org>; Sat, 01 May 2021 09:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uoVLWqfrBFIU352FfRf6qE4csxEKg9qhCNe5+wmVvgk=;
        b=O8mDpA+VEM5A/0SSYlydkFn+lsUp8MHDrji/MCu5Kfx2nINTG+61cowr+3+NA2oBnE
         ZTYdEfgggJdohfapSNsDIb8ktZ1xpykOawGERTFze5Nqy1J9/PDzzr4MWhP0Lz7x9O/D
         lzRgClTda4vRjnI+vaiawanUg06pCXWK7GCTkIMF/DnKdCUkS9wAJJpMLo3hhudbKCqu
         F3WS7ssg/QTTa1bR5OZVqjGyP/jMRlLYoWh72GiMAftgHTVVlAT4YSWQQwIG7FwRQqWo
         xmKZzqbVYwZdS77wnYlAgxaU7uSaDd4uraB/4m8IvAi8pCJc7tep5S72qlnO7hwxUlXB
         YymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uoVLWqfrBFIU352FfRf6qE4csxEKg9qhCNe5+wmVvgk=;
        b=nXOWAKL3Y0R40mArl5t9MuPEKwUlJQvfnjCrFvFywr/XUSh2mR+b7hopg1Z+OHCp5x
         Kv+zh/YyH4eJ+t8ACa74Hipzr7qdzg2AA5D4rOEYjhXLUf6G1C15JujFT5YCQ8Bjp96W
         +sWIjrOjGDsEfowAMPA+aAFtPw8sqRLGV7ffVOmfJ1ghBpwMJaw4GCilsBdebiOBu663
         XyrBy2b7ExffWaywuhZTuMScgD96AzlVfzbGkjdKoS1msgZ0MVm34SxR3s1xgjmpZAfj
         iqlykQA5W6mKQAFVGfCGxPJAerrpSoMyVI2iletS4e6UV6DYHy4F/y2kVAJGa/1DMat3
         Nonw==
X-Gm-Message-State: AOAM5300R8lEwBNZG50TbzjdsU27npRSqTn3jwFXH0qWReJzbFmwHGmX
        Py+ImezP6MxgH4HMlZTtwBu9GMgjIbQIVrSI/V46r9CiEJg=
X-Google-Smtp-Source: ABdhPJy77ZLk9yMmsCqLR6HfpyclmShWaWNCl07Us00YAnQ7yLPyaIwFP+EeKIQw3yoJaOujKK74aHVKD1ppGgHvoL4=
X-Received: by 2002:a25:b84a:: with SMTP id b10mr11892308ybm.327.1619887231145;
 Sat, 01 May 2021 09:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qykPGoWwtfSdXe9BsXp083M9-7zaAXJgkPok0Onp6Zow@mail.gmail.com>
 <87zgxhuxdd.fsf@suse.com> <CANT5p=ojeaoyifJ-6bxc0mGnAnYqgUH5=W8exhjf=8Hjfat5Eg@mail.gmail.com>
 <CANT5p=oeCf3VeyFECPeUrnGwQM71pehj=o0t25z-+hWmpY+bSg@mail.gmail.com> <CAH2r5mtFQpZUtjaqMSu7cvz+ykkNfLmYAJuJfVRHM3x+rg+LLw@mail.gmail.com>
In-Reply-To: <CAH2r5mtFQpZUtjaqMSu7cvz+ykkNfLmYAJuJfVRHM3x+rg+LLw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 1 May 2021 22:10:19 +0530
Message-ID: <CANT5p=rgZUu1SzVK87Ots+hhmyJVgS30fQv2arsDnzXa0ps0=g@mail.gmail.com>
Subject: Re: [PATCH] cifs: detect dead connections only when echoes are enabled.
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000fd3bc905c14762c7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fd3bc905c14762c7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Aurelien,

I did some reading in this code path, and it seems like echo_interval
was changed to 0 for NeedNegotiate cases to handle cases of too much
delay between echoes causing the server to be declared as
unresponsive.
This was back when we used 2*echo_interval as the timeout to declare
the server as unresponsive. Later, Ronnie changed this to
3*echo_interval.
So we should not need to change echo_interval to 0 anymore.

Attached patch has the fix.
Please let me know what you think about this fix.

Regards,
Shyam

On Fri, Apr 30, 2021 at 12:23 AM Steve French <smfrench@gmail.com> wrote:
>
> FYI kicked off buildbot with your patch (and Rohiths)
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/=
builds/41
>
> On Thu, Apr 29, 2021 at 10:48 AM Shyam Prasad N <nspmangalore@gmail.com> =
wrote:
> >
> > Attaching updated patch with can_echo() instead of referencing echoes d=
irectly.
> > I'll submit another patch for the other changes.
> >
> > Regards,
> > Shyam
> >
> > On Thu, Apr 29, 2021 at 5:59 PM Shyam Prasad N <nspmangalore@gmail.com>=
 wrote:
> > >
> > > Hi Aur=C3=A9lien,
> > >
> > > Replies below...
> > >
> > > On Thu, Apr 29, 2021 at 5:16 PM Aur=C3=A9lien Aptel <aaptel@suse.com>=
 wrote:
> > > >
> > > >
> > > > Hi Shyam,
> > > >
> > > > Ok so I ended up looking at a lot of code to check this... And I'm =
still
> > > > unsure.
> > > >
> > > > First, it looks like server->echoes is only used for smb2 and there=
 is
> > > > a generic server->ops->can_echo() you can use that just returns
> > > > server->echoes it for smb2.
> > > Agree. I can use can_echo() instead.
> > >
> > > >
> > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > > Hi,
> > > > >
> > > > > Recently, some xfstests and later some manual testing on multi-ch=
annel
> > > > > revealed that we detect unresponsive servers on some of the chann=
els
> > > > > to the same server.
> > > > >
> > > > > The issue is seen when a channel is setup and sits idle without a=
ny
> > > > > traffic. Generally, we enable echoes and oplocks on a channel dur=
ing
> > > > > the first request, based on the number of credits available on th=
e
> > > > > channel. So on idle channels, we trip in our logic to check serve=
r
> > > > > unresponsiveness.
> > > >
> > > > That makes sense but while looking at the code I see we always queu=
e
> > > > echo request in cifs_get_tcp_session(), which is called when adding=
 a
> > > > channel.
> > > >
> > > > cifs_ses_add_channel() {
> > > >         ctx.echo_interval =3D ses->server->echo_interval / HZ;
> > > >
> > > >         chan->server =3D cifs_get_tcp_session(&ctx);
> > > >
> > > >         rc =3D cifs_negotiate_protocol(xid, ses) {
> > > >                 server->tcpStatus =3D CifsGood;
> > > >         }
> > > >
> > > >         rc =3D cifs_setup_session(xid, ses, cifs_sb->local_nls);
> > > > }
> > > >
> > > > cifs_get_tcp_session() {
> > > >
> > > >         INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
> > > >
> > > >         tcp_ses->tcpStatus =3D CifsNeedNegotiate;
> > > >
> > > >         tcp_ses->lstrp =3D jiffies;
> > > >
> > > >         if (ctx->echo_interval >=3D SMB_ECHO_INTERVAL_MIN &&
> > > >                 ctx->echo_interval <=3D SMB_ECHO_INTERVAL_MAX)
> > > >                 tcp_ses->echo_interval =3D ctx->echo_interval * HZ;
> > > >         else
> > > >                 tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DEFAUL=
T * HZ;
> > > >
> > > >         queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->ech=
o_interval);
> > > > }
> > > >
> > > > cifs_echo_request() {
> > > >
> > > >         if (server->tcpStatus =3D=3D CifsNeedNegotiate)
> > > >                 echo_interval =3D 0; <=3D=3D=3D branch taken
> > > >         else
> > > >                 echo_interval =3D server->echo_interval;
> > > >
> > > >         if (server->tcpStatus not in {NeedReconnect, Exiting, New}
> > > >            && server->can_echo()
> > > >            && jiffies > server->lstrp + echo_interval - HZ)
> > > >         {
> > > >                 server->echo();
> > > >         }
> > > >
> > > >         queue_delayed_work(cifsiod_wq, &server->echo, server->echo_=
interval);
> > > >         =3D=3D=3D> echo_interval =3D 0 so calls itself immediatly
> > > > }
> > > >
> > > > SMB2_echo() {
> > > >         if (server->tcpStatus =3D=3D CifsNeedNegotiate) {
> > > >                 /* No need to send echo on newly established connec=
tions */
> > > >                 mod_delayed_work(cifsiod_wq, &server->reconnect, 0)=
;
> > > >                 =3D=3D=3D=3D> calls smb2_reconnect_server() immedia=
tly if NeedNego
> > > >                 return rc;
> > > >         }
> > > >
> > > > }
> > > >
> > > > smb2_reconnect_server() {
> > > >         // channel has no TCONs so it does essentially nothing
> > > > }
> > > >
> > > > server_unresponsive() {
> > > >         if (server->tcpStatus in {Good, NeedNegotiate}
> > > >            && jiffies > server->lstrp + 3 * server->echo_interval)
> > > >         {
> > > >                 cifs_server_dbg(VFS, "has not responded in %lu seco=
nds. Reconnecting...\n",
> > > >                          (3 * server->echo_interval) / HZ);
> > > >                 cifs_reconnect(server);
> > > >                 return true;
> > > >         }
> > > >         return false;
> > > > }
> > > >
> > > > So it looks to me that cifs_get_tcp_session() starts the
> > > > cifs_echo_request() work, which calls itself with no delay in an
> > > > infinite loop doing nothing (that's probably bad...) until session_=
setup
> > > > succeeds, after which the delay between the self-call is set.
> > >
> > > Perhaps we think that 1 sec is too much for us to complete negotiate?
> > > But echo_interval of 0 looks bad.
> > >
> > > Ideally, we should queue echo work only when session setup is complet=
e.
> > > What do you think?
> > >
> > > >
> > > > During session_setup():
> > > >
> > > > * last response time (lstrp) gets updated
> > > >
> > > > * sending/recv requests should interact with the server
> > > >   credits and call change_conf(), which should enable server->echoe=
s
> > > >   =3D=3D> is that part not working?
> > > It's working. But since these channels are idle, change_conf is not
> > > called for these channels.
> > > So echoes=3Dfalse till there's some activity on the channel.
> > >
> > > >
> > > > Once enabled, the echo_request workq will finally send the echo on =
the
> > > > wire, which should -/+ 1 credit and update lstrp.
> > > >
> > > > > Attached a one-line fix for this. Have tested it in my environmen=
t.
> > > > > Another approach to fix this could be to enable echoes during
> > > > > initialization of a server struct. Or soon after the session setu=
p.
> > > > > But I felt that this approach is better. Let me know if you feel
> > > > > otherwise.
> > > >
> > > > I think the idea of your change is ok but there's probably also an =
issue
> > > > in crediting in session_setup()/change_conf() if echoes is not enab=
led
> > > > at this point no?
> > > >
> > > > Cheers,
> > > > --
> > > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCr=
nberg, DE
> > > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG=
 M=C3=BCnchen)
> > > >
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> >
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam

--000000000000fd3bc905c14762c7
Content-Type: application/octet-stream; 
	name="0001-cifs-use-echo_interval-even-when-connection-not-read.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-use-echo_interval-even-when-connection-not-read.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko5z05z10>
X-Attachment-Id: f_ko5z05z10

RnJvbSAzMzRhYjBlZmE5NWYzOTNkZmY5MjZmYTk0NzQ1ZDk1MzcyYzMwYmYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBTYXQsIDEgTWF5IDIwMjEgMTY6MTc6MDcgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiB1c2UgZWNob19pbnRlcnZhbCBldmVuIHdoZW4gY29ubmVjdGlvbiBub3QgcmVhZHkuCgpX
aGVuIHRoZSB0Y3AgY29ubmVjdGlvbiBpcyBub3QgcmVhZHkgdG8gc2VuZCByZXF1ZXN0cywKd2Ug
a2VlcCByZXRyeWluZyBlY2hvIHdpdGggYW4gaW50ZXJ2YWwgb2YgemVyby4KClRoaXMgc2VlbXMg
dW5uZWNlc3NhcnksIGFuZCB0aGlzIGZpeCBjaGFuZ2VzIHRoZSBpbnRlcnZhbApiZXR3ZWVuIGVj
aG9lcyB0byB3aGF0IGlzIHNwZWNpZmllZCBhcyBlY2hvX2ludGVydmFsLgoKU2lnbmVkLW9mZi1i
eTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nv
bm5lY3QuYyB8IDEyICstLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2Np
ZnMvY29ubmVjdC5jCmluZGV4IGJlY2Q1ZjgwNzc4Ny4uZDdlZmJjYjJkNWRmIDEwMDY0NAotLS0g
YS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMzkyLDE2ICsz
OTIsNiBAQCBjaWZzX2VjaG9fcmVxdWVzdChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJaW50
IHJjOwogCXN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciA9IGNvbnRhaW5lcl9vZih3b3Jr
LAogCQkJCQlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvLCBlY2hvLndvcmspOwotCXVuc2lnbmVkIGxv
bmcgZWNob19pbnRlcnZhbDsKLQotCS8qCi0JICogSWYgd2UgbmVlZCB0byByZW5lZ290aWF0ZSwg
c2V0IGVjaG8gaW50ZXJ2YWwgdG8gemVybyB0bwotCSAqIGltbWVkaWF0ZWx5IGNhbGwgZWNobyBz
ZXJ2aWNlIHdoZXJlIHdlIGNhbiByZW5lZ290aWF0ZS4KLQkgKi8KLQlpZiAoc2VydmVyLT50Y3BT
dGF0dXMgPT0gQ2lmc05lZWROZWdvdGlhdGUpCi0JCWVjaG9faW50ZXJ2YWwgPSAwOwotCWVsc2UK
LQkJZWNob19pbnRlcnZhbCA9IHNlcnZlci0+ZWNob19pbnRlcnZhbDsKIAogCS8qCiAJICogV2Ug
Y2Fubm90IHNlbmQgYW4gZWNobyBpZiBpdCBpcyBkaXNhYmxlZC4KQEAgLTQxMiw3ICs0MDIsNyBA
QCBjaWZzX2VjaG9fcmVxdWVzdChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJICAgIHNlcnZl
ci0+dGNwU3RhdHVzID09IENpZnNFeGl0aW5nIHx8CiAJICAgIHNlcnZlci0+dGNwU3RhdHVzID09
IENpZnNOZXcgfHwKIAkgICAgKHNlcnZlci0+b3BzLT5jYW5fZWNobyAmJiAhc2VydmVyLT5vcHMt
PmNhbl9lY2hvKHNlcnZlcikpIHx8Ci0JICAgIHRpbWVfYmVmb3JlKGppZmZpZXMsIHNlcnZlci0+
bHN0cnAgKyBlY2hvX2ludGVydmFsIC0gSFopKQorCSAgICB0aW1lX2JlZm9yZShqaWZmaWVzLCBz
ZXJ2ZXItPmxzdHJwICsgc2VydmVyLT5lY2hvX2ludGVydmFsIC0gSFopKQogCQlnb3RvIHJlcXVl
dWVfZWNobzsKIAogCXJjID0gc2VydmVyLT5vcHMtPmVjaG8gPyBzZXJ2ZXItPm9wcy0+ZWNobyhz
ZXJ2ZXIpIDogLUVOT1NZUzsKLS0gCjIuMjUuMQoK
--000000000000fd3bc905c14762c7--
