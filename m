Return-Path: <SRS0=ZNV/=D4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D71CC4363A
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 21:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E5D21481
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 21:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eltq3cu5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505707AbgJUVDu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Oct 2020 17:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505706AbgJUVDu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Oct 2020 17:03:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4860C0613CE
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2020 14:03:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z5so5236390ejw.7
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2020 14:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5ovgJT4UMv98Iuv6vTvY8WPWItfK1yPUj0p8dhiTMq4=;
        b=Eltq3cu5WZJtuI40eKbRx2yt+ATrrDf14/DyW0ulkAuss2NBgBfTeW7qM4HGXV/e1g
         N5rQfUM2fzHvb9RsaiTmsYDzLaTQ5Z8NaJhjdIvO7AcmFXAviQKPsdsLijvHaGt7qQpT
         yzvawhfd7SWe/VZKbZ8G3UdSt7ksDKYZv2BOqxj54bwPwSs+uFB2upeEmYZIJ3SfHqB+
         p5OIqBaC985F5rd8f2jgKpV0KHCbcnFypj/mjI8JJzqMXSKdPEmWGD2v2iUOf5Nm26/2
         47FZdxxqI12TMADUNlVhB48he5UrDLEHD9/RRcrRXfLVLUIl6cvM6hWyUxQCox7/08Iy
         AbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ovgJT4UMv98Iuv6vTvY8WPWItfK1yPUj0p8dhiTMq4=;
        b=hexaTmrAgtqnDEZuhPvjDcXbAWkVT4k30gyUfgNAhAgzU3bBHOqaq2H9ewFJo+JImC
         y17g4779n5JaRIJ9vW7/3UjHgwWbl/UseLnQ8TLJep59yacX/SSWzdfooMSNXSYFLR0W
         L5HyBLN2yFlTTTLLAfxO+U1hUQSZKOlCoRLRsm4/QwsWQuwp5y9wjGlLgi7I8QUBnuVU
         6IRJ1SBLbfcRkvLDtRTVVMsdC/UOsFl+EmfQ003K3WjlttzZ/5qmHuQlbVF2T75WPEyj
         BnLjqUUwvllK4T0vB2OcCKImlECjLiCqRl9nud1uEx2XVCmNh9bscbdhr354D8q4X/Mu
         YAkg==
X-Gm-Message-State: AOAM530MW0OfTBfAsFeYpQNDdP4SF357Z5XrtY9L9rsBpE6+LR9Wtw9E
        GgfZ0stpa+DJKPgG3YZYTECR420YgE8aBHmZXg==
X-Google-Smtp-Source: ABdhPJwYTe7aE0ZDRyVCsu2cd3LckyQ+QXPsOes9i1RXEsKHePtmJ6eK8ZEfwRMJz0Rx9aERJEr4lOz6Mz6SqDNDGNU=
X-Received: by 2002:a17:906:f9d1:: with SMTP id lj17mr4164813ejb.280.1603314227313;
 Wed, 21 Oct 2020 14:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
 <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
 <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
 <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com>
 <CAKywueRcNLv5k2kchN6vC2t1=K9SWNNAhd6f+gJYYgGdUwEWqg@mail.gmail.com>
 <CAKywueR=uDELZrL0fQKOseS6OcCDa9X_eVXwGG55+pt9qSLrOw@mail.gmail.com> <CAH2r5msArhmdTHZ499eUZHbo7FEeAmxzJc-Sp5+YDWUCNMsNaQ@mail.gmail.com>
