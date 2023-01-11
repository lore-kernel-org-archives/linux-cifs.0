Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D89C5479D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 07:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjAKHfs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 02:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjAKHfr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 02:35:47 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B86FB25
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 23:35:46 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id y18so11598592ljk.11
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 23:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nm6lUEzJW4La15K9SyyF6SP1OjFrmgyG4atDkNdInCo=;
        b=ntWjXZOw7+4miBgxP/5VaIwVMSMYWI0h+dXUAS8p2wZ3zlBgyoaMFdxySfloMI4BhL
         ayvv8D/CEC2SfOquGWCjDBrasIz2EZfswUGwE93Ho5tnkwdYN8qJLa/2x1m1pu8DCE87
         qx99MFffWeDKU7o1zu8sV/oYbrQOChYqwYc8EEibiPhSHfz4fIrdf9e0RBf3Si8fMLEK
         biA8MvXXcagAcmEUHf6Lch3oOyOiIUQ+lfxmUX1lhVSVBg6IxyvyT9WnI0BIMF/Lv/d7
         He4q3fzPbRROcbnGKimRhkNE+QTN60/PQls3DdS9QzZ5pXuijwml8sLZRkBSwzrzPvSN
         DnoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nm6lUEzJW4La15K9SyyF6SP1OjFrmgyG4atDkNdInCo=;
        b=Yxf6E7LzoSOJtBT3UFUrTr33Ph6F3ieVuZRtSoOTfvdF3S6H+NL9xYs+caiB7nkugM
         fmHpHWCTLtMgjwZqLZrCqxHWKetZA8wZnm3nCAmDmUo1heQCe5a1BDwsxz5dBObeXtjr
         FdvHA5g4P+GROin94ff6pQtYfHj0FuRkXeVbEQsy4wCLFGubww8EBgyQA3uzzbZBzZvI
         DgfVyZDa5XOUMZ91PfyTPCM4MiBPGbjsZ5k8GZczCYrhfiK8/+kvAzUHXA1hAsYdhy/O
         ZWqfTJd1eMHAnI2Pp1V6uQDHCTxaRoI/G5/inE8QU8D4A/oWqWXEoAXZBB+meuahgHlJ
         siQw==
X-Gm-Message-State: AFqh2kp2Ga+Avz7ntltjBUuahSedQTqd6Q/OT2nmzXkxn3zxvpQq0q+k
        CjKaEnKovXTZMm2jEHFVHVCyNWNlaJAI8GLHNu0=
X-Google-Smtp-Source: AMrXdXuW0PQkPmwrzrDVqIV9oQ0Zf0oKmLHXPGpym/J5eLvwuUKFzwQVCi1fPCWPJ9mD/Y3y3zRslRLX+nSrZqO2e68=
X-Received: by 2002:a05:651c:c5:b0:284:2fea:5266 with SMTP id
 5-20020a05651c00c500b002842fea5266mr804340ljr.476.1673422544044; Tue, 10 Jan
 2023 23:35:44 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
 <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com>
In-Reply-To: <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 11 Jan 2023 13:05:32 +0530
Message-ID: <CANT5p=rEDkTsSin7y_VKZ=9T9V2tqNVXp2qM4MHnFQEJo8Sinw@mail.gmail.com>
Subject: Re: Connection sharing in SMB multichannel
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aur=C3=A9lien,

Thanks for the inputs.

On Tue, Jan 10, 2023 at 6:30 PM Aur=C3=A9lien Aptel <aurelien.aptel@gmail.c=
om> wrote:
>
> Hey Shyam,
>
> I remember thinking that channels should be part of the server too
> when I started working on this but switched it up to session as I kept
> working on it and finding it was the right choice.
> I don't remember all the details so my comments will be a bit vague.

I'm not proposing to move the channels to per-server here, but to move
the connections to per-server. Each channel is associated with a
connection.
I think our use of server and connection interchangeably is causing
this confusion. :)

