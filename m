Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDA0343892
	for <linux-cifs@vger.kernel.org>; Sun, 12 Jul 2026 16:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783872181; cv=pass; b=u35gr3QSjkCG8aD/v8x/HYNOSwAHXTa1prQOGS6h5dprF6JkfZ+c57NeWEi/mQotIHtk7GOva92KtTaTY1GQ3Rwd83ncZtGWNk6JuMUD/RdokhJ2chudA2yhuHE4Zb5Pl6Vb/eVDbZqHJJNBl/9+QySNC1r9mvld8s9uhy020JQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783872181; c=relaxed/simple;
	bh=NV2pzC7VYZUgEjsdZ1i1bIgl/fP0YBsfxQ2Ky/GbfuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lu8JgIgIGux6/C7BT6EpA70JUbYqiNate7mQaFVkme4OPXRuYs7IENbbS18TJUghtnjBNJoZGd6qDZMkRszb05wCILYW5DxKLzGWtNMMXu66tnNp7RwL0/1dEPS2S03ITeffe64TQRZBqsEUnb6zSE98zvZpNq6MOWMQlREQgm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agttTwXk; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agttTwXk"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8ee6912d86dso17738376d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 12 Jul 2026 09:02:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783872177; cv=none;
        d=google.com; s=arc-20260327;
        b=kjoB+0499t88k/cOg1iyqZKPV/1kZDkeOfuuegoihc0lNSnhjU/973lBzfWpccnMTT
         kByvDRy6megwgXqiHfenMI2a0dSTu5359BKnGm0EcEibPHDuGX5oThjBYJfCEO1BgNAk
         ajDMtFzO1ohkwuuqfH2KQUW3Fh7LFn3goISMGNY6OCI+ehJ+SOOBG3ZRSZqT2n9uCk7p
         5bZZD9+2VFv576WYByMLSB3zJ3yfVjYWuoNFFYcAQZ5ktrvIbDzFvhChT1YPi28lWxdU
         XPa+VrFQc29ClNI6Dl6ZeR/kKOOcxPJKUmS+NGLtJNa7+JbfEIULjo/VYQXxYPnOu0vw
         SSYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tr/vLvyJLyQATf1/0yNI+vtyxOEwCi4r/Ln8QC3scXw=;
        fh=XG4gKm4615skLiDBY7Khapnlv0ME3DeIGOwrW98aMYg=;
        b=EMkX3iSjnsfS1lIQDm3Z4R6otrrWsmHo4H1hODcALMv7/0DFnoIOIOacPVakVfLeON
         dLPkr8+AXWdcPKlz2c/TO4CMjAIuTl9y6mlF53WlZllA9e8R2YLFhqJyGJXd+LC3uZ+P
         30371QfVIIVkhS8JEOWkVoFWFHfY826Cl7DFR1xLAugXUkJwOlrcxK4izbvePDg6c2q/
         4UcezaayOgMmvVzvXuhTlgNXjNHtGhJK47RVV2NGLNJLjWnz0/UO5EprrFmhOCiSJq9s
         iF94BjuTgl50ZIxDOSpvm30a8a0Hojy/QcHjB2QXHLC6UbjvLVqIOKdy966Hg3k2+JRN
         y11w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783872177; x=1784476977; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tr/vLvyJLyQATf1/0yNI+vtyxOEwCi4r/Ln8QC3scXw=;
        b=agttTwXk+CHWnQKEX6BVK0gbbZkeJxlXcywn04KcO8meHz47gEHyuFfyizieKdRdJB
         53ZbSaVGdkU16tIylTDm2adgigbEjpkRaoGNAhyyHKv4YVb3DSMeuJZXps6iaj1fXydL
         176B5ZipaGUTfE22NNkZpco5+TUe0YKI+6sCwRV24BNIpp3jA/qGZv2ST270AYDiVAA5
         XuMifUqMCF+lhwQamTmIfG6oRiLmnniFsog4tSDXTOv24izVUZI9Siq5FGl6Mfsu4DZa
         6o7o+SxbhVYPsBG2+kcJgzcv61Yfm0uvZcvg7iEKfgC/VVpgtKFEO0C2W+ln1KBAFeQm
         e9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783872177; x=1784476977;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tr/vLvyJLyQATf1/0yNI+vtyxOEwCi4r/Ln8QC3scXw=;
        b=o6b9zKfVJkTW2qgtZuG/5FoiHZOa3uw+8F+28PICt+5h4rs8wHixaX7qUpIl7gvLDp
         bPH4CRg945hDk4EvAtRAXB890w8Gzz62YXA2oXbTCU6MWdUHhNm72NYqTZOpEVoavlqe
         J+PMTdMekuRxeax7ycHg1UCCi2rR0FJbEpVzXxa06q1WsKdI7eWadP0B/iONIw0Fv4SM
         3ErwrJFZjg4L/4GNAawvTvw+thpE9TSBU7kJRKnb+EsBUHhYCt4hKA0AhQnJrRQBxxm5
         j3Eby+ixfqfbfobFdsdU8vWeglKrlFz5iQo6zSlqvG98hqPJAaxxPpTm5NnZWlw6BO82
         PjrQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/sx5n6u7y5DLGyL0kI5keqFsupGwcP6U5/SjCJG6XhV/lnZe6FHHs8PBUTBB10LXzBB/HGzMHX1z/@vger.kernel.org
