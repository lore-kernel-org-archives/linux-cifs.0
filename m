Return-Path: <SRS0=6k4I=4N=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340DAC35E01
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Feb 2020 19:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0872F20CC7
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Feb 2020 19:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sj3J4Tg3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgBYTVu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:21:50 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33528 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731090AbgBYTVu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Feb 2020 14:21:50 -0500
Received: by mail-lj1-f195.google.com with SMTP id y6so195036lji.0
        for <linux-cifs@vger.kernel.org>; Tue, 25 Feb 2020 11:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BjwYlHmuGAdeikF/2XEu23FikIQIHQ0h05ocXqEZmU8=;
        b=Sj3J4Tg3a7jHWn1UN3QTLQ4tHjd4ZwtnogvppoampuWUOl4IxtJCOhGhWHpymmS/LL
         CAqqbT/MN4g+BDrta/uPd/VLtqJ8sXCuUGlCaPPAue1533LFScYi3gKOxp2iCi1MevuT
         5IajPA5Nn6T5XueVWTMzlL9o8tB6mzAX7tOde0BnLcpe1HIAbBqkqcZO/CYlo1BwLOqN
         +R5kryO+C/NzsHeFjKXTVce7io2MqZuyZ/Yzky/eT2NrVwQ782zi4pYBXYN+niWzTdOi
         aLLSVmlJbqAehTwL3qGDWuFyBsUFK44OkvLqw52vK54dPTnaVj5wUSiL2B2DjTCn152o
         ozcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BjwYlHmuGAdeikF/2XEu23FikIQIHQ0h05ocXqEZmU8=;
        b=Ure/sfdwvIG4YzSsXUqXXgduUwL56mmyzWuKm2REVyyYu+A1CKt8F+0uKxNOu1rk+B
         Wt2+ZIYFT/IS6hYVYqbDgkn1Lnp2CWvjBzTdAe0jM+RS4F2BF7e5q0T51Rc6XLc1P9g6
         KafDl2BS1liAPPaY1eGNe+L88dUgLbsmtbs8J1zfO0ZvMS1jE+cRO7U++gb8617louT1
         M8Ei4PqhYAgvebvlz4YXBFqvtZZ7PU4RLVK/ymWxqrgUoLHGXYopK6gGHt7QepPD/m4S
         geRW7HuPMVNexmyg88U6yk2ZcfCukuiGVyMHBEWkU84GoXOHGY/VuRf6fU37X2EonL7S
         miJw==
X-Gm-Message-State: ANhLgQ1U7ogdA4Z+0CMC8BNhjipM/zYh95d/3D7ZNpJYHh/ndqpXQ0Qk
        8D4iughJOHx1Cyf8EWG+TjbYlO6ix2mQScXg8w==
X-Google-Smtp-Source: APXvYqxeW4UQ/zk0pm30UkccRUZ3VM3DdFFKBYJnGpmAn9BSFZeG6fEediJMVLF6olVRu+qYHATi8UbXZ+9uBpU+78s=
X-Received: by 2002:a2e:7315:: with SMTP id o21mr345323ljc.276.1582658508301;
 Tue, 25 Feb 2020 11:21:48 -0800 (PST)
MIME-Version: 1.0
References: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
 <370134c148a5f4d12df31a3a9020b66ef316a004.camel@kernel.org>
 <20200214142836.2rhitx3jfa5nxada@xzhoux.usersys.redhat.com>
 <CAKywueRV8+8qVP6e5nsvbpMQtwDU5mQGw5h51w=5rOsCN+Oj0w@mail.gmail.com>
 <20200219021039.3mpkrmvipd6z3wes@xzhoux.usersys.redhat.com>
 <CAKywueRvfABoVrdipic6x5_V31K0sOqs8T5y9VzJuyB4Q40bUQ@mail.gmail.com> <20200225051551.erpp36onb2kxmxjn@xzhoux.usersys.redhat.com>
In-Reply-To: <20200225051551.erpp36onb2kxmxjn@xzhoux.usersys.redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 25 Feb 2020 11:21:37 -0800
Message-ID: <CAKywueRBLp84nrSVBYoLs-uk2OjJpcME-OW4q0UDSTNjQoggJw@mail.gmail.com>
Subject: Re: [PATCH] CIFS: unlock file across process
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 24 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 21:16, Murph=
y Zhou <jencce.kernel@gmail.com>:
>
> On Mon, Feb 24, 2020 at 11:39:27AM -0800, Pavel Shilovsky wrote:
> > =D0=B2=D1=82, 18 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 18:10, M=
urphy Zhou <jencce.kernel@gmail.com>:
> > >
> > > On Fri, Feb 14, 2020 at 11:03:00AM -0800, Pavel Shilovsky wrote:
> > > > Also, please make sure that resulting patch works against Windows f=
ile
> > > > share since the locking semantics may be different there.
> > >
> > > OK.
> > >
> > > >
> > > > Depending on a kind of lease we have on a file, locks may be cached=
 or
> > > > not. We probably don't want to have different behavior for cached a=
nd
> > > > non-cached locks. Especially given the fact that a lease may be bro=
ken
> > > > in the middle of app execution and the different behavior will be
> > > > applied immediately.
> > >
> > > Testing new patch with and without cache=3Dnone option, both samba
> > > and Win2019 server.
> > >
> > > Thanks very much for reviewing!
> > >
> >
> > cache=3Dnone only affects IO and doesn't change the client behavior
> > regarding locks. "nolease" mount option can be used to turn off leases
> > and make all locks go to the server.
>
> Great to know! I can't find it in any man page. Doing more tests.
>

Good catch, it is missing in the man pages.

Now added: https://github.com/piastry/cifs-utils/commit/4b8b2e2680e7e4aa9cc=
8bd4278d04e5fe07d885e

Thanks!

--
Best regards,
Pavel Shilovsky
