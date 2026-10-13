Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66C554094
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 22:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929861; cv=none; b=Ir1/pfT3KDgKPaYTuDw40iJ9LE+CZKGAfFk+f0hUPU8faJw25u7YiWnL87VRVww1OZ2JnxEFDE5/n6w0ZpjzVIsYMMZGcqnx8Q2L9m6t70C8BuToWYE137+P8mBWxTiDDM/eBLW7/TfDRzkhj+mvp7hhclSO4RdR7w0VGpwz3Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929861; c=relaxed/simple;
	bh=JtGF+FGtGT9RJmbUsrjkUwxXXjE5+XdonvoAN0D6Vtk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M6DIoBZLJDWz28tBJq6NeOjFlAiaBtTPJ9Cjv1jjSSi5hjY/8vstM6SA+FRpiRMTHwhpQP0L2CuLsKGV+N1AvXLcy9N5Lx2wTychA8c5Q4ZvDWsKLiDq/y+p0/OeE0qF5Mb2MFqxKuFqgVjY/iRbPah4jL7L8eqEpfIwSGHV3CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2D18dtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2D18dtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A041F00898
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791929859;
	bh=CwKVUc54TR9GsNV4uLfAlgqoISPW2GwsvXsZrez6iv4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=E2D18dtQa6ysXE4OT2W7Qpz65wSpEJE5eQ+tnL0q3MUziJ0J9iSIqpMzDpOng8kYS
	 PbSao/fGFPIf9Xu2l09Dsj2JCJ2rwleAlhetmV816T+uLpSBTdXkmMRuZ9uNZiaIm0
	 eKX3xSbgyE/Zr2J2j+mnP8W6KHO/CkM6dJ05ysy3Kp3x2mOGN38yGd/MyNNgoIsqQ/
	 pBczAW4oKC9hqiIC93aN3rwVquZuJAPCPiD5ZnXKPdDASadvz1MnbwC2RvNBwYk4N9
	 INEI92XA2FlY3xRUXguPPEwfGL5MdP2/IIl3AIASWLjNaIz8nGhhWlVFJU0NoP4KZ1
	 cJxPBP2U+t4/A==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c315869241fso60411566b.0
        for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 15:17:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxtXfOmrWGg5dAxHwyJPqrmq9tntJu7i5GHwytdn0W4ty9ZLa/1pR6hFZDurSTLU/qLetighs7jDaRD@vger.kernel.org
X-Gm-Message-State: AFq9FYI/7SiAP+2zlANtfH2iQ/EPTUQ48ZCMFQqvWql+zrLsbopZUVp5
	NV1w2V6HONCEHF7LpdoWjZOOFAO3V+6QykDBuwXAOeFHVxhps0XAbN6k3W2PNGkkdSnhcBPm8AY
	lLs6hrTlhO5G0wYqz7uh23Hxj7KX5SrQ=
X-Received: by 2002:a17:907:7296:b0:c2e:4f16:fbf with SMTP id
 a640c23a62f3a-c31a9f8af14mr1310034966b.31.1791929858333; Tue, 13 Oct 2026
 15:17:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011115239.1588419-1-charsyam@gmail.com>
In-Reply-To: <20261011115239.1588419-1-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 14 Oct 2026 07:17:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_50E7cH51hxKi9xWfE3Hjyj0PhwccgsuGX416pEJVs8A@mail.gmail.com>
X-Gm-Features: AclHuK8OAWGwLoKzQBG0D3Oot1tstax4BO8bMIAe_7E41NZ5nv9FGQK9zZI9jhc
Message-ID: <CAKYAXd_50E7cH51hxKi9xWfE3Hjyj0PhwccgsuGX416pEJVs8A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: truncate files before allocating space below EOF
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 12a43efdb53f..b155a27eaeac 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -8533,23 +8533,15 @@ static int set_file_allocation_info(struct ksmbd_work *work,
>         alloc_blks = (alloc_size + 511) >> 9;
>         inode = file_inode(fp->filp);
>
> -       if (alloc_blks > stat.blocks) {
> -               smb_break_all_levII_oplock(work, fp, 1);
> -               rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
> -                                  alloc_blks * 512);
> -               if (rc && rc != -EOPNOTSUPP) {
> -                       pr_err("vfs_fallocate is failed : %d\n", rc);
> -                       return rc;
> -               }
> -       } else if (alloc_blks < stat.blocks) {
> +       if (alloc_blks * 512 < i_size_read(inode) ||
> +           alloc_blks < stat.blocks) {
>                 loff_t size;
>
>                 /*
> -                * Allocation size could be smaller than original one
> -                * which means allocated blocks in file should be
> -                * deallocated. use truncate to cut out it, but inode
> -                * size is also updated with truncate offset.
> -                * inode size is retained by backup inode size.
> +                * Truncate before considering allocation when the new size is below
> +                * EOF. This avoids allocating holes in a sparse file just before
> +                * shrinking it. Also release excess blocks if EOF is already
> +                * smaller than the requested allocation size.
>                  */
>                 size = i_size_read(inode);
>                 rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
Using alloc_blks * 512 for fallocate() and truncate() doesn't look right.
MS-FSCC section 2.4.4 describe:

"The file system rounds the requested allocation size up to an integer
multiple of the cluster size for nonresident files, or an
implementation-defined multiple for resident files."

And the truncate branch skips fallocate(), so it can return success
without reserving the requested space. For example, if a file has data
only at offset 1MB, setting AllocationSize to 512 KiB removes that
data. The file size will be 512KB, but the file will have no allocated
blocks.


> @@ -8559,6 +8551,14 @@ static int set_file_allocation_info(struct ksmbd_work *work,
>                 }
>                 if (size < alloc_blks * 512)
>                         i_size_write(inode, size);
> +       } else if (alloc_blks > stat.blocks) {
> +               smb_break_all_levII_oplock(work, fp, 1);
> +               rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
> +                                  alloc_blks * 512);
> +               if (rc && rc != -EOPNOTSUPP) {
> +                       pr_err("vfs_fallocate is failed : %d\n", rc);
> +                       return rc;
> +               }
>         }
>
>         fp->allocation_size = le64_to_cpu(file_alloc_info->AllocationSize);
> --
> 2.43.0
>
