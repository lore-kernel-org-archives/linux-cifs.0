Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2757C4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 21:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FAEF2237B
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 21:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eWQPLtPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392107AbgJTVnu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 17:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392089AbgJTVnu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Oct 2020 17:43:50 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55795C0613CE
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 14:43:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dg9so220965edb.12
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 14:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pWlPMWfgvbfRlDAAl/aVUk4a/aActXoQK34r9796CHY=;
        b=eWQPLtPaKAnnQqrqmWzfCBKSiDvXJZGLcRp06Ixwb98s/nBo0hKfcfcjPW58B2H7nS
         A2AkfN7XqPXVRbflfkUPns+yR7iwNam9HOQ5FEu/AcfSbz7MdF9rREwA2+6c+7VUZPnu
         s2EVNaoT7p07arnTsaNq/Ggde+v8PCYihAiFuWuPCaI93eIXi72W+tCOl/HQDHx42gkG
         P6KdkJeNAYxAa6a7fUDpoxQTck/Upk7/xOKUOPRziEsYtL3y9832dAJxJwcbzw418FwO
         aBwtJGo9Gb/m5kM6TF+DKe9DNZ/yFKfGgCDgj/SCFe6l59DZzZGgxGDxOtHo9j6zoP5X
         XayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pWlPMWfgvbfRlDAAl/aVUk4a/aActXoQK34r9796CHY=;
        b=YurNqa6yvudDKP7ysSlhpEfgy9Z59rbR/9lz92/pomMP8t6Sku4wUeMcGQUCTG3Xq4
         eyvGfEdbyEW18Dyqo9xUi342Qci3hNBr/rotjMPBnlwU3oti5w1+csS0rT6A7nZDpL74
         bzvqlhDKnhzhbwM8lUTVeugI+t5hKQOdP+gVxxiYYcmuIXVjzmQtN1tHL/vqse9KajTd
         EqF+yAex9TUuPhlGeTQ5fd/bjTajX9Lx/kfZONdi6Bx/M6TRLc0v7o26act7qEsBtv6b
         ktjmclRaiKgsEzFf+P3wIBgcqxzAVu3GQdV2QLhLCRdfs6PFu+brdyYYbAazNnns97xX
         nb8A==
X-Gm-Message-State: AOAM533FLcBN4SlvpuQRsigtLAQnKxYl7R+8ejJpUcMaXuVFAsDxzqXJ
        aQUYTzbKCXonm/1qRkoKjjYSS1QmCohqX/ipYg==
X-Google-Smtp-Source: ABdhPJwWjuAohh4c0HEuVr3UK0ikIQIpLwqwD3xFvrewr5/RITJDjTVYuad8zCKmicm8u5OQOzF0/DBEEBNYY/tjhiY=
X-Received: by 2002:a05:6402:b72:: with SMTP id cb18mr12192edb.129.1603230229029;
 Tue, 20 Oct 2020 14:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
 <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
 <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
 <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com> <CAKywueRcNLv5k2kchN6vC2t1=K9SWNNAhd6f+gJYYgGdUwEWqg@mail.gmail.com>
In-Reply-To: <CAKywueRcNLv5k2kchN6vC2t1=K9SWNNAhd6f+gJYYgGdUwEWqg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 20 Oct 2020 14:43:37 -0700
Message-ID: <CAKywueR=uDELZrL0fQKOseS6OcCDa9X_eVXwGG55+pt9qSLrOw@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any ideas about stable? esize mount option went into kernel v5.4.

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 09:48, Pavel Shilo=
vsky <piastryyy@gmail.com>:
>
> Thanks for the patch!
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 00:28, Rohith Su=
rabattula <rohiths.msft@gmail.com>:
> >
> > Hi Pavel,
> >
> > Corrected the patch with the suggested changes.
> > Attached the patch.
> >
> > Regards,
> > Rohith
> >
> > On Thu, Oct 15, 2020 at 9:39 PM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > In receive_encrypted_standard(), server->total_read is set to the
> > > total packet length before calling decrypt_raw_data(). The total
> > > packet length includes the transform header but the idea of updating
> > > server->total_read after decryption is to set it to a decrypted packe=
t
> > > size without the transform header (see memmove in decrypt_raw_data).
> > >
> > > We would probably need to backport the patch to stable trees, so, I
> > > would try to make the smallest possible change in terms of scope -
> > > meaning just fixing the read codepath with esize mount option turned
> > > on.
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:21, Rohit=
h Surabattula <rohiths.msft@gmail.com>:
> > > >
> > > > Hi Pavel,
> > > >
> > > > In receive_encrypted_standard function also, server->total_read is
> > > > updated properly before calling decrypt_raw_data. So, no need to
> > > > update the same field again.
> > > >
> > > > I have checked all instances where decrypt_raw_data is used and did=
n=E2=80=99t
> > > > find any issue.
> > > >
> > > > Regards,
> > > > Rohith
> > > >
> > > > On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gmail.co=
m> wrote:
> > > > >
> > > > > Hi Rohith,
> > > > >
> > > > > Thanks for catching the problem and proposing the patch!
> > > > >
> > > > > I think there is a problem with just removing server->total_read
> > > > > updates inside decrypt_raw_data():
> > > > >
> > > > > The same function is used in receive_encrypted_standard() which t=
hen
> > > > > calls cifs_handle_standard(). The latter uses server->total_read =
in at
> > > > > least two places: in server->ops->check_message and cifs_dump_mem=
().
> > > > >
> > > > > There may be other places in the code that assume server->total_r=
ead
> > > > > to be correct. I would avoid simply removing this in all code pat=
hs
> > > > > and would rather make a more specific fix for the offloaded reads=
.
> > > > >
> > > > > --
> > > > > Best regards,
> > > > > Pavel Shilovsky
> > > > >
> > > > > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36, St=
eve French <smfrench@gmail.com>:
> > > > > >
> > > > > > Fixed up 2 small checkpatch warnings and merged into cifs-2.6.g=
it for-next
> > > > > >
> > > > > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > > > > <rohiths.msft@gmail.com> wrote:
> > > > > > >
> > > > > > > Hi All,
> > > > > > >
> > > > > > > With the "esize" mount option, I observed data corruption and=
 cifs
> > > > > > > reconnects during performance tests.
> > > > > > >
> > > > > > > TCP server info field server->total_read is modified parallel=
y by
> > > > > > > demultiplex thread and decrypt offload worker thread. server-=
>total_read
> > > > > > > is used in calculation to discard the remaining data of PDU w=
hich is
> > > > > > > not read into memory.
> > > > > > >
> > > > > > > Because of parallel modification, =E2=80=9Cserver->total_read=
=E2=80=9D value got
> > > > > > > corrupted and instead of discarding the remaining data, it di=
scarded
> > > > > > > some valid data from the next PDU.
> > > > > > >
> > > > > > > server->total_read field is already updated properly during r=
ead from
> > > > > > > socket. So, no need to update the same field again after decr=
yption.
> > > > > > >
> > > > > > > Regards,
> > > > > > > Rohith
> > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
