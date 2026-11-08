Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794175056;
	b=1eVfxDQ/x4HklUvYuiABHh4huObR7JFrlT8Z7JZjyHMqAn5OPiMToeUP1WvDjxXH0InI
	 zXbb6j1pFIHp+9tGVaGbk/87Me5Xn5kgwfDLCmyJpuGntcCRbAN8M/2gGqbJj7uUcFhJ+
	 u7v08I278H/f6J54txMB/7N2tuSzMlwn+XgP1f9LrqQLK7QVvEgLDasbUwsqmERoKHW0Q
	 Fxur8MbU61MAdc/bG/RztiPvNCIQO4975a6RU2Zo4JVo3XKdH234QalYCs5/w8OhdBGwp
	 pssnlYZWgDt1WH/iPMXb6/twAKRgAJ0UVYS6AY/Q4wlsWKOm3sr+2gBNwXi9ARI7C1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794175056;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/XKsovGRFFCPnmd4VeOPzgbzs8lEv3wbfJUp3GVmSf4=;
	b=vzmJKyLd9Hb8iCvz3CU3oLz/Au3WIz7K4NAHZ6hQaDysKLZJvAhlg3kPYIttROS4lz30
	 DsliFDC2sNS8OYARsi+oI/uCMDZRWfkZLHtUL23VLM5/uH8+38V5i3SLBO3o3lW8uii8D
	 mWhiDr1OuX3mQpVOnJ/8p8k7w+cDbJkxEWw5WlMxke3ZxzHN5t1qlTd5iPxQqacODsBgA
	 vZNMrdJwwXAQrgRX7wF1jJuE0OR3VkRE8vPoVrDvkRP4xqVwQ9yPGjiZc1wo6ZslwuYGM
	 MnN2/2qDoLnXfdal1XonNEwosy5i/mZ47W4oWpZPUP6AtvlXlQcbHvQk9ocIuzh41JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tXTmw841;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8568F606A31C;
	Sun,  8 Nov 2026 21:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8568F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tXTmw841
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=/XKsovGRFFCPnmd4VeOPzgbzs8lEv3wbfJUp3GVmSf4=; b=tXTmw8418uw2UqK6SC6fVNdRuL
	V+/rV7+fSXFN7rg+qBlKkrLf4Geea2xvAdy9mIT8BEw6STSds79weQR1S1a0WB0DumwH7EhQDxXV5
	sqvcz12aFC9FgRbeV/Gg5k6qDyx593mae0wU+b9czpg/8x9jV3u2UmuqCH5cElaOw7tdcOYEtv3jj
	1GnLd9HUToYJ8BI7uIwcWhG5igX3xwIFUH1EBgu6vNWwD6913GtFJVdlXjpzIAER9kyenJGL7GVYB
	8UqjItxQtJQxldi9iShqpy2JlI1iyHfBj9leAkvAGiCOMzCSjjcXazME8/LsMxOAiE30DnXvsvIB9
	mTK9ASJg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xQAtD-00000001CJR-1SVE;
	Sun, 08 Nov 2026 18:57:28 -0300
Message-ID: <42c2987357662d1c29235b31583aa59f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH 0/2] smb: client: fix DFS handling of non-ASCII paths
 with non-utf8 charset
In-Reply-To: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
References: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
Date: Sun, 08 Nov 2026 18:57:28 -0300
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

> This series fixes two problems that show up when a DFS mount uses a
> non-utf8 charset (iocharset=3Diso8859-1, or a kernel built with a
> non-utf8 CONFIG_NLS_DEFAULT) and the DFS path has non-ASCII
> characters.

Applied.

> Known limitation, not addressed here: when a non-ASCII link is
> followed by a path component (e.g. //srv/dfs/caf=C3=A9/sub), path_consumed
> is still in utf8 bytes while full_path is in the mount charset, so the
> prefix path is offset incorrectly.  I saw this as -ENOENT.  Patch 1
> only prevents the out-of-bounds access.  Fixing it needs the
> consumed length converted to mount-charset units, which changes the
> dfs_parse_target_referral() interface, so I haven't attempted it.
> Paulo, how would you like that handled?

Please address it with a follow-up patch.  Thanks.
