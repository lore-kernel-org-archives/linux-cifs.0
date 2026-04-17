Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95203BA21
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 01:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776389861; cv=pass; b=kSOZGFwSqWT57BXkjkQFeIm2mxV0g4VhuquEjAkGs3X/gdoWRfYLbLbZ7sKQ17cHa6Evr0GPQAL/WHwgOkFtyucJ1OoyeCBXdYMsncRiGizZIqu3Bs/afNBj8OdeZ2FR02NjJEewDRi25WslW/d/Ollej6fbrL6gOfE8TrA5xKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776389861; c=relaxed/simple;
	bh=c8ZBS+V8jEtDvPVR1JijwtduvD5q8yXfJTgYKDWL6rA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eXay6BRLyleh2tHGyvJsA2CVOnz8uYvzK63qaZhM2PbI1x3KCnQxSPmmNfo5FUqovvIZm2JlldftotmQ7lKGzkHPG9fvgAQm+m3nP8DEvuoW91d1pgPMRPWmGUw8LZGdCZphvIqPHaFJu/6rmGUgt/CDr5Bxe/a7tPDS7C2soRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YNO0aZ7B; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNO0aZ7B"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a068db9989so12215106d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 18:37:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776389859; cv=none;
        d=google.com; s=arc-20240605;
        b=QXcnpJ2h1gblT22awvsfjqQJOsMRTgg7hMzuM6YxsvGMPwu58wLm+XuGc61P6SKMyy
         i6Dne0DPX46TW8QgVFB2d7m76TI6XcO7rZi4iuIIXJ7+PJTGPC6EVSTcpmB1bKBVEVQR
         /6ZYKHx+Bz3ia7hx9vWPU/sYUexiXMvw8q9cx5jzM5YpvXvyyNYsUkwg8zoLDHY9oXsK
         9kBq1LlXb23h3ZQx818PcKWhRpNH0uwgLJ5Ja9PrkfY8V0cZrqs2o7T2f0qBbj4QNgmy
         Zyyp7agK/GRvVT2sbG526fnj7EO2gDWz6JDClYnMXKk+x1Ob2jHBTCAnFPFfSpPaPe7p
         NR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AdTij6DUQxjWdvtMNHhYJ/o6hImRsree6psuIVyyW6Q=;
        fh=WyCtTtAtDDwpHXm+di9GcpEGXwWwv8hmV6qHqsaeuxs=;
        b=Yl3C0TIQSlu16MHqXUgCD3lhdNB+tkj8ZdhbhEpeI4fynsSttPWrrmdCfafXvsQj1s
         p070ImFpUaVcQ2zk/5iCAYtvZbsgcW7f/NO4C/yvH4o6vP2h3mvG2JlasWXS7G2K2rsR
         +LICGugE//9J0LMc5BN+aS1gElSwLYLcc0KahiGU06kKQ9DhsCsdHRP7VaQc1ktT6+27
         1NSTo7Gjv71mJ7BLcH3stD5zlBi3rjKWSzPkYIw6MW0BBhluyF6oxFae7+bUCyv38hq/
         5VZ5wxVaCoxK+PVZBctdzadfvuGy/JPP9lMe0+eosz2Ekc/NQT4BjNxVbhf69UQNrra0
         MYbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776389859; x=1776994659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdTij6DUQxjWdvtMNHhYJ/o6hImRsree6psuIVyyW6Q=;
        b=YNO0aZ7BKl21SLO/YFdlsehEzBtrgzcw4K5vaQwa1Nb3vKnwDpM8anUGliFHnSAc07
         c6fcX4SKo0U+tfvxk+BiG6WoQExLcS1h7Onw9vvXuf9vkOpJD7srYTfdCAT1r17d2WrM
         npIdFOVy7Ql0RLGXalqEPb1sa7mmersHLf9EBF0NDr7gFSy5Q7sOq09q65+fiB0fnHPU
         MaanNS8ciOClCKi3TKOP4N7X+2fvmsiefbWIlt013V7/twPbnx/NlOkYKNXgivjxzDQE
         1L7wR5nICWFPhFeGEpeUPXReoCgjEcGZ/XVepUWmnD/y+ZrMviuV4zpXkoR9ui34NDjx
         64Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776389859; x=1776994659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AdTij6DUQxjWdvtMNHhYJ/o6hImRsree6psuIVyyW6Q=;
        b=CN2oidexCUoaW/04578j2EkJpBVau/9CUdj/mXB3NZAt9LEzJhKk5x6BMbq9CIUk2W
         osMd/9ck5cllkfZIPHTkglYWkVJ2iDJt+NpBfvFCz259+O+q8+bHunQ9sPfIojqGjmI2
         r9fw9JJ/lJfAMbSiXoO9+Fx7dlmQpR890e9peQz1/kiYAeu8R4pE+aDXl6oHuNr6qQ5w
         9gyfiJwHnj8mKFtzkl1CCstoka1aJeEkxUzLeaU13fsSUfUYKG4u1BIe/frOKn1TctfP
         U9mS92pd/eSjfCVKSjP6JMf8vP5lR3df1/TeNfjVU+VG0rkjxTyij3/hssGbzKYHZLo3
         s9MQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Ft3SMgL6Kf93BceWAFeJjFX8/RqMMnHKajirj4+hP4mZJ9iLH7ghwdILelIXIuUjRdjcSlw/Yi5Fw@vger.kernel.org
