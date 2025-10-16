Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4E194137
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 03:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760584338; cv=none; b=bOjxDPxtTbWKUEi7Y0PkJbyN3gQn9Vf9jmyjXkCjlzoCg/EQ+2PnPk7Un9GEPjZYUM3ujUkc9wLQ6ud/zevKhp+uJncT5/bnf8Bmycg9nNrYefDXaQOwwxCog6CNWaqa5BXuoOSVux9K9BU1FWRBvo27JTtgg5LbVhGczlz3PcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760584338; c=relaxed/simple;
	bh=FosbK3+mmiDc/+/euP2ZG1JXUgsZmpul+xmFj7RybeA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S/CALah3ECUl1fCCJUCr/wmGl0WG5VNgE5yug2yT6gm/WRIvZGL/iy/saXQHqDOeFJRHSv6xJnlMt14XO9QoCga4KFvOsp3aMacAVDdvAQY/1HbZDj2lEJ7uy2EwVYD5DqimbnGw1UbNFOLAeZXPpXW2mH301l2aXoH/XJ+ihgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cJ7oGRTY; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cJ7oGRTY"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-78ea15d3489so3483346d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 20:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760584336; x=1761189136; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEQXE06caMZeo5HYZoW0oDsuziZc3EuBAg1B8KF+blo=;
        b=cJ7oGRTYNYGo5taJhWyHlc73SKlNUgzpt5NlWHKnmoR/5tTokmNOxmo0uLhJUqp2Yi
         kOpH35ZVswLp3UfmTknl1SF38mDMfZ39a+5mBRNzhBmAViNW22ZNFYZ3TQVr8LtHRQX3
         pIsetqOXKwV91WMYzrgPrY4IwDtDydPnt6lRq+FIjynyFoePHYzAKA85WMzETo6Uttqw
         0jKpcSnyLPNwCY0vT5iILtjSr/kR3eILUSGF/Xztm7Yzxl4uA07vlsFiKvpVdE54VlY9
         AsaiJUX7RoUhQehpv2BZJgEhuxMfIQrUzvjzpxj0gogVPL/8yBKN9Bq2+LauRl52dY9h
         qUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760584336; x=1761189136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEQXE06caMZeo5HYZoW0oDsuziZc3EuBAg1B8KF+blo=;
        b=Cpxuw01tsNFpDZzzaXexTqQcx8V9/8cQmnLB1W9ekNbjp+1IWVMM7f4rBswmyrKcEC
         uhc8PrHP1i4ugzMLN5a9rFH84JvGWhpDK4UA8awvttHz3wLDhpu1Er8tVOyLsyZ606I3
         +cj9vI6nGz7XB9f09Di7VeC19GcVxOyttxOXHGWo9n7gBPtJdQ7GV70POxk7dpSnpR43
         rY9RK7DFN0j0usuJfZs3iyfdYCh0PZ0sZiwTjRocmF9+lxgNClegVXrlKBK+0IsqhadC
         NPcWE19teV9a1VPUL/7kIKJDyzHpNj3aOZvIMa29WQvAcOGYoEFE4gOI4sgTwvZsjlWA
         f6Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWuz3aqyN232U5S6/vCFmUtFpS/Vig41IfbnbjIqkTqzGsO/0747KfrnhjPa6kUJDFNSVQFVq6q02KD@vger.kernel.org
X-Gm-Message-State: AOJu0YySDlaHuKnxmEQt5DhH1bH1D1bAZikjjHJkiOUZvnl8SZjtWYdY
	f1l93is46ruAfo5mqwd7WEXfTSi2Mjw6tqc48Kufev8JDKEXTJ+EM27xsXEr5RxVgKLHIpmijfC
	BuI+tWuI/q7ZKBM5Qvkt+U8Z4zpKXy3c=
X-Gm-Gg: ASbGncvP8mZxByj8SILIwF4JoEAf4p5dDePptBxwUNSA3DyRP3jHVQqwA5PGkc4Xhkd
	20dfu8Kjp8aw/flTi7lvKZO7whLLGvQKzgl3hpaIjS4fDuCnLgc9ORRsMEpNuJqHbjn4UsHq3c7
	JGvey/XKFW2FCDFA69Y5dchC7nDk8/uvXrVRH6pMn5CHXE5BvB9z7T082mIDuLL9Ti0YIVa/8oB
	kJHbJodVF7Yusu+FJRMcChnRr7dNzuv+e85l8rMwyGMxR/zBUlm2K1fQ1SZ/OjDperaR3pS/cVf
	7ChU85xUAseuwSVnTAlJY2TOX6YBPoCPwZLTYlOvopZ4Wca840yKYEO3Aw84pGV2Ohu56lYvz0X
	+3loAyi4MVdlTHtFOzorV2b8K6GLVqUZeZG7mgWGSE8QbwWwXy+tft6i1thtb6fiFAFy9vnVq99
	Ib2/5pVQKEVg==
