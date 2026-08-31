Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EC23002DD;
	Mon, 31 Aug 2026 22:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214536; cv=none; b=C+9Fqf2H925t+JWpoGQeBIOFVgT1urfvQyNfwlaQZlXEUqmhcKlN6DUPJPXUYL6z6o631YAX3F5xC0bseNbTvvTgXL7E3STN/P2rEp2OlkOeKZJNZN16Epjdq2GJ2pFGgkjZDZzOxZ83aJBl1qolP0+2yJXLvx0WMbCRVSiA5qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214536; c=relaxed/simple;
	bh=l4haeV6VhtUB3oibnyraeVizUHKDvnuEXG4rWi6pXek=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=W+FviQapB1rDIG7bMUQEjHZedThsQcLVE6I3DSsDGUdKXvx9ugyxtpqZp2Q/CcBx1P+ATHm7FVOdZBinPGi0lVtROQBxIZkxO99hg6nLa7w9R0+vdjk2HrPcRWaYH9fIIdujlD6tCjHPtTvvam7EpBrbAL4LIENfbw+5YAR9yEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Q5EF2Yer; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Q5EF2Yer"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7eEXQnZ3TyFS1iy6IZK3Iv7UtyMqIYCMseVZ2nJyG6g=; b=Q5EF2YerUQmijCvcfG7FC5GwE3
	NNzR5bthohB8gaK1/15JS4VI7qizr14KbmvXe0gR+9/2GekADtxHeFD/tsSbWhUpm+tm1HVY6gpwt
	DPRm559/bqF3fy9ATPpXEZ2aNMtul15RloQmNJBgEGlj1jx/Ifkju/k6EMCDWnZIeFIGjSJBNBy0/
	GDduOp4n0/a1mFRsXI0E/jG3YWwxuGnTWLD6nwyodtWV/gXdi/kWZx/fgAu+xSmtovyTbstRq4xvI
	5zwaXzXvPyYvIcBfeiGf8FtvF4wG7pk8rugYsIFONB0MTGrwvGPdiHuna6aXl6Iy4cxeP5VlbN4QW
	PcGb74Vg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1AHk-00000000NLF-0nUP;
	Mon, 31 Aug 2026 19:15:24 -0300
Message-ID: <0abfb2d2f99e54aceac4cea63947b65a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Diego Oliva <diego@bynar.io>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: reject out-of-bounds DataOffset in
 CIFSSMBRead()
In-Reply-To: <20260831125045.479576-1-diego@bynar.io>
References: <20260828150203.1419003-1-diego@bynar.io>
 <20260831125045.479576-1-diego@bynar.io>
Date: Mon, 31 Aug 2026 19:15:23 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Diego Oliva <diego@bynar.io> writes:

> The SMB1 synchronous read helper CIFSSMBRead() validates the server's
> DataLength against CIFSMaxBufSize and the caller's count, but never
> validates DataOffset. The copy source is formed as
>
> 	&pSMBr->hdr.Protocol + le16_to_cpu(pSMBr->DataOffset)
>
> and memcpy()'d for DataLength bytes with no check that the
> [DataOffset, DataOffset + DataLength) range lies within the response
> actually received from the server.
>
> A malicious or compromised SMB1 server can return a short response
> carrying an in-range DataLength and a large DataOffset, driving the
> source pointer past the end of the response buffer. The memcpy() then
> copies adjacent kernel heap into the caller's read buffer (information
> disclosure), or reads unmapped memory and oopses (denial of service).
> SMB1 is not negotiated by default; reaching this code requires an
> explicit vers=1.0 mount.
>
> Both DataOffset and the received response length recorded in
> rsp_iov.iov_len are relative to the start of the SMB header, so reject
> the response unless DataOffset + DataLength fits within that length,
> using overflow-safe arithmetic, before forming the source pointer.
>
> While here, make data_length unsigned. It holds a length derived from
> an unsigned on-the-wire field and is only ever compared against
> unsigned quantities. This is not required by the validation added
> above, but it matches what the variable represents.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Assisted-by: Bynario AI
> Signed-off-by: Diego Oliva <diego@bynar.io>
> ---
> v2:
>  - make data_length unsigned, as suggested by Namjae Jeon
>  - rebased on current upstream
>  - v1: https://lore.kernel.org/linux-cifs/20260828150203.1419003-1-diego@bynar.io/
>
> Note for backporting: this uses the smb_EIO2() tracepoint helper added
> in v6.19 with f80ac7eda1cf5. For older kernels, the call can be
> replaced with a simple return of -EIO.
>
>  fs/smb/client/cifssmb.c | 13 ++++++++++---
>  fs/smb/client/trace.h   |  1 +
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index f5aad5f61dce..b89d49395362 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -1720,7 +1720,8 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
>  	if (rc) {
>  		cifs_dbg(VFS, "Send error in read = %d\n", rc);
>  	} else {
> -		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
> +		unsigned int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
> +		__u16 data_offset = le16_to_cpu(pSMBr->DataOffset);

Shouldn't you also validate the minimum response size so that you can
safely dereference the above fields?  E.g.,

if (rsp_iov.iov_len < tcon->ses->server->read_rsp_size) {
        rc = smb_EIO(...);
        *nbytes = 0;
} else {
        unsigned int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
        ...
}

>  		data_length = data_length << 16;
>  		data_length += le16_to_cpu(pSMBr->DataLength);
>  		*nbytes = data_length;
> @@ -1733,9 +1734,15 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
>  			rc = smb_EIO2(smb_eio_trace_read_overlarge,
>  				      data_length, count);
>  			*nbytes = 0;
> +		} else if ((size_t)data_offset + data_length > rsp_iov.iov_len) {
> +			/* check that the data lies within the received response */
> +			cifs_dbg(FYI, "bad data offset %u length %d for read response of %zu\n",
> +				 data_offset, data_length, rsp_iov.iov_len);

@data_length is now unsigned, so use '%u' instead.  Also, print __func__
in cifs_dbg().
