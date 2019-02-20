Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8855AC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 23:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4486A20855
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 23:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KW1m7h3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfBTXl0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:41:26 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:43236 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfBTXlZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 18:41:25 -0500
Received: by mail-lj1-f174.google.com with SMTP id z20so21333453ljj.10
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 15:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3wLLJXWA884uheSwmCeizg93uci4oR9Rj+vHKHEkMXw=;
        b=KW1m7h3fDFOjar/wmKl+ZzCQv9KoTWXzhYrDFYunjak6/6X6ZdRYi24GjcZ831siNA
         ZPCvuQDy2Hz/y1mYzdyoPGHl7N/6YaRaRGe9xiNwYRQt+54ZW4HUNreBEiCzqFV9eNHN
         uMa/LkitegULt6TaEdrE5DS+zm4a1G8rZ/jR8GZugJ6FvdjUm/oLmIYXQF9sI5eIQ+oH
         TNp+0UO5UtLdWB/tLhpsSg1UFxOsxclmtCxpunIlZwiyviuVIjLEahT+IQE59pVf7y4Q
         bamO8LSJgUeEw859tkv6mRS+ykVEZvLbAd/kEqccm6IMASu+njOjH1XqBfGMBixbd3QJ
         70HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3wLLJXWA884uheSwmCeizg93uci4oR9Rj+vHKHEkMXw=;
        b=B2H+262S8qbUhQHvy8nIhBqdlvs72dFFkfwNwGxhqCevvOSJmQmEO28ouYlEQgWIGp
         WUzMJMYggoUDlizXuWSsEGa4x/EjC/2I7luygsly43Oa3y8skz4tx8p0gH5phpeyZ/IA
         p8412Y16uQiaErK6jXZFkuYjHY+A7zKB3letOAjqPYjqMGZOKi36GDa9wgOnwQ3A4BYt
         tVKFrs6tzjniXsEmuZ4JbtqvJ2ySK1dUnhsJQ/cepY7tw9vkbf7h7ygEEGeIbeZQLPt0
         H5aJFRyFejQsAkQ0DV9j5dt7FZXGxYtw+czNUAyI91YF/Ngsjpd0qxgpFXYS5a28cwzC
         m/0w==
X-Gm-Message-State: AHQUAuZcQKGP6DxOUub0oQJTRputu/Bb3vZZeEqHXpOHqFk6Qo/OGDCw
        r+ZiiGmQacvBwJrhlV4fFcZXzB4ZFwNpibHYuw==
X-Google-Smtp-Source: AHgI3IZEwp73V0fo0HTwljSJalBaF2XiQ06RaKqeHGFwtiZAybWIHbMHOWztOLFcZ9QiBxx8Wwvp02PQBU4opCL/mLY=
X-Received: by 2002:a2e:251:: with SMTP id 78mr16325680ljc.90.1550706082826;
 Wed, 20 Feb 2019 15:41:22 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
 <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
 <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com>
 <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com>
 <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com>
 <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com> <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com>
