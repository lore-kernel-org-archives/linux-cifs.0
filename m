Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2C0436BCC
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 22:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377236; cv=pass; b=Cvxois8z9SBPR2Aco5fdztFjICtts9CtiC53W6Co4DBch6sLvKmBiv1wOLu+o1dwjmvqlVHCiy4FRhTzON97Izy3tua4V2BNBGitB4cK2wCwSV0AfVb+45aTuJKRIS8H2RIHzRlqeZ0zdZKs1a52Zr1Wyx7kGqNjX4aA1Seal6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377236; c=relaxed/simple;
	bh=l6BcC6/QeZx7LqCkNScNv8KnHaNyEjz6CKmhIUy+qe4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C8aEJIqZRGMztjDy90Re3KolbF0EioEo7gIE103VMg1YK8xniYuGbaa1rVNHifBYUtsBzuEWN6cxcdm5snpjyq0AG1VGBz6AvFK53yQwZ6AnDK7NAeXMV3ts1ixhhfjKiX+62FGbhfC8Jj/EsVoSaqXzzr8XDyhEkdc89wjaaMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Opqcyg5z; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Opqcyg5z"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8efcfdb2b43so26383146d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jul 2026 15:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783377234; cv=none;
        d=google.com; s=arc-20260327;
        b=EY+oEXmdaFknsCPEyUMGPBMXH9Bcn84msABydTJ8bwR+ZLcAALBK5GJtz5y5ZtpT3j
         UyNKdA+RETfLzGEK+rb2tGC8IHSiCV4hamKlTJw8RYDw7Pz7f6J5pbF16TXMh+va2zK7
         TIS3tssLqJpc4PDzs/lHZiQfi9xjYGznVh55NjVdB+lXVBzIZwarBfXDBAf4uJI6G0kZ
         g0MFRQGVfddq/+7hcfmZXSUVotpJ1c9eOESdj83W41K5EnFg1B87M5KjrQF6cPeZTHSW
         1Q5ftYAIxDaEVlA5O6k1ztl81DyaUl+yf55dd4u32PX8/H3jFOKXVFk/ih5cED3FnpDH
         ow0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xQJ1Mu1DFNc/AXchvXduSTBSZ3ZxEgilvf1vGjORuCo=;
        fh=zT53YbnAUiWJs0waoT6Ehs9EwFVYA2N7lEfO5TVOXNY=;
        b=qKkoEDINzFm7+qD18h/v7KILUq1Opn+vdA1P5by8pJV98XqfjspTND1hjjDnBwNy1m
         ht+oJC5UjIjwLJ3x9oNSg2bW5rXEw6zRDOzGMfxcrbEisfgsOmXODeACADifWw76LEwh
         EprzsiPyJhwTaZTApZuJhIjxojPGhEiEhmuiy/fvWyVnTVtkcfH7Z9Joipu483AETIRI
         lUxXldywZN8uCmrExKQgHmhSmvTl2kY0xH17gn/xuiMykQRJUjO8wneNNm0Z/g6/RHxn
         WIqgIPxXC6gBWNLpuAsUr68MzWy/QtiTKDjqOq2KCa4XpJWiVvQay1VwPuOfwIjx/rqt
         tiIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783377234; x=1783982034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQJ1Mu1DFNc/AXchvXduSTBSZ3ZxEgilvf1vGjORuCo=;
        b=Opqcyg5zNS+gu5lHAwjdCNc5S1mUXhCrHZxcZuBXwjLcwD6kTDAbfGMZiQS0Rpkpod
         W92Y9khD6kC0FxzLMlzZ6vAP+jnYb3KT8MdJ6rM8uC9xI2KMEm1fIS8ZEgcK5q0TaJWz
         VmbxDVhEvbTszj13GU/JXxYJwduanjHepNv7cIReRkbQNycz0HIiBTD1H0l4uW2RmE14
         BVDXTSuMmlzezsmV7EMB/e4hTvBo8snAZWwTIH577pucS08KAsWZZo9Z0Rzhb9Rx2jYW
         ZSK0EJ3aIT9Y0l9tq8CIeBkzTFiAiWiqM9yaIXmcQpEbbAyEb51Y/286m8UUTt6d0qoV
         mgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783377234; x=1783982034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xQJ1Mu1DFNc/AXchvXduSTBSZ3ZxEgilvf1vGjORuCo=;
        b=g9OryOtsXu0oN9a7MX+nFN1I4Yw9vBlme2TjAzvNvsHVbmJTNWUxhYmdxeXYeJ/5TF
         JsAtqmZoQyxUZDPtO0zc3OKzcXPb1f/B+OxSVzmbGOg2V3o3f40DNTEspO5R0llPnoi3
         kBe2y3Ml+wOqOc8gtMT/onX5CNufCjFCh5UxMZlSsqZcoj/1thTqoqc0cyTN/nXfBZxF
         xHuicaPVuGvjGqVNvcxRDQ/BkZW+mZVv/hoStHnT/7qJ9A88wVAhYD5HGTb3oHTLnPHj
         hTlML72hm/fL7XZnZv4Dpd7Ko+yddCYmAJ+rcff8FF2pjigZsOS8a9Y9H9w5bENIOJYi
         LHtA==
