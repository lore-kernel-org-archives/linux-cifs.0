Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A832223D283
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 02:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787968907; cv=none; b=g1Wuu/1kLha6QIDcaFm7Cac09AAgrH6kFDt2M6NQIvxdqT9XsrAexv0cHCURGIPjZz/6Vvu8ace8V8+YPP8m883PDxJTKRjzo7jabNShI5Q8oEmMZWJo++EV9M22e02vZAurGRxZtEdw/M9w57I8ZXzpa5xKZU81KyAHml6G8xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787968907; c=relaxed/simple;
	bh=OqpKpqqD+UM1Z1l0If2qv3BrTIjKEP32JUi/fwJP15s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P9j2vg5/zP1947KM8kKGPF8TWCLj6SnjVgU9jCi+xVuiXh/zd+odIJOM5w+UQYzeT0GH+Yb++CLQAYAJ6bvQQx9D8gOjXnLaOq8FdzGPZDRtCgIDU70fMwXe94yMDAlmVjS0GGkVNBT1eBK5ZRDHvivSntzHm69gWj1B/Aws18M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEB2fb0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEB2fb0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383661F00AC4
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 02:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787968906;
	bh=jlpGyhwXjesf6ZnaWXrXznCduD1TII085tibm+6tLy4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JEB2fb0+ULPJFC0DsNSRec4qCqXrn/Z9G4touKLrfSe+R7kJMK9Nbj2gHBLLdbZbU
	 scj4xfJn/XoqG5TocdlQbHp4yEDDAXWKG7vJMirT8Pifkxszo8EKyj2x/6OPnzMF5U
	 Ib3llH3DoeEfvp0Z5jDGVSz9PkW1gH4o9KFDfwCftrtXDPE47RR+o3zgCF4o15NI7z
	 P49WvFyrNBuD6MTYcn/GmOJdeAtSd75afhpVngEkgVNmVuMkbTP0+BJvyuRKgRTWIX
	 Cj4v2QyJnHvBqBuVo/OKXVmgi+oPR0//NV8HGhyUQr1Q3IXplH8Wo8ZPTV+Lghi9nM
	 gsGp9KG7de5aA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a611ba5130so1845580a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 19:01:46 -0700 (PDT)
X-Gm-Message-State: AFuF++nDFSRfjwE9/n85U6ASGpRivTHuZIeemvmOwVb9BJ7FVlzf8Bea
	4Jk9BfGslHGN7N1nSU9jW/srO7f9a5YCBk6aOQofisbT8b6yaZZoCR9DUMl9F5SyhykGp+6glua
	iP6dG6FT9hrfkHLzHgR8zrUqWthFJQl0=
X-Received: by 2002:a05:6402:4586:b0:69a:b38d:403c with SMTP id
 4fb4d7f45d1cf-6a60d38def0mr7715469a12.7.1787968904831; Fri, 28 Aug 2026
 19:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828231211.252093-1-pc@manguebit.org>
In-Reply-To: <20260828231211.252093-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 11:01:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_cR_WAd-3iRW_KJRmSBKxNiSuGvjNXXk33pG3Z_2dBvA@mail.gmail.com>
X-Gm-Features: AcwNN1VILaKDOM4dtcNgoljXB7_rqvgCW88YptLIe-XZhSXePPIxbmQybTfk-h0
Message-ID: <CAKYAXd_cR_WAd-3iRW_KJRmSBKxNiSuGvjNXXk33pG3Z_2dBvA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix data corruption with concurrent writes
 and O_TRUNC
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -999,42 +999,50 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
>         struct cifs_tcon *tcon;
>         int rc;
>
> -       rc = filemap_write_and_wait(inode->i_mapping);
> -       if (is_interrupt_error(rc))
> +       rc = inode_lock_killable(inode);
> +       if (rc)
>                 return -ERESTARTSYS;
> +
> +       filemap_invalidate_lock(inode->i_mapping);
Should we also take filemap_invalidate_lock_shared() in the
page_mkwrite path to serialize mmap writes with this truncate path?
