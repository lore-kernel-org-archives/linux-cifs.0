Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3984BC77B73
	for <linux-cifs@archiver.kernel.org>; Tue,  2 May 2023 05:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjEBFyz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 May 2023 01:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBFyy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 May 2023 01:54:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8AA40DD
        for <linux-cifs@vger.kernel.org>; Mon,  1 May 2023 22:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27C9D6188A
        for <linux-cifs@vger.kernel.org>; Tue,  2 May 2023 05:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83731C4339B
        for <linux-cifs@vger.kernel.org>; Tue,  2 May 2023 05:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683006892;
        bh=gJW+oP21UfBXXjm4SaSKFM4Z4OhGmyZssJrSC1aN+2Y=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=B7MlEqDlem1ZMVGBwiL5KOs4wtS1iWKV6coE9BMUOF6HjeB/ceqraylPukFrjz00e
         7+QtkVRDtSrICT4xjFnF52Tcvvn19qreRW4+JIAZsyV7Ja6TARChEcB9A0z4vaUo4o
         2VYaxIOl1qLPdrXD1VcIOB0lZgqYNL/g/TF66X8ttaqywcv6mnEDZ1op89BTiwQsvN
         Pq49og/EwNGaZCzDYuDvCt0eQ1DS1J62eaLgEjqnvfopY57F0M5VOA7Gj8JHgDFNeX
         CJYnUrKrSm0v/OmuqRnOQqYw2dzUUXidEvHEUMHY2VSq4MCkTN7wT6Sy2tRAwjMxi3
         SrhJ+yPnQEIYg==
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-54cae469c07so208690eaf.3
        for <linux-cifs@vger.kernel.org>; Mon, 01 May 2023 22:54:52 -0700 (PDT)
X-Gm-Message-State: AC+VfDxousOWlSyVsYt24nn7x4LqeIP9JyQ9iNdGNCkrghIfQUyCylDR
        6Uc9Jv+5flL/kVUHG2o2L4iFb2fo+pZO0n6eQo8=
X-Google-Smtp-Source: ACHHUZ70Lr0e1XVxSPV4Ja3OaAki+RgaxiBHkYQ4ne81GFgc3AjRBlBLHw1JIgC0eb+5qdveKxtzwASqpC+eZ4ASGfs=
X-Received: by 2002:aca:1e19:0:b0:38d:f4dd:ac69 with SMTP id
 m25-20020aca1e19000000b0038df4ddac69mr7077960oic.42.1683006891665; Mon, 01
 May 2023 22:54:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1086:0:b0:4d3:d9bf:b562 with HTTP; Mon, 1 May 2023
 22:54:51 -0700 (PDT)
In-Reply-To: <CAH2r5mspEcMGsgeWqNpNSLxCnog1XJt7U_m6aM=fuBDhzsNHNQ@mail.gmail.com>
References: <CAH2r5ms+mTNU746nkbAjb9FOdiaAcK9rQK76NMv6Njd0MsDq7A@mail.gmail.com>
 <CAH2r5muyLyhc_y8k6XwTyfpF4hhSTAezRmvfCCd+wjzpLqkwMg@mail.gmail.com>
 <CAH2r5muDPGgFQoXhME0MDUH+9enrpcFW5z=XBLBB_gRTz7hu=g@mail.gmail.com> <CAH2r5mspEcMGsgeWqNpNSLxCnog1XJt7U_m6aM=fuBDhzsNHNQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 2 May 2023 14:54:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8J=5kOM0LCgzZG8QNYgU2urHAvY=oQKGaVHBo7_dVa4g@mail.gmail.com>
Message-ID: <CAKYAXd8J=5kOM0LCgzZG8QNYgU2urHAvY=oQKGaVHBo7_dVa4g@mail.gmail.com>
Subject: Re: [PATCH][CIFS] fix incorrect size for query_on_disk_id
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-04-29 11:31 GMT+09:00, Steve French <smfrench@gmail.com>:
> attached wrong patch - resending with right attachment
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
>
>
> On Fri, Apr 28, 2023 at 9:30=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
>>
>> As Paulo pointed out - size was not incorrect, just confusing when the
>> two structs (cifs and ksmbd)
>> differed.  I fixed the patch description.
>>
>> On Fri, Apr 28, 2023 at 12:48=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
>> >
>> > forgot to remove the old incorrect struct (now unused).  Patch fixed
>> > and reattached
>> >
>> > On Fri, Apr 28, 2023 at 12:24=E2=80=AFAM Steve French <smfrench@gmail.=
com>
>> > wrote:
>> > >
>> > > We were assuming the wrong size for the struct, use the ksmbd
>> > >     version of this struct and move it to common code.
>> > >
>> > >
>> > >
>> > > --
>> > > Thanks,
>> > >
>> > > Steve
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Thanks,
>
> Steve
>
