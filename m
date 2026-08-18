Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DDE3612F8
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038319; cv=none; b=i2PSHiFCjdiaw8fs/RDZNbIGKDYREZub1tgks0yHGt6tAWjAtssUdNhfu3J/M1ijw7p2AgY+VT59eEmvG8dhTsCdtuf6F07yoA4JssSIruUwMl7TngT8k6J9cH60EJZu/0UyTlIYsJL8AmGvsOALnOyAYjDhDHdKVfCntIuaQa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038319; c=relaxed/simple;
	bh=+qYEbrsbxj7e9WQzvoPeckK44XOr8IeXkOfRcwGoItc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=blpx5p+PWZ9Zh9/3iUFnjfDz8mQosbTCZrkMSUTI/aZ+vU9+jsT16Ouublyn5nuQiCiJDzoiZFoe28SPdyZL0HukWGfb0EQWCW0PPiz1CxnX8JwiwaXHvcqAbIkMi6+95u6TSmvoM8m6Rjzx4PTy/EwmW4PKSb3tYOWAtBcjaIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwmmCRaE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwmmCRaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1CB1F00A3E
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787038318;
	bh=fgU1zVBtw16i3Xm5dVnrej6Xkx66zn4xXZdqZiqmMe4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jwmmCRaEd7pqX2Mbtyl5Nr0TzvSVYM9cYBUrrRhk+kwvToYclAE3VIY+EbKo3BFhS
	 cxQhNeEnvoETGEBY4cHJxHUd01LcM0Z4jq3sSy1GSERO54yW8vnlZmOLqxN4NYOrsR
	 /Gu+g+CTozsQWrotWzm/cLmtdPMZzzNjbtc5lDOuVYW27uFu7izpk82tugmLVm8CZI
	 8eXuSeA01JRlP840fihBFPDj70oBJEtIru/MsdocGW/bJwquGwEpPA+y6EI3sA5ipP
	 O7wYm0CpHEGP9COziZ9TKPXXmQxCsKFyxI1sa8cuKMPDh420tkQ5UeD1nzm77aCoAI
	 M4Wh9YBtrfpkg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15e592da74so584806566b.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:31:58 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyev0qnCjOsU60DkqSmQFWkCQ1PlN9bDDaIX7DDo2Jz31+oTGw1
	+LUhzkjGQidH0AyPAc1jTgiZGBDYGcv+pkb7qpXjF1NGk7RNfk31xHqy83iU5pyhDIpimvlAtgz
	hCEOk7ILmOYb6pr4gOyKttcZ1ALvUiiY=
X-Received: by 2002:a17:906:fe02:b0:c16:9edc:612e with SMTP id
 a640c23a62f3a-c212a090d19mr1497844066b.3.1787038316995; Tue, 18 Aug 2026
 00:31:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260817171657.212776-1-sorenson@redhat.com>
In-Reply-To: <20260817171657.212776-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:31:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8sLqY_j4yRQy1vassOwqovocJACH71Y2Zsv1YSetYs+w@mail.gmail.com>
X-Gm-Features: AcwNN1Wyl_fTX05l4Fm8c5G-HZiGJsoB1qry4FfCMhYS_uF0xlXDr7lpTUK1Lxk
Message-ID: <CAKYAXd8sLqY_j4yRQy1vassOwqovocJACH71Y2Zsv1YSetYs+w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix use-before-check of ReparseDataLength in reparse_buf_ptr()
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 2:17=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> reparse_buf_ptr() reads buf->ReparseDataLength before checking that
> count covers the full fixed header:
>
>     buf =3D (struct reparse_data_buffer *)((u8 *)io + off);
>     len =3D sizeof(*buf);                          /* 8 bytes */
>     rdlen =3D le16_to_cpu(buf->ReparseDataLength); /* offset 4, 2 bytes *=
/
>
>     if (count < len || count < rdlen + len)      /* check comes after */
>
> struct reparse_data_buffer has ReparseDataLength at offset 4.  If a
> server returns OutputCount < 6, the read at offset 4-5 reaches past
> the end of the received data.  The off+count bounds against iov_len
> were already validated, but that does not protect against count being
> smaller than sizeof(*buf).
>
> Split the check: verify count >=3D sizeof(*buf) before reading
> ReparseDataLength, then verify count covers the data region.
>
> Fixes: a158bb66b137 ("smb: client: optimise reparse point querying")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Will appy it to #for-next with Paulo's acked-by tag.
Thanks!
