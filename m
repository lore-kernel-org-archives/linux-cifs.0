Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F15C4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 22:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41AB822256
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 22:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ng446V7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393435AbgJTWIl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 18:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393142AbgJTWIl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Oct 2020 18:08:41 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D59C0613CE
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 15:08:41 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id x16so6264ljh.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 15:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qg/GwBnqnDkolgzylLrj53jT27RDzpQ7/B/8tD4wG5w=;
        b=Ng446V7WiRc9P/luoMwvkZUdJkDN+gbpzUdsWknhIl6iVszSnh9ueFixC8p7nGhR5z
         3a3c9TRTd81Ytnno2ia1WIEGiyu82e29rAk7ta+NhGtrrRkPBcS7/w4/50NjkMWE7frd
         CDdtyGfMKiOl+SQleoAn5I1qeE63tK/3yCCqsadP/mVwVwOMuAjWqTP343xRdWXqNBfN
         SwPoaKSqJ6EsZDr+L1kfWqxwH0TCv93COIeoY4uXx3/FAY/I/1HqchlwhcpbFu0VrL+J
         gRKCKlsGip6lubP72JqQX92FGEg1ivs1VOsXIfCMYRkP5JVhkTCCLlL6P25ikFmluXtB
         Qt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qg/GwBnqnDkolgzylLrj53jT27RDzpQ7/B/8tD4wG5w=;
        b=olkUSeGjgq15LxLAzmGVNgdAxVN4pnS+keZUd5zcGeagm6ou2PUTymucX5Wq5kGOhk
         9STYKwdtVm/yNxIAkeUg4gnBC1XrVzWwWB2GyaO+SNoin1hziNgytouXExxLMgGgh7he
         /u5FYKe7U5cu6WJvkrLkRjeUvU7GaFXOnMe8I1v4WqQKaSu/n953RClVp84CMLN9bdED
         Wapyaugq7k3PzOQhzCNcSfJgruSNn8UzmFDF7WgWZxrLI+bLt2XxijnYjTIWPln2L5Ig
         9eomsXteJkQe6rDebfrx5VUdFXleTVUNIGNZMN3q7jxDqArhj6rwWlQHniOhZaXCjdvZ
         vDPg==
X-Gm-Message-State: AOAM5317hWedy2q90FKN0HqdjHftTYt5pCSqVR4130kDFTSyTIucOs1C
        phXLumqsNeL1HXBbcNSlq3HZna/warmtP4o35JdRNGct7IU=
X-Google-Smtp-Source: ABdhPJwwWfpaglfLp3vBbsIX7bpmw0lD1IAq1JIq8wns9BJ/+1jMBfetrTodBATdO2g8HYpDoxtGdTIE6+LoaipRPQo=
X-Received: by 2002:a2e:b009:: with SMTP id y9mr104200ljk.372.1603231719770;
 Tue, 20 Oct 2020 15:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
 <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
 <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
 <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com>
 <CAKywueRcNLv5k2kchN6vC2t1=K9SWNNAhd6f+gJYYgGdUwEWqg@mail.gmail.com> <CAKywueR=uDELZrL0fQKOseS6OcCDa9X_eVXwGG55+pt9qSLrOw@mail.gmail.com>
In-Reply-To: <CAKywueR=uDELZrL0fQKOseS6OcCDa9X_eVXwGG55+pt9qSLrOw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Oct 2020 17:08:28 -0500
Message-ID: <CAH2r5msArhmdTHZ499eUZHbo7FEeAmxzJc-Sp5+YDWUCNMsNaQ@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Rohith Surabattula <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added cc:stable 5.4+ and the 2 Reviewed-bys and merged into
cifs-2.6.git for-next

