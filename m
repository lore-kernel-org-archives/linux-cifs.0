Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325321;
	b=THuNr88kiQkCO4fjAawE4XlbDZtI842gAMYqMI5kF08JTY7SBcSt2jcTFRyyYl6o0MtG
	 dvAXEsfJUmWtstzOha9v2jbM4nO7Ma9OsnGewGu5gK+LscrErJiA5f9TyIsTn1dcvJZ0d
	 IHCEBTMhub9eWRwa0pmfuhdFhLO00spbggB94Se14aRxMeoXpmpzf20bRvhaKArzFHL+D
	 rRtgeMdo04UBLcW2aZsqMn13YwQWtIScvdBQ4qXc/pSqIdp0XWLz+JQw2HuZj2U5TmTJy
	 cNRKYDzZVs9CeagOBfcoo53MMzuyBvdd6YvgcVVp+CEGyyehq6qldW3d1rg9fChvx3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325321;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=9jyzrNW+uLpCLSN6mVN1YOOuKEzhBfBDxAyFVPj3suI=;
	b=ghqiUaWgHKnX1hwQl6yt2NreCfdGU2q0raZIubGTCqwjeUk7RjiSfeQapgbIir63GP7k
	 NASShhPmxdBgfzE52Nj4PiCruZlxEavCpKG5oLkSsWmHUN9ajF/tMMwXwUwRIB071cAkp
	 /UqK0TczsRc+sT1Dwi0RVzxqaLIplY+omsnambNeDnPvaEi9gjelpj8gv9LPwAPBnx50h
	 EX3LrNYkwv2CFAvYPlOeFVlW67Gg/NTYKJPR5I3crm0JeZSqiF0ec/cP+0Sy3R5WZ3lQO
	 esJLgaK4Zf5XdQ6bPSXaDz/raaeCHG0VPpuWA4s6r5sMHAXJycmV6Traob5JhFR2UWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BdNYeTuG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDAA606AB40;
	Tue, 10 Nov 2026 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BdNYeTuG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649251F008A1;
	Tue, 10 Nov 2026 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325320;
	bh=9jyzrNW+uLpCLSN6mVN1YOOuKEzhBfBDxAyFVPj3suI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BdNYeTuGVKQ0iAGpsaiUPkDDdkEeUD0PEzZWf8kx0jwb9/lS5CpRVGv9YM8qIobWd
	 6UBaLEpyZxgt4EWXI4OF3ltUHJjSWCDjUkG1nn9X+sH6Y83z4iRn8/UVkrXc/1/kJk
	 nkcoLy+6/OAuD2BIZkyLQXvH41plIpL5b/IcMHnQwR2hcGinSGBcNqaQVXrZOFU/6o
	 zTMJHCkEKhvchBEIoYthGW3rd7nqEkFGUUnFvZYyoHej6yHmj5jhIBY+zhfTwSL/n6
	 p7VJ+MOsYa9dODc4LP1g3OIMfS4ZMbf2zmi1+7NiYJHII1iOSQT05+97Ld8XyJaa1r
	 9lpUJbgzWNOXw==
Date: Tue, 10 Nov 2026 07:41:53 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Stefan Metzmacher
 <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli
 <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz
 <dreibh@simula.no>, linux-cifs@vger.kernel.org, Paulo Alcantara
 <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey
 <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, Chuck Lever
 <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring
 <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, Matthieu Baerts
 <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, Cong Wang
 <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Jason
 Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, Sabrina
 Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, Andy
 Gospodarek <andrew.gospodarek@broadcom.com>, mef@scarletmail.rutgers.edu,
 paul@jakma.org, Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH net-next v18 00/15] net: introduce QUIC infrastructure
 and core subcomponents
Message-ID: <20261110074153.4b895bb6@kernel.org>
In-Reply-To: <cover.1794241654.git.lucien.xin@gmail.com>
References: <cover.1794241654.git.lucien.xin@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  9 Nov 2026 11:27:21 -0500 Xin Long wrote:
> The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transport
> built on top of UDP. It enables low-latency connection establishment,
> stream-based communication with flow control, and supports connection
> migration across network paths, while ensuring confidentiality, integrity,
> and availability.

coccicheck says:

net/quic/connid.c:250:19-25: ERROR: invalid reference to the index variable of the iterator on line 241
net/quic/connid.c:252:16-22: ERROR: invalid reference to the index variable of the iterator on line 241
-- 
pw-bot: cr
