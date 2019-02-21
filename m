Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04C0C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 00:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65A4420855
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 00:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dan3L3yQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfBUAMt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 19:12:49 -0500
Received: from mail-qt1-f180.google.com ([209.85.160.180]:41628 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfBUAMs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 19:12:48 -0500
Received: by mail-qt1-f180.google.com with SMTP id v10so29535605qtp.8
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 16:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CC02aJUpfWxD1O4Uc0MDFKUAMX6prcbleDrxhzyyS6w=;
        b=dan3L3yQu0yKVwjDw1Xsk2AFw9FerFDSxRqw5zPaU/lJm2Co2avd2ifkr9Nht6p38I
         Ju+G0I8JTUVHmTggdgfXGXrIslz8JBZuJB24XxNVRc2XIKDwG9bGbOQFI8AoSF4NflLu
         vDyBaNsDRpTkupX0xCCiz0EtsCzQ8k5G+c0GwBK2evC5NshqxLWvfY/Y7TMV3gNx0XcJ
         vbWAubAKQ7M7+qM5BqJPkhNyJTlgOShEhr96LSUhpNHn3bR+kpP5ajmv6NYFLWs+/SWm
         DXk+G09YhwF2AWkV52A8WVdy71sVX5mHcCYMu8O47r0yfmRxMfy117iXtbOsPs40m3lq
         K+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CC02aJUpfWxD1O4Uc0MDFKUAMX6prcbleDrxhzyyS6w=;
        b=FNv+YZo3WNTSEfA+MpIaPCY0J1q2nVWySmMt/6xKoc7mO/oKjoEkt+6A7wDUJQoUWy
         SmuMfvwOYI0Ryp1AGu4eqP+XtFmDLSh8c10TgzBajoy+iSXk03Uz3xxazV7a76rJuN9m
         juKhOzpucktMwQBfjSwzKT82/OpOt/TFTVmzFWDr8ttStlpaGanb66m/B3l2hh6VE8ZU
         LzXXPmhuG10BrFmR8YM7K+42mSw9LmjRPfXu8nC83NOCot4MRCmS55eBk9wrYKX2jrcQ
         P+6re0Whygr4Cf/NyVS7efjDj1fkz5hzllmUbsX4hvzGcZgV1NgjkwNjb3xD5lUDBWoC
         mhvA==
X-Gm-Message-State: AHQUAuZ9c9SSoRy/tVfe6nFRPCyh617vO8HaujYdD8KdO4mlEkotZ9w8
        EIR0/SzYS3oWxyCkOaUuz7vMvTrW8XJV2lGIHMA=
X-Google-Smtp-Source: AHgI3IZ8MoiflEecB0fhWBXHus2CDOXLQcSlTSbMuLPQLqKVzkKaDoCtSgimh1sH00Q8OYXI8T9D/A5tuCJ1NwXcMgw=
X-Received: by 2002:aed:2586:: with SMTP id x6mr29080884qtc.331.1550707967393;
 Wed, 20 Feb 2019 16:12:47 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
 <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
 <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com>
 <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com>
 <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com>
 <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com>
 <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com> <1014205314.2917941.1550707791215.JavaMail.zimbra@redhat.com>
In-Reply-To: <1014205314.2917941.1550707791215.JavaMail.zimbra@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 21 Feb 2019 10:12:36 +1000
Message-ID: <CAN05THTp7_sKUVQSYYTYx9AhaUeSafX_GPGSjvsLSJUa=-pzmg@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

What I mean is that generic/013 still works,  it just takes ~3 times
as long to run  so the buildbot is timing it out.

Steve,
Can we revert d3de48233978524514d3b605ad55bb21d1ecd706 from for-next
and re-run the buildbot and see it it now passes?


On Thu, Feb 21, 2019 at 10:09 AM Ronnie Sahlberg <lsahlber@redhat.com> wrot=
e:
>
> I ran a git bisect and the performance drop came with commit d3de48233978=
524514d3b605ad55bb21d1ecd706
>
>
> ----- Original Message -----
> From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> To: "Steve French" <smfrench@gmail.com>
> Cc: "Pavel Shilovsky" <piastryyy@gmail.com>, "Aur=C3=A9lien Aptel" <aapte=
l@suse.com>, "CIFS" <linux-cifs@vger.kernel.org>
> Sent: Thursday, 21 February, 2019 8:47:44 AM
> Subject: Re: xfstests and current cifs for-next patch set
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
