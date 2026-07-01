Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10934386450
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 21:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782942476; cv=pass; b=Wixv+14lRAmPdgfgMxU40W3m3P+1MvAFWkqifzevBeyIOmCpyLqnwcKyd0r07hiVcGRXFqFxYYFTmfzTDF52owATYxLhGAi9Ebu2B53ZLMWJ+H8kXXVcqx4LHDNIkkOtsRsvgoYKe0hRX9MS34x4ML1F+wzKqik1005SEFOdvWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782942476; c=relaxed/simple;
	bh=H0rmLNHY5Q0EfmTTWT7iXJbIhGOdnFi8GKOcHg4c5E8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hnd3oO+46QFLvLcK9bSJLu9PyHfM5Ih2cOcQPST7F/l1U2NCfyKN6JyANcs7SneMzsiqd6LK/oLChwOEzHu8C7uXaodTdZOHhX5ZOxgw/kR5OQ169a6EkLTcn3d0mAcLvH0frK8IaCTeRQSuAhgO+G2iXmWm40YOkxlOpavPSN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ciiDIgkR; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciiDIgkR"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ee88fce476so9859076d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 14:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782942474; cv=none;
        d=google.com; s=arc-20260327;
        b=VnbzomiiUf2C27RwOE9Z9uKzEddQIHw9CdC8kSGi9Zic4yyPM+meC0yrunjjDkP+b4
         tAddczK+/Pw7IZHCHNd+kyZdQ5e9Eu1xnMSJX/uh2wTj073sRO9+CRpvEjy7FwtRvwu+
         keCOgvm1zyVFUPSqDPXosVnByVRH/vQYeofwJkfI2TbM6rSQdmGdRCj2SLs9TvqjYsQd
         qEfT6Nxyu+jkiw5on0F1kLfVWZosLxuaARDPy7eg7nGtk8E7mw/vTMZ/JYcl9mJ26bX8
         UPBXLCmdUa3lpdfWW7HpOPXoz1c6XAik12yyU7MmKjDx4Vj7u2gB+YJjSqhwe14isf7z
         2InQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5DMsUg7D3URDvxNrOwtGfF+HxS2ydq2gWLRjvWllS2c=;
        fh=exiCK+K2qjphmn7GZDZ4nyoAFsrPOKYoLcWNrq1jIFw=;
        b=nB4ZGO8mSuPsoBEaT2a1rPEZfXt4vh4vJ/lMXI7RiJJUJKbsk8fXo3NLIprXd3vP09
         oy0Fm/v8xcTeFzeJTaUCbpL/teC8E52iyg386SFv+5g9rpEnmcBJYRJaTvWGcIZQ++U/
         Cdr7qQf6+WuOTxyg1lOQgV50wfbJhtYAOcor732flm8I6kXFDkW9dZ0yrpiXnFjtdDYD
         Jrm4b7fEpL4lbWF9NduY5aNwg7u8CDKH+wMRUoBv2fK4zn/WPZ35SOKIbu55DkxHuHXx
         7VyhqA3pfDpm+R8/oe1exTWL0/asiT+dX2wIEkg6air6yPqVOykBNPJtyodzF2QbUqQm
         r7SA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782942474; x=1783547274; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DMsUg7D3URDvxNrOwtGfF+HxS2ydq2gWLRjvWllS2c=;
        b=ciiDIgkRiKq85W8P01Wm5IUDwVZst1GdYvLev+z22HWK3j7e3i+cNtvTgSYDE8eVKP
         xrsW+M7dPI7LoZ+rMxtkaq80b5qDAb+4WWOGgh0EZo/C5hdOJlNIZTDTGGKuGGRXvWl8
         9ZlCY8P6hGotwE6HDCTTqKx/XUcwhA3HBnlfq37+GrWto5w4Zk8wa/xxTbMaKDZXnnce
         3jFUyOYunKpPT9C5UHCkTLXN1al3zZpaKjGzA/cXJdPXWa5oi84wY3y+9PtTLHKhFPtT
         Qhg9VmLYH4CE4SPmGZeRBkf4wDtYP4Zw6fBTuNabbMBBbtujxwUj6ar9lf26fyp8qHzs
         5wdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782942474; x=1783547274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5DMsUg7D3URDvxNrOwtGfF+HxS2ydq2gWLRjvWllS2c=;
        b=caQ4aZrLIRk9sCHS0dGId8bLc+16zA/rbIUwVbtsNnAsMBCODVhLPso8O3tj3D6n+0
         DnDnlQmXo8wERZY432iVv8eg98k9UfBZonAHzSffyr9W1Wch0z6fdA4fwNBPsluhlaH5
         h1Eo9ULZmXfBpu5zswDghESqpkymPB0Pz1/ng7fladsDRGWFFQo/qO2RZfl1f0OpSXkB
         lEk47F0QFB0RAP3w0hz7IY2wqmcgvBSDX4sNvRLGnscV5rIpq0SZWi0vUtBN7X5EJ7H1
         28MJHzHL/x+fJm2VK41quhygSAwSekQbtypeAr++RSefvNoLY4UWveo6PHdR04ymTZIJ
         zEIg==
X-Forwarded-Encrypted: i=1; AHgh+RrIfgCX+gQDZo0l8kGtQZsI5ZaYXBWbV/VZ9Pn2oGL/EbKPRG6+BJmnv+kDiNjnJu3tl5cEIx9CcEob@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7T+jvj4REwo2jy90bnz6FEaVkNj6KdE3Dy0MKzS4DEr+ccr+O
	qGGv8jgCftUkuC/99BsL60BJENNEKL9Ri+425bEBVrNAN0JPCOcce36GL2V1zQu34m0wL8Pu5+y
	VxFoBcsXd2xwDKxf1qxB36w5bnQX/io0=
