Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA0E370D7B
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784301036; cv=none; b=i0shVK+NUrDnvGXLaBYD6ck+ODBkJ0jqyC8VHgKj/2mMvhFjTOZHdWOIdtHIoDcR1gt0uo7BI2xPfYHf7MiAQMfY+Q3uo9HS4fUFjHCuCSLwxtgOZPJvHY7v/QWEz6/hE6IRhRjyHKv3Wzz0UzGwSzOSH2VQ51Pc0DMA7lkOwCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784301036; c=relaxed/simple;
	bh=G4WYwL8mJIo7yQBZcDBeTX0iTvqgsUkizXJA6cWHQ0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P4UbKn7itBnoaDKdjpELJgbN6gC/UXf2JGt7ANVCtoOGP/6wgk4bYe8ZJ4vtQea/cjv+mgYzoiwmcxZWvl5f9f3oQpB6eMZQ/JnuBt7SH8lsv6tb8k9hMpqFgb7bXkogc1xcE3K8W2yNB3nJZv/LOETVJWpuVJW5W0BuuhV1yNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICAEfm2Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICAEfm2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5E21F00A3D
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784301034;
	bh=G4WYwL8mJIo7yQBZcDBeTX0iTvqgsUkizXJA6cWHQ0Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ICAEfm2ZjVR9qh5gJ9Fbp5RwGRAC4MldswUbyHXu/F23ZH5JKhAXmdYpxrV5KSknP
	 2LwQ3MghI9/0r0T/RCv7wbkFbO0mZmZGMrAhL7vUCkdo0XbbU0oGErTiefFMzVfTrP
	 rHH5cnwOJXiLe6+y6VvnsN3RFTUxusuP4tn2d3n2w/3aEGcgLmVaTgtsDFQlFNjWOX
	 M+AFfEIWFWkm2l83FKmFqw6AAtjZAddhPKNvvMf4FI1MaORFYclICoZxTbFdT7gzga
	 53xqDb0t6uSGmWAsQbMRlbHaNGOopancrSj6zpP66+BVxBX7aYDUI+umnYuPBxeuEE
	 o3fG/KBeidvVg==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8114a4542b2so26900067b3.1
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 08:10:34 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxrw+ypslbKdkrxDEpjzK4s7J69+JjGHTYTyS2cbZEBQQbHr/JD
	soLOfUkMZF2gdYXdjsGHAyEmvRFDC+xtt/kGsnUHmaOJNkvfjj0TL3gaWN1nRwYfrOXjZtV6SDe
	jsfFjJO80oOJbXADrUBc3Pbhx6WCM3gI=
X-Received: by 2002:a05:690e:2062:b0:667:8b91:2424 with SMTP id
 956f58d0204a3-6683be0445cmr633766d50.107.1784301033914; Fri, 17 Jul 2026
 08:10:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717071508.7297-1-g.blivet@me.com>
In-Reply-To: <20260717071508.7297-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 18 Jul 2026 00:10:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ZdZYiNM0WxYL67+89Bsz-oLhL9GLyM_9_vOkrKnbx6w@mail.gmail.com>
X-Gm-Features: AUfX_myyYXB97cVDEl1lMFWZYZpNoe0xdRZzAGXnkRXtQZl89PcEjsPJvSuEo0s
Message-ID: <CAKYAXd_ZdZYiNM0WxYL67+89Bsz-oLhL9GLyM_9_vOkrKnbx6w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix maximal access leak when object has no NT ACL
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 4:15=E2=80=AFPM Ga=C3=ABl Blivet-Bailly
<gael.blivet@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> smb2_open()'s maximal-access handling sets maximal_access to the
> FILE_MAXIMAL_ACCESS_LE request sentinel, then calls
> smb_check_perm_dacl() to compute the real access mask from the
> object's DACL.
>
> smb_check_perm_dacl() returns success without touching *pdaccess when
> the object has no stored NT ACL xattr (ksmbd_vfs_get_sd_xattr() fails,
> taking an early goto err_out with rc still 0). This leaves
> maximal_access holding the raw FILE_MAXIMAL_ACCESS_LE sentinel instead
> of a real access mask.
>
> Observed live: a freshly-created share root shows macOS's "no entry"
> (prohibited-access) badge on connect, even though POSIX permissions
> clearly allow access -- macOS requests maximal access via the MxAc
> create context on every share-root open, not via DesiredAccess, so it
> trusts the leaked sentinel verbatim instead of falling through to the
> correct POSIX-based path.
>
> Fall back to ksmbd_vfs_query_maximal_access() -- the same POSIX-based
> computation already used for the DesiredAccess-requested-maximal-access
> case below -- whenever the sentinel comes back unmodified.
>
> Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
> Assisted-by: Claude:claude-sonnet-5
Applied it to #ksmbd-for-next-next.
Thanks!
