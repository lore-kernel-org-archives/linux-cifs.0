Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90C5C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 06:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6B661040
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 06:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbhJFGyG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 02:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236777AbhJFGyG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 6 Oct 2021 02:54:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DC661040
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 06:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633503134;
        bh=A7c8a3AY32HQOhcFefxH3v1W7I0/oIZzuKQ2d10TG3c=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VMvQyIUTa3+TN6oVOWxEbK4FG5G1iz2ITklHVb45okKu1WJAuitFgWangEZ4fvWe6
         mzRMDyNMtuObm//ktIHZ94SVyeoTxnZGXL4PbWQjFlCJ+4kZw+3UOYHYNuEAupr4nX
         2IKKNZktgucTm7absiBiS3cIGquwXKypbBvKQ6eGileeuH6WJFcRLF/D77DmsDqVl9
         m6N0kagK7cXBgEXlaKJXkcezZCbbx+klQTP3/PnXZAGyW8dWPsIvnLGyKj/NoOlXz+
         kF/AnE8GCLI+ZaTCe3rodj4khsCzOphhku83fsb29ZatDO+68AxSWvAdodi+yM+kbN
         +BanVNwzLQmeA==
Received: by mail-oo1-f53.google.com with SMTP id y16-20020a4ade10000000b002b5dd6f4c8dso536115oot.12
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 23:52:14 -0700 (PDT)
X-Gm-Message-State: AOAM533HPb7tXxacu3Eg7RxeXCtBItbGJN3t5/nTTLGW/T/b9xV80mg2
        XuRUaSlq7UMqqplHJsnQ6lEU+8B2L6ozOMnjvaQ=
X-Google-Smtp-Source: ABdhPJxNmSMpTWstq5Tazznc88hio4B94rSu6S9mQBYPj/661/X5U/EG/uBjErQbqO5KXsK52HXt92mah1Cq+Zlqa2E=
X-Received: by 2002:a4a:c18d:: with SMTP id w13mr16893808oop.15.1633503133746;
 Tue, 05 Oct 2021 23:52:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 23:52:13 -0700 (PDT)
In-Reply-To: <CANFS6baHtcO5gHSC=c76nTHn65ObAACJMq0c5uhxsxPuyEEOiw@mail.gmail.com>
References: <20211005100026.250280-1-hyc.lee@gmail.com> <CAKYAXd9KuopMe8B_BrjxXDv+XZe6=_uWXoNXv6_f8YxYMAiTiA@mail.gmail.com>
 <CANFS6baHtcO5gHSC=c76nTHn65ObAACJMq0c5uhxsxPuyEEOiw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 6 Oct 2021 15:52:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9_VjDDBAbDZqoM=bpjmxEnhh3Q0QbFaKHT3iLO9Z85nQ@mail.gmail.com>
