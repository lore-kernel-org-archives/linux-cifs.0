Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A015431A42
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 22:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785365676; cv=none; b=XfASigVim2vO4UjKWN6PoBkSjZhT8Dz6xIhlreClNCG8M9O7uSTkrgR34DkcWB6ypng3e+x1rqi2YICEfCLN3fd+laDjHaIVuHSVLGmhmSuqWRBtj1IplWtzxLwSSlkTdXuMnhnx0U/J8QtTdvi0MJzA5tRxHA1AYdUslVgLxBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785365676; c=relaxed/simple;
	bh=n0qrZjvCCD9dMsYnS/NG6PVYesgyk/QmmhxF6Guqgt4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ekQbeWSBmOkdxd7nwGvuB/IoNoPN2SebunOsFiqSk8UkwF9KwZJnsrpesIyz1tNMl751hyL5oEMA//krNG9fZXP4Y8ld5QaO2Qb379+rWN21eUiIKVTGyDFHEdfB2EedB5cwC6WiiqQKyCtO/DSmqJOTBKdGUf1bqdlaQucwPOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=DNkTXsGY; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="DNkTXsGY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kzh5aMeh0wR5mXcmQOkoItEWHTYnKiQ3GANz9lr1J0w=; b=DNkTXsGYuuxcJmDIw3vN8wJH7t
	oYkodkzGcwJxa+LP8t5wWVbl6Rmpheli0OvREORvJR/Mj1FFgayVF76R5aad2MqcDlfFyp2/MflLz
	j7kQ3lpoHoToOS8CKoqW9cQq+TmdrJdUH0GcRcKFnVFop+9FOmOVzLbnhpM43jIZC7qQYXdsoHSts
	l443k3NVcf+mWJQ1F2I5N0iGfb0nSUOfetH/NLSE53qAxHxiVB59n5fCo1uNSeOVy1FZgnIlRhbgp
	vNaAXFTUATmj91toIKD4LUuhHlMPobgBAhQByxxAWqQ3xu4ayTojPOzMxZKZfXJ+TNfVnWIPecfTF
	bDE+3RiA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.4)
	id 1wpDAP-00000000GzN-3YR2;
	Wed, 29 Jul 2026 19:54:25 -0300
Message-ID: <97c0ca61c2bed2d2559b32b7ed967121@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org, Roberto Bergantinos Corpas
 <rbergant@redhat.com>
Subject: Re: [PATCH v8 5/5] smb/client: refresh allocation after
 EOF-extending fallocate
In-Reply-To: <20260703053300.913371-6-huiwen.he@linux.dev>
References: <20260703053300.913371-1-huiwen.he@linux.dev>
 <20260703053300.913371-6-huiwen.he@linux.dev>
Date: Wed, 29 Jul 2026 19:54:25 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Huiwen He <huiwen.he@linux.dev> writes:

> From: Huiwen He <hehuiwen@kylinos.cn>
>
> Before this change, xfstests generic/496 was not supported on ksmbd:
>
>         generic/496 ... [not run] fallocated swap not supported here
>
> ksmbd handles SetEOF as truncate, so EOF extension alone does not
> allocate backing blocks. A fallocated swapfile can therefore still
> look sparse to swapon.
>
> Request allocation for EOF-extending fallocate ranges that can be
> represented by FILE_ALLOCATION_INFORMATION, and refresh the allocation
> state afterwards.
>
> With this change, xfstests generic/496 and generic/701 pass on ksmbd.
>
> However, Samba "strict allocate = no" now exposes the real generic/701
> failure: the old pass came from inflated local i_blocks, not from
> server allocation. generic/213 also fails in that case because an
> oversized allocation request may not return ENOSPC.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

This patch regressed fstests generic/103 and generic/590 against samba
4.24 (strict allocate = yes) with a 15G xfs partition for both test and
scratch shares.  The tests now fail with -ENOSPC.

A simple reproducer

	$ mount.cifs //samba-fs0/scratch2 /mnt/1 -o username=xxx,password=yyy
        $ df -h /mnt/1
	Filesystem            Size  Used Avail Use% Mounted on
	//samba-fs0/scratch2   15G  326M   15G   3% /mnt/1
	$ xfs_io -c "falloc 0 8G" -f /mnt/1/file
	fallocate: No space left on device