X-Forwarded-Encrypted: i=1; AHgh+RrdwWVw9+T1Z2Ks7YCxFXsKIsQgn77WYxSmiBHRSwbmEBiVcgvYBOPqqmmMQaWfcpbJc8fdGnYKmcfD@vger.kernel.org
X-Gm-Message-State: AOJu0YwHSEWfIRTKyETjHZ4aR0Z8F3NzXi+rbWwWG7pMdI7qbNGaG5Lj
	BE+SEBESjbeQ8KE+dxvDiHcm1vnN7n6cMe52KmNIj3is5/efL2SQHj+0lshhE7xqNDjwZBmUE8M
	7sRjxj8R3uOV7pD+yIc76D4v/sHvNT615vNSu
X-Gm-Gg: AfdE7cmXrIiD7yvVHQiqbvBKgOLtNe3B57jzrGvhj5blL5ShroNKHh6gPSREMTyoOL0
	4mPuUmy4u+YP6IcKxO5+7Jlsms5t+NSz09ulvsSYL4paBto9ZYlS+UhNAkBtR82OFFqQbpbX6Sz
	n4sCcew+qblM5E6nZxEQbJ9lHU4qLNHv8mwcNMrgI7jQB5Ujy4S8EQHn+Lvh5GSE3ObcuJFrcJa
	+tYccErjOmtC6k+RUZ3388TFWetrEzKWIOkfJTKQOTEh1Csn4OVwTZGe6cexFrQ9y17U9ta+aHJ
	eIJKWj4e5CjRZpeEJet1KgJQjdLh85/IeIyzQLET3XB3ONzG94xeXQd7BI/dvIue1vpS3DCz4PX
	+cXplwlJ0VQKdxGUIqbTH4ooOnNNz2Zy8CiK9hywoYgwTobPAxAwVy2g0r5itaH/sMS9GApfug9
	v2lGgwkaM1
X-Received: by 2002:ad4:574a:0:b0:8f0:2dc6:2d88 with SMTP id
 6a1803df08f44-8fcb4b029b4mr30733036d6.28.1783377233858; Mon, 06 Jul 2026
 15:33:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706184819.22124-1-pali@kernel.org> <20260706184819.22124-8-pali@kernel.org>
In-Reply-To: <20260706184819.22124-8-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 6 Jul 2026 17:33:42 -0500
X-Gm-Features: AVVi8Cer5fKREgCjxvscAJfrl8WAhl3eC5F9J_4AQ4g_6lYoq5yuQ1asZ2_Nlwo
Message-ID: <CAH2r5mvHgpVP=CxcBd6iygLzDr5cvvvh9_W7DbxzRJTN6H4FKA@mail.gmail.com>
Subject: Re: [PATCH RESEND 07/11] cifs: Check if server supports EAs before
 trying to set it for WSL
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If this were purely Linux, without this patch what would happen with
creating special files if the server didn't support EAs.  Would some
special files still work?

On Mon, Jul 6, 2026 at 1:52=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> WSL special files store information into EAs. When EAs are not supported
> on the server filesystem then fast fail in mknod_wsl() function.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 99e93b56374f..e2ea59a17c9c 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -668,6 +668,13 @@ static int mknod_wsl(unsigned int xid, struct inode =
*inode,
>         struct kvec reparse_iov, xattr_iov;
>         int rc;
>
> +       /*
> +        * WSL special files store information into EAs. When EAs are not
> +        * supported on the server filesystem then fast fail.
> +        */
> +       if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EX=
TENDED_ATTRIBUTES))
> +               return -EOPNOTSUPP;
> +
>         rc =3D wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse=
_iov);
>         if (rc)
>                 return rc;
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
