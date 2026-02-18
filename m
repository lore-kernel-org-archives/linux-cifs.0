Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CA52F1FEF
	for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450955; cv=pass; b=OIobdRyyzwbPeXSnho+2GbsgZfnXTDrlayPtjkpqavpPHGG5afRmBXs8WbCjgUAM4WLnf4uz7wZ77N1W3eAyteVOXFB0pAZ5Mz6H2Ct+kdE0j3zXwxr/NzYMyMG8f0GFzBKhfGxboXu0h+AFo0TOYxo3oKidFtmdZjPnbpyKDBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450955; c=relaxed/simple;
	bh=Kut9itH4KGS+1jezuu1kMPaauhlTNVrL1GqgQMwPuCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G55Sl/0VgJN9GsFg4gEo1UzBf/gReKAJEHUmvYTqKCwUX9daAUxRJW6ZK4AjzKBH0AYrBTTvnxlZwRjaQB1jEgiRSXdoa2KoO87buxWyxctIDapFHrzOJ7MTrgbpjn6+ko6/MOvG2Bzty0ziq1PhmIhFt+WV/VqjnfcNdq+DpUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWq3uxCe; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWq3uxCe"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8966bd9da41so2541096d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 13:42:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771450953; cv=none;
        d=google.com; s=arc-20240605;
        b=GZRUVi1xRc0VRQgVV2sTsZ8FFwN7P92UiSpvG8V6VidFQ3QuTjKKNUiqDOa3IpCev8
         93aez41Pi08TKOB+zc4glYxHHqz9kxNnscK4PVHCKVgaH+IM5ULAuiq1bsBGk+EV7gWO
         8872iVt1ghCI6aI2CeC17KHZaBZgs8Af39NMpocpoGbOi3FoBv8dcKmdC+n02UJcmNNL
         BYPShCgLtbwuMipEpc330m4ighq2KcW89Rb3qJzEfEYHXMpRoG/xCFRqAmkI9TGoOTru
         T/q9wSYRO+Ul3MC4iCVZocjYC9Bon7HCLohAX3BM2e/wO5GbNWdCvY+0m8Ku1pmQ+JGs
         pNBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fdl0A8UixsIff/MQ5v+B5jVRqHb5yulzDbRj1E6u3Cs=;
        fh=U2jrFi75SWXcjQs3OvxRr8ZdSEy63F0iyrD+QkXkhKw=;
        b=JQdiO60OlYe28j21Atp1BQ1Tj7IBdS1IZTKv5Awgyi+joIBgt+3VLx1RGzfVRRAqlS
         9edGMsuy903GMwjCdruw8juu2EMuXXBaNna59SNIXsamBdr67D8DOGmwhOR/j2rYOpIE
         KbPcaTb5FmQ6PABznxj+xpHcFOT8veUgCYRRmCsukIZaOtGtAN0+Crqsq2JEYFR8z/2o
         V3CMnd8rxt+27JgQGEihmCrXBbPXbGd/1d/J02vKREzvT7NwW9x7Mi+zuw3E1ZXAb5JT
         OHAZQ8fmz+7NBV9z6w4xmMuQuVpI1xPdThYWqIBFSoM1AHVYp0CFl/QEMJYwNdF0rRtC
         /kkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771450953; x=1772055753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdl0A8UixsIff/MQ5v+B5jVRqHb5yulzDbRj1E6u3Cs=;
        b=cWq3uxCeBP9EK2ynO2MhTibZAvHgXAbDCJ8BbKl2BiPdoTj6B+pUSGxpaqwltdSmx+
         Al97xgil93Qi2LGQDWzEvIYCtZ7QpARlbap4ofdKmPaL9FcdUehcLcHCoNGFTKIjcLne
         3x3F3I3j6yo8e2d6HASYqKHfJYSXnoQhpFOpH585+Ijz3Tqn11Lf4ObZhqcwusBHpfDq
         gMluBg9wh7NB00sn184MYLNH8hn69tETFM45HEgr6/dv3oPCbZAEyf68lPF6OsKtDJn4
         o4L/2/8cM9aBXYjvbyoz2OjVFK1LhS9GKShH1uW74B6iH71BXuLmYJkLChdDxcXmIdKc
         2juA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771450953; x=1772055753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fdl0A8UixsIff/MQ5v+B5jVRqHb5yulzDbRj1E6u3Cs=;
        b=ptN1d7Jsr+OqMj37TDcLza9YOo7/0yhZa47bhNZgPX+XutJB2KUQIDswxZMswVHoXE
         5HXrKcYLufqdwjf/ritqMVtiTAw4CtrOEMEJ3W1WLzjNqJ7LC4sfhy2Q4WcJ4fEpl/V9
         qtwKa7nf7UTagOeZ8urfOTynubcb54iHw5YZIifKaziO8Bee6RXeVbtg890llTKuBeex
         3RvgePXcGUt/bu8vyIN8xsRT4Ci+Q2WYfK0wghRChiuIWNP9/VeASbpOBsFqWpdxx9Pp
         pcPKGww3iNJ2xu03YLP/aBweTHEeQqy1d9Uy8LSCvozOgvqR60B0B/pl7alUJPwf/Rkm
         +6bA==
