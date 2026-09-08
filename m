Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3837656329D;
	Tue,  8 Sep 2026 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884188; cv=none; b=tMaJ+XIomtPHauUDSneedQX6UNJDHJv7x36k2UfPHhvDC0aBNxMM0z28pJ6l9uvFeGwBQT+88WUsEtuOke4Kow4NjXVyssMFVq6jrQzW4kKCsHSeK4+Rp1Pz/5J+H6c4lFC+nV+JxDCyIc/QqREppHEWQ+eUH2QlPQyJFBbrolY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884188; c=relaxed/simple;
	bh=Un2gg66X2C1FjvpljLa+7yi1kP9r6vlyqZ/rKCKiujo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2VcJL7XHYcAHk7DiSFK0xb7Le9J02ntqrU2d4fnrXsnQjH3ETbdO2/1YMgrl30R7dAJBEwSgHqEjoylpt7lny5oZgyq1M0j+Iei2JTnf2UYePwTwJTTwCdl3MhOKFzoTRlq4Foj/g6KjTUb3t7b4CwriYijF3bWoZqHoB7Kph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=guK6vPqE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="guK6vPqE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=sMKuAn+LSmWxYC97uq00amy3h7wNVI3iis7OY64EHJM=; b=guK6vPqEEKQRj9ffc0geJ/Sk6t
	wrZjO3OgANZcm/opG7KT1n/H7J0OqdgmUmVxueAsjMX3omI5UO+Gzj2hYfbIT0OGvC/B467peCcKB
	7p3W/UEVur4PgS0k9lBbZ3qTIFALCW1HMvhYTT60oqvqdSvBAhiD6VK2WqHth83ijmfsovooyKear
	f4yBGJzgkKUtTUrRgyOEgbuZz4uttBsfenuV1atc1Jup6GKZey5zVP3vZY2rucez8SOQp2W+u8Nmh
	1T62A+YwnXKqwDaF6d8DjpbNGUXC6MqodC9BX3eUvpfW/iGFKGQuyhLrCCcWIHa+NVQzbPfw/5ruC
	WWRq9s+ri++GJE0MhRh8sbheHOToK4kXN3LZLKI91+SRY/s972PPiiEFUrNKUnQzkBYDdBscUlNrS
	uK0WPHfmHDadIktu4nZdegQWmA/RFZ+8iHF4OOKN2mUAj+NBjPN9c3cQ0AvMxnc/brYu8PVJFCiPo
	p9QRWeyxAu8qEtF+JFXDtBPb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1x3yUg-00000000QdZ-38xP;
	Tue, 08 Sep 2026 16:16:23 +0000
Message-ID: <c46d2974-04fa-4f49-a9ec-43ac8c1dd4db@samba.org>
Date: Tue, 8 Sep 2026 18:16:21 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] smbdirect: don't hang on netdev reconfiguration
To: Ammar Ratnani <ammrat13@gmail.com>, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 Ammar Ratnani <aratnani@nvidia.com>, Kechen Lu <kechenl@nvidia.com>,
 Mithun Maragiri <mmaragiri@nvidia.com>
References: <20260908154454.10966-1-ammrat13@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260908154454.10966-1-ammrat13@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ammar,

thanks for the fixes!
I let the rdma maintainers comment on the patches in detail,
but it's good to fix these problems where they happen.

> When I mount a CIFS share using SMB Direct over RoCEv2, I observe a kernel
> thread hang if I "configure" its slave network device by taking its link
> down and bringing it back up. Attempting to just `ls` the mount point in
> this state gives EHOSTDOWN.
> 
> I believe the following is the root-cause of the hang: When the link is
> taken down, the corresponding GID Table Entry is marked as pending deletion
> and has its slave ndev set to NULL. All sends on RDMA connections still
> using that GID Table Entry fail at MAD creation. SMB Direct eventually
> detects this and tries to disconnect / reconnect to recover. Unfortunately,
> disconnecting requires successfully sending either a DREQ or a DREP. Since
> neither of them even post, the connection remains in the RDMA_CM_CONNECT
> state, and no callback moves it out. The SMB Direct layer never gets the
> RDMA_CM_EVENT_DISCONNECTED it's waiting for, and hangs.
> 
> Fix this in the CMA. If we call `rdma_disconnect` on a connected connection
> and we fail to send both a DREP and a DREQ; disconnect, and thereby send
> the `RDMA_CM_EVENT_DISCONNECTED` event to SMB Direct.
> 
> I tested this change in QEMU using RXE. I ran Ubuntu 26.04.1 with a
> mainline kernel. On commit 9f0346dcbea3 ("Merge tag 'driver-core-7.3-rc2'
> of git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core"),
> I reproduce the hang. With this patch applied, SMB Direct immediately
> disconnects and reconnects when the slave device is brought down then up.
> Listing and reading files from the mount point also work afterwards.
> 
> Artifacts for reproducing the hang and testing my fix are available at
> 
>      https://github.com/ammrat13/linux-cifs
Given you have some automation to reproduce it I'm
wondering if you could also test the iwarp case, see
https://lore.kernel.org/linux-rdma/20260805000159.321645-2-yunseong.kim@est.tech/

That was reported as fix for ksmbd, but I guess it
will also happen for the case your're seeing with rxe.
And your fixes are likely also good for ksmbd.

Thanks!
metze
