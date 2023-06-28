Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59D6EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 17:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjF1RIE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjF1RIB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jun 2023 13:08:01 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4D710C
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 10:07:59 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b6a0d91e80so425501fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 10:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687972077; x=1690564077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6MWWCWR5nr8vTSycLn4vAHV/KLF19WnjpAv1YLvgX0=;
        b=EKjrhxZzYrkCp8eXgVvyLYrqLn5Ju1ZQESW/76xJqlpGK4lyv1Hfydn4QYSDM9Q1mk
         H/7MuuLvP+GoBjatsIXZYNc5FUoeMYDd6blCdagyepHVJcLzTorl3DNReRBV4kUOB0oI
         vB3sr6B2gevrCs88blSKEP3U8ST5mtI3cmb+kWdmJ76foclLNDNEI9K2KWs5SSD4qZra
         qXtaWAvZOGNvF0JsJpuzSgJrGK2jCwX9UJqqGiKqy+kek2/tC6KJVUKLzEnURm1ZmqSN
         aSxFcgplicWh9cfnKb5L4IS2UWN1OUYhzRr+EAY+X0T68W2omnrQ3po4JRTcBa5WYDpR
         J5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687972077; x=1690564077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+6MWWCWR5nr8vTSycLn4vAHV/KLF19WnjpAv1YLvgX0=;
        b=k8LP/KrW7YCwq3keRK4EuWdUpvfVmGuBmJ8WbTYBlanJfiiD5LO62U8gVo1yUK4dJr
         6VzDkX3yHpS4NeIG7IyAp+hdN8dbTX4dYYSczHg5Wi1po8zwvMBFw4KMDc34MNNppCSL
         Chv9N8Fm/jp+hEko+hu4lmjdbxyT9rZ7LEn/nh2GAk7zWuxelBHxtHcf98k6Ddc7stnL
         P/12qbmM6mdPAeM3jX3lci5XMBfPXgoEQoHzsvmt0YJaGqMCT6BS8oqsc66LKRgPsT3R
         kyrrRfnIjXiSgbhod+igeY/EJ4T7FqF5GgbvmLpKatGGWRKE9Jc8rhCqyVvYg/woTpqF
         0FKg==
X-Gm-Message-State: AC+VfDz3lZFdNFf4w0CsuchT5gIQ0tDXdwTfwDPPb5ypYl0Pp5VPuCEt
        fey+Yvjmr/DOw7Z0KCYkbD9R0Uw/kScYokQPF+E=
X-Google-Smtp-Source: ACHHUZ7pD3+3mPwiozlWlx5jTbjIFciIwvjsVmVrJwDBQgbW6TNbhvGBP/xkA5QH6+Hlh5k+7HrDPoCHeAqfYRJHgIY=
X-Received: by 2002:a05:651c:118:b0:2b4:753d:9321 with SMTP id
 a24-20020a05651c011800b002b4753d9321mr20552274ljb.21.1687972077098; Wed, 28
 Jun 2023 10:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com> <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
 <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com> <CANT5p=pW-O7UQgfRKR6XpFnnFka9PVQQ0y1YtOz+DcaQt9yH3Q@mail.gmail.com>
 <CANT5p=qdS6FFj9ay3bDiP+mWnU1b-NJp2TLb0YdAFyvkqZcKFw@mail.gmail.com>
In-Reply-To: <CANT5p=qdS6FFj9ay3bDiP+mWnU1b-NJp2TLb0YdAFyvkqZcKFw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Jun 2023 12:07:45 -0500
Message-ID: <CAH2r5msrTOKQdwr7vjOEAK0zqATXWNcdF5Vq0TOcSHjZp-O0zg@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

corrected a missing unlock (near line 451 of cifs_debug.c) and
tentatively put in cifs-2.6.git for-next

On Wed, Jun 28, 2023 at 5:20=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Jun 27, 2023 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > On Fri, Jun 23, 2023 at 9:24=E2=80=AFPM Tom Talpey <tom@talpey.com> wro=
te:
> > >
> > > On 6/23/2023 12:21 AM, Shyam Prasad N wrote:
> > > > On Mon, Jun 12, 2023 at 8:59=E2=80=AFPM Enzo Matsumiya <ematsumiya@=
suse.de> wrote:
> > > >>
> > > >> On 06/12, Paulo Alcantara wrote:
> > > >>> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > >>>
> > > >>>> I had to use kernel_getsockname to get socket source details, no=
t
> > > >>>> kernel_getpeername.
> > > >>>
> > > >>> Why can't you use @server->srcaddr directly?
> > > >>
> > > >> That's only filled if explicitly passed through srcaddr=3D mount o=
ption
> > > >> (to bind it later in bind_socket()).
> > > >>
> > > >> Otherwise, it stays zeroed through @server's lifetime.
> > > >
> > > > Yes. As Enzo mentioned, srcaddr is only useful if the user gave tha=
t
> > > > mount option.
> > > >
> > > > Also, here's an updated version of the patch.
> > > > kernel_getsockname seems to be a blocking function, and we need to
> > > > drop the spinlock before calling it.
> > >
> > > Why does this not do anything to report RDMA endpoint addresses/ports=
?
> > > Many RDMA protocols employ IP addressing.
> > >
> > > If it's intended to not report such information, there should be some
> > > string emitted to make it clear that this is TCP-specific. But let's
> > > not be lazy here, the smbd_connection stores the rdma_cm_id which
> > > holds similar information (the "rdma_addr").
> > >
> > > Tom.
> >
> > Hi Tom,
> >
> > As always, thanks for reviewing.
> > My understanding of RDMA is very limited. That's the only reason why
> > my patch did not contain changes for RDMA.
> > Let me dig around to understand what needs to be done here.
> >
> > --
> > Regards,
> > Shyam
>
> Here's a version of the patch with changes for RDMA as well.
> But I don't know how to test this, as I do not have a setup with RDMA.
> @Tom Talpey Can you please review and test out this patch?
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
