Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FB8CA5A
	for <linux-cifs@vger.kernel.org>; Wed, 27 Aug 2025 20:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756325017; cv=none; b=fI7XnQz0AHngj+H/ShmTZCy4nxPuDiNruJwpPgIGFpb3/MhuZ5YLpukoPeE5RLbH2Aezz4vbNfIW+LQvpOXtq1tPys52Cb4MxHISnYc7Zyjr+iYlhV7rVZ7DymcFV5XkQHpFtcND/JaUops0o3wU2l+WQxVrQTV3W2xUxZJY4pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756325017; c=relaxed/simple;
	bh=/uB2rItIahE4Hcta2m8d0v1BW2hpbpgJ9fUR+2xREZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKhnmDqNFZOXSi57FmRVQ64MswaJZTGJL0nbyEV67dm0nLtWIcxUZTtK6zKkFNvhTe8BYFJ4qOx0vVpClDO/gvzyZebYU/1jKQ19bcavvkLXlVtFc6VD7iik2EBhw7nZ9D67knQgM9mmugwzuKIBtv63Q3cBTRJfn9+crVwcSQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cC8QzqzH; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cC8QzqzH"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-70dd5de762cso2809736d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 27 Aug 2025 13:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756325015; x=1756929815; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PbMg2iZBF50w9bvltl4tIdLeh/aZoJYuThqFn7NRr7U=;
        b=cC8QzqzHLa/L9fh3jeZfMxWQIbn+2HZUngbVykdXa5+yNOkBvywjNcf7AEo09gLfWM
         KocWXyV/Wa6Bry/U8r3jzS+7SLTd2fVfbOiJ6BgPKPzYitIi382V2LhjCBVqeNViKHOk
         d0pj+Bey5Gk8ySgvLWIAlThiS2rs3Tq3xfe/HSt6nCrdKjZKlu1C+uCwDj0QxKPfuaEM
         VMkH1erZPrZJozcqbwiSdxv9Nz+DltFEF2uIaqPvvtyTANb3ystkKGYVk1rDQCFf+3PK
         Iv0YYsuEp58oei06Fgnhy9WSgCXk+vwPrh2BFQSeOXyOgKEBZDIuyv2a+jlCTLZjJ5s0
         3itQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756325015; x=1756929815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PbMg2iZBF50w9bvltl4tIdLeh/aZoJYuThqFn7NRr7U=;
        b=YSvgOzQe/RHR69ACL54cL25i9Reo4vUTn4Rq0XsEbFSa8CyyyJkEE1DYvXDpUxAhO0
         y6V48sJPPk+co+OU7NDUHyDUI5fu/zZm2W5r0m/wJKdsLB2rJkH/zmxi7xmwXRc2pIga
         YESO6Ne21v6/8FWgOMw7boyyMo55vBEI5xJm/1SK+nMv6J8c5p2NOitGsVb8cEOZ6/uS
         Oijq+K4+RQtCy2XB2VJn0NAjAj927XIOjCofp0hZF030JlzcAvH93f1S9TuiJyqc//DU
         2lkNGUNqgrlS1HPtaK1yFfVyLx65YICSWvDvGrVU0rgTYQ6+fv1nRUwWOkpc/F4NNffT
         +iBg==
X-Forwarded-Encrypted: i=1; AJvYcCVt1MwsjAJCpPcq4vCJJSyCuOZo1p5h3tOOquwLrL3r1SaYZJCPOOWF/TO0ATwkZrNyuxzNgcdQZKrh@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Uy8ae/aeOSwI7YYlZNQiPXiMZDR1eAK6WX07bHlmed9/Wybt
	i+UkRFeH+p11iB7DzbXWnb2nmU2u4fikOpUZnBIFlmVguSWYyVlSE7yFmUi77QLavnH6/WhKh3a
	Qseer9NeL1hJu2s1yBs9GmayQc2ps7Qw=
