Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85BAC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 09:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FF4F20880
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 09:44:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qjy+L0tN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfBUJok (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 04:44:40 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]:37420 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfBUJoj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 04:44:39 -0500
Received: by mail-qt1-f179.google.com with SMTP id a48so30770038qtb.4
        for <linux-cifs@vger.kernel.org>; Thu, 21 Feb 2019 01:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JY21P0fl1QgfsfeTtVdC5xjLsjWbN6rv17P86nKsemg=;
        b=Qjy+L0tNWX6NyVO4xMsu2TCWOpcEvXxONHAk7tIRfEdEGt+UIyoZEQhsj13cz1NWKJ
         MCqfkl3+1Zs4R79gil0yrrrA+t6ijmIyYMhFuc0FwWKi4dqDIjLGiIaPOZpQhQoTuByr
         jwfakWEOOlJ/f7vl+xZwC/xHE9wjq1TL/xAZOqImY6itCjeGQWRxLktqPo80UEVdji+r
         +tbWNxc6//olHQi80WITpQbV1L1vqODzsbhR/eDKabtNpM9kVWrP5QAZqblhjEP3Lpub
         mHGo5RhkOHDShf9Guhlr6LXiKITuvVmJzWPllju5wpMaSoRUE+3lbV7vuI/vYQ+LdgFc
         kfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JY21P0fl1QgfsfeTtVdC5xjLsjWbN6rv17P86nKsemg=;
        b=rKYkRTAL1TXmPr0dWeX3SfUEWx+rSQHw55qMepuRPKpAKvth8964hphap8eEqF7NU2
         +/M3jtzFY6IVogFV6b/Blckp22vwYS2KPh/bYVOn2TQzoI9IFy8h7cEM98u4larAotqc
         hEpiJe21hA/oIl/W+13FeQqeyLrMImFSoGcHkHJGWp+vbyTzVLzcWFF5XzY/Apn1A7Ds
         xcR5xyIp0jRGAzhWvHcNYkfFCbVePT4Ds+LL7hgQ9OBJM5uJYFzJWWhjU/oAaALeWodf
         SXBe6Oj0Kp5xvhzKmjuAUE+SeIhih9Vja3uknK7MXflsRmIuRFXb/ZH/JoFy3ZNadMv1
         rerw==
X-Gm-Message-State: AHQUAuYdFsr5xeD/zI4v3K6B75RuakE8yY+2R6gsW6aS+HGaDWqavnnL
        xuPDaTrR3JW2mdqK4x7s5jRsJqEryMax/zxdLHYCWg==
X-Google-Smtp-Source: AHgI3IZVZ8Ko/ijQx/dx16FlRTaqIDpQT8bQR0m6wiooNIpc5AuAHmcGlOXFDL6vd2KBVM3n2AiZbVBJa7WNiEvn0V0=
X-Received: by 2002:ac8:2709:: with SMTP id g9mr29922306qtg.287.1550742278279;
 Thu, 21 Feb 2019 01:44:38 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
 <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
 <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com>
 <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com>
 <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com>
 <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com>
 <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com>
 <1014205314.2917941.1550707791215.JavaMail.zimbra@redhat.com>
 <CAN05THTp7_sKUVQSYYTYx9AhaUeSafX_GPGSjvsLSJUa=-pzmg@mail.gmail.com>
 <CAH2r5mscVyY4WcLfNWzCZhELQYUT_SRNK0UJvVyWHdC-6N3XCQ@mail.gmail.com>
 <CAN05THTSFf23JdkY0=seh9SbO6y1qXcQ2XGreG+ZpJWhOWG0=Q@mail.gmail.com>
 <CAH2r5mvBtCG_TwjOa9AqAZDeq+EEjWqR2tYaG_6NZYjQaZrMHw@mail.gmail.com> <CAH2r5mvZHgoUePpZGGikWpqQbjoNGXg_pR6tE1DxUjnPBpcztw@mail.gmail.com>
In-Reply-To: <CAH2r5mvZHgoUePpZGGikWpqQbjoNGXg_pR6tE1DxUjnPBpcztw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 21 Feb 2019 19:44:26 +1000
Message-ID: <CAN05THTn5ei7B+GMfEsKhvpzr0pq5CzQpcBW23VdP40k_xBeMQ@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All the tests passed. Still generic/013 takes well over double the time it =
used.
Maybe 1Mb is better?   Or this is all micro-optimizations for a super
rare usecase (users actually using specific mount options)

