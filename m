Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB483382CB
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 23:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781824913; cv=pass; b=UWntIoO2/eIxHWz1bRjl/pOmhxuVcTVFE/tleKzbC7wIyqNVpqUyKS1xiXnV2ykaFr7FcJACjfROlPlZFxPGcnVZwQrJDFkcImqqBTbcSTCgoJCK/Fit30zWdHbJQpP5kSRG7m5KdNDwFUjfhIkutPkw1C5fmsyAO5gFaU1id00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781824913; c=relaxed/simple;
	bh=ce7+7YVBK5mb1J1lThyUA/OeHQ6mPK8XAghbGOc/sDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ynna0hiCJqH1J9oiwGEVk6YKa8Gs2gfcFzJMjh0JlqSXyrmOM49+KgBYrnPWlyD6co9GgX8eJ9nNNsLPEfFyHenapO0TiUZJHzRP1a9p+GrgOj7W+xiet29HDJFFh1F/sg5JivNmaWO6yno1HfFYglnRzYedUSk+cnMaArzqjCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z03oyUMX; arc=pass smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z03oyUMX"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-915ab38ac14so210197885a.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 16:21:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781824910; cv=none;
        d=google.com; s=arc-20240605;
        b=h6h9nLgvy4MOywGamc4Cqx+/gMSu5wRHBHqWR4gT08DRqhb+u148fCxc2miPO5xkj0
         cjo9IP33om55jL9k15B2zrh1tXdB5QF5Q89SKbN9XItRy00w2uDmRJfVkGW2wMdjKsmO
         Y86Z5mAAQCQjv5Ch0EYpgxd9fQjblwVskuB0ve1GqR9U2u+pH9pdnzPhHVTSPjCsSiIr
         DqcO+LUOZACRBtU0wbFmgNasDdT4h3Tq/Rx84J3gpDdJ1G3xA/rlVb2wgnmyawUWQ6Jl
         3xDRfHY4nA3aaO/bPMkUwdvUjihVu/L4S6hPVR2UKCH2whsRjT+CxyV0bbwjw3IlIYLU
         rHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VRC/6Xjju81rcRtghBQZKowgyZuVVUJEp1YIosE2KkU=;
        fh=5ioywmNvHv5E9nMaKYbbuCCtesbFkm58zEGgEFEalxM=;
        b=JaS5+1obooKFlIOrXRaABUKwUfwZg/IAq2onFx66MzSUerHmx9GPlfcVeK/RRxCM8K
         x6B5pS0OzBzVqYFRJ7pH0k3O5GK6oB3hyNIDtGywEvipRKC+iJJQnTPKxs3IxH6hBqlx
         BaP2g0Eh/HAo8y5ydFWZ1iPxddREdMjz6moahr2jZ3NVIkfbG4tY7FfymdTEAeym6ARc
         xPmbOqd2PtAOAge7HUqy6/pU/a4zL8FDXABUgP+cd3xeFbzWezHu92sOQFXWOr3vwCDC
         +e91YYn0DImg+OLbOP84j1erHNep7XoIKbBNxIFD8ALgxDH4Qk/6r54iQjJbGW9bvSla
         uSqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781824910; x=1782429710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRC/6Xjju81rcRtghBQZKowgyZuVVUJEp1YIosE2KkU=;
        b=Z03oyUMXQkBB8JtdCsQ47x5bzdwYe/ptvI4on+xwVpt3kaZi8V6/g65geJYUoGpXEP
         lHDmElZkNJ/zGoX1jRkkvZY7HDjRHI/xmlsY6JKT/axhd8JC3Pfzg5T6jGRf1p81veL2
         dAZJTewxA6ZtK4P5XW1NLTJvcPoQ7L0d+GxHQOOdW8896fSiu3hIUk4RGnoHqJNXdyzO
         +4L0B5JET3KyLJHqncUplDwgzfK/EOmPJAl1J5RP+EYloXhDrDuJRX3qQEpf2ForYCW4
         7WPeBEf5tkVeUBPc8T07SEW0uJc1OS1y4SvbJOQCY+mznxdpfzXMZ7Lidv56cEWfktIH
         Psow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781824910; x=1782429710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VRC/6Xjju81rcRtghBQZKowgyZuVVUJEp1YIosE2KkU=;
        b=AgWXCWppXS6ZJHvOoMRKNkOuqTM0m9INvBL56fSERHboEqSwEfFIHONTdbBXQAiuAr
         J5g+0yewZG9QEAnPnQJT039mvBJxfaqxqByh2u05oFR0+2aT6qxlPOMyK+ZeAS3gOZ6S
         Xf2b6qWrwgBYsP++o9RaLNOIXufhE6lJn1M3OGuf5nR5YPlWL/VgOyvq2BdmzDRjByGP
         CbtEA5O+GI8FJjJNXIc4C6UL287ZWqEmxORATfeNAlKyGOMLQrKLPpCSazblB8RiMnk2
         S+npWf9o+KlpHe/waE9HlIQ8RNawShHslEd4R8OHmCu+9MQxfjCSQvxfheZeRZf8rakM
         QbWg==
