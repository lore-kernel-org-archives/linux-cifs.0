Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B2B20FAA4
	for <linux-cifs@vger.kernel.org>; Sat, 13 Jun 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781322766; cv=none; b=VY9k5/6u90JGNEt1RU6tfDYpkSg2YNLM2vPw/FwUVUyGF6V7raxA9o9yfTwdxC51uuZ3xGKEny3bmU9/9fw1I0fUyOA9kxtAgiMeSWiXJgKdKj0Yxqg1JRKnkddnSpsrpQdVC7UibBb+75k/Alsiw/Sgkh0wwOTgoqqFKQfNO8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781322766; c=relaxed/simple;
	bh=pzpCVBiQNJ2Axu252bsZd8uoI06haKcXK8kRUrys/qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mze8jsCn+kCI9buCOYiTFoMeSMGTPSYdpTOj4j9J99smrR8wV3m7JodlHwNAAKHZkvc0+2UGPrq3L8aXHoMcXWvGiKTEPzjosh60r9oL9o8L1l75uRbcTJUKsfqj03I0j7ZuxjQ7/P+bldf+jX5e4kFfRoxlzvAOSY9AgjLpqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxNVEF7w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxNVEF7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C126A1F00ACF
	for <linux-cifs@vger.kernel.org>; Sat, 13 Jun 2026 03:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781322764;
	bh=ba1qAPHVQTkAy1tGcRVUliFqgdqLmwqnnccwHPkCjBo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gxNVEF7wCLLlMYEYwtII9VCfiJ1B9z8kGzSnA+q6A0x/MCVuq4XaPE8uUGwGBHIKp
	 8MglRR7k+W7gjAr2oc3qC5aUEHQwXxMeJeE2bDQIMJ3Z/cc6T4DouBK+EBIOUY2EB0
	 BBvW1bQFJGHjdc3sujLDxgiSjotPR+98v/vZfUdZth00uaiHUwOBSVTM98JAAnZDZB
	 Ejn3pl0VBT5v9njwSlwYAZmMeB2dekFzHiim28JHFieP/tgA7iyqXwPDALlhVHd2nW
	 44LRW3LRf5/inms3oMtDjEMnCi0U8goxzki8iEwb+hH0iUjjmzfq6zdgyllIuiZpmM
	 P+ahLVa+EEKLg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec354815b9so158590066b.3
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 20:52:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+x64CbPCNO7EzJNMKZ1nNR4TPdo3vbzboha9qqx3txPjZk51nT8grRPyd/ePXBL8PS0DFh4h0RwbPZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxKNnHeXOYb+Md1bO4HjeNp0l+x65XHim0fHR8wI1TBjlkvOpnO
	NyZsis7vm8qw7nk6rEdQsiJyX+El4BQ0HOdJwqDzB2/yKwh7cxZyFN3hqJnwARE5W674JJHzsg1
	dA4hlGI0eJrrDjeO33tY7zV1zAp/J2XE=
X-Received: by 2002:a17:906:8456:b0:bea:5ce6:4267 with SMTP id
 a640c23a62f3a-bfe29328ba4mr191916966b.35.1781322763503; Fri, 12 Jun 2026
 20:52:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 13 Jun 2026 12:52:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
X-Gm-Features: AVVi8CeLpJjwkieKN1sCQpbvMq-Q7p1KEBwCAPouDCJldAHCGNXcwGGNQ9uWQHw
Message-ID: <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 00033c4a5eb5..251dd6bfb06a 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -718,6 +718,16 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
>                 goto out3;
>         }
>
This check is also applied when SMB3 POSIX extensions are negotiated.
POSIX rename semantics allow replacing an open destination while
existing file descriptors continue to reference the unlinked inode.
The check should therefore at least be skipped when
work->tcon->posix_extensions is set.
> +       if (d_really_is_positive(rd.new_dentry)) {
Although destination share-mode enforcement appears to be missing
already, rejecting every open destination would also reject the valid
case where all existing handles permit FILE_SHARE_DELETE.
> +               struct ksmbd_file *target_fp;
> +               target_fp = ksmbd_lookup_fd_inode(rd.new_dentry);
This can incorrectly reject a rename when the source and destination
refer to the same inode, for example through hardlinks.
> +               if (target_fp) {
> +                       ksmbd_fd_put(work, target_fp);
> +                       err = -EACCES;
> +                       goto out3;
> +               }
> +       }
> +
>         err = vfs_rename(&rd);
>         if (err)
>                 ksmbd_debug(VFS, "vfs_rename failed err %d\n", err);
> --
> 2.54.0
>
