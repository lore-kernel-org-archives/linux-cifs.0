Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A65D30566E
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779207247; cv=pass; b=qQEeldn57W7xsYaHbfHMtk+vFeZHbqzoc61q2Mq0lZEXsR4bcUaMrP0TbEwRZzweNynxD0WqloT8LQRObsgjs/abgakyu8mMKYooG/+Et4Vz0a/XFnSxI2B9XhCFf26rCPX2R/+oGIckbaKhbVed641nXq1604Y0D8+8XDADGTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779207247; c=relaxed/simple;
	bh=eJhyssaVAHNK/h8Hxtk5dyEoQ1+Damu/fmJLSCyYh3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OY43w1tyh4nPPkoTUyr1oU0LUzVfodIavUwHDrLWUycNr5foh8gqBsOfdN8eQxVs3tymAuUuRwHJJOGEhBANSfEREuyKlzwWWHmdcxGJytE9SN+y4tAf39Ookfgp4lkjUJGPNNXpH4inC3wPYVNxU6OYw77N335lB1OLU0b7FnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I7BEsjRL; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7BEsjRL"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-65e170f1ca5so3879934d50.0
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 09:14:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779207245; cv=none;
        d=google.com; s=arc-20240605;
        b=asMjwgr0y3bf5Kei+sXhqZwCmWL+jc1vPow6JvJjR0AnP1Ui0OXeIn0AqC4C3w62vH
         wmGcGzbwKSe73mcEUIO4Zwkyw8+68H+fNElHBY+sOwSvlRqwuRWYltJvx1aXltZbMN8K
         DtF5gLsVEYq/h7937hY5x+fNuefKue91KBnp8QvFH5o3HJcCfJkFPUQ2CnzsI/kT4/DF
         QimcEGqk+vz5W6ZAtZJ4yMuBr/S+ItGWtagQusS5tnrLlDTptMKw3XKy7ixJ18t3Wj02
         GlL4cJ2BRZmd5SPkz8wuNwlj2UqQnauZ3r4c622yX1ir+Iqy5sH91oFnS2+7gy8i2Oaj
         oNvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o1eu3n16YxCs7yfqPvAq1HFRibL7XFfKfCzYcR9nV4E=;
        fh=IIP0/0ICc8MAok+G6WSIqcnYnOV+HEh639IaASNA7dw=;
        b=CEzmQkNnlWeQGbAzIyCBWUmy6i9sboL4M1qbP6L/tvvmwnL/lBBbsrLaLJ/jse/4Y1
         dW6Y/Afwg1MgdLiNFAf3+p1o/lR7Za4EYN/HIC41JqtM7Pwa7N/xVhQEL2+1POxIwxpX
         CqjL6ORIAFgTL4BR4VFtsIuOXyVykHjXXhKrTnpvq7COF4MStyZYY6GA+9sH2LozyU36
         bWH7A4Z5NrGx7S9x389px6jdB8e3Lttc9pV4XzaHCOv5bsRKGKVHz36uK7LYOeIAghRP
         pRZpC+P2MXC276Vd4Siar9BI1nOEMRJpbjFxBihV+GI7TnjsrboQZNQQhGfE2K63bW6G
         2psg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779207245; x=1779812045; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1eu3n16YxCs7yfqPvAq1HFRibL7XFfKfCzYcR9nV4E=;
        b=I7BEsjRLrLEg7VHZxHHES9PJLDBbKJRHc3NVwvTqCTUyRu1muoQRlC5Nzr6EGtGSlP
         uU5diCdhNbyKJPLB3BUFaLfMyHrhWpGWdAveKTinP/SZNc9sjBzQyuRj4HIk55vRGs32
         Hoi02IgvVlBpn4z4qdMVxujhbYKN/rkPhLUIZ5vyqZ0WCX5fPFlcc++yrEFNaULsUzqi
         b8qHrsk6saqXGz4MjtXgZ+nsKiOCMV5Irop8KUujzV+R1Mm+k0X9Fc9lG8YZ0A3WITYc
         Gppxbwr4oYPDDxgjpU/DVgUXnD8KiwRWbQfv+aYYcf8jpsuzxpFU1bgQJGDJMbHQaZIA
         pbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779207245; x=1779812045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o1eu3n16YxCs7yfqPvAq1HFRibL7XFfKfCzYcR9nV4E=;
        b=b+Am9VszIv72eU1DOGidtWNNdFctwMcUm7sqHC0Z0AcM5rCfKumG0Y3PcOcMuni6YG
         LPotmGuwvSXiF6OijsItuwmbgC7L/s4L7ka9uR5t+XwMUfUzGLT7WQyFqLxWdjDsUYg8
         N3ExGt4qCs19xYShMHlt5GdfXEHz8TQ+d+WMCeJ8wWL1gysSJcVIKDi01fDG/x+2uKed
         SusBl2afqxscxDOMptuSZDv67ECr1t2iRlz+kpOfCG1neyANxyLL6oWJEBWgOrl61XLr
         V3GC8rpMMK/0HMrutKbLx3fyWvKegCdGf0GO1VjV0MhtnIM65vj7WqFyACTiLckzxePQ
         w2uA==