In-Reply-To: <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 20 Feb 2019 15:41:11 -0800
Message-ID: <CAKywueT4N=LnjAHyHRV-+hehF8x2U4+TguGO2dPojX4t=SqtBA@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Last time it worked with patches on top of the older tree (~rc4).
These tests keep failing since then. We should probably apply patches
on top of rc4 and restart.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 20 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 14:47, ronni=
e sahlberg <ronniesahlberg@gmail.com>:
>
> generic/013 and generic/014 failed with timeout.  These tests used to
> take several minutes.
>
> Testing locally,    generic/013 is successful but it takes almost
> three times longer than it used to just a week ago.
>
> On Thu, Feb 21, 2019 at 7:18 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Looks like Pavel's latest fix (unrelated to credits it turns out, the
> > problem in this case was skipping a mid) does fix xfstest 310.   Azure
> > test bucket passes, no reconnects that I spotted:
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4=
/builds/94
> >
> > Running cifs-testing buildbot bucket now.
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2=
/builds/134
> >
> > On Sun, Feb 17, 2019 at 1:30 PM Steve French <smfrench@gmail.com> wrote=
:
> > >
> > > Retrying the same test run it worked.   Rerunning the same set of
> > > patches but this time with larger (cifs-testing) collection of tests
> > > on the buildbot
> > >
> > > On Sat, Feb 16, 2019 at 10:38 PM Steve French <smfrench@gmail.com> wr=
ote:
> > > >
> > > > The test (310 and subsequent) seemed to start failing with this in =
dmesg:
> > > >
> > > > [root@fedora29 ~]# dmesg
> > > > [ 2969.016552] CIFS VFS: Cancelling wait for mid 29640 cmd: 14
> > > > [ 2979.449426] CIFS VFS: disabling echoes and oplocks
> > > > [ 2999.109655] CIFS VFS: Cancelling wait for mid 1494 cmd: 6
> > > > [ 3225.207488] CIFS VFS: Server
> > > > linuxsmb3testshares.file.core.windows.net has not responded in 120
> > > > seconds. Reconnecting...
> > > >
> > > > On Sat, Feb 16, 2019 at 8:30 PM Steve French <smfrench@gmail.com> w=
rote:
> > > > >
> > > > > So (unless there is a random factor involved) - I narrowed it dow=
n to this patch
> > > > >
> > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > > > >
> > > > >     CIFS: Respect reconnect in MTU credits calculations
> > > > >
> > > > >     Every time after a session reconnect we don't need to account=
 for
> > > > >     credits obtained in previous sessions. Introduce new struct c=
ifs_credits
> > > > >     which contains both credits value and reconnect instance of t=
he
> > > > >     time those credits were taken. Modify a routine that add cred=
its
> > > > >     back to handle the reconnect instance by assuming zero credit=
s
> > > > >     if the reconnect happened after the credits were obtained and
> > > > >     before we decided to add them back due to some errors during =
sending.
> > > > >
> > > > >     This patch fixes the MTU credits cases. The subsequent patch
> > > > >     will handle non-MTU ones.
> > > > >
> > > > >     Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > > >     Signed-off-by: Steve French <stfrench@microsoft.com>
> > > > >
> > > > >
> > > > > ---------- Forwarded message ---------
> > > > > From: Steve French <smfrench@gmail.com>
> > > > > Date: Sat, Feb 16, 2019 at 6:46 PM
> > > > > Subject: Re: xfstests and current cifs for-next patch set
> > > > > To: CIFS <linux-cifs@vger.kernel.org>
> > > > >
> > > > >
> > > > > Narrowed the xfstest 310 possible regression in current for-next =
down
> > > > > to three patches, rerunning with this one of the three added (see
> > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/buil=
ders/4/builds/85)
> > > > >
> > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > > > >
> > > > >     CIFS: Respect reconnect in MTU credits calculations
> > > > >
> > > > > On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@gmail.com>=
 wrote:
> > > > > >
> > > > > > With 5.0-rc5 and current for-next (29 paches) two tests 310 (re=
ad and
> > > > > > readdir simultaneously) and 422 (delayed allocation stat, numbe=
r of
> > > > > > blocks) fail I see this in the azure test bucket in the buildbo=
t).
> > > > > > see this run: http://smb3-test-rhel-75.southcentralus.cloudapp.=
azure.com/#/builders/4/builds/80
> > > > > >
> > > > > > These don't fail when I select only the first 8 cifs fixes in f=
or-next
> > > > > > ontop of 5.0-rc5.  See
> > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/bu=
ilders/4/builds/82
> > > > > >  so am trying to narrow it down.    This run (in progress)
> > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/bu=
ilders/4/builds/83
> > > > > > has the first 19 (of the 29) cifs patches (ontop of 5.0-rc5 mai=
nline
> > > > > > as with the runs above) so we can bisect which commit causes th=
e
> > > > > > problem with tests 310 and 422.
> > > > > >
> > > > > > This seems unrelated to the problem I see in slightly more curr=
ent
> > > > > > mainline (that we can see with no cifs changes) in xfstest 422 =
that
> > > > > > was introduced with 5.0-rc6.
> > > > > >
> > > > > > Let me know if others (or other scenario problems) see the test=
s
> > > > > > 310/422 failure.
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
