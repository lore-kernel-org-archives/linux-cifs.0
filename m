Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495C721B191
	for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 23:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782169275; cv=none; b=qflokjqKwybiWvy1cQq9RJJz2+BGFKytpCLVS2HWc50zMBBuBzUvBzX8X9zDi5EHdyxpMiCqovX39cBMI+ph4Qx4/GRLR1Zxcc+l1V92ihXBtpzdcLUHpbs0EjtrcVtuuWwbB4+ZX1IbzaTA9mhAWBOFyMwLBS972eyT3MxAioA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782169275; c=relaxed/simple;
	bh=sUEdDSQ0pXRa7UsGddTSLXouovPN1Q1lmCiPM2WZ3hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfcOfyO/d1jCoCHxkU/LuwdkfKwQPVnrDj50Ce9Hm3mpwCz6/I5fR/MaIbdWo+U/C6K3LG6lPK9W09P1L6ZrobpymyTpZWH6JlYUvw+rc2kMJfJpknhSWFT7JfXh6/Fdv9hglADmJMTPd+OrypjsUn6k+YSwAByuCacyIRTVFHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jyXPBQKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jyXPBQKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1961F000E9;
	Mon, 22 Jun 2026 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782169274;
	bh=Vk6UMp1SByzUMrgSlEk6sYWCURR8QL+1K+l3nCW4Css=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jyXPBQKAVeRWtEIsMsC8lcNJZSofpL4QtqRDwaMSJpz42e5PEtt3EiEHWOndCvDnQ
	 N1fF67GTs75nT/3B+jYz/6Wupq/rI+/D+NFnn4/KVomfQBHhIcJjZmL4FnxqY/MOEA
	 JnvnHnJhX09DGBM+RKvP+HgRvol8xAJaRlb3OsHuNyiqKC9hFWmciZBjz40s9PmzuX
	 kgvBZ6+yLNKsOmfOfEN/0rV8IcGmCkNUi89BPfUX/oi4nsbhABvb7LZgAXNn/Y1WwD
	 645GzJTj580gBrm3VX8b8ofdVAHfnBCwi7yXkfSK4+SdGMClVB1IOCjqO+rGyF5oyS
	 e1Er3/euZCDAw==
Date: Mon, 22 Jun 2026 16:01:09 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com,
	senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH 17/29] ksmbd: return requested create allocation size
Message-ID: <20260622230109.GA3328@ax162>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
 <20260621124844.6235-17-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260621124844.6235-17-linkinjeon@kernel.org>

Hi,

On Sun, Jun 21, 2026 at 09:48:32PM +0900, Namjae Jeon wrote:
...
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index d6001cdce085..cca04bf84b81 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
...
> @@ -3926,8 +3927,19 @@ int smb2_open(struct ksmbd_work *work)
>  	time = ksmbd_UnixTimeToNT(stat.mtime);
>  	rsp->LastWriteTime = cpu_to_le64(time);
>  	rsp->ChangeTime = cpu_to_le64(fp->change_time);
> -	rsp->AllocationSize = S_ISDIR(stat.mode) ? 0 :
> -		cpu_to_le64(stat.blocks << 9);
> +	/*
> +	 * The cached allocation size hides filesystem rounding for the
> +	 * requested allocation, but it can go stale when the file grows past
> +	 * it via writes (e.g. across a durable reconnect). Refresh it once the
> +	 * file exceeds the cached value, rounding the end of file up to the
> +	 * volume allocation unit (the filesystem block size, matching the
> +	 * SectorsPerAllocationUnit/BytesPerSector ksmbd advertises) rather than
> +	 * using the raw on-disk block count, which can include filesystem
> +	 * preallocation and metadata rounding.
> +	 */
> +	if (!S_ISDIR(stat.mode) && stat.size > fp->allocation_size)
> +		fp->allocation_size = roundup(stat.size, stat.blksize);

This patch is in -next as commit 64ab25180b27 ("ksmbd: return requested
create allocation size"), where it breaks the build for 32-bit
platforms, as stat.size is a loff_t and roundup() performs a plain
division:

  $ cat allno.config
  CONFIG_INET=y
  CONFIG_NET=y
  CONFIG_NETWORK_FILESYSTEMS=y
  CONFIG_SMB_SERVER=y

  $ make -skj"$(nproc)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- KCONFIG_ALLCONFIG=1 mrproper allnoconfig vmlinux
  arm-linux-gnueabi-ld: fs/smb/server/smb2pdu.o: in function `smb2_open':
  smb2pdu.c:(.text+0x765a): undefined reference to `__aeabi_ldivmod'
  arm-linux-gnueabi-ld: (__aeabi_ldivmod): Unknown destination type (ARM/Thumb) in fs/smb/server/smb2pdu.o
  smb2pdu.c:(.text+0x765a): dangerous relocation: unsupported relocation
  ...

Is this series intended for 7.2 or 7.3? If it is 7.3, it really
shouldn't be in -next during the merge window...

-- 
Cheers,
Nathan
