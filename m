Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F50212D20D
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 05:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725342325; cv=none; b=lgNcvATo+Ltyd2ufsCOmV1NW0PnidpAf1m3tCkrNpla7k8DnKvZu3cOysCa/cWyvfEQx8Y0A64YhpcPhqIgRD0AjGS2z4xV9kpQ1Eur5DbmmTDQseOHtaJZr4bPAz14VzM13addRi/jABTLJGdz4y3NfepE64w+orpcP/Qb+ITQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725342325; c=relaxed/simple;
	bh=uquXX5PVso5tFecY0Hlpd89knJCr46GIN4LVm94T2Fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eGcqcpbShm7BMQfH9+tOYrAhNM1VvtE855dMqgiugJq1u23ceMK7N39ie62qp6JCeBqyKx822eHd9Pk5y54C+8JG9LtnS4fzEOgdVRnDF/imZae+AkeiN42j0vh7pwj8+1QJ3WAOAM/tzgvtQSbtGZ81s30It75cbfqleZfofMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H9oD4Pvd; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9oD4Pvd"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-374b5f27cf2so2261702f8f.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Sep 2024 22:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725342322; x=1725947122; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKKTObdekpQJ8jyXGJmV50vKGfwl6z7FJCyAypHcuqQ=;
        b=H9oD4PvdTFVNMTTuTq4W5eGZHPBd1aPTeRv1IcuiXWJGJ6YG7EXjYTaoMktPTNqX+f
         yj0qN9fHvFxT3d9P/4w+/hrf3FePdNlGwFFUTCRM5KdvMJKjJVsqVvpHEkFmhy1s03rm
         QP2zItpa3Ve1Zx63EndERbiv0au304w++WsnIRfWDosinEbwebK5wRPbYB8PlsqgT1+H
         69Fm59SoIw5IKpryzpYXT7nYTjBybchVsneJD7+ZS0EgqPnhkUpU0gAbdrLo2xNjbmGf
         jgGTC87uN1B6oZyGFx1V6S8DjW0C78CO2npN2kzQSx8VbRdIk3TjhgCO3Je0k/HB4h4B
         ONkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725342322; x=1725947122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKKTObdekpQJ8jyXGJmV50vKGfwl6z7FJCyAypHcuqQ=;
        b=ZsOb5pVmR1d83rkUi+UUbADla+Kxzzb2zHF6FM2rVV3/wVaVYqZr/kO+fj24dKwVkD
         Cc/cXKgv2KWgWSqzS2wjwf9rCe46ZtMLvbp23trBcpQrGZDl79DOT3IozzPheAG2Ytuv
         3Y64BD5YxqOV+NIrd614HZWaKxYRyI0/ySouTpILFJDmYygCvBbe+CXXhF4ASkffx3cB
         kqnXxsrutiAVZEud71QGPXrgAlfCvVA/frDRSlgjRSE72vbr1O3+FvI7CXG+9+a0yvmr
         O8awWUshd0tCbGcicMOP/oWK9ezpn8kMh6vqzW0kk6N6X8Ftq3VudRpAMtHR4JS54Y0f
         bB/Q==
X-Gm-Message-State: AOJu0Yz1FH8+sWIhe6Y2kSOxoUjS9sQSrolQM9Bu396ZIcL3jGUpLErV
	/HSjqXt4+dvF2SiXIJUKTmGRb+DGDcWhBlHYmL5XQOZSyPmshdcjzGCToBGZzHfxjnMjD49aIpb
	c6hbxdDKMtjJaIHqBlbJbhluzVXg=
X-Google-Smtp-Source: AGHT+IFDWVZT/i5QrNKpQRVCiNlYJKmgMJFfYTeOKSEY3VUsNgvS3NTudVqAF+HQfnUu5+EFnwpw0wQv8rpI6awHBfU=
X-Received: by 2002:a5d:47a7:0:b0:371:8a69:18b5 with SMTP id
 ffacd0b85a97d-3749b58962fmr11440401f8f.44.1725342321566; Mon, 02 Sep 2024
 22:45:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250@epcas1p3.samsung.com>
 <20240903051918.728540-1-hobin.woo@samsung.com>
In-Reply-To: <20240903051918.728540-1-hobin.woo@samsung.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Sep 2024 00:45:10 -0500
Message-ID: <CAH2r5mvdprK8imp4MCgTS_t3Ke2Gk6bG3SJ0ksZGDNMR4wPGJQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: make __dir_empty() compatible with POSIX
To: Hobin Woo <hobin.woo@samsung.com>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, sfrench@samba.org, 
	senozhatsky@chromium.org, tom@talpey.com, sj1557.seo@samsung.com, 
	kiras.lee@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Is there an example where you have seen an fs not report . and .. ?

On Tue, Sep 3, 2024 at 12:19=E2=80=AFAM Hobin Woo <hobin.woo@samsung.com> w=
rote:
>
> Some file systems may not provide dot (.) and dot-dot (..) as they are
> optional in POSIX. ksmbd can misjudge emptiness of a directory in those
> file systems, since it assumes there are always at least two entries:
> dot and dot-dot.
> Just set the dirent_count to 2, if the first entry is not a dot.
>
> Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
> ---
>  fs/smb/server/vfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 9e859ba010cf..bb836fa0aaa6 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -1115,6 +1115,8 @@ static bool __dir_empty(struct dir_context *ctx, co=
nst char *name, int namlen,
>         struct ksmbd_readdir_data *buf;
>
>         buf =3D container_of(ctx, struct ksmbd_readdir_data, ctx);
> +       if (offset =3D=3D 0 && !(namlen =3D=3D 1 && name[0] =3D=3D '.'))
> +               buf->dirent_count =3D 2;
>         buf->dirent_count++;
>
>         return buf->dirent_count <=3D 2;
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
