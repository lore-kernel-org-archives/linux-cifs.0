Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD6D28B501
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526655; cv=none; b=uHP63+sQAkXygqCiZDBrRA/DVONMg2pCGLHZf2vzZ5L9NqVxWapwhEBRe8ebAwepmFoGgT+ExVcUouIwNEilFAizdN450S6v43rzRO+bv70EALru64U5SBcPVrVrmA/qDmackTCe3NXfH/XqkSG4mJj206iRr8XxFcvRiWAzMhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526655; c=relaxed/simple;
	bh=/TtS0J4xznLpclBPgAFbSJvIC4CdDs5ZoFgTuUAAtQE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iP2CjLBx0Gs6e/cGqwGdh3LKpge8DT068kAOoZqNcsZ0AwI7EaHnR4aUWsl+ZfOS1VFSxHj7an/t9ARiiU02cHSQkhJZWz37P4KMrRj+Xh1D2x3AvLaLXHzWP6HFpE+Vx98CDpkeKfzQ4l8dniD2ry1gmQlsHGVTnNw9c0Nns2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HygAAfpr; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HygAAfpr"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-726e7449186so77070806d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 10:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757526652; x=1758131452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTwv3XYhprTa4qVMJ/iTxMUSJZQ+KtRtBnHhwngabQk=;
        b=HygAAfprCCXanGHyokqIy3CNQxdJGt0B+w2mcmFRliQ6RPdQ+JITccVBr1H19F6IYD
         JVnkKQRgkObK1g5x+emPCfZJCflb6ZmR9XM50+xmD8F/yBUvC+tGoYhDBu9p4QKqO2jy
         8ca3sY0KLYvulX2H6sva1bTafiIpF5oxHBbR+jztvDt7XA51bZmMK2e9bEhtieoU2Mny
         owf42NXJZVE0dtqCeaSIKse6dQvAi/XVk44Dd054jw/FP1aVQPuOrOPsObUNwe7aA+Vu
         RWrtSixM7MjWIVqaBbzwqvQOvrlHgLAD6NZNQG3w2O4H/Gt0M9iQ7IQeBUiUZs+UQ/3F
         d2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757526652; x=1758131452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTwv3XYhprTa4qVMJ/iTxMUSJZQ+KtRtBnHhwngabQk=;
        b=TNnhQZ2OQZNQLLFb/r8GBnsZGY9+YMS6fau2mHqMz72+/2Z4l5jmhzsy3yQ9iDP/eJ
         ftCq64AWFd5PCLcid1lTOPL+zg3+ZmsdVaXf6NlCuERudkzty/XjsxvRvibm+C733UtF
         YGXXE/A7YluwiDBwZPv8M/JKpC4dnEay9P9LRVx/FidGr/6Adh6fq8cl7IZUz7z0dzMd
         PwPohV4J2xGFgves56Y4mxkLlMSKvuRJo8G4G5gfceqwGhtIQDMIMYWKQMBdMAvAV4Jn
         OfqSUq8QUl3ScYxtJ2Lm9ezIDGrUYR0sq3K3WghlyoYhcCLwWjof1NtTt/SYvmyURd0l
         WJZg==
X-Forwarded-Encrypted: i=1; AJvYcCVSAbD9Lr9NDz0t7svqvyK3MxNKhIxhSKp/ZFSQLwVj5fOb3NkenUzsKe8KEOj7B2xfD0cyaW6TPH2N@vger.kernel.org
X-Gm-Message-State: AOJu0YzPYyh2Vx5ISdhCefiOgmYaJeVfMma74UVk8Lx23kKdYgxzagRn
	d4siW7dYDtmCMuSyarqLkzIy/fWcJkQiXGwCfD7LbUIHAaddwvsAz9D7eqkFi7oq6l+24LVoHGj
	ZPsSC7HIf7mW5I62SXgdXh5kr32aBv78GQ6K3
