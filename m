Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0C2C19F2D
	for <linux-cifs@archiver.kernel.org>; Sun, 14 Aug 2022 02:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiHNCuc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Aug 2022 22:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiHNCub (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Aug 2022 22:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF7295A4
        for <linux-cifs@vger.kernel.org>; Sat, 13 Aug 2022 19:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B6460F85
        for <linux-cifs@vger.kernel.org>; Sun, 14 Aug 2022 02:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC15C433C1
        for <linux-cifs@vger.kernel.org>; Sun, 14 Aug 2022 02:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660445428;
        bh=CKLDym73WTzMMJOlioMXH1miMGsUH9GQs61rkcgPLVg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=rblHJNSO/Bt6R2DdOQ8ebiUJrOuFgNE/T+WN/AboXXvsGvzO/YuDAgliVvAf8Jq23
         H3O3WWuf5O/Odj9okFfxiFr92SSVQxy81e2jkVoeJq1zb6PZKAu2gt3U21StjVuaDO
         6CxGiA9FmgKNi+saI9yNXH00lJzdb0UK5cygQt+o/CB8fAa/qycUTO2jnYc1pmbuzy
         TmHeDEd5jwC0gu8PSX+5G2LCwdFj6s9GuObNoFlxxs+pu7TQ+mwf5RtpqaWUmC66/V
         H28hAxeDaOrxnuO9Wa91foXbyJDGD0xfrpklkY3h+5Q2SN3Ci0B1spLhj14BKjdJCk
         /Xwefjmk3qUtw==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-10ea7d8fbf7so4944516fac.7
        for <linux-cifs@vger.kernel.org>; Sat, 13 Aug 2022 19:50:28 -0700 (PDT)
X-Gm-Message-State: ACgBeo2BT7ul4LWb0l3wLG3u9YAmOFRLEBjrqy4QZHDAbZehGREitnRz
        n4NkxcogxUwyuxiQrDOMNf5FZMaRfp32Oc9jF4k=
X-Google-Smtp-Source: AA6agR5ivUZjOStlfUvx6anHoCc3XG9Rin4yWF26+hdFj0cEzudnyTqG7Ul9tLC4kd4xk2U5j3rlGdmGDeZPwhSPzwE=
X-Received: by 2002:a05:6870:f69d:b0:10d:81ea:3540 with SMTP id
 el29-20020a056870f69d00b0010d81ea3540mr4679652oab.257.1660445428032; Sat, 13
 Aug 2022 19:50:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sat, 13 Aug 2022 19:50:27
 -0700 (PDT)
In-Reply-To: <CANFS6bYChCrTQHT6NKvpBX1PEuWPX1CYH_Z5TpGGgdMswV-dFw@mail.gmail.com>
References: <20220812025614.5673-1-linkinjeon@kernel.org> <CANFS6bYChCrTQHT6NKvpBX1PEuWPX1CYH_Z5TpGGgdMswV-dFw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 14 Aug 2022 11:50:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_tzk8YTpOrX-MvJWVwK2zJz4=sYf1M-+y+Z2R2t4YdCA@mail.gmail.com>
Message-ID: <CAKYAXd_tzk8YTpOrX-MvJWVwK2zJz4=sYf1M-+y+Z2R2t4YdCA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: don't remove dos attribute xattr on O_TRUNC open
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-14 11:19 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 8=EC=9B=94 12=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:56=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> When smb client open file in ksmbd share with O_TRUNC, dos attribute
>> xattr is removed as well as data in file. This cause the FSCTL_SET_SPARS=
E
>> request from the client fails because ksmbd can't update the dos
>> attribute
>> after setting ATTR_SPARSE_FILE. And this patch fix xfstests generic/469
>> test also.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/smb2pdu.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index b5c36657ecfd..0c2e57397dd2 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -2330,9 +2330,7 @@ static int smb2_remove_smb_xattrs(struct path
>> *path)
>>                         name +=3D strlen(name) + 1) {
>>                 ksmbd_debug(SMB, "%s, len %zd\n", name, strlen(name));
>>
>> -               if (strncmp(name, XATTR_USER_PREFIX,
>> XATTR_USER_PREFIX_LEN) &&
>> -                   strncmp(&name[XATTR_USER_PREFIX_LEN],
>> DOS_ATTRIBUTE_PREFIX,
>> -                           DOS_ATTRIBUTE_PREFIX_LEN) &&
>> +               if (!strncmp(name, XATTR_USER_PREFIX,
>> XATTR_USER_PREFIX_LEN) &&
>>                     strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
>> STREAM_PREFIX_LEN))
>>                         continue;
>>
>
> We don't need to exclude security.*, trusted.*, system.* from deletion?
Right, will fix it on v2.
Thanks.
>
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
