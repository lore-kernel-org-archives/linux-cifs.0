Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DAC3D1717
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777650469; cv=pass; b=uis5hwXjhXbwdvPCL0piZwhzrZNS96WrgPOmOsoLkytklyV42mXzUEknruv//1MgOQPPdREaIfYQ0iOnfnZ3PoGoFYJWzt4RmmvngyXkmdTYFW5+kqBKAKDoJQxOyI1HikbN1byxHSe4tAYOAo8pM30ot7Z+FcKkVAo8P/5XcuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777650469; c=relaxed/simple;
	bh=KAMJcyUu+loBy7Z7OuvsQT75z4RaI/BrOPyP8+HUS3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zol9ncB2BHhx9qZZ4ygqYgB+lo4FVGMuFCl6c8DsjioEevH3gT8398PehE9x+NVCXB/5STwUaK3xf6JXguCwtILNiWG27kAuJX/xCkrPOswmXZhFLKxB+SXt7Acs57EMatbrBfTMk3uTqgeMa6jZyYIzdhraG+FGq1n6/1i/tY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMLnBP6S; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMLnBP6S"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8a3970f1a0eso21262256d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 08:47:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777650464; cv=none;
        d=google.com; s=arc-20240605;
        b=QboVQskl3ZwgqPEbx9YlNNlAXThdJVPvaF4tKT/FYoWJtjKTjfvjn+64KfKqdXlg6J
         4K4mBabH6TCQ2F6U6R1GFXunj9jxbgDbV1HNt5aAYx7o3/WZ50U89/azHRLsF0QHsNx9
         oHetlft1UT2KpvjA8V0+RqZXlEfEqn4PGeqdRSNwF3g5RdWg1MgE0BlAohck11ImGxo1
         0/4fa/25Wha9xgntK6H/cDLMclWy8qU5vRrGnFOr12DSM3e9nQtFqalpIaQ5evdCNDCk
         a1YmKczugCZz8qm9io37MQ3KC4k26ZFtsS7J2RXmGiuL7XenPTxrObdoIzkL5qV7t1Qf
         6HBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LbaE+Aza58xRPo79sT8dReX3dgImdntDKN4JIT9S5r8=;
        fh=7A3r6+09tzNnhHTw+uNnYVJyzJRQqAQTAUc0TDW5sqE=;
        b=f7WrKSmrmWw2xENOAvTJQTWxbtr+0SJ5YKX+2L+8qit60I/HzcgxhWXKSH1EEIK9NV
         TiaffIiiUvYOWGKw/11GmK0SjTi3MoF4o217hgtN5DTDwoKnn/riddyFQDpHvxhtpZ5t
         sqJtg/IkdZtt8Sb7NJOMZRcyh++qmpuXnfqWbVAZKzyWDscCrSEdWX5/D+FQXc/9LT29
         PfczwbgfimUz5dJ0fMHgFRKzWj7XHU/T/z74FPQk/1FGnTE/orqVATISPred36iDyH5V
         yyrwD1QIQGZFmdxsSnlL2VptW76aneaJzTyL5FALiy+LqgcFWSBdTQdrp7HccpZ1jfAZ
         TU3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777650464; x=1778255264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbaE+Aza58xRPo79sT8dReX3dgImdntDKN4JIT9S5r8=;
        b=CMLnBP6S4xDar5Bv0HF8WsfB3qnRulGc2NuS4wdEkB81S35IpLNa3s5PCIWM5WfPHx
         uDkogzQ/f8puhXH4D2U8GZ4ughspXC8LAbgwrTAea6RzxMAwGFcC7Dzh+ODtYifD0iIK
         I06svyZWTPF6YUgzLPSgihg9iVdCtaRgXH1qaOf5dhP1xwfKxsWqu/a3zBQbiX8R7wR0
         GWpzwch58PWtZhTu2G9l9eL/lMQAf3e5Zbu0DZcNFqXqsuBATWegPwPq8RoOHkwbDLO6
         f9i08E2YIS8CtZIdiRbZAxBQdhTIZd8m2wqm6BLpKGj9SM2Xgn0YrHvDw3sBf87xCxj7
         R3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777650464; x=1778255264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LbaE+Aza58xRPo79sT8dReX3dgImdntDKN4JIT9S5r8=;
        b=CoX0ZKqfDgFQZdlMR8oYI3z3vqsH2vYjyJFmOAB2CLvu81LkWmO/M7HioJTAr30lX3
         VXEDWYdsEzrEQioM3o7VlQWofI8OhcGAci6XyIquBxH7eY+MbsyCM28w/cJvWLNgRi/Y
         0Bhu5FEFfXKDI80A+5s3hj2eQRE69ZGl9jWTSXNhAZyyZq8j2f4KFyQwtjxRScQpjlzI
         bj6nUjeD6yVuRUO3hEg25xLUhb+PbLdPkTX+An+Imdz1d/Dx5ID/Hs+UoJwv6dCosDmO
         XzY8e05KOcv+5Dk1mmL8FPvpnZeHUIg85IaZLalMVV1dNsJRlAfW/KUxJP8OuBHHpv7c
         qWRQ==
