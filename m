Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E1B3033C5
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770322407; cv=pass; b=a6gKheBezdT2YL7wij4K704R+3crh6hhELtKuOXUa8lRkJ1X7Q9rL7/SiEzMpiYDceepQ5n5fB6TdCwqbL9OOjDU21Wt90c87bXbtHnjobYIdKU/JsV5JV6ewI6uJDdRrDzSCd0mIsJIKIy39QVYLXBvBlrbAb+v3tw9yzCEKv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770322407; c=relaxed/simple;
	bh=9BnTuDqOkfVwbQjOpEppIuMgBuPS1ZnthXCFc0SespQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=idySBIxtoEFSAz67mgfIaqqCHFTkqSou5CVPCseWpR5aQBK9tDSX4/rDCFYJdaYxe346236UOMPauHyp/35ZYRkhp56GqR/Q75pimkLTtXHuggXOGgHB40d5lGdWRrlIy4Nt9SKsf+1m3EkogvCENjzyrMj7r6uToEN7lK5M/S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGvpp2fS; arc=pass smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGvpp2fS"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8c9eedc2363so135021785a.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 12:13:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770322406; cv=none;
        d=google.com; s=arc-20240605;
        b=P1QswxlEh3WHavri1GEAyFiVX2UlyzVxiZi6HS70m4+Z5qKj6nNlyscN0bGupt7YiX
         5jwjIYRNKwHj+IiNjLmufZbIrJdGKwyabK7I/GKDdMg0NHWO6wUoPRAVVZv+ovDKbV2/
         aNy7U6ZJbEqamj6R/yASAbTehC0y9cNcCfEcacXDwxVaH6Dw4PqNP3GclpWftp71yz8e
         K0iOjFU+y+Xzwztj4hCftXsEz/THOxpOUhl8mtBoJ9tr5nS+6eD+SnOeJ2MDOH/zOONT
         mNQ9ghaDMf6ZlTQy5FEji2f0AcNY0EPdhC/C8sQhVAfoYMl5hcthFuZIH1F7be5LpDB5
         Nsjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wd/z3YQatTiriQ/b43PjTkl3jgJMdFGc5C0TT2eEAW0=;
        fh=0NEkzjKJYy2Ykv8Xo9Y9btRRf0ekAX8eDCO6YriC6ig=;
        b=YV13/NTxmbdQs5oFLiWvgTBX6UYSoOMcMhQFi9G943h3+X+rVOqC20POzsg481lt0B
         4knwK5zP8+eOEEFoSjDm9B4miUsC/SpuH3T9Utjvak/1QHp0JNNUnV2HKVVWpaenRM42
         p8rgd2eOihws/nGOHwI21UwWFdrWobbrTqRgw3Ao6WZi4GFiREuyxxs1Z42cAR5aZewq
         91JvZAhOMMNtl+Uvqhz8r30KuqYuXALM13lJcyJcE7zav2zJFtIAHUgXVcL9HobYLj7a
         Wd0kRSxg/7QiyfDLEW1KrfvPe/XkwWuB7Sp/HdVsV7Gu4Um9VCaGj7vqoJWvIa1rh2R0
         yoeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770322406; x=1770927206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wd/z3YQatTiriQ/b43PjTkl3jgJMdFGc5C0TT2eEAW0=;
        b=iGvpp2fSWsc7TjLLpvUtG7FW3pr3Y/8UMvlO3vQwO+xV/ZuBCxfDvWL4V0DohkYsPf
         A4UB8+c5PDXYhDy7LJyB8TDuzFLzO2MFeFoTrIy8I5/wToV9gRzMK2Z2j1Fb7hr8+WnI
         bK31v+Go96/n+DjWSqLbZEoIcibS8eZ2wROmCiUtU7A0F5wAuPkxw34nI8IoB7hP8hWG
         n1s8yvKSYPdj3R6X/duL8P2BpT/MGQcv5TV8QjpMb+kgKtzh62Lwhcmz19Gkc05RKXFM
         Hr34JNECF5LccvMRtRN0QCMRMtj3+cMaCaqdS0WpvxAtulUUyDpW5Yho7xIKrU5NWJC3
         hZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770322406; x=1770927206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wd/z3YQatTiriQ/b43PjTkl3jgJMdFGc5C0TT2eEAW0=;
        b=f0gNjdzsIkc0iRuTtyuKAxDNYBBiSDV9Q+BN2962gFt/MGUeswYav0Ip+FBgNl8H6Y
         FWEZoq2erSYNjGM1Ey2cr0ZoYbSNdLdgeTSh/brQWAJuX4lg327t5oN2aNkB4QY8j6oE
         UsulE/zC4FXvj0g7VzqVk/hYJIx4GmgxR3G+eTCA2c1wB5HW2gLxN2VGVfGkcs2/Dle0
         dTW7z/JJQHm8v08EKjJPcw7QE7178ZrfRpxwkxigJdENKlzV0l4hZcgIOcHb1CdtJFIS
         8YZyO5Gd2NzPFl8zQJ/J4e8G+mg4r6a7cXmMbnvZFJ1K+L1cGuXsPaALaYPLNqk3Pz0W
         pywA==
