Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF28EB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 12:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjF0MRo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 08:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjF0MRn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 08:17:43 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F255D1BE7
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 05:17:41 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b698937f85so45497631fa.2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 05:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687868260; x=1690460260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zT3UiCDBGIhjfbKC/PdcGl+zLwmRp+1TQX5pdE6SV7c=;
        b=pf3iJ0UcqNI29mwd31a6z6/O8tedp73G0st8keaZz14ycCtlesg82hshkwqf2BIHjX
         9BgtHfChd+f0FJT8muE7u/ut6uwglm05ZLHFb9Y460WLX+NNCZb1V1V9ljgSTof9gfwW
         ZewBZFjTlU8GIGM6D3Zhkhmjk2grdKMPawwVwSbLpM72vq9aB3mzkByPiRqVRyrFr0dd
         J5lvxQMAHovk+llnUhepqM3lMOTLc9Q94SxFFEb/kMGiTcMM3p1Et0LWZj4/8fdSTyki
         +m+Dd8/03lU6h7nBLdEJZ+/SK/Mmz/ObR0oiFWgo4cFN70tJKJYlkQqUoH3eGRtU6oCm
         YmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687868260; x=1690460260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zT3UiCDBGIhjfbKC/PdcGl+zLwmRp+1TQX5pdE6SV7c=;
        b=NKghx/Iq/XGD3Y4cJ0UTU60r6ern5G0GXiBxUq8M/eDkX+jBOL3wHm/UKL2UmVJBXa
         wSnjU5FXVo6Uq4qOf6NlSbeAX0anApdh4hB97at9Bal/v7Eo1yByye3SzL6IM44xBaMV
         qSWfXOB6St59eSFnHNxCNmAwSRPbpu5s7k2ja/a4zBG889hAUICvW0ERFzw7LUnTFrNO
         FFwNCVcf6jbnKWXxBbK5WoyM4lPUMU3hB7Fh4jMAaC5qJgtS2COgKNtGvt6E/IEFl17J
         2bZn3ICB8QI4QcPqqyrHznMUaEn3a4UqoXq/8b4P+f5vvV5r3+NShh64afLjPczjMjTj
         cCBQ==
X-Gm-Message-State: AC+VfDxGobwW26jXVHXLBDhAr7KEfdkMLFTAC0N+Dg7AkejcaQAa8YBS
        BdVDxr5omO9TosKsiKWmtMoQa8n1uWQA4ccc9VU=
X-Google-Smtp-Source: ACHHUZ6yeBFCZ0kcBXkCp5kandSLdDpk5aeTxKo96FTWa5PCY+mvUNDKCe8om/filCdm7ixsWt1IeBUM8ddv8Eup7ec=
X-Received: by 2002:a2e:94c1:0:b0:2b1:daca:676f with SMTP id
 r1-20020a2e94c1000000b002b1daca676fmr19515072ljh.36.1687868259851; Tue, 27
 Jun 2023 05:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com> <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com> <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com>
In-Reply-To: <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 27 Jun 2023 17:47:28 +0530
Message-ID: <CANT5p=pW-O7UQgfRKR6XpFnnFka9PVQQ0y1YtOz+DcaQt9yH3Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Tom Talpey <tom@talpey.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 23, 2023 at 9:24=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/23/2023 12:21 AM, Shyam Prasad N wrote:
> > On Mon, Jun 12, 2023 at 8:59=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse=
.de> wrote:
> >>
> >> On 06/12, Paulo Alcantara wrote:
> >>> Shyam Prasad N <nspmangalore@gmail.com> writes:
> >>>
> >>>> I had to use kernel_getsockname to get socket source details, not
> >>>> kernel_getpeername.
> >>>
> >>> Why can't you use @server->srcaddr directly?
> >>
> >> That's only filled if explicitly passed through srcaddr=3D mount optio=
n
> >> (to bind it later in bind_socket()).
> >>
> >> Otherwise, it stays zeroed through @server's lifetime.
> >
> > Yes. As Enzo mentioned, srcaddr is only useful if the user gave that
> > mount option.
> >
> > Also, here's an updated version of the patch.
> > kernel_getsockname seems to be a blocking function, and we need to
> > drop the spinlock before calling it.
>
> Why does this not do anything to report RDMA endpoint addresses/ports?
> Many RDMA protocols employ IP addressing.
>
> If it's intended to not report such information, there should be some
> string emitted to make it clear that this is TCP-specific. But let's
> not be lazy here, the smbd_connection stores the rdma_cm_id which
> holds similar information (the "rdma_addr").
>
> Tom.

Hi Tom,

As always, thanks for reviewing.
My understanding of RDMA is very limited. That's the only reason why
my patch did not contain changes for RDMA.
Let me dig around to understand what needs to be done here.

--=20
Regards,
Shyam
