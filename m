Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F8FC46467
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 09:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjAKJd6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 04:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjAKJdX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 04:33:23 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A583BB4D
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 01:30:59 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id bx6so15429698ljb.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 01:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8nZU2O1opp1Y0ZYZLTrpK33ewYVJs8VYYeva7yfr2Y=;
        b=qj9XCnesmMQ616M3eKtTdwVU/NFqQFVfd3iaS/yuEddjnMjs0lY1F4nlGKoZgSBugP
         S1y9UP0rrPxQMhPf3wsAgQcM09WPkgr0qFGAw/SddsD4diPZpIZ8wqRPhtr83YzTCBxV
         /Ur6xhmus2kS6M4IXsZNZ18Z2Uw3vUCeBpfC8vOpemKUFZ6hNV+Em9hqB4J+CR71tNML
         im7LMHGSrWTvObUnu+nwbznkYwmr0Z5p5CYPT/QD3KQOARAk2cM0Hfvx34WSpmx0fT7o
         9wGCqf6cpnGOhbczBExkgqZ6kb2H8Nin8fFiHEvCc1Ql2bk/cgEfE/znp9D454lp7wiF
         rX3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8nZU2O1opp1Y0ZYZLTrpK33ewYVJs8VYYeva7yfr2Y=;
        b=DW8Zf1aTHuKz2/+MUsNVIKEjNWkJDU8HFx3aBBC4XOFWdz4jyyvCqM0GV23R4LpZ7Y
         T+Ep7C1Eiyy98ExKbbLR9rgz57c8nBRL6a+URjca6n7Bbu4PCoPJ1RyiHeGZc94hQLMo
         y3YWz1o1doL+Tg3FQ7eoPnXjTrveBJHHfwXGOLB6EzNIq+8IjbeyJfIAzTYSlk4IRcHK
         6g29iBTXsq0P43UuOPQcgJaM7K68FRX4mqO7UF59WQOxUYSmqFLEBNQ8Z2YSFG/9FA7b
         zjBsazPAAsngotvTd4ln4cmc9SMna5zlwBMEKQz+p0SAOu7+spU0nV6US3iGFzMSthdq
         ytHg==
X-Gm-Message-State: AFqh2kr4mxQTC4abp/fUQW10eT/YyZMp+7E4xGGHioaO3aOPCrzhj/Pd
        59c5l7p5coHwYoZChYYL2pu2+170NOys9Gv44SE=
X-Google-Smtp-Source: AMrXdXu20kIusaMF2VrB/dpA/VnnR5R1y2gDort6S7OfbFK92OOARNOoLcc/vovJxg2zuLaWZ6iJuHXi54UxcSJp3U8=
X-Received: by 2002:a05:651c:38b:b0:27f:d04d:d2d4 with SMTP id
 e11-20020a05651c038b00b0027fd04dd2d4mr1883274ljp.182.1673429457828; Wed, 11
 Jan 2023 01:30:57 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
 <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com> <87h6wywamj.fsf@cjr.nz>
In-Reply-To: <87h6wywamj.fsf@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 11 Jan 2023 15:00:46 +0530
Message-ID: <CANT5p=rW24pWN5d_fLJ7B+rZHU1PZpy2Us_6F4y3CTZe8AeFCQ@mail.gmail.com>
Subject: Re: Connection sharing in SMB multichannel
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jan 10, 2023 at 11:11 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Aur=C3=A9lien Aptel <aurelien.aptel@gmail.com> writes:
>
> > Hey Shyam,
> >
> > I remember thinking that channels should be part of the server too
> > when I started working on this but switched it up to session as I kept
> > working on it and finding it was the right choice.
> > I don't remember all the details so my comments will be a bit vague.
> >
> > On Tue, Jan 10, 2023 at 10:16 AM Shyam Prasad N <nspmangalore@gmail.com=
> wrote:
> >> 1.
> >> The way connections are organized today, the connections of primary
> >> channels of sessions can be shared among different sessions and their
> >> channels. However, connections to secondary channels are not shared.
> >> i.e. created with nosharesock.
> >> Is there a reason why we have it that way?
> >> We could have a pool of connections for a particular server. When new
> >> channels are to be created for a session, we could simply pick
> >> connections from this pool.
> >> Another approach could be not to share sockets for any of the channels
> >> of multichannel mounts. This way, multichannel would implicitly mean
> >> nosharesock. Assuming that multichannel is being used for performance
> >> reasons, this would actually make a lot of sense. Each channel would
> >> create new connection to the server, and take advantage of number of
> >> interfaces and RSS capabilities of server interfaces.
> >> I'm planning to take the latter approach for now, since it's easier.
> >> Please let me know about your opinions on this.
> >
> > First, in the abstract models, Channels are kept in the Session object.
> > https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/8=
174c219-2224-4009-b96a-06d84eccb3ae
> >
> > Channels and sessions are intertwined. Channels signing keys depend on
> > the session it is connected to (See "3.2.5.3.1 Handling a New
> > Authentication" and "3.2.5.3.3 Handling Session Binding").
> > Think carefully on what should be done on disconnect/reconnect.
> > Especially if the channel is shared with multiple sessions.
> >
> > Problem with the pool approach is mount options might require
> > different connections so sharing is not so easy. And reconnecting
> > might involve different fallbacks (dfs) for different sessions.
>
> AFAICT, for a mount with N channels, whether DFS or not, there is a
> wrong assumption that after failover, there will be N channels to be
> reconnected.
>
> There might be a case where the administrator disabled multichannel in
> server settings, or decreased the number of available adapters, or if
> the new DFS target doesn't support multichannel or has fewer channels.
> In this case, cifs.ko would have stale channels trying to reconnect
> indefinitely.
>
> Please correct me if I missed something.

Hi Paulo,

Your analysis is correct. We don't support scaling down the channel
count. Again, this was always the case.
I did have some changes planned to deal with that scenario too.
Haven't managed to implement it though.

--=20
Regards,
Shyam