X-Forwarded-Encrypted: i=1; AJvYcCUMgvxaZfMiYYiteAn/zTSXo3vkCOeYOgmC8/U2nDq5rDyEOtOtnwyvRp9plaJs/84vjAJFi3gVw3gb@vger.kernel.org
X-Gm-Message-State: AOJu0Yw59/KS8CH3uzGXe8Udc7iEIlj+8YAmIbHarXxXDFxTkn6r8hSn
	DxjZGHkyeYtppEnyAJ8L9cS46O/a1aeTLmy5IQdrgfwrNTIQ9I8JqTcvb20k6gfEh1Y4gRXlAb1
	rNgKbPC4L39xJqVZ5uaULRLtwFaLp2hJtug==
X-Gm-Gg: AZuq6aIZUgioHUMMcit+Nzi+kzUcUKAoLINDp7dDfjKpoIU9fNw37iE0iUnQl4A2Yys
	ts9SnoGm7oaXImgZhdvjLiDec+IBynQUkDJUvM/kKfp3aUsYnu6k+7u8vRVn1ze3/2iwQxTN/iB
	GVGJKK+PxzWsdRKssrpgGcEfn0Md9rCWoKous/GSmHG/5hRZXtKv5ofYPjv2sukkv+vzIzPYKu9
	wM4SLXt5xwCxSqtdF+Vs4RljHfFFD3fhlg+bElon56YSHTdT2yJ4cMc99wmJlN8pxYj0YEuf82c
	axFI3dU09ztIjKAqOooOS9JJHejKjghlXc4ZKPa/cJLo4f/W0/cgia/6HShtpKK4q4T0C1LggTG
	lA1xiyo2coB7QzyU6ztRiwTMR5KzzCz0YPytkNeF/7cywwcSkXP8ty+2rsade1VzHJt1/dpAgGP
	nH0wrpMv11885KukGQ2X2M+w==
X-Received: by 2002:a05:6214:202b:b0:897:306d:98b9 with SMTP id
 6a1803df08f44-897402d74ddmr259168586d6.11.1771450953049; Wed, 18 Feb 2026
 13:42:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218213501.136844-1-ebiggers@kernel.org> <20260218213501.136844-12-ebiggers@kernel.org>
In-Reply-To: <20260218213501.136844-12-ebiggers@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Feb 2026 15:42:22 -0600
X-Gm-Features: AaiRm51OR0UA1EoYTzTIBq9EZMqc4hCYgiV_-Pm5bfpkALLXMax-4eNCD0kf6YQ
Message-ID: <CAH2r5msdQw2KLyMJMoSrzFoGoJfmuCsBj_qeT34sH5b+6DLWFQ@mail.gmail.com>
Subject: Re: [PATCH 11/15] smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Acked-by: Steve French <stfrench@microsoft.com>

On Wed, Feb 18, 2026 at 3:38=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Since the crypto library API is now being used instead of crypto_shash,
> all structs for MAC computation are now just fixed-size structs
> allocated on the stack; no dynamic allocations are ever required.
> Besides being much more efficient, this also means that the
> 'allocate_crypto' argument to smb2_calc_signature() and
> smb3_calc_signature() is no longer used.  Remove this unused argument.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/smb/client/smb2transport.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 0176185a1efc..41009039b4cb 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -202,12 +202,11 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, =
__u64 ses_id, __u32  tid)
>
>         return tcon;
>  }
>
>  static int
> -smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r,
> -                   bool allocate_crypto)
> +smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r)
>  {
>         int rc;
>         unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
>         struct kvec *iov =3D rqst->rq_iov;
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)iov[0].iov_base;
> @@ -438,12 +437,11 @@ generate_smb311signingkey(struct cifs_ses *ses,
>
>         return generate_smb3signingkey(ses, server, &triplet);
>  }
>
>  static int
> -smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r,
> -                   bool allocate_crypto)
> +smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r)
>  {
>         int rc;
>         unsigned char smb3_signature[SMB2_CMACAES_SIZE];
>         struct kvec *iov =3D rqst->rq_iov;
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)iov[0].iov_base;
> @@ -451,11 +449,11 @@ smb3_calc_signature(struct smb_rqst *rqst, struct T=
CP_Server_Info *server,
>         struct aes_cmac_ctx cmac_ctx;
>         struct smb_rqst drqst;
>         u8 key[SMB3_SIGN_KEY_SIZE];
>
>         if (server->vals->protocol_id <=3D SMB21_PROT_ID)
> -               return smb2_calc_signature(rqst, server, allocate_crypto)=
;
> +               return smb2_calc_signature(rqst, server);
>
>         rc =3D smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, ke=
y);
>         if (unlikely(rc)) {
>                 cifs_server_dbg(FYI, "%s: Could not get signing key\n", _=
_func__);
>                 return rc;
> @@ -522,11 +520,11 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Se=
rver_Info *server)
>         if (!is_binding && !server->session_estab) {
>                 strscpy(shdr->Signature, "BSRSPYL");
>                 return 0;
>         }
>
> -       return smb3_calc_signature(rqst, server, false);
> +       return smb3_calc_signature(rqst, server);
>  }
>
>  int
>  smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *ser=
ver)
>  {
> @@ -558,11 +556,11 @@ smb2_verify_signature(struct smb_rqst *rqst, struct=
 TCP_Server_Info *server)
>          */
>         memcpy(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE)=
;
>
>         memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
>
> -       rc =3D smb3_calc_signature(rqst, server, true);
> +       rc =3D smb3_calc_signature(rqst, server);
>
>         if (rc)
>                 return rc;
>
>         if (crypto_memneq(server_response_sig, shdr->Signature,
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
