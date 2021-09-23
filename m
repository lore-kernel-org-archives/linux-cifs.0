Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD58C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971206124D
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242869AbhIWTb4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 15:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242841AbhIWTb4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 15:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA1A6124D
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 19:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632425424;
        bh=X+IOrmCKHLGbmwEPrDBlzuN7Gg8Lb+ltq4DzGA7cKUI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=AsIu5HZQ+cpj+Fl+3EHDmGJCnnlzGk6QXyw7irS2lbQqJ1DPqzUVckL+ZbiLiuCe9
         34DtHwbZgKng9ZMpCDCZbyUZRem+zcyGmkDyvrauiJvhnNF1arNTCrE8/0HLBpiQpZ
         /reVP6oVkB6sD5GCuf4y6N331aWVm4VQUXS7ZBSVbRlx7ncx7xCJ1NYSHR4L4yISkC
         IPonr9P3DbtIBbX/l6DxaYovRDL9v+M5k4JtGKWG8bTz4MbCCmmigRfYZL2JurOzxf
         VUfzf23IW0XcMuRH/xcuaY7NiVrXcF/Je8Bf1OZqsl/KPgOCN8g/50dVIbQdi2DCDo
         MTL4Rfl+eRobQ==
Received: by mail-ot1-f51.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso9982564ota.8
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 12:30:24 -0700 (PDT)
X-Gm-Message-State: AOAM531TQ3DPUq+y5yy1PfRvD3yMos9Eg62X56L65LnUHQUxhkrDU0OC
        CrM0HiDQkjjO6MwK5jxVjQL1P67D5FM58oOHZpg=
X-Google-Smtp-Source: ABdhPJw2JZoS0zoOltWnp8DYZtfVKYTpADPbhm3aQchgx6afTLBjrWDO8EzgdntQ5Fh6cvera/kBlikZm+6cnmJ+0jw=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr329569otf.237.1632425423704;
 Thu, 23 Sep 2021 12:30:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 23 Sep 2021 12:30:23
 -0700 (PDT)
In-Reply-To: <e8c75bd8-a8ef-a040-843a-a05bb8c3746e@talpey.com>
References: <20210923034855.612832-1-linkinjeon@kernel.org>
 <20210923034855.612832-2-linkinjeon@kernel.org> <e8c75bd8-a8ef-a040-843a-a05bb8c3746e@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Sep 2021 04:30:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8fy9S+XWAQpzt51sQvHOPq2G42ELqXN8oONp5_GWoB0g@mail.gmail.com>
Message-ID: <CAKYAXd8fy9S+XWAQpzt51sQvHOPq2G42ELqXN8oONp5_GWoB0g@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: fix invalid request buffer access in compound
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-24 0:13 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/22/2021 11:48 PM, Namjae Jeon wrote:
>> Ronnie reported invalid request buffer access in chained command when
>> inserting garbage value to NextCommand of compound request.
>> This patch add validation check to avoid this issue.
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>    v2:
>>     - fix integer overflow from work->next_smb2_rcv_hdr_off.
>>    v3:
>>     - check next command offset and at least header size of next pdu at
>>       the same time.
>>    v4:
>>     - add next_cmd variable not to avoid repeat conversion.
>>
>>   fs/ksmbd/smb2pdu.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 90f867b9d560..301558a04298 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -459,13 +459,21 @@ static void init_chained_smb2_rsp(struct ksmbd_wor=
k
>> *work)
>>   bool is_chained_smb2_message(struct ksmbd_work *work)
>>   {
>>   	struct smb2_hdr *hdr =3D work->request_buf;
>> -	unsigned int len;
>> +	unsigned int len, next_cmd;
>>
>>   	if (hdr->ProtocolId !=3D SMB2_PROTO_NUMBER)
>>   		return false;
>>
>>   	hdr =3D ksmbd_req_buf_next(work);
>> -	if (le32_to_cpu(hdr->NextCommand) > 0) {
>> +	next_cmd =3D le32_to_cpu(hdr->NextCommand);
>> +	if (next_cmd > 0) {
>> +		if ((u64)work->next_smb2_rcv_hdr_off + next_cmd + 64 >
>
> The "64" is somewhat arbitrary and mysterious. Is this the size
> of the next command smb2_hdr? Why not code that, at least with
> a #define?
Okay, Will use macro.
>
>> +		    get_rfc1002_len(work->request_buf)) {
>> +			pr_err("next command(%u) offset exceeds smb msg size\n",
>> +			       next_cmd);
>> +			return false;
>> +		}
>
> Hmm, well the header fits in the reminder of the message. What
> about the rest of the nextcommand smb2 request? It seems very
> odd, and more than a little risky, to be validating only one
> aspect of the nextcommand here.
There is a loop to check the rest of the nextcommand.
Please see do { } while (is_chained_smb2_message(work)); in server.

>
>> +
>>   		ksmbd_debug(SMB, "got SMB2 chained command\n");
>
> This, to me, is entirely needless debug splat.
The reason is ?
>
> Tom.
>
>>   		init_chained_smb2_rsp(work);
>>   		return true;
>>
>
