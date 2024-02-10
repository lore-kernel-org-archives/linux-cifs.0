Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD71D3612E;
	Sat, 10 Feb 2024 10:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707560510; cv=none; b=piIgJ2+/HSmlRiNeW5MeEIE1PUIc8FWIo2kunnWgBzIKQtNxC7uGkV87BgK3u9GWmGBiHs/C4+rJcZHCkjDuHGQEOpoE8S9QljlRp1moyso5nhYLOYem9QF4zKfrFmo8N156rmKjpUal75cvt6e9hW0ydib+2TnpS/ecFG9j6gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707560510; c=relaxed/simple;
	bh=Dsxo8YjEUONWUnrqrGPvbFDLMUbCP6guDxtq2y91Umk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ba8K9ytQOFS6SweIzfyN/F0LsyWNwLdBAYJEs5f3fgwjSSypJ815ta1diVI7vvaOaoClAnIirud68BxRDeCAYkEKnd7wYsCENYAWtiSQwsWkRNropuumtt/i7NwPBFsiScw4B6yjjj05g7+rF2wwvhkp+KBkRHb32sgaGCmRjWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id CA06E72C8FB;
	Sat, 10 Feb 2024 13:21:45 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id BC7BE36D0246;
	Sat, 10 Feb 2024 13:21:45 +0300 (MSK)
Date: Sat, 10 Feb 2024 13:21:45 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Convert struct fealist away from 1-element array
Message-ID: <20240210102145.p4diskhnevicn6am@altlinux.org>
References: <20230215000832.never.591-kees@kernel.org>
 <qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf>
 <202402091559.52D7C2AC@keescook>
 <20240210003314.jyrvg57z6ox3is5u@altlinux.org>
 <2024021034-populace-aerospace-03f3@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <2024021034-populace-aerospace-03f3@gregkh>

Greg,

On Sat, Feb 10, 2024 at 10:19:46AM +0000, Greg Kroah-Hartman wrote:
> On Sat, Feb 10, 2024 at 03:33:14AM +0300, Vitaly Chikunov wrote:
> > 
> > Can you please backport this commit (below) to a stable 6.1.y tree, it's
> > confirmed be Kees this could cause kernel panic due to false positive
> > strncpy fortify, and this is already happened for some users.
> 
> What is the git commit id?

398d5843c03261a2b68730f2f00643826bcec6ba

Thanks,

> 
> thanks,
> 
> greg k-h
