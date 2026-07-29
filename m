Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1973DE45C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 23:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785367328; cv=none; b=tCAmxKQrKFm8EbAoIW/4NNuB9d0Z+3DzwloTXvZfzOU+PCgtmXpAwbh/OBzfKjOCZKLJQaLgHeUMB4ReWniZBrkm5sgRaa9sVo+9/lEeGH3FW9yu8E7U6AzPwuerRCMEKnr9FtbaH4kuJxcRolSdZYoUBSWqBFceuu+3VBTkVQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785367328; c=relaxed/simple;
	bh=t/p7i2s0+EkDdU/pGdz4xcdLWwho6DIWr9TwDjaS2v0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QeokWZXubRO7SOajARHjW6tQK+VPhuLAwq7Pm+gqGXZUv9z1TpWSZ5RpeDcKqAOKhw+PmPYu9gFjD+KwuRJP5lhBXwWwQOzshWF73KJYZ5stAlm1rESW9OWN19Ntl9oV/VVj2PJMC5vQTZ2mxvePUqDpVXrP/ZhAvc36PJY1F1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VaM14Iei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VaM14Iei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1711F00ACA
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 23:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785367326;
	bh=r9mvrMAjFtQPWl/4xrWCbi8W8Rt0p8EN58Vi3L5Dj9E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VaM14IeijML2GLKlkWX8DYe5SXGZ+LFq4AMOB9wCs4BpIv83FNFbdC+9DNmiNY84i
	 /VAgsfrRO7vtbvXOjHTYgzKtPp60Q8D525jWmmVna2VqxQk2lWS/CHarXKqTETOb5v
	 eODx7PuMV5gUvnRqSAAch/MgmYngj8nAIiy9vc+V8+yzj924kLTExriiV8zqhgZb0W
	 9hwD9cR4JxpiUgkzykCFxymu7rs0gY85BNJgF/rPuq7VgenUs+pYTh2A4w9/GsuJIL
	 432BhKNDIHDgA3DrZPv7Oj9myWanMiI9O9AUbAUT0Muh22/dmgteYPDmpq5rGR685N
	 cQQ3K6E0fgewQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-698acd36d67so2662570a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 16:22:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YxYHsOozJ/p7OuC1EatCXUMdWS0I0Zfsvfv7dGIl7yEs+XW5iyh
	D/PXI0IT19MBu1PkPWh1G4TFAtHt1LzI5du3KGP4D1a37CifdB4KCJcCq4XBY8ZLse3vDiey7dJ
	RUJQ5NEtsI9VAEUWo38qqoTD8f8QEHEI=
X-Received: by 2002:a17:907:c08d:b0:c1f:a370:7c2e with SMTP id
 a640c23a62f3a-c1fa571e0c8mr17124966b.23.1785367325376; Wed, 29 Jul 2026
 16:22:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720194925.2108840-1-ematsumiya@suse.de> <20260720194925.2108840-13-ematsumiya@suse.de>
 <CAKYAXd_mkSR_=krs0idmhR_uYxUTzHAFK1cB7tZRtNfMJUSsRw@mail.gmail.com>
In-Reply-To: <CAKYAXd_mkSR_=krs0idmhR_uYxUTzHAFK1cB7tZRtNfMJUSsRw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 30 Jul 2026 08:21:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9-DNGr61h9A-npJrT2Dh-G5h=6fnMbqW=5NayTr7ym2Q@mail.gmail.com>
X-Gm-Features: AUfX_my2GonJhrbgzykj3vjTc9T7hM1-me5hoPKa5xVwnCtF76yOL_SurF55LoI
Message-ID: <CAKYAXd9-DNGr61h9A-npJrT2Dh-G5h=6fnMbqW=5NayTr7ym2Q@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] smb: server: use smb_decompress_alloc_size() in ksmbd_decompress_request()
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 25, 2026 at 10:08=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org=
> wrote:
>
> On Tue, Jul 21, 2026 at 4:50=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >
> > Use common helper to validate compress header and get decompressed size=
.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> I can not apply this patch to #ksmbd-for-next-next.
> Can you create this patch based on #ksmbd-for-next-next ?
>
> > -       max_allowed_pdu_size =3D SMB3_MAX_MSGSIZE + conn->vals->max_wri=
te_size;
> > -       if (out_size > max_allowed_pdu_size ||
> > -           out_size > MAX_STREAM_PROT_LEN)
> > +       buf =3D smb_get_msg(conn->request_buf);
> > +       out_size =3D smb_decompress_alloc_size(buf, pdu_size, 0,
> > +                                            SMB3_MAX_MSGSIZE + conn->v=
als->max_write_size,
> > +                                            conn->compress_chained);
> In ksmbd_decompress_request(), the old code rejected decompressed
> messages smaller than sizeof(struct smb2_pdu).  The new helper call
> passes 0 as dmin.
> So you need to pass sizeof(struct smb2_pdu) as dmin :
> out_size =3D smb_decompress_alloc_size(buf, pdu_size,
>                                            sizeof(struct smb2_pdu),
>                                            SMB3_MAX_MSGSIZE +
>                                            conn->vals->max_write_size,
>                                            conn->compress_chained);
>
> Except this, The other server and common patches look good to me. I'll
> leave the client patches to the cifs.ko developers.
If you do not send the v3 patchset by next week, It will be difficult
to merge into the 7.3 kernel.
