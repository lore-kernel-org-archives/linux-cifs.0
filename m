Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236DBC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 01:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7292086C
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 01:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G8a8qem2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfBUBsY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 20:48:24 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:45307 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBUBsY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 20:48:24 -0500
Received: by mail-qt1-f172.google.com with SMTP id d18so19694830qtg.12
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 17:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tIlaa87ifUkGu8YNMuy1gOwiIbIFvFA0MW2PcqRor4s=;
        b=G8a8qem2+hAc7rucnqdu8gjuFv34/zMQPM+bqumt+HJHHe8LX/RPKVY0H862n0CmSs
         PWPJZEoDTYKaFnBC8GaBc99OSkb8jwc4Zmq+0/CyvELIgUGFIS7/67vFkD67XdS41fOx
         XehLv+nORQOXLJoh37SDapxDXj6ThiU0XyU7n5piLBXy06abDyVKic2BP84KrGg/vpkU
         jOGEJymMwaBRKGGVCpdkSb2ywwkzTNLa+nGEeKyoj2JSt4uMCFL9zqiKGw7CD82uyyfh
         DunOU9XKqrcUwO28z/ebjWGG+00f2mZZw5FDc8hmY87X0BDhvys3wd0CmILsolAFqqmL
         3Hdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tIlaa87ifUkGu8YNMuy1gOwiIbIFvFA0MW2PcqRor4s=;
        b=nIi53/f5cQdrNXAo+0yoRH4g75yV2yNYLf9rOVhWNsAdnwelV1STbA1MxHIqIM6vPO
         sMxHUsQSJ98Brw4RW0yek5CQrCD8ZwvUNHOAbH9cTWKMCniAo06fsBRM6nvvWr9MvSgV
         GflUwe+asjHmBLPi5RaiWPABFgSdkO8B8WMPRqiwWhD/KDxD742DPCHTui+h2sahRIhD
         tiCGhRoSECon2OXs4PkViyjRTdrShoXFlgrjyp+qES9AsS913dxFpxr8BnTU2MY8dksa
         dADpEh/mH6NpJaDoI37ELXmC+SOao0Jv1ygo61FoLvGdjU3o6R5ZbdGPTlmB1Ld2aNB0
         cMDg==
X-Gm-Message-State: AHQUAuY6MOw+i9wDBHozt/CjygJYxE4HVlTqzKG/LkTTDOoqHTJzRDO5
        POaxpV84eAnzZ9IgSnqlXuvzdAXRnQpbXQeF5YTPkg==
X-Google-Smtp-Source: AHgI3IaAhFoaV5xqlgIGqh6zECD8iV/g1JwP79t8pDkhGh7mVAJ5Ib3rI/r3NlI7FRnG0UAzbuT9YEXyDXQGoE/AEkw=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr27763971qtj.86.1550713702579;
 Wed, 20 Feb 2019 17:48:22 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
 <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
 <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com>
 <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com>
 <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com>
 <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com>
 <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com>
 <1014205314.2917941.1550707791215.JavaMail.zimbra@redhat.com>
 <CAN05THTp7_sKUVQSYYTYx9AhaUeSafX_GPGSjvsLSJUa=-pzmg@mail.gmail.com> <CAH2r5mscVyY4WcLfNWzCZhELQYUT_SRNK0UJvVyWHdC-6N3XCQ@mail.gmail.com>
In-Reply-To: <CAH2r5mscVyY4WcLfNWzCZhELQYUT_SRNK0UJvVyWHdC-6N3XCQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 21 Feb 2019 11:48:10 +1000
Message-ID: <CAN05THTSFf23JdkY0=seh9SbO6y1qXcQ2XGreG+ZpJWhOWG0=Q@mail.gmail.com>
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

This patch is also the reason why generic/490 fails,  so lets drop it for n=
ow.

