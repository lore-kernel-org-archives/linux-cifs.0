Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9E6248886
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764355917; cv=none; b=Ybqih115FxZhPrepRjOsp7HmnGi8YxLk6N/P4dDN1AsRgEvVefAKYiZyZEJpruLBKqREcyl7uA6e6Mg1g6Cyni44VQ5sVAHy/fk1Ht00VJ3sq6gouYZK76rBsdWHfGvsDz4G4f0YOFXgHyvjzcV3fWBAydgmnJIvDtnBA8L8sd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764355917; c=relaxed/simple;
	bh=mR6YrckDN5ohKcIpS46MyUYYjGQ0iujR6crQdAUZUaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOK9DivV+qLL0zM3E0mpqgAYq6AtTnt466atXlAw1JopEwnfwLuRrUOkrMGf0+irfO64WTv6P2Bplz/EIJMkhSA2pIOGvBSvulFfT8LOPC/x2BUM3XYpQjlmKihBZjVLSGhopPOFA8bEsp1pHiNhcU47n6UTpuX+SkQS/xhHPIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=GJZuYFkO; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GJZuYFkO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Vx5DHGXnqdyqUkxWDveNCIl8IbJ47O9ltzJT0QrI3D8=; b=GJZuYFkOXZHBrcYuFLVfILD8yc
	8wKmsrUW9zyJefL3trLURemL+GX8I7oFIQ1liznsXU2HFVSnAZ9mJUcPewOBl57BfPoukVUXhPHjQ
	KBg2GGWw22GCJ4plWkbPZ/Iea37vyG2YyC8UB5GCx1RF1ud+oPzkY3geKYivGC+3UuH7P4Sfno5NO
	kcEJwGe3ToQsv1cMrjYL9tElk/G3sYSYkJJMHBvo7sjy9XNIfxOSzYzZLUm0ddr3ipJrOaS8lemmf
	l2DF1+VqKoKB7k+ApAmLE+daewKxy34y1MqjwXvvLkC/iSH9kSNiBXkgebMEoFsjuGsnE1nTlpw9V
	TpvY2VqJN6y5AuHfuM0Ctk9W6jVMFXfK6HYONr1ec6BjrFTk8WeVuMAonRdnMX0h96ljCKuy3c74K
	AZYlqke92f1D04BWuNq7OX7q9FKNt++NEKIK4lNq1oW8KudmxjCHDOeot6Aj6TJK8j1y/9SW9VKLw
	jbYr2+l1hMIqb2R1iFXPQhwr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vP3ZR-00GB0G-0G;
	Fri, 28 Nov 2025 18:51:53 +0000
Message-ID: <e67a626a-828a-434d-8921-4bd8fcaeabcb@samba.org>
Date: Fri, 28 Nov 2025 19:51:52 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: change git.samba.org to https
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
References: <20251128134951.2331836-1-metze@samba.org>
 <CAH2r5msBaRVPNkaMy0iQKPq9COR+p5+UUNf-B-Fh6=v7zKNRnQ@mail.gmail.com>
 <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org>
 <CAH2r5msAQ7JZvOksSWJiW9SrZmX85yzcbHJ1Zb7r=P9yU+p5Ew@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5msAQ7JZvOksSWJiW9SrZmX85yzcbHJ1Zb7r=P9yU+p5Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.11.25 um 19:15 schrieb Steve French:
> ok - this change seems harmless.   I also want to look at way to add
> you to MAINTAINERS to make clear you are "expert" at RDMA/SMBDIRECT
> and either reviewer or co-maintainer for smb client/server/common more
> generally.  Wanted to look at a few other examples in MAINTAINERS and
> compare

I compared things like
NETWORKING [GENERAL]
and
NETWORKING [SOCKETS]

They are 2 sections, but some files overlab.

scripts/get_maintainer.pl include/net/sock.h
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING [SOCKETS])
Kuniyuki Iwashima <kuniyu@google.com> (maintainer:NETWORKING [SOCKETS])
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [SOCKETS])
Willem de Bruijn <willemb@google.com> (maintainer:NETWORKING [SOCKETS])
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
Simon Horman <horms@kernel.org> (reviewer:NETWORKING [GENERAL])
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

And I think we might want an additional section that covers
F:     fs/smb/common/smbdirect/
F:     fs/smb/client/smbdirect.*
F:     fs/smb/server/transport_rdma.*

That way the maintainers for the smbdirect section will appear
first followed by the more general results.

I first thought to have excludes for fs/smb/common/smbdirect/
in the cifs.ko and ksmbd.ko sections, but we can leave that out
and just let it overlab.

> On Fri, Nov 28, 2025 at 12:00 PM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Am 28.11.25 um 18:48 schrieb Steve French:
>>> On Fri, Nov 28, 2025 at 7:49 AM Stefan Metzmacher <metze@samba.org> wrote:
>>>>
>>>> This is the preferred way to access the server.
>>>
>>> Are you sure that is the preferred way?  75% of the entries in
>>> MAINTAINERS use "git git://" not "git http://" but ... I did notice
>>> that for all github and gitlab ones they use "git http://"
>>
>> It seems a lot of them were created long time ago.
>>
>>> But maybe for samba.org there is an advantage to https?!
>>
>> Yes, the admins of git.samba.org prefer that clients use https://
>> instead of git://
>>
>> I also checked what linux-net uses and it also uses https most of the time:
>>
>> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep https | wc -l
>> 178
>> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep -v https | cut -d ' ' -f2-
>> Merge branch 'main' of git://git.infradead.org/users/willy/xarray.git
>> Merge branch 'master' of git://www.linux-watchdog.org/linux-watchdog-next.git
>> Merge branch 'master' of git://git.code.sf.net/p/tomoyo/tomoyo.git
>> Merge branch 'next' of git://linuxtv.org/media-ci/media-pending.git
>> Merge branch 'docs-next' of git://git.lwn.net/linux.git
>> Merge branch 'master' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>>
>> metze
> 
> 
> 

