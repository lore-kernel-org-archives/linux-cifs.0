Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciMgopKP"
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B21BD3
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 19:13:22 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-50be3eed85aso5578466e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 05 Dec 2023 19:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701832401; x=1702437201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEdVIhPU3tRRprFkip8dx4oqjZUTV87k0wbpNF7BHt4=;
        b=ciMgopKPBl4B78gXDAwfmWWptBsAE5Lma0dzO7NayeOI1ulsaoyS/EdLGY4SB1cAz6
         BuKENJj2iYQ+NjWHbUgs+9tJLMpNa48Va6JNpiASH8BPtn5D5gdWWGvp+/GrST4o6hMz
         A5KtYhyuvenqQe67CkDs90zvHA9zVPoVgXjxT/FZHrhzNAvXq4fa9vGe43OXZgEIFrht
         VIUgL8cC3ugErBfUR9JsfeKAzfEY0QfCELVeXqLpf3tVzU9Sc3hePEXLIKUoGY+wUL6d
         ord33DLiLUK3hUxGUYX+g7bComvFn6nIQEUV33NJ5pLiPS5oWZt4FnzhjXtDEK6WzvXh
         hFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701832401; x=1702437201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qEdVIhPU3tRRprFkip8dx4oqjZUTV87k0wbpNF7BHt4=;
        b=AdaIrh40lbc0RkwnkAMo/bc2sQqlfuaJvyzwWUJ5jV8sVCpATecxoAWkuAo1N2N3nc
         bo6zmVgVe3IE+ipNPvCGkudUmLDaMhIF2vhWAPrQpGZWvxP1ZX0I+cUlS62SqtKCzJde
         B+J392SfI0acAQEki/3fBehnrCy78/zZcxUv17O8xFy39WPxBWm7dkw0H+1UJoBlyCGp
         FQT64g4m7nBnsp2RnmA+Snqz32L/EwyyaPKhggiYZ9jjyvs8WumYotAA2QRoWxPky/mB
         ZZimRz20FMEXN6Vp3qAjCJZCQeJR8wMhRr2hAgUh60DuIZTGAZx2CRmPApz3q6PGJsM6
         68OQ==
X-Gm-Message-State: AOJu0YyAUv8FTdwHFikYfKYjstwE6xZgdXfrwljDIW7QILWFOhcY9cK+
	UAfJi6rAsZXLaiTwQDpC8sQeNbc3bbPZUxG6pSHQdxn9iyc=
X-Google-Smtp-Source: AGHT+IF0elH7oHF+tCg9oeq9y85ORxfjXKU3XZxUhjGaaYtoWIsJZe5RpYflnMeGQP3wDXoQRsoeYatomdGwawuB7as=
X-Received: by 2002:a19:f618:0:b0:50c:a39:ee2a with SMTP id
 x24-20020a19f618000000b0050c0a39ee2amr119656lfe.55.1701832400564; Tue, 05 Dec
 2023 19:13:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206004929.8199-1-pc@manguebit.com>
In-Reply-To: <20231206004929.8199-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 5 Dec 2023 21:13:09 -0600
Message-ID: <CAH2r5mv88oASPWSak420j7h5C4bvRjeZaaoY8UkzLeRbKoHNZg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix potential NULL deref in parse_dfs_referrals()
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Robert Morris <rtm@csail.mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated cifs-2.6.git for-next (and added Cc: stable) with this patch

On Tue, Dec 5, 2023 at 6:50=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> If server returned no data for FSCTL_DFS_GET_REFERRALS, @dfs_rsp will
> remain NULL and then parse_dfs_referrals() will dereference it.
>
> Fix this by returning -EIO when no output data is returned.
>
> Besides, we can't fix it in SMB2_ioctl() as some FSCTLs are allowed to
> return no data as per MS-SMB2 2.2.32.
>
> Fixes: 9d49640a21bf ("CIFS: implement get_dfs_refer for SMB2+")
> Reported-by: Robert Morris <rtm@csail.mit.edu>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2ops.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 45931115f475..fcfb6566b899 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2836,6 +2836,8 @@ smb2_get_dfs_refer(const unsigned int xid, struct c=
ifs_ses *ses,
>                 usleep_range(512, 2048);
>         } while (++retry_count < 5);
>
> +       if (!rc && !dfs_rsp)
> +               rc =3D -EIO;
>         if (rc) {
>                 if (!is_retryable_error(rc) && rc !=3D -ENOENT && rc !=3D=
 -EOPNOTSUPP)
>                         cifs_tcon_dbg(VFS, "%s: ioctl error: rc=3D%d\n", =
__func__, rc);
> --
> 2.43.0
>


--=20
Thanks,

Steve
