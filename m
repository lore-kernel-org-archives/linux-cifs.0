Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B492673AA
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602964; cv=none; b=oeJ1LMTfiqy8jTanT8OFrAv/GlacCIECddgqFuoP0c49iCKK8vvVVdUMQLANFyVuN4mpEQgTwvrs9tsXaBDoaxj5CRBC5xOgAZ4ZX9y4/z1npdMEfKic5Ogib33fkNDcaSvZGmWXehl/4sWoLOHAjT4HMRoaLImecWBO/epFu5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602964; c=relaxed/simple;
	bh=S9oCMvrdgwloIYiOwCw8xw5ICTYkdd7OBlqGZA/ewvM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TJZ0gX3D2mD+67ek54ox3litwFu/MqSIvivGcFdMx52ajH6UYdC/mpN8Zi2BoNozZ6XznJfOxgjz+B/rPr0S39fU2dIlqYjjJtxETkXB1aQj6187mPaiDZ4FITYqHDjAqLfn9vPg4r8jtDR/bVeruB99TEytZl7DO4npqPMnS1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1ViObND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1ViObND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7FA1F000E9
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783602963;
	bh=H67r6m6M5Q9uRHI47lh4R/IR8ERu9h2FLP3XKD+lXOs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q1ViObNDIuCq6mVhZwJzg/6S4UKFuXBkYMJ1OpStb0glWdINIjLuhAvtfM0ZWe+jh
	 pjbmt2Ynof5skeoVllamkrCcvFrg+VNyTBvoxy2TtK4pUFxDjsd/0CT5zLd+WPneFw
	 Re9P7EicYVyAmP5LEgyuC1TE1Ji5t7DXKBG5e8zaW86afEinFG04REoMBuwPQ8yGX2
	 Hx36JZJjtquI//GVKBmtSdhw8PBvRE56TDk1vVzxyBLO0BYTBNGbwfwpiBgC6T9JIX
	 DAFsg/whJxjXCT/HXHWCZp/dvoj0GWkQH7lQQ9e5R23YgSg9IMpsqpRk1t490kFQxD
	 MVOlAQV4iZo2A==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso1490350a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 06:16:03 -0700 (PDT)
X-Gm-Message-State: AOJu0YwgnEi3jDBemRBW6/ZEBlo+K4Fz6FaX2rxMxb2TRpq0qy7HFaR4
	UyD1pqyFZa6ZMKtl34QY2/7s4BdozZcfSK/3n/GmpaRvInI66+cgLcxJrf46yF+VWFWS2NtcVDt
	U8ANUOfWJrWCiyB93b7ck4FRmnDJ0UFg=
X-Received: by 2002:a17:907:8997:b0:c12:6389:9085 with SMTP id
 a640c23a62f3a-c15e741480emr132107466b.6.1783602961861; Thu, 09 Jul 2026
 06:16:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709000618.66534-1-g.blivet@me.com>
In-Reply-To: <20260709000618.66534-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 9 Jul 2026 22:15:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+wT6db2vAQZsrdcDep=RVbF8oKhzC9f5mEfo+THPzOg@mail.gmail.com>
X-Gm-Features: AUfX_myqi7V3-Ot7IPkgMbnj84Ezo2j7k5cK9l_JXqv7vUqcQKlVjZROIh13y-A
Message-ID: <CAKYAXd-+wT6db2vAQZsrdcDep=RVbF8oKhzC9f5mEfo+THPzOg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] ksmbd: add macOS Time Machine / AAPL SMB2
 extension support
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 9:07=E2=80=AFAM Ga=C3=ABl Blivet-Bailly <gael.blivet=
@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> Link to v1:
> https://lore.kernel.org/linux-cifs/20260707100129.47563-1-g.blivet@me.com=
/
>
> v2 addresses the CHANGE_NOTIFY CANCEL concern raised on v1:
> smb2_cancel() calls each async request's cancel_fn() while holding
> conn->request_lock, so cancel_fn must not sleep. Patch 4 now splits
> this into inline lock-protected list/state manipulation (matching
> every other cancel_fn in this file) plus a workqueue-deferred send of
> the actual STATUS_CANCELLED response, which is the one part that
> sleeps.
>
> Separately: the corresponding ksmbd-tools userspace patch (aapl_model
> field, "time machine"/"aapl model" config options) has been sent to
> that project directly, since it's a different repository from this
> kernel series.
>
> New since v1: patch 6, AAPL READDIR_ATTR V2 support -- real macOS
> clients negotiate V2 over V1 when both are offered, so v1-only left a
> gap for current macOS versions.
>
> Also new: patches 1, 3, and 6 are now additionally cross-checked
> against Apple's published SMBClient kernel source
> (apple-oss-distributions/SMBClient, smb_smb_2.c) -- everything matched
> the network-derived understanding v1 was built on, except one
> inaccurate assumption in patch 3, now corrected.
>
> Patch 5 also gets a correctness fix: the synthesized ChunkCount=3D0
> full-copy response was reporting ChunksWritten=3D1/ChunkBytesWritten=3D
> <file size>, describing a chunk the client never actually sent (it
> sent zero). Now reports 0/0, matching what's actually been validated
> against a real client; only TotalBytesWritten carries a value.
>
> Patches 1-4 are otherwise unchanged in substance from v1, re-derived
> against the current tree (this branch has moved since v1).
>
> Gael Blivet (6):
>   ksmbd: add Apple AAPL kAAPL_SERVER_QUERY create context support
>   ksmbd: synthesize empty AFP_AfpInfo xattr on first probe
>   ksmbd: send inline FinderInfo in FIND responses when READDIR_ATTR
>     negotiated
>   ksmbd: defer CHANGE_NOTIFY completion instead of
>     STATUS_NOT_IMPLEMENTED
>   ksmbd: implement full-file copy for AAPL ChunkCount=3D0 COPYCHUNK
>   ksmbd: add AAPL READDIR_ATTR V2 support
Applied them to #ksmbd-for-next-next.
Thanks!
