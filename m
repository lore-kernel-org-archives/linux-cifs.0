Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BB5C46467
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 17:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbjAJRlf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 12:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbjAJRlY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 12:41:24 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70261DC
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 09:41:13 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4400E7FC04;
        Tue, 10 Jan 2023 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673372472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clprMD+Vf0+8vEQzbVxv5QSrSuD6qFZhCkmaveEDgZE=;
        b=a/8TjPv2DH0Wy1v7nd+ZdCRmL42IGIGIkjX5c0P/CaBRs4gpj8k47Jo7AoJO1oAWAQJ9G8
        ujZY37IfLhaasRiGveniAjxv2DLjpv9earZoo4WIxQEhAicim9FTL49JDdFbIc5o/2CpIM
        XhqhIMg+8I5A+MO8jUdeNZAVEdOLsYAuMtZjz2cyNoM1+CPF7AUGW/xV22NBNMTEWnJJ0n
        wbGUJHGRKWjv2LD0jsg8OZV1isPYDDdPGRLisdInQc6kkEhhOl4N6VC+F20pHs8rAXGgue
        wpTuFkKYM8sOQbVCuuIiZwzBgV+iEmWSF/G4YivJG1F1Skn3xRZPs4Q+Jlu60g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aurelien.aptel@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Connection sharing in SMB multichannel
In-Reply-To: <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com>
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
 <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com>
Date:   Tue, 10 Jan 2023 14:41:08 -0300
Message-ID: <87h6wywamj.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aurelien.aptel@gmail.com> writes:

> Hey Shyam,
>
> I remember thinking that channels should be part of the server too
> when I started working on this but switched it up to session as I kept
> working on it and finding it was the right choice.
> I don't remember all the details so my comments will be a bit vague.
>
> On Tue, Jan 10, 2023 at 10:16 AM Shyam Prasad N <nspmangalore@gmail.com> =
wrote:
>> 1.
>> The way connections are organized today, the connections of primary
>> channels of sessions can be shared among different sessions and their
>> channels. However, connections to secondary channels are not shared.
>> i.e. created with nosharesock.
>> Is there a reason why we have it that way?
>> We could have a pool of connections for a particular server. When new
>> channels are to be created for a session, we could simply pick
>> connections from this pool.
>> Another approach could be not to share sockets for any of the channels
>> of multichannel mounts. This way, multichannel would implicitly mean
>> nosharesock. Assuming that multichannel is being used for performance
>> reasons, this would actually make a lot of sense. Each channel would
>> create new connection to the server, and take advantage of number of
>> interfaces and RSS capabilities of server interfaces.
>> I'm planning to take the latter approach for now, since it's easier.
>> Please let me know about your opinions on this.
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
>
> Problem with the pool approach is mount options might require
> different connections so sharing is not so easy. And reconnecting
> might involve different fallbacks (dfs) for different sessions.

AFAICT, for a mount with N channels, whether DFS or not, there is a
wrong assumption that after failover, there will be N channels to be
reconnected.

There might be a case where the administrator disabled multichannel in
server settings, or decreased the number of available adapters, or if
the new DFS target doesn't support multichannel or has fewer channels.
In this case, cifs.ko would have stale channels trying to reconnect
indefinitely.

Please correct me if I missed something.
