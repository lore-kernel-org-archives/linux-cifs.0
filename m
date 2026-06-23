Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C74395ADC
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782247204; cv=pass; b=IkwbQJAstmqyWiQy7rPjLMPl31JzrBbvLKZgIIHBD4iMEEG4HH6rCuNkV/epVDFGjHlsX5Q2lyGz2+0wzMYcS4/Nw/YMqqzsL2HU4T1BGT4pjxz9GAT2I+P2Cj9z4wZrYxagK52V9UXIj7wf4pf7c7C5bXppR/TSdJcft/sfQrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782247204; c=relaxed/simple;
	bh=9YFX4LSYLRdE94AdPyGGNY3vctgrGXOF0vynkIynogk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=amyBvOaGA9l75CtUxFOMIgd+sM14yZarV9CemUWFyCAmBb0MNPXBu2s79IGeNQCyAdvxBZ1fSFZqSuShh2GxL7haxxmFJjly+ZWrmE07WuLFi3hi6/UEi907rluMlrSGTZVDVESF5WSxE8W15NPVjCIBlQ3pueYgPLa2HeCSxAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixbiGqMn; arc=pass smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixbiGqMn"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-91588056619so12635385a.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782247202; cv=none;
        d=google.com; s=arc-20240605;
        b=J0US6nZjVfjOoPxMoXq/G6U8R61wQUCf5Rej91YeMMgUoKWyvuK/Mv8mKas+4h3H7z
         +NSHjmjy9k3E+O44KuflRwBrBP+Vr7Ybrik8W4ghiKYzaAiv3KxLouSbGeqW7p608G+B
         oogYzxdohwzBFlTP8RzVlIVddFEoQJ3RWpBVyClyBB7T6RpMPDfwogREZuQc3rEdhI/b
         YOWE3b59VW+xlfeFPioAhYTJxu+vUb5I8mI9HLASjBHSfpzfKTmV4vjNPoK32cYYzO+D
         SHKsfPG6M8CbQ17Vd0v9C4QvxTSeMIkOP59IkEmWgqwlEKDL7jVBzW7sMxFK/iKpTV0E
         2KwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GrCMfpR2TCViNZ3I5Wfh2xWUn64Atu6ZCEIFJtrziLY=;
        fh=RqO3qHF46gXSias6EkyM1c9q3GaZhJ7f9O5kiDDkEN0=;
        b=LPyK781bJUT808FPAMr6f/49HyNrk2bnRwkp+h7hM0jYfXLxA6yX5a1/mcPNdOgvMs
         NRQpsOpiRmhmPAJJeI2Yvy6BH6NvfAW01Wxz9UMQSBORPqmOo8QD0x6aq0Y95g6mF8l7
         cwkOlqX1W4dTvmLMcj4wIZaBr1PVIfFv+zI/ec+s7a8W4TAkrr29a/kEEyZHq0+DSLr8
         cjXnnJtcj3EQ/Y45syl2xLsC5LdtQWVSbhzsWYhXB9IWgCtOWYjqdLnqAGxgDxrIO28p
         VWDEONm99lWb/dZGVVUwDKCiDPicjOkQ4OUIKUC2QNq4FZgk6j1Yjm/ZtqAQvr3V5Zf3
         UYAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782247202; x=1782852002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrCMfpR2TCViNZ3I5Wfh2xWUn64Atu6ZCEIFJtrziLY=;
        b=ixbiGqMn9pb3vBYJbbNLW5Q09so011cGXKdQQSsH4ITG5apx7Iaue+65zhLmonsQGH
         d6HrQ3wKOX0VbOJIP0Kgj04vcZyKWZa4Mzuru6TfbY63sbrqNB28MxIJmM0vCUYhWvpI
         m7hs/85YLiDgB7dISq8bmYj56OcxomHMYoIZLaV1TPzK1SGiu/9fZwAE8YfFKovZiYR8
         0nPlrQ1NnvI1gc2o53Rg1ywCKZIgpwT/nooFsGQzop5AtaKKFG3Vbxz8KiuFbEiFfp48
         K0VJ4rjViMhx636+RGjWDQt2PtEJBvq/hcPd6bfVPB+/H5fsbCoLuZYESbjA6TfvkzWm
         NYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782247202; x=1782852002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GrCMfpR2TCViNZ3I5Wfh2xWUn64Atu6ZCEIFJtrziLY=;
        b=esKrji3VBFc+ZQexdsjh7P8M63KsbaZ5bD0opzANJvpuo52BMBiXUQGiqA+qSgOgaG
         RMw6ItKsW3P7GQtOpE/d4a0PxC24ohwuE6Q4S3AA83fNgNpC70KaoSmJJ1HYBxcI+FaR
         f0xAczByEyrurLT29zyN4YMvt9KdLdFa7eGwjfmpVSSOurj43Owj9rBo/VqUabB+4Xr2
         ukOuNicUTEnIw/CZWv4oGKRTZwne19JMKdEJd6ibHIa5TpKPK/JxuectTz6ec5tw1hFJ
         AExVj23/3wWr+q3PQ7T+KguChvhOzvnm5yHFCot3H9iG1wZ1BHIENFNZ94ADFmmQTFej
         jswA==