X-Google-Smtp-Source: AGHT+IGAmXUQRmwsgVDvQbYvXojEsX7CJBtDld+dU6Sg9MvBtBJilFj4HbmhNlkERWRbsuIYDiCI/jX/pZLNTYS90MU=
X-Received: by 2002:ad4:5f89:0:b0:87c:b8f:f4f7 with SMTP id
 6a1803df08f44-87c0b8ff74amr32437746d6.29.1760584335852; Wed, 15 Oct 2025
 20:12:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aPBeBxTQLeyFl4mx@chcpu18>
In-Reply-To: <aPBeBxTQLeyFl4mx@chcpu18>
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 Oct 2025 22:12:03 -0500
X-Gm-Features: AS18NWAEyWCeaVPeoVcoBEQpSJ9u0N2hnfc_WhSXLkxKfJqq1sbEBlBaJtOWFjY
Message-ID: <CAH2r5mtNVsFcMsW+=jdw4=hc4rssca-0fWMg4uhipBbuHnQ9GQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: Fix refcount leak for cifs_sb_tlink
To: Shuhao Fu <sfual@cse.ust.hk>
Cc: Steve French <sfrench@samba.org>, Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated the patch in cifs-2.6.git for-next

On Wed, Oct 15, 2025 at 9:53=E2=80=AFPM Shuhao Fu <sfual@cse.ust.hk> wrote:
>
> Fix three refcount inconsistency issues related to `cifs_sb_tlink`.
>
> Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be
> called after successful calls to `cifs_sb_tlink()`. Three calls fail to
> update refcount accordingly, leading to possible resource leaks.
>
> Fixes: 8ceb98437946 ("CIFS: Move rename to ops struct")
> Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getac=
l functions")
> Fixes: 366ed846df60 ("cifs: Use smb 2 - 3 and cifsacl mount options setac=
l function")
> Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
> ---
> Change in v2:
> 1. improved patch wording
> 2. nicer goto label naming
>
> Link to v1: https://lore.kernel.org/linux-cifs/aOzRF9JB9VkBKapw@osx.local=
/
> ---
>  fs/smb/client/inode.c   | 6 ++++--
>  fs/smb/client/smb2ops.c | 8 ++++----
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 239dd84a3..098a79b7a 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2431,8 +2431,10 @@ cifs_do_rename(const unsigned int xid, struct dent=
ry *from_dentry,
>         tcon =3D tlink_tcon(tlink);
>         server =3D tcon->ses->server;
>
> -       if (!server->ops->rename)
> -               return -ENOSYS;
> +       if (!server->ops->rename) {
> +               rc =3D -ENOSYS;
> +               goto do_rename_exit;
> +       }
>
>         /* try path-based rename first */
>         rc =3D server->ops->rename(xid, tcon, from_dentry,
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 7c392cf59..00b3f769e 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3212,8 +3212,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
>         utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
>         if (!utf16_path) {
>                 rc =3D -ENOMEM;
> -               free_xid(xid);
> -               return ERR_PTR(rc);
> +               goto put_tlink;
>         }
>
>         oparms =3D (struct cifs_open_parms) {
> @@ -3245,6 +3244,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
>         }
>
> +put_tlink:
>         cifs_put_tlink(tlink);
>         free_xid(xid);
>
> @@ -3285,8 +3285,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
>         utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
>         if (!utf16_path) {
>                 rc =3D -ENOMEM;
> -               free_xid(xid);
> -               return rc;
> +               goto put_tlink;
>         }
>
>         oparms =3D (struct cifs_open_parms) {
> @@ -3307,6 +3306,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
>         }
>
> +put_tlink:
>         cifs_put_tlink(tlink);
>         free_xid(xid);
>         return rc;
> --
> 2.39.5 (Apple Git-154)
>
>


--=20
Thanks,

Steve
