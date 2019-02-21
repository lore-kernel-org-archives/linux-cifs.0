Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55661C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 03:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1066720651
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 03:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZmMJiQBI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfBUDl0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 22:41:26 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:46814 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfBUDl0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 22:41:26 -0500
Received: by mail-pl1-f180.google.com with SMTP id o6so13410571pls.13
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 19:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LXE4j4ndQNexyjXa4iXHkAYLx3qMvfJu8mjRYGOYQ5w=;
        b=ZmMJiQBI2WysHq+DbfXIE8+fYqD3au2jCWH3hL6qvs6Aah61OjPyNynAMayl91o7Nh
         wzRpAtag0sWBRqVo2enXsWSUbj4+mZsiHEKTzEMHBYPzGgv9/qRTptwbw4cJ12Yww+At
         8AhjwAoSm3yFGibuUCtsTpou2CZsphDQPCj3txQ1y13jQ6/t1Jnd9f4FSOXOKYURNabt
         hM4eOj9dsx0PDMDKFz3/xPEU63GHqeyHMElGhMdjMtJ2tMvvcUvdZifWnAQMDKbZ+M7i
         ev8Ctq+14elSzeZYYcQt+fgEKq/0nuiyOMeR1hUo+7A/RIQ5QRu+VlZ6x/b7xNyV0ETM
         VDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LXE4j4ndQNexyjXa4iXHkAYLx3qMvfJu8mjRYGOYQ5w=;
        b=K7UW6Mo3f94PVvGu8OFRoAPERAFNij4rid+cPi2GaYN95OGUdG1vWt3NOUl14XyJVo
         gsPsQqMEnwwA4jX5VJkaSh3QBwEKeIoZKowwxtaTxk4d80nP4p+pZSGvitQtRQr3w5Zu
         ZJcgNGQmyqVjO8cBwJxFIvZWuW49iCKPHML5hehzQHcR8SIPDElw3iDte/vccElZ+E2m
         KuBFVHxK6IPm1gBBf7jElNbxjYP8eJ19dCrfIC4HQnww9urebqQv/F+Bvpkexi6LrXPh
         Yrnsu4urkWxPcvRAKAXV+oaS611/skonYc5Ny0sX/SnC+oSlwu/xR6kkLFRXJIOFDBNt
         Fj4w==
X-Gm-Message-State: AHQUAuY4ZMpQKc20tHfRVwoyFp8C2PtbJZUkAqPUFiKTiYG7CyRDYAVJ
        SLt2jfJryd/iBPiRuko670TGYqaQkd+CAQ72X7qtgg==
X-Google-Smtp-Source: AHgI3IZmERAeGbI0Ln3TWGFbIdvTGx4XepgdJ+c7X4EW7/SgHGjmjpDvo6h2G2MeqRx0mq3T91NL9PmFg9V8tsyWo6U=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr38389021plk.290.1550720485215;
 Wed, 20 Feb 2019 19:41:25 -0800 (PST)
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
 <CAN05THTSFf23JdkY0=seh9SbO6y1qXcQ2XGreG+ZpJWhOWG0=Q@mail.gmail.com> <CAH2r5mvBtCG_TwjOa9AqAZDeq+EEjWqR2tYaG_6NZYjQaZrMHw@mail.gmail.com>
In-Reply-To: <CAH2r5mvBtCG_TwjOa9AqAZDeq+EEjWqR2tYaG_6NZYjQaZrMHw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Feb 2019 21:41:13 -0600
Message-ID: <CAH2r5mtLyC-LutGR5bLXiMjjZrEthMhNB1-47JXN+tztht+RTg@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
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

I tried it with 1MB and 2MB i/o size and it worked so will change the
patch from 4MB blocksize (which is optimal for some cases) to 2MB
which doesn't cause these problems and at least is optimal for other
use cases.  Let me know if you see perf difference.  I saw the same
run time (with/without patch) for 014, test 490 worked (same time as
well) and 13 was 1 second slower.