X-Forwarded-Encrypted: i=1; AFNElJ9q66XI2OF9sparfWniqp/Hr/65EkXxzWilfA06pPOPOInRSFHC0Fhg+OoJtFZH1gUt3C8ZY8ndhBuz@vger.kernel.org
X-Gm-Message-State: AOJu0YzvwedVz5I/2nhsMOzSFUy4TZZC4P+ktp3t2WlbHb0fW62k+vs1
	ULpo0lVPebQyqd07RyvFMzTdTZgRtqGLMVy8Mmxu/5iAOQoHOohJtM3VNxMyrN0ITkhGJaqlnUa
	imGLjg3xUXV6hqJV9Om4CUxi0md2ZXPk=
X-Gm-Gg: AfdE7cnP7BzTJUfmwIT2YJFYB6nyLLGr7YnaC/BAdHoEcyHb94F7QwDvVxNQszMwmPY
	TLSQ8UhxpqiiNiHIT8G3KJt64fwYAdbRgF8r29h3JZgTlw6su3hvIUMAtISk1xWazAEcjr3jNmi
	erApFYijQyVo0+M02f4s91IPJsGfQAibh1DZ1I3IojTbB/NVEbzcnkrVBJ6asJc+2yc1uEGmshx
	jAE1usJyocLoaSp+wC4rHp++iUODGIZV+XzD1wpwvbd4J+VFf6FRZ7mWMlD8bzZXK4tzkzcFT7f
	9cjIz18PwGn2Fk923yhjGI0s32FVzbddc6nje3SnXZ4jVXdcay9/Hvt6E6gQ6jrdjp8nCLb/3ln
	xwhpgmg3zB4IVJ+/lZ3jHCRSJz/gyfYgt5NFEdGeNVyOrc+8TIXYTPrA9VBQJMEllLWPO2kxOvz
	NTzCVSPySp6vg=
X-Received: by 2002:a05:620a:25c9:b0:914:c0e8:242 with SMTP id
 af79cd13be357-92783a48e71mr103579985a.30.1782247201534; Tue, 23 Jun 2026
 13:40:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260622091450.2668504-1-chunjie.zhu@citrix.com>
In-Reply-To: <20260622091450.2668504-1-chunjie.zhu@citrix.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jun 2026 15:39:48 -0500
X-Gm-Features: AVVi8CcE_BRPWf7m5vqZk2J5gOZXp7rnBuXGuGAURa8MGV346tSHW80AuWPCGwc
Message-ID: <CAH2r5mu7sdqJ4NJQzsqhY+3LmHE7AcREM9nYAbEZCNZ08yEafA@mail.gmail.com>
Subject: Re: [PATCH] fix smb client defer close causes file corruption
To: Chunjie Zhu <chunjie.zhu@citrix.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you see different behavior of this to different servers (Samba,
Windows, ksmbd, Azure xSMB etc)?

Disabling deferred close carries metadata integrity issues because it
will lead users to set actimeo (or acregmax) to higher values, and
disabling deferred close could significantly hurt performance for some
common workload patterns (open/write/close/open/read/close e.g.)

Other narrower client fixes for this presumably could be done, e.g.
forcing close on the deferred close when rename a hardlink.

