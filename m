Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967954A3F1C;
	Fri,  4 Sep 2026 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530079; cv=none; b=JnaLFiIc8eJirRrIQ/kiPAuCrt6rg30qqbjJ7IJaph6K0T2vWz2U/+gy6jYI9AHQG94yrIIF61EaviWNe0oQ7BXBUTBUZqukUUgcBAi3IXjrfFuFrAbci639IPJXLeK7qKr2DKg/EVYno4Q+NpgEROwtKMPK8slV9Z+J+hk8rdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530079; c=relaxed/simple;
	bh=5FvOFRik9OscagyI9Ksiw8qb4TnMYmsl3K4FJhJlfg4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nUcjaXoPtbgxcVN6qsTftfNbeqItK3u2fND45W0w2PpTzK0MotKClq4t9XbqfG6Q/jX3YcHIYKTjMW17I8XxZJcFI38Tn/wCMqodBTL4VzjjmtLyU4Ar38yw2txEjToHo4lX8AJJfFwHFrq3YqXgjfkwVafNag6O1We/6csnu38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=YwprV6Ww; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="YwprV6Ww"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net CC4FC40908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1788530071; bh=qGrw0LcN4kcIILhqFZ0ns5IIpWW9WdDrdy79MAy1D+g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YwprV6WweqqCZLX7W+ZEzjUaKgXgE70k2Y8dTiyQ4+oClz/bddTn1aLieSO4+x1lz
	 WpJU6H3mMapkqQJeAnv+cnhfJfh5bwazWFLtNnLTYEKjPx41edaapTCYPG82UdfQAN
	 aqryTQtikoIbSr4lxxKD3ctZwDyuOpTNG8I7Bc8FtS/DSnPpAEklyF399g3Wd4tYdp
	 9HWyJloE4Ig6b4OySZ8Mx3XuMk4hDJIwHtLjVx2vqa2n3rekQF7MgVyt/O6ZcrcIor
	 hvdcdPk5nRqZKtu/TxE46H/IOq4l79DHbWBPw6jAGp8PcISBnAcgvMHN/Y7DE6EjNk
	 BiwgvzIo6A1PA==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id CC4FC40908;
	Fri,  4 Sep 2026 13:54:30 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Hemanth Selam <hemanth.selam@gmail.com>, Paulo Alcantara
 <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation/admin-guide: fix typo "asser" in comment
In-Reply-To: <20260904114821.33650-1-hemanth.selam@gmail.com>
References: <20260904114821.33650-1-hemanth.selam@gmail.com>
Date: Fri, 04 Sep 2026 07:54:30 -0600
Message-ID: <87bjad2kbt.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hemanth Selam <hemanth.selam@gmail.com> writes:

> Correct "asser" to "Assert", reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  Documentation/admin-guide/cifs/authors.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/cifs/authors.rst b/Documentation/admin-guide/cifs/authors.rst
> index 5c1d2f0fa7d1..ebe223413577 100644
> --- a/Documentation/admin-guide/cifs/authors.rst
> +++ b/Documentation/admin-guide/cifs/authors.rst
> @@ -40,7 +40,7 @@ Patch Contributors
>  - Adrian Bunk (kcalloc cleanups)
>  - Miklos Szeredi
>  - Kazeon team for various fixes especially for 2.4 version.
> -- Asser Ferno (Change Notify support)
> +- Assert Ferno (Change Notify support)
>  - Shaggy (Dave Kleikamp) for innumerable small fs suggestions and some good cleanup
>  - Gunter Kukkukk (testing and suggestions for support of old servers)
>  - Igor Mammedov (DFS support)

You do realize this is a list of names, not an English sentence, right?
We appreciate efforts to improve the documentation, but please think
about changes rather than just reacting to scripts.

Thanks,

jon
