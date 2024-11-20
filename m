Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068EB15855C;
	Wed, 20 Nov 2024 20:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732133612; cv=none; b=AGrNSUbxCNefwCLcWWffitnyl/41uRG4XxzS+wVdmEVpRyc85f0FZUVjc47RuBVAftBmWqmTBcIR3z823DTJLXAXCBhXXLYX7J4ZF27Sb+OnuVGJXg5M/7/PQtXDB7N6n7+KVp+X8YEmi/fUW4T+qXDnd5qt1zmvKBQlufDUzCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732133612; c=relaxed/simple;
	bh=t/ik3dHSYxotQNp46eevXQ/BsCREisvE1czclnKcF+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fjt2asgE/GhyIeU1hHpBdwW/u1uCxWr7PV7QFwUt95cwIsyyBMtIJ5rFVPKZN19mDmZaZ206mDsiETLzxRiI7dLVZJxfNZ1QkDe1yrOl7JP2hchsPYFf1JCBFmL1DfoQEXEB1f4cOXSqTO1hlLoIKKKcWidtwZL/WfN5gYFxnPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAIQxp61; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAIQxp61"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539e8607c2aso129592e87.3;
        Wed, 20 Nov 2024 12:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732133609; x=1732738409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBQkKb4gSboV6iKU/oPbGe52ILx+pR9xNlAhFQK8kPk=;
        b=HAIQxp61+yoCf0K4yATvaBlv2lIKAt7Mbe+v0Wk/Rep+aOw9KtkGvPTYOLOOZ/EVMa
         ih5cJXrwA0s59IIDWaHiyWhW2quD4UC6N7h6UMq4zdImAbQ+/NmjyLiie8L+9t/kyw/r
         bdle0tC0MgJ2/yAL3U3W4ir/vxcjoDg3bdLySKISZ4e5OTUUlb4WJ+Xmy54l8LFKaqsF
         XFRUfXFV/KDOuYHD2xi+ASpBfTdTTJaG5irQ6Nno9HmwkLz3IOjXy6LouuyCogz7Gj0p
         2zIYS2R/Mlkel2ZGgMOOTRg8UW61B3HlTJ78OmLwhK4yZXRPwSkcAmUI271Tz2ensqmv
         MYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732133609; x=1732738409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zBQkKb4gSboV6iKU/oPbGe52ILx+pR9xNlAhFQK8kPk=;
        b=UOySZt1kqe+OhsFkPBQb377wOO1VzpOIVeNL8qKRIP7lvvzYPhJZ6TpRJw8Wk2F8kM
         O78oLDsoRjQKM3C/rUPb4tiFvOmiZyb+9biB0YTmH+LJX2s422UaeoGwk2yfPyEF5F75
         HfZZq6A+wgmxaWcDdh+aSTtIANfWgaR4is/ToI1r4DYQdx5eyCl4n4cku72ysqbTvzSt
         4Xz19DoMyQnvbci6MAoS9s/jC55D7OyzYP60lgcYw9kuCzEWNt1b7O/VEQbwehnpgfJg
         elBt0OCb5KgY9vojWKQ9L0MCbzVGJvCIu9HoPs374Fm/T+tMWNfoYmHz3yf43D6FESMK
         ICzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8PMD0KZFGN3RswN0dY8iET2sOpFmxwKFy5bzeYKMsYIHtsUztm460bF+Ba3rU3SqMt95TiAdCkDJMo7Ek6XA=@vger.kernel.org, AJvYcCXOgM9ukhWx8aQTimDjg6GzIEDmHuO0nfVcy9a6R23wZFe4wTIb/6QmB4Ez21hGYdzuyanBS68Rm/02js0Z@vger.kernel.org, AJvYcCXXLygplxH1/ZuNZkE58c93uwa5krVxFcXfesXwNDm3ZtcdrLTqVgVVEcnpzoBBAACEO2Q0P8kUngdMCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgAQbFIBwpPH/lUytlOjPA4J3OznvcigAgTpKPBZ56BNiheUQt
	vUlRHlO32LJBUUH+tryZLlxVv98Vc9PVhIy8oijgYLAXXmZ8mgJs0iRknwg5uxxXObqPQnAzseU
	i12r18/6qmpxIUN3HY+XdlM5wwDA=
X-Gm-Gg: ASbGncsjt2knuLG6RSkYVV+nO/zI/9rGmH0LJCPoyeD9YB+zPQiubwN8wGxcF9N6Y+i
	DjsG9ZFhgXIhYFhHaZnJdN4GXoivVq8GxiOuTNdSm7Dw7F0qBfKdR63yaWmnhcVS8mQ==
X-Google-Smtp-Source: AGHT+IFlFr1JI5HCpNRZOwkeFCqSrWI0luh5NT2gRSmyfWPA36RCIsBljUHjNfK499/nK1PzZHJkhP6c8TKTffzp0TY=
X-Received: by 2002:a05:6512:2316:b0:539:f9b9:e6d2 with SMTP id
 2adb3069b0e04-53dc136715emr2383473e87.35.1732133608822; Wed, 20 Nov 2024
 12:13:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e0addd3d-2687-4619-8f47-4d8ff13950a7@stanley.mountain>
In-Reply-To: <e0addd3d-2687-4619-8f47-4d8ff13950a7@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Wed, 20 Nov 2024 14:13:17 -0600
Message-ID: <CAH2r5mu=8vvqgD0KGb_WVFsP2c1dvOz=ePbWurF3A=AL=nQoWw@mail.gmail.com>
Subject: Re: [PATCH next] smb/client: Prevent error pointer dereference
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Ralph Boehme <slow@samba.org>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, Nov 20, 2024 at 11:18=E2=80=AFAM Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
>
> The cifs_sb_tlink() function can return error pointers, but this code
> dereferences it before checking for error pointers.  Re-order the code
> to fix that.
>
> Fixes: 0f9b6b045bb2 ("fs/smb/client: implement chmod() for SMB3 POSIX Ext=
ensions")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  fs/smb/client/cifsacl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index c68ad526a4de..ba79aa2107cc 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -1592,14 +1592,16 @@ id_mode_to_cifs_acl(struct inode *inode, const ch=
ar *path, __u64 *pnmode,
>         struct smb_ntsd *pntsd =3D NULL; /* acl obtained from server */
>         struct smb_ntsd *pnntsd =3D NULL; /* modified acl to be sent to s=
erver */
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> -       struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> +       struct tcon_link *tlink;
>         struct smb_version_operations *ops;
>         bool mode_from_sid, id_from_sid;
> -       bool posix =3D tlink_tcon(tlink)->posix_extensions;
>         const u32 info =3D 0;
> +       bool posix;
>
> +       tlink =3D cifs_sb_tlink(cifs_sb);
>         if (IS_ERR(tlink))
>                 return PTR_ERR(tlink);
> +       posix =3D tlink_tcon(tlink)->posix_extensions;
>
>         ops =3D tlink_tcon(tlink)->ses->server->ops;
>
> --
> 2.45.2
>
>


--=20
Thanks,

Steve