On Wed, Feb 20, 2019 at 8:31 PM Steve French <smfrench@gmail.com> wrote:
>
> The problem with dropping the patch is that fixes another critical
> problem where cp and scp can go VERY slowly (since they use blocksize
> to determine the I/O size to use).  1MB is probably the minimum we
> want to set (which is what NFS uses)
>
> On Wed, Feb 20, 2019 at 7:48 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > This patch is also the reason why generic/490 fails,  so lets drop it f=
or now.
> >
> > On Thu, Feb 21, 2019 at 10:22 AM Steve French <smfrench@gmail.com> wrot=
e:
> > >
> > > We could also try with 1mb instead of 4mb for uncached I/o
> > >
> > > On Wed, Feb 20, 2019, 18:12 ronnie sahlberg <ronniesahlberg@gmail.com=
> wrote:
> > >>
> > >> What I mean is that generic/013 still works,  it just takes ~3 times
> > >> as long to run  so the buildbot is timing it out.
> > >>
> > >> Steve,
> > >> Can we revert d3de48233978524514d3b605ad55bb21d1ecd706 from for-next
> > >> and re-run the buildbot and see it it now passes?
> > >>
> > >>
> > >> On Thu, Feb 21, 2019 at 10:09 AM Ronnie Sahlberg <lsahlber@redhat.co=
m> wrote:
> > >> >
> > >> > I ran a git bisect and the performance drop came with commit d3de4=
8233978524514d3b605ad55bb21d1ecd706
> > >> >
> > >> >
> > >> > ----- Original Message -----
> > >> > From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> > >> > To: "Steve French" <smfrench@gmail.com>
> > >> > Cc: "Pavel Shilovsky" <piastryyy@gmail.com>, "Aur=C3=A9lien Aptel"=
 <aaptel@suse.com>, "CIFS" <linux-cifs@vger.kernel.org>
> > >> > Sent: Thursday, 21 February, 2019 8:47:44 AM
> > >> > Subject: Re: xfstests and current cifs for-next patch set
> > >> >
> > >> > generic/013 and generic/014 failed with timeout.  These tests used=
 to
> > >> > take several minutes.
> > >> >
> > >> > Testing locally,    generic/013 is successful but it takes almost
> > >> > three times longer than it used to just a week ago.
> > >> >
> > >> > On Thu, Feb 21, 2019 at 7:18 AM Steve French <smfrench@gmail.com> =
wrote:
> > >> > >
> > >> > > Looks like Pavel's latest fix (unrelated to credits it turns out=
, the
> > >> > > problem in this case was skipping a mid) does fix xfstest 310.  =
 Azure
> > >> > > test bucket passes, no reconnects that I spotted:
> > >> > >
> > >> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/bui=
lders/4/builds/94
> > >> > >
> > >> > > Running cifs-testing buildbot bucket now.
> > >> > >
> > >> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/bui=
lders/2/builds/134
> > >> > >
> > >> > > On Sun, Feb 17, 2019 at 1:30 PM Steve French <smfrench@gmail.com=
> wrote:
> > >> > > >
> > >> > > > Retrying the same test run it worked.   Rerunning the same set=
 of
> > >> > > > patches but this time with larger (cifs-testing) collection of=
 tests
> > >> > > > on the buildbot
> > >> > > >
> > >> > > > On Sat, Feb 16, 2019 at 10:38 PM Steve French <smfrench@gmail.=
com> wrote:
> > >> > > > >
> > >> > > > > The test (310 and subsequent) seemed to start failing with t=
his in dmesg:
> > >> > > > >
> > >> > > > > [root@fedora29 ~]# dmesg
> > >> > > > > [ 2969.016552] CIFS VFS: Cancelling wait for mid 29640 cmd: =
14
> > >> > > > > [ 2979.449426] CIFS VFS: disabling echoes and oplocks
> > >> > > > > [ 2999.109655] CIFS VFS: Cancelling wait for mid 1494 cmd: 6
> > >> > > > > [ 3225.207488] CIFS VFS: Server
> > >> > > > > linuxsmb3testshares.file.core.windows.net has not responded =
in 120
> > >> > > > > seconds. Reconnecting...
> > >> > > > >
> > >> > > > > On Sat, Feb 16, 2019 at 8:30 PM Steve French <smfrench@gmail=
.com> wrote:
> > >> > > > > >
> > >> > > > > > So (unless there is a random factor involved) - I narrowed=
 it down to this patch
