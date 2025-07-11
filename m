Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AEB2E975D;
	Fri, 11 Jul 2025 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752245397; cv=none; b=iH7nyhtDOUUcUUdaLftam1r1ejXPiO0YgA1ipuG32g4q4Fun8EQ9Zy4LAjVOX1r2C6tjJDsptBrGlZcrtt0HFSNj8xGsR4XJoBvnD8IHkv6gv+cepnGwxymJwvqXhRL/fRLO4ulKLjGdWKjWWQ5ijT06bCMzZ1Ao4mZxqgmS94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752245397; c=relaxed/simple;
	bh=d/G5Np4BjWAyQHDBYeRVvI+dHxs0oAifCvJZ7nhqN4I=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=IZZIpvkUvyL7hxY3nJUIpOoJg4NOPbVsCpRVbEXWL0tBmZwokbJiIiSBnxMsM24kMSft9DRVK+EndVjcEW/8td7Z+g+4rAGYrL7ZSRNQI4r7oHj9V5AJ5d13pyrALrY2ZYFlfs8I42DmcDGujSLD7XCFaTMoXZY9nf0SBddadHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=87E+xoiU; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="87E+xoiU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8brX1+ag4+ShccAgZ35yztbKtdrd3eYqr5p3qU932G8=; b=87E+xoiUbkW4T9VHu+od/ykDc7
	fYwtJXCxYpana3HDwI+mHxGjag1LlCyK1wJDmqeJAZ6UYCcQ4IrFWO2N1PFqqF3UMOdO2XpC39Nb3
	5BXM6tJx3GM+fnKEG3+NDIC5r/TKrjtGeVSgDFsc6OoSXgWQfGsSkIL6P1skGOrmPUilrJ97NRrM+
	jfM1I9jp0BCbn80p+zj6+Fo6nG3qhsX/vpTPufZDgJZAzpuNU4vDYIdSb5PAIss4C8b6D2H0bf96N
	nS73wmRSP4JWeUH8vvCBm/Lxt+Fl76hCjoVgAi+74nirgK0b9HnYWQ8SDCrIb/JLTOMGiClvlsmrU
	aM+wpxgA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uaF4Q-00000000BFH-29H4;
	Fri, 11 Jul 2025 11:49:50 -0300
Message-ID: <aa4ecd85deb859ad32ba7f649321084b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>, sfrench@samba.org,
 pshilov@microsoft.com, aaptel@suse.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] smb: client: fix use-after-free in cifs_oplock_break
In-Reply-To: <20250707010926.31623-1-wangzhaolong@huaweicloud.com>
References: <20250707010926.31623-1-wangzhaolong@huaweicloud.com>
Date: Fri, 11 Jul 2025 11:49:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Wang Zhaolong <wangzhaolong@huaweicloud.com> writes:

> A race condition can occur in cifs_oplock_break() leading to a
> use-after-free of the cinode structure when unmounting:
>
>   cifs_oplock_break()
>     _cifsFileInfo_put(cfile)
>       cifsFileInfo_put_final()
>         cifs_sb_deactive()
>           [last ref, start releasing sb]
>             kill_sb()
>               kill_anon_super()
>                 generic_shutdown_super()
>                   evict_inodes()
>                     dispose_list()
>                       evict()
>                         destroy_inode()
>                           call_rcu(&inode->i_rcu, i_callback)
>     spin_lock(&cinode->open_file_lock)  <- OK
>                             [later] i_callback()
>                               cifs_free_inode()
>                                 kmem_cache_free(cinode)
>     spin_unlock(&cinode->open_file_lock)  <- UAF
>     cifs_done_oplock_break(cinode)       <- UAF
>
> The issue occurs when umount has already released its reference to the
> superblock. When _cifsFileInfo_put() calls cifs_sb_deactive(), this
> releases the last reference, triggering the immediate cleanup of all
> inodes under RCU. However, cifs_oplock_break() continues to access the
> cinode after this point, resulting in use-after-free.
>
> Fix this by holding an extra reference to the superblock during the
> entire oplock break operation. This ensures that the superblock and
> its inodes remain valid until the oplock break completes.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=220309
> Fixes: b98749cac4a6 ("CIFS: keep FileInfo handle live during oplock break")
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>  fs/smb/client/file.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
