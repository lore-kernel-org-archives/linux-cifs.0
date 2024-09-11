Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3F23D3B8;
	Wed, 11 Sep 2024 21:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726090014; cv=none; b=pGfN5+p596PNyrL+vQcICwC4EvKFtbtE2XFY4LsWvMkqoK0qM9IN98wqkLLDfsHX6QwgK88zsrcm2N4kI5bTZaBvxN712pv25hoJybIjHLRqN9bdwdjoECm1N1EUEKnrdaYUpixkJiJH6Bi2pKzAUqxgJSD3PmVUpuNO9MaKUo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726090014; c=relaxed/simple;
	bh=qxmwKIKZZVH0IEXWiQwUCTvUGTIMoGFuw3rr4W/Y/I0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qa0ScIVyU+qmxR9SKwdKcHIVUKfTQ6avlFdR744Xya496yJAKqxYj8I7hVxgxb5mta4xD6/TcUp2Cfi+Zhpd0FPy5zZyqQMgG4qF3tKAFAJgqC2wWXpbbLlzdbm8/ebkWUoi4qSPbKhTJmknIAH/mSvFTepUJkwF1qBCpuTSBuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4yGDUrO; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4yGDUrO"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-535694d67eeso253803e87.0;
        Wed, 11 Sep 2024 14:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726090011; x=1726694811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqtRh/pJ/kG5Ee3Qg3j3oLtps4VUqaM2CM4az1A8dtU=;
        b=R4yGDUrORiuusEmgJ892Gtc1j2MrvfpX6WP9FUB7PJQtlDrcYgWgqAvEdBa0RvGeOD
         HrESLNFEnRbLwzS8zZgUGDyzlFzs6tPR9/AbLpBCpD2ksHtHv0GwPVy0+J8+kA/Gi+/8
         MFsv1C9j7Xw0HZze/f2w30T3svAAWTVTcTRP79bLmTqWw/koJqZohLizPmSxzZakoJCV
         03ahKm+xxVrYhG2y05nwz1oUoZb5lFPhKY3C65dv+lzsHaf460oHFs79ZLGYWzcdBBSf
         9lc8rm4hvRuT/PCU4PDk6ZDP4/EgrMeJGFVhKhB8AHG6HwVgSy8KAKPNTf+QhaNDip0v
         e2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726090011; x=1726694811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqtRh/pJ/kG5Ee3Qg3j3oLtps4VUqaM2CM4az1A8dtU=;
        b=SWXLTIaTM1bfbywkg9fDfw4IJyNgn64hQlq7LoQW89GmNRHuTS6Z084uso8ekNkFKR
         2llWtpqeRh3hqICZPibTdXeovSUywtjgRlG+dvpaCKsJmkfYH6YkBvw/UtxgJAKc/bIS
         Hmn/NuUyfjscLhjbw7FKOnfLX0CpEglTnjZrsVddfNJQnvjb+X31M6qT+dHowhUQ1rPX
         puVuC2DilfATpuPpBZH9GZUo3cVAG475NsdkyLMDGnjZfzNFm8ZdLiBFGs3v6fWVg950
         Z1lGtI3AMc4wlQuUF2x6oAg10iteHFlr9pePFzGP4jrtN4G6HuNFNwR9YuK1dZt9ZzKK
         EFQA==
X-Forwarded-Encrypted: i=1; AJvYcCWZN11RdrWLYJDk4wVtKOJpR6CAv1WFc3LMqwOX457Is7S8n3jkhn9s9GgUmF8dOwjw/7FyFMuk7fvg5eg5@vger.kernel.org, AJvYcCXzg98YYY7Qz4GLWUIF2dbzeKGT8IgQE5m5krikrdP0sm7D2iK+i5RbwBwJD4xF27IyjsieH9FbouFN@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb726cf4/Pte35Tjl2WCMOn7k0c55iqnH1DxvCMHt8osiDx7dL
	J9oHox9olWnV9hU3dXfjwIUJqGZW6sdoML/m0GqB4eJG1ZJEhkwzbw0SpZuQVxwbwapUjNmVY07
	hyhS+euHlsm4ou1SCwxQTo5XCgGQOiuGYjBM=
