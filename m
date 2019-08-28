Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9821C3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7410C217F5
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3FQabcc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfH1KN7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 06:13:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44139 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfH1KN6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Aug 2019 06:13:58 -0400
Received: by mail-io1-f67.google.com with SMTP id j4so4665616iog.11
        for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2019 03:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zm2I9gbBvIDA2Mqs+iJw4hoO4J1sD6qFk0pSQSTmeqc=;
        b=U3FQabcc1AtOGubRC8Vqlz4AnQ9VHw1+FU9ECmtcvoIExmYTNzqtI91XK2x8gBTrTE
         zeG1jQgvoPahs6oB551OsgQxMXdGdkxGgJzmm5D+BS7cLenIk2/0fcCdnhmEqQbqfohN
         XLHamYDHvYoVcNK6IC+9TglAIBGvICgqyhocV9FUJ8mNd2xVtG53EoZw+hbGLCLc4ufy
         sf6Mc0QhAbJEydrdrQWsPYBub2COqPwn23iPIKPly8LGS2bgAZ6Nc3hxjXykdn8XWsWD
         oI/H7P2Yapyz/LN+OF32cVqOhekPrild7QmkjiG0n3zbQ6bLbhaqyUJXaAlaKea9cRZ6
         VRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zm2I9gbBvIDA2Mqs+iJw4hoO4J1sD6qFk0pSQSTmeqc=;
        b=fG7Y9BQZzoghJY927AM0LzP6GaG1+ydW7iIqY1gGEJAXYRjVHA56QmteoEIyZ00Vdw
         gjD7IGxBTTj4e6W8JF2OMSK4uoBLA4WSKQ74lAgxPnbx8rTBwymuGzCjz+ybHv+EVbEk
         WIv65j9z0uwzWXPf9prqBSGc3TKNmXzdE4jsOrHzyjFRzEjKsOloFdMBA2aufjPIk8bt
         TtTDRG2Zp9lK7p4MgxxmN7vMiML96eKSpraC1+OdMaX4W7BymYCPmaIf/vYfj0XYRI2F
         kO2y1ii8QSU+uY2hNP9CCgVN3BTRWbg57jPPEdGJDh42+JU5BbcVv1QSTH1uGhJrDcr/
         fW3A==
X-Gm-Message-State: APjAAAV4X/4P8AnyuP6ySNKr98m55Q/+QG+XNngTo96WSXl95GDdYKC5
        cxMLuSsv5JuX7AvQyVMNKGP571sfoGlHGvp+q9M=
X-Google-Smtp-Source: APXvYqxJXF4VGabtb4zyREa4HC2wvC01yx/hZXw26eHzVIdZ4H16L/U4M+SnxpXXPJN8RKs9MdlteNNzqVv99AeX6zg=
X-Received: by 2002:a6b:9203:: with SMTP id u3mr3504758iod.3.1566987238022;
 Wed, 28 Aug 2019 03:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190828031742.6234-1-lsahlber@redhat.com> <87o909li6g.fsf@suse.com>
In-Reply-To: <87o909li6g.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 28 Aug 2019 20:13:46 +1000
Message-ID: <CAN05THRc24L1MBbOHfT6r4WJEiucjkrr3cE7d7uo65M1b+dNsA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add new debugging macro cifs_server_dbg
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 28, 2019 at 8:05 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > which can be used from contexts where we have a TCP_Server_Info *server=
.
> > This new macro will prepend the debugging string with "Server:<serverna=
me> "
> > which will help when debugging issues on hosts with many cifs connectio=
ns
> > to several different servers.
> >
> > Convert a bunch of callsites in connect.c from cifs_dbg to instead use
> > cifs_server_dbg.
>
> This looks like a poorman's ftrace. I'm not sure about it I think it
> would make more sense to add those (or convert) as ftrace tracepoints as
> it supports filtering built-in.

In a sense they are but the usecase is different.
Ftrace is way superior if you can handily reproduce an issue in a lab and t=
est.
This is to make the dmesg output more meaningful for production scenarios w=
here
running a long ftrace is not an option.


If there is an issue that takes days/weeks/.. to reproduce on a
production system
you can't run ftrace for that long.

This is for triage when you have rare events that can not (easily) be
reproduced on production
systems and when after the fact you only have dmesg to further aid in
how to proceed to triage an issue.


>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