X-Forwarded-Encrypted: i=1; AJvYcCVzTjqxlW3Hv35Rfap0mEXBp7y+dmC2Vb2Dz9MiG3n5a5OMduP1+qAj3GjAX67UJO5/AVxWwSUvPjKb@vger.kernel.org
X-Gm-Message-State: AOJu0YxyqEz726VbJy/LHveDM9JzJC3WKW5FmmQlb7gN6Pmu4Tgf1PGV
	MPUNka14E14IRqtY+aijUmj7g1FgV/kLNvpbr9H1eGk2zsNr0wfjBzk6V7zZDkeQsrz6UWByeQO
	i9aZksvRAgX3WdUexjP2cyj1Z2Q42VKU=
X-Gm-Gg: AZuq6aJrfb1cD3UKd3y0HF6xVP1GM8Gma3uNnfcj6O/8xESLwXCN2dSpgX3HEfruNYL
	TBcLe131vlF6lwzU+RhlmZNfpaj7Rf06hNUDnVyKJqqqDo9nKTLNwyfhsJZpdipEgaf6zc/7gab
	6aL24c7/Rl2rAs+iJVQfSC7FKrUqzCx+97a4nbIwOURyAoD215RVGraUAuAe20e0NFHnGuhVGmG
	RYvHJ+nYJ+IvJK17sp+Yj6rbyxUQ1YbX7EMxAUQ78ag3g0odv75T/LGCh/bhGVlI2bybg6gLOaF
	z0BHHIikaWxKkomi8cRU9AQdLwZGn9K4LN11KNpXA4TfhgNrne+27bBXUW1RA6mvPRfao37YyJ+
	beW//fl7M399lLNr8AqcJuWCPHbgpRxv5AMM2//rRxHtph/sOBWSm3QOZkyrChJH7xAW67QTnl3
	heNXYWVluB
X-Received: by 2002:a05:620a:2906:b0:8c7:1952:7895 with SMTP id
 af79cd13be357-8caefebca20mr43499685a.31.1770322405938; Thu, 05 Feb 2026
 12:13:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205161952.245146-1-pc@manguebit.org>
In-Reply-To: <20260205161952.245146-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 5 Feb 2026 14:13:14 -0600
X-Gm-Features: AZwV_QiYaU-KBt9a-jTRlFWNyQQLI1_V678atjWPIxoO_ihRmQVf6d8ua7pKeRE
Message-ID: <CAH2r5ms1Zph9faLedoCYHCXZWUZKZyTFxVnghoRuJBdD0R3Ymw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix potential UAF and double free it smb2_open_file()
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

corrected typo and added Chen's Reviewed-by and merged into
cifs-2.6.git for-next

On Thu, Feb 5, 2026 at 10:19=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Zero out @err_iov and @err_buftype before retrying SMB2_open() to
> prevent an UAF bug if @data !=3D NULL, otherwise a double free.
>
> Fixes: e3a43633023e ("smb/client: fix memory leak in smb2_open_file()")
> Reported-by: David Howells <dhowells@redhat.com>
> Closes: https://lore.kernel.org/r/2892312.1770306653@warthog.procyon.org.=
uk
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/smb2file.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index 2dd08388ea87..1f7f284a7844 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -179,6 +179,8 @@ int smb2_open_file(const unsigned int xid, struct cif=
s_open_parms *oparms,
>                        &err_buftype);
>         if (rc =3D=3D -EACCES && retry_without_read_attributes) {
>                 free_rsp_buf(err_buftype, err_iov.iov_base);
> +               memset(&err_iov, 0, sizeof(err_iov));
> +               err_buftype =3D CIFS_NO_BUFFER;
>                 oparms->desired_access &=3D ~FILE_READ_ATTRIBUTES;
>                 rc =3D SMB2_open(xid, oparms, smb2_path, &smb2_oplock, sm=
b2_data, NULL, &err_iov,
>                                &err_buftype);
> --
> 2.52.0
>


--=20
Thanks,

Steve
