Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4325D33E7
	for <linux-cifs@vger.kernel.org>; Fri,  7 Feb 2025 19:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738955409; cv=none; b=plhdhYkLsfQXkYIB3GfBHPAQUxLQ3HRKVgoZTVDm+XWO1Mt4B5okI8yJ0mAsDUQE/eUjq6/0aYsxpVfyTFvXC2cEtxPWVwJfy+DERJU3kGV391v+1aehW+jZgvknb5LpYUKkrIDL0WF6enR990zDc3rBgz4mQ8iKkl/sRmtZBD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738955409; c=relaxed/simple;
	bh=L3hBF+iQrBKTRIa3wKiXJJ/OQyIh4KsyTMz0Xy+5S4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sTe7Z7cuK+4KUHt3OESg7v/3lEGFHTRIdif3iEXtyZRZmceZL7kQzLT1KxhHz98NWQvXDniTbxjytoGUotSLHPlxWxC4s5eRLmrD9J7Me1Ow3nfFmGE+3kDpmPZQ9CYHZttWEF/0vyII8FP/hHhH7Emb+mBXSrzAqPA2AYs+SzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GKim8lt4; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GKim8lt4"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6f9625c0fccso23789587b3.1
        for <linux-cifs@vger.kernel.org>; Fri, 07 Feb 2025 11:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1738955406; x=1739560206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Om2VSE738EF+Gy11pRhlx9VqvfBmWOXzuPiTJvCwuz4=;
        b=GKim8lt4SXP5kCoh/4cTxGCOS0NFKc37s/H8tESJs+gNOMv7ToQFj9aCC6gXDOyZFW
         HLxSttUGftYuYAnyZLRg40Zjxvlf+AWJp8XZhkFbbWk1U2XHw2B6BMJCaOy4FE3fPdpW
         Unfpfmv2KhLrQ0n6jpymXy/CUq2x15XKxIBQ0mhxWAURjkNVKfJwfsEDRlZ88+bThbLy
         S7h6oS6qz2gkxd30lZv9rMUCNFRCH6fquC2+bZCWmiLNNARvDStxMgbCi1NfsA9chIbC
         +jyROlyUVDutZjFEJL45IVc2NMcmVq07hYptArEUCcGxbrzeWHvGJD2J5f1lTQrXqPxp
         7fhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738955406; x=1739560206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Om2VSE738EF+Gy11pRhlx9VqvfBmWOXzuPiTJvCwuz4=;
        b=e3ZNNa/jzzlG+QEm5a7NeW4uh4AhO62xNwAxKddsJxUqjepwUUdRjoodqatydaTnkT
         J6zRVvtRk8HJ6xW0nky0Y64BSqNPnQpA8+RT65cvnDijljHfa2S1VDSKuaTsk4a+DmZB
         EJpvhTnetAxI04cpHHW2qBspfYQI/WeivsNhjHabhi0tSv12aIwdQ+iDTOyX9s2lDj8a
         yAHBGakYbp6NDKe4UhTOzJMmwFcxB39GGqx3IGHJf4L6+otuN7GI7G5ST22SU1ldU7dh
         TBRA1sQOVtU6DBx5ABr4z/UDX53zJ7ZHtyPsxhEbCu5SZLR/LujI3iwS4Ju8bxXSacSS
         iqBA==
X-Forwarded-Encrypted: i=1; AJvYcCVhKqOc2BsU+IIwmCXJRd8RB4+lCQVK+Q5Tvd5AC/cmveQzuRJagtby5N8pryX14JyoW5Ev9c7CVzny@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7KvDEUQjXJHiPuSqGasWeSdPX/XaJkpt8k88bAI/AHRU3KyMW
	By2R86gIVja5qLrV36RX4py0uRCmTh87U+KvDsvFrJlN3QEUWRMxh2BN7ALrp5KnoFdAFZs8mxs
	p1RZHKGPbVKkPARmv4B9fhffwIOCwdnv5YkTL
X-Gm-Gg: ASbGncvP9Mb7/d0z3dJSkKcnGLClmWB2qKeAs9t3Ej9lsJfQY+s0RHOmhOkmq6fenHX
	+H4FSmYRa2oOBxcvNKB1rRuQ8vhXXtPN1sAqT7v+JfviJ4EA/FzWpEEqHI+GAdmNqdExO9I8=
