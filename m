Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B42C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 23:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CF66611CE
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 23:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhI0X6y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Sep 2021 19:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231674AbhI0X6y (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 27 Sep 2021 19:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE3E4611F2
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 23:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632787035;
        bh=lt7FxVYqWddYgEGJ/C2skEgCgRjr9y9cupAnOQ9Obko=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Dm/qktmul+NuuqxhAGidGNLLIi2ItYUMeHNv7gUpUbCJXK+INrgzXRsppl3Hd3lbr
         FdhVIvjY0MYTFS41IDwRPjF/ng9pDZGrqTu01dWT19bn9BWjXIfzVaei8gyEJ+qMow
         XDrKT12GQrPFcUMpAioryZYK1xwIBioKvHEQ0jGoT3sVNcijFeRJZP28Nw5Lec8OQ7
         2ejxTDOEICQXzir6OmPecgJ5Zs7DPxLjEWP/j7hmSJ8bNGheJDU+UaU4l416bzQUzQ
         47zFMim1gjKyvQiz7wxFkHfSk0dy5sT00dbl2dVVAEJ72bfD4czq0LJG3IYOY01hLE
         PQPAcxlvkpZsg==
Received: by mail-oi1-f180.google.com with SMTP id u22so27832452oie.5
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 16:57:15 -0700 (PDT)
X-Gm-Message-State: AOAM533PH/NQUarWlVxtoaCX7jKKVT6P5IMWTtcBPKyHYnqNkvKgH97u
        oIBqFjmWLTHDalzqztcbayfMGWS+DdN4w8NXhsM=
X-Google-Smtp-Source: ABdhPJwf91WrRG6QaC9sTTv9xVafR8ow2ZkrEARy7hlcY2UNEKnel3N7YENSODoZeNMA20fyZ0jeYFxuRZSmCzqWls0=
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr1375694oib.138.1632787035246;
 Mon, 27 Sep 2021 16:57:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 27 Sep 2021 16:57:14
 -0700 (PDT)
In-Reply-To: <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org> <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 28 Sep 2021 08:57:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
Message-ID: <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-28 0:42 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae
Hi Ralph,

>
> Am 26.09.21 um 15:55 schrieb Namjae Jeon:
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>>
>> v2:
>>    - update comments of smb2_get_data_area_len().
>>    - fix wrong buffer size check in fsctl_query_iface_info_ioctl().
>>    - fix 32bit overflow in smb2_set_info.
>>
>> v3:
>>    - add buffer check for ByteCount of smb negotiate request.
>>    - Moved buffer check of to the top of loop to avoid unneeded behavior
>> when
>>      out_buf_len is smaller than network_interface_info_ioctl_rsp.
>>    - get correct out_buf_len which doesn't exceed max stream protocol
>> length.
>>    - subtract single smb2_lock_element for correct buffer size check in
>>      ksmbd_smb2_check_message().
>
> I think there are a few issues with this patchset. I'm working on fixes
> and improvements and will push my branch to my github clone once I'm
> ready. I guess it's going to take a few days.
It sounds like you're making a patch based on this patch-set. If there
is missing something for buffer check, You can add a patch on top of
this, but if there are wrong codes in patch-set, It is right to leave
a review comment to update this patch-set.

Thanks!
>
> Cheers!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
