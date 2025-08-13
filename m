Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2662E11BF;
	Wed, 13 Aug 2025 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071976; cv=none; b=fu/Cq/qxpau1LlNRg8aUtM2Ns0LlbtGZgNuCIYuI7EShJyyI0L8MQE6jIcHNfePLN602Ie+l+PnwTU8q4HVRsCDLnreAJcxGWbzSurpxf2bRamCloJzs7HoKWGeFB5XHWyMgmL0/AOPnpm3WwfZII3QzZiyIyEqNPut/VrnetzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071976; c=relaxed/simple;
	bh=x3xpEFV8uLf6a2pND96fpMgR7YVd5217mwc7nVOOzGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXbP+2jgT1h5up55P96fy2ufYAGr7puXYu0mcygEdE+RMd0cMbfiQJpCWJvlmTM2082m63L6Bz9i+18qpU8Rvj8HtLn+oVoqIB4eJ6gwlGiAUVBHSwSyG0KPamm8aPwbPMDqR4E+C258SGpwSvHLueU0X4rErQ6i7mBIoOxvFNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHl1yYkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHl1yYkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F61DC4CEEB;
	Wed, 13 Aug 2025 07:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755071974;
	bh=x3xpEFV8uLf6a2pND96fpMgR7YVd5217mwc7nVOOzGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xHl1yYkTISXLA7cEFlQhXssRs1w1JNEn0ctYWnOjq49LgQZ03YlzFTI5joh3oHBbm
	 GHNu9Z4L0iN8fvNk1m44rNAx35pDCGHL3sReoCoCWbYTbDAWFd+la0mddPV/vpljTC
	 GcxPWCxtxaotHq+y5kmV3GT7/U/9rCIRiqJe1+po=
Date: Wed, 13 Aug 2025 09:59:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 563/627] smb: client: let send_done() cleanup before
 calling smbd_disconnect_rdma_connection()
Message-ID: <2025081325-movable-popcorn-4eb8@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173453.306156678@linuxfoundation.org>
 <527dc1db-762e-4aa0-82a2-f147a76f8133@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527dc1db-762e-4aa0-82a2-f147a76f8133@samba.org>

On Wed, Aug 13, 2025 at 08:17:53AM +0200, Stefan Metzmacher wrote:
> Hi Greg,
> 
> Am 12.08.25 um 19:34 schrieb Greg Kroah-Hartman:
> > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Stefan Metzmacher <metze@samba.org>
> > 
> > [ Upstream commit 5349ae5e05fa37409fd48a1eb483b199c32c889b ]
> 
> This needs this patch
> https://lore.kernel.org/linux-cifs/20250812164506.29170-1-metze@samba.org/T/#u
> as follow up fix that is not yet upstream.
> 
> The same applies to all other branches (6.15, 6.12, 6.6, ...)

Thanks, now queued up.

greg k-h
