Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94A93D76
	for <linux-cifs@vger.kernel.org>; Fri, 29 May 2026 00:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780013120; cv=none; b=T/QtG7U/FWHAfl/HGRdZ8NAbfm/PmdnwldIB/sE06YKEawDx1IVPQyQ24Mbzeayu9qVDIeBU326ZyRb9nAyuP3UJNh4jugou74WyiWlp8mljuzP76GrlWHTfVOwtWEPNtOxXyJYUX9+jt5Tud0TKKIX53koBR6VoX2hAn9D1MmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780013120; c=relaxed/simple;
	bh=v30IPAXJubwri/kbd76T+RGLrbOjnftJb7rYRRx9bE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jvPlER6DJRXIQe4+01rYulIUy1HZdWPkAEtvsjP0u3lA6eSpD3snQarxObEn4USrpvRUcHp6WNC3vjNhp1dxIZxaG6EdXI9bvsqO7wyCz5mQY77Z/+nNbhZx0m7ckArLn8YfCQwyJNJ6znpf1M2RG/cWetx1xApTbOzEpVNGbMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjdLf5zx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjdLf5zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5081F00ACF
	for <linux-cifs@vger.kernel.org>; Fri, 29 May 2026 00:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780013118;
	bh=v30IPAXJubwri/kbd76T+RGLrbOjnftJb7rYRRx9bE8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LjdLf5zx30e5r+HoKD/wk9qisJ0ov8MQjsGzKUxq6UzaDfAaJUhW26dkleYFpYWpm
	 PmsZpZRvYH7G6/0QAfj3sORlVX0jVknwWNx+e7bzi373W606Gm+3IPmoTp7fbtl07P
	 d0zxW7i/T7Y6ZwguiS2SznzA6zKEOYYAPFAJbqkj6/UGUckkHfnln+1/vgyKEHDbVW
	 03yJq/rZHGZ0K8pWIbj7OQrIBlpLkZDeUrxzRsZEbEEI6zaHJGek9iRVSrEX7YIDOu
	 qUWCfyhmVxDycXxJ7+osAATQXL6oudWuJg/B7peBRtJTsysSVHTycw6li0zfJeIQph
	 l5EM2sCcZgOlg==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-68b73f1a8ebso1559914a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 28 May 2026 17:05:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9daMlX9qrIhCFUG5FJ8xM8OK3peNLjFtU8QrzlYAj/JbH+zry7PK+pTeYG9s2I2923+EOX1rgNFPn3@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdo9/CvigncoFWOW+pDuWnClervGECjWLy8lge68YvqcmOeCJT
	X9mdZE1h7az2iGzE9Zp1l324TR/CLJFZzDRep4STRtqVVbEwr3qTf3ga1a9jdpDaMmxe4rOfeU9
	FIKOHgH1OrkBCiLnfCIl6IrJlmm158Dc=
X-Received: by 2002:aa7:d98b:0:b0:67f:97eb:b0ef with SMTP id
 4fb4d7f45d1cf-68c10e750c3mr108247a12.15.1780013116959; Thu, 28 May 2026
 17:05:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260528175854.57626-1-jkoolstra@xs4all.nl>
In-Reply-To: <20260528175854.57626-1-jkoolstra@xs4all.nl>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 29 May 2026 09:05:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_S1J-xXzOJ66HjuEQB9iwJdM261_5pbsAGrksuYcn4Kw@mail.gmail.com>
X-Gm-Features: AVHnY4JmsCSLoCE2OhoYjXmAv19sHGEKdfCVwK9RIWLD2LzuEYGX49UCyRw5v6Y
Message-ID: <CAKYAXd_S1J-xXzOJ66HjuEQB9iwJdM261_5pbsAGrksuYcn4Kw@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: make LAST_XXX private to fs/namei.c
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SMB3 SERVER (KSMBD)" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 2:54=E2=80=AFAM Jori Koolstra <jkoolstra@xs4all.nl>=
 wrote:
>
> The only user of LAST_XXX outside of fs/namei.c is fs/smb/server/vfs.c;
> ksmbd_vfs_path_lookup() calls vfs_path_parent_lookup() and expects a
> LAST_NORM last type (or it will be ENOENT). ksmbd_vfs_rename() also calls
> vfs_path_parent_lookup() but forgets the LAST_NORM check.
>
> It does not really make sense to have vfs_path_parent_lookup() expose
> the last_type because it is only needed to ensure it is LAST_NORM. So
> let's do this check in vfs_path_parent_lookup() instead and keep the
> LAST_XXX internal to fs/namei.c. This changes the ENOENT errno in
> ksmbd_vfs_path_lookup() to EINVAL, which matches better with how this is
> handled by callers of filename_parentat().
>
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
For ksmbd part,
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
