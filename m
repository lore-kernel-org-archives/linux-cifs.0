Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74F5C678D4
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 19:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCBTm2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Mar 2023 14:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCBTm1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Mar 2023 14:42:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCCD12BD2
        for <linux-cifs@vger.kernel.org>; Thu,  2 Mar 2023 11:42:26 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u9so1571937edd.2
        for <linux-cifs@vger.kernel.org>; Thu, 02 Mar 2023 11:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOqx6+dyQPye0A81ODuEToLEveIRPrUr3lZNhmSxjjk=;
        b=iIxJ+yaqP3QmfBW0rsDQmbUeN2HV9lQSgW9lPvJNFQ5OA6vsIf9R/rS4J5ed51Ityk
         tP38dC8HUmfeM+h02dXn1giAYHHOabCkfPyhXroows+8+1OmI6+kb8R22AVk7+f4rHe4
         qmSC8oQRs4SCX/e2IuDKGhQHz2lSlaCcm6uH8DCYFrL86CNLgzQszQ+ktSVmdkuQgcQt
         moHBS8W0drY2SqTsH1TeX4z58lIP7M9Eo+UjitfptDEHb1cNEISrnvPls7P/Fcd00Zu2
         LsFn+U1sNZnmIoN8ZDlofjJY+RgYiQsgmapahlZ2L8WGnhoHh0NN7v4aC4QC/YWH0ZS2
         RUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kOqx6+dyQPye0A81ODuEToLEveIRPrUr3lZNhmSxjjk=;
        b=PVm2GT3iAsXkbbaclEy/k5yFWzjUnUtzH92mzAbh/cmrX341HS0bJNNoIfxeQF5xVS
         YAgefVZ2MtSDCJ7Pg7sodLXMYFM7kOTIVocwpEy4ALEtAmbB0JT8LRkMzQl7qGXFjdx6
         JKT9tvVM+BbXSdu14TqOoZiiiaadOUcZ03d2XP8PBxawobo683vReKyO4xkadSw7Zb7e
         qRfDHSHOVEo1IVif/MeR5ZoPZ5TDcf+LW4O134jTZ3GNfRp8xtMbbk2v7J6kEhvqwvAI
         1OA8OwqCi802h3DnzLgf7utk8NvalNm9G5Z/zvMMFkeJz+dq5JjgE4thHqi+iVoq9yUs
         8riQ==
X-Gm-Message-State: AO0yUKV01l6oibd9cB5qkcP0a6P4H5GSgILc0ZIXt37eOX7p1x//NXX5
        kK12dRbhNhvvr9r5ELzdm3PrqK/kApdAnf9HLUI=
X-Google-Smtp-Source: AK7set/0xFcpWqwQDQPSfbB+cPf/CHo5PsvE69nxXhYD2gRy03tmyT1+jbcO1l0BS0d32BWVtp3UB57hoHiVk9gedjw=
X-Received: by 2002:a17:906:53ca:b0:878:790b:b7fd with SMTP id
 p10-20020a17090653ca00b00878790bb7fdmr5526415ejo.14.1677786144708; Thu, 02
 Mar 2023 11:42:24 -0800 (PST)
MIME-Version: 1.0
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com> <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
 <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
 <300597ce-06a5-a987-5110-aa6ec24ea199@talpey.com> <CAH2r5msjKi-FMQRaHptk5fPycZRSS5ZQNC-u=1wE8oxBUhN5Ug@mail.gmail.com>
In-Reply-To: <CAH2r5msjKi-FMQRaHptk5fPycZRSS5ZQNC-u=1wE8oxBUhN5Ug@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 3 Mar 2023 05:42:11 +1000
Message-ID: <CAN05THRC3nbDFhsiBxaQo9NPazk2RFr65EpEjka_gnDY_aOapg@mail.gmail.com>
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Andrew Walker <awalker@ixsystems.com>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 3 Mar 2023 at 05:38, Steve French <smfrench@gmail.com> wrote:
>
> > Why isn't this behavior simply the default?
>
> Without persisted inode numbers (UniqueId) it would cause problems
> with hardlinks (ie mounting with noserverino).  We could try a trick
> of hashing them with the volume id if we could detect the transition
> to a different volume (as original thread was discussing) -
> fortunately in Linux you have to walk a path component by component so
> might be possible to spot these more easily.

Just hashing it with something does not make the problem go away, it
would just make it
more unpredictable to trigger or reproduce  but the very serious issue
with data loss that Tom ponted out still remains.

Maybe a solution is to NOT traverse across these volume transitions at
all in the client and maybe users should be forced to
explicitely mount these different volumes clientside, exactly like how
NFSv3 does and requires clients to deal with this situation.

But yes, it is an extremely serious bug that will cause data loss when
it triggers for files we write to.


>
> On Thu, Mar 2, 2023 at 1:19=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 3/1/2023 8:49 PM, Steve French wrote:
> > > I would expect when the inode collision is noted that
> > > "cifs_autodisable_serverino()" will get called in the Linux client an=
d
> > > you should see: "Autodisabling the user of server inode numbers on
> > > ..."
> > > "Consider mounting with noserverino to silence this message"
> >
> > Why isn't this behavior simply the default? It's going to be
> > data corruption (sev 1 issue) if the inode number is the same
> > for two different fileid's, so this seems entirely backwards.
> >
> > Also, the words "to silence this message" really don't convey
> > the severity of the situation.
> >
> > Tom.
>
>
>
> --
> Thanks,
>
> Steve
