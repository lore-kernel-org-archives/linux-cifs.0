Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793179289;
	b=CV7wC5m5/P1QbCkwO6Drs/bwKdQEzyGmFwbUcq4M2VDApXLm/p5t+i5qcOLfnenCC1LV
	 LRShw2sPrThWuPzVKkT4Wm9eYANXIu8Fl82jgwW1NL1zLFXLXZtOD/2tYpKfRQovbTGYB
	 gdKhtUtBDqiqguLlOHhJKalmf7KGIbPOSVxIjr3P9i6UYpsGHmYFoNdS1I7r5TjwqZ08F
	 F0oL9fRhFucKpMw71+duX9jKWJUZDrmmZYNeN+ifdPy3Z/QdZVkWpShDl2J2jUsDSht09
	 S+yTBPX12Dohl0OIpH34v4vlEJFBRO6uzSZ2l5lYfJi3kArYonJDca6L68HeMvs0BCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793179289;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LBfBGw+jhPwOk155E35xBmFE2LfARI5TcyAeAxeY6y0=;
	b=GHFsnRogasgsDLTMsdlhgz2lSZG0bWlH+NxGOu3cz7gPeXaEqvcpn+R5D+szolNscxKD
	 avNbcQpoMYq7EN0ONG9fKY3MDNL8BPszuMD/92BfCeD1Q/Ui8R/lhm9M8AhfZyFugCXMb
	 lRr5z3aL8r7uXj/AYFmVGw3sqYsj/Rgz/KsaGfjEk0OwhfzcSUjq4faZHDCq4dkEr4AMv
	 WXZzK3ZHvt+wKw9PsOl/lkHMYrYAABE2tfLcWSqekZXkfD9QOcip4yuDRRx0ssPl6u77m
	 h+skiViA+nPya8WQyiBxeevtuj3eZwEbU/9bXXiNbT9n1W2AAWQf1b8XXdrUjkmSYjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPMPkiN6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6032606A31D
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 09:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPMPkiN6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BD91F031E3
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 09:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793179288;
	bh=LBfBGw+jhPwOk155E35xBmFE2LfARI5TcyAeAxeY6y0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IPMPkiN60y8evtarV7sNotj3qh8KcX33sta+hU0d3hnUiJ74McIZtPkEPpAzwXOyn
	 2zdjLgHRN6OgbUnNGgY0Ui1PJLZ2AMM3GZLBKsLy0Z25Jys7+9LpikI2KZIxDBgO8k
	 pNcRDqQP5vleQhSS8qQ1uEJCyIKq5JS0w1+cy8Ql+89fq8QpFYbQaPIkk3Y49xkVsc
	 jKXbfu6qvfwiIu0HsbLM6NNdj9keLfGuuaroLejSxDhFKL6sa5V7D7n7Bvm6URO3eq
	 xqkji7YoirVaUgeiNuJHm1rng/p/kOPk/7YoFmaxBQlLS6QA1SADhwcx1b3zwoWFyU
	 kn/OPn/DAz77Q==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c418e215671so86480666b.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 02:21:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx2fp0Y6EL9HJqvivZJmr5ufuh+r3x4LeWh0ilZRH9x1WM75Z/uucrqmF6v6OjzH/ncBwjpKvxEAx55@vger.kernel.org
X-Gm-Message-State: AFq9FYKUmqVxLisbPj0VFS9LZR9C7iw4YjEiF1gAOCUeBMVgj8ejyenj
	EqjX7aRysuUqLkkgQ5Y8/1we4YYAe7bXF5HuEK1zkjAfRSjjFyp8JxrfnZ8xCEoggcj0eOABDbV
	oEy5TKpoJcjjdtbQnF4K0ByME2KimLhw=
X-Received: by 2002:a17:906:f59b:b0:c35:d50a:1352 with SMTP id
 a640c23a62f3a-c49bdeaafbcmr140045666b.11.1793179287106; Wed, 28 Oct 2026
 02:21:27 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <TYZPR02MB6959DA97FC41F99C5DBD9CE8E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
In-Reply-To: <TYZPR02MB6959DA97FC41F99C5DBD9CE8E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 28 Oct 2026 18:21:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-9XjA3ZP0uLGqNqBFZO0KsiFnqRS56yivzUoiKi=jZ1w@mail.gmail.com>
X-Gm-Features: AclHuK_81ZzGJH9Q0r2nE9GovJSixXCHhmTzLOLXm4AR3OTOH1s_q91L-fStTFo
Message-ID: <CAKYAXd-9XjA3ZP0uLGqNqBFZO0KsiFnqRS56yivzUoiKi=jZ1w@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] ksmbd: fix named-pipe reply loss and operation races
To: wangzhaolong633@gmail.com
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 11:43=E2=80=AFPM Wang Zhaolong
<wangzhaolong3@outlook.com> wrote:
>
> This is a candidate v4 of the named-pipe fix series, based on mainline
> 7d37252fc49a. Patch 1 is unchanged from v3. Patch 2 addresses the cached
> TRANSCEIVE input-acceptance problem reported in review and reports
> BUFFER_OVERFLOW for a positive pipe READ that leaves unread reply bytes.
>
> The first problem is that RPC IPC replies are matched only by the pipe
> handle. Concurrent operations can interfere with reply delivery, and
> CLOSE can release the handle before another operation finishes. Patch 1
> adds per-pipe serialization and lifetime, checks teardown after locking,
> and clears pipe state on logoff. Existing mainline foreign-handle checks
> and STATUS_FILE_CLOSED behavior are preserved.
>
> Patch 2 retains the original IPC reply allocation with an offset. READ
> and TRANSCEIVE return only bytes that fit and retain the suffix until it
> is successfully pinned in a response. Closing, logging off or disconnecti=
ng
> releases the cached reply.
>
> In v3, TRANSCEIVE with cached data sent a userspace WRITE before returnin=
g
> older cached bytes. Mountd's RETURN_READY fast path can acknowledge that
> WRITE without accepting its input. A later transaction can then return an
> old reply while skipping its own input. Merely returning the cache withou=
t
> the WRITE would also silently ignore the current transaction's input.
>
> V4 instead rejects TRANSCEIVE with STATUS_PIPE_BUSY before any IPC when
> cached unread data exists. It does not accept input or consume output.
> The client can drain through READ and explicitly resubmit. The no-cache
> path still uses one combined IOCTL IPC. There is no new kernel RPC queue,
> extra whole-reply copy, IPC ABI change, timeout, quota or production limi=
t.
>
> MS-FSCC section 2.3.48 lists PIPE_BUSY for unread pipe data; native Wine
> and ReactOS behavior also supports this rejection. This remains a proposa=
l
> for the SMB2 path, not a claim of a fresh Windows remote-SMB2 oracle or a
> universal MUST. No new per-pipe mode selection is introduced.
>
> Changes in v4:
> - Reject cached TRANSCEIVE with PIPE_BUSY and a standard SMB2 error reply
>   before IPC, preserving the cache and offset.
> - Remove the cached TRANSCEIVE WRITE/ACK path.
> - Set BUFFER_OVERFLOW only after a successful positive-length READ leaves
>   a suffix of the same cached reply; exact final drain returns success.
> - Preserve the zero-length READ no-op and pin-before-consume ordering.
>
> Bugzilla references:
>   222196: short PIPE_TRANSCEIVE output loses unread RPC reply bytes
>   222197: same-pipe RPC replies can reach the wrong request
>
> Wang Zhaolong (2):
>   ksmbd: avoid races between named-pipe operations
>   ksmbd: fix named-pipe reply loss with small output buffers
Applied them to #ksmbd-for-next.
Thanks!
