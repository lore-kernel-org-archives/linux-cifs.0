Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B5833122B
	for <linux-cifs@vger.kernel.org>; Sun,  1 Feb 2026 11:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769946859; cv=none; b=te8aPt1lJp1aBRimYghS21WOlfCoc3UABaOKCthuHx8JWuTOn6Y75fwrCUnRtsBGBx4XpkXao591y+lofNTm7RfjQCNf2p9x/ZvdM6lWJck9p6BtSl4IWhIQRewZHVUBA4K673uTuCnxzYrpJuyqKa4RkFZdXT5BOXoRvD5I++Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769946859; c=relaxed/simple;
	bh=VpBFLvPRbCYtEBWFPtQ+S5uMF3TEzXl8m7qaemIa9OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqdBm0Krdq98Vlw0kvRgP//Kkzll1inAyTVKj9/SgJh1wHvLEJASCtCVTu1h/sXPif7F6dJ/AkCw1jrI74fOLbar58K4xCD4MuSFE6OZ99oIr1DF4zQNVI+F0gPAoZxLpSTugZcIWVlPLVUo8uaojmbTyAzZ7UzgjSEo6Ub/Sm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDKxFfo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDKxFfo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56A2C4CEF7;
	Sun,  1 Feb 2026 11:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769946859;
	bh=VpBFLvPRbCYtEBWFPtQ+S5uMF3TEzXl8m7qaemIa9OU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YDKxFfo9OUzqVa5SP5abnB38OPN7mEIdPoT+6zkFOvgSg7acrdAm3/T3srOrgxcWQ
	 HIUNIzvmeDIJN5ghl+5eLejwz5dteBwtGsENs3YJTYFlISrYC8X0yZlqCx8rkIx72Y
	 QX+Cy2LyFz/AcveTj7mVdoMfq1+6b/B8K1+CcqZ6ZqD75kRf8GqEAhI9mtH09yccV0
	 e6b0HqcA7YbFRw/Z0oiMgiT6Cx2zDteDdZdEwvLQXK9kXLflFxF+hcSkXchOwekgor
	 kH0kjv+gBWGBKerhO8uY08LEhmUQ+9i5/e5rFQgQEOr7s44mRD71bLF4EOilBcsGYg
	 nlNuHKmcm4nBg==
Received: by pali.im (Postfix)
	id 2A3E4476; Sun,  1 Feb 2026 12:54:09 +0100 (CET)
Date: Sun, 1 Feb 2026 12:54:09 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, nspmangalore@gmail.com,
	henrique.carvalho@suse.com, meetakshisetiyaoss@gmail.com,
	ematsumiya@suse.de, linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/client: fix memory leak in smb2_open_file()
Message-ID: <20260201115409.5owvqgxqkefmqkkh@pali>
References: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
User-Agent: NeoMutt/20180716

Hello,

Thank you for looking at this issue and preparing a fix.

On Sunday 01 February 2026 08:10:17 chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Reproducer:
> 
>   1. On server, set the permissions of the shared directory to read-only
>   2. mount -t cifs //${server_ip}/export /mnt
>   4. dd if=/dev/zero of=/mnt/file bs=512 count=1000 oflag=direct
>   5. umount /mnt
>   6. sleep 1
>   7. modprobe -r cifs

Another possible trigger could be to pre-create file on the server and
remove write permissions for the caller. Then opening it for write
access will also trigger the fallback path, which also fails.

> The error message is as follows:
> 
>   =============================================================================
>   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shutdown()
>   -----------------------------------------------------------------------------
> 
>   Object 0x00000000d47521be @offset=14336
>   ...
>   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x34e/0x440, CPU#0: modprobe/1577
>   ...
>   Call Trace:
>    <TASK>
>    kmem_cache_destroy+0x94/0x190
>    cifs_destroy_request_bufs+0x3e/0x50 [cifs]
>    cleanup_module+0x4e/0x540 [cifs]
>    __se_sys_delete_module+0x278/0x400
>    __x64_sys_delete_module+0x5f/0x70
>    x64_sys_call+0x2299/0x2ff0
>    do_syscall_64+0x89/0x350
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   ...
>   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when called from cifs_destroy_request_bufs+0x3e/0x50 [cifs]
>   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x16b/0x190, CPU#0: modprobe/1577
> 
> Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> Fixes: e255612b5ed9 ("cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES")
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index 0f0514be29cd..9ab0df01b774 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -178,6 +178,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>  	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
>  		       &err_buftype);
>  	if (rc == -EACCES && retry_without_read_attributes) {
> +		free_rsp_buf(err_buftype, err_iov.iov_base);
>  		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
>  		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
>  			       &err_buftype);
> -- 
> 2.52.0
> 

This change looks good, the second SMB2_open() is reusing &err_iov and
&err_buftype, so they need to be properly released before reuse.

Reviewed-by: Pali Rohár <pali@kernel.org>