Message-ID: <CAKYAXd9_VjDDBAbDZqoM=bpjmxEnhh3Q0QbFaKHT3iLO9Z85nQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: improve credits management
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-06 15:27 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2021=EB=85=84 10=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 11:06=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> [snip]
>> >
>> > -     if (credits_requested > 0) {
>> > +     /* We must grant 0 credit for the final response of an
>> > asynchronous
>> > +      * operation.
>> > +      */
>> > +     if ((hdr->Flags & SMB2_FLAGS_ASYNC_COMMAND) && !work->multiRsp) =
{
>> Can you elaborate what is this check ? especially this !work->multiRsp..
>
> According to 3.3.4.2 Sending an Interim Response for an Asynchronous
> Operation
> in MS-SMB2,
> For the request that will be handled asynchronously,  a server should sen=
d
> an interim response, and grant credits to the interim response.
> on the other hand, a server should grant 0 credit to the final response f=
or
> the
> request.
>
> "hdr->Flags & SMB2_FLAGS_ASYNC" means that a response is an interim
> or final, and "work->multiRsp =3D=3D 0" means that a response is final. S=
o in
> this
> case, a server should grant 0 credit.
Okay.
>
>> > +             credits_granted =3D 0;
>> > +     } else {
>> > +             /* according to smb2.credits smbtorture, Windows server
>> > +              * 2016 or later grant up to 8192 credits at one.
>> > +              */
>> >               aux_credits =3D credits_requested - 1;
>> > -             aux_max =3D 32;
>> >               if (hdr->Command =3D=3D SMB2_NEGOTIATE)
>> >                       aux_max =3D 0;
>> > -             aux_credits =3D (aux_credits < aux_max) ? aux_credits :
>> > aux_max;
>> > -             credits_granted =3D aux_credits + credit_charge;
>> > +             else
>> > +                     aux_max =3D conn->max_credits - credit_charge;
>> > +             aux_credits =3D min_t(unsigned short, aux_credits,
>> > aux_max);
>> > +             credits_granted =3D credit_charge + aux_credits;
>> > +
>> > +             if (conn->max_credits - conn->total_credits <
>> > credits_granted)
>> > +                     credits_granted =3D conn->max_credits -
>> > +                             conn->total_credits;
>> >
>> > -             /* if credits granted per client is getting bigger than
>> > default
>> > -              * minimum credits then we should wrap it up within the
>> > limits.
>> > -              */
>> > -             if ((conn->total_credits + credits_granted) >
>> > min_credits)
>> > -                     credits_granted =3D min_credits -
>> > conn->total_credits;
>> >               /*
>> >                * TODO: Need to adjuct CreditRequest value according to
>> >                * current cpu load
>> >                */
>> > -     } else if (conn->total_credits =3D=3D 0) {
>> > -             credits_granted =3D 1;
>> >       }
>> >
>> >       conn->total_credits +=3D credits_granted;
>> > @@ -371,7 +358,6 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
>> >               /* Update CreditRequest in last request */
>> >               hdr->CreditRequest =3D cpu_to_le16(work->credits_granted=
);
>> >       }
>> > -out:
>> >       ksmbd_debug(SMB,
>> >                   "credits: requested[%d] granted[%d]
>> > total_granted[%d]\n",
>> >                   credits_requested, credits_granted,
>> > @@ -692,13 +678,18 @@ int setup_async_work(struct ksmbd_work *work,
>> > void
>> > (*fn)(void **), void **arg)
>> >
>> >  void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
>> >  {
>> > -     struct smb2_hdr *rsp_hdr;
>> > +     struct smb2_hdr *rsp_hdr =3D work->response_buf;
>> > +
>> > +     work->multiRsp =3D 1;
>> > +     if (status !=3D STATUS_CANCELLED) {
>> > +             spin_lock(&work->conn->credits_lock);
>> > +             smb2_set_rsp_credits(work);
>> Can you explain why this code is needed in smb2_send_interim_resp() ?
>>
>
> As I wrote above, a server should grant credits to an interim
> response.
Okay.
>
>> > +             spin_unlock(&work->conn->credits_lock);
>> > +     }
>> >
>> > -     rsp_hdr =3D work->response_buf;
>> >       smb2_set_err_rsp(work);
>> >       rsp_hdr->Status =3D status;
>> >
>> > -     work->multiRsp =3D 1;
>> >       ksmbd_conn_write(work);
>> >       rsp_hdr->Status =3D 0;
>> >       work->multiRsp =3D 0;
>> > @@ -1233,6 +1224,7 @@ int smb2_handle_negotiate(struct ksmbd_work
>> > *work)
>> >
>> >       conn->srv_sec_mode =3D le16_to_cpu(rsp->SecurityMode);
>> >       ksmbd_conn_set_need_negotiate(work);
>> > +     conn->total_credits =3D 0;
>> This line is needed ?
>
> Yes, conn->total_credits becomes 0 when receiving a SMB2_NEGOTIATION
> request. But init_smbX_X_server functions are called many times and
> conn->total_credits is set to 1 in these functions while negotiation.
If so, can we move conn->total_credits =3D 1 in  init_smbX_X_server() to
ksmbd_conn_alloc() ?
>
>>
>> Thanks!
>> >
>> >  err_out:
>> >       if (rc < 0)
>> > --
>> > 2.25.1
>> >
>> >
>
>
>
> --
> Thanks,
> Hyunchul
>