In-Reply-To: <CAH2r5msArhmdTHZ499eUZHbo7FEeAmxzJc-Sp5+YDWUCNMsNaQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 21 Oct 2020 14:03:35 -0700
Message-ID: <CAKywueQD8=FM8PYS-0VCg8bqf=ig-2FqNYeM0xptaQg2VDsw1w@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Steve French <smfrench@gmail.com>
Cc:     Rohith Surabattula <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks. Should we add "cifs: " prefix to the beginning of the patch
title? Given that the patch goes to stable this may worth doing
another rebase.
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 20 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 15:08, Steve Frenc=
h <smfrench@gmail.com>:
>
> Added cc:stable 5.4+ and the 2 Reviewed-bys and merged into
> cifs-2.6.git for-next
>
> On Tue, Oct 20, 2020 at 4:43 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Any ideas about stable? esize mount option went into kernel v5.4.
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 09:48, Pavel S=
hilovsky <piastryyy@gmail.com>:
> > >
> > > Thanks for the patch!
> > >
> > > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 00:28, Rohit=
h Surabattula <rohiths.msft@gmail.com>:
> > > >
> > > > Hi Pavel,
> > > >
> > > > Corrected the patch with the suggested changes.
> > > > Attached the patch.
> > > >
> > > > Regards,
> > > > Rohith
> > > >
> > > > On Thu, Oct 15, 2020 at 9:39 PM Pavel Shilovsky <piastryyy@gmail.co=
m> wrote:
> > > > >
> > > > > In receive_encrypted_standard(), server->total_read is set to the
> > > > > total packet length before calling decrypt_raw_data(). The total
> > > > > packet length includes the transform header but the idea of updat=
ing
> > > > > server->total_read after decryption is to set it to a decrypted p=
acket
> > > > > size without the transform header (see memmove in decrypt_raw_dat=
a).
> > > > >
> > > > > We would probably need to backport the patch to stable trees, so,=
 I
> > > > > would try to make the smallest possible change in terms of scope =
-
> > > > > meaning just fixing the read codepath with esize mount option tur=
ned
> > > > > on.
> > > > >
> > > > > --
> > > > > Best regards,
> > > > > Pavel Shilovsky
> > > > >
> > > > > =D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:21, R=
ohith Surabattula <rohiths.msft@gmail.com>:
> > > > > >
> > > > > > Hi Pavel,
> > > > > >
> > > > > > In receive_encrypted_standard function also, server->total_read=
 is
> > > > > > updated properly before calling decrypt_raw_data. So, no need t=
o
> > > > > > update the same field again.
> > > > > >
> > > > > > I have checked all instances where decrypt_raw_data is used and=
 didn=E2=80=99t
> > > > > > find any issue.
> > > > > >
> > > > > > Regards,
> > > > > > Rohith
> > > > > >
> > > > > > On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gmai=
l.com> wrote:
> > > > > > >
> > > > > > > Hi Rohith,
> > > > > > >
> > > > > > > Thanks for catching the problem and proposing the patch!
> > > > > > >
> > > > > > > I think there is a problem with just removing server->total_r=
ead
> > > > > > > updates inside decrypt_raw_data():
> > > > > > >
> > > > > > > The same function is used in receive_encrypted_standard() whi=
ch then
> > > > > > > calls cifs_handle_standard(). The latter uses server->total_r=
ead in at
> > > > > > > least two places: in server->ops->check_message and cifs_dump=
_mem().
> > > > > > >
> > > > > > > There may be other places in the code that assume server->tot=
al_read
> > > > > > > to be correct. I would avoid simply removing this in all code=
 paths
> > > > > > > and would rather make a more specific fix for the offloaded r=
eads.
> > > > > > >
> > > > > > > --
> > > > > > > Best regards,
> > > > > > > Pavel Shilovsky
> > > > > > >
> > > > > > > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36=
, Steve French <smfrench@gmail.com>:
> > > > > > > >
> > > > > > > > Fixed up 2 small checkpatch warnings and merged into cifs-2=
.6.git for-next
> > > > > > > >
> > > > > > > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > > > > > > <rohiths.msft@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > Hi All,
> > > > > > > > >
> > > > > > > > > With the "esize" mount option, I observed data corruption=
 and cifs
> > > > > > > > > reconnects during performance tests.
> > > > > > > > >
> > > > > > > > > TCP server info field server->total_read is modified para=
llely by
> > > > > > > > > demultiplex thread and decrypt offload worker thread. ser=
ver->total_read
> > > > > > > > > is used in calculation to discard the remaining data of P=
DU which is
> > > > > > > > > not read into memory.
> > > > > > > > >
> > > > > > > > > Because of parallel modification, =E2=80=9Cserver->total_=
read=E2=80=9D value got
> > > > > > > > > corrupted and instead of discarding the remaining data, i=
t discarded
> > > > > > > > > some valid data from the next PDU.
> > > > > > > > >
> > > > > > > > > server->total_read field is already updated properly duri=
ng read from
> > > > > > > > > socket. So, no need to update the same field again after =
decryption.
> > > > > > > > >
> > > > > > > > > Regards,
> > > > > > > > > Rohith
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > --
> > > > > > > > Thanks,
> > > > > > > >
> > > > > > > > Steve
>
>
>
> --
> Thanks,
>
> Steve
