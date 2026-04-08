Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76BA36495E;
	Wed,  8 Apr 2026 06:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775630428; cv=none; b=dDO7u03NUdFMQCPyceyjHDtGI+6dnAXyneQjtj2HWvkNj3OcEeShB3btGtPwXj3xjKgdtszpVFXtX6Ty57oZ1BJHaAp5IzMEqtyIgVFI1QB4XU0f9zTj4WWW+DqhiljY8aMXKdhyW6bVDMZakn6sXCsR5SuyOmLYgjoipw4WXLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775630428; c=relaxed/simple;
	bh=DZr/CyiL0tBakOiW+bpiDccVL3DKrCbola+AqUVIKWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aw+/HwDbKEPuhMD12zvrJsUQ2Iwb/otfUa0axZnC8zFOG28WV6h/sQBJrxyuTSgHcsk3CZ1Lj7IPrky0lnI56OJAxxhChuZsuDJpkPTWKR4lxAnnKE4VpdBbQZWQtbvqVxIvnvpKBa7Rrw1PVRg5RFZE3m4yjQ7BvykCSALHkx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeHoV0z5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeHoV0z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75A2C19424;
	Wed,  8 Apr 2026 06:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775630428;
	bh=DZr/CyiL0tBakOiW+bpiDccVL3DKrCbola+AqUVIKWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FeHoV0z52X3UhIEEeJHa7ZUwS42Udn4WyW57/pzPC+O9V42puHr9idD5eLcyQfPz0
	 dcEwbZN8is8HvoqyLqgIXNQlej9KIHnJsjAUCP68ZF+6H0m2hsmGLGFOK3W/ct2Mms
	 MTocVZK6EbOAKJQ2DvUDG4/YID17dQCTg13VQVxU=
Date: Wed, 8 Apr 2026 08:40:25 +0200
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
Message-ID: <2026040846-winner-juniper-096c@gregkh>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
 <2026040822-shortly-chump-8518@gregkh>
 <68bc86cc-1c57-4734-9c75-14c9de80bd71@chenxiaosong.com>
 <2026040833-espresso-triangle-425d@gregkh>
 <c7c0fcc2-ebdb-4ba0-9c64-fadbd57137fd@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c0fcc2-ebdb-4ba0-9c64-fadbd57137fd@chenxiaosong.com>

On Wed, Apr 08, 2026 at 02:19:48PM +0800, ChenXiaoSong wrote:
> Could you send v2 with this check added?

Looks like this was already accepted, and the additional check would be
just that, an additional check :)

> I am currently reviewing another patch. Perhaps you could wait until I have
> finished reviewing it.

I have no problem waiting, but as you found this one, I want to give you
proper credit for the find/fix.

thanks,

greg k-h
