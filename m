Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794928285;
	b=EHE2j9DyF+Aurqs0m/puLSar7P5dgsoUSnb8dXNBkDblg/UgrpdzzldCHy9Vz7bBUxAV
	 /65QK9vAITYnZK721NlIJZySLGsd8QT/pb2AYhW0rSbdEcOwKEzAMelCti3s7Tj00NcVT
	 sXEySXVNjxYWKJyxXLWSoRrOr4FvGMsfqlw7wyHjdYQe+9MwdW2F2G3vOjoPBalDDGvSW
	 SCDmJ1c1i+G0rqL8pzuRV/7YmNPuvsSkCfdp08zNKf3dvphNc5DLyd5loPaof2d9MCPfE
	 rS/6CFYIAhprNTxc1khzIqD3Lz6wOyxb0Hu7UD1KfvYOdX6TrfOrmz9pWXnl+5BPHMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794928285;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=MtphZhFOIkTJ7fYGOaxJ8FZss72jGafiSI5Av5cF0nM=;
	b=tNE83X5ypaGw6jrsTBX1KhYdg7fUtWdYb6tw6diGT+nMbtS3yUs56SdVoj4CvKj2Y443
	 yBEIbavkCg6kzmlfmrntkCWsJyPGIXlIsMVnmmQQGaivv+FlGVuQyb47cUuCLZpRhJb0g
	 lHTQGU0X65ToOhEY8uUUpOmixY9ZyPQV4GZgnjJLu6hVjPKTHhWQmKi9DLzXd72HGD6gO
	 bZ71KqqORDSoKBK/LMkMhCwmExb3ME1Xsh6ysbBufsIVAq0yQVjVIzfSpO4s36UPAI/fT
	 5HUpXFgDmqI93CQnhoYq3+7Ns+InMjFS8r41luuerbZ7RWuGdkQANknnllvOgAAas7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=AdhsOzJh;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1127606A31C;
	Tue, 17 Nov 2026 15:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1127606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=AdhsOzJh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=MtphZhFOIkTJ7fYGOaxJ8FZss72jGafiSI5Av5cF0nM=; b=AdhsOzJhAlGZtkiQZFo7gSZnDC
	NaWH2CCDWtAP7PuUwIUMkNz6t9vvgS9fgKzdpErbCNJfmEouEJT4B3eA0QZ784o8Ju208vLxJy8LG
	oRM68jwjmgFdZ5gN/igGtMCHAfScnZ/Y6jTO1EXvc97A1jabDGVeN5Q9S0ItfOzD4TRzdWVMGEWZf
	uKEBCBtTLwgswfRhYF1dw2xoasNt68eLJiJSUf+bZLzO5P/aO+cQeEfEP4ylWbiSHqSRx3Lh0+2wz
	Ziu2TuijP0i1CcE/xUXyaArui2APPxwWgvQfRTqOA05eeRfRQJe6hoiMoCCokl5Jr9osG5FtNIivl
	eRCGuwJg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xTKq0-00000000C4U-1FXA;
	Tue, 17 Nov 2026 12:11:12 -0300
Message-ID: <287aa602b5b30784566310e917cdb9da@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH] smb: client: convert path_consumed to mount charset units
In-Reply-To: <20261112042137.1642509-1-fredric.cover.lkernel@gmail.com>
References: <20261112042137.1642509-1-fredric.cover.lkernel@gmail.com>
Date: Tue, 17 Nov 2026 12:11:11 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Fredric Cover <fredric.cover.lkernel@gmail.com> writes:

> path_consumed in a DFS referral counts bytes of the canonical path,
> which is in the DFS cache charset (utf8). dfs_parse_target_referral()
> applies it as an offset into full_path, which is in the mount charset.
> When the mount charset is not utf8, each non-ASCII character in the
> consumed part that encodes longer in utf8 than in the mount charset
> makes the offset too large, so leading characters of the prefix path
> are dropped. For example, with iocharset=3Diso8859-1, mounting
> //srv/dfs/caf=C3=A9 =C3=A9/sub yields the prefix "ub" instead of "sub" an=
d the
> mount fails with -ENOENT. (A single accented character only worked
> because the offset happened to land after the delimiter.)
>
> Translate the count in parse_dfs_target(), where both strings are
> available, by matching path components: count the delimiters in the
> consumed part of the canonical path and find the same position in the
> mount charset path. Delimiters are ASCII in both and are not affected
> by remapping. If the consumed bytes are identical in both strings,
> which is the case for utf8 mounts and ASCII-only prefixes using the
> default backslash delimiter, the value is used unchanged.
> ...

Applied.
