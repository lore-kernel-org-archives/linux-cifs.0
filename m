Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D712680B;
	Thu, 12 Sep 2024 00:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726099251; cv=none; b=iUhRKAhOmD7ezBH9GfRr/v73RTIfk/5m5GEn3yOT51/E3PQkxc8qdkbPaHF5N9UmSyaXxiXbi+PuV6Z+Ks3EsBBc6fRNeu+RxxfbcNW6BruYPxdTGxN9Nm6kF7yju2NpoWx1VxhT3AQ+NQ0xfwFy0jVWlvdguyLhoFSQqqV0Cqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726099251; c=relaxed/simple;
	bh=+s0dxMF9HtXSk6N02EC2YZl7Km3Dpn07bt4LUntZBiw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQXcTa4U6aK5z1B9ZBM8jYec0EMtLlUkq0mF9qxROoV/ekBjJahsxbLcAf0Nnztcrqwa6ydNs2WDN2mZtYFxGCn992Sfen8E6AGAyKAEtVcbGWKxyYZjdxjmM01wvul/nkyVTZiepYIB/3PUjmEz/Z0lKCUCmBYB8NiHUOG+BOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFBwAk64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFBwAk64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4A1C4CEC0;
	Thu, 12 Sep 2024 00:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726099250;
	bh=+s0dxMF9HtXSk6N02EC2YZl7Km3Dpn07bt4LUntZBiw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NFBwAk64+tO/fpv0erDqeuuRgVfAb8sSGLNqVebTtEFfKbVifyWPpe5o5O5BZfdoh
	 zktDpagsK3ofqzYCtOT1tPw76LezeINoYm+yN9o2ibIK9vAfwC1eZkEGZCkCCQoFqZ
	 DKzMySw2e7G6sFZ9Wbjuy4Vvb72poDc9wR3+1KvyP3gYmpEz9v/VcYe1OBtn2Y5CeT
	 iRwjSxw7CJbLrPfIqQ+2BAOa0MCWS9m+AbDz7+7xj1z63WJtbDlNqpdCshoiD8FtiP
	 9v0s+RBRqMgJrtkDN8y8C1AbC1mfOm+2zguoXRAAmwwjjriT+dCVsI+uOonM02C4qH
	 oS5oa6UWKfagg==
Date: Wed, 11 Sep 2024 17:00:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli
 <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>, Stefan Metzmacher <metze@samba.org>, Paulo
 Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes
 Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, Sabrina
 Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, Andy
 Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next 4/5] net: integrate QUIC build configuration
 into Kconfig and Makefile
Message-ID: <20240911170048.4f6d5bd9@kernel.org>
In-Reply-To: <887eb7c776b63c613c6ac270442031be95de62f8.1725935420.git.lucien.xin@gmail.com>
References: <cover.1725935420.git.lucien.xin@gmail.com>
	<887eb7c776b63c613c6ac270442031be95de62f8.1725935420.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  9 Sep 2024 22:30:19 -0400 Xin Long wrote:
> This commit introduces build configurations for QUIC within the networking
> subsystem. The Kconfig and Makefile files in the net directory are updated
> to include options and rules necessary for building QUIC protocol support.

Don't split out trivial config changes like this, what's the point.
It just make build testing harder.

Speaking of which, it doesn't build on 32bit:

ERROR: modpost: "__udivmoddi4" [net/quic/quic.ko] undefined!
ERROR: modpost: "__umoddi3" [net/quic/quic.ko] undefined!
ERROR: modpost: "__udivdi3" [net/quic/quic.ko] undefined!

If you repost before 6.12-rc1 please post as RFC, due to LPC / netconf
we won't have enough time to review for 6.12 even if Linus cuts -rc8.
-- 
pw-bot: cr
