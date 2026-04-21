Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32EB36167B
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 23:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776815928; cv=pass; b=oC2QTfzAA9TN4ByAfSQPWFmHXJRqp+u1KOuaKxzsedDMFDRsDX3cm5UY/dJr4vakDTx+sUbccX7F2bj48O2wBAAfwF2Dg3UslFdw08tMtroG580G+RIQBXtVfXpuwAzZBj2Cnb7ziHCR3PIJjjR+0E+Z+uMVIKZ5Ki8XO8TNc3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776815928; c=relaxed/simple;
	bh=h6st7tUPmacYRbcbyVHk1J1MmG7oibqwV0YNku9qCTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K7JhVZ3zymPfzUIkNBc9BJWBYbHs9fMAZw+KeZmOnXeThs18BfTx0tR5yORI1+hp32Dqu3uoAepOaiRUHJbEnmuTXn6yfwBOQUISR8ViaPz6f14QON0Lede8ISJ44UqUJA/kRIAE2Y5MEVCi12aJi0s+vcoBPkjK3XBK8U92YsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tDdK2NC4; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tDdK2NC4"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8a151012558so53083766d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 16:58:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776815926; cv=none;
        d=google.com; s=arc-20240605;
        b=MuAQx/4DWKcMXnszsx4R3GUPFG1utvosXNxA1Jvb9M0OOZuHte49vEoj25F5HAjRCl
         qhRV1wuCI14hcxeWSC+aHuaQY4CoKHbzVXBRdnCiD9WShDZW7J/6CzlxvM/4RRgDsRdU
         mhjv947oAAGS+1rY1H8pi/BCQqTWRuXXaOa2M+Le8Aafzy8BLckOQQFpV29ZKkFce8z7
         9HBz3JiEQGKTGSj3tolU5+oQhFPK8nBCG7Zm1RSkh8nZyvq4vG309QQUanptaquZg+Wu
         xPCcksVJ5I9vF23yCKFz7YsOuv2EAYBdvwd16Omq26eqcjtSkdWBmahgJaocjSTpbJiS
         KQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1w9xmPIw1s4ACofNeSxjnnwGMUxDSVTPAfVJPCJagLY=;
        fh=LkWR6+ZIjPscXyWh/U6uVaNMTfbqm2hNZabMFStHs60=;
        b=FOMkwwX2ltA0VNNhm8GgTabSnUgaG+AgCSP0mMe1vx8joJ1iy+N1VMt4XUaxGkPMKL
         VSbyMtkS/lyRuEzpVhpupWxsvl7OGJeiX8CcKgZrfilqla/HiZw+LOhme8jV3Ag9H6y1
         fvyn3VUIZVPOnHHnbpGAS7Be6EGsFeVyoXeq85vxtX5W9EjhHSPxHw7NxwGuRi+LxWHB
         TPJ5BjrvzaGvHE5cs0AQhCeWQWjHMBxn/+00CbaL3A17Xwq5HDpTEnQy1I+2mb7VA0dM
         d8yChBl05JhijlzUpF1FKVJoB5C1XmusUhUrsSKeAdPx0/UbsS/9rK0oCaMG6Zu6YzRJ
         FvhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776815926; x=1777420726; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1w9xmPIw1s4ACofNeSxjnnwGMUxDSVTPAfVJPCJagLY=;
        b=tDdK2NC4wPsVyTIH2ZrxLDvVMayZgWpR9xwJDRwW1ZS3jvJndCzmXgibRBDI0D1rF6
         0iZwsza7a7yRDIVLUyT5WjqvrUA4ITnP6KWFCJImOpWLsn2KkDBP8ThE0pGI5OsxQk/w
         siwIeZN4UpgAACmp74h3nDfkDYy7mXVqtBT1PjE+xTBHzT83/zckTB142ls6yhHPZsMu
         7mj3WWl77jNBc0QMkOnSnNtimdw1u711V8q5eypEzGdUJejW9+ckwy7kIA1xigrtBo0v
         SKX9odzZskA8BJsk6QUUEc6/3RhEwhUp2UInroOaOmQ5bNJpNzrMxTt4C0kKRWrFvbY5
         JweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776815926; x=1777420726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1w9xmPIw1s4ACofNeSxjnnwGMUxDSVTPAfVJPCJagLY=;
        b=ZH8rAgltXFdxAijBeXE3raHRMZI95tZPzDaBU1ciTkd+Ogkfg2qbbZMy4mL+KKy50q
         ryxkD/lFQYdTHW3Gmd4TtYnohFuIr0VQNyDfno8DPLdztz/DMTwGE5cindBjtHEIMRhh
         Y8arNbkz69VwcdZ2CrUFO5d5iF34QxgPgPcehYQsr3Dcmr/0tWstXqE/SV+gwPJrWx8Q
         xCdZ9o1SuvcrLcmbAL2S0mDXvJkbZ6KcKzpLP6ARGAUZEfaKYziBtWDFM84t74mEin/+
         TrreYj+KR2qBjQPGqD3ztYyrMG2kWpsSIhV69TzY2miYU7gUZbzFeia78fWc6uGcw5rg
         SOyA==
