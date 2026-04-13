Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06F23DCD80
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 14:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776090099; cv=pass; b=HalojzbFehNYWdE5/9vB5LQxQhnut5/X9CocMQun0Hk7dLmhAb243w8aglmIwrmuj71DZWzEMc3DF4LQfwBvHZza8jBgexKO7xKsNvWKcIskPz0ljUjQeohGvR10E5FPo9soNzL1bsf+J20pAg2Yb4vXKq3cdKbvWULGWyS5qp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776090099; c=relaxed/simple;
	bh=9+obQ07IWrt6YEnhJzoZSzYqcgggQq2eCC+qsYSSKm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZSKLEA1JUpV2AWlb70WyEzcQd+7nQJRVFS7pOKm2e1osmg5tYZ3RiGDPmZ4TUA8Lqwo95gzHG/KYmMHOSA3YJSNNIthz1jKxKSeTXAVFrmuAyqgrPrwhPdl3Cb7NZZImZcaGP+F9w1feq4hh8mcM/STEaChGrQ5qsw9NAMtAgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=maap0CyQ; arc=pass smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maap0CyQ"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-6108228a851so151453137.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 07:21:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776090094; cv=none;
        d=google.com; s=arc-20240605;
        b=NzxOvQTtzE19Km1e2sAc+dw/UVZ30jxricI6bCUJwhdWy3ge27Ab2ILRvknd0iaM50
         bj0Frt8GOmW+dChz3VIC3HIZu29q51g/ImJO9DVcU1W+kI+n47T2zOomviR0mXCRpHdv
         JceC7A17Or+JGB8QlJ2pplpddItv+VOlhw1dZB5GHv638UAmibY7soyp/VAidYF+gH5/
         Hi/NrWZg3ZGy0FMcBBNf4WivN73WPqBKKh4S9r6dNS/0py3BMXbLohlbWssm0KaulMnD
         Z5Snce+cnnJpCdYs0fZOUIS8qm1iNrwvbl2tv1LcEk3S/dzEniffCwZMLIljcRrh4omV
         z+Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V+6ojMwl5ZV5B9wCLGxJ+se1g/V5jX+jmgkoLrUyjS8=;
        fh=mmXixiziDYOQKxXq4puq568MTVyHPOHvSsKkLMlUOBA=;
        b=aAlsSIXp1pQfTx4ivh3Xou+lxkQaldV3vKF/GpgfT7L+nhOzK1GX2EHipNsuH1o27L
         g+gV3XhneBOITC70jXMnucHo7WBzUkezpDjjSw37AqWflC5UrrFak+Y5rpp/1bdaRUiA
         9QD5RYs+9kVxNHus8ndNoT6akKKTH5g/3prwdVpUF7J0Mg2gHsIvvEDgjGH0pORo3EnM
         hQy729xuNUsghwSfBE9sVE5hlSgZJgTgmcA4KP2i+hI4Rxf/GqM1MZ46ixfpUmKnLXu2
         LVNZUh7X1pz0lYBSknEKrd4MGeQzFksxMbjCv9XxO1O/o0+ipZMd3ppsnB3+cYoi90nY
         nb1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776090094; x=1776694894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+6ojMwl5ZV5B9wCLGxJ+se1g/V5jX+jmgkoLrUyjS8=;
        b=maap0CyQctsCQVfT+9Jj6uPY0ajeN72TXRmVLc6OOirFQFdd0ixoa1d0HLsiyX/M2R
         NhdRHfWDQz7rKWThn7JFH9uAJP1yv1dLG+H+jmBkKZLmuXHdEw65z1Ic/+9PGFEQaLkd
         IuJOHWH/lBJ2f/LQQ6fq2vKCfh4+oUQmAaXSyvc7qZlkdg4cexpe80v0zCyYS7IK4FOh
         GiYar+wXgMfKBGP+j1LxCHfTwQcL5Kx3GagNFFs0y6WXxw3PcFoO9QaOJKlNVVf9Sxnf
         4GqS1Wq0SyLBqanMpN9PtEnuMaoe/dRXFecNd6HuvIvdDpW4yqWLrk1rG1c27EZDmeSX
         c3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776090094; x=1776694894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V+6ojMwl5ZV5B9wCLGxJ+se1g/V5jX+jmgkoLrUyjS8=;
        b=Rq5uN5ErRwrVte9QQVglI6cbvvwG98fod4wtsWMq5xSk3bz0HMiErHVeIsE+GBTQXo
         SDNMmtDi0y3BuZqvyKbAdHSVqPjd4ZnMSFasTkl2VBStbvHgJjNjgPxlUOeLzMSnFRzB
         kbcO4Z1jQPsiFGbkrwnabvF4mc5YFOnZq5xnmjHMF05vDpgT8jfyLVNsbpihLu0AIBtu
         TIOhEd1R8RWsp3xRRCjj2PJYsAlYDyD7q8FuRBzURbDryTY1gKuUa65GtaJh/yvHMeOX
         My1ZEuiGhJ9EHu7utNTky2Sl4nSYuFfl67AExH8rmQkkexlQCCU0l1WIHWDmJppl4maA
         J1xw==