On Mon, Jun 22, 2026 at 4:40=E2=80=AFAM Chunjie Zhu <chunjie.zhu@citrix.com=
> wrote:
>
> Test environment
>
>  4 hosts as smb client, 1 host as smb server
>  smb client hosts, kernel 6.6.138
>  mount options,
>   //10.70.48.15/xxx /run/xxx cifs rw,relatime,vers=3D3.0,
>   cache=3Dloose,username=3Dxxx,domain=3Dxxx,uid=3D0,noforceuid,
>   gid=3D0,noforcegid,addr=3D10.70.48.15,file_mode=3D0755,
>   dir_mode=3D0755,soft,nounix,serverino,mapposix,reparse=3Dnfs,
>   rsize=3D1048576,wsize=3D1048576,bsize=3D1048576,echo_interval=3D60,
>   actimeo=3D0,closetimeo=3D1
>
> Work around
>
>  mount with cache=3Dnone or closetimeo=3D0
>
> The Race Condition Flow
>
>  Step 1: Host-01 closes file
>
>   Host-01:
>    file close (eeefe8d0.vhd)
>    -> CIFS defers SMB2 CLOSE
>    -> Handle H1 stored in deferred_closes list
>    -> Lease L1 (RWH or RH) still active on server
>    -> Entry: { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=
=3DI1 }
>
>  Step 2: Host-02 does hardlink and rename
>
>   Host-02:
>    hardlink(eeefe8d0.vhd, 0f11b74e.vhd)
>    -> SMB2: Creates new name for same inode
>    -> Server: inode I1 now has 2 names (link count =3D 2)
>    -> Host-01 lease L1: NO BREAK (same inode, just added name)
>
>    crate(eeefe8d0.vhd.new)
>    -> Entry { path=3D"eeefe8d0.vhd.new", handle=3DH2, inode=3DI2 }
>
>    rename(eeefe8d0.vhd.new, eeefe8d0.vhd)
>    -> SMB2: Replaces =E2=80=9Ceeefe8d0.vhd=E2=80=9D name =E2=86=92 points=
 to new inode I2
>    -> Server: old inode I1 now only accessible as =E2=80=9C0f11b74e.vhd=
=E2=80=9D
>    -> Server SHOULD send: Lease Break notification to H1 =E2=86=90 KEY!
>
>  Step 3: Lease break delivery is not reliable
>
>   strict locking off, level2 oplock
>
>    Host-01:
>    -> Lease break not received or processed
>    -> H1 is in deferred_closes list (not "active")
>
>    Result: Stale entry remains:
>       { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=3DI1_OL=
D }
>
>    Host-02:
>    -> Open 0f11b74e.vhd in readonly
>
>    Result:
>       { path=3D"0f11b74e.vhd", inode=3DI1_NEW }
>
>  Step 4: Host-01 reopens file
>
>   Host-01:
>    file open (eeefe8d0.vhd)
>    -> Kernel checks deferred_closes for =E2=80=9Ceeefe8d0.vhd=E2=80=9D
>    -> Found H1! (matched by pathname string)
>    -> REUSES H1 without checking
>    -> close or reconnect, flush buffered writes
>       slient corruption?
>
> Signed-off-by: Chunjie Zhu <chunjie.zhu@citrix.com>
> ---
>  fs/smb/client/fs_context.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 0812af001417..4ed33de0a00d 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1300,11 +1300,11 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
>                 ctx->acdirmax =3D ctx->acregmax =3D HZ * result.uint_32;
>                 break;
>         case Opt_closetimeo:
> -               if (result.uint_32 > SMB3_MAX_DCLOSETIMEO / HZ) {
> -                       cifs_errorf(fc, "closetimeo too large\n");
> +               if (result.uint_32 !=3D 0) {
> +                       cifs_errorf(fc, "closetimeo must be 0, deferred c=
lose is disabled\n");
>                         goto cifs_parse_mount_err;
>                 }
> -               ctx->closetimeo =3D HZ * result.uint_32;
> +               ctx->closetimeo =3D 0;
>                 break;
>         case Opt_echo_interval:
>                 if (result.uint_32 < SMB_ECHO_INTERVAL_MIN ||
> @@ -1795,7 +1795,7 @@ int smb3_init_fs_context(struct fs_context *fc)
>
>         ctx->acregmax =3D CIFS_DEF_ACTIMEO;
>         ctx->acdirmax =3D CIFS_DEF_ACTIMEO;
> -       ctx->closetimeo =3D SMB3_DEF_DCLOSETIMEO;
> +       ctx->closetimeo =3D 0;
>         ctx->max_cached_dirs =3D MAX_CACHED_FIDS;
>         /* Most clients set timeout to 0, allows server to use its defaul=
t */
>         ctx->handle_timeout =3D 0; /* See MS-SMB2 spec section 2.2.14.2.1=
2 */
> --
> 2.52.0
>
>


--=20
Thanks,

Steve