> > >> > > > > >
> > >> > > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > >> > > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > >> > > > > >
> > >> > > > > >     CIFS: Respect reconnect in MTU credits calculations
> > >> > > > > >
> > >> > > > > >     Every time after a session reconnect we don't need to =
account for
> > >> > > > > >     credits obtained in previous sessions. Introduce new s=
truct cifs_credits
> > >> > > > > >     which contains both credits value and reconnect instan=
ce of the
> > >> > > > > >     time those credits were taken. Modify a routine that a=
dd credits
> > >> > > > > >     back to handle the reconnect instance by assuming zero=
 credits
> > >> > > > > >     if the reconnect happened after the credits were obtai=
ned and
> > >> > > > > >     before we decided to add them back due to some errors =
during sending.
> > >> > > > > >
> > >> > > > > >     This patch fixes the MTU credits cases. The subsequent=
 patch
> > >> > > > > >     will handle non-MTU ones.
> > >> > > > > >
> > >> > > > > >     Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> > >> > > > > >     Signed-off-by: Steve French <stfrench@microsoft.com>
> > >> > > > > >
> > >> > > > > >
> > >> > > > > > ---------- Forwarded message ---------
> > >> > > > > > From: Steve French <smfrench@gmail.com>
> > >> > > > > > Date: Sat, Feb 16, 2019 at 6:46 PM
> > >> > > > > > Subject: Re: xfstests and current cifs for-next patch set
> > >> > > > > > To: CIFS <linux-cifs@vger.kernel.org>
> > >> > > > > >
> > >> > > > > >
> > >> > > > > > Narrowed the xfstest 310 possible regression in current fo=
r-next down
> > >> > > > > > to three patches, rerunning with this one of the three add=
ed (see
> > >> > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com=
/#/builders/4/builds/85)
> > >> > > > > >
> > >> > > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > >> > > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > >> > > > > >
> > >> > > > > >     CIFS: Respect reconnect in MTU credits calculations
> > >> > > > > >
> > >> > > > > > On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@gma=
il.com> wrote:
> > >> > > > > > >
> > >> > > > > > > With 5.0-rc5 and current for-next (29 paches) two tests =
310 (read and
> > >> > > > > > > readdir simultaneously) and 422 (delayed allocation stat=
, number of
> > >> > > > > > > blocks) fail I see this in the azure test bucket in the =
buildbot).
> > >> > > > > > > see this run: http://smb3-test-rhel-75.southcentralus.cl=
oudapp.azure.com/#/builders/4/builds/80
> > >> > > > > > >
> > >> > > > > > > These don't fail when I select only the first 8 cifs fix=
es in for-next
> > >> > > > > > > ontop of 5.0-rc5.  See
> > >> > > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.c=
om/#/builders/4/builds/82
> > >> > > > > > >  so am trying to narrow it down.    This run (in progres=
s)
> > >> > > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.c=
om/#/builders/4/builds/83
> > >> > > > > > > has the first 19 (of the 29) cifs patches (ontop of 5.0-=
rc5 mainline
> > >> > > > > > > as with the runs above) so we can bisect which commit ca=
uses the
> > >> > > > > > > problem with tests 310 and 422.
> > >> > > > > > >
> > >> > > > > > > This seems unrelated to the problem I see in slightly mo=
re current
> > >> > > > > > > mainline (that we can see with no cifs changes) in xfste=
st 422 that
> > >> > > > > > > was introduced with 5.0-rc6.
> > >> > > > > > >
> > >> > > > > > > Let me know if others (or other scenario problems) see t=
he tests
> > >> > > > > > > 310/422 failure.
> > >> > > > > > >
> > >> > > > > > > --
> > >> > > > > > > Thanks,
> > >> > > > > > >
> > >> > > > > > > Steve
> > >> > > > > >
> > >> > > > > >
> > >> > > > > >
> > >> > > > > > --
> > >> > > > > > Thanks,
> > >> > > > > >
> > >> > > > > > Steve
> > >> > > > > >
> > >> > > > > >
> > >> > > > > > --
> > >> > > > > > Thanks,
> > >> > > > > >
> > >> > > > > > Steve
> > >> > > > >
> > >> > > > >
> > >> > > > >
> > >> > > > > --
> > >> > > > > Thanks,
> > >> > > > >
> > >> > > > > Steve
> > >> > > >
> > >> > > >
> > >> > > >
> > >> > > > --
> > >> > > > Thanks,
> > >> > > >
> > >> > > > Steve
> > >> > >
> > >> > >
> > >> > >
> > >> > > --
> > >> > > Thanks,
> > >> > >
> > >> > > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
