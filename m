Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC193DA7C5
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 07:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789628791; cv=pass; b=XbPTYsrGPODNhbGPMjI8ONccagWIlHyNkBDd2UZ4GptF8jT5psbpzgkWdoYfTcV6ekSiTZYx+tXBl/AKyYKFKs3Pv6IQkiatLIjhNS6OEqrNhM1tRG3x5Us3VQidAATgo+7oWWfT2wr5JNT41duReBg4QoLJKGHXPsMeJ7NIivg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789628791; c=relaxed/simple;
	bh=J2uRQxDf8E+aareFzGaYlD702xZ3/doMA0NNbLNDJyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QNP4pnqxn+Pct8UfzWkktlD249bJ0EzTAwtKYLwDI/WKcMYpkoHWCCB4FASvESwwo8XRAq691EQKC9MIqY/2CMYNBT4f7dXOgWJWXCgexz9xrQFUDjXAzo+0pbvbrkvMak3XaOYQsj+FU/1pck9dH+29/n7ByZUA2v/7PxpifQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oppegwj3; arc=pass smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oppegwj3"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a985fba28bso641486a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 00:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789628788; cv=none;
        d=google.com; s=arc-20260327;
        b=F8bnN+F7fSjIYJ8n5v04SjpSYwnYjdcsDxkN2/sWo/EYw4+OYL2Tmajs5YbqVAaH4U
         NRJjuocOqzX8Tmi10XLK1dT3sQ4rh9TR+osZ/yMens7sEhblCOkBcXVm8Z/ewh/slmHz
         69jKzJO6urNnDaEwi5TQtsRAQDO1zCyOO1ooX8IUtCi4otSAl2jjXGy7hXWnPRaYOmXu
         3RqnNn6uCI+bxhQywdlL9bnF1PGt26FIoi3t5b8vuvmXXlMR+CK37Fokxl/+LdmNWejT
         GvNwNSAdLKRaUCmNvliQ7gN+V37fP9muzBl/xVfUo1DNkkXjcFnUz+isSa+xI3keaT8W
         OK4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NNxe8K44nQvoz/kViWtNNfcivqgrY0YqGszclygSN/s=;
        fh=ZIkBjlmCUV9JilsQfeossITvxlkWwYWo9TpcUdkW+yA=;
        b=RqafED2ctLe/XQzRyH8tapXXMT6GsEdfMSsZy1Sp9za2PmDDoC6uNReasZA9kiqqMm
         oKQmn4qWqjp9YC4l3ZBYXTM481EvuX1bpvTgOT18M+QPeAEnXSPHlxAtA/8yUdANPFX9
         45jE/AyGBm1I9KR2fv1SVZakUa3wFXBeJvrs14q+QkeqGgng06GZGNZTOe4aHVEILGar
         uMRF4TTzc+n0/RD/3Slsbd4CxSrSRsZuhsGo4XFTqBwXAOao+dq7EVzfNxCNI2hJsJPj
         VkuuzxamZB9Ps0h1FQRgnPcccT54ug3axn0zVnniKbXIfwCtQ0vl1kOT1QIm6ZPu2YMp
         Ilfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789628788; x=1790233588; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NNxe8K44nQvoz/kViWtNNfcivqgrY0YqGszclygSN/s=;
        b=Oppegwj3+jR7JzKeyMHmjJd0gjE7irPCajSdUaeTjiH3TFiUcxRSOqDD5RRtciF0bW
         4URA0l0y+ZamhsTE3IQV4eumEGEe76AnQ9+0DGRwKFLcbCGuyC9V/U/iNl4eDoKqwfpQ
         3YKLje6CisZIU5wXVQzwxbZFNP1mdY+CvhrTx32wkQvFEau1j4N/2EyPG0sh47gGoz45
         BlZdHQ4L34vbOHtE5Mvjgf91R+mcWpsL18F9/eDgI9iu6Q7nbi55BrzPuAsbVlNbGbTu
         R/LWvqzuC00vZut90Sux7VhLj0o+2NV/3hpsFiWm+Tzo5JYRHFfw8oo/Z5zTnUjabdmb
         Fe/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628788; x=1790233588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NNxe8K44nQvoz/kViWtNNfcivqgrY0YqGszclygSN/s=;
        b=LEQCJL0AfAqJ84CKwgECrbndkBgiWJktMW2SPrR1PpmPagIJrBXy5gct0cORLzHJmV
         gJIvbPvkzRUclpyOXBci6lbmPiabzoNlNDiEcI/Nfr48DXcB2wMAWzy4yBD+V+eOPhpL
         jBDOknw8eosQH7YtheRG3sDRH7HUcTIFudPiDyag7+PuIJ3JJxGg9JHgv6hXI2j9ceWd
         Q+MbWh36ZlG+vKbauyzv+NCJr9iBuTVNdqCcmmK/LEM0/tRMWJDsOC+xZ6rlvHA/0yqJ
         GCF5hYj/YY59Duq+lxjRkPhxdOJr1MHCQjXXJ4XYc82v6KGC0eucZbu4HHXfqti9BAg7
         tZ1w==
X-Forwarded-Encrypted: i=1; AKwUvByh1N81umbP8HiZ1cbexVv6F13N3d6+11nVmQ/2tAFsAc/srbl68oqFe+rqJlqTowRJfEgyqq8jlv8p@vger.kernel.org
X-Gm-Message-State: AFuF++lTWaKC2GOLXyFhMGxv/ztzgtu5S/pWn3bspQvGS27LtCiGlabZ
	uZlBWZkI9tJHcjinMOdXDAs9mQdial75JXRDROXmZVazyEiWZQHWjXJ9w4wktTXILx1UBG4ext8
	n85yWd0dZ0oLrp11xZ3E5TWu3tIxSEd8=
