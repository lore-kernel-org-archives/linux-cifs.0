Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E189C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 01:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3324961425
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 01:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347376AbhI3BDN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 21:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232383AbhI3BDI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 21:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E9B61425
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 01:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632963686;
        bh=v0jbI79VA4txYi4kGAbWVZQgT6dLbXK+ERvhSJylqbI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=MroBckjSEnHi5PbMxOqTiSbY4T7PJg7TpkEj/2/f1pCmgb6MSlzlNTy6PyosAiCdk
         /OyQchx3rMN2uIZTpNFoCL0B32KMVYJXO1ooCUAf6ugW6ewuIZ2YH3zLNXERcOBln9
         l2SIMiuKWFt6CfkLVi1S8a8kn02ypnCJVU0WOTJHMKMc7GISKVDyNyQgLFFA0+1WLj
         yfmtl1GVrHsgjPovw7dViZvwsf8yqLcOaAIzzHn4oxIS4HkRcEYR1Zbko2IwABHFPW
         7hwsrjiMNdd+QhIjRHN02kLOAIpqTzXehBpdmF7zRAl/0hdnSPjS4XngYzq5JbLGQx
         Cq97wQO2lVyUg==
Received: by mail-oi1-f174.google.com with SMTP id e24so5197997oig.11
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 18:01:26 -0700 (PDT)
X-Gm-Message-State: AOAM533MTn64/+BEEcw0O4TiHGNiIQleUyauJdkdh/cBjv3CZLBcc7jn
        v7YPhx9KwuhZxwKDOvqC9BrtGK6e6D2bqkLJLOc=
X-Google-Smtp-Source: ABdhPJy8mPwgUb9WYn1x0s8lSduliypHWIncfczvQHgKl0lK5u7d6eW6DEZUzaTZaifipnik3WVOVUQ+3x4SIv+NyyU=
X-Received: by 2002:a05:6808:1a29:: with SMTP id bk41mr498819oib.167.1632963685576;
 Wed, 29 Sep 2021 18:01:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 29 Sep 2021 18:01:24
 -0700 (PDT)
In-Reply-To: <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org> <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 30 Sep 2021 10:01:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
Message-ID: <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
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

2021-09-30 2:55 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 29.09.21 um 10:44 schrieb Namjae Jeon:
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
>>
>> v4:
>>    - use work->response_sz for out_buf_len calculation in smb2_ioctl.
>>    - move smb2_neg size check to above to validate NegotiateContextOffse=
t
>>      field.
>>    - remove unneeded dialect checks in smb2_sess_setup() and
>>      smb2_handle_negotiate().
>>    - split smb2_set_info patch into two patches(declaring
>>      smb2_file_basic_info and buffer check)
>
> it looks like you dropped all my patches and didn't comment on the
> SQUASHES that pointed at some issues.
>
> Did I miss anything where you explained why you did this?
Please see v4 change list in this cover letter
  - use work->response_sz for out_buf_len calculation in smb2_ioctl.
  - split smb2_set_info patch into two patches(declaring...

I didn't apply "SQUASH: at this layer we should only against the
MAX_STREAM_PROT_LEN =E2=80=A6"
because smb2 header is used before ksmbd_verify_smb_message is reached.
See init_rsp_hdr and check_user_session() in __handle_ksmbd_work().

Have you checked my comments on your squash patches of github ?
I didn't get any response from you :)
>
> The changes I made imho consolidated the SMB2 PDU packet size checking
> logic. With your changes the check for valid SMB2 PDU sizes of compound
> offsets is spread across the network receive layer and the compound
> parsing layer.
>
> The changes I made, adding a nice helper function along the way, moved
> the core PDU validation into the function were it should be done: inside
> ksmbd_smb2_check_message().
ksmbd is checking whether session id and tree id are vaild in smb
header before processing smb requests. is_chained_smb2_message is
checking next command header size.
>
> You also dropped the fix for the possible invalid read in
> ksmbd_verify_smb_message() of the protocol_id field.
Where ? You are saying your patch in github ? If it is right, I didn't drop=
.
>
> I might be missing something because I'm still new to the code. But
> generally we really sanitize the logic while we're at it now instead of
> adding band aids everywhere.
I saw your patch and it's nice. However, we have not yet agreed on
where the review will be conducted. You also didn't respond to my
comments on my squash patch in your github. So I thought I'd take a
deeper look if you send the patch to the list.
>
> Thanks!
Thanks :)
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
