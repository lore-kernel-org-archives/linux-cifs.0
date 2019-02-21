Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEEBC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 00:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5294D20880
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 00:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfBUAJw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 19:09:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfBUAJw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Feb 2019 19:09:52 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 02773308125D;
        Thu, 21 Feb 2019 00:09:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD08760856;
        Thu, 21 Feb 2019 00:09:51 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 953514A460;
        Thu, 21 Feb 2019 00:09:51 +0000 (UTC)
Date:   Wed, 20 Feb 2019 19:09:51 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Message-ID: <1014205314.2917941.1550707791215.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com>
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com> <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com> <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com> <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com> <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com> <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com> <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.64.54.96, 10.4.195.18]
Thread-Topic: xfstests and current cifs for-next patch set
Thread-Index: UgF1U6hld4qlS1YOlaGOdl2ZLzApQw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 21 Feb 2019 00:09:52 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I ran a git bisect and the performance drop came with commit d3de48233978524514d3b605ad55bb21d1ecd706


----- Original Message -----
From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
To: "Steve French" <smfrench@gmail.com>
Cc: "Pavel Shilovsky" <piastryyy@gmail.com>, "Aurélien Aptel" <aaptel@suse.com>, "CIFS" <linux-cifs@vger.kernel.org>
Sent: Thursday, 21 February, 2019 8:47:44 AM
Subject: Re: xfstests and current cifs for-next patch set

generic/013 and generic/014 failed with timeout.  These tests used to
take several minutes.

Testing locally,    generic/013 is successful but it takes almost
three times longer than it used to just a week ago.

On Thu, Feb 21, 2019 at 7:18 AM Steve French <smfrench@gmail.com> wrote:
>
> Looks like Pavel's latest fix (unrelated to credits it turns out, the
> problem in this case was skipping a mid) does fix xfstest 310.   Azure
> test bucket passes, no reconnects that I spotted:
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/94
>
> Running cifs-testing buildbot bucket now.
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/134
>
> On Sun, Feb 17, 2019 at 1:30 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Retrying the same test run it worked.   Rerunning the same set of
> > patches but this time with larger (cifs-testing) collection of tests
> > on the buildbot
> >
> > On Sat, Feb 16, 2019 at 10:38 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > The test (310 and subsequent) seemed to start failing with this in dmesg:
> > >
> > > [root@fedora29 ~]# dmesg
> > > [ 2969.016552] CIFS VFS: Cancelling wait for mid 29640 cmd: 14
> > > [ 2979.449426] CIFS VFS: disabling echoes and oplocks
> > > [ 2999.109655] CIFS VFS: Cancelling wait for mid 1494 cmd: 6
> > > [ 3225.207488] CIFS VFS: Server
> > > linuxsmb3testshares.file.core.windows.net has not responded in 120
> > > seconds. Reconnecting...
> > >
> > > On Sat, Feb 16, 2019 at 8:30 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > So (unless there is a random factor involved) - I narrowed it down to this patch
> > > >
> > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > > >
> > > >     CIFS: Respect reconnect in MTU credits calculations
> > > >
> > > >     Every time after a session reconnect we don't need to account for
> > > >     credits obtained in previous sessions. Introduce new struct cifs_credits
> > > >     which contains both credits value and reconnect instance of the
> > > >     time those credits were taken. Modify a routine that add credits
> > > >     back to handle the reconnect instance by assuming zero credits
> > > >     if the reconnect happened after the credits were obtained and
> > > >     before we decided to add them back due to some errors during sending.
> > > >
> > > >     This patch fixes the MTU credits cases. The subsequent patch
> > > >     will handle non-MTU ones.
> > > >
> > > >     Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > >     Signed-off-by: Steve French <stfrench@microsoft.com>
> > > >
> > > >
> > > > ---------- Forwarded message ---------
> > > > From: Steve French <smfrench@gmail.com>
> > > > Date: Sat, Feb 16, 2019 at 6:46 PM
> > > > Subject: Re: xfstests and current cifs for-next patch set
> > > > To: CIFS <linux-cifs@vger.kernel.org>
> > > >
> > > >
> > > > Narrowed the xfstest 310 possible regression in current for-next down
> > > > to three patches, rerunning with this one of the three added (see
> > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/85)
> > > >
> > > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > > >
> > > >     CIFS: Respect reconnect in MTU credits calculations
> > > >
> > > > On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@gmail.com> wrote:
> > > > >
> > > > > With 5.0-rc5 and current for-next (29 paches) two tests 310 (read and
> > > > > readdir simultaneously) and 422 (delayed allocation stat, number of
> > > > > blocks) fail I see this in the azure test bucket in the buildbot).
> > > > > see this run: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/80
> > > > >
> > > > > These don't fail when I select only the first 8 cifs fixes in for-next
> > > > > ontop of 5.0-rc5.  See
> > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/82
> > > > >  so am trying to narrow it down.    This run (in progress)
> > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/83
> > > > > has the first 19 (of the 29) cifs patches (ontop of 5.0-rc5 mainline
> > > > > as with the runs above) so we can bisect which commit causes the
> > > > > problem with tests 310 and 422.
> > > > >
> > > > > This seems unrelated to the problem I see in slightly more current
> > > > > mainline (that we can see with no cifs changes) in xfstest 422 that
> > > > > was introduced with 5.0-rc6.
> > > > >
> > > > > Let me know if others (or other scenario problems) see the tests
> > > > > 310/422 failure.
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
>
>
>
> --
> Thanks,
>
> Steve