X-Google-Smtp-Source: AGHT+IFC8+ySnmybQlygTyoRyhYMxq7uAqdH0Tu9Gl/JShGnHyNqwXrbsLhR7L3k9aYMEkxezsOAaYTLJ7OjHjnL66A=
X-Received: by 2002:a05:6512:12cb:b0:52f:27e:a82e with SMTP id
 2adb3069b0e04-5367909dca5mr192274e87.21.1726090010686; Wed, 11 Sep 2024
 14:26:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240910151418.1233049-2-u.kleine-koenig@baylibre.com>
In-Reply-To: <20240910151418.1233049-2-u.kleine-koenig@baylibre.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Sep 2024 16:26:39 -0500
Message-ID: <CAH2r5mu_PT+34JqL7O6yqfDua=6NNU+AP4+n56FJSc1X5Rpp3Q@mail.gmail.com>
Subject: Re: [PATCH] smb3: Fix complilation for gcc9
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: Steve French <sfrench@samba.org>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

this looks like it doesn't apply anymore due to changes in "smb:
client: compress: LZ77 code improvements cleanup"

Let me know if you see any problems building the current for-next

13b68d44990d (HEAD -> for-next, origin/for-next) smb: client:
compress: LZ77 code improvements cleanup
1dcb0b607b9b smb: client: insert compression check/call on write requests
ee71379301eb smb3: mark compression as CONFIG_EXPERIMENTAL and fix
missing compression operation

Enzo,
Is it easier for you to update patch 1 and 3, to make it smaller so
you don't have to add code in patch 1 that you remove in patch 3?
Also let me know if other patches to try?

On Tue, Sep 10, 2024 at 10:14=E2=80=AFAM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@baylibre.com> wrote:
>
> Compiling an x86_64 allmodconfig on Ubuntu 20.04.6 using gcc Ubuntu
> 9.4.0-1ubuntu1~20.04.2) 9.4.0 fails as follows:
>
>         $ make fs/smb/client/compress/lz77.o
>         ...
>           CC [M]  fs/smb/client/compress/lz77.o
>         In file included from fs/smb/client/compress/lz77.c:10:
>         fs/smb/client/compress/lz77.h: In function =E2=80=98__count_commo=
n_bytes=E2=80=99:
>         fs/smb/client/compress/lz77.h:220:1: error: no return statement i=
n function returning non-void [-Werror=3Dreturn-type]
>           220 | }
>               | ^
>         cc1: all warnings being treated as errors
>         make[5]: *** [scripts/Makefile.build:244: fs/smb/client/compress/=
lz77.o] Error 1
>         make[4]: *** [scripts/Makefile.build:485: fs/smb/client] Error 2
>         make[3]: *** [scripts/Makefile.build:485: fs/smb] Error 2
>         make[2]: *** [scripts/Makefile.build:485: fs] Error 2
>         make[1]: *** [Makefile:1926: .] Error 2
>         make: *** [Makefile:224: __sub-make] Error 2
>
> That compiler seems to know about __has_builtin but not to have
> __builtin_ctzll. In that case fall back to the implementation that is
> also active in the #ifndef __has_builtin case.
>
> Fixes: 0fa8d04ff36d ("smb3: mark compression as CONFIG_EXPERIMENTAL and f=
ix missing compression operation")
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
> ---
> Hello,
>
> feel free to squash this into the original commit.
>
> Best regards
> Uwe
>
>  fs/smb/client/compress/lz77.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/compress/lz77.h b/fs/smb/client/compress/lz77.=
h
> index 3d0d3eaa8ffb..4fb939296f39 100644
> --- a/fs/smb/client/compress/lz77.h
> +++ b/fs/smb/client/compress/lz77.h
> @@ -200,10 +200,8 @@ static __always_inline long lz77_copy(u8 *dst, const=
 u8 *src, size_t count)
>
>  static __always_inline unsigned int __count_common_bytes(const unsigned =
long diff)
>  {
> -#ifdef __has_builtin
> -#  if __has_builtin(__builtin_ctzll)
> +#if defined(__has_builtin) && __has_builtin(__builtin_ctzll)
>         return (unsigned int)__builtin_ctzll(diff) >> 3;
> -#  endif
>  #else
>         /* count trailing zeroes */
>         unsigned long bits =3D 0, i, z =3D 0;
>
> base-commit: 6708132e80a2ced620bde9b9c36e426183544a23
> --
> 2.45.2
>
>


--=20
Thanks,

Steve