X-Forwarded-Encrypted: i=1; AFNElJ+DddBHz4O56OKWCZ4j2yNvtSAJuKrXPkPT+AJ1zObsEHMaBmvg2oxVWEsZUkSBNMbCGsfPL7y0uyy1@vger.kernel.org
X-Gm-Message-State: AOJu0YwQCVH6fWcXHSW5Z8Ug6A9pc4qDkiFUfy3LrkEAeo0tC81Xx4o+
	jh8uz0WIOVSB/iVqRd50SVmvxSAmc57nyA80k97GPJ3cpoi/s56SeL/VbZu1vQaWdFcnEu6I3eR
	Zsc0apoLPDzJnLRB9toc4rYuFViAKSg0=
X-Gm-Gg: Acq92OFZwbrKjeZdR9z7NM9r5NqojKc5eEe3BvtKR06hTkJdI/RCEt+pXmNi/OrWA+5
	dpJgCnEsRS/3LEekdNwQW+eBsgXZri1anEg7GTRkz9ByJq1HHZb7llkMmeTLLmL+zKO7FfIdaOI
	Qfj/BJFYOYb5+l+iXBEWLY1I9GTZrBaC++BlJ3TH2TaDSykJbifyRf361D8gcdFf9dTMGeRrxmZ
	AFX6XdFTD/aO+VH31tRjcsEo3Lemjdk7p2POVHi18A4Y5B/rv79OFjRR7r5Ib5NuQY2qUM7uIUH
	2BJ52R8srNzIJsvKjoKNIy7bGXRlGqDWx5ZhGpd6O43OP/EiZ7OIyT42gDogeNJtXFXllJMk7nC
	gVi0x/EKHZm/YRrxLE76QwKDTkCi7zSk7JQodpICXsdgbHgIpuVT8nDVRfeirhKOv/J5We//fW0
	hS/pLzIg57NvTrsxcDdPZItQ==
X-Received: by 2002:a05:690e:4183:b0:65e:b05:7679 with SMTP id
 956f58d0204a3-65e2268bacbmr18514013d50.3.1779207245365; Tue, 19 May 2026
 09:14:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260519091805.220902-1-chengzhihao1@huawei.com>
In-Reply-To: <20260519091805.220902-1-chengzhihao1@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 19 May 2026 11:13:54 -0500
X-Gm-Features: AVHnY4KHf7AZhOGK78LxVvdoZCdAOjSBs0Kby4xLNx9155c-De5POEBFZK6rC24
Message-ID: <CAH2r5mtBdyNOqYQEFicOv9P-PAVc23jxK2cw4D7zjLKwmCpNRg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix busy dentry used after unmounting
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: sprasad@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	yangerkun@huawei.com, yi.zhang@huawei.com, wozizhi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

Sashiko had some followup patch ideas, but it looks like no changes to
this patch needed:
https://sashiko.dev/#/patchset/20260519091805.220902-1-chengzhihao1%40huawe=
i.com

On Tue, May 19, 2026 at 4:28=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawei.c=
om> wrote:
>
> Since commit 340cea84f691c ("cifs: open files should not hold ref on
> superblock"), cifs file only holds the dentry ref_cnt, the cifs file
> close work(cfile->deferred) could be executed after unmounting, which
> will trigger a warning in generic_shutdown_super:
>  BUG: Dentry 00000000a14a6845{i=3Dc,n=3Dfile}  still in use (1) [unmount =
of
>  cifs cifs]
>
> The detailed processs is:
>    process A           process B           kworker
>  fd =3D open(PATH)
>   vfs_open
>    file->__f_path =3D *path // dentry->d_lockref.count =3D 1
>    cifs_open
>     cifs_new_fileinfo
>      cfile->dentry =3D dget(dentry) // dentry->d_lockref.count =3D 2
>  close(fd)
>   __fput
>   cifs_close
>    queue_delayed_work(deferredclose_wq, cfile->deferred)
>   dput(dentry) // dentry->d_lockref.count =3D 1
>                                          smb2_deferred_work_close
>                                           _cifsFileInfo_put
>                                            list_del(&cifs_file->flist)
>                     umount
>                      cleanup_mnt
>                       deactivate_super
>                        cifs_kill_sb
>                         cifs_close_all_deferred_files_sb
>                          cifs_close_all_deferred_files
>                           // cannot find cfile, skip _cifsFileInfo_put
>                         kill_anon_super
>                          generic_shutdown_super
>                           shrink_dcache_for_umount
>                            umount_check
>                             WARN ! // dentry->d_lockref.count =3D 1
>                                            cifsFileInfo_put_final
>                                             dput(cifs_file->dentry)
>                                             // dentry->d_lockref.count =
=3D 0
>
> Fix it by flushing 'deferredclose_wq' before calling kill_anon_super.
>
> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=3D22154=
8.
>
> Fixes: 340cea84f691c ("cifs: open files should not hold ref on superblock=
")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>  fs/smb/client/cifsfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index f557eb7875c7..ce23924f01b3 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -306,6 +306,8 @@ static void cifs_kill_sb(struct super_block *sb)
>
>                 /* Wait for all pending oplock breaks to complete */
>                 flush_workqueue(cifsoplockd_wq);
> +               /* Wait for all opened files to release */
> +               flush_workqueue(deferredclose_wq);
>
>                 /* finally release root dentry */
>                 dput(cifs_sb->root);
> --
> 2.52.0
>
>


--=20
Thanks,

Steve
