Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28517331ECC;
	Sat,  5 Sep 2026 23:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788650513; cv=none; b=M6ZvYPTJRRP8jySZeSis+4lW6TQ0vg1OnLh+ApqmpFPCX790Lh2lg43IROuid05zi0qoxkqx5Rho2vM61qgrRCjjCEa/9hilfcqZ+/GC3Ts3EJ+yUx+aE0moCaTRT3R2UUUNMORkVrwgwYeOb4Ot9xE2C9Bphu1XEgrrgh0T+yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788650513; c=relaxed/simple;
	bh=itv9qmUlgv9l7G57VKXSuNEy9qFSqnNvNz9gaSEOXF4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Aavt32gQ2Pj1xWCT1zZv+SKINQCiVQOVluMaxLF6mg2EoOmLMRIJXJTP9mFTbce7nwDlFG5dUy50g6LcKqFHjSzbQO4upk2n5c88hr/jGofvKL+u+UfH4PidTaIWodT5hyfPwB4T8zA8sdfD5eJj4zbEFrDWG1uVF8JYvJ/vh0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=4NFLLyGB; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="4NFLLyGB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JIaLVlmKMhnAqefC2cLh2pp8GpOf97oAkRwk0GX8cek=; b=4NFLLyGBNNGSm4gB23H4it7+4U
	DYv3m0XVhIirv0Y6G3Px24QQCxnNbznF3APhH2bXyNjIW6UZKv+X2x90TontPxbhe3T9NDmc0zWI1
	sgBY1dZkkrLLYavtxoRsPt01wF5bEOhwW6apSdgZw7I7AzQnDVrTERz+3lArCRcLFnpAcP8x7pCho
	Kietn6d8klNJfAcly7cxMKbqc7HY5EwHCJ+uWRGFUmCIhmGKsXjrbqN63wxrKHe/gNj98q04RE3LG
	jZs31CdXOPWGdQkSxg/UtxVwd5/x80CLxar28piguqkfcFkUn+e27LU+QZ2Kialjl5VlCtLqUdVyt
	dnpWJPSA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x2zhm-00000000lUc-0uZt;
	Sat, 05 Sep 2026 20:21:50 -0300
Message-ID: <e8b4f081731986a161823f68eff462db@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bjoern Doebel <doebel@amazon.de>, Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath
 SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 doebel@amazon.de
Subject: Re: [PATCH] smb: client: avoid leaking refcount when
 cifs_sb_tlink() fails
In-Reply-To: <20260904104236.1603533-1-doebel@amazon.de>
References: <20260904104236.1603533-1-doebel@amazon.de>
Date: Sat, 05 Sep 2026 20:21:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bjoern Doebel <doebel@amazon.de> writes:

> cifs_oplock_break() takes over the reference that
> cifs_queue_oplock_break() acquired when it queued the work, and drops it
> with _cifsFileInfo_put() once the break has been processed.
>
> Only in setups with "-o multiuser", cifs_sb_tlink() may fail, at which
> point cifs_oplock_break() returns without putting the file reference,
> mirroring the reference leak we already fixed in the companion patch to
> cifs_queue_oplock_break().
>
> This would trigger a crash due to busy inodes on the next unmount:
>
>   BUG: Dentry ... still in use (1) [unmount of cifs cifs]
>   VFS: Busy inodes after unmount of cifs (cifs)
>
> Drop the reference on that path as well. Doing so before the out label
> mirrors the normal path, which also puts the reference before
> cifs_done_oplock_break().
> ...

Applied.
