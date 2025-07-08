Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A6F2AF07;
	Tue,  8 Jul 2025 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985270; cv=none; b=frInH9mz17eyDgm93FsanGLGQyM1ZsIkp1HAJEaOzwcjtaZAes4LbwYFr5gf/e7NjOMCMw2Q+xmZPeEXVq6lEkE8LFJ1DP4FhB50vvt3rZxmQau5gQzYGRZoGbTe3irtNR6Xug5KnOgwYcn5YkyNfYhs1n4oZZTAeDGVFNnKUc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985270; c=relaxed/simple;
	bh=5tduTloL7o58Qv0JYfn4WgvECx8dhVTHJ7cQroK1ivM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnKPdKD4Uo3E9pEb+tsFqR23s/akbDATIL3deWh7cEzGOxEP+oMTsGiIHlwgKWwXAUnCJhx1p9xKVGCVsmvN9EukswozQbKioRhHda9+/XLTYjsAtqYiKv1grVsGIiJ6HV8wDdFbrK3LkhdFY5ZVJn5HrkUOdCvTPPw4AS3odsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dw3TnR2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dw3TnR2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0213AC4CEED;
	Tue,  8 Jul 2025 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751985269;
	bh=5tduTloL7o58Qv0JYfn4WgvECx8dhVTHJ7cQroK1ivM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dw3TnR2jP3B6YiC5TeCFZdBjn23BoGVjN3kr1F4Th88b0dzAkmpsZ/2LGzaltUSxQ
	 PH/r9NVuiAO4cVEuUtFCMBDn4TskePd802dJ9xaDyBb8QtwuiF8YRUWUidGSWsx24y
	 Jprt3uoD+s8hJFCmD6y98PRpBhUNuMVp8vnq1N/idi/NrEdlytnOteNUZqzhDsucWj
	 MkuO1p6Y0/A19x0K3tOuihyJC5esIcvbLGv8Nj6XVEZ8DzY+e4JIt8Bkx0OqNvr2pF
	 ycf8i5sColU+22mFEHv/1FtyV1RHkuiYMUzWCX3hhd7hvw0WE6Gz6AIw6FqW577CwQ
	 kOf9RJa252zAA==
Date: Tue, 8 Jul 2025 07:34:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>, Moritz Buhl
 <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, Pengtao He
 <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, Steve French
 <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara
 <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington
 <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke
 <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Jason
 Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, Sabrina
 Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, Andy
 Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next 05/15] quic: provide quic.h header files for
 kernel and userspace
Message-ID: <20250708073427.6ba38b45@kernel.org>
In-Reply-To: <74b62316e4a265bf2e5c0b3cf7061b4a6fde68b1.1751743914.git.lucien.xin@gmail.com>
References: <cover.1751743914.git.lucien.xin@gmail.com>
	<74b62316e4a265bf2e5c0b3cf7061b4a6fde68b1.1751743914.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat,  5 Jul 2025 15:31:44 -0400 Xin Long wrote:
> This commit adds quic.h to include/uapi/linux, providing the necessary
> definitions for the QUIC socket API. Exporting this header allows both
> user space applications and kernel subsystems to access QUIC-related
> control messages, socket options, and event/notification interfaces.
> 
> Since kernel_get/setsockopt() is no longer available to kernel consumers,
> a corresponding internal header, include/linux/quic.h, is added. This
> provides kernel subsystems with the necessary declarations to handle
> QUIC socket options directly.
> 
> Detailed descriptions of these structures are available in [1], and will
> be also provided when adding corresponding socket interfaces in the
> later patches.

Warning: net/quic/socket.c:142 No description found for return value of 'quic_kernel_setsockopt'
Warning: net/quic/socket.c:175 No description found for return value of 'quic_kernel_getsockopt'
-- 
pw-bot: cr
