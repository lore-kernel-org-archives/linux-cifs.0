Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65EA377A95;
	Mon, 12 Oct 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814252; cv=none; b=mQixJWj+40j/zvEgKjSEuHJnpjgy0zhIIvjIJb1fvHYU1tvQIql6nsKUj/EtQTAXsXnKxlWUWQJVGKO0RP36KP3uL3nzRbDtFOJI6xNvWQfP0b511mbcqrsyqM0tFIwIClk3JAN9VMs/x/nT0Erukijl9GtjIg/9mz9JWaWq4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814252; c=relaxed/simple;
	bh=3aOCEyp/2J+J8YqGSGYqbA06IHKpdnZKyFsaGuAQA4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kx7LfPRX+XXGFWZtx+BDdgciLGn4uL+M3rmCACpqnsWaqJt3fbnSss6Sh+66DBVQ922CeV5/D0NppA4UJiHnH6uaBJhtg3l0wNaceFn3BQrs05P8xmO/k9Y9dpKERo1KgHAq27k0Ir0MBfgdQNhXb884bqbG8o+wCNSW3wX3PvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSRfaM4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSRfaM4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418641F0089B;
	Mon, 12 Oct 2026 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791814251;
	bh=27I2gRXR13lAFGzMq/TZGlEA/Q+QsxnDcCEZSMnGl7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CSRfaM4ZzL+PLrBs1gqF8OWuKdoYVJEJunhPpGU+/wwVvMy7FHj7ryxHU+/OzOk9B
	 6cOn7s8NzdKmVu+hMHZuMdWsaXjcm2/kFpnrCPXqK1CBvM/i0yBZh/FSuizIWPiCEg
	 rX2IM3mWmLlouS5ky/T1fN/thD+W+ep2IBFFC7uL3VHSxR3UEg0GUR3/dqcio6KBnQ
	 V4GgH40CSyrooCii/GS+iGyMtLNrgOhTEx86fknEfHrdSvJ+2yQYP1oRlAnQnqZLw9
	 wF6GvSeZb7Gmg+a7UFl8jFoIqD4DPKA6m/Sq07NI2RWLoUuL67MggiXjKd5iaH2muF
	 sEoJyN+fAe7bw==
Received: by pali.im (Postfix)
	id D279083A; Mon, 12 Oct 2026 16:10:53 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:10:53 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Various changes
Message-ID: <20261012141053.4ud5pihrtrxpkxfy@pali>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260825230622.24617-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

Hello, now when is the -rc7 cycle, could you review these patches?
So if there are any issues, I would have a chance to address them for
the next merge window.

On Wednesday 26 August 2026 01:06:13 Pali Rohár wrote:
> Rebased changes on top of the 45c13f3f9e3bb15fd89ff2864c6f627a3b4b4229.
> 
> Pali Rohár (9):
>   cifs: Remove code for querying FILE_INFO_STANDARD via
>     CIFSSMBQPathInfo()
>   cifs: Remove cifs_backup_query_path_info() and replace it by
>     cifs_query_path_info()
>   cifs: Fix validation of EAs for WSL reparse points
>   cifs: Validate presence of EA $LXMOD for WSL reparse points
>   cifs: Check if server supports EAs before trying to set it for WSL
>   cifs: Extend ->set_EA() callback to allow operate on reparse point
>   cifs: Create native Window socket file compatible also with WSL
>     subsystem
>   cifs: Add support for parsing WSL symlinks in version 1 format
>   cifs: Add support for creating WSL symlinks in version 1 format
> 
>  fs/smb/client/cifsglob.h   |  10 +-
>  fs/smb/client/cifsproto.h  |   1 +
>  fs/smb/client/cifssmb.c    |  43 +++---
>  fs/smb/client/fs_context.c |  11 +-
>  fs/smb/client/fs_context.h |   3 +-
>  fs/smb/client/inode.c      |  98 +------------
>  fs/smb/client/link.c       |   3 +-
>  fs/smb/client/reparse.c    | 273 ++++++++++++++++++++++++++++++++-----
>  fs/smb/client/smb1ops.c    |  11 +-
>  fs/smb/client/smb1proto.h  |   4 +-
>  fs/smb/client/smb2ops.c    |   6 +-
>  fs/smb/client/xattr.c      |   3 +-
>  fs/smb/common/fscc.h       |   5 +-
>  13 files changed, 297 insertions(+), 174 deletions(-)
> 
> -- 
> 2.20.1
> 
