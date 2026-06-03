Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB074358367;
	Wed,  3 Jun 2026 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780508367; cv=none; b=XOlve//2XT+LJMSX8ICTpSmVzh0W0QNa6y9qkoMhKqqRPEeNGOm2p9dqYXbqyiK9nx+ZxBVj8Hk/Had2TpdyjvzovQqeVFFQvtHcZgjUYdyqlBHyr8d2yoAILCyL5jz/FcCsA4LKCNgHJd8ek5trcz7V++sAnrHrnEkeXkuwPlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780508367; c=relaxed/simple;
	bh=AlotTfEWBpnwR/nJztsU/+NMEc2X1AkYjzc64RpIc7E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1ZEFHXgsIx+IyY0vMLRYFFXmrOxX1VYuMWVjcAiBOVMrbsp3mPtfbJMsIxfBrASWZqyTAi8PMP5z3rVEFFIYKDhEnWdtQIWGj2SNDDBd02QJh0f88h4scVrgyZed9XlAeSunt3BXWjyz1AMGEeQEoADyfGsJkyxNyVgwpkQqjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lpYdJ9t7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpYdJ9t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7FA1F00893;
	Wed,  3 Jun 2026 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780508366;
	bh=lfVv+INkqeHy9m8x8ugZxyD8ug0jrqBPnkR5DLA25HY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lpYdJ9t7d590bXJYPnnsTJPhVKDDbn5RvlUvLRXYnMrSpMUGpvd+GwW4Pe3a6RLpx
	 3nr0ybw7Qrk+BKMtQ+VkEPayeAtb9oNgrqFbTUF/cfdJiyJrIes+hUlvb/K5i8BfgB
	 hVchvoCO71SZzurWizGQQBqTGz7V26cxiiAoFQJHfcNManzOcMo8KqR7vCXtggEVG7
	 LB903FQIO0dkyIuzVCJLc2V3q/LUOCd2jGWHQP2aQNucqjyECLpYfb3Om2rGdkNXbc
	 El0To/pVTkHNAjtzOInK29sdj7vhByr89KAwc9DsIAzpTQuWDBFJjhmHvwHnBtYsic
	 0vlkmAeHBcOzw==
Date: Wed, 3 Jun 2026 10:39:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Stefan Metzmacher
 <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli
 <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz
 <dreibh@simula.no>, linux-cifs@vger.kernel.org, Steve French
 <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey
 <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring
 <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, Matthieu Baerts
 <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, Cong Wang
 <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Jason
 Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, Sabrina
 Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, Andy
 Gospodarek <andrew.gospodarek@broadcom.com>, mef@scarletmail.rutgers.edu,
 paul@jakma.org
Subject: Re: [PATCH net-next v12 00/15] net: introduce QUIC infrastructure
 and core subcomponents
Message-ID: <20260603103924.643f1ea4@kernel.org>
In-Reply-To: <CADvbK_e7T=Yfb800TbO+BcpDEp=Sf6rbtiy2daLaskFAjeg=Ww@mail.gmail.com>
References: <cover.1780232930.git.lucien.xin@gmail.com>
	<CADvbK_fBbLCwY61HXsNeGCA8MhiBKcbvE0BvSZppohJgtXO+2g@mail.gmail.com>
	<20260602111823.0b1129d6@kernel.org>
	<CADvbK_e7T=Yfb800TbO+BcpDEp=Sf6rbtiy2daLaskFAjeg=Ww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 Jun 2026 10:14:24 -0400 Xin Long wrote:
> Will address it in v13.
> 
> BTW, is there a public link to the Coccinelle check results?
> I don't see them showing up on Patchwork.

They are part of the CI that runs ksft because they are very slow.
So they should show up if you click on the "contest" check in patchwork.
(caveat - I haven't actually check if that still works :))
