Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E511EA84;
	Tue, 10 Jun 2025 17:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749576145; cv=none; b=GPYRy7/x5QaRUFHbdZmj5lHbMCKDP/kG/H1zDDEu5Rmg+zfEvpRJ7xTdixVgDn4p4WH0TOpZCuEzZa9s1sjOd2X7QsnyRykwzcyGTTH2fu/Qc4nxdAO0fZhxX7uLkkQTfICDltrLV/RT6lQohSTPHB4O5+j3lkZ6U11XKFlbeqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749576145; c=relaxed/simple;
	bh=kHd9TSsDO3XtYFoP3Nh+aS09i0CUcGaeMZaA/3uwS90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NA0AUq6tC58baeNMlYBnpmQEb0lLZmaRepUub1TUBTRSiVySYV/y440VARDk2ujHYMRxGRHPqvld6cY8SZRKfewAWSRxuVwGtk88Ec18Q+CPhvlb0N2Tv9z/kn3A0vleOfvCG5iU6/gsFvw6+Zry2YFT/q5zf9QnpfHZvuUnpqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNa88WkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNa88WkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD785C4CEED;
	Tue, 10 Jun 2025 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749576144;
	bh=kHd9TSsDO3XtYFoP3Nh+aS09i0CUcGaeMZaA/3uwS90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BNa88WkYu22NGWzNJERk+StVFSXzdJtx+G7mGu5A54jaQNlyHA+H5l4cLqc2ltUTp
	 jEbpkN+eoAPeiAog9B/7a2Cg04OKjG8diObEWx1Ts1rlCNGL1p8F7FAoonIEuiR5+0
	 p9eTDAEU3dTeK+nIyyNeScHkUeEISJ1v1NpE271G388hpZ4KX9dXS1IuITRyK+5hwH
	 S/JUBcP2DVoOsgE90c+akTTBlYuNPeVqr28Ak6BbHCUN4D0bPzxSDuxlhKW3EOtr8j
	 Zt9PoPvR9DWumrVTWSVUG6eOObjgwJpBaPIWNHySuxaHYL79vQqpiqaOLIfkhL2WbI
	 E654Wk3C2KLlA==
Received: by pali.im (Postfix)
	id 1F7B44F1; Tue, 10 Jun 2025 19:22:22 +0200 (CEST)
Date: Tue, 10 Jun 2025 19:22:21 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Show reason why autodisabling serverino support
Message-ID: <20250610172221.ihsrjrikbiijyb4n@pali>
References: <20250608164453.6699-1-pali@kernel.org>
 <3d644c3f8acb3dbcef395bd96e7e957c@manguebit.org>
 <CAH2r5muuanOgjzQ8wgd+QoyrU_ZM4tATrfYYQj=b7MapGLMh5A@mail.gmail.com>
 <20250609073650.kj6lxrykguhb7nuo@pali>
 <ac80cb46-5787-4fc9-a405-fd38a505c613@talpey.com>
 <20250610165555.sekma4ybcl63flnw@pali>
 <b51772c542618b56cf0fed0cf95836f5@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b51772c542618b56cf0fed0cf95836f5@manguebit.org>
User-Agent: NeoMutt/20180716

On Tuesday 10 June 2025 14:10:00 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > For sure I can improve also existing text message. But Tom already sent
> > NACK so I'm not sure if I should continue with improvement or discard it.
> 
> Oh, feel free to continue as I'm not the CIFS maintainer, so my NACK
> doesn't matter much.
> 
> Go ahead with Steve's suggestion to make those dynamic tracepoints.
> These VFS messages will simply flood dmesg when reconnecting,
> automounting DFS links or surrogate reparse points -- note that they
> expire after 10 minutes, so next access will print the VFS message
> again.

Ok, I will try to improve it and I will start with the text messages.
Tom is right that that currently those text messages are missing
important details.