X-Forwarded-Encrypted: i=1; AFNElJ9ZQ+vOXd/LJcWMzmLie4gqpjWFhnOT7HF+bDTZtWmG8ehmDxQ7HhRFjtuc7K8W+WaB0p1c0E2vAZoV@vger.kernel.org
X-Gm-Message-State: AOJu0YxhU1z0vW/8vkP5eztF8WeRFuO0h84ArnATU9TznXeqEPgxLaIb
	zMfOPhNZJVEzO6pD3xt6d/iAcaLj8y5WJtGyJcCpWFrJwOFOXx4ejcnumQklY3El4P6Av9u5lO4
	0Ma04OVSpC4kpBUVpQ11cj/3TxPkNu1M=
X-Gm-Gg: AfdE7clw1qhALjjRFMJlCXCLPNoClBbROodiO+jL1PtFFcwwCj7243hrqCKyZHjxtzG
	eycVnhmlDbdw2jkQhcsI6mKNRXAVSdUlrj7mOqI2YQ7AIOXl6YXuOvJuQJkph0OQm/Ax6FxP92s
	pozQVWHOqeWkfCCKvb1WNNZ9Bv3AdpS7Ou9FdZ7IerWBgpDvpoRGXsIQ5xiJP7KoVIfmR7d0vtB
	4T7i1s29BJpJdyDLLm9dMSW3bXxyqVJxF6m4rH19udhO0WP3DJ4W5ceFJtD9BHH8Ud6mNm2gYH8
	Y58yn/aw4XULaBG01G6Z1lYRaim2u8GpSq8yg8YPYdnY1rH6pOOFY4A/1yyWRXcZWU8u4PhID4t
	+woBEP2p7jwEaHdupgS05O27YnJ3h+CNGkhM7eiQBYIDwOe1z1rXORfcst0v/oR2HjAX3VBEx94
	R2kS8i1TuZTcA=
X-Received: by 2002:a05:620a:284f:b0:915:cb40:f773 with SMTP id
 af79cd13be357-92092253d13mr196478585a.46.1781824910565; Thu, 18 Jun 2026
 16:21:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260618203438.667881-1-henrique.carvalho@suse.com>
In-Reply-To: <20260618203438.667881-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 18 Jun 2026 18:21:39 -0500
X-Gm-Features: AVVi8CfonI0tY0QTM_COH8XVvtnyl1oR6XYIRDExk_5J5zNJnBowwug2D2SQ7rk
Message-ID: <CAH2r5mtxg0DZ=BGC+6Jh-+B+y8LgedZ45cqfbgkX7x912Sputg@mail.gmail.com>
Subject: Re: [PATCH 1/6] smb: client: fix double-free in SMB2_open() replay
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged this series into cifs-2.6.git for-next pending additional
review and testing.
AI reviews haven't shown any problems with it so far.

On Thu, Jun 18, 2026 at 3:34=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> A response-bearing attempt can return a replayable error and free its
> response buffer. If SMB2_open_init() fails before the next send, cleanup
> retains the previous buffer type and frees that response again.
>
> Reset response bookkeeping before each attempt to prevent the stale free.
>
> Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay =
flag set")
> Cc: stable@vger.kernel.org
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/smb2pdu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 318559cd00db..4d6a989748f9 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -3305,6 +3305,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>
>  replay_again:
>         /* reinitialize for possible replay */
> +       resp_buftype =3D CIFS_NO_BUFFER;
> +       memset(&rsp_iov, 0, sizeof(rsp_iov));
>         flags =3D 0;
>         server =3D cifs_pick_channel(ses);
>         oparms->replay =3D !!(retries);
> --
> 2.54.0
>
>


--=20
Thanks,

Steve
