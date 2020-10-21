Return-Path: <SRS0=ZNV/=D4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C35C4363A
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 23:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 778BC2225F
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 23:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qmenxzJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507102AbgJUX1m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Oct 2020 19:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441767AbgJUX1l (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Oct 2020 19:27:41 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67316C0613CE
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2020 16:27:41 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id o18so4274670edq.4
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2020 16:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a1RQUhBW+3jfUbh6YZGMp+J6kX1fzMPPMGUpYpYDlz0=;
        b=qmenxzJ2H+mz0tGWx9jNZR1UPvK5Y8CwR0TMezx7Q2U9va7CKtH/fTEr3cQwWxm7Cn
         YTbVEgvv6reNxU49BBnNkXKEWj/MPzOs6RbAQm+XTG2a+pYmVDe2tyw4kqdjNIdrP8Xg
         hqelHVpa2YKM58WwpJhejsoIiRyfuSWoOf48uUt1KMBHv76Q7IrqboQWq62Xmy1dS/k8
         SDZwH6C4n3LNXRLCaNqwJ0xMyBJEmDrWWX1vgjqzxCIGouinJSPFC1fsuqpoRgKnJzD+
         lyWDiQg5H9p+cwZ7QedlYAH5h1bQ3XLdOxlYG2eNak6kGvvhBVDdeg2E29cxcui8FMAY
         op+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a1RQUhBW+3jfUbh6YZGMp+J6kX1fzMPPMGUpYpYDlz0=;
        b=PRdUmbWrRNzHecpoUOm9WdDSI9nOXJkpJUVm5K8pWKubg1c39tok90dgfa/hOyU1Qi
         oy4+V5ZlTishJh+Az7knSoa6Ncgpr00s9+ormSee6ftbKa9sqO1jpEazPaQuRz6J3/GG
         ZRaBFVfi6WkctVzB0hrGpjIhnh5IROMeYfk1aKlcbL1SWGHSlTV3AQ/niYNRafXpUlRS
         qA+d/8jiE7iRA66OX95j3wt1zydfZn13qrdxcGE7/pJih4kB9A6Hl0wLZ2WKSI0JGINi
         xjy+O/sb4JsXIodTANGedGjFVFjjHkBxPahCSuo9TLM9h4eUjzh6SIG3lroyaBIHvEQZ
         uGlA==
X-Gm-Message-State: AOAM530xtkM1UA4i3mP1GRw3R16QlVPxNII3aaOvsCDw8b5OXswuBup1
        tlU6WF9KKs/9hUpUJqpWCNK4xUICWh3zi8nPrQ==
X-Google-Smtp-Source: ABdhPJyobvdEfkVDKVnaouoGL25EXOsT8J86A4remjfpkJ3YeONwE3zw/qxuJa098CXreDUubLq1MIZm40h9y2E7b/Y=
X-Received: by 2002:aa7:c68b:: with SMTP id n11mr5137006edq.340.1603322859892;
 Wed, 21 Oct 2020 16:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
 <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
 <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
 <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com>
 <CAKywueRcNLv5k2kchN6vC2t1=K9SWNNAhd6f+gJYYgGdUwEWqg@mail.gmail.com>
 <CAKywueR=uDELZrL0fQKOseS6OcCDa9X_eVXwGG55+pt9qSLrOw@mail.gmail.com>
 <CAH2r5msArhmdTHZ499eUZHbo7FEeAmxzJc-Sp5+YDWUCNMsNaQ@mail.gmail.com>
 <CAKywueQD8=FM8PYS-0VCg8bqf=ig-2FqNYeM0xptaQg2VDsw1w@mail.gmail.com> <CAH2r5msq45hNqC5u=7xu78KGxWyjJChiubbiFEKKVBmnN56q1g@mail.gmail.com>
In-Reply-To: <CAH2r5msq45hNqC5u=7xu78KGxWyjJChiubbiFEKKVBmnN56q1g@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 21 Oct 2020 16:27:28 -0700
Message-ID: <CAKywueQ8-X8ADWykywh3tMg9swzOyNyv8eMF2RSh_ChKLUMOYQ@mail.gmail.com>
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

Sounds good. Thanks!
--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 21 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 15:59, Steve Frenc=
h <smfrench@gmail.com>:
>
> updated ... I added SMB3: to the title
>
> 62593011247c SMB3: Resolve data corruption of TCP server info fields
>
> (since it was SMB3 only fix doesn't affect cifs)
>
> On Wed, Oct 21, 2020 at 4:03 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Thanks. Should we add "cifs: " prefix to the beginning of the patch
> > title? Given that the patch goes to stable this may worth doing
> > another rebase.
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=B2=D1=82, 20 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 15:08, Steve F=
rench <smfrench@gmail.com>:
> > >
> > > Added cc:stable 5.4+ and the 2 Reviewed-bys and merged into
> > > cifs-2.6.git for-next
> > >
> > > On Tue, Oct 20, 2020 at 4:43 PM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
> > > >
> > > > Any ideas about stable? esize mount option went into kernel v5.4.
> > > >
> > > > --
> > > > Best regards,
> > > > Pavel Shilovsky
> > > >
> > > > =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 09:48, Pav=
el Shilovsky <piastryyy@gmail.com>:
> > > > >
> > > > > Thanks for the patch!
> > > > >
> > > > > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > > >
> > > > > --
> > > > > Best regards,
> > > > > Pavel Shilovsky
> > > > >
> > > > > =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 00:28, R=
ohith Surabattula <rohiths.msft@gmail.com>:
> > > > > >
> > > > > > Hi Pavel,
> > > > > >
> > > > > > Corrected the patch with the suggested changes.
> > > > > > Attached the patch.
> > > > > >
> > > > > > Regards,
> > > > > > Rohith
> > > > > >
> > > > > > On Thu, Oct 15, 2020 at 9:39 PM Pavel Shilovsky <piastryyy@gmai=
l.com> wrote:
> > > > > > >
> > > > > > > In receive_encrypted_standard(), server->total_read is set to=
 the
> > > > > > > total packet length before calling decrypt_raw_data(). The to=
tal
> > > > > > > packet length includes the transform header but the idea of u=
pdating
> > > > > > > server->total_read after decryption is to set it to a decrypt=
ed packet
> > > > > > > size without the transform header (see memmove in decrypt_raw=
_data).
> > > > > > >
> > > > > > > We would probably need to backport the patch to stable trees,=
 so, I
> > > > > > > would try to make the smallest possible change in terms of sc=
ope -
> > > > > > > meaning just fixing the read codepath with esize mount option=
 turned
> > > > > > > on.
> > > > > > >
> > > > > > > --
> > > > > > > Best regards,
> > > > > > > Pavel Shilovsky
> > > > > > >
> > > > > > > =D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:2=
1, Rohith Surabattula <rohiths.msft@gmail.com>:
> > > > > > > >
> > > > > > > > Hi Pavel,
> > > > > > > >
> > > > > > > > In receive_encrypted_standard function also, server->total_=
read is
> > > > > > > > updated properly before calling decrypt_raw_data. So, no ne=
ed to
> > > > > > > > update the same field again.
> > > > > > > >
> > > > > > > > I have checked all instances where decrypt_raw_data is used=
 and didn=E2=80=99t
> > > > > > > > find any issue.
> > > > > > > >
> > > > > > > > Regards,
> > > > > > > > Rohith
> > > > > > > >
> > > > > > > > On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@=
gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > Hi Rohith,
> > > > > > > > >
> > > > > > > > > Thanks for catching the problem and proposing the patch!
> > > > > > > > >
> > > > > > > > > I think there is a problem with just removing server->tot=
al_read
> > > > > > > > > updates inside decrypt_raw_data():
> > > > > > > > >
> > > > > > > > > The same function is used in receive_encrypted_standard()=
 which then
> > > > > > > > > calls cifs_handle_standard(). The latter uses server->tot=
al_read in at
> > > > > > > > > least two places: in server->ops->check_message and cifs_=
dump_mem().
> > > > > > > > >
> > > > > > > > > There may be other places in the code that assume server-=
>total_read
> > > > > > > > > to be correct. I would avoid simply removing this in all =
code paths
> > > > > > > > > and would rather make a more specific fix for the offload=
ed reads.
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > Best regards,
> > > > > > > > > Pavel Shilovsky
> > > > > > > > >
> > > > > > > > > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 1=
3:36, Steve French <smfrench@gmail.com>:
> > > > > > > > > >
> > > > > > > > > > Fixed up 2 small checkpatch warnings and merged into ci=
fs-2.6.git for-next
> > > > > > > > > >
> > > > > > > > > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > > > > > > > > <rohiths.msft@gmail.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > Hi All,
> > > > > > > > > > >
> > > > > > > > > > > With the "esize" mount option, I observed data corrup=
tion and cifs
> > > > > > > > > > > reconnects during performance tests.
> > > > > > > > > > >
> > > > > > > > > > > TCP server info field server->total_read is modified =
parallely by
> > > > > > > > > > > demultiplex thread and decrypt offload worker thread.=
 server->total_read
> > > > > > > > > > > is used in calculation to discard the remaining data =
of PDU which is
> > > > > > > > > > > not read into memory.
> > > > > > > > > > >
> > > > > > > > > > > Because of parallel modification, =E2=80=9Cserver->to=
tal_read=E2=80=9D value got
> > > > > > > > > > > corrupted and instead of discarding the remaining dat=
a, it discarded
> > > > > > > > > > > some valid data from the next PDU.
> > > > > > > > > > >
> > > > > > > > > > > server->total_read field is already updated properly =
during read from
> > > > > > > > > > > socket. So, no need to update the same field again af=
ter decryption.
> > > > > > > > > > >
> > > > > > > > > > > Regards,
> > > > > > > > > > > Rohith
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > --
> > > > > > > > > > Thanks,
> > > > > > > > > >
> > > > > > > > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
