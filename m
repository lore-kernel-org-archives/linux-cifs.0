Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695311;
	b=3IADJIIv7Nz3CfWI5dcfIGEnF92HG6P8wzgZi99UHfAPmMb/CMz140OKixfRVnmkifgB
	 Do3Q/WOu1JPxSJnvnWYiwQ1oVXGUWlW3fVxUhuHtN7NhpSOvxix65klZkELtwhZklo99B
	 lnGMcO9C9lE7NzvK2329HF4u28To2McqIPvnPVbZe5MiNnyXVwYbcUoUW8BpYyvx1g5r6
	 uB8+GEl278AOg/xE4+PTRgZEd2K58T5Xkd9TGeQwhWwTFdYNa7SjkKElQ27gAWXMkDyae
	 ePfbOsVjK2mk7bZSnHWpFFHupgBXDkfz1KfqRQvZnMVeiV4PbvpZCr20cQ+LDoQ2ZjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695311;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=z0tHTAzbyTQIOl58u5zVuFxD7F8WWDLgBfZbFKsKHd0=;
	b=jSvqE5K3QqRj9W43uCYIvLStBy7FAfOGoD3Te+88oLxDnF3RUFWqyiiR4OmofKDP1823
	 g0LsHF7+cIWBpeFHJgv3/aog70lsh/1QywX9hB0RkaQJa4PXow8h7ySiT8oN8KzNIJQee
	 u25jaFZlHvNpq88kZuxErqIWMagyVWrfC0Dvro7pqT6pYX2H5eu09jKaJqvIvLznEjTML
	 q/629SQ5N/vaoFAgFdvQ3MRZL8ElJdKPcWFxFtEaBhrGW5WfmivLHPykRrUCFk6/WB+/i
	 QsHVnXQmJXzRMq6ZVxr+uVe9G4NQFM2gF7CzbchabzJyTeEGkInYsjnvIPTE/VVuLvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zGV6MF5m;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB94606A31E;
	Thu, 26 Nov 2026 12:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFB94606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zGV6MF5m
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z0tHTAzbyTQIOl58u5zVuFxD7F8WWDLgBfZbFKsKHd0=; b=zGV6MF5m6fZKxbSciJlnPVuumJ
	9rArgDnX23oMXP60zg6ej5V6VyoMhRp/n3A7/HGcg7DCRwLNw12Pt4U0tVXSRWgMylgiHiflnJE4w
	KK2CfvIUN7PCkYawfs+6lKC586b+vF9cXMgqlce5zMtQOg0lGCCXvK9UW67hwG1q5gphZRKDSHTub
	/JR1L1cxMDrbJYri3rhjF3KQHxRQ7HWOXXMtGfpQweRKABKxGqateE4b6sTZwQ9GNZ9JKs452cjyE
	q43KyfRMKIpZ4TlC6QbgG7Yqq1v6jD+PrBglZ1y3X6evaLeRUVXolFcM7ZnOFwBi3K+k89aXeLJ7I
	YZg15nQw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWYNU-00000000zor-2gJV;
	Thu, 26 Nov 2026 09:15:04 -0300
Message-ID: <200bda64156d7af0cbf6a16b261005f7@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: convert DFS prefix from cache charset on
 reconnect
In-Reply-To: <20261121030951.1470502-1-fredric.cover.lkernel@gmail.com>
References: <20261121030951.1470502-1-fredric.cover.lkernel@gmail.com>
Date: Thu, 26 Nov 2026 09:15:04 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Fredric Cover <fredric.cover.lkernel@gmail.com> writes:

> The DFS referral cache stores paths and target strings in UTF-8
> (cache_cp), whereas cifs_sb->prepath must be encoded in the mount's
> local charset (cifs_sb->local_nls).
>
> When reconnecting a DFS link in tree_connect_dfs_target(),
> dfs_cache_get_tgt_share() returns @prefix in cache_cp, which was
> passed directly to cifs_update_super_prepath(). On mounts using a
> non-UTF-8 iocharset such as iso8859-1, this overwrites
> cifs_sb->prepath with UTF-8 bytes. Subsequent operations then
> re-encode cifs_sb->prepath to UTF-16LE using cifs_sb->local_nls,
> corrupting non-ASCII characters on the wire and causing lookups to
> fail with -ENOENT.
>
> Add dfs_cache_local_path() to convert a path from cache_cp to a
> caller-specified codepage via UTF-16, and use it in a new
> set_super_prepath_from_cache() helper called by
> tree_connect_dfs_target() so cifs_sb->prepath stays in
> cifs_sb->local_nls across reconnects.
> ...

Applied.
