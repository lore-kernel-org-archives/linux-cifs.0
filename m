Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F888F5B
	for <linux-cifs@vger.kernel.org>; Wed,  2 Oct 2024 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727894370; cv=none; b=uO/Z3rhEShoLnh7V+WTdd5JyUEJScFlRd2/im14TKA9eZkDDYdz/HUentNkTRZfAAJhq2bO+zk1naUEx8bHmPi7QdQvbmPP1wL8fr3qDQLFWtW9rWRj65eRr2SRw/KORTLua6Ul5GbBF5obMqehOjCIP3FUr00BOTDvbChvNnEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727894370; c=relaxed/simple;
	bh=DdphyFpivaktk5qpHCv0fHTpTcwElSNvFeR3814KHig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EL69hW1KKDIVENWTBsV9A4c3BANrkCkMAtnnJ3kiIZynlzz9VQhVnyNJ66xQ9P3pC7PEmZAP1IIXtL/vlh7u1tDJs8peA2W2a0ni4PS1bpX/3lbM044mDKADMXcH1HHFh5EcjF1Rua87E4owUHxob5gi3QjK8Q2fV0tOJjK+sKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9Xr/XWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9Xr/XWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A51FC4CEC2;
	Wed,  2 Oct 2024 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727894369;
	bh=DdphyFpivaktk5qpHCv0fHTpTcwElSNvFeR3814KHig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b9Xr/XWwpE0Zb/bf5ABAWHQiGpZOqb7tJfrjwMd5w0xVjbQRe8MHDzJAYy21CedMX
	 CUpnv2bZUxGPPfT9uYQWKxbwpLjec6JoCaHhyrFoPNQtb7KFt7vtDPg0Ek171r8qa0
	 ccKDMC1V5N/EZFN82rc6xg9PW1b+viX49QaAOKBiWNqmb/EqmtY7FiLP7QZICog5zo
	 2yRoLebRyqtsEvU7bqbB9+Ul75GjBpIM4/5moAkoP59mhznQatIeHPXb4RWXeFtGFg
	 xHh8kxlxUthjqRDtR0I7PIRNIRlfjsxBPL4UFF7BeEYwKzxnvgQOKlRFmwRqPwElOb
	 EKwWZhKNvsD7Q==
Received: by pali.im (Postfix)
	id 97C61708; Wed,  2 Oct 2024 20:39:23 +0200 (CEST)
Date: Wed, 2 Oct 2024 20:39:23 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>
Cc: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Subject: Re: SMB POSIX Extensions specification
Message-ID: <20241002183923.mgk35xzp3rar4oxi@pali>
References: <20241002073519.2fee66fwopzy3dpp@pali>
 <56ac8ed5-781d-4ca9-95e6-75a6e52c34e3@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56ac8ed5-781d-4ca9-95e6-75a6e52c34e3@samba.org>
User-Agent: NeoMutt/20180716

On Wednesday 02 October 2024 09:44:12 Ralph Boehme wrote:
> On 10/2/24 9:35 AM, Pali Rohár wrote:
> > Hello, I would like to ask, is there any normative specification of
> > SMB POSIX Extensions? Because I was not able to find anything in
> > MS-SMB2 and neither in other related documents.
> 
> this is still very much WIP.
> 
> https://gitlab.com/samba-team/smb3-posix-spec
> https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> 
> I'm hosting WIP html versions here:
> 
> https://www.samba.org/~slow/SMB3_POSIX/
> 
> -slow

Thank you! I see that most of the information is still missing.