X-Gm-Message-State: AOJu0YzQV6Pq9S2YvT9eakVGohl6gWY4QgbrmaHaLFRvX33dsDXPOLOr
	uReconcivtPgF/HEGSgtCGWoHboRcB1IZPRR0/qO4Et1KxZo+GMMZfrRmvQ414fy08qEpxBJStA
	vb0WS/u1n8+zTGAl0Dutn6POYKrIusCo=
X-Gm-Gg: AeBDieubr16DiuTZmWvhxzo6bRDEg8ckz/W3xFMSWYsm2pqESrvNZ6uxcE7coyOW2o3
	8uIzESJxVqtx12AE0e18PJ1fv02L8XE6ep0MXzBLBf9Q2Bshh5K+0Rem78pfL58/yBQ/PGwJKXd
	Gs3Xg+hHOUI3N9BXSH4QC7r1QO+nN9ULwHm+/5CvWqF5Bn0LsOvdRo4n2elRSeRHBFADQwxl7cW
	8EdGxsijZ81vi3fNZWcb7dOOpmUUvpV+w76Bnlv3IfX+wAoF5xUhD5qxGJHVJbVmGBMUze9IvKR
	I5gQmpccGawu5KHGHDzpegczdxRNgE7awbGMVs9cldPd6hlPV+bVsew6wRZyYJH3MPp7+N1zjo6
	cuiq4Ic6hXQSLDXFTEabBG2lelNPGvLWlYYFgNlVVes7q8/raQz2h6j9Tj0fldOMDOOscJZg=
X-Received: by 2002:a05:6214:4285:b0:89c:cfcc:2f31 with SMTP id
 6a1803df08f44-8b667d75121mr314426d6.32.1777650464271; Fri, 01 May 2026
 08:47:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501112023.338005-1-sprasad@microsoft.com> <20260501112023.338005-13-sprasad@microsoft.com>
In-Reply-To: <20260501112023.338005-13-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 1 May 2026 10:47:31 -0500
X-Gm-Features: AVHnY4KZUhie906gbiYG-risco5S5vSN8rwIdb5hOXMHNzFG6cwnGLrAOIBCwTc
Message-ID: <CAH2r5mtgqehu+Qtutws_cHQRmULHZi_-0_WRyskmT=emcZEjzw@mail.gmail.com>
Subject: Re: [PATCH v4 13/19] cifs: option to disable time-based eviction of cache
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Seems like there is still value in temporarily free up the dir cache
(setting dir_cache_timeout to 0), remount with nohandlecache may not
be as helpful if you just want to temporarily reset the dir cache for
debugging.  Is there another option that could set it to unlimited
(e.g. setting to -1, if that is allowed)?

On Fri, May 1, 2026 at 6:20=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today there is no way to disable time-based eviction of dir cache.
> dir_cache_timeout =3D 0 meant immediate free up of dir cache on next
> laundromat scan. We already have nohandlecache to disable dir cache.
>
> This changes the meaning of dir_cache_timeout =3D 0 to mean unlimited
> timeout. Shrinker-based eviction is still possible.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsfs.c  | 2 +-
>  fs/smb/client/connect.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index ee5de358e27f8..79a6a4c297ee3 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -121,7 +121,7 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requ=
ests to server for "
>  unsigned int dir_cache_timeout =3D 30;
>  module_param(dir_cache_timeout, uint, 0644);
>  MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache director=
y contents for which we have a lease. Default: 30 "
> -                                "Range: 1 to 65000 seconds, 0 to disable=
 caching dir contents");
> +                                "Range: 0 to 65000 seconds. 0 disables t=
imeout-based cleanup (cached dirs persist until explicitly invalidated).");
>  /* Module-wide total cached dirents (in bytes) across all tcons */
>  atomic64_t cifs_dircache_bytes_used =3D ATOMIC64_INIT(0);
>  static struct shrinker *cifs_dircache_shrinker;
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 69b38f0ccf2b2..849c16c538353 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -2698,7 +2698,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_=
context *ctx)
>
>         if (ses->server->dialect >=3D SMB20_PROT_ID &&
>             (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASIN=
G))
> -               nohandlecache =3D ctx->nohandlecache || !dir_cache_timeou=
t;
> +               nohandlecache =3D ctx->nohandlecache;
>         else
>                 nohandlecache =3D true;
>         tcon =3D tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new=
);
> --
> 2.43.0
>


--=20
Thanks,

Steve