On Tue, Oct 20, 2020 at 4:43 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Any ideas about stable? esize mount option went into kernel v5.4.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 09:48, Pavel Shi=
lovsky <piastryyy@gmail.com>:
> >
> > Thanks for the patch!
> >
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 00:28, Rohith =
Surabattula <rohiths.msft@gmail.com>:
> > >
> > > Hi Pavel,
> > >
> > > Corrected the patch with the suggested changes.
> > > Attached the patch.
> > >
> > > Regards,
> > > Rohith
> > >
> > > On Thu, Oct 15, 2020 at 9:39 PM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
> > > >
> > > > In receive_encrypted_standard(), server->total_read is set to the
> > > > total packet length before calling decrypt_raw_data(). The total
> > > > packet length includes the transform header but the idea of updatin=
g
> > > > server->total_read after decryption is to set it to a decrypted pac=
ket
> > > > size without the transform header (see memmove in decrypt_raw_data)=
.
> > > >
> > > > We would probably need to backport the patch to stable trees, so, I
> > > > would try to make the smallest possible change in terms of scope -
> > > > meaning just fixing the read codepath with esize mount option turne=
d
> > > > on.
> > > >
> > > > --
> > > > Best regards,
> > > > Pavel Shilovsky
> > > >
> > > > =D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:21, Roh=
ith Surabattula <rohiths.msft@gmail.com>:
> > > > >
> > > > > Hi Pavel,
> > > > >
> > > > > In receive_encrypted_standard function also, server->total_read i=
s
> > > > > updated properly before calling decrypt_raw_data. So, no need to
> > > > > update the same field again.
> > > > >
> > > > > I have checked all instances where decrypt_raw_data is used and d=
idn=E2=80=99t
> > > > > find any issue.
> > > > >
> > > > > Regards,
> > > > > Rohith
> > > > >
> > > > > On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gmail.=
com> wrote:
> > > > > >
> > > > > > Hi Rohith,
> > > > > >
> > > > > > Thanks for catching the problem and proposing the patch!
> > > > > >
> > > > > > I think there is a problem with just removing server->total_rea=
d
> > > > > > updates inside decrypt_raw_data():
> > > > > >
> > > > > > The same function is used in receive_encrypted_standard() which=
 then
> > > > > > calls cifs_handle_standard(). The latter uses server->total_rea=
d in at
> > > > > > least two places: in server->ops->check_message and cifs_dump_m=
em().
> > > > > >
> > > > > > There may be other places in the code that assume server->total=
_read
> > > > > > to be correct. I would avoid simply removing this in all code p=
aths
> > > > > > and would rather make a more specific fix for the offloaded rea=
ds.
> > > > > >
> > > > > > --
> > > > > > Best regards,
> > > > > > Pavel Shilovsky
> > > > > >
> > > > > > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36, =
Steve French <smfrench@gmail.com>:
> > > > > > >
> > > > > > > Fixed up 2 small checkpatch warnings and merged into cifs-2.6=
.git for-next
> > > > > > >
> > > > > > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > > > > > <rohiths.msft@gmail.com> wrote:
> > > > > > > >
> > > > > > > > Hi All,
> > > > > > > >
> > > > > > > > With the "esize" mount option, I observed data corruption a=
nd cifs
> > > > > > > > reconnects during performance tests.
> > > > > > > >
> > > > > > > > TCP server info field server->total_read is modified parall=
ely by
> > > > > > > > demultiplex thread and decrypt offload worker thread. serve=
r->total_read
> > > > > > > > is used in calculation to discard the remaining data of PDU=
 which is
> > > > > > > > not read into memory.
> > > > > > > >
> > > > > > > > Because of parallel modification, =E2=80=9Cserver->total_re=
ad=E2=80=9D value got
> > > > > > > > corrupted and instead of discarding the remaining data, it =
discarded
> > > > > > > > some valid data from the next PDU.
> > > > > > > >
> > > > > > > > server->total_read field is already updated properly during=
 read from
> > > > > > > > socket. So, no need to update the same field again after de=
cryption.
> > > > > > > >
> > > > > > > > Regards,
> > > > > > > > Rohith
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Thanks,
> > > > > > >
> > > > > > > Steve



--=20
Thanks,

Steve