>
> On Tue, Jan 10, 2023 at 10:16 AM Shyam Prasad N <nspmangalore@gmail.com> =
wrote:
> > 1.
> > The way connections are organized today, the connections of primary
> > channels of sessions can be shared among different sessions and their
> > channels. However, connections to secondary channels are not shared.
> > i.e. created with nosharesock.
> > Is there a reason why we have it that way?
> > We could have a pool of connections for a particular server. When new
> > channels are to be created for a session, we could simply pick
> > connections from this pool.
> > Another approach could be not to share sockets for any of the channels
> > of multichannel mounts. This way, multichannel would implicitly mean
> > nosharesock. Assuming that multichannel is being used for performance
> > reasons, this would actually make a lot of sense. Each channel would
> > create new connection to the server, and take advantage of number of
> > interfaces and RSS capabilities of server interfaces.
> > I'm planning to take the latter approach for now, since it's easier.
> > Please let me know about your opinions on this.
>
> First, in the abstract models, Channels are kept in the Session object.
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/817=
4c219-2224-4009-b96a-06d84eccb3ae
>
> Channels and sessions are intertwined. Channels signing keys depend on
> the session it is connected to (See "3.2.5.3.1 Handling a New
> Authentication" and "3.2.5.3.3 Handling Session Binding").
> Think carefully on what should be done on disconnect/reconnect.
> Especially if the channel is shared with multiple sessions.

That's a good point.
But that affects even other cases like multiuser mounts and cases
where a session shares a socket. Doesn't it?
I think we call cifs_reconnect very generously today. We should give
this another look, IMO.

>
> Problem with the pool approach is mount options might require
> different connections so sharing is not so easy. And reconnecting
> might involve different fallbacks (dfs) for different sessions.
>
> You should see the server struct as the "final destination". Once it's
> picked we know it's going there.
>
> > 2.
> > Today, the interface list for a server hangs off the session struct. Wh=
y?
> > Doesn't it make more sense to hang it off the server struct? With my
> > recent changes to query the interface list from the server
> > periodically, each tcon is querying this and keeping the results in
> > the session struct.
> > I plan to move this to the server struct too. And avoid having to
> > query this too many times unnecessarily. Please let me know if you see
> > a reason not to do this.
>
> It's more convenient to have the interface list at the same place as
> the channel list but it could be moved I suppose.
> In the abstract model it's in the server apparently.

Yeah. It makes more sense to keep it on per-server basis.

>
> > 4.
> > I also feel that the way an interface is selected today for
> > multichannel will not scale.
> > We keep selecting the fastest server interface, if it supports RSS.
> > IMO, we should be distributing the requests among the server
> > interfaces, based on the interface speed adveritsed.
>
> RSS means the interface can process packets in parallel queues. The
> problem is we don't know how many queues it has.
> I'm not sure you can find an optimal algorithm for all NIC
> vendor/driver combinations. Probably you need to do some tests with a
> bunch of different HW or find someone knowledgeable.
> From my small experience now at mellanox/nvidia I have yet to see less
> than 8 rx/combined queues. You can get/set the number with ethtool
> -l/-L.
> I've set the max channel connection to 16 at the time but I still
> don't know what large scale high-speed deployment of SMB look like.
> For what it's worth, in the NVMe-TCP tests I'm doing at the moment and
> the systems we use to test (fio reads with a 100gbs eth nic with 63 hw
> queues, 96 cores cpu on the host&target, reading from a null block
> target), we get diminishing returns around 24 parallel connections. I
> don't know how transferable this data point is.
>
> On that topic, for best performance, some possible future project
> could be to assign steering rules on the client to force each channel
> packet processing on different cpus and making sure the cpus are the
> same as the demultiplex thread (avoids context switches and
> contentions). See
> https://www.kernel.org/doc/Documentation/networking/scaling.txt
> (warning, not an easy read lol)

Interesting. I'm guessing that this is the "send side scaling" that's
mentioned here:
https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-=
server-2012-r2-and-2012/hh997036(v=3Dws.11)

>
> Cheers,



--=20
Regards,
Shyam
