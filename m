Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FD94949FF
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 20:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781210053; cv=pass; b=msmiIsRR89uJFhRr6CnlU995jjdwsGVmaqkTA7DaXzD/zJDlbf9x8KvIcZHZDhIR0YVNgtZPKlZU7aSz8oV8DUY/T9974Hp48NBFz8IOz83/atsEiBvFRvL2V2e9MH97UDDVndbRYMOIcGL7vqA82HlPZg0HVCVeTmULcMo6xWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781210053; c=relaxed/simple;
	bh=+k9Qjy1NkF0FDiPkGEmSGqZVWGbN48lhI4YAZOO5Z9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S8F4VXvKD7YfLwJ9OQ33nZSBD88GgWCKxXpzBVUf9FDUeuJfk8xe8WwSOeuvwxqYnhcsXCn0H56xMJA/SFAIxgIFR/nRZuwRM0CVDdL9AaYrcncY/Q2q8YlbNcVxNCYrfdicLcNR87q/u4KsBh3sYlKWAvfJ1U/gnu6FwuMCyoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P5wshO8B; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5wshO8B"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa68cfc182so192779e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 13:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781210045; cv=none;
        d=google.com; s=arc-20240605;
        b=H9NUXnmYtImHFoojSd7jQbe1renPSO2+DdraGJ6bp2NQEZx9p+3T4U6ckvHvAovOK8
         hDKX1Tm6vionFlGfyr3Pb9FmGFU3lu0KCLds+8kf8U37c0BBTcfJR/MXDaVTaH+kFnzU
         e2bzP4pQtrwQ4klmETKV6eNDoZILErc9eGbt93XxNW4U8TfFmNaF4gXlBqlxGavCn7t7
         XPaQm+TFJEzQ7Y8YrfsgylPbsfMFzfrhzpaYE717cToeOgaggBKFkKPsWeOX2hPVa/2I
         alasvi9SIKvQ8deOatTemL+B/pITj5CW2mzpyOGShuAQkb69Cp/Xu2WWMNPygAJEe4eY
         uorg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VXgpEb7Jl6rYUuemLw2bRvtLoodxIHoILodPUeD0OiE=;
        fh=aN6NFjxx5wXl5Q48BVx9tfVrN4QToyN5rtduMi51gkE=;
        b=gJdKviBCEJs2vM7FgOD6JcUmW6GlGZCxFo55GWOHkSbHZF6ccypbCaKQTSv1qm1nZI
         KGLRhbkCZqs22Qzudt7f6/fr4e4qVhtiL3IFnmyKjAP3aZ+YCvOJ+3dpPA2eyRwYavWV
         lxUIMQSX64BB00fxBo6Rhc69Mztw7srm2VpUrrX180/Xcr4kS96GbSGlH5O3c5Wzwo8i
         AIfyjIr2QL07U0chzsMANUCaIhgV6WsuAmGSt2406kWHEqe8KfM+vSRosZYZeb5luzsd
         rhHS8TSX8rflLP3JBwecyQF2B/ygo3k5vp/O2ylQOstjwVxwAWMfmuop5+OiXxTTGqoN
         R1kw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781210045; x=1781814845; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXgpEb7Jl6rYUuemLw2bRvtLoodxIHoILodPUeD0OiE=;
        b=P5wshO8Bkr2jXP3OfF+ta8++tZQnze+5aUYtNpuOxocg3g+8xbfnnjUUAPZi1aml2m
         pkvmCeZQ3zFTHc2D+ZDgiiQb5n2t14luKs5H1fJVy4cPZaBiQBvxFa4anTXkCBKHGrLX
         he1zuvBbaq6Q7DUAdCKsgi53QaD+RKZsWfpZscL07Xg/LcBj6f3p3YoxQ0BlhfX4I/DJ
         MIH8VlT511umTEtrZvJFbdH+Gp50HJLXKybfLDZhMaSJqU2LRFXIQV5PS19E1o6z5Pwo
         8Snmi9+2j2WV5Q4CFEv2sGmvY3nZ2YNs1PISpbMH+YKg1M7s9h5r7kXUcRp+z5i0EprU
         JCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781210045; x=1781814845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VXgpEb7Jl6rYUuemLw2bRvtLoodxIHoILodPUeD0OiE=;
        b=dYcPOLLbPnch6XP3akCq6u+QZaqbKLhFlhD4QFZazTFfysc3eoZvFUWlezg8wR4dnq
         E8AMFZI7BQdmz5EYTxDNdIPfma9PWJ5RrwvZY+LOcbyTK9uvfKEhmxGyllS2ncdLOdUr
         8jqNosmSqZ/vlavydLLEObwCw5z/yfGCPugA+z5PAz1Zc6uFOUDENyI1JmdjYKtJGa0k
         GoFhVB1vbwYUdeu3uDUs/HeWU28oKECDPL4S1rPL9HL0m0TiO/gucSVjex+oUvvzBFGA
         7dgPAjUwCzmdvWnmm4L5QkblHT74LLvzB7KyNmVF8ocdiJMuNzEcg+nXviscT0JTcYr/
         017Q==
