Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7322ECEA3
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764018431; cv=none; b=lkn4wAYyxV3Mm37bW/I30ANeDYLxnNkwxQ5cP6c7XYIdySj/yM1odDHFXOexG7NN/Cwp369khISOWojIA9/fr2nsnH+TErd6B/5Xlr5K8qiMxeXesXpE6Di4J6snXPGvsyAu74Kk8h/SqLwrRKF6/dN2e6Gm6j6mz52nCJLXJAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764018431; c=relaxed/simple;
	bh=+l/otmz7P2/Abac2Yc29sLsXis1aldOqprLTLGddmuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W45x3PpKk8LISEPhMEaB+t/Xu09TSFmTmyfbyvS/oH4HRbCeNIAPgTi2pz0t/32x5TBQai56+uHUnUvND1jtOhTr4f8lOOf3R1tLJt4TZizWfi0Eg67caGh7mzZRGkSBneh5ZTFEsn5NFj74FRe3JOkrlI+5s0lBHcyxC2Q8wek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cg318w7C; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cg318w7C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=p4Uhj2hqlAoIG3tYbLXlsV42mkOA4ZEbg7RqaiqbhJU=; b=cg318w7C3Ts8Jmmi6y+2AkCHpJ
	R6JxWsNAuXEckDJ2ltHVyYCyu59YdawOJCAfhJ5YbfumbbCU4xFQ6ByjTmCjPUAt3Aabvz1h37ARX
	goYmNoKRodY8bw4hUNmrJFcU7LSa9z0D6grfkO58fBp9UElRBgfu31NIfMHMAPevsoJk68gN3FLEB
	zRtKySKoq7Jno87VcQhOzuM2F7Cr0x4lMkx489XRdORnmMQUFTdMushRLs7SUD596oMZ4lFpUQJTY
	HnY+3bVht8ZA9JfUdt6jeBQH0qzKRNwbwObLljVtOQJ33+Id9q0NuJ8HMdpzalaratLK6eJlFFDzn
	NbvITx9ytfdW2o617FjG88d/0yWnlQf+YfRrmoL5KcHjQWjIq/xtLtYipd8wqxadb7r/VoKj61gjs
	pWcVV/sCvuftEMnuIn1PcZmO9Za2FfMLH+eFl9GCYdatDMuxEu8RxmFocrfgYZRu2cAdhMW+yKroS
	cc1RczhrNys2tUM72VJq2dfr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNdm7-00FSzE-1p;
	Mon, 24 Nov 2025 21:07:07 +0000
Message-ID: <63d42fdd-d3d0-4d4e-98a9-bf1926cbd9d0@samba.org>
Date: Mon, 24 Nov 2025 22:07:07 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>
References: <cover.1764016346.git.metze@samba.org>
 <a5d65f2d2e7cb45bd47317b726f86568@manguebit.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <a5d65f2d2e7cb45bd47317b726f86568@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 24.11.25 um 21:56 schrieb Paulo Alcantara:
> Stefan Metzmacher <metze@samba.org> writes:
> 
>> The patches should relax the checks if an error happened before,
>> they are intended for 6.18 final, as far as I can see the
>> problem was introduced during the 6.18 cycle only.
> 
> Since we're late in the v6.18 cycle, I would suggest leave all this
> churn (e.g. adding new helpers) for v6.19 and then provide a simple fix
> for the problem instead.  This way it will get a higher chance to be
> merged in next -rc.

I'd actually like to leave it as I posted, if that's
really too complex, I'd leave it alone and let 6.18.1
pick it up via the Fixes tags. If someone else likes
to propose and test a different patchset for 6.18 that's
also fine for me.

metze
