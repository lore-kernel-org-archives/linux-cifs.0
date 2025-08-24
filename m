Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598F581720;
	Sun, 24 Aug 2025 08:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756025264; cv=none; b=r88gbqBcOWkV7N3C7/vgwId14lnvefouO3mDao0A8SMBfEXw7RPKzWMy2p3UB50lNtezJl2vAEZVqYum2ErblQPCP2Mci7fnCw8BRp9SsEoqkz+9NXDhbX+05WsIF8/AVBEg/XC6boL+LjHrqpUxq/FT+BftWzi3KBCl0FEN2+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756025264; c=relaxed/simple;
	bh=4qnfj7B1/34ClaygFGmlMs5FPlCUiwOd4no144xlpQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDa3VdBVRqh3UCsKt+Z+BYKaYXX3X1AWUYnTwdkbxCbL7q9i9rXCLqBe6fUyYqz4mKQhF68uX2nl4Z42m5A4eHTSknOmgwKuW7sXxTaUZka5jbrpDygKz2Yq4sSsQCXPCUJGxLCt/kh9bem1I9+c275JrSkSnZ1C2yybYZrV524=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kW/LdunO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kW/LdunO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746F2C4CEEB;
	Sun, 24 Aug 2025 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756025263;
	bh=4qnfj7B1/34ClaygFGmlMs5FPlCUiwOd4no144xlpQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kW/LdunObntnN1FJ89EJQFLf48CJElZ1pnPEordAvUk4pek15IKEmKREloZouTjgo
	 +CGYAnS0JlCaF0HhlI3ALsvx9WddkmyZsNpuqlpuCGfz5aW/vd63zz+AiyoLRaGjDF
	 5ob9us/0Kzdv7oZAux4zHGya+gmACEGqQwqADJEo=
Date: Sun, 24 Aug 2025 10:47:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	gunho.lee@lge.com, sashal@kernel.org
Subject: Re: [PATCH 0/4] smb: Backport UAF fixes for v5.4.y
Message-ID: <2025082410-finless-amused-5edc@gregkh>
References: <20250811094639.37446-1-chanho.min@lge.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811094639.37446-1-chanho.min@lge.com>

On Mon, Aug 11, 2025 at 06:46:35PM +0900, Chanho Min wrote:
> This patch series backports four fixes from v5.10.y and later to the v5.4.y,
> addressing potential UAF issues in the SMB client implementation.
> The patches have been adapted to account for the directory rename from fs/smb/client/*
> to fs/cifs/* in v5.4.y, ensuring compatibility with the target kernel.
> 
> Paulo Alcantara (4):
>   smb: client: fix potential UAF in cifs_debug_files_proc_show()
>   smb: client: fix potential UAF in is_valid_oplock_break()
>   smb: client: fix potential UAF in smb2_is_valid_lease_break()
>   smb: client: fix potential UAF in cifs_stats_proc_write()
> 
>  fs/cifs/cifs_debug.c | 4 ++++
>  fs/cifs/cifsglob.h   | 8 ++++++++
>  fs/cifs/misc.c       | 2 ++
>  fs/cifs/smb2misc.c   | 3 ++-
>  4 files changed, 16 insertions(+), 1 deletion(-)
> 

We need these in newer kernels as well, otherwise you will have a
regression when moving to a new tree.  Please resend patches for all of
the relevant trees and we will be glad to take them.

thanks,

greg k-h