X-Gm-Message-State: AOJu0YyFqjTMGLqWEYYQLC4F56byR7Wzp3S+F/UD5yLag/2tqsF6i17X
	c4MfdiD9I2HSS+rtiv7FkKw3BNURL5sJMA6K85zaUPVYI6l42S0kB+wj1E7MbXRvdjgmaFPLeDp
	uwgc8Vs2PccNJfIY484+kSfKLiu6dFnZKqQ==
X-Gm-Gg: AeBDieuTgUdduxxDR99nCes55ttn7Z96eVus0kdGntsCR8Kdm+IlKEbiicGKhvwlUUK
	dbUtcxVhEYKDleEhW28HRyqrS1d+SEtGv/MMmyEFnU1mBUsTooLbq25o1SRPnzJ5FX44AQodk9z
	VIh7R34WSxbSa67+4lVOyIzZGoE9CZX9uOpiUHZPDIiwN5qHO2sM+S22SNPpewdVqKJrdLxb26h
	45Od2tokf0z7DqII4jKhIjnrqPZuwsxvIy9fWiCWsYEWrOMbw8wkFD4I1T5yG+N4pRZ+v3FIifq
	oIRpmbVm5VCWRcYC152GwgTCJAqjjDGikr9/SOgeAMFt/jnEy3HFBpFEsA8lPQaJWf+jjK0LazG
	MpRUhW/C7nQ6Apgae6E7Aa8W2V9GgWUkr9pgKqzKVPZr/s1VHovJyWve8dkZiSTcI6sqqAJAC8t
	n4wVm1WRKWW4ebzh/Gl1/hHA==
X-Received: by 2002:a05:6102:3747:b0:605:ead:8f38 with SMTP id
 ada2fe7eead31-60a0137af3fmr5155299137.29.1776090092491; Mon, 13 Apr 2026
 07:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129140948.621754-1-plambri@redhat.com>
In-Reply-To: <20260129140948.621754-1-plambri@redhat.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 13 Apr 2026 09:21:18 -0500
X-Gm-Features: AQROBzBHArbmqSKi0LExBmkzat8NA-S1ZIOXGVTNwiYApzdK9Bm-aOYnENBEFZs
Message-ID: <CAH2r5mvgd9W4QJ603uv9UAQ6R=ASnORea532o8Ok7kjhJvEh4A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] cifs.upcall: add option to enable debug logs
To: Pierguido Lambri <plambri@redhat.com>
Cc: Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged the three patches into cifs-utils for-next

On Thu, Jan 29, 2026 at 8:09=E2=80=AFAM Pierguido Lambri <plambri@redhat.co=
m> wrote:
>
> cifs.upcall uses two levels of logs, DEBUG and ERR.
> However, when using systemd, these logs will always be recorded.
> When the system does a lot of upcalls, the journal could be filled
> with debug logs, which may not be useful at that time.
> Added then a new option '-d' to enable debug logs only when needed.
> This will set a logmask up to LOG_DEBUG instead of the default
> of LOG_ERR, thus reducing the amount of logs when no debug is needed.
>
> Signed-off-by: Pierguido Lambri <plambri@redhat.com>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> ---
>  cifs.upcall.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 69e27a3..9c2843d 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -1356,7 +1356,7 @@ lowercase_string(char *c)
>
>  static void usage(void)
>  {
> -       fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb=
5.conf] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
> +       fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb=
5.conf] [-d] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
>  }
>
>  static const struct option long_options[] =3D {
> @@ -1379,6 +1379,7 @@ int main(const int argc, char *const argv[])
>         size_t datalen;
>         long rc =3D 1;
>         int c;
> +       int mask;
>         bool try_dns =3D false, legacy_uid =3D false , env_probe =3D true=
;
>         char *buf;
>         char hostbuf[NI_MAXHOST], *host;
> @@ -1395,12 +1396,19 @@ int main(const int argc, char *const argv[])
>         hostbuf[0] =3D '\0';
>
>         openlog(prog, 0, LOG_DAEMON);
> +       mask =3D LOG_UPTO(LOG_ERR);
> +       setlogmask(mask);
>
> -       while ((c =3D getopt_long(argc, argv, "cEk:K:ltve:", long_options=
, NULL)) !=3D -1) {
> +       while ((c =3D getopt_long(argc, argv, "cdEk:K:ltve:", long_option=
s, NULL)) !=3D -1) {
>                 switch (c) {
>                 case 'c':
>                         /* legacy option -- skip it */
>                         break;
> +               case 'd':
> +                       /* enable debug logs */
> +                       mask =3D LOG_UPTO(LOG_DEBUG);
> +                       setlogmask(mask);
> +                       break;
>                 case 'E':
>                         /* skip probing initiating process env */
>                         env_probe =3D false;
> --
> 2.52.0
>
>


--=20
Thanks,

Steve
