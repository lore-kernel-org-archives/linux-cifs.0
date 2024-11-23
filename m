Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EBE20E3;
	Sat, 23 Nov 2024 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732364459; cv=none; b=DuGcGP/JKbT7vE2yHqypM4YNAHhzOOcSziNwDMtvuRIFsA8imb4EeCpHyRUemOAU9cBm/wW5D/sPUiM5dz0HwFyCQqrCgFajl8xKXwmyP/ZrzbW7Eb+CkP71U7coGeSb9xLp929/Gy3lZqPEw+qglmM6n9h0Moo2T0y1ig5sDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732364459; c=relaxed/simple;
	bh=ChIgCQEgpQUlDyNAj42KbHsG7tPfZ6kxOQMBnO1CVNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eqc/fH5M4p+Bc4/qldPaV8LSuF+L4OdrpN8sefEakD6rp49hjemsU1ooWRTcBEDHqjlJ6DX/zcb/wATcv5m3dEktzjjKRgXC28HOU3XvM5x5X1csFicJJBViLNySZhnEWY+s4aa4eybSegK5PRdKJBrPItSfBjF6nluhwnuvjKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3GP7hyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3GP7hyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410D0C4CECD;
	Sat, 23 Nov 2024 12:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732364459;
	bh=ChIgCQEgpQUlDyNAj42KbHsG7tPfZ6kxOQMBnO1CVNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H3GP7hyWq9FOmNmfIP8/fYcpbdhTzKY+aPqENMOqUgn5j9fKrRGlD4b5fZMiilKMZ
	 olTLuhmr0Gzh8twfTm4K+EwrJ2NoGRhIHPM+lxmTvUIUjKCbyOXrhQD9EUSQN1R7TC
	 +HRV23hRPdNsrTMRSKxsLC8Ur4fBuPFERvYzRAMkpdL30KTFN2zBS70btYSWkAZd6P
	 6mIImJJjgHmFdXViXUcDAYQGcP6qjFjX8ojU1bu68faNczu/LiAGChZ8CuOErRsgiY
	 xd6noHJWO+R6PF8FkzF5IMO48XCFNkDHacqQeS9lWZ8Qau5yXUF6TBv8f83CWr4/4R
	 Qml8CFwalTv2Q==
Received: by pali.im (Postfix)
	id 8EA66476; Sat, 23 Nov 2024 13:20:50 +0100 (CET)
Date: Sat, 23 Nov 2024 13:20:50 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Mahmoud Adam <mngyadam@amazon.com>
Cc: gregkh@linuxfoundation.org, stfrench@microsoft.com,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix buffer overflow when parsing NFS reparse points
Message-ID: <20241123122050.23euwjcjsuqwiodx@pali>
References: <20241122134410.124563-1-mngyadam@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241122134410.124563-1-mngyadam@amazon.com>
User-Agent: NeoMutt/20180716

On Friday 22 November 2024 14:44:10 Mahmoud Adam wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> upstream e2a8910af01653c1c268984855629d71fb81f404 commit.
> 
> ReparseDataLength is sum of the InodeType size and DataBuffer size.
> So to get DataBuffer size it is needed to subtract InodeType's size from
> ReparseDataLength.
> 
> Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuffer
> at position after the end of the buffer because it does not subtract
> InodeType size from the length. Fix this problem and correctly subtract
> variable len.
> 
> Member InodeType is present only when reparse buffer is large enough. Check
> for ReparseDataLength before accessing InodeType to prevent another invalid
> memory access.
> 
> Major and minor rdev values are present also only when reparse buffer is
> large enough. Check for reparse buffer size before calling reparse_mkdev().
> 
> Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> [use variable name symlink_buf, the other buf->InodeType accesses are
> not used in current version so skip]
> Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
> ---
> This fixes CVE-2024-49996, and applies cleanly on 5.4->6.1, 6.6 and
> later already has the fix.

Interesting... I have not know that there is CVE number for this issue.
Have you asked for assigning CVE number? Or was it there before?

>  fs/smb/client/smb2ops.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index d1e5ff9a3cd39..fcfbc096924a8 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2897,6 +2897,12 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
>  
>  	/* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
>  	len = le16_to_cpu(symlink_buf->ReparseDataLength);
> +	if (len < sizeof(symlink_buf->InodeType)) {
> +		cifs_dbg(VFS, "srv returned malformed nfs buffer\n");
> +		return -EIO;
> +	}
> +
> +	len -= sizeof(symlink_buf->InodeType);
>  
>  	if (le64_to_cpu(symlink_buf->InodeType) != NFS_SPECFILE_LNK) {
>  		cifs_dbg(VFS, "%lld not a supported symlink type\n",
> -- 
> 2.40.1
> 
