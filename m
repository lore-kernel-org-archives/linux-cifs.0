Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0127838911E
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 05:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779342137; cv=none; b=kXzhdTbPJfCVyeA83mJFJLeuomRjIZ/n8lBMxnbJKRLpO/XflvyAN9ATh/D0tdnsmVfgn1dv/v70j5hOY0EwE/sq6YndQVC2BN0AYDGlZRTu+c2C+S8NDoYt8PKin2mUn7STRvMvaJk0xJu+8SGZ8S+FwOT0x5/UEmKG2ECeCKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779342137; c=relaxed/simple;
	bh=vkdZT2+b55romYcSXFLvBS2Yc0pR2C7/weYs0cQzfuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BCdjlaGeC3sOS00rJYKBN0kmVUty94OdTgTghBnoNaRpp3Y0KBpR9Thqdpbg8do3kR4WF3XK4cB120L9vg6a8K1BSw9NhhTK4nXKMug3NV8rUBeb+z+N9PQm+36n6pkmLYnmJoQ2UoWb+K+VS1B8K/FAiD3az99Hx9PTcBSnlBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWVTHOxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWVTHOxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6427E1F000E9
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 05:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779342133;
	bh=6KVZHpV9KaLIjhU6M8VfKpsBKV4VyQ4keqErwG+tTsY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PWVTHOxqrR30XCULmcutYyMXYZJykPYYtsTB3S6P7W9YaZ4NHM4oOB4pGLMDFNUdB
	 cNv52/OJa3vXSlcfsvG2B77TRTORRPGZNOsvlPr38fRZNyNNhfOjqoYP177yCJRItb
	 T5AqskG69cMrW+gPvKHatHz9UlCTR7nDCNuxkZ5KxzvetDSR2+G05Gx4iR+TEZ9O/E
	 wwscxUJG8AlU61dKJA45W2enEJisi+8ZHYr0dgWBvfjjD7EP26/2j1iznJIcrqFhFj
	 05WNd4fq6NlDNGcaYdsPCqkuylhLzoxpgjZ/3NxYa3r6Uq17AnhwlO6o/93IJ11Xpp
	 wZqxqb1uqDUcg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd11a3729e8so903503366b.0
        for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 22:42:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9/L8O4SOgGz5huZ5bXsc1/lCxxRWorBUSK8xcF1ITv+0GCrwZa5Vry8VmyMykghHeDjOuhsaKkoHmz@vger.kernel.org
X-Gm-Message-State: AOJu0YzWU0xmgwETdJYRvjEJnchZOUOrBptG52hpSX2inZrdY1J1jht8
	BYC95AzIMv4hRYblqWW4i+ldQ/LpyZHnfartU6eDPL8O67X5F12/nncXqx7ZX9CvdpZ23QKRh8d
	FvWqZz4NIrj3ypwVh9YAcle/Zu2pb/+c=
X-Received: by 2002:a17:907:c70b:b0:bdb:e19d:5253 with SMTP id
 a640c23a62f3a-bdc13e7e9b9mr66657266b.29.1779342132078; Wed, 20 May 2026
 22:42:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520180401.539215-1-grandmaster@al2klimov.de> <20260520180401.539215-2-grandmaster@al2klimov.de>
In-Reply-To: <20260520180401.539215-2-grandmaster@al2klimov.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 21 May 2026 14:41:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-GeH2o6a_rHs-CiPR5N=CZMDOP17Xc9Ry998kMqTVQsA@mail.gmail.com>
X-Gm-Features: AVHnY4L9ZSJFPEo6zNkTM5OAjxnBUnQOqta_pdsPFoxxBqqXzPwoCtBAyEQd5vM
Message-ID: <CAKYAXd-GeH2o6a_rHs-CiPR5N=CZMDOP17Xc9Ry998kMqTVQsA@mail.gmail.com>
Subject: Re: [PATCH] smb: smbdirect: divide, not multiply, milliseconds by 1000
To: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: Steve French <smfrench@gmail.com>, Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>, 
	"open list:SMBDIRECT (RDMA Stream Transport with Read/Writ...), samba-technical@lists.samba.org (moderated list:SMBDIRECT (RDMA Stream Transport with Read/Writ...), linux-kernel@vger.kernel.org (open list)" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/smbdirect/debug.c b/fs/smb/smbdirect/debug.c
> index 05ba7c8d165e..3445843445bf 100644
> --- a/fs/smb/smbdirect/debug.c
> +++ b/fs/smb/smbdirect/debug.c
> @@ -40,7 +40,7 @@ void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
>
>         seq_puts(m, "\n");
>         seq_printf(m, "Conn keep_alive_interval: %u ",
           seq_printf(m, "Conn keep_alive_interval: %u sec ",

It would be nice to explicitly show the unit so readers don't have to
guess whether it's seconds or milliseconds ?
> -                  sp->keepalive_interval_msec * 1000);
> +                  sp->keepalive_interval_msec / 1000);
>         seq_printf(m, "max_readwrite_size: %u rdma_readwrite_threshold: %u",
>                    sp->max_read_write_size,
>                    rdma_readwrite_threshold);
> --
> 2.54.0
>
>
