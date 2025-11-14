Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C49231065A;
	Fri, 14 Nov 2025 12:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763121726; cv=none; b=YaUKUA2+iXGE60A1r8SrP3EWDb0eYfvqV06nxbn0vShhOSKtTk3KNuas5Un7EYqs2/106xRbrNojyw9OFH38Joz5ZB4R27CKIA8GPIVfhx2/W0kTiz5hqXRMZTKG9Bc3ECKAohMh+F9KKIpeUB3roAAYrbiyIShaH1lJvDg3GGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763121726; c=relaxed/simple;
	bh=RcOIrza22pQbeEe4PPAk8KoX4dKtq9BnjNAjCwPPzLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihPn1m2ArqwdgTMYWAGlXVCnlJ7UToFQOQiARr96884jZmfiya1iUYroph+qyOYV+G6a9HqDO1Ae8nAi3AR2n7jcSEuO/mHXOH+XmBi81zfIoMl0qSk5hCsL2OZGiYcfb+tldviKI7hiw/ZVUhg5tlZeQYVCi+KQ1HRHzgbvOFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3Pnieip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3Pnieip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEA4C4CEFB;
	Fri, 14 Nov 2025 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763121726;
	bh=RcOIrza22pQbeEe4PPAk8KoX4dKtq9BnjNAjCwPPzLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V3PnieipHYUUHcmnuNUlP7qNnl4dAYVySltj5L82uJj+Zj2PhVTomjJO9l8aXBtKm
	 WrQSYWwZxnM6Qx6JYPZ72VHI93r76g27SDW+ZC524cHwhEsAJp96v7kcELQkIXmZ5s
	 UVIxXrLlmoTXZg7IcMKjn+U1kI/WG9Gzc4lYDzOjKteyO8e5ezGr+YGbeDHBhJDdHp
	 8GlGeXdITJH7bD0Kc1ZGqEOoy7kaSVKzDMbVfiIm7IbY0SZuVKOab3At/b2g6VuXHt
	 BDTwEk8yi9o7kSPP1fym2dwjy7THo9vl9syjiKb9N10o0hngCr8R3lUzaWJuwrWFP7
	 PfBb+nOKyOujQ==
Date: Fri, 14 Nov 2025 12:02:01 +0000
From: Simon Horman <horms@kernel.org>
To: Qingfang Deng <dqfext@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2] ksmbd: server: avoid busy polling in accept loop
Message-ID: <aRcaOZ79iQwqMTZI@horms.kernel.org>
References: <20251111104750.25739-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111104750.25739-1-dqfext@gmail.com>

On Tue, Nov 11, 2025 at 06:47:49PM +0800, Qingfang Deng wrote:

...

> @@ -458,10 +451,6 @@ static void tcp_destroy_socket(struct socket *ksmbd_socket)
>  	if (!ksmbd_socket)
>  		return;
>  
> -	/* set zero to timeout */
> -	ksmbd_tcp_rcv_timeout(ksmbd_socket, 0);
> -	ksmbd_tcp_snd_timeout(ksmbd_socket, 0);
> -

Hi Qingfang Deng,

W=1 builds tell me that ksmbd_tcp_rcv_timeout() is now unused:
I expect it can be removed.

>  	ret = kernel_sock_shutdown(ksmbd_socket, SHUT_RDWR);
>  	if (ret)
>  		pr_err("Failed to shutdown socket: %d\n", ret);

...
