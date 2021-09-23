Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FD5C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 20:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1CEE6124E
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 20:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243072AbhIWUQa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 16:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243068AbhIWUQa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 16:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 775DD6124E
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 20:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632428098;
        bh=5IKPd8dn97r3nWzogbNsGE/5oT7JzOjGvq3EHWnPhAg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=U899o+AhwDgCIzsg3XX4v19GNWUs5u/zyEqUdrwDfDl+7pGaT6knmgvIhHWxe1A03
         wDD8zqofo4HVmF0Of751x3raIcB6UvR0ZgnrmIyui8Gsxb25Pe1KKCwtgg8vRejHSQ
         JMygDOv5m86r1WL3J4Dvaxr2Mx+XQbOt9rTDK3KiajD1PrrYEIzs3H34tUffH6OuPK
         KqALeCJjLYziCnNYJVgVpIeG/QP2zYYMF7n+zqsdsN9coCP4wkNRvZEP8CxO4gPqdT
         cCRpv2UGc/EyOAqWmxorl9nmYv6/DDU0bvQ2Rr6E3Rk07pPrEe+txMTOUgaR1vPLnn
         uCZ2qVQ/PRXIA==
Received: by mail-ot1-f47.google.com with SMTP id o59-20020a9d2241000000b0054745f28c69so8108516ota.13
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 13:14:58 -0700 (PDT)
X-Gm-Message-State: AOAM530Gs83Ow5ysVYIY+dgValMRNzykYTP3Z7XogekdfAKo79E4bK8d
        b5Sic7NrDejyXs0JWZP5fOR/wbhd4cSEmDCwlZM=
X-Google-Smtp-Source: ABdhPJxh0HN4Gjp49DiY9Z2E1jA/iVJoSzTncuh5ujuZiucqslwxyrGIiyuD9AqGhoYL6/LPCswjkvQ7LT4shFnnz/s=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr485930ots.185.1632428097866;
 Thu, 23 Sep 2021 13:14:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 23 Sep 2021 13:14:57
 -0700 (PDT)
In-Reply-To: <62d23460-aba4-9978-5fe7-ce907ca49d00@talpey.com>
References: <20210923034855.612832-1-linkinjeon@kernel.org>
 <20210923034855.612832-3-linkinjeon@kernel.org> <62d23460-aba4-9978-5fe7-ce907ca49d00@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Sep 2021 05:14:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9CO=O1rb1xVEcuG7dnwScD8WdgmPf-DFBqi3rW-vQBuA@mail.gmail.com>
