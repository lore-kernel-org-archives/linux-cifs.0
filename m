Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8544BC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE3F61268
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhIYJZh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 05:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhIYJZg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 25 Sep 2021 05:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 856A26127A
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 09:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632561842;
        bh=4kzPmOd/cHqQVLMPNYAwdzBj6BXQIvnILG9hV8LbXQ4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=n36HkFqhoLnJVwVJykDbZ6qVd51Si9inG05noS8NYkYy21forExLPAXs3BBUjW5uS
         ZGJAMTMmwUCWWSu8xmkLPZtSUDRlEQ8uGIh2YaHgYCvcPC6G303imov5VriXwOGvQy
         Y9IJ6ZLflx9JehAmMFkXt4ejHGWBq1888UxG1l2iv3ypMssTOffRkfdSZGS4MveF+3
         J5Na38Juu3cbQj3YTuEEDThaIzB9BEeBgZ+LQM8ZanwfsrvuYmkBtnXXADfxXk1uc+
         FFaaAR0ZXbX+GhGjgzPFDt7m/reluGrj5kRQ64zcqW8UtQKoiGoJ/WYXHAlp9J/OLC
         /D1CHAXN9BphQ==
Received: by mail-ot1-f44.google.com with SMTP id 67-20020a9d0449000000b00546e5a8062aso16614389otc.9
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 02:24:02 -0700 (PDT)
X-Gm-Message-State: AOAM531YPplPPnsQw3IECQj3CmdfK6ZcAKP4aQ3xPastkf29AbVFEpji
        kKYcDqjdpnnC2llFIp9UhzVavwSYAu71YoZqbnY=
X-Google-Smtp-Source: ABdhPJxqNcOwfLqauVMZCVafOr9zME5THWJ2XT+xxC6VDjm4gLjrdmK2Umzh/XV1I+M1J4DXNRZWyKvJisueXF+kHvg=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr7940881otf.237.1632561841938;
 Sat, 25 Sep 2021 02:24:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 25 Sep 2021 02:24:01
 -0700 (PDT)
In-Reply-To: <CANFS6baqgQeHdQwmfekMVC2u_FaAkUgfr3BMhBHDEKKr+1J=wA@mail.gmail.com>
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-6-linkinjeon@kernel.org>
 <CANFS6baqgQeHdQwmfekMVC2u_FaAkUgfr3BMhBHDEKKr+1J=wA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Sep 2021 18:24:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Ej3hM7qa7UXvCru0=0yA30fYVH3=GVwir6ZcSOhzfNg@mail.gmail.com>
Message-ID: <CAKYAXd9Ej3hM7qa7UXvCru0=0yA30fYVH3=GVwir6ZcSOhzfNg@mail.gmail.com>
Subject: Re: [PATCH 5/7] ksmbd: add the check to vaildate if stream protocol
 length exceeds maximum value
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

2021-09-25 17:41 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> This patch add MAX_STREAM_PROT_LEN macro and check if stream protocol
>> length exceeds maximum value. opencode pdu size check in
>> ksmbd_pdu_size_has_room().
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/connection.c | 10 ++++++----
>>  fs/ksmbd/smb_common.c |  6 ------
>>  fs/ksmbd/smb_common.h |  4 ++--
>>  3 files changed, 8 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
>> index af086d35398a..48b18b4ec117 100644
>> --- a/fs/ksmbd/connection.c
>> +++ b/fs/ksmbd/connection.c
>> @@ -296,10 +296,12 @@ int ksmbd_conn_handler_loop(void *p)
>>                 pdu_size =3D get_rfc1002_len(hdr_buf);
>>                 ksmbd_debug(CONN, "RFC1002 header %u bytes\n", pdu_size)=
;
>>
>> -               /* make sure we have enough to get to SMB header end */
>> -               if (!ksmbd_pdu_size_has_room(pdu_size)) {
>> -                       ksmbd_debug(CONN, "SMB request too short (%u
>> bytes)\n",
>> -                                   pdu_size);
>> +               /*
>> +                * Check if pdu size is valid (min : smb header size,
>> +                * max : 0x00FFFFFF).
>> +                */
>> +               if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
>> +                   pdu_size > MAX_STREAM_PROT_LEN) {
>>                         continue;
>>                 }
>>
>> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
>> index 5901b2884c60..20bd5b8e3c0a 100644
>> --- a/fs/ksmbd/smb_common.c
>> +++ b/fs/ksmbd/smb_common.c
>> @@ -21,7 +21,6 @@ static const char basechars[43] =3D
>> "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
>>  #define MAGIC_CHAR '~'
>>  #define PERIOD '.'
>>  #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
>> -#define KSMBD_MIN_SUPPORTED_HEADER_SIZE        (sizeof(struct smb2_hdr)=
)
>>
>>  struct smb_protocol {
>>         int             index;
>> @@ -272,11 +271,6 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
>>         return 0;
>>  }
>>
>> -bool ksmbd_pdu_size_has_room(unsigned int pdu)
>> -{
>> -       return (pdu >=3D KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4);
>> -}
>> -
>>  int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int
>> info_level,
>>                                       struct ksmbd_file *dir,
>>                                       struct ksmbd_dir_info *d_info,
>> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
>> index 994abede27e9..6e79e7577f6b 100644
>> --- a/fs/ksmbd/smb_common.h
>> +++ b/fs/ksmbd/smb_common.h
>> @@ -48,6 +48,8 @@
>>  #define CIFS_DEFAULT_IOSIZE    (64 * 1024)
>>  #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>>
>> +#define MAX_STREAM_PROT_LEN    0x00FFFFFF
>
> Do we need to append "SMB" to this macro name?
I named it with the name defined in specification. That is, no problem.
> Looks good to me.
> Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Thanks for your review!
>
>
>> +
>>  /* Responses when opening a file. */
>>  #define F_SUPERSEDED   0
>>  #define F_OPENED       1
>> @@ -493,8 +495,6 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects,
>> __le16 dialects_count);
>>
>>  int ksmbd_init_smb_server(struct ksmbd_work *work);
>>
>> -bool ksmbd_pdu_size_has_room(unsigned int pdu);
>> -
>>  struct ksmbd_kstat;
>>  int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
>>                                       int info_level,
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
