Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2BDC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 01:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4452E613DB
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 01:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243525AbhI2BmU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 21:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhI2BmU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Sep 2021 21:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0936140A
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 01:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632879640;
        bh=GQZFz6N+ycAcPIEpKNRvges497BhSIH9A1V8Zkz1aMs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=sKVnIdcYAF1Prh7E+pRNv2Zye0O4vntJ4zV2CKJe8HzZ0gER1iEQH7b0HSgnuO1Vf
         Gv/mdXdJ9MvVeQmRKPYsXBrM8AuWqrcDtg7STtlq9LSqftfwIcg0HfOVTK1zARtg8R
         gH5a8Hn0qVDaOOxqAUOrWyrJMlMli3ZjNy0NguMCTzjK3IVDbVjNecoM819aU70Ukj
         UVxXY5m3H1vZ+V7572PnEDE0GnrowU0sd/oufhh7UdXjQJ3TnUdjmAWs/Cx8pV9c+S
         gDGH0lqP6/eB3Z3A6Dbj2OYxBvznEliW3NAr4NRTT+VNP0MuWSw/UpMBPoWu4O4Itd
         /UU49nI0n9fNw==
Received: by mail-oi1-f180.google.com with SMTP id 24so968650oix.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 18:40:39 -0700 (PDT)
X-Gm-Message-State: AOAM5324sLu1kg/qqy+cH+dY6d038Sy22IAUOKLwAEdqPP4nGzYjj03d
        4GOn9Dysgtd9d/0WLwRns2N51JZnyFGpE5j2AAs=
X-Google-Smtp-Source: ABdhPJxUb5GVW7PZYKvm4wvTwBsyWC0xYRnXchjHL/y5yeIZJr8weq02YP6S0SafgYAuIOXhifJlC+pz6xFCKiZWI5I=
X-Received: by 2002:aca:3704:: with SMTP id e4mr6051891oia.32.1632879639278;
 Tue, 28 Sep 2021 18:40:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 28 Sep 2021 18:40:38
 -0700 (PDT)
In-Reply-To: <18b746cc-e790-19ad-c0e5-a2338c7c6359@talpey.com>
References: <20210927124748.5614-1-linkinjeon@kernel.org> <18b746cc-e790-19ad-c0e5-a2338c7c6359@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 29 Sep 2021 10:40:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_5fK8c09N0G6fu=-LXFhGBES4FgWgBWONcCh=zXuDdOw@mail.gmail.com>
Message-ID: <CAKYAXd_5fK8c09N0G6fu=-LXFhGBES4FgWgBWONcCh=zXuDdOw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: remove the leftover of smb2.0 dialect support
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