On Thu, Feb 21, 2019 at 10:22 AM Steve French <smfrench@gmail.com> wrote:
>
> We could also try with 1mb instead of 4mb for uncached I/o
>
> On Wed, Feb 20, 2019, 18:12 ronnie sahlberg <ronniesahlberg@gmail.com> wr=
ote:
>>
>> What I mean is that generic/013 still works,  it just takes ~3 times
>> as long to run  so the buildbot is timing it out.
>>
>> Steve,
>> Can we revert d3de48233978524514d3b605ad55bb21d1ecd706 from for-next
>> and re-run the buildbot and see it it now passes?
>>
>>
>> On Thu, Feb 21, 2019 at 10:09 AM Ronnie Sahlberg <lsahlber@redhat.com> w=
rote:
>> >
>> > I ran a git bisect and the performance drop came with commit d3de48233=
978524514d3b605ad55bb21d1ecd706
>> >
>> >
>> > ----- Original Message -----
>> > From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
>> > To: "Steve French" <smfrench@gmail.com>
>> > Cc: "Pavel Shilovsky" <piastryyy@gmail.com>, "Aur=C3=A9lien Aptel" <aa=
ptel@suse.com>, "CIFS" <linux-cifs@vger.kernel.org>
>> > Sent: Thursday, 21 February, 2019 8:47:44 AM
>> > Subject: Re: xfstests and current cifs for-next patch set
>> >
>> > generic/013 and generic/014 failed with timeout.  These tests used to
>> > take several minutes.
>> >
>> > Testing locally,    generic/013 is successful but it takes almost
>> > three times longer than it used to just a week ago.
>> >
>> > On Thu, Feb 21, 2019 at 7:18 AM Steve French <smfrench@gmail.com> wrot=
e:
>> > >
>> > > Looks like Pavel's latest fix (unrelated to credits it turns out, th=
e
>> > > problem in this case was skipping a mid) does fix xfstest 310.   Azu=
re
>> > > test bucket passes, no reconnects that I spotted:
>> > >
>> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builder=
s/4/builds/94
>> > >
>> > > Running cifs-testing buildbot bucket now.
>> > >
>> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builder=
s/2/builds/134
>> > >
>> > > On Sun, Feb 17, 2019 at 1:30 PM Steve French <smfrench@gmail.com> wr=
ote:
>> > > >
>> > > > Retrying the same test run it worked.   Rerunning the same set of
>> > > > patches but this time with larger (cifs-testing) collection of tes=
ts
>> > > > on the buildbot
>> > > >
>> > > > On Sat, Feb 16, 2019 at 10:38 PM Steve French <smfrench@gmail.com>=
 wrote:
>> > > > >
>> > > > > The test (310 and subsequent) seemed to start failing with this =
in dmesg:
>> > > > >
>> > > > > [root@fedora29 ~]# dmesg
>> > > > > [ 2969.016552] CIFS VFS: Cancelling wait for mid 29640 cmd: 14
>> > > > > [ 2979.449426] CIFS VFS: disabling echoes and oplocks
>> > > > > [ 2999.109655] CIFS VFS: Cancelling wait for mid 1494 cmd: 6
>> > > > > [ 3225.207488] CIFS VFS: Server
>> > > > > linuxsmb3testshares.file.core.windows.net has not responded in 1=
20
>> > > > > seconds. Reconnecting...
>> > > > >
>> > > > > On Sat, Feb 16, 2019 at 8:30 PM Steve French <smfrench@gmail.com=
> wrote:
>> > > > > >
>> > > > > > So (unless there is a random factor involved) - I narrowed it =
down to this patch
>> > > > > >
>> > > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
>> > > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
>> > > > > >
>> > > > > >     CIFS: Respect reconnect in MTU credits calculations
>> > > > > >
>> > > > > >     Every time after a session reconnect we don't need to acco=
unt for
>> > > > > >     credits obtained in previous sessions. Introduce new struc=
t cifs_credits
>> > > > > >     which contains both credits value and reconnect instance o=
f the
>> > > > > >     time those credits were taken. Modify a routine that add c=
redits
>> > > > > >     back to handle the reconnect instance by assuming zero cre=
dits
>> > > > > >     if the reconnect happened after the credits were obtained =
and
>> > > > > >     before we decided to add them back due to some errors duri=
ng sending.
>> > > > > >
>> > > > > >     This patch fixes the MTU credits cases. The subsequent pat=
ch
>> > > > > >     will handle non-MTU ones.
>> > > > > >
>> > > > > >     Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
>> > > > > >     Signed-off-by: Steve French <stfrench@microsoft.com>
>> > > > > >
>> > > > > >
>> > > > > > ---------- Forwarded message ---------
>> > > > > > From: Steve French <smfrench@gmail.com>
>> > > > > > Date: Sat, Feb 16, 2019 at 6:46 PM
>> > > > > > Subject: Re: xfstests and current cifs for-next patch set
>> > > > > > To: CIFS <linux-cifs@vger.kernel.org>
>> > > > > >
>> > > > > >
>> > > > > > Narrowed the xfstest 310 possible regression in current for-ne=
xt down
>> > > > > > to three patches, rerunning with this one of the three added (=
see
>> > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/b=
uilders/4/builds/85)
>> > > > > >
>> > > > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
>> > > > > > Date:   Wed Jan 16 11:12:41 2019 -0800
>> > > > > >
>> > > > > >     CIFS: Respect reconnect in MTU credits calculations
>> > > > > >
>> > > > > > On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@gmail.c=
om> wrote:
>> > > > > > >
>> > > > > > > With 5.0-rc5 and current for-next (29 paches) two tests 310 =
(read and
>> > > > > > > readdir simultaneously) and 422 (delayed allocation stat, nu=
mber of
>> > > > > > > blocks) fail I see this in the azure test bucket in the buil=
dbot).
>> > > > > > > see this run: http://smb3-test-rhel-75.southcentralus.clouda=
pp.azure.com/#/builders/4/builds/80
>> > > > > > >
>> > > > > > > These don't fail when I select only the first 8 cifs fixes i=
n for-next
>> > > > > > > ontop of 5.0-rc5.  See
>> > > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#=
/builders/4/builds/82
>> > > > > > >  so am trying to narrow it down.    This run (in progress)
>> > > > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#=
/builders/4/builds/83
>> > > > > > > has the first 19 (of the 29) cifs patches (ontop of 5.0-rc5 =
mainline
>> > > > > > > as with the runs above) so we can bisect which commit causes=
 the
>> > > > > > > problem with tests 310 and 422.
>> > > > > > >
>> > > > > > > This seems unrelated to the problem I see in slightly more c=
urrent
>> > > > > > > mainline (that we can see with no cifs changes) in xfstest 4=
22 that
>> > > > > > > was introduced with 5.0-rc6.
>> > > > > > >
>> > > > > > > Let me know if others (or other scenario problems) see the t=
ests
>> > > > > > > 310/422 failure.
>> > > > > > >
>> > > > > > > --
>> > > > > > > Thanks,
>> > > > > > >
>> > > > > > > Steve
>> > > > > >
>> > > > > >
>> > > > > >
>> > > > > > --
>> > > > > > Thanks,
>> > > > > >
>> > > > > > Steve
>> > > > > >
>> > > > > >
>> > > > > > --
>> > > > > > Thanks,
>> > > > > >
>> > > > > > Steve
>> > > > >
>> > > > >
>> > > > >
>> > > > > --
>> > > > > Thanks,
>> > > > >
>> > > > > Steve
>> > > >
>> > > >
>> > > >
>> > > > --
>> > > > Thanks,
>> > > >
>> > > > Steve
>> > >
>> > >
>> > >
>> > > --
>> > > Thanks,
>> > >
>> > > Steve
