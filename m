Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45BE244661
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602820; cv=none; b=PQBcVEu8m0R5VRPeq+XEOaPm7/OUVRhKkf+RWRfNYHvhsmExG1gK+pUyGHDPLoSgjLkeRftA6UPGLCpMepqZhNgzTRy3/X4KvrSrqdsz9iMFoE3T7sD9VgVEUR6nsOZZN0AC5BzCJhrXcY9s/vds+P+sahGIHB8H4ND6JC2UxDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602820; c=relaxed/simple;
	bh=W05j3Ev9nopMG3YdEeox21V3+1EAz6wTDAXGX2ELwqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uJej9Scc90Y7JE8a1nAsl9zaqtu4YLGQf9YE/l7PEuhcH4bJ9KLx5nCkB2jA6cF+YIl5jwkzInXOQQmrDGZ8qOYCa8vS7IznlzCfRsA2e3VPpe5nVRt1JJwShyP8aMlsw8FqMgmknpT8wUz71GXUvXOG+GeMmmVa4QrQOoyB8pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKXJMJ/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKXJMJ/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1161F000E9
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783602818;
	bh=eo7zIrVDqUtjB6594qXxSaPkktpafk8pk362HGKiHcc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bKXJMJ/A9Qa5EII0eWKMY85S9qMMmVEa+c8qwXqmvWT01Wq1s0iMeiYt4O0Bc+Bmx
	 SEXbQiRXORooW0BfJk5T5ybZGNPcYYrF3HdivA+AXUtj88plNQEAiegsfgS9DmE8tQ
	 ovCBoldNgKlPEP7n67HpVxoiH8mPYt3+DHUyNnYBfdrTvDFXyAErfMCYXyYewUwaZD
	 K7cYWAzkPLcfk2x8hUhkomRiu6ew8Xr9RLlzr+JNJZ+78s7epRTfyy3QVIrORZA3oz
	 gwOBe1O5xiTNhTJv2i5xkExaIohLEAo8uLkqddnywnKbYYlzTyWL+3R54wNcNxFxrq
	 gbwTQM+w5w9rQ==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15f360851aso36501766b.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 06:13:38 -0700 (PDT)
X-Gm-Message-State: AOJu0YzCY00/gH94ri0Sl29zbOPKdxCSN6yHJ28+ffFfORkPZu77encc
	Gxe7zm6LOlqXyd5f2YBtMs9REZeOXKzLXqvax6Iu+LZ40VDPsMP2fLXA5NxvKUqZ60BWtIyheTE
	KthVmcKw1481YEQhC+xh8/PDzPk0Xm8I=
X-Received: by 2002:a17:907:a286:b0:c12:f81:661f with SMTP id
 a640c23a62f3a-c15ce130541mr305094766b.51.1783602817038; Thu, 09 Jul 2026
 06:13:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709000548.66445-1-g.blivet@me.com>
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 9 Jul 2026 22:13:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9rtrHOWD01==RHnzm0L=t5ULL41BN9XGejuZ5bg07vyg@mail.gmail.com>
X-Gm-Features: AUfX_myKGgiXZlq00Wr8N6PYKlVsEOWZRBCAu4tpaV8KS7XCHf6fw0H97JXRwrY
Message-ID: <CAKYAXd9rtrHOWD01==RHnzm0L=t5ULL41BN9XGejuZ5bg07vyg@mail.gmail.com>
Subject: Re: [PATCH 0/8] ksmbd: follow-up fixes to previously-merged patches
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 9:06=E2=80=AFAM Ga=C3=ABl Blivet-Bailly <gael.blivet=
@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> Follow-ups to bugs found in patches from an earlier series ("ksmbd: fix
> several independent bugs found while adding Time Machine/AAPL support",
> already applied to this tree), plus a few additional issues found while
> re-reviewing that same area of code. None of this depends on or touches
> the AAPL/Time Machine feature series (sent separately as "ksmbd: add
> macOS Time Machine / AAPL SMB2 extension support").
>
> Patches 1, 2, and 4-8 are Sashiko (automated LLM-based patch review)
> findings against the original series -- two triaged and fixed
> already, the rest found on a closer re-read of that same review this
> session:
>  - Patch 1: commit 78380c12125a ("ksmbd: route stream
>    FileDispositionInformation through stream delete flag") used an
>    inode-wide flag to track a per-handle delete-pending state, so
>    closing one stream handle could delete a different, unrelated
>    stream on the same file.
>  - Patch 2: commit bb682f1496f7 ("ksmbd: quiet mdssvc RPC log spam")
>    silenced one of two log sites for the same rejected RPC pipe,
>    missing a second, separate pr_err() in the caller.
>  - Patch 4: two IOCTL response handlers (FSCTL_CREATE_OR_GET_OBJECT_ID,
>    FSCTL_GET_REPARSE_POINT) write a fixed-size response without
>    checking the actual remaining output buffer space first, unlike
>    every comparable case in the same switch statement -- a compound
>    SMB2 request that leaves little space for a trailing one of these
>    IOCTLs can overflow past the end of the response buffer.
>  - Patch 5: stream enumeration (FileStreamInformation) reports each
>    stream's name length as its data size, the same bug class already
>    fixed for EndOfFile/AllocationSize on an open stream handle, just
>    missed at this second site.
>  - Patch 6: a DOS attribute struct is used without zero-initializing
>    it first; one of its fields is only populated by the on-disk NDR
>    decoder for one xattr version, so an older-format xattr leaves
>    uninitialized kernel stack memory copied into server state that's
>    later exposed to clients via QUERY_INFO.
>  - Patch 7: deleting a stream (not the file itself) on a directory
>    incorrectly fails with -EBUSY if the directory happens to be
>    non-empty, since the emptiness check doesn't distinguish a stream
>    handle from the directory handle it's attached to.
>  - Patch 8: opening a stream with an AllocationSize create context
>    fallocates storage on the underlying base file's actual data,
>    since streams don't have their own file and fallocate doesn't
>    apply to them.
>
> Patch 3 is unrelated to Sashiko: a 1000x units bug in the default
> durable-handle-v2 timeout (60 instead of 60000 milliseconds) that
> would make any client relying on the server's default timeout lose
> the reconnect race after even a brief disconnect, found during a
> separate investigation into durable-handle-v2 reconnect reliability.
>
> Gael Blivet (8):
>   ksmbd: route stream FileDispositionInformation through stream delete
>     flag
>   ksmbd: quiet mdssvc RPC log spam in create_smb2_pipe
>   ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
>   ksmbd: validate out_buf_len before FSCTL_CREATE_OR_GET_OBJECT_ID and
>     FSCTL_GET_REPARSE_POINT writes
>   ksmbd: report actual xattr value length in stream enumeration
>   ksmbd: zero-initialize xattr_dos_attrib in smb2_update_xattrs()
>   ksmbd: don't check directory emptiness when deleting a stream
>   ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream
>     handle
Applied them except 0002, 0005 patch to #ksmbd-for-next-next.
You can send the updated two patches to me and the list next time.
Thanks!