2021-09-28 23:46 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/27/2021 8:47 AM, Namjae Jeon wrote:
>> Although ksmbd doesn't send SMB2.0 support in supported dialect list of
>> smb
>> negotiate response, There is the leftover of smb2.0 dialect.
>> This patch remove it not to support SMB2.0 in ksmbd.
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb2ops.c    |  5 -----
>>   fs/ksmbd/smb2pdu.c    | 15 ++++-----------
>>   fs/ksmbd/smb2pdu.h    |  1 -
>>   fs/ksmbd/smb_common.c |  4 ++--
>>   4 files changed, 6 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
>> index 197473871aa4..b06456eb587b 100644
>> --- a/fs/ksmbd/smb2ops.c
>> +++ b/fs/ksmbd/smb2ops.c
>> @@ -187,11 +187,6 @@ static struct smb_version_cmds
>> smb2_0_server_cmds[NUMBER_OF_SMB2_COMMANDS] =3D {
>>   	[SMB2_CHANGE_NOTIFY_HE]	=3D	{ .proc =3D smb2_notify},
>>   };
>>
>> -int init_smb2_0_server(struct ksmbd_conn *conn)
>> -{
>> -	return -EOPNOTSUPP;
>> -}
>> -
>>   /**
>>    * init_smb2_1_server() - initialize a smb server connection with
>> smb2.1
>>    *			command dispatcher
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 88e94a8e4a15..b7d0406d1a14 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -236,7 +236,7 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
>>
>>   	if (conn->need_neg =3D=3D false)
>>   		return -EINVAL;
>> -	if (!(conn->dialect >=3D SMB20_PROT_ID &&
>> +	if (!(conn->dialect >=3D SMB21_PROT_ID &&
>>   	      conn->dialect <=3D SMB311_PROT_ID))
>>   		return -EINVAL;
>
Hi Tom,

> This would accept any in-between value! That, um, would be bad.
>
> This needs to be a much stronger check, especially since significant
> state is being built in the lines that follow this segment.
Will fix.
>
>
>> @@ -1166,13 +1166,6 @@ int smb2_handle_negotiate(struct ksmbd_work *work=
)
>>   	case SMB21_PROT_ID:
>>   		init_smb2_1_server(conn);
>>   		break;
>> -	case SMB20_PROT_ID:
>> -		rc =3D init_smb2_0_server(conn);
>> -		if (rc) {
>> -			rsp->hdr.Status =3D STATUS_NOT_SUPPORTED;
>> -			goto err_out;
>> -		}
>> -		break;
>>   	case SMB2X_PROT_ID:
>>   	case BAD_PROT_ID:
>>   	default:
>> @@ -1191,7 +1184,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>>   	rsp->MaxReadSize =3D cpu_to_le32(conn->vals->max_read_size);
>>   	rsp->MaxWriteSize =3D cpu_to_le32(conn->vals->max_write_size);
>>
>> -	if (conn->dialect > SMB20_PROT_ID) {
>> +	if (conn->dialect >=3D SMB21_PROT_ID) {
>>   		memcpy(conn->ClientGUID, req->ClientGUID,
>>   		       SMB2_CLIENT_GUID_SIZE);
>
> If SMB2.1 is now the minimum supported dialect, why is this GUID
> insertion made conditional?
Yep, Will remove this condition.
>
>>   		conn->cli_sec_mode =3D le16_to_cpu(req->SecurityMode);
>> @@ -1537,7 +1530,7 @@ static int ntlm_authenticate(struct ksmbd_work
>> *work)
>>   		}
>>   	}
>>
>> -	if (conn->dialect > SMB20_PROT_ID) {
>> +	if (conn->dialect >=3D SMB21_PROT_ID) {
>>   		if (!ksmbd_conn_lookup_dialect(conn)) {
>>   			pr_err("fail to verify the dialect\n");
>>   			return -ENOENT;
>
> Why is verifying the dialect *ever* conditional on the dialect value???
Will remove it.
>
>> @@ -1623,7 +1616,7 @@ static int krb5_authenticate(struct ksmbd_work
>> *work)
>>   		}
>>   	}
>>
>> -	if (conn->dialect > SMB20_PROT_ID) {
>> +	if (conn->dialect >=3D SMB21_PROT_ID) {
>>   		if (!ksmbd_conn_lookup_dialect(conn)) {
>>   			pr_err("fail to verify the dialect\n");
>>   			return -ENOENT;
>
> Ditto previous comment.
Will remove it.
>
>> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
>> index 261825d06391..a6dec5ec6a54 100644
>> --- a/fs/ksmbd/smb2pdu.h
>> +++ b/fs/ksmbd/smb2pdu.h
>> @@ -1637,7 +1637,6 @@ struct smb2_posix_info {
>>   } __packed;
>>
>>   /* functions */
>> -int init_smb2_0_server(struct ksmbd_conn *conn);
>>   void init_smb2_1_server(struct ksmbd_conn *conn);
>>   void init_smb3_0_server(struct ksmbd_conn *conn);
>>   void init_smb3_02_server(struct ksmbd_conn *conn);
>> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
>> index b6c4c7e960fa..435ca8df590b 100644
>> --- a/fs/ksmbd/smb_common.c
>> +++ b/fs/ksmbd/smb_common.c
>> @@ -88,7 +88,7 @@ unsigned int
>> ksmbd_server_side_copy_max_total_size(void)
>>
>>   inline int ksmbd_min_protocol(void)
>>   {
>> -	return SMB2_PROT;
>> +	return SMB21_PROT;
>>   }
>>
>>   inline int ksmbd_max_protocol(void)
>> @@ -427,7 +427,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn,
>> const char *longname,
>>
>>   static int __smb2_negotiate(struct ksmbd_conn *conn)
>>   {
>> -	return (conn->dialect >=3D SMB20_PROT_ID &&
>> +	return (conn->dialect >=3D SMB21_PROT_ID &&
>>   		conn->dialect <=3D SMB311_PROT_ID);
>>   }
>
> Ditto previous comment. And after fixing it, why is this helper not used
> everywhere?
Will use this helper.

Thanks for your review!
>
> Tom.
>