X-Gm-Gg: ASbGncv5V3pOGIES7nmzxh5mEXUNObmZHdFUfZaHh5ska7caYcG1tcRSuE4TFwd6z6f
	uBMFAH2AwseNGiPfI2NpSiAAlX9PEurNXSzqJvCVqnIjpW3wJPY0PeAH6o2Cgsvz73xPrVnZwfc
	GsVg5NY35A/7KPlUrwCgSBQi1G4O2zZvebBpYVAZ/pAj1Ml2NJD6svWd4IjyiZsJ8RPZuUQiZoD
	AM3GAdkWO1gLxpmYk/KdhbnFYbaCRRXllv0I7Ezq8Ps8b2eD161kr4/m20Mo2h8EfzHyWJppLSl
	COTq5FPMOxfVdGmEzxXRTLn2ZsRevBfq0gtaW4dr0dIQABElYydg0UcM1LYOLAf/4Ito3zQFr54
	s
X-Google-Smtp-Source: AGHT+IEV6qMqq9sBczaxOaO5vNA0hm7rCT4n0cUmYbS9rljxIoL3T2e2xjDjXkEvdFiJ0AccAkamo2M0pIiIpSpwJGM=
X-Received: by 2002:a05:6214:4c46:b0:747:3c06:64ce with SMTP id
 6a1803df08f44-7473c0667d8mr134345916d6.22.1757526652180; Wed, 10 Sep 2025
 10:50:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250909202749.2443617-1-henrique.carvalho@suse.com>
In-Reply-To: <20250909202749.2443617-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 10 Sep 2025 12:50:39 -0500
X-Gm-Features: AS18NWBudkT8ml8u0Wv40h0sw_Ap7w8AQtDZ4f28xcEcjeM2JyoeBUjX4qOnML4
Message-ID: <CAH2r5ms_Nr0qt=Ntg4dBNXxrPhCNdKPg5qWW1BhBkt281fw2yQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: skip cifs_lookup on mkdir
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Interesting that running with three of your patches, I no longer see
the failure in generic/637 (dir lease related file contents bug) but I
do see two unexpected failures in generic/005 and generic/586:

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/=
builds/116

e.g.

generic/005 5s ... - output mismatch (see
/data/xfstests-dev/results//smb21/generic/005.out.bad)
    --- tests/generic/005.out 2024-05-15 02:56:10.033955659 -0500
    +++ /data/xfstests-dev/results//smb21/generic/005.out.bad
2025-09-10 08:33:45.271123450 -0500
    @@ -1,8 +1,51 @@
     QA output created by 005
    +ln: failed to create symbolic link 'symlink_00': No such file or direc=
tory
    +ln: failed to create symbolic link 'symlink_01': No such file or direc=
tory
    +ln: failed to create symbolic link 'symlink_02': No such file or direc=
tory
    +ln: failed to create symbolic link 'symlink_03': No such file or direc=
tory
    +ln: failed to create symbolic link 'symlink_04': No such file or direc=
tory
    +ln: failed to create symbolic link 'symlink_05': No such file or direc=
tory

Do you also see these test failures?

On Tue, Sep 9, 2025 at 3:30=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> For mkdir the final component is looked up with LOOKUP_CREATE |
> LOOKUP_EXCL.
>
> We don't need an existence check in mkdir; return NULL and let mkdir
> create or fail with -EEXIST (on STATUS_OBJECT_NAME_COLLISION).
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/dir.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 5223edf6d11a..d26a14ba6d9b 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -684,6 +684,10 @@ cifs_lookup(struct inode *parent_dir_inode, struct d=
entry *direntry,
>         void *page;
>         int retry_count =3D 0;
>
> +       /* if in mkdir, let create path handle it */
> +       if (flags =3D=3D (LOOKUP_CREATE | LOOKUP_EXCL))
> +               return NULL;
> +
>         xid =3D get_xid();
>
>         cifs_dbg(FYI, "parent inode =3D 0x%p name is: %pd and dentry =3D =
0x%p\n",
> --
> 2.50.1
>


--=20
Thanks,

Steve