Message-ID: <CAKYAXd9CO=O1rb1xVEcuG7dnwScD8WdgmPf-DFBqi3rW-vQBuA@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add validation in smb2 negotiate
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-24 0:54 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/22/2021 11:48 PM, Namjae Jeon wrote:
>> This patch add validation to check request buffer check in smb2
>> negotiate.
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   v3:
>>    - fix integer(nego_ctxt_off) overflow issue.
>>    - change data type of variables to unsigned.
>>
>>   fs/ksmbd/smb2pdu.c    | 40 ++++++++++++++++++++++++++++++++++++++++
>>   fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
>>   2 files changed, 60 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 301558a04298..2f9719a3f089 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -1080,6 +1080,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>>   	struct smb2_negotiate_req *req =3D work->request_buf;
>>   	struct smb2_negotiate_rsp *rsp =3D work->response_buf;
>>   	int rc =3D 0;
>> +	unsigned int smb2_buf_len, smb2_neg_size;
>>   	__le32 status;
>>
>>   	ksmbd_debug(SMB, "Received negotiate request\n");
>> @@ -1097,6 +1098,45 @@ int smb2_handle_negotiate(struct ksmbd_work *work=
)
>>   		goto err_out;
>>   	}
>>
>> +	smb2_buf_len =3D get_rfc1002_len(work->request_buf);
>
> Where is it validated that the pdu actually contains the number
> of bytes in the DirectTCP header?
ksmbd_smb2_check_message() validate it.
>
> Honestly I don't understand why the 4 bytes are passed around at all.
> Normally I would expect these to be stripped off after validation by
> the lower-layer receive processing. This would simplify the gazillion
> "- 4" corrections all over the code, too.
Okay, I have a patch for this. There was a small amount of code
modification, so I thought to apply it after the buffer check issues
are fixed.
>
>> +	smb2_neg_size =3D offsetof(struct smb2_negotiate_req, Dialects) - 4;
>> +	if (conn->dialect =3D=3D SMB311_PROT_ID) {
>> +		unsigned int nego_ctxt_off =3D le32_to_cpu(req->NegotiateContextOffse=
t);
>> +		unsigned int nego_ctxt_count =3D
>> le16_to_cpu(req->NegotiateContextCount);
>> +
>> +		if (smb2_buf_len < (u64)nego_ctxt_off + nego_ctxt_count) {
>
> This seems to be wrong. nego_ctxt_off is the base offset, but the
> nego_ctxt_count is the number, not the length of the contexts!
Ah, Right. This can be validated in deassemble_neg_contexts().
>
>> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> +			rc =3D -EINVAL;
>> +			goto err_out;
>> +		}
>> +
>> +		if (smb2_neg_size > nego_ctxt_off) {
>
> Isn't this completely redundant with the next test?
How do we know if the DialectCount of the next check is valid?
>
>> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> +			rc =3D -EINVAL;
>> +			goto err_out;
>> +		}
>> +
>> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
>> +		    nego_ctxt_off) {
>
> This validates that all the dialects are present, but it does not
> account for the padding and negotiate contexts fields which follow
> them.
negotiate contexts will be validated in deassemble_neg_contexts().
>
>> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> +			rc =3D -EINVAL;
>> +			goto err_out;
>> +		}
>> +	} else {
>> +		if (smb2_neg_size > smb2_buf_len) {
>> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> +			rc =3D -EINVAL;
>> +			goto err_out;
>> +		}
>> +
>> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
>> +		    smb2_buf_len) {
>
> Same connects as the 3.1.1 validation above.
< 3.1.1 doesn't have negotiate contexts. So It should be checked with
smb2_buf_len(rfc1002 len)
>
>> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> +			rc =3D -EINVAL;
>> +			goto err_out;
>> +		}
>> +	}
>> +
>>   	conn->cli_cap =3D le32_to_cpu(req->Capabilities);
>>   	switch (conn->dialect) {
>>   	case SMB311_PROT_ID:
>> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
>> index ebc835ab414c..02fe2a06dda9 100644
>> --- a/fs/ksmbd/smb_common.c
>> +++ b/fs/ksmbd/smb_common.c
>> @@ -235,13 +235,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialect=
s,
>> __le16 dialects_count)
>>
>>   static int ksmbd_negotiate_smb_dialect(void *buf)
>>   {
>> -	__le32 proto;
>> +	int smb_buf_length =3D get_rfc1002_len(buf);
>
> Same comments as above on length field and passed buffer size.
This will be improved on another patch.
>
>> +	__le32 proto =3D ((struct smb2_hdr *)buf)->ProtocolId;
>>
>> -	proto =3D ((struct smb2_hdr *)buf)->ProtocolId;
>>   	if (proto =3D=3D SMB2_PROTO_NUMBER) {
>>   		struct smb2_negotiate_req *req;
>> +		int smb2_neg_size =3D
>> +			offsetof(struct smb2_negotiate_req, Dialects) - 4;
>>
>>   		req =3D (struct smb2_negotiate_req *)buf;
>> +		if (smb2_neg_size > smb_buf_length)
>> +			goto err_out;
>
> What is this test protecting? neg_size is the length of the pdu *before*
> the Dialects field.
We need to validate DialectCount is valid first ?
>
>> +
>> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
>> +		    smb_buf_length)
>> +			goto err_out;
>> +
>>   		return ksmbd_lookup_dialect_by_id(req->Dialects,
>>   						  req->DialectCount);
>>   	}
>> @@ -251,10 +260,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
>>   		struct smb_negotiate_req *req;
>>
>>   		req =3D (struct smb_negotiate_req *)buf;
>> +		if (le16_to_cpu(req->ByteCount) < 2)
>> +			goto err_out;
>
> So, this is SMB1-style negotiation, and it's very unclear if the
> ByteCount is being checked for overflow. The code in mainline is
> very different, and it's not clear what this patch applies to.
ByteCount should be checked in ksmbd_lookup_dialect_by_name().
Could you please give a idea how to validate ByteCount ?

Thanks for your review!
>
>> +
>> +		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
>> +			le16_to_cpu(req->ByteCount) > smb_buf_length) {
>> +			goto err_out;
>> +		}
>> +
>>   		return ksmbd_lookup_dialect_by_name(req->DialectsArray,
>>   						    req->ByteCount);
>>   	}
>>
>> +err_out:
>>   	return BAD_PROT_ID;
>>   }
>>
>>
>
