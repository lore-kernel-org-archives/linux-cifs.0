Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DD539CCF3
	for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2026 07:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785740464; cv=none; b=sYTK9D6/aoRDANeHT4WZTEatjGYVBFJ1Ymtk8JIvZYku6oVZN9FLS60fsqjqv6MjIXsm9wMeMJpXXQJprrPrqPIjYfuLtt54WBCVbvbxnopTPJvdhVYHyV5T+FQ0u0Sxn2bcfJpLrrlH91wAxWjGKaYhw7udbIAfF/1Rpu4TGPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785740464; c=relaxed/simple;
	bh=dEHSWkHDEYYFqS0EQnRe9AddR75tIlHWZhiCe2Kmeeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bKa/9REANB/FjtMMJDckw5Weo0VhvmxyXaTWbOpWnGQrmO6uWW/2l3NkJWr+1vzxU4mz1jWfJQvDJ5No+L5vG+I3LT1CuQc9KDXMMgQ3C2PGeDKKAWnMw4N95lXYOR4exNNHi0Dipei/9pQXYlBrODWLkusz78D/3zTmk0TdG1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FjHHhf4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjHHhf4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927FF1F00A3D
	for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2026 07:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785740463;
	bh=dEHSWkHDEYYFqS0EQnRe9AddR75tIlHWZhiCe2Kmeeo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FjHHhf4EnjbLPtknDRWd6G4CHFpejAEPEVXceEQrQi2HxHZPvF1QMixSb8oytdaUj
	 oxySLf9pOe60qoLcBfX7UeAdPNpgOIirsSvY3gMYhZJRpGQrDs0/SkpC8naBke+YFY
	 p3KVD4CqCymNVyJQc7xeXmoU6BittEuIcZ38A+rbi9cHdm11Uk8raKq555ZHAoooOA
	 IssEzGEYCF1c+PMMCt9HhEHDx0LnIJB73AbPQtm+3k6kQOyISNEYWzCjwU/QETs8Mk
	 GeRqpXJBMYqi605dvYxkekcAK0V1nqIN6TqGD4aQYxfINJ+rHZEyWzyvMwDzyoGd09
	 Wf47rJCDJGWdA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c167bda216fso450817566b.2
        for <linux-cifs@vger.kernel.org>; Mon, 03 Aug 2026 00:01:03 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx7DVsXrGghRbXEHzkqJBYxDnc6h3Rjui0Ihgv11cGdduW7QJ7o
	NqAwyVn78ry6rjrICWOSWmMRG7SqrqAfYxU5wDWkQiA1+h9L73s2hf5iiAznO6+GDIm7rrRt6Cm
	m/F8yrS72m1RQAhGNIH1vIyFjuuroCAc=
X-Received: by 2002:a17:907:7248:b0:c12:695b:8876 with SMTP id
 a640c23a62f3a-c1fe8167532mr622340166b.5.1785740462210; Mon, 03 Aug 2026
 00:01:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731115424.9892-1-g.blivet@me.com>
In-Reply-To: <20260731115424.9892-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 3 Aug 2026 16:00:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-C8Nr537u7rm531FyWncoA=ZnnZHHai_37-xEup17N3w@mail.gmail.com>
X-Gm-Features: AUfX_mwe9io23Pm6MI7YrSVdSj-aZ54Hw81TrMpjXhfwOZfymZGfMtnFJJsg5_k
Message-ID: <CAKYAXd-C8Nr537u7rm531FyWncoA=ZnnZHHai_37-xEup17N3w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic
 file-id lookup
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 8:56=E2=80=AFPM Ga=C3=ABl Blivet-Bailly
<gael.blivet@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> smb2_ioctl() rejects FSCTL_PIPE_TRANSCEIVE with
> STATUS_OBJECT_NAME_NOT_FOUND before fsctl_pipe_transceive() runs. RPC
> pipe IDs live in sess->rpc_handle_list, a separate namespace from the
> ksmbd_file table the generic ksmbd_lookup_fd_slow() gate searches, so
> the lookup always misses.
>
> Found while testing generic SMB browsing (Finder's "Connect to
> Server"): every DCE/RPC bind over a named pipe (SRVSVC, WKSSVC, SAMR,
> LSARPC) failed right after CREATE. Adding FSCTL_PIPE_TRANSCEIVE to the
> same no_fileid_ioctl exemption as FSCTL_PIPE_WAIT fixes it, confirmed
> by testing a build with and without the change.
>
> Fixes: 0726814421c2 ("ksmbd: add SMB3 request replay support")
> Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
> Assisted-by: Claude:claude-sonnet-5
Applied it to #ksmbd-for-next-next with ChenXiaoSong's reviewed/tested-by t=
ags.