X-Forwarded-Encrypted: i=1; AFNElJ9nd+XyxXy8vBtPSYaksy4kuWs/lfF+0V/WZpBrhBeIaj3cCjnCfkOAh0nd+07rf1DexXtFyXdAL/Le@vger.kernel.org
X-Gm-Message-State: AOJu0YwKxg8o06GZf1DQ5NjsMGi8zl5UobUGuX+jxZZ9fMXa+UX5OpMJ
	eZblmX0SnfimL70UUdtiuLWsUlTV64RsWCA3fO7fZmTpKkRmfLu8r4TNQA3k7mHCBupCt+Okz0v
	F1Qlzo51jOXCDPqoJbDArbJMWlvfysFs=
X-Gm-Gg: AeBDievyexD1u5rl1YHJcPYKdztDsg9vodWGt2BLWpKJCGB+mARcY1Cz0wDrqaYP6QH
	6jFkbfhwVWSKwvmO+OkWer3xbTAUVytZA4+yAwYurrk/NsZSiIQIjLCIWf0ost0EAxjas8vX/fU
	frPDxGZDrjZAVlwlLaXI1Ni/1F58HXhk36fcPoGl9DYOFW1KLdT7QnMCQtZagtHpn6rk8cMCFHK
	0LmfLdpT0fZuWyMcpaRpGg65zEtrh9mYvcXNTLUR+02VOqdIWsePksmo+nRapBODHChukacCkCo
	Jzb9EK2fr82THGLczifeRyCtEv9/Ih+IZAlo65ENWqbxF5umr5wsXwrb+HUHLKo56i/jEAXcHR8
	bLOIoJqIax0kEuQ5vgvNG+9JTsOFkuhJIAQ7j4RY+66NfHINnDhAqD25DhY1bpSy4z40OjIR9WA
	==
X-Received: by 2002:a05:6214:5b86:b0:8ac:7d7a:56fb with SMTP id
 6a1803df08f44-8b027ff9ad8mr334820896d6.5.1776815925829; Tue, 21 Apr 2026
 16:58:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202604220046.tGkRxVtS-lkp@intel.com> <20260421234022.4144209-1-michael.bommarito@gmail.com>
In-Reply-To: <20260421234022.4144209-1-michael.bommarito@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Apr 2026 18:58:33 -0500
X-Gm-Features: AQROBzCSqxb7UrXES82np52thvNKKuicFFDAsnSczdEkb-GEFf4ev_ygkXuBAAs
Message-ID: <CAH2r5mvZwRW+uuRmwV2skkJf0mD4FDQoZuNPAGxX5mzGaVYK1A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: scope end_of_dacl to CIFS_DEBUG2 use in parse_dacl
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steve French <sfrench@samba.org>, Steve French <stfrench@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Apr 21, 2026 at 6:40=E2=80=AFPM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> After validate_dacl() was factored out in commit 149822e5541c, the
> local end_of_dacl in parse_dacl() is only read by the dump_ace()
> call under #ifdef CONFIG_CIFS_DEBUG2.  With CIFS_DEBUG2 off the
> variable is assigned but never used, which gcc -W=3D1 flags as
> -Wunused-but-set-variable.
>
> Remove the local and compute the end-of-dacl pointer inline at the
> single call site inside the existing CIFS_DEBUG2 guard.  No
> functional change: when CIFS_DEBUG2 is enabled the argument value
> is identical to what the removed local carried; when CIFS_DEBUG2
> is disabled the code was already dead.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202604220046.tGkRxVtS-lkp@i=
ntel.com/
> Fixes: 149822e5541c ("smb: client: validate the whole DACL before rewriti=
ng it in cifsacl")
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7
> ---
>  fs/smb/client/cifsacl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index 4ec204d2c774..ec5d47779304 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -836,7 +836,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *e=
nd_of_acl,
>         int i;
>         u16 num_aces =3D 0;
>         int acl_size;
> -       char *acl_base, *end_of_dacl;
> +       char *acl_base;
>         struct smb_ace **ppace;
>
>         /* BB need to add parm so we can store the SID BB */
> @@ -860,7 +860,6 @@ static void parse_dacl(struct smb_acl *pdacl, char *e=
nd_of_acl,
>            user/group/other have no permissions */
>         fattr->cf_mode &=3D ~(0777);
>
> -       end_of_dacl =3D (char *)pdacl + le16_to_cpu(pdacl->size);
>         acl_base =3D (char *)pdacl;
>         acl_size =3D sizeof(struct smb_acl);
>
> @@ -876,7 +875,8 @@ static void parse_dacl(struct smb_acl *pdacl, char *e=
nd_of_acl,
>                         ppace[i] =3D (struct smb_ace *) (acl_base + acl_s=
ize);
>
>  #ifdef CONFIG_CIFS_DEBUG2
> -                       dump_ace(ppace[i], end_of_dacl);
> +                       dump_ace(ppace[i],
> +                                (char *)pdacl + le16_to_cpu(pdacl->size)=
);
>  #endif
>                         if (mode_from_special_sid &&
>                             ppace[i]->sid.num_subauth >=3D 3 &&
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
