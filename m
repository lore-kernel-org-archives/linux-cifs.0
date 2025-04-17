Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0418253B7E
	for <linux-cifs@vger.kernel.org>; Thu, 17 Apr 2025 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744905524; cv=none; b=Q/rKP6cUeXWBNF6IzWEKKQMLUBuhWXN8KOQlvZLwhyExoZFoqLCOVKRKIzlAKDPRvRTWQ3EFKEW/cQCd+QkwoCYwVA6mjpjhG8lClkvb7kHQ442n6vZZQBO6VVO92mk6LbI0iE7cj9itlCdQBSx+v/oeXelLJP2CYeMHe2WJhK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744905524; c=relaxed/simple;
	bh=CC1ZnZUapvRqEYSbeTl37bGVxOEJGu6KQs+v00a2hKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jQMv1m6ScaXq/KIHFnZ/AbbfBLdgjP2g+Q5ZsEweMNV6wDtnSSqNG3SmXQDmBXNYqPEoEyeU1QQuouFbB73KCpPizNfftxoYlNgrtbP6lt24RrHhJDAS4PWrOWAO4DibEeNsfJc8KavkrANp/xYahDdEAAN6n04zhWzvw7WV//s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=noBXTYMV; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="noBXTYMV"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54998f865b8so965718e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 17 Apr 2025 08:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744905521; x=1745510321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wv3LigI3xOWhoXLfr71vNXDT9QEzM0DUbx7wjCiA1E0=;
        b=noBXTYMVy668mt1sFAo2cShNUDpu5lWoGQg+1qq3eOwcOS4c4R0dbCTehHudK+p7DC
         BC6z00ppvhPU6UMBw9Bk8t22r82TYUnC9zTAOKjSGP9E35nipTGPKTAaZsqsYvls58+J
         pJQxCY1DFTSdNpEH4msWmF0qBwuF0/jVHLIp1rQ2pX4HcZn8TLrDPU1aJl76Rp6x6y41
         +EU003hcOb32wUeDV20m+xbkIf8L5BiHFmxalphLw7+Vj7NyOxvj1hzCKUsaXwou04Uq
         syGceKSGk5ShOEtKTiYFPwx61LDfgHQEAX0eIGhVKNjCcgvFOia9lD4UOKeIQgW/ND4o
         hRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744905521; x=1745510321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wv3LigI3xOWhoXLfr71vNXDT9QEzM0DUbx7wjCiA1E0=;
        b=oRdf4aLYwMIqWWO1rv5JNgM0/dMEKtebaLNeu7G1XOnG3oKqohQn+1UTZJwmUWSWFl
         TyUBFOh9LVRn5pGnJX7ZLxfk6meZadKhZ/Vzjxnxfi8MpOLAkrtfmJIEy+QiYzanSMPp
         Y9PXqxgkyV0KkLtXVdSJcFDCGNJKdk2QSEWqydPlM/48QX0jJCwNghqwjf7KilQ5Fhaa
         ht5nM3UkjodZ/pdPeqCDTq6RSI1kqdz/mHwMjRa709wIrjgsece0/Tn+AlujXb06iEgX
         RB5R6BCuMJaV6/A1vcxmgDhuRcIQcUY5b7qnw2HkeoF8d+Ieq4S+ziB9O4sGYm5fYKXh
         jbkw==
X-Forwarded-Encrypted: i=1; AJvYcCUUoHPIG5q4kdao5gDS9ECgzbfGK5dKZ/DY6rPLrmWIZxCS98syCNVN991dIkLLKZ347MgA6LMc7YOg@vger.kernel.org
X-Gm-Message-State: AOJu0YwuiDiThvxMahjtzhlsJ5KvkNmxSxcSunOBbE6M6EHVTfLy0tBQ
	9IfO2pBoIOqQ3j8g976znponxWObMowYjA+sTRJQ0T88pyEFs6tz8fG8MPTuEiUzcq4Pu0AzBDI
	FvR+AbZCP65+2pRciU4i2+EjmavQ=
