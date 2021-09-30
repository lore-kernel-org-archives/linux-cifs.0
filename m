Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA997C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 00:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B61266152B
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 00:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347783AbhI3ACU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 20:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347786AbhI3ACP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 20:02:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C3366152B
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 00:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632960033;
        bh=l0kXKCQWbeoRqJDZqJaBrWMsLYUHHfsncCM2UerrYac=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=s7N1RuICsKaGIeOOVu7OfKcqcq3kbTX8kl7trh5UNZT6cLhbDjls7DmVrRDseHNVx
         EJOUiwpP6spc6vQP4UxrxT0HhxkFm7XfPkIBFhkRpZCud1i/oJjvAwLpnu1nxOHiPL
         NQhzNvz6xQB0M2Aa1w+zBcKvt+FU4roan+Oa8uoQSh61XF2ktBxhp6kxP6UDdAapwy
         c9m8SeEolXfQUhZatyjguGitDdinyMo7epX1BQSvJJzzQJGIIReNJsWKdDbqvCTTPH
         hHJEEZnD5865GJ2gXuLh2Ox+azMzRE24Me0rapPP8Op0kbtVFPlMiSKBG+UIKbqQPx
         U0iFZg6DVWwgA==
Received: by mail-oo1-f52.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso1298092ooq.8
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 17:00:33 -0700 (PDT)
X-Gm-Message-State: AOAM533t2p3XHHXtpeTqiluo9o5/agwbfBoy3YUY1BnZApxwxw6wrRwS
        sFVZXMA0hWesaMy6o5oVOMrC2IKX4fyNRb8yCaA=
X-Google-Smtp-Source: ABdhPJzsoYBdDD5uMgS+nhJGZ+SpVSiwN5CAZMZwbESJslF609/oKq4+CLCBHOWj36XzpXAAhtb9SBJzkcnOue96vcw=
X-Received: by 2002:a4a:d30f:: with SMTP id g15mr2239594oos.32.1632960032971;
 Wed, 29 Sep 2021 17:00:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 29 Sep 2021 17:00:32
 -0700 (PDT)
In-Reply-To: <11ae0ea4-a714-b9a3-f3f9-7733c45fcf5a@talpey.com>
References: <20210929133657.10553-1-linkinjeon@kernel.org> <11ae0ea4-a714-b9a3-f3f9-7733c45fcf5a@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 30 Sep 2021 09:00:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9pzcj_fb_FQiwkv5hGOz1BV1Pv9U2s6BOWbWVbkLmm2w@mail.gmail.com>
Message-ID: <CAKYAXd9pzcj_fb_FQiwkv5hGOz1BV1Pv9U2s6BOWbWVbkLmm2w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix transform header validation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-30 0:18 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/29/2021 9:36 AM, Namjae Jeon wrote:
>> OriginalMessageSize and SessionId should be used after validating
>> transform header in request buffer.
>
>
> I suggest rewording the log for clarity:
>
> ++ Validate that the transform and smb request headers are present
> ++ before checking OriginalMessageSize and SessionId fields.
Looks more clear:) Thank you! I will update it.
>
> Is there some reason you aren't using the buf_data_size that is
> already calculated, to verify these offsets? It seems like a lot
> of redundant, and therefore fragile, coding.
I can't remember why I did this 3 years ago... I will change it on
another patch after checking it.
>
> Reviewed-By: Tom Talpey <tom@talpey.com>
Thanks for your review!
>
>
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index ec05d9dc6436..b06361313889 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -8455,16 +8455,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>>   	unsigned int buf_data_size =3D pdu_length + 4 -
>>   		sizeof(struct smb2_transform_hdr);
>>   	struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_hdr *)bu=
f;
>> -	unsigned int orig_len =3D le32_to_cpu(tr_hdr->OriginalMessageSize);
>>   	int rc =3D 0;
>>
>> -	sess =3D ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId)=
);
>> -	if (!sess) {
>> -		pr_err("invalid session id(%llx) in transform header\n",
>> -		       le64_to_cpu(tr_hdr->SessionId));
>> -		return -ECONNABORTED;
>> -	}
>> -
>>   	if (pdu_length + 4 <
>>   	    sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) {
>>   		pr_err("Transform message is too small (%u)\n",
>> @@ -8472,11 +8464,19 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>>   		return -ECONNABORTED;
>>   	}
>>
>> -	if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)) {
>> +	if (pdu_length + 4 <
>> +	    le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct
>> smb2_transform_hdr)) {
>>   		pr_err("Transform message is broken\n");
>>   		return -ECONNABORTED;
>>   	}
>>
>> +	sess =3D ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId)=
);
>> +	if (!sess) {
>> +		pr_err("invalid session id(%llx) in transform header\n",
>> +		       le64_to_cpu(tr_hdr->SessionId));
>> +		return -ECONNABORTED;
>> +	}
>> +
>>   	iov[0].iov_base =3D buf;
>>   	iov[0].iov_len =3D sizeof(struct smb2_transform_hdr);
>>   	iov[1].iov_base =3D buf + sizeof(struct smb2_transform_hdr);
>>
>
