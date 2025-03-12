Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF9252907
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741793586; cv=none; b=XZFwlK2Hfku8vYfrE/aBPsae82sXOcvI4D3HQf/g2GOxNh6JBv63sAM6H2w8lTM3jc/FUx7IE9gPgASNRelsC0de0a6zk068CLhP2K2JpSN1hvx81DlMotgJk9oVFV56QcSv6XQa755Vup82x23Qc8MvbxGJo7PUTY5BWvlbQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741793586; c=relaxed/simple;
	bh=dyO+83zAMiA9tJ6lbWkCUKvAFsZJS9tYPBpkQW1Tc/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AFr6R1pqPENWJwSBLanbasRMunPpZMjFFqDUVJj5uAvRyOICzR8tpxgA6tWzO46vewHPAR22td1DaXLdj+AgkWQKTrq/5fJVxZuJ00kqTPQQEULsUHWbM+HXLNwMhv9XIVpZi6Jo1FilTz/TUZO/ylOS5g5XmxJlipsFc+sq0/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DECLsdVx; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DECLsdVx"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-549a4a4400aso3968035e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 08:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741793582; x=1742398382; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKfINbpB1rxmIrjDieV8VN4ZAdNGNE8OTWoDBMLjSAs=;
        b=DECLsdVxW/EZymLgUA7T2eh8kxXDwPOWXusbqvk8VdD59/Av7JkZ6z9APWZwa83i8f
         DtpmZD+zDCG6Jl0biLtLJb0C/uNi0MqfWfYoAWL80g1ztji9GYOZYPLC5YGXJyZhlZLy
         TA5GTHOZOVKz0nUzlHvEJAjvxCKvW/HOiIdeizc6OnyVz/W7MaqKN6pvKPmFUsVjZLlc
         c1F8hytTklFNXxh6AfCw1b+iJQWJbN7CuI/adqtsD7IpBPZVyvwfE0/mF7zaHmk2a5Y0
         AAAPSrMdlS3PWvJiF17yAhPqZLEBvTIT/ZiFAYHHWohJ39Wq2KVMsvsYCNkLjPxjbxhu
         AkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741793582; x=1742398382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wKfINbpB1rxmIrjDieV8VN4ZAdNGNE8OTWoDBMLjSAs=;
        b=VUzxG7TNxdwz5vWDA1QI7ZCdIWHv+YLgKVFUo5c5+RRiBVrfmpo1yOlgWC/cCsXDsm
         yoDddvRP6OkknqrJs/Xg7DtnTg/lG1SJppV8oy1mXCRit57OQ5DHy6yHpg1byi8IQwFN
         ytIhRXx6qrV9OQoX4ZS/jz12DR+HUXj1r3ihsS92BQiAgnUSTFrqbgBo6kL4p+z8E8VT
         rsgaGKxM4a6ja219s5dBW9dX29QbSZ7bYO1fPHe+1lZntDfmAAGWAX8SfYvFivAxyA4L
         cXKSPOde7yszn9i7dH4W1N+FRmzllidT7WcJlqfT5y2wvJh79vq/DoDje/AfbVgJk21q
         7Ang==
X-Gm-Message-State: AOJu0YxqROWtT6jAhbKmQejAXbk1NbCTS6G1w65ge0bzfc0SnYJLQzso
	SSTytyl+W4sd1/SczjQRjmTd2N1aPqG1g/kAE0ICn3UrAwbAUODh0/aULv9gpDpdHHTUKtwlz4q
	oVfbEzYF2N0ABPH+gD982NEwRexo=
X-Gm-Gg: ASbGncvIQhZGdbgyzwkYAkkcci1O8m2IyEbq3m6NNcMdtVCwi/4M22zrY504DieZXBM
	XsPb7gk79vNzSo9WyRITmHrlRbdlwk3GjInz/z6T7MnIHflFkFH42RH/dUvVl0SgO+5q6eHdcZf
	iWRL9Gv4Qv5aQnwso4moZFtSqIdDnTOkzOAgeI7ZEE6vP88VQJMT+dKnj7Uz2UJnA00+5Ep5g=
X-Google-Smtp-Source: AGHT+IGewnsJFOKvCEySfwSuGsw7TkwuLDqaTTKWVOAZLdVsalcsnasgUAlNUTRMYWpyvYJq/hrL9pRP6ofs8/Sm4oU=
X-Received: by 2002:a05:6512:31d2:b0:549:5822:c334 with SMTP id
 2adb3069b0e04-549abaed778mr2982266e87.52.1741793581848; Wed, 12 Mar 2025
 08:33:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250312135131.628756-1-pc@manguebit.com>
In-Reply-To: <20250312135131.628756-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 12 Mar 2025 10:32:49 -0500
X-Gm-Features: AQ5f1JrheQc-RsVKaS7sAP56E3rNdJs98f7L01PEIUPbqP-bO20PX21fRSayX9w
Message-ID: <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix regression with guest option
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Adam Williamson <awilliam@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing/review

Presumably we could also update cifs-utils (mount.cifs.c) to
workaround this as well.  Thoughts?

On Wed, Mar 12, 2025 at 8:51=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> When mounting a CIFS share with 'guest' mount option, mount.cifs(8)
> will set empty password=3D and password2=3D options.  Currently we only
> handle empty strings from user=3D and password=3D options, so the mount
> will fail with
>
>         cifs: Bad value for 'password2'
>
> Fix this by handling empty string from password2=3D option as well.
>
> Link: https://bbs.archlinux.org/viewtopic.php?id=3D303927
> Reported-by: Adam Williamson <awilliam@redhat.com>
> Closes: https://lore.kernel.org/r/83c00b5fea81c07f6897a5dd3ef50fd3b290f56=
c.camel@redhat.com
> Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changing o=
n the server by allowing password rotation")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/fs_context.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index da5973c228ed..8c73d4d60d1a 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -171,6 +171,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] =
=3D {
>         fsparam_string("username", Opt_user),
>         fsparam_string("pass", Opt_pass),
>         fsparam_string("password", Opt_pass),
> +       fsparam_string("pass2", Opt_pass2),
>         fsparam_string("password2", Opt_pass2),
>         fsparam_string("ip", Opt_ip),
>         fsparam_string("addr", Opt_ip),
> @@ -1131,6 +1132,9 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>                 } else if (!strcmp("user", param->key) || !strcmp("userna=
me", param->key)) {
>                         skip_parsing =3D true;
>                         opt =3D Opt_user;
> +               } else if (!strcmp("pass2", param->key) || !strcmp("passw=
ord2", param->key)) {
> +                       skip_parsing =3D true;
> +                       opt =3D Opt_pass2;
>                 }
>         }
>
> --
> 2.48.1
>


--=20
Thanks,

Steve
