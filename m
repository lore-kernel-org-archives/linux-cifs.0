Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAB8364EA6
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 12:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770035068; cv=none; b=U6ZaNjDBJmK1nnc/Q968fh6rpjRLoouNppxTLy2IQkDs0iOa8zoNzCN4uxoVO4Di4RgDPP4UZVCIfVbZaZw1Y6F7fIB2V0Ym4bk0RVW42aAwHaWr0Ilouln+tUTVCIC9ScngAAixPInb9xa9RWNCvWAExheJjnfWZl99ZW/4+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770035068; c=relaxed/simple;
	bh=XLInijexvCsMsVqbceK+qEJM2ek4Uvx4dGdCJYvK7mE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=n5HicwIO0IZAygafrnHwETMZOkXiX8CFwkB5AK7mmh6J7btx6NVRthqFpRjYszjfmnM+g5Vuj++IT8opGm0kTXuZfuZmQkEiesmQVUwCiEwmDptfxzvZnNJw0EURkPhFNeM4wX+jq2Sd/GwuraluJttBgUDFM6sSpxtzG/qbSpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=JrCm5ppG; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="JrCm5ppG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H+M5nSsXdUI3mvfDWn0rKtb3gVWDWwlIVIW5xLNTBHE=; b=JrCm5ppG1xHnU4I4avJKwi8R+M
	zlIPNafZiCb3gmkPLayK74yVNy1C4ekwHiJYKqk4b3sCmOID0I+41Ar2nKk7XRWF/xhmukb4BeCLU
	neoDrb4dFLQNlvDAPuI6fM7CEgrkV2UMITq4MDKN6vIvKO2TB1jNi2fsf5YlKgfThJgK/Ez+Ms3tM
	G9gXMgMCRDwgsycST5RYEuF67z9ei2quKKmoqzlqrxfnLELIFAKpw+eQSf052x7MtJMCDPOYfh0Sw
	I4sa68QFRfoOaF7zUAzvsivUw5LUHt20uuRp2aQFUNp4621iHKuAaDr46bF5CVsQ+bLkT3SQo9ttL
	AUB6RANw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vmsrh-00000001UUR-3qMi;
	Mon, 02 Feb 2026 09:17:13 -0300
Message-ID: <9d1cf884bff0ed167a73f957ded11de2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: chenxiaosong.chenxiaosong@linux.dev, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, nspmangalore@gmail.com, henrique.carvalho@suse.com,
 meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, pali@kernel.org
Cc: linux-cifs@vger.kernel.org, ChenXiaoSong
 <chenxiaosong@chenxiaosong.com>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v3 1/1] smb/client: fix memory leak in SendReceive()
In-Reply-To: <20260202094906.1933479-2-chenxiaosong.chenxiaosong@linux.dev>
References: <20260202094906.1933479-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260202094906.1933479-2-chenxiaosong.chenxiaosong@linux.dev>
Date: Mon, 02 Feb 2026 09:17:13 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

chenxiaosong.chenxiaosong@linux.dev writes:

> From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
>
> Reproducer:
>
>   1. server: supports SMB1, directories are exported read-only
>   2. client: mount -t cifs -o vers=1.0 //${server_ip}/export /mnt
>   3. client: dd if=/dev/zero of=/mnt/file bs=512 count=1000 oflag=direct
>   4. client: umount /mnt
>   5. client: sleep 1
>   6. client: modprobe -r cifs
>
> The error message is as follows:
>
>   =============================================================================
>   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shutdown()
>   -----------------------------------------------------------------------------
>
>   Object 0x00000000d34491e6 @offset=896
>   Object 0x00000000bde9fab3 @offset=4480
>   Object 0x00000000104a1f70 @offset=6272
>   Object 0x0000000092a51bb5 @offset=7616
>   Object 0x000000006714a7db @offset=13440
>   ...
>   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x379/0x3f0, CPU#7: modprobe/712
>   ...
>   Call Trace:
>    <TASK>
>    kmem_cache_destroy+0x69/0x160
>    cifs_destroy_request_bufs+0x39/0x40 [cifs]
>    cleanup_module+0x43/0xfc0 [cifs]
>    __se_sys_delete_module+0x1d5/0x300
>    __x64_sys_delete_module+0x1a/0x30
>    x64_sys_call+0x2299/0x2ff0
>    do_syscall_64+0x6e/0x270
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   ...
>   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when called from cifs_destroy_request_bufs+0x39/0x40 [cifs]
>   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x142/0x160, CPU#7: modprobe/712
>
> Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> Fixes: 6be09580df5c ("cifs: Make smb1's SendReceive() wrap cifs_send_recv()")
> Reported-by: Paulo Alcantara <pc@manguebit.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/cifstransport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
