Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46156211A1E;
	Thu, 12 Dec 2024 12:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734005394; cv=none; b=O1t2BUeV7nnF0Wg1G9IJ/Cb1Bg8iLXO4WEiCYgxZUumIZ9r+qoldVoiuXgmC3l1GjUt/nhdsWMJD5hHtGAZsnUQADDTYwhbEQsD4LqtG/BZY2dnHLtm2GMump+jfUJI+0UzyjngUYnDDKoYmL9bw2KT/3LSVf/C57HsVhJLm9KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734005394; c=relaxed/simple;
	bh=U59/QLEl7hYdBEpB1dXTAZwPI8WQJUNGqd3XEIbuTu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1bonTp7Ei/OYt60aw3RJW7kK/3HgZzxCOqFG5ff12u2hStLdWDuHx9BfVkU4zeN6uDIDyongS/3s6ugrk4OcQBR/her44ZT8NsdlB69pgkCxy2L8G06wTWP7nX44IFZ5Qu1V+XWTZxnzNxIrc6eoPjwFq4cbQ/QBmsAoE0VaPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqJ0dtRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqJ0dtRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D8BC4CED0;
	Thu, 12 Dec 2024 12:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734005392;
	bh=U59/QLEl7hYdBEpB1dXTAZwPI8WQJUNGqd3XEIbuTu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gqJ0dtRL1hbkI6dj8gHqlznbjIRPsWmebAsIa29f66JCocZyEdkI97cvA8SAEp0wi
	 wTKisIHb9AelfijHOjQchtxpHCEaGBnYLRVxAOyT9zLSM1urllO9EdpMyVLtMVBg9T
	 +WqhCeq7q8opvqM5o9p40U02+f8xWe8v6H74uU1c=
Date: Thu, 12 Dec 2024 13:09:49 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: pc@manguebit.com, stable@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH 6.1.y] smb: client: fix potential UAF in
 cifs_dump_full_key()
Message-ID: <2024121236-jaywalker-outweigh-1c81@gregkh>
References: <20241209085813.823573-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209085813.823573-1-jianqi.ren.cn@windriver.com>

On Mon, Dec 09, 2024 at 04:58:13PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Paulo Alcantara <pc@manguebit.com>
> 
> [ Upstream commit 58acd1f497162e7d282077f816faa519487be045 ]
> 
> Skip sessions that are being teared down (status == SES_EXITING) to
> avoid UAF.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> ---
>  fs/smb/client/ioctl.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

You sent this twice, both different, so I have no idea what to do at all
:(


