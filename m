Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5E0C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 21:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D12E20880
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 21:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pDAhBFGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfBTVSR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 16:18:17 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:34242 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfBTVSQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 16:18:16 -0500
Received: by mail-pf1-f173.google.com with SMTP id u9so5289560pfn.1
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 13:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=0OIFi+M8xhTE99WcNurHSQy8uXKLDHjKMPW6YWJmN+A=;
        b=pDAhBFGNR2FUf/RSaFxHN06EDCPHb8YMJhFBxiA9OvwWR3R+8QmJdjeuPDN8i9EVEb
         1XUCGHx+XQr2gPoemepYYo8AUrhmfyMhRH+hkdtu1fm2Qyjk+9CI9Q7xejkxuyf1rag9
         4szUtektlUfVrdeZDYYI4puI0mauD2JNS6UCV27co1QJi2w4mDbNkt7FJjEtaohjebfa
         mrqjMXVIqWg0NUM634E09X3olR2fNr4OYdm/1RlAu48B2G4ZgQQc+qPcb6OsmnPgzuT6
         Zk5JYczpeKpyYsp/JA6bS5rmW/yHqNhT9pChSF2mdFSkq6A8byl1Ig3IvFdX8rmIgGRm
         PQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=0OIFi+M8xhTE99WcNurHSQy8uXKLDHjKMPW6YWJmN+A=;
        b=gnj3HsrN5Hsat37H24jm/OXiGB7a7AA/dTvx551GxRXROo1JfS5vO89akzJNN3Bc7f
         gujCyOeULeuVlRkOntYjxtCXV6G9dJEeXechD1xvlJM4uNrVj5jL7zLKRaHgmzuTP5Qf
         xe9o8uXgxW+VVUTVhMTBHlSrkT4f7ZwlZYk7fqSLcqKdHV8JFziD2QH7lk+xbmzPdAxP
         peG3jEUo5/WYxSjAX+a9HLPYgUEDbPJVCpQe3CCZC/wqMlUkjqlcQ/DNVPlSKxydyj+T
         lv32qUxbcdtaFR9OxJD4nS8zL1An90SSQAZWUNRD6oPYJ/Q4fTrB7luq5AvATNd2MOWg
         kF1w==
X-Gm-Message-State: AHQUAuZACjKv5VGKY8RdWg4wH0sN6PxpkzuKn+m+got5Bwbr5uW2kjS9
        PfA4l4y+5cNEdQmmOubZEvW4FLdUOR4TvghitnA=
X-Google-Smtp-Source: AHgI3IawhUFx6mu1KtdnRCGeQ9xUOAUreGcy1IkT1PQbj+zjkpsO/5qe8Z2kJy5p8LhDh824jLsdeMIZtAeD7JT7GSg=
X-Received: by 2002:a63:2312:: with SMTP id j18mr31228781pgj.344.1550697495505;
 Wed, 20 Feb 2019 13:18:15 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
 <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
 <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com>
 <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com> <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com>
In-Reply-To: <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Feb 2019 15:18:04 -0600
Message-ID: <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like Pavel's latest fix (unrelated to credits it turns out, the
problem in this case was skipping a mid) does fix xfstest 310.   Azure
test bucket passes, no reconnects that I spotted:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/94

Running cifs-testing buildbot bucket now.

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/134

On Sun, Feb 17, 2019 at 1:30 PM Steve French <smfrench@gmail.com> wrote:
>
> Retrying the same test run it worked.   Rerunning the same set of
> patches but this time with larger (cifs-testing) collection of tests
> on the buildbot
>
> On Sat, Feb 16, 2019 at 10:38 PM Steve French <smfrench@gmail.com> wrote:
> >
> > The test (310 and subsequent) seemed to start failing with this in dmesg:
> >
> > [root@fedora29 ~]# dmesg
> > [ 2969.016552] CIFS VFS: Cancelling wait for mid 29640 cmd: 14
> > [ 2979.449426] CIFS VFS: disabling echoes and oplocks
> > [ 2999.109655] CIFS VFS: Cancelling wait for mid 1494 cmd: 6
> > [ 3225.207488] CIFS VFS: Server
> > linuxsmb3testshares.file.core.windows.net has not responded in 120
> > seconds. Reconnecting...
> >
> > On Sat, Feb 16, 2019 at 8:30 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > So (unless there is a random factor involved) - I narrowed it down to this patch
> > >
> > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > >
> > >     CIFS: Respect reconnect in MTU credits calculations
> > >
> > >     Every time after a session reconnect we don't need to account for
> > >     credits obtained in previous sessions. Introduce new struct cifs_credits
> > >     which contains both credits value and reconnect instance of the
> > >     time those credits were taken. Modify a routine that add credits
> > >     back to handle the reconnect instance by assuming zero credits
> > >     if the reconnect happened after the credits were obtained and
> > >     before we decided to add them back due to some errors during sending.
> > >
> > >     This patch fixes the MTU credits cases. The subsequent patch
> > >     will handle non-MTU ones.
> > >
> > >     Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> > >     Signed-off-by: Steve French <stfrench@microsoft.com>
> > >
> > >
> > > ---------- Forwarded message ---------
> > > From: Steve French <smfrench@gmail.com>
> > > Date: Sat, Feb 16, 2019 at 6:46 PM
> > > Subject: Re: xfstests and current cifs for-next patch set
> > > To: CIFS <linux-cifs@vger.kernel.org>
> > >
> > >
> > > Narrowed the xfstest 310 possible regression in current for-next down
> > > to three patches, rerunning with this one of the three added (see
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/85)
> > >
> > > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > > Date:   Wed Jan 16 11:12:41 2019 -0800
> > >
> > >     CIFS: Respect reconnect in MTU credits calculations
> > >
> > > On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > With 5.0-rc5 and current for-next (29 paches) two tests 310 (read and
> > > > readdir simultaneously) and 422 (delayed allocation stat, number of
> > > > blocks) fail I see this in the azure test bucket in the buildbot).
> > > > see this run: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/80
> > > >
> > > > These don't fail when I select only the first 8 cifs fixes in for-next
> > > > ontop of 5.0-rc5.  See
> > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/82
> > > >  so am trying to narrow it down.    This run (in progress)
> > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/83
> > > > has the first 19 (of the 29) cifs patches (ontop of 5.0-rc5 mainline
> > > > as with the runs above) so we can bisect which commit causes the
> > > > problem with tests 310 and 422.
> > > >
> > > > This seems unrelated to the problem I see in slightly more current
> > > > mainline (that we can see with no cifs changes) in xfstest 422 that
> > > > was introduced with 5.0-rc6.
> > > >
> > > > Let me know if others (or other scenario problems) see the tests
> > > > 310/422 failure.
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



-- 
Thanks,

Steve