X-Google-Smtp-Source: AGHT+IGK+1YaMF/yB5tZ88LHxwIuQM3/Gj8AOscWWTmOeYR+q9GoKPuGwr2TcabPJS4LqujSyvfXsbiPIUAyuUzPzSo=
X-Received: by 2002:a05:690c:3804:b0:6f9:97bd:5a63 with SMTP id
 00721157ae682-6f9b2844e3cmr39923927b3.4.1738955406214; Fri, 07 Feb 2025
 11:10:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250207034040.3402438-1-neilb@suse.de> <20250207034040.3402438-2-neilb@suse.de>
In-Reply-To: <20250207034040.3402438-2-neilb@suse.de>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 7 Feb 2025 14:09:55 -0500
X-Gm-Features: AWEUYZl_WdQaatK919wx4Q8t6Nn6ccb6OCvCp4tV_BELcL0JYxwXteOCsEvAF2g
Message-ID: <CAHC9VhTnVg-5C75qY8NkfKs4tjbVz62Vk=SVXS2mwH0f3ftLhQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] VFS: change kern_path_locked() and
 user_path_locked_at() to never return negative dentry
To: NeilBrown <neilb@suse.de>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 10:41=E2=80=AFPM NeilBrown <neilb@suse.de> wrote:
>
> No callers of kern_path_locked() or user_path_locked_at() want a
> negative dentry.  So change them to return -ENOENT instead.  This
> simplifies callers.
>
> This results in a subtle change to bcachefs in that an ioctl will now
> return -ENOENT in preference to -EXDEV.  I believe this restores the
> behaviour to what it was prior to
>  Commit bbe6a7c899e7 ("bch2_ioctl_subvolume_destroy(): fix locking")
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/base/devtmpfs.c | 65 +++++++++++++++++++----------------------
>  fs/bcachefs/fs-ioctl.c  |  4 ---
>  fs/namei.c              |  4 +++
>  kernel/audit_watch.c    | 12 ++++----
>  4 files changed, 40 insertions(+), 45 deletions(-)

...

> diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
> index 7f358740e958..e3130675ee6b 100644
> --- a/kernel/audit_watch.c
> +++ b/kernel/audit_watch.c
> @@ -350,11 +350,10 @@ static int audit_get_nd(struct audit_watch *watch, =
struct path *parent)
>         struct dentry *d =3D kern_path_locked(watch->path, parent);
>         if (IS_ERR(d))
>                 return PTR_ERR(d);
> -       if (d_is_positive(d)) {
> -               /* update watch filter fields */
> -               watch->dev =3D d->d_sb->s_dev;
> -               watch->ino =3D d_backing_inode(d)->i_ino;
> -       }
> +       /* update watch filter fields */
> +       watch->dev =3D d->d_sb->s_dev;
> +       watch->ino =3D d_backing_inode(d)->i_ino;
> +
>         inode_unlock(d_backing_inode(parent->dentry));
>         dput(d);
>         return 0;
> @@ -419,7 +418,7 @@ int audit_add_watch(struct audit_krule *krule, struct=
 list_head **list)
>         /* caller expects mutex locked */
>         mutex_lock(&audit_filter_mutex);
>
> -       if (ret) {
> +       if (ret && ret !=3D -ENOENT) {
>                 audit_put_watch(watch);
>                 return ret;
>         }
> @@ -438,6 +437,7 @@ int audit_add_watch(struct audit_krule *krule, struct=
 list_head **list)
>
>         h =3D audit_hash_ino((u32)watch->ino);
>         *list =3D &audit_inode_hash[h];
> +       ret =3D 0;

If you have to respin this patch for any reason I'd prefer to move the
'ret =3D 0' up to just after the if block you're modifying in the chunk
above, but that's a trivial nitpick so please don't respin only for
that.  Otherwise it looks fine to me from an audit perspective.

Acked-by: Paul Moore <paul@paul-moore.com> (Audit)

>  error:
>         path_put(&parent_path);
>         audit_put_watch(watch);
> --
> 2.47.1

--=20
paul-moore.com
