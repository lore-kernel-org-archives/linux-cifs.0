Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFCAC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 08:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92DE66136F
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 08:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhJDJA2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Oct 2021 05:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhJDJA2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 4 Oct 2021 05:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E6D6137C
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 08:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633337919;
        bh=eDND+f0opgoYlH1zhUhHcAyhYOMyEY9EhdFTjOVeItE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=AdFR8Apf2HqAlciwum5WkwklFid3YWvs9aln7LF9t1wSD0vM9Sc1qXRCppajuJRPS
         3o6obp2qKkIYPq1UeFoyl43Yr5Qx3jdg0IGRyGqEW5Cm0htke1SFGISFKhZEK6tSMf
         B4U8iiwC0vUtDtIvr0IKvwcmMFFLwau7MAZuhnXovNR6QQ+i/rWa9PFlZAlkXzRbuw
         Ouo02KReLmmGhnyAlDHHI2DQHT97kY7Y8zTblKFbZ7g3Fz+fSTIzkNy1Qm4+tTNhe8
         SZQpeTqNSYlym6vOKZAZeUzDkDdQsX4zA+UFDBWeZWIVOTjq4JqWP0Omg3LkZRkCcX
         epwdOCCdi1emA==
Received: by mail-oo1-f49.google.com with SMTP id z11-20020a4ad1ab000000b0029f085f5f64so5148846oor.5
        for <linux-cifs@vger.kernel.org>; Mon, 04 Oct 2021 01:58:39 -0700 (PDT)
X-Gm-Message-State: AOAM530eQi04pgANDG/gJKHjn68Tz7f7zlLSrh2i7StSCns1/f6o+opn
        XWGMrKCoxkcILUVGwz2LsEdqsktAFqwr4NAAMs8=
X-Google-Smtp-Source: ABdhPJzKySadLDCxSsjsAdCqUfjooDq50XEzDlTLgE4ujJkkc96IPL056NDPd9SqSUrqphQ2D4m71xBBt+ZriBi1mdg=
X-Received: by 2002:a4a:b78c:: with SMTP id a12mr8331513oop.58.1633337918895;
 Mon, 04 Oct 2021 01:58:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 4 Oct 2021 01:58:38 -0700 (PDT)
In-Reply-To: <CANFS6bb+hqid_YvkkSnMajwsQeOF_6NFke5ffuRVnPVoiHdKug@mail.gmail.com>
References: <20211003043105.10453-1-linkinjeon@kernel.org> <CANFS6bb+hqid_YvkkSnMajwsQeOF_6NFke5ffuRVnPVoiHdKug@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 4 Oct 2021 17:58:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Cyv2qXgGmuGKQn1jr8SQu4kF4wyMrDxeAt_8Ao4pudg@mail.gmail.com>
Message-ID: <CAKYAXd-Cyv2qXgGmuGKQn1jr8SQu4kF4wyMrDxeAt_8Ao4pudg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: use buf_data_size instead of recalculation in smb3_decrypt_req()
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-04 17:38 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2021=EB=85=84 10=EC=9B=94 3=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 1:31,=
 Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> Tom suggested to use buf_data_size that is already calculated, to verify
>> these offsets.
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Suggested-by: Tom Talpey <tom@talpey.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/smb2pdu.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index b06361313889..4d1be224dd8e 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -8457,15 +8457,13 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>>         struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_hdr
>> *)buf;
>>         int rc =3D 0;
>>
>> -       if (pdu_length + 4 <
>> -           sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr))
>> {
>> +       if (buf_data_size < sizeof(struct smb2_hdr)) {
>
> Could integer overflow occur when buf_data_size is initialized?
> buf_data_size is initialized with "pdu_length + 4 -
> sizeof(struct smb2_transform_hdr)".
overflow does not occur. See the comments below.
>
> There was the check that the pdu size is greater than at least
> __SMB2_HEADER_STRUCTURE_SIZE at ksmbd_conn_handler_loop(),
> But I can't find this check in the latest patch set.
Please check "ksmbd: add the check to vaildate if stream protocol
length exceeds maximum value". pdu_length will never exceed
MAX_STREAM_PROT_LEN(0x00FFFFFF).

Thanks!
>
>
>>                 pr_err("Transform message is too small (%u)\n",
>>                        pdu_length);
>>                 return -ECONNABORTED;
>>         }
>>
>> -       if (pdu_length + 4 <
>> -           le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct
>> smb2_transform_hdr)) {
>> +       if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) {
>>                 pr_err("Transform message is broken\n");
>>                 return -ECONNABORTED;
>>         }
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