X-Forwarded-Encrypted: i=1; AFNElJ+0k7w1TsOZvL+YWKSjTYt13k4MuHyNnUn4ryZuZ0GKFHoP/oZoix+ZcQLgHhhTxn+t0Jl/R+DHHFAk@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ595+pqBpLr/uq5RoPAg7tnJCkUPzkqC0h199PWHp6l0laLAA
	Kake4AJBgp0+R5fHyNbMWrsTT2NfmIySRN1/2h4EcJe+WO3RSp8rGUcc1EHXFkcu8vet6W/IDb+
	gvZQW7I50zsT3ZVw+Qt9oWRnUb92IT9c=
X-Gm-Gg: Acq92OHRgEND4MW1QNcmx/u5isexEGBAC/KYBZauICQMJ6idoGfrnr/lW+5I0nxgbuq
	kKDA6Y1tgZwJvs6gbVgSB+/o4AyG7Ovt4xeHcWk3OO39moBVt8Qjxw0QUeSzPyj1vwpXrev1U8A
	7zUAesE9Eo2A3IHSdoEoYH8JaAdBXDpA+iqgsUMofmukDIxJrph3MgckmuX95Z1Ox/9k1IyFk1/
	GFnDkUakIE+RyoZo/HBC6jZSAFE1VxUFURqD1vWMbKR4KGJOhmBxgjAoWTR/i6UUPVuT6luY4T5
	AzvNxEwBRuIFzyQutE4uAuNh8poY/dki2D5PeCDPoi8NBGdgGeAoiamExSiEnn0Q5fKj3upWmYy
	reOFKsgQsnDjpgMFTdGWT11gkuYEwbwxPErRUhOoq3hwcAbNZMB7dtgdZaQ4nLMMJR+cb/4E9Dl
	VNHlnZepaBvv6fGT1gTxky
X-Received: by 2002:a05:6512:230e:b0:5aa:7ad2:f4d5 with SMTP id
 2adb3069b0e04-5ad27fb780emr1375910e87.38.1781210044818; Thu, 11 Jun 2026
 13:34:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aiplG8fGQOYmXS5g@stanley.mountain>
In-Reply-To: <aiplG8fGQOYmXS5g@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Jun 2026 15:33:50 -0500
X-Gm-Features: AVVi8Cdu1uKQmjCfULGU_wu_t2erX4cmfDuYdIGcEcJxfNgKRpgUCSSL2tyI2Ps
Message-ID: <CAH2r5mutN9yDPF8Q=z_GYbgAzJFS6OE+2zBd8na9zY1Wbt3gyg@mail.gmail.com>
Subject: Re: [PATCH] smb/client: clean up a type issue in cifs_xattr_get()
To: Dan Carpenter <error27@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
	kernel-janitors@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Doesn't your patch need a cast in the following code in xattr.c since
it returns a ssize_t and you changed rc to int with your patch?

315                 if (pTcon->ses->server->ops->query_all_EAs)
316                         rc =3D
pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
317                                 full_path, name, value, size, cifs_sb);


On Thu, Jun 11, 2026 at 4:00=E2=80=AFAM Dan Carpenter via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> The cifs_xattr_get() function returns type int, not ssize_t so
> declare "rc" as int as well.  This has no effect on runtime.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  fs/smb/client/xattr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
> index 23227f2f9428..5091f6c0d7fe 100644
> --- a/fs/smb/client/xattr.c
> +++ b/fs/smb/client/xattr.c
> @@ -272,7 +272,7 @@ static int cifs_xattr_get(const struct xattr_handler =
*handler,
>                           struct dentry *dentry, struct inode *inode,
>                           const char *name, void *value, size_t size)
>  {
> -       ssize_t rc =3D -EOPNOTSUPP;
> +       int rc =3D -EOPNOTSUPP;
>         unsigned int xid;
>         struct super_block *sb =3D dentry->d_sb;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
> @@ -354,7 +354,7 @@ static int cifs_xattr_get(const struct xattr_handler =
*handler,
>                                 inode, full_path, &acllen, extra_info);
>                 if (IS_ERR(pacl)) {
>                         rc =3D PTR_ERR(pacl);
> -                       cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
> +                       cifs_dbg(VFS, "%s: error %d getting sec desc\n",
>                                  __func__, rc);
>                 } else {
>                         if (value) {
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
