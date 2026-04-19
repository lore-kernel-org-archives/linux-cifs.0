Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAFC32FA3C
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 07:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776583834; cv=none; b=MRZFBdsxSjdm/RzFVQ3HX29iMO0bqs6+yS3qDIKunDnQAHcGNWphTpFkFYTDkiPB6H77WnOHA18IF5GcBFyD0GD/JaQBI4yD0Dak1Knh2AhRWm9mpI+6IHFHgP5wqVMy972liN/LdSfpmZUqL91d/c3xxdRpJgNkUlwqvMt53x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776583834; c=relaxed/simple;
	bh=wfUrrQBCkecgTuBu9NhgoRwwZHhreWaGejevzpekHV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MMq4iw44pXHX1ps3IWgYrCvQc6My78CWi+Xtx0KSz/jjJEXtE9c0AN7qMUO1/gdyGPKL2/zT8KvlxEuBiPP4P4IpAN03mTZ+F4AmbeVyFPvioYdXUkjxV5+IT/79eBa73z8EATPpRzFfog9+PfCKi07VZL2MCqfH5g4VR91M2hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9QCQs0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9QCQs0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF3BC2BCAF
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 07:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776583834;
	bh=wfUrrQBCkecgTuBu9NhgoRwwZHhreWaGejevzpekHV0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q9QCQs0W1wQHHNT29hVD1QBiQLjImjS7lbViJ+v3WRJXVw8ZpSccCoTT4h6E0CIEi
	 0DFoLPc9ggeTjZJR0z8bProuDBdEK9773UHaMC2OKC4s48h8w9lqLdhi1caTfZCGtx
	 sGB46WgbZrNo84ThqPpNqhrcPMgsVFFtWi9iUlaeiWQDUt49nJCNvwqfTO8I46rlDZ
	 72m4DoJGy8697JlxQZb6qJfPBcB2HDxSQQbioaSTw03MCHU0Ciy4br1gwfWsmAxqg2
	 /2qde9C8p6znyZGF2kx3rruEho2gZkUt6jUI6P1HVdbaPQc0YcY5YHvnz8cBXFQqAi
	 C5oBcA1/7O4Jw==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so3367048a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 00:30:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9Kb50vFX2hgQVPCGq4dswIIOfvn5Kei3whWsz849HvvqZgXs5J3UKmY+aWnb9l63r94ZCP3BrwTz5h@vger.kernel.org
X-Gm-Message-State: AOJu0YzxAHxp7E/iiryAFsNRK16+b4FutW2r2CgPBjDJ52MJnY2LYPeW
	WApAA+JXM8z8Ahai5+ayOk4koytTgcMxY8x5TE9u8Tlhqu/lBprxkHzXxaMuIx59y4+wVJ10u98
	6+MZzECyBRMR+pMjva3ughpR/SXWXqzI=
X-Received: by 2002:a05:6402:26d2:b0:66e:8ce7:5461 with SMTP id
 4fb4d7f45d1cf-672bfdc947cmr4231892a12.16.1776583833220; Sun, 19 Apr 2026
 00:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418172844.1333378-1-charsyam@gmail.com> <20260418172844.1333378-2-charsyam@gmail.com>
In-Reply-To: <20260418172844.1333378-2-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 19 Apr 2026 16:30:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8=ckDwaYgKFZQG80umwKBO1S2UuTWq34qq8hRQ0Nz2tA@mail.gmail.com>
X-Gm-Features: AQROBzBZ6N8P1_138HmLsN8SXaSKKLbOnBVKn-zYmzcS-gbAK7Pzb7AQE19FL6U
Message-ID: <CAKYAXd8=ckDwaYgKFZQG80umwKBO1S2UuTWq34qq8hRQ0Nz2tA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: fix active_num_conn leak when
 alloc_transport() fails
To: DaeMyung Kang <charsyam@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Henrique Carvalho <henrique.carvalho@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 2:30=E2=80=AFAM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> ksmbd_kthread_fn() increments active_num_conn right after accept(),
> before calling ksmbd_tcp_new_connection().  The decrement normally
> happens in ksmbd_tcp_disconnect() at the end of the connection's
> lifetime.
>
> If alloc_transport() fails in ksmbd_tcp_new_connection(), the function
> releases the socket and returns -ENOMEM without going through
> ksmbd_tcp_disconnect(), so active_num_conn never gets decremented.
> Under memory pressure, repeated failures monotonically inflate the
> counter until max_connections is reached and new clients are refused
> indefinitely.
>
> Decrement active_num_conn on this error path, matching the accounting
> rule used by ksmbd_kthread_fn() and ksmbd_tcp_disconnect().
>
> Commit 77ffbcac4e56 ("smb: server: fix leak of active_num_conn in
> ksmbd_tcp_new_connection()") fixed the sibling leak on the kthread_run()
> failure path; this patch closes the remaining one.
>
> Reproduced with a debug build that adds a temporary module parameter
> guarding an early return at the top of alloc_transport(), forcing
> the first N accept-time transport allocations to fail:
>
>   * Configure ksmbd with "max connections =3D 3".
>   * Force 5 successive alloc_transport() failures at the accept path.
>   * Without the fix: active_num_conn drifts up to max_connections and
>     subsequent legitimate mount.cifs attempts are refused with
>     "ksmbd: Limit the maximum number of connections(3)" in dmesg.
>   * With the fix: the counter is correctly decremented on each
>     failure and legitimate mounts continue to succeed.
>
> Tested by injecting 5 alloc_transport() failures with
> max_connections=3D3 and verifying that subsequent mount.cifs attempts
> still succeed on the patched kernel while the unpatched kernel
> refuses them.
>
> Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
> Cc: stable@vger.kernel.org
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Looks good, but Michael Bommarito has already submitted the same patch
to the list, and it has been merged into the ksmbd-for-next branch as
shown below.
https://github.com/smfrench/smb3-kernel/commit/6551300dc452ac16a855a83dbd1e=
74899542d3b3

Thanks!
