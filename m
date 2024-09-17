Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD897BA3D;
	Tue, 17 Sep 2024 20:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604966; cv=none; b=nUdQLFjv9TiXRpmbW7ulpMP0ZpmVV4vbaB44V5egposZI2Ir8lYr/isU3H9jPAbE4lFMpZ/W/EZEj8rGP+E8SsosyweHpVxRxJ1xtxiMyOLugp24ABLMvODVJurchi57AyJRuGEYqwT/kbaRNeWVbOptOWVdInP69bPpbP+fjIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604966; c=relaxed/simple;
	bh=1u5qfbV/wXkrEI1rMOo37jka3EKwNBRi2E/srOJMWo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L4Q6gJcDWg98i5LMW2B9ZcQyR9T+xyxbeycixTkyCYkEUBE/Gm9BA0ej6WLbkWuE9BqP8IpzCwEkkdqr9ZzU6VAlpQwHsgRnJTqBi/Rgmu4FUuxxksPYHF+maz6nLbxEKLBbMI/r4nad8/t6dL+H0E6jMF0rS4iP8EgqNG1vlgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cV5LWwiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cV5LWwiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EFBC4CEC5;
	Tue, 17 Sep 2024 20:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726604966;
	bh=1u5qfbV/wXkrEI1rMOo37jka3EKwNBRi2E/srOJMWo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cV5LWwiMqV9Hd4NgJk2qDLcrZbaJ214LCPgacUASDXZq2snJ86k3e7x8eZXR8vtBh
	 uFh9mPp/Yv3WNxo8gVbCVdo4N+VLo8TDOUg9XbsnyjOz2cH1QVMRFtoufWqGU21FwB
	 SGsAPuH7E1Nw/2+6QZoUJ/XsGwZ0yv4hWDPNBN+/bpvqX4szge4idP+aG33kNYyXKH
	 /EDPCfaNLM7Ig7LNrgKl0MBCN+fHC3/RA8WJ/DfrKwQ9w5JzuRTBOu2xszefUDc7JL
	 +IsfT5/IBHi8MY/veXmf4GD9tgnziTkLzhqYQpTHuwcOSmUu9RlNY+eM9snnhzkMx4
	 kNdHg9QZSBD1w==
Received: by pali.im (Postfix)
	id 3BD577BA; Tue, 17 Sep 2024 22:29:21 +0200 (CEST)
Date: Tue, 17 Sep 2024 22:29:21 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20240917202921.ty32zzmhrg33knpy@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
 <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
User-Agent: NeoMutt/20180716

On Tuesday 17 September 2024 13:23:40 Jeremy Allison wrote:
> On Tue, Sep 17, 2024 at 10:06:00PM +0200, Pali Rohár wrote:
> > And seems that SMB2_OP_QUERY_WSL_EA is useful not only for reparse
> > points, but also for any regular file or directory as it can contain
> > UNIX mode and UID/GID ownership.
> 
> uid/gid should *never* be exposed over the wire for SMB.
> 
> That way lies madness.

Hello Jeremy, if I understood wsl_to_fattr() function correctly then it
is already doing it, it fills uid/gid for stat() from data which were
exposed over the wire for SMB. Could you check that function if it is
truth?
