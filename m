Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE903D331D
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784215523; cv=none; b=PWBbx2LonN4kUoBNlvHhlYUX4wHxvK2QqEKelMFKbZERuOnR07DjRVFDlW25NcSU9HETN0bq84Ol7uv3UXtcFjOn1vncww2E1Q4ZGB0gQzwBdxOEVoJB3pkRHCiWBsAUDLYoLWPBDfpz3SnHmmyGuJxYZHjeUOpZhoS3pTBsXx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784215523; c=relaxed/simple;
	bh=+sEaqkgyj6aZXR0g6NNf2arw3L44r3FZppKOLHs5PyM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=m1IMUZtBISnJDPjC0nxFdGkurre+WyEBquMqLrzXovSxBr6M6acb1GfyKhxUqnFgXoODNKLXaPPRVcft6xY5LV5bkLVKNKTQXx6ddzhrWitVNrtKpztzLuHgnEG8dXYPGk/+/WCwS8bLlawJ4WUVNFI/INX+cqXaaWcitN5w+0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=vjUmziWx; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="vjUmziWx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6+3phoyPj0QC8JA3HGDlivdicXQhm9UM28ZfPxyXtgc=; b=vjUmziWxf19EyXvKksul0KvDAO
	l+gMTzB0MNHUH240f+GD+1kXtzieNQOra+yAp2GWAyVDR/ALHrMVwl8CnduA0xpwFZsKiLHM78SEO
	5raWh3KXvsqUiv8pbAPnf5d0hsbmRBavbvS55q2RAc2fCnPniZB9ei6ro/OCHujFIJp6jnMmTkx8P
	/xTz/7NuTZHaB2j7dyrktCQWaWRXMP1NY8xIem/YJ0SDxQFznndUbDHsigfiYcIELXmZ7thxVVV1B
	PAmGjm4PzQc7e/apk78B9qmwiQXNNjQ6htwmB/16KiZgPB/UwycTy3LKlLePmzNL7F2o8QcpLXY5h
	qIkreFwg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wkNiN-00000003RjS-0chm;
	Thu, 16 Jul 2026 12:09:31 -0300
Message-ID: <0727f6af62bc986a221a720e7f180be0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb/client: fix unaligned fallocate emulation with
 O_DIRECT
In-Reply-To: <20260716144731.729559-1-huiwen.he@linux.dev>
References: <20260716144731.729559-1-huiwen.he@linux.dev>
Date: Thu, 16 Jul 2026 12:09:30 -0300
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
> Commit 4a7d2729dc99 ("smb: client: fix atomic open with O_DIRECT & O_SYNC")
> made atomic O_DIRECT opens correctly use CREATE_NO_BUFFER. This exposed
> an issue in the fallocate emulation added by
> commit 966a3cb7c7db ("cifs: improve fallocate emulation"), which may
> reuse the handle for unaligned zero writes.
>
> Windows requires the offset and length of writes on an
> unbuffered handle to be sector aligned, and rejects these writes
> with STATUS_INVALID_PARAMETER, causing xfstests generic/760 to fail.
>
> For SMB3.02 and later, fix this by keeping the handle buffered and using
> READ_UNBUFFERED or WRITE_UNBUFFERED only for actual direct I/O requests.
> Determine this from the netfs request origin rather than the file flags,
> since mmap writeback on an O_DIRECT file is still buffered.
>
> For older dialects, retain CREATE_NO_BUFFER since they do not support
> per-I/O unbuffered flags.
>
> With this change, xfstests generic/760 passes against Windows with SMB3.02
> or later, while Windows SMB3.0 remains affected.
>
> Fixes: 4a7d2729dc99 ("smb: client: fix atomic open with O_DIRECT & O_SYNC")
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/cifsglob.h | 13 +++++++++++--
>  fs/smb/client/dir.c      |  2 +-
>  fs/smb/client/file.c     |  4 ++--
>  fs/smb/client/smb2pdu.c  |  6 ++++++
>  4 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 08e94633a9c1..2e43dbd564de 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -2374,17 +2374,26 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
>  		WRITE_ONCE(cinode->oplock, 0);
>  }
>  
> +static inline bool
> +cifs_server_supports_per_io_unbuffered(const struct TCP_Server_Info *server)
> +{
> +	return server && server->dialect >= SMB302_PROT_ID;
> +}
> +

Unfortunately this check is unsufficient to tell whether the server will
actually support SMB2_WRITEFLAG_WRITE_UNBUFFERED and
SMB2_READFLAG_READ_UNBUFFERED flags.

Have you tested this against Azure server?  IIRC, the server would
reject the write and read requests with STATUS_INVALID_PARAMETER if any
of those flags was set.

I had a patch to use those flags and improve reuse of open handles but
then gave up as Azure server seems to be the only one broken regarding
those flags.
