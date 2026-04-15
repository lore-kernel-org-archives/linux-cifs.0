Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B53B389E
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261298; cv=none; b=N1NRPoLj2jRYlhSwMsZtBvzjMIczjMdYkajGEORCyRP2sOQvNRnFGXylyjN+VfBcO8VS3Pz/AcTzJCEgv6YjGpXmEbxgOq/SxVRhj/U7qTzyCUlL5xTtGo1Vy1Z8eKIKDodHuykiu7nIqVK5YKD3HlMmO7hCah+sWbvF4NYEPeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261298; c=relaxed/simple;
	bh=RIKahspqXMQwf0ggm73qvj5D3+prlXvV6tlUXnSiv0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YXfTIjCtfAKmZw8KOqAHZ9FCV4mxvEwpzyAuUoERBhirv07uZG2iCrkexjGj4UESpKs5mYqpOlI3K+95b+q5+GXvLYWEIxbSrgFUz7E6k9B1lSxPZltQE/jlLHBq5ZChSADvDHms1LoxSwkqHq8BovENQj9P8Q8XEGDiVupw6f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=b+wD3C7K; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="b+wD3C7K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=w7p/hmCdxvnIxE/R2pd74gXUlSlUkc7LG92dY4f0OxE=; b=b+wD3C7K3hcfXayEnIkZDoguZa
	uXoIxBYqC+6B/IQdwvVryJYdvKB18Jn/RB1J2tTKADOpL+99zO217jNYdPFeyN7e9oGtLC/iBNAW3
	bhwBtgrjO6/o4ZXCrSPeHoz2A8H/wUqdTILM7X27QuwAqwHodWz2hHaaueT1MePXtlz2j4XyRcZ4M
	GRKvyR7IAV5S4XmSu/075fV9oV9efnSAoPXbuGfJn6lqpp/jGR+NAVGTLl/7xnDfSEmSVAcSGyLLy
	u0cUsOM8TkVa2l9Md+NvbMhaNp6aE8gNFS0kwbZwm3VUb5bbrQdSzJN1AQ4joY5GKlLhqMscUAMe8
	UmWkcHA9NMFkn3Kt1C3hKwvBpiiCF1NCRPu0EpcfUnjJGpbxVdFoHH76dlmXvipXhKsoFJ4kRU9lD
	T2Za0BKAXvWbAVeJ9Lu2H7BpLe6dgYGLRPGSkG4twp0EIv83Mx5gLWDPPnnwAXOXCimTKCMaURjBs
	28WEhK2DOQApyn6H9VYS39Rl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wD0hd-00000001VJ6-0vNx;
	Wed, 15 Apr 2026 13:54:49 +0000
Message-ID: <7f3a633a-2992-45fe-8a97-43d217953d84@samba.org>
Date: Wed, 15 Apr 2026 15:54:48 +0200
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
 <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.11.25 um 19:00 schrieb Stefan Metzmacher via samba-technical:
> Am 28.11.25 um 18:48 schrieb Steve French:
>> On Fri, Nov 28, 2025 at 7:49 AM Stefan Metzmacher <metze@samba.org> wrote:
>>>
>>> This is the preferred way to access the server.
>>
>> Are you sure that is the preferred way?  75% of the entries in
>> MAINTAINERS use "git git://" not "git http://" but ... I did notice
>> that for all github and gitlab ones they use "git http://"
> 
> It seems a lot of them were created long time ago.
> 
>> But maybe for samba.org there is an advantage to https?!
> 
> Yes, the admins of git.samba.org prefer that clients use https://
> instead of git://
> 
> I also checked what linux-net uses and it also uses https most of the time:
> 
> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep https | wc -l
> 178
> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep -v https | cut -d ' ' -f2-
> Merge branch 'main' of git://git.infradead.org/users/willy/xarray.git
> Merge branch 'master' of git://www.linux-watchdog.org/linux-watchdog-next.git
> Merge branch 'master' of git://git.code.sf.net/p/tomoyo/tomoyo.git
> Merge branch 'next' of git://linuxtv.org/media-ci/media-pending.git
> Merge branch 'docs-next' of git://git.lwn.net/linux.git
> Merge branch 'master' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git

can you submit this during the current merge window?

Here's the commit again:
https://lore.kernel.org/linux-cifs/20251128134951.2331836-1-metze@samba.org/

Thanks!
metze

