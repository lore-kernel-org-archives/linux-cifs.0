Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE6B1E5B9A
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780755130; cv=none; b=cAol2ia3i9Fo1XLsBBJRd6OccyI1PfZTfqO0G2xY/ElMXS9ujGA5cpMpszKd2Udz/aeDqGuvB5lCBmBTn4Ka6wtW+RTX/YtBZlOhF9l7rmYoNaV08kFuB0BLScHRHNOILJcbUj85tJDv2N/aInB2agjEBA2ySC75Hfz3vWHAkx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780755130; c=relaxed/simple;
	bh=I8ugM/xxqiwstLCulXWOnbNLpq/YVoN0IuoyB4wdQVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtyKSZq6xrHexlHDN2FAtovs1TojAYxtlDRLPZ2r4KZ6rQFP8xWHEf+u0cqpwMeq3JqNxWG6STWFWVq7dkcsz6WcjVapX8nEVXDBPvtl1kT2tZ31sO5NLyWa/rfO632UnHygb3VDLUCNdItlb08/ATgSct/uoZ0tpURSf7CWMgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtzleKHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtzleKHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197F51F0089B
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780755129;
	bh=B65uzVUVni5CijrC1bZJvDMaaUt3ONjcLd0PmXx0XZI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KtzleKHZnsNwjQwzba0TmK2UYrIPl2V+gZVfa0HNdkFLrM6RhrT7GaS65kMARM5xN
	 2yzEB09g+IW6d0Pg/FhylLbj5vmKtUIw3AckzqeOorEUF9+sQjIwQ7gUKUEyECr8Ae
	 mC8ZZmdAq3su/n1c+TYp7ofSBt6b3yTGP8pbLRba4LJVY3qt+mIXsxUxJjHPGAEIg4
	 Ylw/2ZZmk/D4pjSEevAwIapuNZfxo4GOOqXsL1xtNcHDmeldpJmXGb7tOyAXR2Vtes
	 1FS/u2qV8WxB6G3SJgG11wV77n7wCjVxG1zHEtLrCcDT4CNT6qqfEqXMF8vBmv1v98
	 SZe4tMzmKSQvg==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-68bd9fce347so5106408a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 07:12:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+r+drRm/inRzzzIBZhqzzqc5GtnTGY8zzufT+79BmZf5ewFd5t0BMy8yar8dC86CjrtO1Ubw8kuqh+@vger.kernel.org
X-Gm-Message-State: AOJu0YyQqFEfdRsitHrLLKkzGeNhKL6R8kbq/w/1Z2UpQFhD/yFTKT/X
	L2j+XPHOzZEpDwSlxtGmUkL0m8LKj+4eWFYpTtzlpMOYmollJodAxo5AYZGZWnNy1t1+FqpX/MU
	46INk6Geczk+R1Mt+20zJASH1uUvDXcU=
X-Received: by 2002:a17:906:cc59:b0:bee:215e:5486 with SMTP id
 a640c23a62f3a-bf3725405f2mr296858866b.36.1780755127674; Sat, 06 Jun 2026
 07:12:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com> <20260606092601.299698-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260606092601.299698-5-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 6 Jun 2026 23:11:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Ls0jSyH_bHvEMjgGivBpHLcEk=J-Ts70jjMNdUTWnhw@mail.gmail.com>
X-Gm-Features: AVVi8CdNDly_HMQfFBgYjkZcqNWQdJ0OvjvCtMGub58Q9aaHtQ0FRvXO3LM18WY
Message-ID: <CAKYAXd_Ls0jSyH_bHvEMjgGivBpHLcEk=J-Ts70jjMNdUTWnhw@mail.gmail.com>
Subject: Re: [PATCH 4/5] smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +int ksmbd_vfs_set_compression(struct ksmbd_work *work, struct ksmbd_file *fp, u16 fmt)
> +{
> +       struct file_kattr fa;
> +       struct dentry *dentry = fp->filp->f_path.dentry;
> +       struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
> +       u32 flags;
> +       __le32 old_fattr;
> +       int rc;
> +
> +       if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
> +               rc = -EACCES;
> +               goto out;
> +       }
> +
> +       rc = vfs_fileattr_get(dentry, &fa);
> +       if (rc)
> +               goto out;
> +
> +       flags = fa.flags;
> +       if (fmt == COMPRESSION_FORMAT_NONE) {
> +               flags &= ~FS_COMPR_FL;
> +       } else if (fmt == COMPRESSION_FORMAT_DEFAULT ||
> +                  fmt == COMPRESSION_FORMAT_LZNT1) {
> +               flags |= FS_COMPR_FL;
> +       } else {
> +               rc = -EINVAL;
> +               goto out;
> +       }
> +
> +       if (flags != fa.flags) {
> +               fileattr_fill_flags(&fa, flags);
> +               rc = mnt_want_write_file(fp->filp);
> +               if (rc)
> +                       goto out;
> +
> +               rc = vfs_fileattr_set(idmap, dentry, &fa);
> +               mnt_drop_write_file(fp->filp);
> +               if (rc)
> +                       goto out;
> +       }
> +
> +       old_fattr = fp->f_ci->m_fattr;
> +       if (fmt == COMPRESSION_FORMAT_NONE)
> +               fp->f_ci->m_fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
> +       else
> +               fp->f_ci->m_fattr |= FILE_ATTRIBUTE_COMPRESSED_LE;
> +
> +       if (fp->f_ci->m_fattr != old_fattr &&
> +           test_share_config_flag(work->tcon->share_conf,
> +                                  KSMBD_SHARE_FLAG_STORE_DOS_ATTRS)) {
> +               struct xattr_dos_attrib da;
> +
> +               rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
> +               if (rc <= 0) {
> +                       rc = 0;
> +                       goto out;
> +               }
> +
> +               da.attr = le32_to_cpu(fp->f_ci->m_fattr);
> +               rc = ksmbd_vfs_set_dos_attrib_xattr(idmap,
> +                                                   &fp->filp->f_path,
> +                                                   &da, true);
> +               if (rc) {
> +                       rc = 0;
> +                       fp->f_ci->m_fattr = old_fattr;
If ksmbd_vfs_set_dos_attrib_xattr() fails after vfs_fileattr_set()
succeeds, you only roll back fp->f_ci->m_fattr and return 0. This
leaves the actual filesystem with the FS_COMPR_FL flag enabled, while
ksmbd's attribute treats it as uncompressed. If the xattr update
fails, we should either properly roll back the filesystem flag as well
or don't roll back fp->f_ci->m_fattr. I prefer the latter.
> +                       goto out;
And no need goto here.
> +               }
> +       }
> +
> +out:
> +       return rc;
> +}
