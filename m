Return-Path: <SRS0=xrBw=D2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9241C433E7
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 16:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C2D22260
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 16:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Num8X8u/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgJSQs6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730186AbgJSQs6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Oct 2020 12:48:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B2BC0613CE
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 09:48:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ce10so20187ejc.5
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 09:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UjssIQ+hrMzjuE6trlL/E+rsGTJ0iY/VjmjzQzpU3jc=;
        b=Num8X8u/+GCcCfuRxkPDvEucKOaBLI/nKIX9fHE/hz8YXySprYHVB4dnF40J9qB1ZG
         nemiJMvN5f7RAazW4/q9hFweW9S0sMInOE2IpejG2GxoeRVpAfxmwBNkkf2g//ASF/v4
         ArdWsV4d3wNIxpS51QLixVhAhvLxbzybTuder0ubMR9lH7hOh51IVYyizU1siAvWQKDA
         Um4awi1+ZHKFKm8d86LTMAaxlu0SAEikrIGB3DPnXyAFAO7SLbUCkymT05+cGawKFfEf
         ykra5nBGDu7O2gVL7RXZD+v/0FSyJV9WunSmw+iLp8b9Au6P3REwVWXi3bjjzC9721nQ
         oUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UjssIQ+hrMzjuE6trlL/E+rsGTJ0iY/VjmjzQzpU3jc=;
        b=fqCPskTb7vNmk5ypfkxQKdwamvWTUbw7kTfv9V8mtAB6ASTNIas6Ejl7v+IGQGa9TF
         jPOVsFp0SPXuuhRK59k1SY/I6kOFz3DGzEQ5J3zMW2+OosVU/ra9f3B/0PAqh2TtQ5bA
         c/mDSdxVaCBi3k9YhG2GtdiIdp5ZJMxMxBA1i+uuZTMsOriovd+XEyezQufS6AQSklUK
         fJ051zd/sGwoJ53VdGWdCFpB3L9Pom0o+UOLmsdII3yN30gD5FcjILjyPGif1DTWeYMc
         NRisF1ndK+jv1ejUs6PZyAJN2XPnsrhXorF/qcDlOtbCBdseFIEUMZm6jDelbnrwgCev
         S4sw==
X-Gm-Message-State: AOAM532mOelOHP16jSRyxXE6bHDXQ4U2teQHWzALXENTQOyInoaTuU9L
        S277NcQrieFm5FmcVLdzgWfpftqogmm66AM7Sg==
X-Google-Smtp-Source: ABdhPJzGGXGZthwLPyC2YECfNHLsCE3NIkPRFEopINO4pM/TKHOAtOrFUXDddoxBTc2lvtc5cQSEE2GTRMwFUUTStwE=
X-Received: by 2002:a17:906:1d11:: with SMTP id n17mr791481ejh.280.1603126137002;
 Mon, 19 Oct 2020 09:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
 <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
 <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com> <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com>
In-Reply-To: <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 19 Oct 2020 09:48:45 -0700
Message-ID: <CAKywueRcNLv5k2kchN6vC2t1=K9SWNNAhd6f+gJYYgGdUwEWqg@mail.gmail.com>
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

Thanks for the patch!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 19 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 00:28, Rohith Sura=
battula <rohiths.msft@gmail.com>:
>
> Hi Pavel,
>
> Corrected the patch with the suggested changes.
> Attached the patch.
>
> Regards,
> Rohith
>
> On Thu, Oct 15, 2020 at 9:39 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > In receive_encrypted_standard(), server->total_read is set to the
> > total packet length before calling decrypt_raw_data(). The total
> > packet length includes the transform header but the idea of updating
> > server->total_read after decryption is to set it to a decrypted packet
> > size without the transform header (see memmove in decrypt_raw_data).
> >
> > We would probably need to backport the patch to stable trees, so, I
> > would try to make the smallest possible change in terms of scope -
> > meaning just fixing the read codepath with esize mount option turned
> > on.
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:21, Rohith =
Surabattula <rohiths.msft@gmail.com>:
> > >
> > > Hi Pavel,
> > >
> > > In receive_encrypted_standard function also, server->total_read is
> > > updated properly before calling decrypt_raw_data. So, no need to
> > > update the same field again.
> > >
> > > I have checked all instances where decrypt_raw_data is used and didn=
=E2=80=99t
> > > find any issue.
> > >
> > > Regards,
> > > Rohith
> > >
> > > On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
> > > >
> > > > Hi Rohith,
> > > >
> > > > Thanks for catching the problem and proposing the patch!
> > > >
> > > > I think there is a problem with just removing server->total_read
> > > > updates inside decrypt_raw_data():
> > > >
> > > > The same function is used in receive_encrypted_standard() which the=
n
> > > > calls cifs_handle_standard(). The latter uses server->total_read in=
 at
> > > > least two places: in server->ops->check_message and cifs_dump_mem()=
.
> > > >
> > > > There may be other places in the code that assume server->total_rea=
d
> > > > to be correct. I would avoid simply removing this in all code paths
> > > > and would rather make a more specific fix for the offloaded reads.
> > > >
> > > > --
> > > > Best regards,
> > > > Pavel Shilovsky
> > > >
> > > > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36, Stev=
e French <smfrench@gmail.com>:
> > > > >
> > > > > Fixed up 2 small checkpatch warnings and merged into cifs-2.6.git=
 for-next
> > > > >
> > > > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > > > <rohiths.msft@gmail.com> wrote:
> > > > > >
> > > > > > Hi All,
> > > > > >
> > > > > > With the "esize" mount option, I observed data corruption and c=
ifs
> > > > > > reconnects during performance tests.
> > > > > >
> > > > > > TCP server info field server->total_read is modified parallely =
by
> > > > > > demultiplex thread and decrypt offload worker thread. server->t=
otal_read
> > > > > > is used in calculation to discard the remaining data of PDU whi=
ch is
> > > > > > not read into memory.
> > > > > >
> > > > > > Because of parallel modification, =E2=80=9Cserver->total_read=
=E2=80=9D value got
> > > > > > corrupted and instead of discarding the remaining data, it disc=
arded
> > > > > > some valid data from the next PDU.
> > > > > >
> > > > > > server->total_read field is already updated properly during rea=
d from
> > > > > > socket. So, no need to update the same field again after decryp=
tion.
> > > > > >
> > > > > > Regards,
> > > > > > Rohith
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
