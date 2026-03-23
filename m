Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8051B3ACF14
	for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 13:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774272167; cv=pass; b=WpYHJ29kR2LJKo6XtM9vF6BbyyUlnz/AULz1OWRyzNPf6750OiT5lQqC3S7FKUyqhsj9SW6jSrfOE8oEa0BDqnF+n+cKmHJtTah3b5QFKyLxPzrTbRqR+AAVx2gW2QoiGS3CgS2rExxnr+60H4zchLtrlUfIyIwPDT4I0K+UkpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774272167; c=relaxed/simple;
	bh=bOPXSglp+FVbWA6bfnHHnHyxF0OzYYh7ZaZSa6FWLpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jdaBc19xmZggdnWPTGbQg3QmrxjJuwqeMprYoNa4jUdvzWAsCnini6vTv9L3prgjn8OKZGdlVKvVIwR6DKnpilG4p15NW4wkD8sYfogUxjlyaCwDAHmnNfgLPEvZNYQwOFiTxsUCvbUQbsT6KOSUNcgHjit7OFFphIBArKD8LoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMZHgpBW; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMZHgpBW"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cfbbdbaf3cso406246285a.0
        for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 06:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774272164; cv=none;
        d=google.com; s=arc-20240605;
        b=YiQRG8ZmrN8nLlHYo/KDJNHbOyHeagVA/Pb+961FrZ7c/dqFKaVlzIH0S4jMft/3P0
         3FIT6rcAXAQdn5Lj8GF8MFyizZR7jh5gNxSRAe1vaIkw/t1m6ekWtYeWgILY8C+PehXY
         Ht96/0hJFsfsrVHA0sFtABtTd7tEwkLty/yvw+9nM2SFK+vseN5tg7jvUAdUpKtxEuJW
         sWlyMQHnG0Xtc9T/q8tw6nDEqkMPcGhQqVGUMC66c6xDlN/1YTaKnLHk03PwNkK4PTOI
         0G3tQ7BfZBzSrqb6ieZX1vykxbyh5hs7IPjA4Ee7UdJEGhymNpMjOW81+wMScAa+DVCW
         2eCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lc9XaBW5fNSg/0ojkjIV5o4aYWYiXiuUUaVpKb9cXt0=;
        fh=5g7P0tXRAb100F3FFarGE71t7CdltRVyG0pXIlVkOz0=;
        b=R3kwnmta9nrF5YLdWDan1+pP8NxuaKZA8t1H06yDW1o0WLqFZfo0k1LxRAZw8ijj1O
         4sHEAUfYKDoyb9Cf/kUjSR+CAhJhg2MrVIh4JSMfEHdWrO6cLqCNQTZCqPUwp9a/FZQs
         76oJphANw0Sr6+StUOgnjSZ5/T+ELesnk2Deaqz/1SmlDweAiOhiIe0u8ZF/5/bIYAl7
         w3sL9OxYJJh2NyVNZFlIe86QjMWIcIj+18nOkYVERoLFvgETbvlPTDhsJ2K3lWZsMWKm
         xebx/jVbfkr1Gk4o7zgRoPmnb0LDMxRQ5Js4+JBECwC3sxEeo2EbVwYH3IaR4lJsHSXx
         DZCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774272164; x=1774876964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lc9XaBW5fNSg/0ojkjIV5o4aYWYiXiuUUaVpKb9cXt0=;
        b=VMZHgpBW46HJba0Sj+RPBaadS8Q5L91wG0yYytCYZgP++KDZjBH+Ug+YZ/Ir4WHanM
         MXSatytdkyw829X7f9lE3Qwza8FR8qQS1V2TAzZ+RjWxHUOU8EfW9/GgtE5bivfBoOjD
         UTnDXNYrXqqQbctqJK1vrOjIze1Mf2zrUa7ns3oeXhqA8b2cy8fkdhEeLKUBVTavavYR
         juwXanGTWKlvNwGGZ3U89kFnCH8z2QVb0o8tlx2ZbdZe8nyBOGvbJVSZHgAswqT/MMbF
         64H317iMOR884GwXC41dPHKzzlmsvDCHYRVMNpeNS32GohXP+nBhio6pAaved3TnOY2C
         WUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774272164; x=1774876964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lc9XaBW5fNSg/0ojkjIV5o4aYWYiXiuUUaVpKb9cXt0=;
        b=Asy5I8SmgdDbMSElyrMYCg0s/DQwsO41LjFlI0Ihftuc8lYsIzys1ZebFabga+TIJU
         dua1sb18vEFdpk1YaAfsJV2afwEx5Dc/JmK+rw+wv2ZiX1VLFTqHCE8VO75tNdBoWDcQ
         nBQyat2Jej84IxPpC2bvRdB56tJ6/3UKNxpurpm/z5HvjPUceC0hFSSu1OWrUcvjjXMi
         o6udGLtJNhN4Hy4l3/LX7QyasmZbkp6mMhKtnCD7kjjp5y/3DLFettWduwv5/26+dpzl
         ZRFP18Z46Bs8XQSurX7BijG5JJ16GQ523zUA0GjH4qblEXdqq+CuoTZNraE6KN39JJHq
         ufwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaBcy0VjUWNXc03Hs3viAgqbmTayzIzy+nJb7YgVGt8giDmEaZDQkYB+PA3QI7vGekf5C4RxLNOpiS@vger.kernel.org
