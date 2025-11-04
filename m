Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FED7260A;
	Tue,  4 Nov 2025 02:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762224108; cv=none; b=XmrWWyzy+y62nrpyQFryO7CZOP8UU+DEdXKoANMRcLZHAm3+299QgfLByFyMnWeOFio5tauaZwM/wDUe8ujfWUu/ITDe2SDjyYnG5ZV9T4YDtz+9QzqF1C59K7gOs8hKiYf3f7Eo81sKxJ8QpSa6BG5UiXII6Ujne/5gDmNrIKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762224108; c=relaxed/simple;
	bh=y8rNcAWuXaeFrr7yf8H0mIDjXy5rf2wJJSxCDDBFHeo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vvy9+AL+tLed4SYLCqs2Cu3+ixi2P0hw4cFwpuWoGs5nSiDjGaq8W93RJzK4CLokU4m2MH+lX9tm5hUoMJWWPEQsYIkScNphDU6D9mFFGvhjYiiDD6h5zht3r6NQSDCxADiARitdWRUyPjA+nopS5EHoRbQ87LiKXwESN/H5GRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pOeuyrC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pOeuyrC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF3DC4CEE7;
	Tue,  4 Nov 2025 02:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762224108;
	bh=y8rNcAWuXaeFrr7yf8H0mIDjXy5rf2wJJSxCDDBFHeo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pOeuyrC/PvGEOYzmnn2gZHwimvfqAo5x1wYoVM7GsCnp+UKfWdLHB6U1+yWL4LhLu
	 A2KJshzKcbSdDCC2FHO27OFvs6xlBFh4Z8tS+ryqVFj/KUovpG5eA0kNVvtkmCalGI
	 jivKQkw1KV6mnuNOvU9DEefQnC9YcZY4BGMnfxWP0z11snbztUV5A3K+7kpsxI88vg
	 BgglHf9j+N2xpgDTyDFC/7MmVEQ1lJxz5jyoTfUJWQ4my+aLe1ZoJhMEsr8N6P0a7T
	 EsJmrAAZ1QfLj+ZD+2S5Zgjln9Fl1ibq81xssxTsIBfiMUqg/v1Mq1Yd8I8Iq2c/Q4
	 6qRK0hkL15dqw==
Date: Mon, 3 Nov 2025 18:41:45 -0800
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
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington
 <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke
 <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, David Howells
 <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, John Ericson
 <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, illiliti
 <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, Marcelo
 Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg
 <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v4 00/15] net: introduce QUIC infrastructure
 and core subcomponents
Message-ID: <20251103184145.17b23780@kernel.org>
In-Reply-To: <cover.1761748557.git.lucien.xin@gmail.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Oct 2025 10:35:42 -0400 Xin Long wrote:
>  net/Kconfig               |    1 +
>  net/Makefile              |    1 +

Haven't gotten to reviewing yet myself, hopefully Paolo will find time
tomorrow. But you're definitely missing a MAINTAINERS entry...
