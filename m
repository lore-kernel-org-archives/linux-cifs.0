Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491F2EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 16:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjF1QvZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 12:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjF1QvY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jun 2023 12:51:24 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCF39F
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 09:51:23 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b6adef5c22so64191fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 09:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687971082; x=1690563082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1jaCcgcWoYJQO24TPHweqTbLvTYLlQYxZJr8p9E70c=;
        b=Tx6CJP1rFkbJq7v5L8juRNvTexaQO5ZQruhyL+VspRYYZglgOBwpsLLFwqRUuzuCWX
         xJ8vXNvV/uucj88AO8nJjGKfa39enWKGWjRvXfgGCb2m+CdYEJ/PLe/AQF6pcrRTGdXy
         pdyyCGvViLyEs9rlf9+bxUcFyoy7b35oCoA4uM8kgtfvMdwB9O9wJsQfjfFZjORmF+Xa
         Pv3gBxErFHNa8M1ipugVcaC4rTMTSIIhBqzwi5x1KiAtCp4o+u1zbYBBELIhz4yDIchV
         c0izEAGn2FaAHur8JIAM/sakFQ+Yj7XGr0e9M4ronzqmJE616d8c7fuGttMf26O+DaQa
         XcdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687971082; x=1690563082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1jaCcgcWoYJQO24TPHweqTbLvTYLlQYxZJr8p9E70c=;
        b=bgYiuqKxI5aM3r8rzWSVQDHMcYBfqh5kbag9Tir09DDZGBGdX5nnRWhIJCZR36BKiR
         E9dF93/VwsBAUAhfJd+BdJDm4kFBvToPNJUqoWvqgsjP1bGtjf1QUXubFI7dcHk/UunT
         qzK4Hl1tiUwqyapyc+hZJAWRtna4wOX7q4U09qfH+PlqDNutWiBL7A43vtV8z4tsXLau
         kqhLfAzzpKS/c2IBTdRZViIiHUeXc7Da2s/hW8jozd3M5uBrItcwkSeaMjGASgJ/7eYC
         HN4ifBhkWlV7rFw/vDQvUEwsakbLpvX47RDz+MIvhBr37Tq39ZLIuiLyMYb1g4rjmi3V
         /5XA==
X-Gm-Message-State: AC+VfDyEXwdfZ2eiVBKGUlyLigBY/YgyX0gaXKcgs7+YPJKQfBUWnfSF
        KfLTSSASJsZc0vPSrYhFD1sY22yrcR+ZKazNYjg=
X-Google-Smtp-Source: ACHHUZ7qiCC/3+V0MuxY4jAz9qtbp796BRJN9zGHNXTrDgKiNtHEFR3/rcuav/i6GClnenyBp+jlctiP335dAOJoDJk=
X-Received: by 2002:a2e:848a:0:b0:2b4:6c76:332f with SMTP id
 b10-20020a2e848a000000b002b46c76332fmr25395149ljh.9.1687971081652; Wed, 28
 Jun 2023 09:51:21 -0700 (PDT)
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
Date:   Wed, 28 Jun 2023 11:51:10 -0500
Message-ID: <CAH2r5muE+a0mUCb0L8Rnxw08gB6u=Skcw7Jwr_ThWpb-dmrA3A@mail.gmail.com>
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

tentatively merged updated patch in cifs-2.6.git for-next pending
additional testing/review

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