X-Gm-Message-State: AOJu0YxJsGC/QnDqhyXIbHtPcor4t2iebH612Cw0d//m3LbY7/YObuAi
	vmIbhn7pPHUb4dX5ysWfS3Oa2DJUUhlTFb1nh8pbtICb3VBC6lvXkLpX8jIyjxi7VB4GUz5a+G6
	mI/LSvMcHCciMTNeor3x9Pu52zY7FXBXd2Q==
X-Gm-Gg: ATEYQzwfz16tw20NfYz/QHWk5anYqhnQFQDbVUMLY2Kn89ka/3EcjileryxQXO51fNB
	BTiwPUQYW+K4iJZd4x4lUdVH528LCRvcv+fc6xhRxXAgJ59PpcNcYAFyKu5o+M53taiIHZRusCX
	K7VC6gxncJMaiRYHtOXWfaVIUY/NErprcB0acDNvLPECag+TDuMQEy8nvzt6OHEUgl2Dekcd+GF
	0c4rhQnjD+vW1IUKiadejdYxOzAc3YR+zZ2p341mbJ/cWRhw8h1Yf3wQK+SxqwLt0ezATMmaI3s
	dcmvCQUA0itqXurEwxhhj3jj1+umuJd/bBSbD70BckBdonFuZaOLc4wtunM6FNVe8XPu9SA8VjM
	yvNfbkN9MXZdikTQiAzWyUqgM2REJzbmWkWKZUwXL69Cd0Nvzl+bqvP9RRFEflu/5D0/m2NcsqC
	faBwDuR94UOmN6Q8nH9d1jHMBw+nAY9dMz
X-Received: by 2002:a05:620a:4111:b0:8cf:d0bd:bc93 with SMTP id
 af79cd13be357-8cfd0bdc03bmr1284074985a.13.1774272164310; Mon, 23 Mar 2026
 06:22:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323090812.918663-1-hehuiwen@kylinos.cn>
In-Reply-To: <20260323090812.918663-1-hehuiwen@kylinos.cn>
From: Steve French <smfrench@gmail.com>
Date: Mon, 23 Mar 2026 08:22:32 -0500
X-Gm-Features: AQROBzCk7OPPoENyOrdf-rmQBbxY1o489MEwg1ZDDPgj9yl4qy5CO5-3paU-DJE
Message-ID: <CAH2r5mvem72ZXj-G-z3S9L6qQgU54026iNz7xcdZKRQbGZMx=w@mail.gmail.com>
Subject: Re: [PATCH] smb/client: ensure smb2_mapping_table rebuild on cmd changes
To: Huiwen He <hehuiwen@kylinos.cn>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Mar 23, 2026 at 4:08=E2=80=AFAM Huiwen He <hehuiwen@kylinos.cn> wro=
te:
>
> The current rule for smb2_mapping_table.c uses `$(call cmd,...)`, which
> fails to track command line modifications in the Makefile (e.g., modifyin=
g
> the command to `perl -d` or `perl -w` for debug will not trigger a rebuil=
d)
> and does not generate the required .cmd file for Kbuild.
>
> Fix this by transitioning to the standard `$(call if_changed,...)` macro.
> This includes adding the `FORCE` prerequisite and appending the output
> file to the `targets` variable so Kbuild can track it properly.
>
> As a result, Kbuild now automatically handles the cleaning of the
> generated file, allowing us to safely drop the redundant `clean-files`
> assignment.
>
> Fixes: c527e13a7a66 ("cifs: Autogenerate SMB2 error mapping table")
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/Makefile | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
> index 26b6105f04d1..1a6e1e1c9764 100644
> --- a/fs/smb/client/Makefile
> +++ b/fs/smb/client/Makefile
> @@ -48,8 +48,8 @@ cifs-$(CONFIG_CIFS_COMPRESSION) +=3D compress.o compres=
s/lz77.o
>  # Build the SMB2 error mapping table from smb2status.h
>  #
>  $(obj)/smb2_mapping_table.c: $(src)/../common/smb2status.h \
> -                           $(src)/gen_smb2_mapping
> -       $(call cmd,gen_smb2_mapping)
> +                            $(src)/gen_smb2_mapping FORCE
> +       $(call if_changed,gen_smb2_mapping)
>
>  $(obj)/smb2maperror.o: $(obj)/smb2_mapping_table.c
>
> @@ -58,4 +58,5 @@ quiet_cmd_gen_smb2_mapping =3D GEN     $@
>
>  obj-$(CONFIG_SMB_KUNIT_TESTS) +=3D smb2maperror_test.o
>
> -clean-files    +=3D smb2_mapping_table.c
> +# Let Kbuild handle tracking and cleaning
> +targets +=3D smb2_mapping_table.c
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
