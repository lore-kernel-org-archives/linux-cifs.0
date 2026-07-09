Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C369242D88
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602720; cv=none; b=dgmzWsKVsWFkBEfatpD3ZTR78kAmR+9ciIDpV4VjkB94JS8HpeU9f8I4zXBnHjGOaz69SE4M9P6RlhrfBv0Ed6nHRRKDk6x0P6YqRS+uoqm3SDh78iHFKtHGR+1UG5WMtk5NZIw/lcpKQZBsqmb2QgeJjIsPtB7TTYL9g/hNuG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602720; c=relaxed/simple;
	bh=EsvryVd9nv8bCsRvfZGiPpqKwAVGQnn9PpzZyzwYYGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nMgML3zEMRXghSKBePWckQLrR8R2J6X4kWvig1B/3P0d8GzVxOuKTI0RjpTk55hB4b2xMA0CFZ1zX/4FUNCNqeY4eitT0eE4JBCbgYWlZQxOVw8myZ52wlhc/TBtADbJBnlvdUEQBKZbza2WUvZeurdwvOr14ybCQS+CCT7DrG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcEF0SBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcEF0SBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C121F00A3D
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783602711;
	bh=orGmfzJTlSy/BsrApon0mqUdNKMi9RuXHob1SkODx58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jcEF0SBniUJZlhKIfZJyZQwnf8BHKMdIspMYNxhrU8NVai9x7tidxMQPpxs3lu0pc
	 MISpnuYHs16fv/DlRZ5w6+msGO4rdK0dJhavn4HdNEDDpXzK4sW9DGFoPyPZDjB1N7
	 Se8MY46lg6yAu8l0spuZk9yTrpHfWpOGEt1GcWNQcZ4LDDKtE91aG7nD9v0N+/s+Vl
	 J8jkj4rVpctO5tAgklc+tsn87pPViled9WD1yNsK8JVRc8DFUqft+ty8UGQvJWJRrs
	 93/tgijoJlyk0j1EXrWjwKtmkonpx4hR6JWZ2IocYrd7Da38QUyRwexORNQnwpGRKZ
	 Acn/7U5mw78JQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15f020a223so55078766b.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 06:11:51 -0700 (PDT)
X-Gm-Message-State: AOJu0YxHk9L9axK4qzx/LO0KwAxJj7msb7W63uIFLPR3H7PsWtuhurCS
	08ZDYuXe2wEXV6kwANAq8ENiw5nIrc+wkIX37EBMTMA7exPcXwYHpz3qzm/7k9dhYdaHRODEudw
	urHODJgIZ6DBs4uivc+K9KMteHSu08TU=
X-Received: by 2002:a17:907:d15:b0:c15:ce72:9350 with SMTP id
 a640c23a62f3a-c15ce729453mr289548266b.41.1783602710306; Thu, 09 Jul 2026
 06:11:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709000548.66445-1-g.blivet@me.com> <20260709000548.66445-6-g.blivet@me.com>
In-Reply-To: <20260709000548.66445-6-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 9 Jul 2026 22:11:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_nNSGuzzm8dF9GvK5tGqsOwE8LiXXdUCg1XQ67e2N8hA@mail.gmail.com>
X-Gm-Features: AUfX_mxrK1tFJXaT_OuAMdFM8N7uqx_b2NPCrsyne57XW0IWlTkabZhs2Hd0C7o
Message-ID: <CAKYAXd_nNSGuzzm8dF9GvK5tGqsOwE8LiXXdUCg1XQ67e2N8hA@mail.gmail.com>
Subject: Re: [PATCH 5/8] ksmbd: report actual xattr value length in stream enumeration
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index ffdae74b6..ca3d4985a 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -5865,8 +5865,24 @@ static int get_file_stream_info(struct ksmbd_work *work,
>                 streamlen *= 2;
>                 kfree(stream_buf);
>                 file_info->StreamNameLength = cpu_to_le32(streamlen);
> -               file_info->StreamSize = cpu_to_le64(stream_name_len);
> -               file_info->StreamAllocationSize = cpu_to_le64(stream_name_len);
> +               {
Please avoid introducing an extra scoped block({ ... }) in the middle
of the function.
Thanks.

> +                       /*
> +                        * stream_name_len is the byte length of the xattr's
> +                        * *name*, not its value -- same class of bug
> +                        * ksmbd_stream_eof() (smb2pdu.c) already fixes for
> +                        * EndOfFile/AllocationSize on a stream handle; this
> +                        * enumeration path needs the same real xattr value
> +                        * length, not the name length reused as a size.
> +                        */
> +                       ssize_t slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
> +                                                              path->dentry,
> +                                                              stream_name,
> +                                                              strlen(stream_name));
> +                       loff_t ssize = slen < 0 ? 0 : (loff_t)slen;
> +
> +                       file_info->StreamSize = cpu_to_le64(ssize);
> +                       file_info->StreamAllocationSize = cpu_to_le64(ssize);
> +               }
>
>                 nbytes += next;
>                 buf_free_len -= next;
> --
> 2.43.0
>
