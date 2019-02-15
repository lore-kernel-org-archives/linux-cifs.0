Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32989C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3DBF21934
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QeaAwVUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfBOBFu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 20:05:50 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34234 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfBOBFu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 20:05:50 -0500
Received: by mail-lj1-f194.google.com with SMTP id l5so3510684lje.1
        for <linux-cifs@vger.kernel.org>; Thu, 14 Feb 2019 17:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fKkaoxoIpkJzl6me3i85rxhdHPxNKf9kfjqcEdlEy1Q=;
        b=QeaAwVUvwX/PH6UKi9NMS4Q1Tgm6Ob9wixSDcLQi6+jAvoUI4ZpdHChbLMO1JIxcT+
         4Q8rnc3Qt8t95QVDJL4MwlmCWMcjB4qNyC3VnlGTqewyOfLzQdzVohm/KVMrGT7Rg82z
         oCOq5iXfL0w7zLVhX/uo62z5RXFN9Mcr9IOlplHUFaPlr0fFebEDEg1w2c1Z4azzFhU9
         hdwExyhQlelcT0dOG2r4Axs3p2aXvzHm5SrPdKRb7gKyeZvtAM1Zc/m5sAite/JQao1n
         pZdPRq+lQXv3I+jz/sG2iDvOk5JU79Ip11UolVQvLxHxgZvTTaOtTBlUcgtb0HWFC/3O
         s1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fKkaoxoIpkJzl6me3i85rxhdHPxNKf9kfjqcEdlEy1Q=;
        b=jJKvkXmCf1n1NnAxViPsbXzKdHcn0vRVHFyfrRMH4EavMdtdxnnfOP76os5BypT4PG
         f0kySbEf55MnPErnOIgCAEtJNpALXwjO8anYIpfIFIeUkjM5WZe9P9dnVMZrm9PnMTRI
         LOg5jjAzbu5j0q69rCwmHd2FVLN8KbRRjUJaY4r31M+pU22UpXvYWNPLKD6yfaD4CaVO
         cG6q1kF/Fj7ImCKKa7XEd+u+Oe1WvARkDTPk1yx5JuFrOD5pzJnqHjn3lpCnfOl6DP6W
         57R+h7CdLGW886pMnpfObw7KpF8kkvwYA+e0i8d9hcn3ywwnUD0SMAkRx9FQS+JdlL/y
         ofgA==
X-Gm-Message-State: AHQUAuYZikmfgny7WAiB0g42VMcE59x+EwmWcONbnzeWUUDmTtK77BrP
        P4bZ5oyTBmxUFuME6A2h/X27R46hQ2Hhr+nxMAFwNcM=
X-Google-Smtp-Source: AHgI3IY/RGnW8cTjZDE9G2RqAhzdxpxqRo7MxHUw2U3o4wqh04vnDGneNMgBlpxxGfZfKoW4P0vMP7uL9Dfl3ed6lxY=
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr4088598ljj.30.1550192748277;
 Thu, 14 Feb 2019 17:05:48 -0800 (PST)
MIME-Version: 1.0
References: <20181124134707.15993-1-kdsouza@redhat.com> <5C0036FE.8040002@tlinx.org>
 <CAA_-hQL=ipFp8haDc0CvkCCt1pt0PcYfM3CiNU-x0g250CBMxQ@mail.gmail.com>
 <CAA_-hQ+PBaN4V1zz7vhXFYT3N6SPUndi2vfw-4UUPhOaGWmM8A@mail.gmail.com> <CAKywueTiO4yYxRdaq0YTbgGuN_rQPm3CHqU5ctKbO7V9CLMGKw@mail.gmail.com>
In-Reply-To: <CAKywueTiO4yYxRdaq0YTbgGuN_rQPm3CHqU5ctKbO7V9CLMGKw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 14 Feb 2019 17:05:37 -0800
Message-ID: <CAKywueSBfyX3e_g0sjfv3KetsceZKWCy20YVTvk2R8U5t4xpTw@mail.gmail.com>
Subject: Re: [PATCH v3] Update mount.cifs with vers=default mount option and SMBv3.0.2
To:     Kenneth Dsouza <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 30 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 11:29, Pavel=
 Shilovsky <piastryyy@gmail.com>:
>
> There is a mix of proposed changes in this thread. So, yes, please do.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D1=82, 30 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 07:39, Ken=
neth Dsouza <kdsouza@redhat.com>:
> >
> > Pavel should I send a V4?
> >
> > On Fri, Nov 30, 2018 at 9:02 PM Kenneth Dsouza <kdsouza@redhat.com> wro=
te:
> > >
> > > On Fri, Nov 30, 2018 at 12:29 AM L. A. Walsh <linux-cifs@tlinx.org> w=
rote:
> > > >
> > > > On 11/24/2018 5:47 AM, Kenneth D'souza wrote:
> > > > > +  - default - Tries to negotiate the highest SMB2+ version suppo=
rted by the server.
> > > > > +
> > > > > +  If no dialect is specified on mount vers=3Ddefault is used.
> > > > >
> > > > ---
> > > > Should that say "the highest SMB2+ version supported by both the cl=
ient and
> > > > the server"?
> > > >
> > > Apologies for the delayed response.
> > > Yes, will send a V4.

Hi Kenneth,

Are you still going to submit V4 of your patch? If yes, please rebase
on top of "next" branch before sending
(https://github.com/piastry/cifs-utils/commits/next).

--
Best regards,
Pavel Shilovsky