X-Gm-Gg: AfdE7cnrF2nLHPPyS3y9+NIPqngvLmIZpNO1IVOxp7mtyV1GD5qP3w4n4qpD9QZgaGg
	DwRFf0RsK4lY2SZe9N2pJA1ZqUXtaD5jRBG29gu9wAeouubfj+ol4Ma7oYGEai/+u07sFqbNN0e
	HLMw8a41ng4rBL/v9pwS4zxX6So+pODeyqwTMXE2f/ZrKuiM1IMW+VoRN9aIUWJSprpZJr/PqGp
	S9gkBNFY7I0EJbhUebzULSOvkspFL1I5EpABYSYZ+oiXCz//0L+LwxBGPRuAEGsQFWZQdFyIyCL
	dZyVBG188FbsV/YgVggMojWpAhJ7cZnrswzzbVcWI0u6Qogs/atTKpO5HUvzchOrp9CMnIfxg38
	yDJ+ABkDbtSr2m+QsM/WUwfSnkW+dWzGQWHJ4pvICBXh/xJS04Es4E3m8/3iSOJLguhJYNQP9co
	d39hCQbJwa/UY=
X-Received: by 2002:a0c:cdcc:0:b0:8db:dd:4d85 with SMTP id 6a1803df08f44-8f3c8b17e1cmr33919926d6.26.1782942473952;
 Wed, 01 Jul 2026 14:47:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701152157.822207-1-huiwen.he@linux.dev> <20260701152157.822207-2-huiwen.he@linux.dev>
In-Reply-To: <20260701152157.822207-2-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Jul 2026 16:47:42 -0500
X-Gm-Features: AVVi8CeRByc-Tywq4FeOc_yCvXB6Rg8UTI-6xAgnzuLQFSHq3wn_plYIch8Dreg
Message-ID: <CAH2r5mudB4xBQnPvuSZo5SiYkRn0UEs9YZi9rbUGBh3G3GBqZg@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] smb/client: refresh allocation size after
 duplicate extents
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This does lead to an extra roundtrip (common operations like cp will
use duplicate extents in some Samba and Windows server
configurations).  Any worries about performance hit?

On Wed, Jul 1, 2026 at 10:22=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> FSCTL_DUPLICATE_EXTENTS_TO_FILE changes the target file extents on the
> server, but the client does not refresh the target AllocationSize/i_block=
s.
> Callers can observe or use the wrong st_blocks value immediately after th=
e
> clone, before a later attribute revalidation corrects it.
>
> For example, create a reflinked file with a leading hole:
>
>         xfs_io -f -c "pwrite -S 0x61 0 64k" src
>         touch dst
>         chmod 600 dst
>         xfs_io -c "reflink src 0 1m 64k" dst
>         mkswap dst
>         swapon dst
>
> The file still has a hole after mkswap:
>
>         /mnt/scratch/dst:
>           [0..7]:       allocated
>           [8..2047]:    hole
>           [2048..2175]: allocated
>
> The server also reports only the allocated ranges:
>
>         server dst size=3D1114112 blocks=3D144
>
> but the client reported EOF-derived blocks:
>
>         client dst size=3D1114112 blocks=3D2176
>
> and swapon succeeded:
>
>         swapon_result=3Dsuccess
>         /mnt/scratch/dst 1.1M 0B -1
>
> So EOF-derived i_blocks can let a sparse reflinked file pass the CIFS
> swapfile hole check.
>
> Fix this by querying FILE_ALL_INFORMATION on the target handle after a
> successful duplicate extents request and updating i_blocks from the
> returned AllocationSize. If the query fails, invalidate the cached
> inode attributes so a later getattr can refresh them.
>
> This also fixes the xfstests generic/370 regression introduced by the
> i_blocks accounting change, as tested on a Samba "vfs objects =3D btrfs"
> share.
>
> Fixes: 99cd0a6eeb6c ("smb/client: do not account EOF extension as allocat=
ion")
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2ops.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 06e9322a762a..cc8e0595e504 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2193,10 +2193,13 @@ smb2_duplicate_extents(const unsigned int xid,
>                         u64 len, u64 dest_off)
>  {
>         int rc;
> +       int qrc;
>         unsigned int ret_data_len;
>         struct inode *inode;
> +       struct smb2_file_all_info file_inf;
>         struct duplicate_extents_to_file dup_ext_buf;
>         struct cifs_tcon *tcon =3D tlink_tcon(trgtfile->tlink);
> +       u64 asize;
>
>         /* server fileays advertise duplicate extent support with this fl=
ag */
>         if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
> @@ -2232,6 +2235,19 @@ smb2_duplicate_extents(const unsigned int xid,
>         if (ret_data_len > 0)
>                 cifs_dbg(FYI, "Non-zero response length in duplicate exte=
nts\n");
>
> +       if (rc =3D=3D 0) {
> +               qrc =3D SMB2_query_info(xid, tcon, trgtfile->fid.persiste=
nt_fid,
> +                                     trgtfile->fid.volatile_fid, &file_i=
nf);
> +               spin_lock(&inode->i_lock);
> +               if (qrc =3D=3D 0) {
> +                       asize =3D le64_to_cpu(file_inf.AllocationSize);
> +                       inode->i_blocks =3D CIFS_INO_BLOCKS(asize);
> +               } else {
> +                       CIFS_I(inode)->time =3D 0; /* force reval */
> +               }
> +               spin_unlock(&inode->i_lock);
> +       }
> +
>  duplicate_extents_out:
>         if (rc)
>                 trace_smb3_clone_err(xid, srcfile->fid.volatile_fid,
> --
> 2.43.0
>


--=20
Thanks,

Steve