On Thu, Feb 21, 2019 at 2:00 PM Steve French <smfrench@gmail.com> wrote:
>
> The reason 490 seems to be failing is that it is using the blocksize
> as allocation size and then doing truncate/seek.  Could be buggy test
> case but easier to just set it to 2MB which solves both problems.
>
> On Wed, Feb 20, 2019 at 8:31 PM Steve French <smfrench@gmail.com> wrote:
> >
> > The problem with dropping the patch is that fixes another critical
> > problem where cp and scp can go VERY slowly (since they use blocksize
> > to determine the I/O size to use).  1MB is probably the minimum we
> > want to set (which is what NFS uses)
> >
> > On Wed, Feb 20, 2019 at 7:48 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > This patch is also the reason why generic/490 fails,  so lets drop it=
 for now.
> > >
> > > On Thu, Feb 21, 2019 at 10:22 AM Steve French <smfrench@gmail.com> wr=
ote:
> > > >
> > > > We could also try with 1mb instead of 4mb for uncached I/o
> > > >
> > > > On Wed, Feb 20, 2019, 18:12 ronnie sahlberg <ronniesahlberg@gmail.c=
om> wrote:
> > > >>
> > > >> What I mean is that generic/013 still works,  it just takes ~3 tim=
es
> > > >> as long to run  so the buildbot is timing it out.
> > > >>
> > > >> Steve,
> > > >> Can we revert d3de48233978524514d3b605ad55bb21d1ecd706 from for-ne=
xt
> > > >> and re-run the buildbot and see it it now passes?
> > > >>
> > > >>
> > > >> On Thu, Feb 21, 2019 at 10:09 AM Ronnie Sahlberg <lsahlber@redhat.=
com> wrote:
> > > >> >
> > > >> > I ran a git bisect and the performance drop came with commit d3d=
e48233978524514d3b605ad55bb21d1ecd706
> > > >> >
> > > >> >
> > > >> > ----- Original Message -----
> > > >> > From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> > > >> > To: "Steve French" <smfrench@gmail.com>
> > > >> > Cc: "Pavel Shilovsky" <piastryyy@gmail.com>, "Aur=C3=A9lien Apte=
l" <aaptel@suse.com>, "CIFS" <linux-cifs@vger.kernel.org>
> > > >> > Sent: Thursday, 21 February, 2019 8:47:44 AM
> > > >> > Subject: Re: xfstests and current cifs for-next patch set
> > > >> >
> > > >> > generic/013 and generic/014 failed with timeout.  These tests us=
ed to
> > > >> > take several minutes.
> > > >> >
> > > >> > Testing locally,    generic/013 is successful but it takes almos=
t
> > > >> > three times longer than it used to just a week ago.
> > > >> >
> > > >> > On Thu, Feb 21, 2019 at 7:18 AM Steve French <smfrench@gmail.com=
> wrote:
> > > >> > >
> > > >> > > Looks like Pavel's latest fix (unrelated to credits it turns o=
ut, the
> > > >> > > problem in this case was skipping a mid) does fix xfstest 310.=
   Azure
> > > >> > > test bucket passes, no reconnects that I spotted:
> > > >> > >
> > > >> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/b=
uilders/4/builds/94
> > > >> > >
> > > >> > > Running cifs-testing buildbot bucket now.
> > > >> > >
> > > >> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/b=
uilders/2/builds/134
> > > >> > >
> > > >> > > On Sun, Feb 17, 2019 at 1:30 PM Steve French <smfrench@gmail.c=
om> wrote:
> > > >> > > >
> > > >> > > > Retrying the same test run it worked.   Rerunning the same s=
et of
> > > >> > > > patches but this time with larger (cifs-testing) collection =
of tests
> > > >> > > > on the buildbot
> > > >> > > >
> > > >> > > > On Sat, Feb 16, 2019 at 10:38 PM Steve French <smfrench@gmai=
l.com> wrote:
> > > >> > > > >
> > > >> > > > > The test (310 and subsequent) seemed to start failing with=
 this in dmesg:
> > > >> > > > >
> > > >> > > > > [root@fedora29 ~]# dmesg
> > > >> > > > > [ 2969.016552] CIFS VFS: Cancelling wait for mid 29640 cmd=
: 14
> > > >> > > > > [ 2979.449426] CIFS VFS: disabling echoes and oplocks
> > > >> > > > > [ 2999.109655] CIFS VFS: Cancelling wait for mid 1494 cmd:=
 6
> > > >> > > > > [ 3225.207488] CIFS VFS: Server
> > > >> > > > > linuxsmb3testshares.file.core.windows.net has not responde=
d in 120
> > > >> > > > > seconds. Reconnecting...
> > > >> > > > >
> > > >> > > > > On Sat, Feb 16, 2019 at 8:30 PM Steve French <smfrench@gma=
il.com> wrote:
> > > >> > > > > >
> > > >> > > > > > So (unless there is a random factor involved) - I narrow=
ed it down to this patch
> > > >> > > > > >
> > > >> > > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > >> > > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > > >> > > > > >
> > > >> > > > > >     CIFS: Respect reconnect in MTU credits calculations
> > > >> > > > > >
> > > >> > > > > >     Every time after a session reconnect we don't need t=
o account for
> > > >> > > > > >     credits obtained in previous sessions. Introduce new=
 struct cifs_credits