X-Gm-Message-State: AOJu0YxyLcJzKGhx3OLVrdBr/U8py5wRhuFZgkr5xH+OZ89B1NnK7ND1
	9OElBGGj+v72pP0gLImEpycA+aq51eUO84XqLK/75/0lSaUBq17Isx/IXjwwMCrv+tL1B0tkkW7
	V1jL3LDsFu7JFmV6Ev2y/4vHhpyCAZBU=
X-Gm-Gg: AeBDietvEg5OcJk/kqD1E0QtL6Gui8/WkLPOZTJhP3QMxwInAshDZOWrjd/406SLh2R
	vvfi+fJCAGUXeRhBGfWRxJ9uhkH99pjI2RCYu/t7xvq2K8mNH/NnKyRQv0Vh+1Oi1udG08NwK7E
	n853zK+NmY9gn2VnOk/fCLfof/oXt8ckigilzhPfAXATS5B1YuSYFRA2tz84keohPH0DSYxKSFQ
	obqMSdNvEbp/anc9Yu8hBiXJ7AYtilTRHKlA1YrE35yjB/Uay/4WRLyUYG0Ey6n+KROdGgtf8Fw
	+6PzFB6jO7z5oKfmBKkMYBP2Bp85l97Hqdy88fv6IHVJXdj5lce2L7Nmgy6OyVy/ziEIW5+wRG2
	2IBkrGg4MipAi+Oum+G8crjkkoaCT1vjGiAzx0eQXG35yipsbU76JIamM/N4s4+GObvbA8/Kzoo
	e2dXS/4MbqUVIQSE4Ta9Q3VQbOVHn4jNE=
X-Received: by 2002:a05:6214:459d:b0:8ac:dd87:b5b2 with SMTP id
 6a1803df08f44-8b028449ed8mr12457736d6.11.1776389859572; Thu, 16 Apr 2026
 18:37:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417001550.1301260-1-pc@manguebit.org>
In-Reply-To: <20260417001550.1301260-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Apr 2026 20:37:26 -0500
X-Gm-Features: AQROBzA7pmGYPnGr8dfpwgDqbhVLgCR2YE9UKmwwY9P7HtfxqYl92b86f-VG8E4
Message-ID: <CAH2r5muqeJnStj+0GYJxy-TbaKB4k+zrJraYKobHFUCb0W0caA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix dir separator in SMB1 UNIX mounts
To: Paulo Alcantara <pc@manguebit.org>
Cc: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>, David Howells <dhowells@redhat.com>, 
	linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Thu, Apr 16, 2026 at 7:15=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> When calling cifs_mount_get_tcon() with SMB1 UNIX mounts,
