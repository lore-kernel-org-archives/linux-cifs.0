Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466FDC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CB56127B
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhIYKrn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233380AbhIYKrn (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 25 Sep 2021 06:47:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCA066127C
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 10:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632566768;
        bh=RGtngWRw1wcI/hhwddK/bVW6kgrPPX459yHWzRAbW9k=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Ze7RoqmdrzLzPtuFoajojQVAoP1Y8g0hNpAlha8l7geGFRKu9VHJzRfaxQNvmHjqH
         SfVHfAOkOH1fIiP06RHGV5UlIHdKceF5DpQA0S71vr+zW3YuH5Wp+6UZq2QlhJUyCB
         273Eq6Gl0cxEuD9LEj5yhANT82G4PiKHJTbEZgVEXMpLXVbzOALARpL+huc2bh5Kei
         gByjlz2pBCzuQ8CwNV24dg9zzfvVD0KMW4iKe0foqAiU0PAxwTnEPBOoYX+4U+zDd7
         JH1/7sZTyOzhpw0UrhJDHyLaaJpEVs/uvA2Mol7YAOc0y0KO1VNgElTyrIxgc179Cw
         P6WiIZckPMlcA==
Received: by mail-ot1-f52.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so16822444otx.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 03:46:08 -0700 (PDT)
X-Gm-Message-State: AOAM531P99u+3ilbc0tK8ATAJPvn6g8wSYAbFVChQ/DdUPEbGI09ydWc
        G9BJvLcWBylgClQJG9wy2b0NR8FrqizMYaZ8lZ0=
X-Google-Smtp-Source: ABdhPJzaE77L5pjUHE6PzQ3U9d3DBt3s90nLZwGpHnONj3KD0fQMqgPNLjGtoCKRcYcU7xhdJZmyOr3SXsKDBfNAmJY=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr7917175ots.185.1632566768224;
 Sat, 25 Sep 2021 03:46:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 25 Sep 2021 03:46:07
 -0700 (PDT)
In-Reply-To: <CANFS6bYOJE12aA+UZpr6ajeu555a23N7F3OS1mgVZKX48AtwFg@mail.gmail.com>
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-5-linkinjeon@kernel.org>
 <CANFS6bYOJE12aA+UZpr6ajeu555a23N7F3OS1mgVZKX48AtwFg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Sep 2021 19:46:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Mjy44CTe=hPGuUUJd9T9u4UiJT6+Y-2n15pp4nnf=6Q@mail.gmail.com>
Message-ID: <CAKYAXd_Mjy44CTe=hPGuUUJd9T9u4UiJT6+Y-2n15pp4nnf=6Q@mail.gmail.com>
Subject: Re: [PATCH 4/7] ksmbd: check strictly data area in ksmbd_smb2_check_message()
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

2021-09-25 19:27 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Looks good to me.
> Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
>
> 2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> When invalid data offset and data length in request,
>> ksmbd_smb2_check_message check strictly and doesn't allow to process suc=
h
>> requests.
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/smb2misc.c | 83 ++++++++++++++++++++-------------------------
>>  1 file changed, 37 insertions(+), 46 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
>> index 9aa46bb3e10d..697285e47522 100644
>> --- a/fs/ksmbd/smb2misc.c
>> +++ b/fs/ksmbd/smb2misc.c
>> @@ -83,15 +83,18 @@ static const bool
>> has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] =3D {
>>   * Returns the pointer to the beginning of the data area. Length of the
>> data
>
> Do we need to change this comment about the return value?
Will update it on next version.
> Looks good to me except this.
> Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Thanks!
>
>
>>   * area and the offset to it (from the beginning of the smb are also
>> returned.
>>   */
>> -static char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr
>> *hdr)
>> +static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
>> +                                 struct smb2_hdr *hdr)
>>  {
>> +       int ret =3D 0;
>> +
>>         *off =3D 0;
>>         *len =3D 0;
>>
>>         /* error reqeusts do not have data area */
>>         if (hdr->Status && hdr->Status !=3D STATUS_MORE_PROCESSING_REQUI=
RED
>> &&
>>             (((struct smb2_err_rsp *)hdr)->StructureSize) =3D=3D
>> SMB2_ERROR_STRUCTURE_SIZE2_LE)
>> -               return NULL;
>> +               return ret;
>>
>>         /*
>>          * Following commands have data areas so we have to get the
>> location
>> @@ -165,69 +168,52 @@ static char *smb2_get_data_area_len(int *off, int
>> *len, struct smb2_hdr *hdr)
>>         case SMB2_IOCTL:
>>                 *off =3D le32_to_cpu(((struct smb2_ioctl_req
>> *)hdr)->InputOffset);
>>                 *len =3D le32_to_cpu(((struct smb2_ioctl_req
>> *)hdr)->InputCount);
>> -
>>                 break;
>>         default:
>>                 ksmbd_debug(SMB, "no length check for command\n");
>>                 break;
>>         }
>>
>> -       /*
>> -        * Invalid length or offset probably means data area is invalid,
>> but
>> -        * we have little choice but to ignore the data area in this
>> case.
>> -        */
>>         if (*off > 4096) {
>> -               ksmbd_debug(SMB, "offset %d too large, data area
>> ignored\n",
>> -                           *off);
>> -               *len =3D 0;
>> -               *off =3D 0;
>> -       } else if (*off < 0) {
>> -               ksmbd_debug(SMB,
>> -                           "negative offset %d to data invalid ignore
>> data area\n",
>> -                           *off);
>> -               *off =3D 0;
>> -               *len =3D 0;
>> -       } else if (*len < 0) {
>> -               ksmbd_debug(SMB,
>> -                           "negative data length %d invalid, data area
>> ignored\n",
>> -                           *len);
>> -               *len =3D 0;
>> -       } else if (*len > 128 * 1024) {
>> -               ksmbd_debug(SMB, "data area larger than 128K: %d\n",
>> *len);
>> -               *len =3D 0;
>> +               ksmbd_debug(SMB, "offset %d too large\n", *off);
>> +               ret =3D -EINVAL;
>> +       } else if ((u64)*off + *len > MAX_STREAM_PROT_LEN) {
>> +               ksmbd_debug(SMB, "Request is larger than maximum stream
>> protocol length(%u): %llu\n",
>> +                           MAX_STREAM_PROT_LEN, (u64)*off + *len);
>> +               ret =3D -EINVAL;
>>         }
>>
>> -       /* return pointer to beginning of data area, ie offset from SMB
>> start */
>> -       if ((*off !=3D 0) && (*len !=3D 0))
>> -               return (char *)hdr + *off;
>> -       else
>> -               return NULL;
>> +       return ret;
>>  }
>>
>>  /*
>>   * Calculate the size of the SMB message based on the fixed header
>>   * portion, the number of word parameters and the data portion of the
>> message.
>>   */
>> -static unsigned int smb2_calc_size(void *buf)
>> +static int smb2_calc_size(void *buf, unsigned int *len)
>>  {
>>         struct smb2_pdu *pdu =3D (struct smb2_pdu *)buf;
>>         struct smb2_hdr *hdr =3D &pdu->hdr;
>> -       int offset; /* the offset from the beginning of SMB to data area
>> */
>> -       int data_length; /* the length of the variable length data area
>> */
>> +       unsigned int offset; /* the offset from the beginning of SMB to
>> data area */
>> +       unsigned int data_length; /* the length of the variable length
>> data area */
>> +       int ret;
>> +
>>         /* Structure Size has already been checked to make sure it is 64
>> */
>> -       int len =3D le16_to_cpu(hdr->StructureSize);
>> +       *len =3D le16_to_cpu(hdr->StructureSize);
>>
>>         /*
>>          * StructureSize2, ie length of fixed parameter area has already
>>          * been checked to make sure it is the correct length.
>>          */
>> -       len +=3D le16_to_cpu(pdu->StructureSize2);
>> +       *len +=3D le16_to_cpu(pdu->StructureSize2);
>>
>>         if (has_smb2_data_area[le16_to_cpu(hdr->Command)] =3D=3D false)
>>                 goto calc_size_exit;
>>
>> -       smb2_get_data_area_len(&offset, &data_length, hdr);
>> -       ksmbd_debug(SMB, "SMB2 data length %d offset %d\n", data_length,
>> +       ret =3D smb2_get_data_area_len(&offset, &data_length, hdr);
>> +       if (ret)
>> +               return ret;
>> +       ksmbd_debug(SMB, "SMB2 data length %u offset %u\n", data_length,
>>                     offset);
>>
>>         if (data_length > 0) {
>> @@ -237,16 +223,19 @@ static unsigned int smb2_calc_size(void *buf)
>>                  * for some commands, typically those with odd
>> StructureSize,
>>                  * so we must add one to the calculation.
>>                  */
>> -               if (offset + 1 < len)
>> +               if (offset + 1 < *len) {
>>                         ksmbd_debug(SMB,
>> -                                   "data area offset %d overlaps SMB2
>> header %d\n",
>> -                                   offset + 1, len);
>> -               else
>> -                       len =3D offset + data_length;
>> +                                   "data area offset %d overlaps SMB2
>> header %u\n",
>> +                                   offset + 1, *len);
>> +                       return -EINVAL;
>> +               }
>> +
>> +               *len =3D offset + data_length;
>>         }
>> +
>>  calc_size_exit:
>> -       ksmbd_debug(SMB, "SMB2 len %d\n", len);
>> -       return len;
>> +       ksmbd_debug(SMB, "SMB2 len %u\n", *len);
>> +       return 0;
>>  }
>>
>>  static inline int smb2_query_info_req_len(struct smb2_query_info_req *h=
)
>> @@ -391,9 +380,11 @@ int ksmbd_smb2_check_message(struct ksmbd_work
>> *work)
>>                 return 1;
>>         }
>>
>> -       clc_len =3D smb2_calc_size(hdr);
>> +       if (smb2_calc_size(hdr, &clc_len))
>> +               return 1;
>> +
>>         if (len !=3D clc_len) {
>> -               /* server can return one byte more due to implied bcc[0]
>> */
>> +               /* client can return one byte more due to implied bcc[0]
>> */
>>                 if (clc_len =3D=3D len + 1)
>>                         return 0;
>>
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
