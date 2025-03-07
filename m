Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB8820E00F;
	Fri,  7 Mar 2025 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741358550; cv=none; b=eT1AmuGfM6hwMfpD+OHK65FApS64pRqiOWUW2vQ/TauVijCFJjMHzC2viViZN4n4Wr/WucJzALmLwmcaF7GxmGgIC9Lz5oMhMlBAsrCp2LnFhWosDc/zbcqlyiQ3KMTR/+EmcTtqG+gq/xKHyIGOymtw5AbU/lzDm1X6mlp0uJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741358550; c=relaxed/simple;
	bh=2al+86C1+YK+NBuYNt0/3rhz4Sw/x8Fe1REIfwEqqno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u9uSwlZIDVv3jFY8bAroH/cs7KmquAdNYO38bb0uT5Z8P3IBH2GZED+iZDe3wH3qrn5KWUScDLfmCZjjiHjAgpEiWj9EdjyVt72rKFr416kTOjS+3k2Wf7iFrVG0tKYbTu26RLT6pIWZ2w/jvlMC4l2FT381yXtjbeJQP0+oIbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=T39hKfLT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="T39hKfLT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=krNBxnNKUCWp+5mj/3kmTd/U8UpzJVpElMWOIj8TMNQ=; b=T39hKfLTKMi2pABySpMCnxwKeL
	MDnEqGlYjjAtatvrJKKWL/q2thV4RX2SB+BQjmwlDGNCIvC0RheK5GEV0pfv74k46QFvmuTt0QBEJ
	MnWfPUjjbXKpVP/5fduDamCYjRhh+NlFYKE/JTMJPWGd667QbbGMcA3HmSnupjig6v04OvvKrrBFd
	TMI1xAdPoK2Ez3B2ivATur4TayzyrpIiXaxWEkEhHC6jaTfkddN5ZlgScjMklEa6qls3O3fBYFFR0
	ab6QgI4I1a+Rs/1s/5NiiT692Z+wE7tGbXnrBFtOAGFA1Jdj4xUPohGHR9Z1Se10wgxO9HJJv4Fto
	mpE8Sv8mXXlddo1jjY6Jdpj49UJnTuHlNnrdTL7CvQS+/GvKFnWvRNS+iAuIhxarAcurgihp9zQn/
	+VyYfmD8abKg+/JY00jWcvSGqqnYoLxG1CL3/sG51zPUS88l/eGlZh2B8P5JGEyxglZYB1Sge8W5a
	Z90V9xcdP7BwpiKuirr45tj4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tqYty-003t3r-02;
	Fri, 07 Mar 2025 14:42:14 +0000
Message-ID: <53728c53-5c1a-4f5d-9862-8369e9b9d8d0@samba.org>
Date: Fri, 7 Mar 2025 15:42:12 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 4/5] net: integrate QUIC build configuration into
 Kconfig and Makefile
To: Xin Long <lucien.xin@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>,
 Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>,
 Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1725935420.git.lucien.xin@gmail.com>
 <887eb7c776b63c613c6ac270442031be95de62f8.1725935420.git.lucien.xin@gmail.com>
 <20240911170048.4f6d5bd9@kernel.org>
 <CADvbK_eOW2sFcedQMzqkQ7yhm--zasgVD-uNhtaWJJLS21s_aQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADvbK_eOW2sFcedQMzqkQ7yhm--zasgVD-uNhtaWJJLS21s_aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.09.24 um 16:57 schrieb Xin Long:
> On Wed, Sep 11, 2024 at 8:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Mon,  9 Sep 2024 22:30:19 -0400 Xin Long wrote:
>>> This commit introduces build configurations for QUIC within the networking
>>> subsystem. The Kconfig and Makefile files in the net directory are updated
>>> to include options and rules necessary for building QUIC protocol support.
>>
>> Don't split out trivial config changes like this, what's the point.
>> It just make build testing harder.
> I will move this to the Patch 3/5.
> 
>>
>> Speaking of which, it doesn't build on 32bit:
>>
>> ERROR: modpost: "__udivmoddi4" [net/quic/quic.ko] undefined!
>> ERROR: modpost: "__umoddi3" [net/quic/quic.ko] undefined!
>> ERROR: modpost: "__udivdi3" [net/quic/quic.ko] undefined!
> The tests were done on x86_64, aarch64, s390x and ppc64le.
> Sorry for missing 32bit machines.
> 
>>
>> If you repost before 6.12-rc1 please post as RFC, due to LPC / netconf
>> we won't have enough time to review for 6.12 even if Linus cuts -rc8.
> Copy that.

I'm seeing some activity in https://github.com/lxin/quic/commits/main/

What's the progress on upstreaming this?

Any chance to get this into 6.15?

Thanks!
metze