X-Gm-Gg: AYBFou0s5VyuaSigkc66SZ1mQCYxJZBbk51faPPzEYSaMRcJXbWva4de4pIIX7W7xJW
	JEQILMGxy8N1GAkjMosIK6tklCxW6pFswJbHwdWKl5uxhBlHVneKa25ZByWqNoeY85arVr5cDub
	JLJhtuz/EpxwvxPvlOUBZWgOR9kBroW7dHjjOeXGT1lV+6XQ3Y9wk/3R2ePHvf6eQXOT+MPQzJ3
	9TjYOYmV1myzQpkTCX5ZNoLE3sZ6Ex90VhHHSF5ez2iZO1IJFYQHVzEpJ+A2M6A445CTI1sj8L0
	sbgNBtKLdNlxWOJNRNvt+yLlPicSJwJYiPkUT0Pi7vrXLKgpcI/1tw==
X-Received: by 2002:a05:6402:2b85:b0:6aa:976:562 with SMTP id
 4fb4d7f45d1cf-6aa223a6ef6mr3603781a12.11.1789628787368; Thu, 17 Sep 2026
 00:06:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917003750.1790143-1-pc@manguebit.org>
In-Reply-To: <20260917003750.1790143-1-pc@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 17 Sep 2026 12:36:15 +0530
X-Gm-Features: AcwNN1UOB-9ARP42Uhrun59wlBeaXtJ6Zggz9aWOQLG7syf_7WRR-0ry8OzIutU
Message-ID: <CANT5p=qRoaxp4vzM0=GtwVgZMDKcJOO9rvJjc0HW2+5Y8cYd1g@mail.gmail.com>
Subject: Re: [PATCH] cifs.upcall: resolve scraped ccache name explicitly
To: Paulo Alcantara <pc@manguebit.org>
Cc: Pavel Shilovsky <piastryyy@gmail.com>, Alexander Bokovoy <ab@samba.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 6:27=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> get_existing_cc() selected the credentials cache scraped from the
> initiating process' environment by exporting it via setenv($KRB5CCNAME)
> and then calling krb5_cc_default().
>
> MIT krb5 reads $KRB5CCNAME through secure_getenv(), which returns NULL
> whenever the process runs with AT_SECURE set.  The request-key upcall
> that spawns cifs.upcall triggers an SELinux domain transition, so on
> systems with SELinux enforcing cifs.upcall runs with AT_SECURE=3D1.  The
> setenv() is therefore silently ignored and krb5 falls back to the
> profile default_ccache_name (KCM: on many distros).  As a result, a
> valid TGT living in a FILE credential cache is never found, and the
> mount fails with:
>
>   cifs.upcall: main: valid TGT is not present in credential cache
>   cifs.upcall: Unable to obtain service ticket
>
> while the same TGT in a KCM cache (selected via the profile default,
> not the environment) works fine.
>
> Resolve the scraped name directly with krb5_cc_resolve(), which takes
> the ccache name as an argument and does not consult secure_getenv(),
> so the FILE ccache is honored regardless of AT_SECURE.  Fall back to
> krb5_cc_default() only when nothing was scraped.
>
> Reported-by: Alexander Bokovoy <ab@samba.org>
> Fixes: ed97e4ecab4e ("cifs.upcall: allow scraping of KRB5CCNAME out of in=
itiating task's /proc/<pid>/environ file")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  cifs.upcall.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 76e88b79a760..8fdf1af710ef 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -534,15 +534,31 @@ get_existing_cc(const char *env_cachename)
>         krb5_ccache cc;
>         char *cachename;
>
> +       /*
> +        * If we scraped a cache name out of the initiating process'
> +        * environment, resolve it explicitly instead of exporting it via
> +        * $KRB5CCNAME and relying on krb5_cc_default().  MIT krb5 reads
> +        * $KRB5CCNAME through secure_getenv(), which returns NULL whenev=
er the
> +        * process runs with AT_SECURE set (e.g. an SELinux domain transi=
tion on
> +        * the request-key upcall).  In that case the setenv() is silentl=
y
> +        * ignored and krb5 falls back to the profile default_ccache_name=
 (KCM:
> +        * on many distros), so a TGT living in a FILE ccache is never fo=
und.
> +        * krb5_cc_resolve() takes the name directly and is not affected.
> +        */
>         if (env_cachename) {
> -               if (setenv(ENV_NAME, env_cachename, 1))
> -                       syslog(LOG_DEBUG, "%s: failed to setenv %d\n", __=
func__, errno);
> -       }
> -
> -       ret =3D krb5_cc_default(context, &cc);
> -       if (ret) {
> -               syslog(LOG_DEBUG, "%s: krb5_cc_default returned %d", __fu=
nc__, ret);
> -               return NULL;
> +               ret =3D krb5_cc_resolve(context, env_cachename, &cc);
> +               if (ret) {
> +                       syslog(LOG_DEBUG, "%s: krb5_cc_resolve(%s) failed=
: %d\n",
> +                              __func__, env_cachename, ret);
> +                       return NULL;
> +               }
> +       } else {
> +               ret =3D krb5_cc_default(context, &cc);
> +               if (ret) {
> +                       syslog(LOG_DEBUG, "%s: krb5_cc_default returned %=
d",
> +                              __func__, ret);
> +                       return NULL;
> +               }
>         }
>
>         ret =3D krb5_cc_get_full_name(context, cc, &cachename);
> --
> 2.55.0
>
>
Seems like a reasonable fix. Pending testing, you can add my Acked-by.

--=20
Regards,
Shyam
