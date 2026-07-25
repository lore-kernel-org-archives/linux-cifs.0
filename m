Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693CA27732
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784984946; cv=none; b=sBQ5+Ag9tVO62YUc3Eh5pMSZHYgOG2PPj/FBBkHYN7ztwebdDkFRtmB6nJj6G1O76oksUMQ+ik0v4fRgyjdUk+iqY49ccKZjmZ7KdeFVb3fdwZvlM9eokOyaCwUw9z9Z0k6bMiouhVNm0ko2NuAkqvrRRATZGR4tb3IBtIIg304=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784984946; c=relaxed/simple;
	bh=tUDc4wO/RkFoJR9PdH6VXRoZz/cw6bz2snvradO+M38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=byA8NkdPJL1iLy7PG0Lj6SqKyAHTm1cvAJMnbFplELO3PpVZlwG7CmVBvB6ixnrSX5g5xSg3Hnjt0J4AfLxttNIf5aXCkT1ej5ETDaYuE4BQR2GAE/4usPZKVfQTzgCuOqYwAsDJIt5n5CYPVF4al4pjwFEiJdBEW/LgdKCLsto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2ar2/Rf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2ar2/Rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E1D1F00ADE
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784984944;
	bh=dqJRUcnkihnR7XpQ9GFE4EqRxnQhiUmu13jvSJrA20Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a2ar2/RfdfxFUnunDxXwA6ypgCCZrNuqPD3VWg8M3401KbDMygVc8ScpNofPAaibM
	 2P5mpH0ZP3kYfJo765dkVQexd8K8ZQepT4aIXY+0Htsqb5z/dfpLsxOtaJGXsvUOLY
	 NtRTOOTyIsZy2vuh5ZRq8WfrIFIvsESPp1kBrwVWKRpFrnpwUqNCP6XVhmXrbY9wQJ
	 44+EUCjyXiXLbbXvFvI0Ra6VI9YnFq1wvYXcnI4Xa4G9VF5Pzx/ZtxXTNCgH1a/wC9
	 Muwer6PxvdL1oBiZMcOb2b9519x4pDw16te0+o8OdgFE0kRUzEq4Dw9xvQiYm0APkl
	 0iUi89mauxJmQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c197f968b3cso189582866b.2
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 06:09:04 -0700 (PDT)
X-Gm-Message-State: AOJu0YzPCKMwn43zqPhGjg5X3INzVSvYJoEiFOMAqep881tDnfbATfUm
	9PHYy7WTOrLOQk0+gLR9GnS/dtFb6u87X2kwKWl0xkKjghzZteHZ0Wakbm0RVhotzzLG5tISefW
	k2n6Ka7/uCn0r2p4WieLtrV4CPOMneSk=
X-Received: by 2002:a17:907:7250:b0:c12:1651:17b2 with SMTP id
 a640c23a62f3a-c1f1eabe9afmr98450966b.9.1784984943421; Sat, 25 Jul 2026
 06:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720194925.2108840-1-ematsumiya@suse.de> <20260720194925.2108840-13-ematsumiya@suse.de>
In-Reply-To: <20260720194925.2108840-13-ematsumiya@suse.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 25 Jul 2026 22:08:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_mkSR_=krs0idmhR_uYxUTzHAFK1cB7tZRtNfMJUSsRw@mail.gmail.com>
X-Gm-Features: AUfX_mwrSgGOknJJOFdWaJV3zT1uFy5Y9dfaNfHSPIla9dwuInm1MD6V0HApT54
Message-ID: <CAKYAXd_mkSR_=krs0idmhR_uYxUTzHAFK1cB7tZRtNfMJUSsRw@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] smb: server: use smb_decompress_alloc_size() in ksmbd_decompress_request()
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 4:50=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Use common helper to validate compress header and get decompressed size.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
I can not apply this patch to #ksmbd-for-next-next.
Can you create this patch based on #ksmbd-for-next-next ?

> -       max_allowed_pdu_size =3D SMB3_MAX_MSGSIZE + conn->vals->max_write=
_size;
> -       if (out_size > max_allowed_pdu_size ||
> -           out_size > MAX_STREAM_PROT_LEN)
> +       buf =3D smb_get_msg(conn->request_buf);
> +       out_size =3D smb_decompress_alloc_size(buf, pdu_size, 0,
> +                                            SMB3_MAX_MSGSIZE + conn->val=
s->max_write_size,
> +                                            conn->compress_chained);
In ksmbd_decompress_request(), the old code rejected decompressed
messages smaller than sizeof(struct smb2_pdu).  The new helper call
passes 0 as dmin.
So you need to pass sizeof(struct smb2_pdu) as dmin :
out_size =3D smb_decompress_alloc_size(buf, pdu_size,
                                           sizeof(struct smb2_pdu),
                                           SMB3_MAX_MSGSIZE +
                                           conn->vals->max_write_size,
                                           conn->compress_chained);

Except this, The other server and common patches look good to me. I'll
leave the client patches to the cifs.ko developers.

Thanks.