X-Gm-Message-State: AOJu0YyTXCpXqgZtuw6Og4yJ1WCaW4e4HgLLfCHI793AB7tBOYv1bBSE
	d5Qpkh7IypGpuqefmDxvbH6Ca819uOEGcdU4LAxFQYwjpWGA09XA3sM5ZpcFppCGdoRVKWwiwZb
	E+VO0G6UPM17aEdG/PCL7xy1qZKp9pn8=
X-Gm-Gg: AfdE7cnDW2DLFpbN2HpF3A0m7rpEe+WGaxbdZFm6xKGnctS4IUoDKLQg9Ki7CQyYwj7
	5YJcm5xy2bShYG602zlYN2dxd7TWvhtS9gdj4JjNA8Gf2vvceXvoqFEjXSdhzlXvwSdeuYypNB9
	1qac8o0NL1tl9Pjwkto+vko+VjWN+iSVdrjPtacozMAAOxQo4AAFHHN+0qZamQ9RokgUTohMFnb
	Ty9cOdhNGTLyMDZZVMdDdSZvTkygE2iGHpjpAMGpfpvoD5QJf/EV78Zv5OZ8F7i8hczwxOamL9p
	JJ85d7rlqhmxCSCdpQYlZ2IGk0cX17uiHNggdDWPEJNm1MouhIjSDLaEouq+JbT7ixA1yubo0V6
	may/jpzq8wuSDjm++iLrvVu0YYuG6t9f4n0y+mIR9NXSWKSVi2NsCLnJS03p07+nW00/G0wpDWR
	nCaLSggWxkGiw=
X-Received: by 2002:ad4:5764:0:b0:8ee:871e:f2e0 with SMTP id
 6a1803df08f44-903ffc6a7e0mr71122216d6.27.1783872177202; Sun, 12 Jul 2026
 09:02:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712025402.1804211-1-FredTheDude@proton.me>
In-Reply-To: <20260712025402.1804211-1-FredTheDude@proton.me>
From: Steve French <smfrench@gmail.com>
Date: Sun, 12 Jul 2026 11:02:45 -0500
X-Gm-Features: AUfX_mzobQXfLo_VGS-zoz-RhoQokIm1L5z1GziczB8gCLVn9ev0yz2U2TLZTFQ
Message-ID: <CAH2r5muSdTqXznPiv4iZbVBbWvGP6+TW5V76k8yCpef1biS68g@mail.gmail.com>
Subject: Re: [PATCH] smb: client: use kvzalloc() for megabyte buffer in simple fallocate
To: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Sat, Jul 11, 2026 at 9:55=E2=80=AFPM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> From: Fredric Cover <fredric.cover.lkernel@gmail.com>
>
> Currently in smb3_simple_fallocate_range(), a 1 MB buffer is allocated
> using kzalloc(). Under heavy memory fragmentation, a contiguous 1 MB bloc=
k
> of physical memory (an order-8 allocation) may not be available,
> causing the allocation to fail.
>
> This failure was observed during xfstests generic/013 on a 4GB RAM
> test machine running fsstress:
>
> fsstress: page allocation failure: order:8,
> mode:0x40dc0(GFP_KERNEL|__GFP_ZERO|__GFP_COMP),
> nodemask=3D(null),cpuset=3D/,mems_allowed=3D0
>
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x5d/0x80
>  warn_alloc+0x163/0x190
>  __alloc_pages_slowpath.constprop.0+0x71b/0x12f0
>  __alloc_frozen_pages_noprof+0x2f6/0x340
>  alloc_pages_mpol+0xb6/0x170
>  ___kmalloc_large_node+0xb3/0xd0
>  __kmalloc_large_noprof+0x1e/0xc0
>  smb3_simple_falloc.isra.0+0x62b/0x960
>  cifs_fallocate+0xed/0x180
>  vfs_fallocate+0x165/0x3c0
>  __x64_sys_fallocate+0x48/0xa0
>  do_syscall_64+0xe1/0x640
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>  </TASK>
>
> Node 0 Normal: 3375*4kB ... 7*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4=
096kB
>
> Since this scratch buffer does not require physically contiguous memory,
> switch the allocation to kvzalloc(). This retains the performance
> benefits of kmalloc() under normal conditions, while gracefully falling
> back to virtually contiguous memory when physical allocation fails.
>
> Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> Tested-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> ---
>  fs/smb/client/smb2ops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index d4875f9532b4..55b53bb9e3fd 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3595,7 +3595,7 @@ static int smb3_simple_fallocate_range(unsigned int=
 xid,
>         if (rc)
>                 goto out;
>
> -       buf =3D kzalloc(1024 * 1024, GFP_KERNEL);
> +       buf =3D kvzalloc(1024 * 1024, GFP_KERNEL);
>         if (buf =3D=3D NULL) {
>                 rc =3D -ENOMEM;
>                 goto out;
> @@ -3652,7 +3652,7 @@ static int smb3_simple_fallocate_range(unsigned int=
 xid,
>
>   out:
>         kfree(out_data);
> -       kfree(buf);
> +       kvfree(buf);
>         return rc;
>  }
>
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