> > > >> > > > > >     which contains both credits value and reconnect inst=
ance of the
> > > >> > > > > >     time those credits were taken. Modify a routine that=
 add credits
> > > >> > > > > >     back to handle the reconnect instance by assuming ze=
ro credits
> > > >> > > > > >     if the reconnect happened after the credits were obt=
ained and
> > > >> > > > > >     before we decided to add them back due to some error=
s during sending.
> > > >> > > > > >
> > > >> > > > > >     This patch fixes the MTU credits cases. The subseque=
nt patch
> > > >> > > > > >     will handle non-MTU ones.
> > > >> > > > > >
> > > >> > > > > >     Signed-off-by: Pavel Shilovsky <pshilov@microsoft.co=
m>
> > > >> > > > > >     Signed-off-by: Steve French <stfrench@microsoft.com>
> > > >> > > > > >
> > > >> > > > > >
> > > >> > > > > > ---------- Forwarded message ---------
> > > >> > > > > > From: Steve French <smfrench@gmail.com>
> > > >> > > > > > Date: Sat, Feb 16, 2019 at 6:46 PM
> > > >> > > > > > Subject: Re: xfstests and current cifs for-next patch se=
t
> > > >> > > > > > To: CIFS <linux-cifs@vger.kernel.org>
> > > >> > > > > >
> > > >> > > > > >
> > > >> > > > > > Narrowed the xfstest 310 possible regression in current =
for-next down
> > > >> > > > > > to three patches, rerunning with this one of the three a=
dded (see
> > > >> > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.c=
om/#/builders/4/builds/85)
> > > >> > > > > >
> > > >> > > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > >> > > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > > >> > > > > >
> > > >> > > > > >     CIFS: Respect reconnect in MTU credits calculations
> > > >> > > > > >
> > > >> > > > > > On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@g=
mail.com> wrote:
> > > >> > > > > > >
> > > >> > > > > > > With 5.0-rc5 and current for-next (29 paches) two test=
s 310 (read and
> > > >> > > > > > > readdir simultaneously) and 422 (delayed allocation st=
at, number of
> > > >> > > > > > > blocks) fail I see this in the azure test bucket in th=
e buildbot).
> > > >> > > > > > > see this run: http://smb3-test-rhel-75.southcentralus.=
cloudapp.azure.com/#/builders/4/builds/80
> > > >> > > > > > >
> > > >> > > > > > > These don't fail when I select only the first 8 cifs f=
ixes in for-next
> > > >> > > > > > > ontop of 5.0-rc5.  See
> > > >> > > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure=
.com/#/builders/4/builds/82
> > > >> > > > > > >  so am trying to narrow it down.    This run (in progr=
ess)
> > > >> > > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure=
.com/#/builders/4/builds/83
> > > >> > > > > > > has the first 19 (of the 29) cifs patches (ontop of 5.=
0-rc5 mainline
> > > >> > > > > > > as with the runs above) so we can bisect which commit =
causes the
> > > >> > > > > > > problem with tests 310 and 422.
> > > >> > > > > > >
> > > >> > > > > > > This seems unrelated to the problem I see in slightly =
more current
> > > >> > > > > > > mainline (that we can see with no cifs changes) in xfs=
test 422 that
> > > >> > > > > > > was introduced with 5.0-rc6.
> > > >> > > > > > >
> > > >> > > > > > > Let me know if others (or other scenario problems) see=
 the tests
> > > >> > > > > > > 310/422 failure.
> > > >> > > > > > >
> > > >> > > > > > > --
> > > >> > > > > > > Thanks,
> > > >> > > > > > >
> > > >> > > > > > > Steve
> > > >> > > > > >
> > > >> > > > > >
> > > >> > > > > >
> > > >> > > > > > --
> > > >> > > > > > Thanks,
> > > >> > > > > >
> > > >> > > > > > Steve
> > > >> > > > > >
> > > >> > > > > >
> > > >> > > > > > --
> > > >> > > > > > Thanks,
> > > >> > > > > >
> > > >> > > > > > Steve
> > > >> > > > >
> > > >> > > > >
> > > >> > > > >
> > > >> > > > > --
> > > >> > > > > Thanks,
> > > >> > > > >
> > > >> > > > > Steve
> > > >> > > >
> > > >> > > >
> > > >> > > >
> > > >> > > > --
> > > >> > > > Thanks,
> > > >> > > >
> > > >> > > > Steve
> > > >> > >
> > > >> > >
> > > >> > >
> > > >> > > --
> > > >> > > Thanks,
> > > >> > >
> > > >> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