X-Gm-Gg: ASbGncvn1XFmLxxlMgBf7uJPHNUGFjwK40Bff/2rMGj23hoQOymsdcpEBezzPjEy6Yp
	KqjME8/VUrLy86yJBDNL7HavTMerKcnXdmI9mRnnTfV86x7i0tgSLI08XDEO3gtmw+/oXdmdvTt
	KzrStvP97Q7ojChZVZkUyoWWBHDQ4BHF3PsFFBVKih4XSOlyaCW9fplqeHopVC4OsIT0U5r855Q
	IVX6FPcwjNIPkeWgRyvZG+2LhC6wWCkDNgxgDJigJ/g2n86qj/iSr3sUxkXZWHSPswBaRXT6t3y
	KKLbcgYx1gtZ9vqx6+tEjw==
X-Google-Smtp-Source: AGHT+IGvR9Gopsnrfnv3RsqoGfwVXlA895U4Bna9kgMu39ZeDGlbhCSyjzjh40Dwdu8dELMXQbQY/g9N4Qw8chD4d1o=
X-Received: by 2002:a05:6214:1cc1:b0:70d:a94f:eb47 with SMTP id
 6a1803df08f44-70da94ff287mr163620996d6.11.1756325013863; Wed, 27 Aug 2025
 13:03:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aK9NPzbY9M_9eKuv@homelab>
In-Reply-To: <aK9NPzbY9M_9eKuv@homelab>
From: Steve French <smfrench@gmail.com>
Date: Wed, 27 Aug 2025 15:03:22 -0500
X-Gm-Features: Ac12FXzT5j85uvaUwuToH9BZp8ybhHwDmgslW2zYSlEpHJUVxteHmRT4WIfmndU
Message-ID: <CAH2r5mvKJyf9JtRRCRB6Y+9y9RDUpoJW9Cgar7Fs9dgO-zwhLg@mail.gmail.com>
Subject: Re: [PATCH] fs/smb: Fix inconsistent refcnt update
To: Shuhao Fu <sfual@cse.ust.hk>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git pending testing (and added Cc:stable and
Acked-by from Paulo)

Let me know if any objections etc

On Wed, Aug 27, 2025 at 1:33=E2=80=AFPM Shuhao Fu <sfual@cse.ust.hk> wrote:
>
> A possible inconsistent update of refcount was identified in `smb2_compou=
nd_op`.
> Such inconsistent update could lead to possible resource leaks.
>
> Why it is a possible bug:
> 1. In the comment section of the function, it clearly states that the
> reference to `cfile` should be dropped after calling this function.
> 2. Every control flow path would check and drop the reference to
> `cfile`, except the patched one.
> 3. Existing callers would not handle refcount update of `cfile` if
> -ENOMEM is returned.
>
> To fix the bug, an extra goto label "out" is added, to make sure that the
> cleanup logic would always be respected. As the problem is caused by the
> allocation failure of `vars`, the cleanup logic between label "finished"
> and "out" can be safely ignored. According to the definition of function
> `is_replayable_error`, the error code of "-ENOMEM" is not recoverable.
> Therefore, the replay logic also gets ignored.
>
> Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
> ---
>  fs/smb/client/smb2inode.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 2a0316c51..31c13fb5b 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -207,8 +207,10 @@ static int smb2_compound_op(const unsigned int xid, =
struct cifs_tcon *tcon,
>         server =3D cifs_pick_channel(ses);
>
>         vars =3D kzalloc(sizeof(*vars), GFP_ATOMIC);
> -       if (vars =3D=3D NULL)
> -               return -ENOMEM;
> +       if (vars =3D=3D NULL) {
> +               rc =3D -ENOMEM;
> +               goto out;
> +       }
>         rqst =3D &vars->rqst[0];
>         rsp_iov =3D &vars->rsp_iov[0];
>
> @@ -864,6 +866,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>             smb2_should_replay(tcon, &retries, &cur_sleep))
>                 goto replay_again;
>
> +out:
>         if (cfile)
>                 cifsFileInfo_put(cfile);
>
> --
> 2.39.5
>
>


--=20
Thanks,

Steve
