Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0662C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 13:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAE8360F24
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 13:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhJKNqx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhJKNqw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 11 Oct 2021 09:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D07F360EB4
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 13:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633959892;
        bh=/6G21UJT/qK1gxNt8adzVnMsVcOHLnBB/6L5+dNtAFE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=DVD/WN55zWZCdlDp42ju4u6pkoUAVqxcZlTmDzQ/mjxen8V25JwyKmyVI+/SxhxFa
         14ncYjoPj6ZAo0xcoAyxgU/I96cI7RNhncgOR7AWauMHHPktUvHENOkyp1ejnd5QPP
         QBmuVQ+/LqmgiL9vXpaaXgJcU7+Ju6RlehFiU4piPjvRIY7K6m1rvqIC9fbF7sjo/Q
         urJx3ab+5xXHJllL9Sww9emiSElSarMYoptgaFYcG3mWXHJ6c/07JUqwpB11ZrkZbE
         6KYCmkZXUAYLzVzK2zk07DlyoEiIdndxydx7LlR4iyvWURFJCoaSz99+UH1ZkEtPhd
         8qsqj/n0N1Gaw==
Received: by mail-oo1-f51.google.com with SMTP id r1-20020a4a9641000000b002b6b55007bfso3223441ooi.3
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 06:44:52 -0700 (PDT)
X-Gm-Message-State: AOAM530wuMhDeC7BzWnIXuUmua6F0pKjWhap5M85TYhVoK52l7TpQxbp
        FVYQQ302sndLXrE05XNbdchlo3EEehNK8b+hmpE=
X-Google-Smtp-Source: ABdhPJwMf3uj/uvnsKJ7NFq7AuPUQ8KS72qovk1QWJwnmih8shuvjafj6RJp2gTA1rTG3rWJKzVVW/FSUyCrRLe6Fc4=
X-Received: by 2002:a4a:c18d:: with SMTP id w13mr19201647oop.15.1633959892181;
 Mon, 11 Oct 2021 06:44:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Mon, 11 Oct 2021 06:44:51
 -0700 (PDT)
In-Reply-To: <CANFS6baOvbRbtTDDtDJr1s_7h50=BEGMZHHiogk8FXbtty03Gg@mail.gmail.com>
References: <20211008032931.60797-1-linkinjeon@kernel.org> <CANFS6baOvbRbtTDDtDJr1s_7h50=BEGMZHHiogk8FXbtty03Gg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 11 Oct 2021 22:44:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9fGewmd_-WreuNeFpWOVpDE7SBOtcGaOuha+qxagpcag@mail.gmail.com>
Message-ID: <CAKYAXd9fGewmd_-WreuNeFpWOVpDE7SBOtcGaOuha+qxagpcag@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: limit read/write/trans buffer size not to
 exceed MAX_STREAM_PROT_LEN
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

2021-10-11 21:28 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2021=EB=85=84 10=EC=9B=94 8=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:29=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> ksmbd limit read/write/trans buffer size not to exceed
>> maximum stream protocol length(0x00FFFFFF).
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  v2:
>>   - change 8MB limitation to MAX_STREAM_PROT_LEN.
>>
>>  fs/ksmbd/smb2ops.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
>> index b06456eb587b..63289872da97 100644
>> --- a/fs/ksmbd/smb2ops.c
>> +++ b/fs/ksmbd/smb2ops.c
>> @@ -284,6 +284,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
>>
>>  void init_smb2_max_read_size(unsigned int sz)
>>  {
>> +       sz =3D min_t(u32, sz, MAX_STREAM_PROT_LEN);
>
> If the maximum read size is MAX_STREAM_PROT_LEN, couldn't headers +
> data exceed MAX_STREAM_PROT_LEN?
Right, I will fix it on v3.

Thanks!
>
>>         smb21_server_values.max_read_size =3D sz;
>>         smb30_server_values.max_read_size =3D sz;
>>         smb302_server_values.max_read_size =3D sz;
>> @@ -292,6 +293,7 @@ void init_smb2_max_read_size(unsigned int sz)
>>
>>  void init_smb2_max_write_size(unsigned int sz)
>>  {
>> +       sz =3D min_t(u32, sz, MAX_STREAM_PROT_LEN);
>>         smb21_server_values.max_write_size =3D sz;
>>         smb30_server_values.max_write_size =3D sz;
>>         smb302_server_values.max_write_size =3D sz;
>> @@ -300,6 +302,7 @@ void init_smb2_max_write_size(unsigned int sz)
>>
>>  void init_smb2_max_trans_size(unsigned int sz)
>>  {
>> +       sz =3D min_t(u32, sz, MAX_STREAM_PROT_LEN);
>>         smb21_server_values.max_trans_size =3D sz;
>>         smb30_server_values.max_trans_size =3D sz;
>>         smb302_server_values.max_trans_size =3D sz;
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
