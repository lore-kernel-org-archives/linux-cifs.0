Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7627C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 23:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFA6260F24
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 23:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhIVXOh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 19:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238388AbhIVXOh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 19:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BFF160F24
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 23:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632352386;
        bh=4PIgJbS2rq/+Pm76zW98EnG0dqExgnvC11TmKQQp5xw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=thSl/Tb3vlF4MrFpA/pbkoVFWnez8aleMvuSoetJzxXctDYm0psFh9l1D2za8kbMz
         4nxJPi5c91S4xVzEUdmSDmyaEyyxXZbIYjb+ZIHfXRlYNaM17BbCa0pijVbwNWTUC/
         k1N1r4uhz7F23nNVQv1ZTTC2mptsXkpU00yUkUU2/Al1Z8cDrFOe4GOI8hesQOCEAI
         Mt0Hd9pgyQZ30gUonPLAsxwq8qMY5aqK2OT6+bK99QWRYV0PH0aumsj7Of2NSuPg48
         N3lKUCRNBuU+SLtR/DaILk1bYN9Yh6tx8n55RIlldHwrLORZnlvWI3A5t7CsCLogGi
         zyzsdLpyeXHNQ==
Received: by mail-ot1-f46.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso5888136otb.11
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 16:13:06 -0700 (PDT)
X-Gm-Message-State: AOAM531Ww6xC9jp2hV16mL8D81QxMg36KMrWYtP/L54XT6vM+Wj3N537
        HwDglONpNjyZjZriwhiGFHbMbZpTdDiAokfmcDQ=
X-Google-Smtp-Source: ABdhPJyVF2nbEWSNtzGC3A+aPFY53dtOhYgyacFBhYJK5sXK3jVNgVxR2kFDf1PviTYItYaAUTNZebe5+KgCchKsKdw=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr1477120ots.185.1632352385743;
 Wed, 22 Sep 2021 16:13:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 22 Sep 2021 16:13:05
 -0700 (PDT)
In-Reply-To: <433e36b5-f07c-0105-fd30-c7bb4cb8957d@samba.org>
References: <20210921225109.6388-1-linkinjeon@kernel.org> <20210921225109.6388-2-linkinjeon@kernel.org>
 <433e36b5-f07c-0105-fd30-c7bb4cb8957d@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Sep 2021 08:13:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+jfKqonB8=At-znCUBpF-J8Z3NfK=vvUJOfcUMFemoQ@mail.gmail.com>
Message-ID: <CAKYAXd-+jfKqonB8=At-znCUBpF-J8Z3NfK=vvUJOfcUMFemoQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ksmbd: add validation in smb2 negotiate
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-22 23:17 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae
>
> patch looks great! Few nitpicks below.
>
> Am 22.09.21 um 00:51 schrieb Namjae Jeon:
>> This patch add validation to check request buffer check in smb2
>> negotiate.
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c    | 41 ++++++++++++++++++++++++++++++++++++++++-
>>   fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
>>   2 files changed, 60 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index baf7ce31d557..1fe37ad4e5bc 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -1071,7 +1071,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>>   	struct ksmbd_conn *conn =3D work->conn;
>>   	struct smb2_negotiate_req *req =3D work->request_buf;
>>   	struct smb2_negotiate_rsp *rsp =3D work->response_buf;
>> -	int rc =3D 0;
>> +	int rc =3D 0, smb2_buf_len, smb2_neg_size;
>
> I guess all len variables should use unsigned types to facilitate well
> defined overflow checks.
As Ronnie pointed out, if checking max stream size, will be no problem.
I'll fix it though.
>
>>   	__le32 status;
>>
>>   	ksmbd_debug(SMB, "Received negotiate request\n");
>> @@ -1089,6 +1089,45 @@ int smb2_handle_negotiate(struct ksmbd_work *work=
)
>>   		goto err_out;
>>   	}
>>
>> +	smb2_buf_len =3D get_rfc1002_len(work->request_buf);
>> +	smb2_neg_size =3D offsetof(struct smb2_negotiate_req, Dialects) - 4;
>> +	if (conn->dialect =3D=3D SMB311_PROT_ID) {
>> +		int nego_ctxt_off =3D le32_to_cpu(req->NegotiateContextOffset);
>> +		int nego_ctxt_count =3D le16_to_cpu(req->NegotiateContextCount);
>> +
>> +		if (smb2_buf_len < nego_ctxt_off + nego_ctxt_count) {
>
> overflow check needed for 32 bit arch?
Okay, will fix it on v3.
Thanks!
>
>> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> +			rc =3D -EINVAL;
>> +			goto err_out;
>> +		}
>> +
>> +		if (smb2_neg_size > nego_ctxt_off) {
>> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> +			rc =3D -EINVAL;
>> +			goto err_out;
>> +		}
>> +
>> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
>> +		    nego_ctxt_off) {
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
>> index 1da67217698d..da17b21ac685 100644
>> --- a/fs/ksmbd/smb_common.c
>> +++ b/fs/ksmbd/smb_common.c
>> @@ -229,13 +229,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialect=
s,
>> __le16 dialects_count)
>>
>>   static int ksmbd_negotiate_smb_dialect(void *buf)
>>   {
>> -	__le32 proto;
>> +	int smb_buf_length =3D get_rfc1002_len(buf);
>
> unsigned
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
