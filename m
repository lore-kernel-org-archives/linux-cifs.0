Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D5221770A
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764352843; cv=none; b=KgIXjzfTiDxgLidiyHc+QoyHZ1Sv00RLLU0rLsctojIskXpt9sz1wX/+GfU1YhNmkWKbpVKi7u4mgMowHUoDyOx8xCK4A5nTEw5dL0ZTA3KouYcz9djj2iSovg8yB+iZosmgfem0FTY6np3BcB39Ht0ZaUiAJxQL1CgA5xm9QYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764352843; c=relaxed/simple;
	bh=XxLfXIOB86SziRwAVB4nYM5NXqR94LL0XDanv5/PTwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jgQATe0bVoPshXRyiLro3+4dUL3xWZhNadCTdJ09ZwnNNA2scgXfspQIJf2aXpJCyq7gVLxHwFaFLDZNxhFVZ83NT4EHvCP7X+M0GNuJoQk+A9OTxmswKCcIHrvZITNE+7vYfHYuTkhGYTSFNe7iQcpTtP8XzFs4xP62kXZTPlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DuNOecWu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DuNOecWu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Q0UagAmJCOM6kXxCn7e4/UCYXU+NgrmQc/VIu6AMX6k=; b=DuNOecWuOyqbZwaNqjAfo6g6YZ
	V1Rokc9sdrzLBBXdWvoSEIVNvBecZ19jgv5tbz6X57VC9Bjm45vY+NCuM/iCIYhAPZWlpapUBnhCM
	1FzmLb8i0S7h3Azh//cHXTRO/mO9yJcLqQAXlbOoeP3bzlJj0VI+/QO/3gto0UEf6fdrSRarHC3rb
	FIDCHxNqIKCL74IC719wPCrBwFCm7m1f59AW6BrA3GuphtoLd5Kq3jn1qiO+lBxMPvN/+k5NVYXO0
	w6OTkRi4/b1PaKE0evZK7kZZ8knu+TaL4CEofi/Y2CiHEjuR9s0Nm4XGSFSvhSZ7qu8tzycejX5wH
	4fvcLaqdBfQKrpYu+VV/TZOSzq5qNkIvX9GammkZqE9IxbFwVaOBYWbZ/VZ+1lgHWFHWUr6WNRK1T
	RJnyWmjnRhOB6ZDnr1Xcye/j9QAj5Zy/qRmqnKmeGX15rejfleuCam33TfEg+jWVJ3wmeuensW1qi
	cUSrXYd24KuFSBTjUZGO8k0N;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vP2ll-00GAfZ-0t;
	Fri, 28 Nov 2025 18:00:33 +0000
Message-ID: <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org>
Date: Fri, 28 Nov 2025 19:00:32 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: change git.samba.org to https
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Namjae Jeon <linkinjeon@kernel.org>
References: <20251128134951.2331836-1-metze@samba.org>
 <CAH2r5msBaRVPNkaMy0iQKPq9COR+p5+UUNf-B-Fh6=v7zKNRnQ@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5msBaRVPNkaMy0iQKPq9COR+p5+UUNf-B-Fh6=v7zKNRnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.11.25 um 18:48 schrieb Steve French:
> On Fri, Nov 28, 2025 at 7:49 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> This is the preferred way to access the server.
> 
> Are you sure that is the preferred way?  75% of the entries in
> MAINTAINERS use "git git://" not "git http://" but ... I did notice
> that for all github and gitlab ones they use "git http://"

It seems a lot of them were created long time ago.

> But maybe for samba.org there is an advantage to https?!

Yes, the admins of git.samba.org prefer that clients use https://
instead of git://

I also checked what linux-net uses and it also uses https most of the time:

$ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep https | wc -l
178
$ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep -v https | cut -d ' ' -f2-
Merge branch 'main' of git://git.infradead.org/users/willy/xarray.git
Merge branch 'master' of git://www.linux-watchdog.org/linux-watchdog-next.git
Merge branch 'master' of git://git.code.sf.net/p/tomoyo/tomoyo.git
Merge branch 'next' of git://linuxtv.org/media-ci/media-pending.git
Merge branch 'docs-next' of git://git.lwn.net/linux.git
Merge branch 'master' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git

metze
