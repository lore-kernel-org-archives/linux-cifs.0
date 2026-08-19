Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2186426D2E
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 10:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135859; cv=none; b=uYbJx7pT8i8eWrPPWxBmKOZF/xV5/iIHWytT/EpJKPBwhgV0Ut7QYF5h742BqnLlPfzPVVautT3f+eqGMKuJwBML6eyfpZg/hWlUC6yQahrMDzDv7IPFKWLgmSlwUTSVUrT7WnzCOMHctnBDWJecaTXxT+i4plR624OU+PotFE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135859; c=relaxed/simple;
	bh=f4abwxj+6IRGtj5UDh/91NmYkjkKLDQL2QW7oyWZMTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nORxsGrYova0xBfcJdKxzXrsvY9cob85V0G51yqD/Z1ahEGA0GqOMdRGgQK+0oglKUhoWdN2ikKCmEJp8ntdyCq49MVQNnvBXAts1Sk/z1/Ou6pR63O6XZexNjMniCLjZ9i+NlFwG7wUA4mXbiw+eq2HT/6mE8fQ2dIqRLcctKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJIVXzJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJIVXzJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7803C1F00AC4
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787135858;
	bh=lpCqLguSWexNPQljcRiS0oqXgQCWU7b7AKm+8KS0Kcc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bJIVXzJgWmNVCp7v7oo87w/jexgHtVeXj7TT2WYRf6+7/o+5+l3BB38QbPMiO8klj
	 +q86ljJe7++B6OD6xMc9/kFHz0alDib813IZPebYPlhbIXJ2QwduVAHI+TzQk7GVU+
	 A670N+P8FbSKqJAPD2nhfg7YL/H7I9Z0LrLEdNyZlEfQjrUUyR6OjC1gBZfRJF/FEg
	 m/PcRqWJvha0sr6bN8xgeC1QNLJfnCbKQ4143QFOGAmEaNmwzKK23/cNh0ux1kxz0k
	 Hi2EHGi9YxT3pxJpe+QuxnRN5dB1xeWaIN/xthLNLaJ62QHbc2G3bIDuoNAbC4iH9q
	 PoGXfFNIcdB0g==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so967503a12.2
        for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 03:37:38 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywbxdtxxs9o0lPSFFMjkME1m9B85ZAB6HLgM75uGnDrz/L18V5H
	fS8y5DUhmckgEDIxu0YHhy1qDNmM2btucUcZdusEdmD9CC/BJIqohhKIcc31E2JP5p8zduDyEvq
	bm5xLYEeZvGNhxaBRLzyKuiiDs7OukVs=
X-Received: by 2002:a17:907:c398:b0:c16:4e5:944a with SMTP id
 a640c23a62f3a-c242e6e3e5bmr265110766b.21.1787135857058; Wed, 19 Aug 2026
 03:37:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260819090905.12448-1-suruurism@gmail.com>
In-Reply-To: <20260819090905.12448-1-suruurism@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 19 Aug 2026 19:37:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Hd9gQNMTxUM+z0E9B2uF0AmkDGg7-JnN8mFJg9Yeh+w@mail.gmail.com>
X-Gm-Features: AcwNN1U8uJs7m0HUkdTLMvEG0m53uOSqHM-Vhs5aYjDSa4Q5yNnVjq18oiUqJ7E
Message-ID: <CAKYAXd-Hd9gQNMTxUM+z0E9B2uF0AmkDGg7-JnN8mFJg9Yeh+w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free of lease table in smb2_lease_break_noti()
To: Abdifatah Suruur <suruurism@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 6:09=E2=80=AFPM Abdifatah Suruur <suruurism@gmail.c=
om> wrote:
>
> smb2_lease_break_noti() redirects v2 lease break notifications to the
> client lease channel by reading lease->l_lb->conn.  The lease table is
> linked into the global lease_table_list and destroyed by
> destroy_lease_table() on connection teardown, which unlinks it and
> kfree()s it under write_lock(&lease_list_lock).
>
> The break path dereferences lease->l_lb and lease->l_lb->conn without
> holding lease_list_lock, so when the owning connection is torn down
> concurrently (e.g. the client disconnects while another connection's
> open triggers a lease break), the table can be freed between the load
> and the dereference.  This is a use-after-free read of struct
> lease_table; the stale conn pointer is then passed to
> ksmbd_conn_releasing() and ksmbd_conn_get(), corrupting a refcount on
> memory that may have been reallocated.
>
> Take a conn reference and perform the lease-table lookup under
> read_lock(&lease_list_lock), matching the lock discipline of
> find_same_lease_key() and lookup_lease_in_table(), and transfer the
> reference to the async work item instead of re-taking it.
>
> Fixes: 2145945feb2c2 ("ksmbd: route v2 lease breaks on the client lease c=
hannel")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
We have a better patch below.

https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/commit/?=
h=3Dksmbd-for-next&id=3D3a98de41b0a4d80e0aa57f677f7592e5f5321613

Thanks.
