Return-Path: <SRS0=whkR=QY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E693C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Feb 2019 19:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2EC4217FA
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Feb 2019 19:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r3KyzSph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfBQTal (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Feb 2019 14:30:41 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:39928 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfBQTal (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Feb 2019 14:30:41 -0500
Received: by mail-pl1-f176.google.com with SMTP id 101so7610398pld.6
        for <linux-cifs@vger.kernel.org>; Sun, 17 Feb 2019 11:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LxxDj+++19MzTucnawzETYN7Vz5V7JC6INOcS1vw0gc=;
        b=r3KyzSph8X7TxYTijAn03ZkQV/wJTihcFre8r+HEDY4kET89oTfyAKuGtzoXMbc5te
         zAZRXX8Vec1IPwhXnkt5QTdPaQlbOZPFY9R8Q9sw9FogA3Hgsdj04bF9IIAzbAPiiBV/
         nlv6U6p4W77k3g3zjncLZXWYwZej95mFSUFle0IF1gQkuyUTdwegIZRXbO3rVpvclQs/
         NHpd81nVdI4lStMECwG89Mhe3xbKYXRmRH25l3Jv/v/c33zdUUSjMJrRwRzqQxivPAXI
         bC+g+u6Q/i155ZiI6OsjHd2EUuo0DSSrHityjUd7pA+3QKEP6B5oqgABFHikQebVGv+w
         h/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=LxxDj+++19MzTucnawzETYN7Vz5V7JC6INOcS1vw0gc=;
        b=oMpnjkjZCFlmjhEfjq/IpPVbJiv5z9TRKs83whLxEq5WTUECUWr7GiAJuxUwKHCvZw
         uV9mKEgNGMEL/ecVIxxxeIkqjEYxFtJ5blN+BzLosJiQgtUFMxiKJghzSF5cn7TK+OvM
         vziP65kjC6Mm8u90WndXhkFj2oQvzKNuvpJMhJSNcbHh6SYTwzYLawj8dhaXlBjdswzy
         8BfM5f6CULptuz+IgRUJkGHhGHh4IMLUAyQMZFA8vfHMh0x5xX5TBDCUfIk/0Q5kicIB
         7WSYiBknduP2dV6LjbixHtXCw361wvJTYUV21fDKOsoYb2g75mU+peJL4jFx0mbbr0RH
         9PxQ==
X-Gm-Message-State: AHQUAuY4/1BjJQkpd+gQYGiIpkwVnuNTUJYXeFtI/5lcWhs7l8XgEcgy
        4RYmFmzg3SY4hBTW2n2OZIHqA83H2J7+G6B5+RM=
X-Google-Smtp-Source: AHgI3IbK8E6gdy3jBD4DZPJnwkfelul2bBxoFjfIYi2gkbKPo9OaRqeEC1acfUqMNEkHncj5NuIGKri13y3zgU2I3Uw=
X-Received: by 2002:a17:902:468:: with SMTP id 95mr20511812ple.73.1550431840389;
 Sun, 17 Feb 2019 11:30:40 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
 <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
 <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com> <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com>
In-Reply-To: <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 17 Feb 2019 13:30:29 -0600
Message-ID: <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com>
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

Retrying the same test run it worked.   Rerunning the same set of
patches but this time with larger (cifs-testing) collection of tests
on the buildbot

On Sat, Feb 16, 2019 at 10:38 PM Steve French <smfrench@gmail.com> wrote:
>
> The test (310 and subsequent) seemed to start failing with this in dmesg:
>
> [root@fedora29 ~]# dmesg
> [ 2969.016552] CIFS VFS: Cancelling wait for mid 29640 cmd: 14
> [ 2979.449426] CIFS VFS: disabling echoes and oplocks
> [ 2999.109655] CIFS VFS: Cancelling wait for mid 1494 cmd: 6
> [ 3225.207488] CIFS VFS: Server
> linuxsmb3testshares.file.core.windows.net has not responded in 120
> seconds. Reconnecting...
>
> On Sat, Feb 16, 2019 at 8:30 PM Steve French <smfrench@gmail.com> wrote:
> >
> > So (unless there is a random factor involved) - I narrowed it down to this patch
> >
> > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > Date:   Wed Jan 16 11:12:41 2019 -0800
> >
> >     CIFS: Respect reconnect in MTU credits calculations
> >
> >     Every time after a session reconnect we don't need to account for
> >     credits obtained in previous sessions. Introduce new struct cifs_credits
> >     which contains both credits value and reconnect instance of the
> >     time those credits were taken. Modify a routine that add credits
> >     back to handle the reconnect instance by assuming zero credits
> >     if the reconnect happened after the credits were obtained and
> >     before we decided to add them back due to some errors during sending.
> >
> >     This patch fixes the MTU credits cases. The subsequent patch
> >     will handle non-MTU ones.
> >
> >     Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> >     Signed-off-by: Steve French <stfrench@microsoft.com>
> >
> >
> > ---------- Forwarded message ---------
> > From: Steve French <smfrench@gmail.com>
> > Date: Sat, Feb 16, 2019 at 6:46 PM
> > Subject: Re: xfstests and current cifs for-next patch set
> > To: CIFS <linux-cifs@vger.kernel.org>
> >
> >
> > Narrowed the xfstest 310 possible regression in current for-next down
> > to three patches, rerunning with this one of the three added (see
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/85)
> >
> > Author: Pavel Shilovsky <pshilov@microsoft.com>
> > Date:   Wed Jan 16 11:12:41 2019 -0800
> >
> >     CIFS: Respect reconnect in MTU credits calculations
> >
> > On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > With 5.0-rc5 and current for-next (29 paches) two tests 310 (read and
> > > readdir simultaneously) and 422 (delayed allocation stat, number of
> > > blocks) fail I see this in the azure test bucket in the buildbot).
> > > see this run: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/80
> > >
> > > These don't fail when I select only the first 8 cifs fixes in for-next
> > > ontop of 5.0-rc5.  See
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/82
> > >  so am trying to narrow it down.    This run (in progress)
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/83
> > > has the first 19 (of the 29) cifs patches (ontop of 5.0-rc5 mainline
> > > as with the runs above) so we can bisect which commit causes the
> > > problem with tests 310 and 422.
> > >
> > > This seems unrelated to the problem I see in slightly more current
> > > mainline (that we can see with no cifs changes) in xfstest 422 that
> > > was introduced with 5.0-rc6.
> > >
> > > Let me know if others (or other scenario problems) see the tests
> > > 310/422 failure.
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
