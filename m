Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F2BC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 22:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58DC32086C
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 22:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iu5ppdfn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbfBTWr5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 17:47:57 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:33282 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfBTWr5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 17:47:57 -0500
Received: by mail-qt1-f171.google.com with SMTP id z39so29389797qtz.0
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 14:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUHcPc3N6RZxbNqoBTOQd1eDisvS4wCn0DxA78vWnb0=;
        b=iu5ppdfnC41nzZt8n08Xbe+X9qPydhChxXy9g76crVIaP2vd0MtJtLt/PWJYuXeCOa
         jeeA/ZRkWYKg12fMWw+JSYQp9KZdCpjvQPI34KdDn2h9WuRjAF2gGXH2gdtcbxj/lWFF
         DpZXRqirjECulzbPbjkYItPnbgjM5t7m/+3EOLju2sfluikHJuxGKvvFFWZfckTiSAAU
         G2rD8YhYy+Iw41ijwY1jLSsxN4zk3ZPYhctFlq8xQ6YyCwucdHjl2oRDse9ZaG2U8vZ2
         FGAvM+ST2y003ctnJ3hxE/b/0KFm8zt9+OASwm6Bc6JnFseGUKpDK1DfMAPfYgGQF5ZW
         DYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUHcPc3N6RZxbNqoBTOQd1eDisvS4wCn0DxA78vWnb0=;
        b=iH8nTO0qNUlXgUNxJ1vcIf5uQiMMgOvP6ey8kZoHQS+nuwQ7TTChcRYpv2NRt4EmlL
         yUEeRhGFDS01mOQg2AZhTqsyssrObWWWbjLugxBnbU6qk14/f/LOqeoeXGlDBjbd5YYN
         s3s7+hRou9vBgjuLy0S3/xMdhR+UER3teK87VEbMflacgA7sz5iU3LZedkIhKF4PGxVv
         LugLGtm2Zp44nvgaUD1eXmY/wPUeFO+nucDUW2bUVXNgaHCpKPIZvPazP8U09k8lf1B+
         oJ3Z+ys7Ck6n+QFSQyQ4sRYuwNacN5A4kqdCco7C33bnkxOnstVby1sDGuuU+tuWlR5+
         xPPQ==
X-Gm-Message-State: AHQUAuara4dcGcNkcCrHOpgPYqcRltQw9VkKhNYH8CHQhZ1yP59tgYgA
        cDFjuRHi1S1ZKSHT79qGS6GiobP2FEmvdaG99f5u6w==
X-Google-Smtp-Source: AHgI3IZRF+YOzlR/zHqPqHzBTQnu5j07oO/Z3DqchxnfD3qrp3lfNPyxZ17YDZnIjCTugDelHBLTub0pH+hZsM8J1nQ=
X-Received: by 2002:ac8:25d9:: with SMTP id f25mr29716105qtf.156.1550702876048;
 Wed, 20 Feb 2019 14:47:56 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
 <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
 <CAH2r5msHUwbDmftJMHNRrqYMtuf9xdC7qJh+PksgavPvjqVQVg@mail.gmail.com>
 <CAH2r5mv10VEUntZcYW91eSycdNBobrJYF0pMG4pMPqJm=6UAqg@mail.gmail.com>
 <CAH2r5muzb8TFBqp-hk=9421pr20nkcafBmbeugCmz1fSJgaDxg@mail.gmail.com> <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com>
In-Reply-To: <CAH2r5mt_UaGCpx__CLyJBYZNtZTt=zASixrJiiJ7xe-VYu4UCw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 21 Feb 2019 08:47:44 +1000
Message-ID: <CAN05THRDW-kQrsBfeGN9DN4Mg2T=Kz3JuCMZEZPVftsdqR9m=Q@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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
