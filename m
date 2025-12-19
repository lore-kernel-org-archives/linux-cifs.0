Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4649979CD
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 01:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766107012; cv=none; b=uwSTTMaZqaa/hD+Kkrhtg1XSqUk1LpNmSUPkyH62j61Ue0MxqV++BwVmVFuVwc1HK/OpCMXZYve2cqvNBfiL2cyGPFKz6hZeITUi8l/c+TCBJtdlergwnTTnPvLuMS4OwL0Kds1mm29Soagkap2IeO8nihPtKkXJzUstkB0hUvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766107012; c=relaxed/simple;
	bh=HY14TeZn3A+IOIFjTghsV84GinIJFnMLyRBZVvipHvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=axp0S7uL3rcL/txB+99SjN+5VFxTtheMAJaV2ZDLQ0VuEjagGKsSYimRGNXAkx5+7t56jwou2NPq2+sfdzm8YTqQ4ow0q5cBoH0nXrKle0gN36IMllEBTQRGv6GBKiYBQfRG/Y15KzA3zmh8bxkTJr2qC58KeTEqDY79Z2ynMQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMGLGaje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMGLGaje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4CBC116C6
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 01:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766107011;
	bh=HY14TeZn3A+IOIFjTghsV84GinIJFnMLyRBZVvipHvo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WMGLGajecG+giNhC9ZgRL/WIh1xQvMXScJWpxfLXrqzBtrfefttxDqPA+QAGLmkob
	 6UpCooXlJKoTxu7B7yEofe7JRdKM436canVpY7nmsb6RTePh2SzVBeNzwshQ/x4M4S
	 b+JwbEzp36hFojBNh2bAYDRXckf7NvuniwMW1Nq0EM8dCun0kS3hJXiKYzlB1BAfmF
	 YC6zyCdgE3I3fAVIeZU9nffktyX9fEOeHELHAm2zMs/WVWDQh0qRL+sPIkvjOf6u9u
	 k6cWVTyYt8eg6lFco0pFC534wQBRHQ2HB27OQFqiKWl/4CP/23x/5Mdh01nOfojlIl
	 oIZonAFRz3hig==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so2360794a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 17:16:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV++i8A15t3jbWm/TyRS4EeNM0Af7oPILMzwygwEA4z42Z7R82Y7VSwNTlbmHLJXAkwkqPNb0jetHd4@vger.kernel.org
X-Gm-Message-State: AOJu0YzPYCnCxeebb2JKu6lBmDKU6J/eWA0g48yQaQuk0IBhze5LBT0V
	cKbv7xE9wevqwHvhOR2WvyGpIcB/soQulKE6PKu7IMwGfr+49YyfHYGJHBbW2+2ixXuj2OodlFl
	4sM5y2smwfCXQxTZVpUbTGf1JeBR09+c=
X-Google-Smtp-Source: AGHT+IHsBaNLWtA8yidoJl8PxlwZDnm8+Apsg9dpNfoSeOe6w1ex9vlgpHv1GFPrAxuHKCJyn8uafHpfdC6BjiiJDYw=
X-Received: by 2002:a17:907:3d91:b0:b7a:1b3:5e5d with SMTP id
 a640c23a62f3a-b8036f0a474mr126523666b.8.1766107010204; Thu, 18 Dec 2025
 17:16:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com> <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev>
In-Reply-To: <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 19 Dec 2025 10:16:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
X-Gm-Features: AQt7F2q5X88kbtLvhE3iIU9jfdt3AA9dz9Q_3CmClnOe4yBVy4M4SF4GAhVUNNs
Message-ID: <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, sfrench@samba.org, smfrench@gmail.com, 
	linkinjeon@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 10:00=E2=80=AFAM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Hi Namjae,
>
> We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and
> `SMB2_MIN_SUPPORTED_PDU_SIZE`.
>
> But we "should not" add "+4" to them.
Not adding the +4 will trigger a slab-out-of-bounds issue.
You should check ksmbd_smb2_check_message() and
ksmbd_negotiate_smb_dialect() as well as ksmbd_conn_handler_loop().
>
> The `ksmbd_conn_handler_loop()` function is as follows:
>
> ksmbd_conn_handler_loop()
> {
>    ...
>    pdu_size =3D get_rfc1002_len(hdr_buf);
>    ...
>    if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
>    ...
>    if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
>    ...
> }
>
> Thanks,
> ChenXiaoSong.
>
> On 12/19/25 08:16, Namjae Jeon wrote:
> > On Fri, Dec 19, 2025 at 2:11=E2=80=AFAM <chenxiaosong.chenxiaosong@linu=
x.dev> wrote:
> >>
> >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >> See RFC1002 4.3.1.
> >>
> >> The LENGTH field is the number of bytes following the LENGTH
> >> field.  In other words, LENGTH is the combined size of the
> >> TRAILER field(s).
> >>
> >> Link: https://lore.kernel.org/linux-cifs/e4fbcbad-459a-412c-918c-0279e=
c890353@linux.dev/
> >> Reported-by: David Howells <dhowells@redhat.com>
> >> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> ---
> >>   fs/smb/server/connection.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> >> index b6b4f1286b9c..da6dfd0d80c2 100644
> >> --- a/fs/smb/server/connection.c
> >> +++ b/fs/smb/server/connection.c
> >> @@ -296,7 +296,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
> >>   }
> >>
> >>   #define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
> >> -#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
> >> +#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr))
> > +4 is needed to validate the ByteCount field of the smb1 request and
> > the StructureSize2 field of the smb2 request. Let's change the macro
> > name from HEADER_SIZE to PDU_SIZE and add +4 to
> > SMB1_MIN_SUPPORTED_PDU_SIZE.
> >>
> >>   /**
> >>    * ksmbd_conn_handler_loop() - session thread to listen on new smb r=
equests
> >> --
> >> 2.43.0
> >>
>
