Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD5E36DA16;
	Wed,  8 Apr 2026 06:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631527; cv=none; b=ZyB4MeS2N0U31M6ObBOVqi/anMGDHqMo3d9tx4ygIVe36zHarfc9cx9jpZMDmlD3j3bASjWtmJ0p/vQMDeqYbxbzGJxsi8dA/niEOV5K+HqoPsRMV9VxWeXyZPlTXOjDgEVLS7N+cGfIZ1YAxnpGOYoNl61yadl/OmIp0fO7Vl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631527; c=relaxed/simple;
	bh=ydOZvHMnEanUmXgYbqc6wkG84oVARJV1WZguFd5BtlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jw8M4dHx/cElRl9pmJNObCu7US6Lhc2gUjlLADfMXaqewUoHBDBMrdXUkSlQsD7qvMgv8QCE1B3UjFmyjflCQPJLTEebuMLcxnBUDw2pEqikxLU2Sa8XLnNFs8yGJ6gBmonEYvYhX2hBBjc3AmMHVfQhQ9wy7d5Is5pkZooGkoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCQUWXsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCQUWXsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C0DC2BCB2;
	Wed,  8 Apr 2026 06:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775631527;
	bh=ydOZvHMnEanUmXgYbqc6wkG84oVARJV1WZguFd5BtlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aCQUWXsZnIt/mSqfOF95twJd+DleGfxWYE+Z9jQwJ3Fi6LAKdeQv1A4nXyiFTYtGw
	 AqdKWDEuwzOnYO3t0RKZbzjZo+K1+jE8bc09x+vigyYzO0C50bfeLozCPYdHf5huka
	 AzzVlEhLM+F6+EqVfcgDibdybMRg1ZIWy2IQu7w8=
Date: Wed, 8 Apr 2026 08:56:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org, stable <stable@kernel.org>
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
Message-ID: <2026040829-control-capacity-1806@gregkh>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
 <2026040822-shortly-chump-8518@gregkh>
 <68bc86cc-1c57-4734-9c75-14c9de80bd71@chenxiaosong.com>
 <2026040833-espresso-triangle-425d@gregkh>
 <c7c0fcc2-ebdb-4ba0-9c64-fadbd57137fd@chenxiaosong.com>
 <2026040846-winner-juniper-096c@gregkh>
 <0568bec2-b85e-4b5e-8765-8acc3d779c82@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0568bec2-b85e-4b5e-8765-8acc3d779c82@chenxiaosong.com>

On Wed, Apr 08, 2026 at 02:52:31PM +0800, ChenXiaoSong wrote:
> Sashiko found it, I just checked and confirmed it.
> 
> Could you create another patch? I enjoy the review process more than
> creating patches :)

Will do, I'll add that to my queue, but might take a few days if someone
wants to "beat" me to it, I'll have no objection at all :)

thanks,

greg k-h
