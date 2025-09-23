Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA8622ACEB;
	Tue, 23 Sep 2025 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758618409; cv=none; b=Sw3W81bdg+H/vGyk8bf0aBav5flpQ7ThHCwP9bOyGFAhr7fGUhFuRYaMHKJFoLKFxUrr0/8lcKz5R7JQcLDYYODMnCqHRev4cSDKWSMATArFoEx/4c/NX/4woA23SBJdcfAqbBwaZYgAXeOu66HuvboZBisPCq/sbHFhQJMqBxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758618409; c=relaxed/simple;
	bh=ZDzclZSQdzF1oEaN1C3ZiYcW4WfselUNILKqPuhL7q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRIv9H0nGBPayFO7DfoQ3224XO713OCPJXQJPHHZsDaUZ/bRPOqz4rYTDAfinynz10js6pBeTu36/UZyBuMvuK66OFNYdbyyZms9gLNYlwI1j1hxK1I2IN/7qkLdx7I4qyO3WSZfrPj1iYnzYVS+u6guKNRVvNfZRABTjsdUqrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaNNYWLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaNNYWLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D502C4CEF5;
	Tue, 23 Sep 2025 09:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758618409;
	bh=ZDzclZSQdzF1oEaN1C3ZiYcW4WfselUNILKqPuhL7q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PaNNYWLHy4fDFnFg0POymQxjyKJRllvvW2PUUnr0Jp8qv3XJcg61GIMhs0/KUaYCi
	 lX/Wm0QAu11qh8ACDIi6gny9gGL3pMdWMmwslyzGrPd9Yv+CqqAPBioASdIaJFAHz5
	 nWochXiHzX7gDhPOTrw3KFTulztGvv4VFW3L4V+yHV6oSRn7wFV54X6ukuc3WU74Gw
	 l+qoCxx9MlWVSKvZQspuPwwpo6a2fQ4HKGPxOBeq/VS/xyIltNYrFtJ3cKWD+aA4yw
	 5vqH75FRH5jDyhzcPK5yrdIwqpyRlKbWvslpXBVzVoR6vrHFwJO0dwI1zJYKozBxpq
	 VJ+7xEh6SPO4g==
Date: Tue, 23 Sep 2025 10:06:41 +0100
From: Simon Horman <horms@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
	davem@davemloft.net, kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v3 03/15] quic: provide common utilities and
 data structures
Message-ID: <20250923090641.GE836419@horms.kernel.org>
References: <cover.1758234904.git.lucien.xin@gmail.com>
 <a7fb75136c7c2e51b7081d3bff421e01b435288f.1758234904.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7fb75136c7c2e51b7081d3bff421e01b435288f.1758234904.git.lucien.xin@gmail.com>

On Thu, Sep 18, 2025 at 06:34:52PM -0400, Xin Long wrote:

> index f79f43f0c17f..b54532916aa2 100644
> --- a/net/quic/protocol.c
> +++ b/net/quic/protocol.c
> @@ -336,6 +336,9 @@ static __init int quic_init(void)
>  	if (err)
>  		goto err_percpu_counter;
>  
> +	if (quic_hash_tables_init())

Hi Xin,

If we reach here then the function will return err, which is 0.
So it seems that err should be set to a negative error value instead.
Perhaps the return value of quic_hash_tables_init.

Flagged by Smatch.


> +		goto err_hash;
> +
>  	err = register_pernet_subsys(&quic_net_ops);
>  	if (err)
>  		goto err_def_ops;
> @@ -353,6 +356,8 @@ static __init int quic_init(void)
>  err_protosw:
>  	unregister_pernet_subsys(&quic_net_ops);
>  err_def_ops:
> +	quic_hash_tables_destroy();
> +err_hash:
>  	percpu_counter_destroy(&quic_sockets_allocated);
>  err_percpu_counter:
>  	return err;

...
