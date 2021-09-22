Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C51CC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 00:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B8A561166
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 00:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhIVA1x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 20:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhIVA1x (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 20:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DA461166
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 00:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632270384;
        bh=PRJQRecnSOc52CCuEv2l3Jzq+gzLNwrUooAlw9wZ0b0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hIRR5wVNrrC0dBe8Pycms1jh+Oe6iVvt21ZQD1yJPzWbtp/N5Uv+Zuu8fI6m+5McN
         kmxcvZIrw0uPsg2k6BKr9OWcpSnIZucSXgTbTdk2lNtVmiIxPIeeklCl1a8InDWjnm
         RRMbsePNGLGbDCUvKdGDo2HmPL1pGghSl/h1vwPBw5VmggKGcndY9BylR70euLaOJq
         53ViLx7/hMuau5Oq5ksSlVJdrzrEW/igZupTia5xCLNKZ8BqAKdCsBtP9RW27yJ+eJ
         OpY0uOsRzXL+9fxvRyYrVNMTsg6ZfBk9SB0Tz/3Gz5w2so8P2MCfYtceGYvh68y8rv
         3REcoQ+674tOA==
Received: by mail-oi1-f176.google.com with SMTP id 6so1802306oiy.8
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 17:26:24 -0700 (PDT)
X-Gm-Message-State: AOAM5328Kz4zC5GOXMABrisrzMPLXwXXjVDesA/PHaqZVfIXrG/XvxMe
        YFSkgV5pe7/vDWJ2NFkBS6ck94U3GQ5eMMfLvDQ=
X-Google-Smtp-Source: ABdhPJwWzJVm1I4x76g4s+5zP91S8GztexUeu1CDB3XRVe2Pc1qLZXkGpRsh3KzwjmXWP7kj4FLSQshOyOwqZgd0714=
X-Received: by 2002:a05:6808:1a29:: with SMTP id bk41mr5832678oib.167.1632270383620;
 Tue, 21 Sep 2021 17:26:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 17:26:23
 -0700 (PDT)
In-Reply-To: <3ab97b10-d94c-6cb2-0134-a4f3878a5ee2@samba.org>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-5-linkinjeon@kernel.org> <3ab97b10-d94c-6cb2-0134-a4f3878a5ee2@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 22 Sep 2021 09:26:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_8GVoxxkSNhzjQ5YLAWVguG5Vaz5_yi_4Jgc3PLToVYg@mail.gmail.com>
Message-ID: <CAKYAXd_8GVoxxkSNhzjQ5YLAWVguG5Vaz5_yi_4Jgc3PLToVYg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 17:32 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae,
>
> thanks! One nitpick below.
>
> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
>> From: Hyunchul Lee <hyc.lee@gmail.com>
>>
>> Add buffer validation for SMB2_CREATE_CONTEXT.
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/oplock.c  | 35 +++++++++++++++++++++++++----------
>>   fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
>>   fs/ksmbd/smbacl.c  |  9 ++++++++-
>>   3 files changed, 57 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
>> index 16b6236d1bd2..3fd2713f2282 100644
>> --- a/fs/ksmbd/oplock.c
>> +++ b/fs/ksmbd/oplock.c
>> @@ -1451,26 +1451,41 @@ struct lease_ctx_info *parse_lease_state(void
>> *open_req)
>>    */
>>   struct create_context *smb2_find_context_vals(void *open_req, const ch=
ar
>> *tag)
>>   {
>> -	char *data_offset;
>> +	struct smb2_create_req *req =3D (struct smb2_create_req *)open_req;
>>   	struct create_context *cc;
>> -	unsigned int next =3D 0;
>> +	char *data_offset, *data_end;
>>   	char *name;
>> -	struct smb2_create_req *req =3D (struct smb2_create_req *)open_req;
>> +	unsigned int next =3D 0;
>> +	unsigned int name_off, name_len, value_off, value_len;
>>
>>   	data_offset =3D (char *)req + 4 +
>> le32_to_cpu(req->CreateContextsOffset);
>> +	data_end =3D data_offset + le32_to_cpu(req->CreateContextsLength);
>>   	cc =3D (struct create_context *)data_offset;
>>   	do {
>> -		int val;
>> -
>>   		cc =3D (struct create_context *)((char *)cc + next);
>> -		name =3D le16_to_cpu(cc->NameOffset) + (char *)cc;
>> -		val =3D le16_to_cpu(cc->NameLength);
>> -		if (val < 4)
>> +		if ((char *)cc + offsetof(struct create_context, Buffer) >
>> +		    data_end)
>>   			return ERR_PTR(-EINVAL);
>>
>> -		if (memcmp(name, tag, val) =3D=3D 0)
>> -			return cc;
>>   		next =3D le32_to_cpu(cc->Next);
>> +		name_off =3D le16_to_cpu(cc->NameOffset);
>> +		name_len =3D le16_to_cpu(cc->NameLength);
>> +		value_off =3D le16_to_cpu(cc->DataOffset);
>> +		value_len =3D le32_to_cpu(cc->DataLength);
>> +
>> +		if ((char *)cc + name_off + name_len > data_end ||
>> +		    (value_len && (char *)cc + value_off + value_len > data_end))
>> +			return ERR_PTR(-EINVAL);
>> +		else if (next && (next < name_off + name_len ||
>> +			 (value_len && next < value_off + value_len)))
>> +			return ERR_PTR(-EINVAL);
>
> The else is a bit confusing and not needed. Also, Samba has a few
> additional checks, I wonder whether we should add those two:
>
>                  if ((next & 0x7) !=3D 0 ||
>                      next > remaining ||
>                      name_offset !=3D 16 ||
>                      name_length < 4 ||
>                      name_offset + name_length > remaining ||
>                      (data_offset & 0x7) !=3D 0 ||
>                      (data_offset && (data_offset < name_offset +
> name_length)) ||
>                      (data_offset > remaining) ||
>                      (data_offset + (uint64_t)data_length > remaining)) {
>                          return NT_STATUS_INVALID_PARAMETER;
>                  }
I will fix it on v2.

Thank your review!
>
> Other then that lgtm.
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
