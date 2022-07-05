Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 081C8CCA480
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jul 2022 16:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiGEQDH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jul 2022 12:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiGEQDG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jul 2022 12:03:06 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC78D18B35
        for <linux-cifs@vger.kernel.org>; Tue,  5 Jul 2022 09:03:04 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id q28so12358362vsp.7
        for <linux-cifs@vger.kernel.org>; Tue, 05 Jul 2022 09:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jUJYT0TlOykEnOwFFaMmGD4MEWuzPtpDbkiNN9l/4wM=;
        b=Lu79dZZ/jReS5Izum0xy1b3NxdKe1HwDrjHJ/lMdZEyRpD42FyAr6H/2dwcSkLmdba
         bG94E80SPCzOqAIsakUHMay8LC9aLrGOJvmNlRa4nHjQFibotBVVoS25qax9hfmqUasx
         heE6MZGp3w/Atlf/3dIN2th6dwQP6XnVMtWSk6D7P/TsHm4KjFKOamEc2SZV5JB8Nh5Q
         znDdL/U0/Hl2I0OPo7Q2RGg7oNbNsb4s6LdAUXKhI1lMEdw9htoRdq5DMdP7XUE6qWkF
         UpxnO3/CcZ42qLF+6Nb0uKSWEgreUWpgryhYDVVdcxcUhZsuAB5Ef7TF8/zqm3wcND+f
         hmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jUJYT0TlOykEnOwFFaMmGD4MEWuzPtpDbkiNN9l/4wM=;
        b=If28X/uIaECRlKV28sdh9BILM2NpveSW0ULTohNLA8hyYDTag87mgVrfkdy3EFUvh+
         AQY/n28heQvznayzQD3PZjZ0lreGtX8RFNsDBRcIXi1p1IJZOYH5ufJSlhQkLiu8qOwx
         /N8eF/ztu+ujO4/eJuPHk8FBZZkncXPAEI3VvMD0DqTzLNiPiSHQBlpxDwkmjcW6J/V1
         SnmwaYWUm3mBVvmu97xLFumRVgQm9C6UJiBLiA9Gyv72dC8qVMF3O80EE0tAS4fPXOvm
         LO0GcGocmBCzzFQ5BQTLxeuNZjtcXhDmJe6EmrL5xE22EHeu47b++/6mCso4zEQTBa8F
         BnKQ==
X-Gm-Message-State: AJIora9cC7Qczqzvbo2psZa+UNShQxHdHBfMlzAV2+fKfrcKULFMx7rc
        bGwKLqx5lT+Xs0+yKm+cm8q9tkhYn8FYgjo6Kyg=
X-Google-Smtp-Source: AGRyM1vzSqhJJn65pCwI6sy/QKqLYbeH+7qG6I6d7CJ3/EaCHE4NJBbFUbVvDwHY3KohxhPG0Ym35h3zHMjno/1MzdU=
X-Received: by 2002:a67:c189:0:b0:356:c545:436d with SMTP id
 h9-20020a67c189000000b00356c545436dmr5733571vsj.29.1657036979241; Tue, 05 Jul
 2022 09:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
 <874k1m3b56.fsf@cjr.nz> <CANT5p=rRTWpBR6MKiXrMtH0r_PD_jKyLhUhM_Of_oev=7rybDA@mail.gmail.com>
 <CANT5p=rw=JamyDwYby1VVgMXAANMCou_aMhcw0vB48gggDWJQQ@mail.gmail.com>
 <CANT5p=q6xyaaqqNizp1HsXhLFTnwezJ267SJDqr5WwyG8KZO+g@mail.gmail.com>
 <CAH2r5mt6A616063ZigfPBBKFjsV5AhNG3ifk-1HQOcgwb_i0kg@mail.gmail.com> <CANT5p=okGAJCow=+BLGTHf3BqhmHijA1FK-XNVuLNHVRVhficA@mail.gmail.com>
In-Reply-To: <CANT5p=okGAJCow=+BLGTHf3BqhmHijA1FK-XNVuLNHVRVhficA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Jul 2022 11:02:48 -0500
Message-ID: <CAH2r5muQJECP52PGt5h01A-Pj+woqx_7PmRcvos3As_9UFBrTA@mail.gmail.com>
Subject: Re: Multichannel fixes
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Tue, Jul 5, 2022 at 6:28 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Fri, Jun 24, 2022 at 8:14 PM Steve French <smfrench@gmail.com> wrote:
> >
> > FYI - the last one includes the fix for the lock ordering problem that
> > Coverity spotted.
> >
> > On Fri, Jun 24, 2022 at 9:43 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > On Mon, Jun 6, 2022 at 3:57 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > >
> > > > On Mon, Jun 6, 2022 at 11:12 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > > >
> > > > > Hi Paulo,
> > > > >
> > > > > Sorry for the late reply.
> > > > > Good point. Tested basic DFS mounts. I was facing setup issues while
> > > > > setting up DFS for failover.
> > > > > Steve will be running the buildbot DFS tests anyway, which will
> > > > > contain DFS failover.
> > > > >
> > > > > On Thu, May 19, 2022 at 12:45 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > > > > >
> > > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > > >
> > > > > > > This time, I've verified that it does not break the multiuser
> > > > > > > scenario. :)
> > > > > >
> > > > > > Thanks!  What about DFS failover scenario?  :-)
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Regards,
> > > > > Shyam
> > > >
> > > > More fixes for multichannel:
> > > >
> > > > [PATCH] cifs: populate empty hostnames for extra channels
> > > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/fb231a3e148e7537c899f4e145fc0dd876c2b195.patch
> > > >
> > > > [PATCH] cifs: change iface_list from array to sorted linked list
> > > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/94363021b50edb86813ae280526d7f33d6903703.patch
> > > >
> > > > [PATCH] cifs: during reconnect, update interface if necessary
> > > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7610df44d276634a51155e6314ee159b7618013f.patch
> > > >
> > > > [PATCH] cifs: periodically query network interfaces from server
> > > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7dad71410514232501f921a8c3ad389d3344fddb.patch
> > > >
> > > > First one is a fix for ensuring that reconnect does not resolve extra
> > > > channels to possibly wrong IP address.
> > > > Rest three enable periodic query of server interfaces. This is
> > > > important for Azure service, where the server can change the IP
> > > > addresses of secondary channels.
> > > >
> > > > Reviews will be appreciated.
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> > >
> > > Updated the last set of patches to the below set after fixing some
> > > coverity warnings.
> > >
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/37d488b3d38c04f9f4caf1fab2b58301f0c20227.patch
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a21e72b2a9599482739884329523ed91cfabf8db.patch
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ad8f403ac707cf326371d1361ef5880d89b9bbe6.patch
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/85ede3abb8348d3b9b5a2548c9773ed0fec0f157.patch
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/8577d17e605634f297e1be71f602c8027737fefc.patch
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Hi all,
>
> Found a race condition between the delayed workers when there's a
> failure to add a channel to a session.
> This was causing occasional failures on the buildbot due to a warning
> being logged.
>
> Fixed it with the below patch:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ff9ba549b08b8a54bd951e74dae7a1e74f8e7db6.patch
>
> Please review the fix.
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
