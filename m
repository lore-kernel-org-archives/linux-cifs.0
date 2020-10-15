Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DA0C433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 16:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A7D21D7F
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 16:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nO4mxPBp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgJOQJs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 12:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388461AbgJOQJs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 12:09:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E65C061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 09:09:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a3so4372193ejy.11
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 09:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZEXrK/0Hcl59XE4fVhQhBJ1Z0irjLfODcSNFvb7TlEo=;
        b=nO4mxPBpbnVTM9CxfxZOv8IxhgBmvvfps6Q3AlO7a0u1I8Y63aucbMBx8skmQ+G/tt
         01cze8z7rX7kmO23Uxgye3bPDaM6IdvesVtx7AAGUVtb87AaJ0m3XcT3CtMally7x3wz
         F6VVIyBk96vTiEFHQP/c2TcYqV5jgdjyV1kcaauA1UMHxrR8VXlV8irJS4pXmGhJyj3s
         +32fyW1+LEkooPAiEAgFWtva2YDhA+UNyiQSn51RXOUdDDRdxYIbQcEEi/fKlvZGlujB
         oLSipLKHpbndNHgRFY1IctvU6JbVNArCIOrkQK2mT3ESFZ0PH/n+06HWKIq6IptsDGAm
         TjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZEXrK/0Hcl59XE4fVhQhBJ1Z0irjLfODcSNFvb7TlEo=;
        b=rbI72TZYzoC0WNzcS7ek2BZrl3uFPsAgp6QCrEPWF8vGJ3XF3xLWZBGj0AnxEi4Kdq
         yRYpSkS5WQ04FGmP/COJ8QwUFm+E4+1G1vxK7+DApFYe/2Ugy3MfXoj9ism5v2rbJS+3
         h4r9QrNsGeiGgneNUsjMjWkwAec5e7+KRA2/Gcl0Kz6Vg7GjnceIQCVHSmSbX8Bzwn0e
         w25hjxYsBT9jDuc5Zn7T1EX3Ohs/D7E+MmhHLljQXzGzaeT2q3yIZX2g6pgUwubLSHxH
         A4hrjLm2j+OZwZi188VN4LCFN8IIJe58lha+lzNN0BdHqa0whSNM+N/XL0bOZtpp72Mv
         zkYw==
X-Gm-Message-State: AOAM530O9NgyPYqPjsjlK/tDriRgVe8Yrcq9gyoptpx8cehaa+/8AvyK
        SYi9FIDxe5azOF4n1FWlXjsxq43QAEgT/I/eKQ==
X-Google-Smtp-Source: ABdhPJzQxt36wDHK60LxmB3FZlXYai5ZhbdiF7vB2nBOzLCO26BpIFf0/ahbgg4Fs4ReaN30mw62fpkC51N+xKqa/wg=
X-Received: by 2002:a17:906:1d11:: with SMTP id n17mr5129758ejh.280.1602778186719;
 Thu, 15 Oct 2020 09:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com> <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
In-Reply-To: <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 15 Oct 2020 09:09:35 -0700
Message-ID: <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
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

In receive_encrypted_standard(), server->total_read is set to the
total packet length before calling decrypt_raw_data(). The total
packet length includes the transform header but the idea of updating
server->total_read after decryption is to set it to a decrypted packet
size without the transform header (see memmove in decrypt_raw_data).

We would probably need to backport the patch to stable trees, so, I
would try to make the smallest possible change in terms of scope -
meaning just fixing the read codepath with esize mount option turned
on.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:21, Rohith Sura=
battula <rohiths.msft@gmail.com>:
>
> Hi Pavel,
>
> In receive_encrypted_standard function also, server->total_read is
> updated properly before calling decrypt_raw_data. So, no need to
> update the same field again.
>
> I have checked all instances where decrypt_raw_data is used and didn=E2=
=80=99t
> find any issue.
>
> Regards,
> Rohith
>
> On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Hi Rohith,
> >
> > Thanks for catching the problem and proposing the patch!
> >
> > I think there is a problem with just removing server->total_read
> > updates inside decrypt_raw_data():
> >
> > The same function is used in receive_encrypted_standard() which then
> > calls cifs_handle_standard(). The latter uses server->total_read in at
> > least two places: in server->ops->check_message and cifs_dump_mem().
> >
> > There may be other places in the code that assume server->total_read
> > to be correct. I would avoid simply removing this in all code paths
> > and would rather make a more specific fix for the offloaded reads.
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36, Steve Fr=
ench <smfrench@gmail.com>:
> > >
> > > Fixed up 2 small checkpatch warnings and merged into cifs-2.6.git for=
-next
> > >
> > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > <rohiths.msft@gmail.com> wrote:
> > > >
> > > > Hi All,
> > > >
> > > > With the "esize" mount option, I observed data corruption and cifs
> > > > reconnects during performance tests.
> > > >
> > > > TCP server info field server->total_read is modified parallely by
> > > > demultiplex thread and decrypt offload worker thread. server->total=
_read
> > > > is used in calculation to discard the remaining data of PDU which i=
s
> > > > not read into memory.
> > > >
> > > > Because of parallel modification, =E2=80=9Cserver->total_read=E2=80=
=9D value got
> > > > corrupted and instead of discarding the remaining data, it discarde=
d
> > > > some valid data from the next PDU.
> > > >
> > > > server->total_read field is already updated properly during read fr=
om
> > > > socket. So, no need to update the same field again after decryption=
.
> > > >
> > > > Regards,
> > > > Rohith
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
