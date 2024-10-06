Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A231EB36;
	Sun,  6 Oct 2024 10:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728209332; cv=none; b=d6r70cW4ShkoxXn4kEsrxW4U8jEbjxP8RfjiLxaPW4dm9zO1EhmWOhu6y9pL45OnjVWUKfP1igmt3F8hyb5QGFr37/z7aIdQ0umqApAr1q7iXtAGU+zWPD31WEo6L3CeLXqN39TZwyqMvkmSHXqEi1Z31P2tId1z5rbI8OgjFlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728209332; c=relaxed/simple;
	bh=kYVOQ+DJUn8ovZlLq1ujKxMx5WjvYg4tFtTaJNTPe4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3phqYm2sWSzvAu1sxI9xmD3dWJOQZ7HjJIhVv+vin20SmESAe3ISPBw0lTUXDguJNxjoOr7lQ4Re7zIejWMRQRPIXizokBZPGjlHexqMb77F5BTyY24uNW8Pk8YswucBMZU1nCJkqHpoOMBQREICMgY+ZaRV5kIzuP1ffa8DeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EedZDLcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EedZDLcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35976C4CEC5;
	Sun,  6 Oct 2024 10:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728209332;
	bh=kYVOQ+DJUn8ovZlLq1ujKxMx5WjvYg4tFtTaJNTPe4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EedZDLcCMA0OmSXOvD0iX6xnuDzWiDC64ic9hSY2nPlwt8NLc6oFqx/46MhVfKL4C
	 6V5iROppm7fLC5j6xsXAZAqrT62HNiZiyJ6qkO06HoePWpQ4mpCChp1FZpBh29KuMH
	 u3FsXdr2CF/2Ilndhck2BrKx/oyX+q4WHqbqpH/jV99KbV/5eDUmKaj+OPC1OSKr3f
	 pXDFhBVk7sZbUjRSDz2+uUJGOnVmFkoAp7mVgU2Yp/MoNgkOwtcpx4YHgEAT+WsM7/
	 tESPg3qTRrQd39s8sVXIGWAC/a238wvmIS1w14EoY5FDXn3zm19XDVK+c8iMg/OGnP
	 Lh2i3sfYKV83Q==
Received: by pali.im (Postfix)
	id 1C61C81A; Sun,  6 Oct 2024 12:08:46 +0200 (CEST)
Date: Sun, 6 Oct 2024 12:08:46 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20241006100846.ya5rxpu4z75yaqas@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
 <20240917210707.4lt4obty7wlmm42j@pali>
 <7f29cbf81602313df348fe6d36bdb0e2@manguebit.com>
 <20240923181000.4x5uzjbllvz5kjhw@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240923181000.4x5uzjbllvz5kjhw@pali>
User-Agent: NeoMutt/20180716

On Monday 23 September 2024 20:10:00 Pali Rohár wrote:
> On Tuesday 17 September 2024 18:17:08 Paulo Alcantara wrote:
> > Pali Rohár <pali@kernel.org> writes:
> > 
> > > Would you be able to fix the client code to do this?
> > 
> > Yep.  Will send it to ML soon.
> 
> Perfect, let me know when you have a working version, so I can test it.

Steve, Paulo, I think that fixing this part of he code has higher
priority than any other my patches as since commit ea41367b2a60 ("smb:
client: introduce SMB2_OP_QUERY_WSL_EA") Linux CIFS client is not able
to fetch & recognize any reparse points from servers without EAs support
and also from servers which do not support reparse points and EAs
together, which are all non-recent Windows SMB servers.