X-Gm-Gg: ASbGncuLB7Ul6r9ja9WU8XCX5L5EdyBjWqX51XLg0A/lpqXdFG9NomQ1IpIES3FzOz6
	yUwKPwoezWX6UzF5CAAujJ7uABVM16XIi6e+u4zEtNvLsN6KKAI63UZomg2/AalN0snfo/8P0J1
	ZCUw6GhFi0ETFbXWqjv9sIAGNNI/npn4w517zZoI2NPycQz6lQjoF3hq1X
X-Google-Smtp-Source: AGHT+IHUCe1HA8Gb+VGRSPifdwCxz1Py8ORfHjIfdjjaGjJYxcSA4Fy/wjXT+WhHx15JiTGHBpqnoqEIJCvGDxaj3ik=
X-Received: by 2002:a05:6512:2356:b0:545:2fcf:642d with SMTP id
 2adb3069b0e04-54d64a9223amr2618970e87.6.1744905520634; Thu, 17 Apr 2025
 08:58:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250415162052.361258-1-pc@manguebit.com>
In-Reply-To: <20250415162052.361258-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 17 Apr 2025 10:58:27 -0500
X-Gm-Features: ATxdqUEPIi7achkgLiksoozzGiaB17IRod3ZlhqpVYLwe3yFm-FLmgH8E4A-p78
Message-ID: <CAH2r5mu1zV4wi1b-ky+wErNPW4FnYbFNt1xOEv-qmkaJK6e7Cg@mail.gmail.com>
Subject: Re: [PATCH] cifs.upcall: fix memory leaks in check_service_ticket_exits()
To: Paulo Alcantara <pc@manguebit.com>
Cc: pshilovsky@samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Have added to cifs-utils for-next (and also
https://github.com/smfrench/smb3-utils/tree/for-next) after
minor whitespace cleanup, and added Acked-by for Bharath

Good catch

On Tue, Apr 15, 2025 at 11:20=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> The error message returned by krb5_get_error_message() must be freed
> using krb5_free_error_message().
>
> Fixes: af76bf2a11a0 ("cifs-utils: Skip TGT check if valid service ticket =
is already available")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  cifs.upcall.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 678b1402d2ba..97ab4ec88fbc 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -634,33 +634,39 @@ icfk_cleanup:
>  #define CIFS_SERVICE_NAME "cifs"
>
>  static krb5_error_code check_service_ticket_exists(krb5_ccache ccache,
> -               const char *hostname) {
> -
> -       krb5_error_code rc;
> +                                                   const char *hostname)
> +{
>         krb5_creds mcreds, out_creds;
> +       const char *errmsg;
> +       krb5_error_code rc;
>
>         memset(&mcreds, 0, sizeof(mcreds));
>
>         rc =3D krb5_cc_get_principal(context, ccache, &mcreds.client);
>         if (rc) {
> +               errmsg =3D krb5_get_error_message(context, rc);
>                 syslog(LOG_DEBUG, "%s: unable to get client principal fro=
m cache: %s",
> -                                       __func__, krb5_get_error_message(=
context, rc));
> +                      __func__, errmsg);
> +               krb5_free_error_message(context, errmsg);
>                 return rc;
>         }
>
>         rc =3D krb5_sname_to_principal(context, hostname, CIFS_SERVICE_NA=
ME,
>                         KRB5_NT_UNKNOWN, &mcreds.server);
>         if (rc) {
> +               errmsg =3D krb5_get_error_message(context, rc);
>                 syslog(LOG_DEBUG, "%s: unable to convert service name (%s=
) to principal: %s",
> -                                       __func__, hostname, krb5_get_erro=
r_message(context, rc));
> +                      __func__, hostname, errmsg);
> +               krb5_free_error_message(context, errmsg);
>                 krb5_free_principal(context, mcreds.client);
>                 return rc;
>         }
>
>         rc =3D krb5_timeofday(context, &mcreds.times.endtime);
>         if (rc) {
> -               syslog(LOG_DEBUG, "%s: unable to get time: %s",
> -                       __func__, krb5_get_error_message(context, rc));
> +               errmsg =3D krb5_get_error_message(context, rc);
> +               syslog(LOG_DEBUG, "%s: unable to get time: %s", __func__,=
 errmsg);
> +               krb5_free_error_message(context, errmsg);
>                 goto out_free_principal;
>         }
>
> --
> 2.49.0
>


--=20
Thanks,

Steve