> @cifs_sb->mnt_cifs_flags needs to be read or updated only after
> calling reset_cifs_unix_caps(), otherwise it might end up with missing
> CIFS_MOUNT_POSIXACL and CIFS_MOUNT_POSIX_PATHS bits.
>
> This fixes the wrong dir separator used in paths caused by the missing
> CIFS_MOUNT_POSIX_PATHS bit in cifs_sb_info::mnt_cifs_flags.
>
> Reported-by: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
> Closes: https://lore.kernel.org/r/f758f4ff-4d54-4244-931d-38f469c3ff14@mo=
onlit-rail.com
> Fixes: 4fc3a433c139 ("smb: client: use atomic_t for mnt_cifs_flags")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/connect.c | 10 +++++-----
>  fs/smb/client/smb1ops.c | 19 ++++++++-----------
>  2 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 69b38f0ccf2b..e9eeb9f8a561 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3610,7 +3610,6 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_=
ctx)
>         server =3D mnt_ctx->server;
>         ctx =3D mnt_ctx->fs_ctx;
>         cifs_sb =3D mnt_ctx->cifs_sb;
> -       sbflags =3D cifs_sb_flags(cifs_sb);
>
>         /* search for existing tcon to this server share */
>         tcon =3D cifs_get_tcon(mnt_ctx->ses, ctx);
> @@ -3625,9 +3624,10 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt=
_ctx)
>          * path (i.e., do not remap / and \ and do not map any special ch=
aracters)
>          */
>         if (tcon->posix_extensions) {
> -               sbflags |=3D CIFS_MOUNT_POSIX_PATHS;
> -               sbflags &=3D ~(CIFS_MOUNT_MAP_SFM_CHR |
> -                            CIFS_MOUNT_MAP_SPECIAL_CHR);
> +               atomic_or(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flag=
s);
> +               atomic_andnot(CIFS_MOUNT_MAP_SFM_CHR |
> +                             CIFS_MOUNT_MAP_SPECIAL_CHR,
> +                             &cifs_sb->mnt_cifs_flags);
>         }
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> @@ -3651,6 +3651,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_=
ctx)
>  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>                 tcon->unix_ext =3D 0; /* server does not support them */
>
> +       sbflags =3D cifs_sb_flags(cifs_sb);
>         /* do not care if a following call succeed - informational */
>         if (!tcon->pipe && server->ops->qfs_tcon) {
>                 server->ops->qfs_tcon(mnt_ctx->xid, tcon, cifs_sb);
> @@ -3675,7 +3676,6 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_=
ctx)
>
>  out:
>         mnt_ctx->tcon =3D tcon;
> -       atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
>         return rc;
>  }
>
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 9694117050a6..e198e3dda917 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -49,7 +49,6 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs=
_tcon *tcon,
>
>         if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
>                 __u64 cap =3D le64_to_cpu(tcon->fsUnixInfo.Capability);
> -               unsigned int sbflags;
>
>                 cifs_dbg(FYI, "unix caps which server supports %lld\n", c=
ap);
>                 /*
> @@ -76,29 +75,27 @@ void reset_cifs_unix_caps(unsigned int xid, struct ci=
fs_tcon *tcon,
>                 if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
>                         cifs_dbg(VFS, "per-share encryption not supported=
 yet\n");
>
> -               if (cifs_sb)
> -                       sbflags =3D cifs_sb_flags(cifs_sb);
> -
>                 cap &=3D CIFS_UNIX_CAP_MASK;
>                 if (ctx && ctx->no_psx_acl)
>                         cap &=3D ~CIFS_UNIX_POSIX_ACL_CAP;
>                 else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
>                         cifs_dbg(FYI, "negotiated posix acl support\n");
> -                       if (cifs_sb)
> -                               sbflags |=3D CIFS_MOUNT_POSIXACL;
> +                       if (cifs_sb) {
> +                               atomic_or(CIFS_MOUNT_POSIXACL,
> +                                         &cifs_sb->mnt_cifs_flags);
> +                       }
>                 }
>
>                 if (ctx && ctx->posix_paths =3D=3D 0)
>                         cap &=3D ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
>                 else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
>                         cifs_dbg(FYI, "negotiate posix pathnames\n");
> -                       if (cifs_sb)
> -                               sbflags |=3D CIFS_MOUNT_POSIX_PATHS;
> +                       if (cifs_sb) {
> +                               atomic_or(CIFS_MOUNT_POSIX_PATHS,
> +                                         &cifs_sb->mnt_cifs_flags);
> +                       }
>                 }
>
> -               if (cifs_sb)
> -                       atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
> -
>                 cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
>  #ifdef CONFIG_CIFS_DEBUG2
>                 if (cap & CIFS_UNIX_FCNTL_CAP)
> --
> 2.53.0
>


--=20
Thanks,

Steve
