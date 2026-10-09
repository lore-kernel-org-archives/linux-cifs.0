Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3EF44BCB0
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556650; cv=none; b=ehO2aBTdZm761SR6VuuJ4w6BQ3F5PwR1aChsDYpv05zVMH2MXo3Y9+IrYqXiGAqfBRMApcmqI2AtGEIFW8RfI5csTxYfu/XKNF+X2ZABsLBueIViAynNcV2EEhqphYfhurQBozg2WoQ7ARh3tu75hXb0q3cSL1MmQYqZHYkvQjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556650; c=relaxed/simple;
	bh=lgVY5zeOoe/w+1HO6HLIuJzLZCQIwA9T27m+tan5G/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Co4nI0e6PiG564tf7Z8NvrDGMtdE4E2ta4KdtmQmsKZAUAMWFXXaKHU1d6f3ie65D0iwEu9wQAF9QvaB+q4lQcImuJADtvtATL7BgFoY5437Z+sIQpWSrEXu3jnSnOBm/JS5ThyPkpIjlsHY3a66GepKQMMAhsdNLKk3mebrWXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngSNv80F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngSNv80F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC01F00893
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791556649;
	bh=PbKXIO1emAxqMQ2zv8mwSWYUzwH3/TBQTEFGkivyyJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ngSNv80FrHy3G4I3P/OLCmlsIbLxKQODWKurOmanv92Vf1R+gnE4Yf2MCfxJPgdnU
	 vxsHsIhq4WbF38MIzhVSopAfhFPXs6RHpN7QQJqlUhZC7qJbPrKAhjDCouGiAyhcgJ
	 GiyIRjenh6j8tt6pWawRvD24QHxT2j7qjSv/TyZq2VlxIWwbHGS4WIhCkGHHXSIiXm
	 +j9cHnBvc1Kwj+xobNYxaH40VZElHdzqCQZzJwA2YDYnAy2CBjxlhmnYw0vQBESy6S
	 0xTbZiFLYFLBWpaJnsrYCWwK49b7xUplPEJyTNlC+Yh6CtTYqzocS2jt2+TExMuI3f
	 05dZz397l8kZQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6afe29c08ccso5583821a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 07:37:28 -0700 (PDT)
X-Gm-Message-State: AFq9FYJCIUVSJRr/byiZX6+rcKEPzvYXbss2OiAsOjPwsHUJSM3Ashsr
	MPQGlzYkAneDuaMZp5CkbMkKGyEmHN8lYE0LJylqnRILK7ZZQydI7qISsJbyA/UwpZU6oaoVSU+
	CjiT2P5zpkYmqLwteQYuy9+pLjaT5VZ0=
X-Received: by 2002:a17:907:9485:b0:c2d:c5b2:a1e4 with SMTP id
 a640c23a62f3a-c31a9b09b1fmr234230466b.16.1791556647594; Fri, 09 Oct 2026
 07:37:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007062936.25827-1-tjdqudcks0424@naver.com> <20261009135400.722291-1-tjdqudcks0424@naver.com>
In-Reply-To: <20261009135400.722291-1-tjdqudcks0424@naver.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Oct 2026 23:37:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8md_8UbhNCJU6-SswRfsOo+vKpmVQQoyZK_WXAW7uaJw@mail.gmail.com>
X-Gm-Features: AclHuK8sgnK44bFF4AwLJM7_AuHKjKxgkJtBnehs10v8BRGSqo6tW_TVnSnmh44
Message-ID: <CAKYAXd8md_8UbhNCJU6-SswRfsOo+vKpmVQQoyZK_WXAW7uaJw@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: hold TCP session for async decrypt work
To: Sung Byeongchan <tjdqudcks0424@naver.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 10:54=E2=80=AFPM Sung Byeongchan <tjdqudcks0424@nave=
r.com> wrote:
>
> Large encrypted reads may be queued to the global decrypt workqueue.  The
> work item stores a TCP_Server_Info pointer, but does not hold a server
> reference while queued.
>
> If a multichannel mount removes a secondary channel before the worker run=
s,
> the final reference can be dropped and the demultiplex thread can free th=
e
> server.  smb2_decrypt_offload() then accesses the freed server object.
>
> Acquire a reference only while srv_count is nonzero under
> cifs_tcp_ses_lock, which serializes the acquisition against the final put
> without resurrecting a server already being torn down.  Do not queue the
> work if acquisition fails.  Let each queued worker own one reference
> until its final server use, and release the transferred small buffer and
> reference if queue_work() unexpectedly rejects the work item.
>
> The unmodified kernel reproduced the same KASAN use-after-free in three
> fresh encrypted multichannel runs.  With this change, the same race and
> subsequent encrypted I/O, unmount, remount, and cleanup completed without=
 a
> sanitizer report in three fresh runs.  Encrypted multichannel,
> single-channel, and unencrypted controls also passed.
>
> The demonstrated impact is a client-kernel use-after-free and crash cause=
d
> by an SMB peer able to coordinate encrypted responses and channel teardow=
n.
> No controlled write, information disclosure, privilege escalation, or cod=
e
> execution was demonstrated.
>
> Fixes: 35cf94a39728 ("smb3: allow parallelizing decryption of reads")
> Cc: stable@vger.kernel.org
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
