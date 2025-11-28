Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D9E211499;
	Fri, 28 Nov 2025 02:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764297011; cv=none; b=ovYP5kgG32d58hwQeOnmA8V7hJR5fPQ8ppKR1aP5MqCdK/Kp/E+KvE2BJTcTezCAuMGSj3reovroJmk4244pSApVovBbkZ5kWpAcTQg9vO1/mOVx+489Cjb9EvzYeSw5v8JkpOU6NUAw8mJOAaU5g+zRM03+QAccojS8XB8aVxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764297011; c=relaxed/simple;
	bh=YDXNnmOa4Z7WmUwl8ISusVadhfoEwmvPNMjaE0J6jpM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AwR9QzMkEdCzw2n1L0txXJ82HiVcnrMYBsLKZ5XldeuKutdVU9WnAFQ2IP0Sa15SC7/zwtjW8Q4uzBMiaPIeJBSX6DYOeArpa30IIL/+iHpv+Mr21Tb/06d54Reg4eezNx3llSuH6Aa0kNzmnImIexxsfGzU5Q4U7j88OkX5MiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCJeOXW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCJeOXW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55585C116B1;
	Fri, 28 Nov 2025 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764297010;
	bh=YDXNnmOa4Z7WmUwl8ISusVadhfoEwmvPNMjaE0J6jpM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SCJeOXW/6eetBUMzyh9LFNg0qp5bqT+vdgmGJQ9pEs0FD4UQkLvct6uqTJKmAZ+qG
	 lXIRy4dJy/EFYQjTrgr39mPG7RwFHUeldfEJYzAahzbAs+duhWAB+R3ic28sx778M0
	 pXeZcdQsbu15Zca2qUOoHPB6l5ouTL+8o+fhd9C3+1yIhjYqkZoXT/r6l91EjM8KtS
	 gfVkKY775ZrrCz2fkSXHAdCCuHYixiepblWaM6mxfMQLNkQFJkjJJytfrFqOMijudI
	 8GA6+BCX8sP0CUgum4Y3j0sOB8JZz0YRtrROwpTfQSDhb2HEyE8/5HT4xQZDZHf2OM
	 sTcsQTWzzlkUA==
Date: Thu, 27 Nov 2025 18:30:08 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Stefan Metzmacher
 <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli
 <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz
 <dreibh@simula.no>, linux-cifs@vger.kernel.org, Steve French
 <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara
 <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes
 Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, David
 Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, John
 Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, "D .
 Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg
 <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v5 00/16] net: introduce QUIC infrastructure
 and core subcomponents
Message-ID: <20251127183008.5ee6757f@kernel.org>
In-Reply-To: <cover.1763994509.git.lucien.xin@gmail.com>
References: <cover.1763994509.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Nov 2025 09:28:13 -0500 Xin Long wrote:
> The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transport
> built on top of UDP. It enables low-latency connection establishment,
> stream-based communication with flow control, and supports connection
> migration across network paths, while ensuring confidentiality, integrity,
> and availability.

Please look thru the Claude review and address the legit complaints:

https://netdev-ai.bots.linux.dev/ai-review.html?id=8ac157b3-6222-4e89-ac52-28e4ca52d6c4

If the tool is confused but not in an dumb way - it may be worth adding
a relevant comment or info in the commit message. Otherwise a note under
--- would be appreciated to avoid maintainers having to re-check the
comments you already considered and disproved.

Thanks for adding the MAINTAINERS entry, two notes on that:
 - the entries must be sorted, so you need to move it down under Q
   instead of putting it next to SCTP
 - you seem to have copy/pasted the uAPI path for SCTP to the entry
   instead of QUIC ;)
-- 
pw-bot: cr
