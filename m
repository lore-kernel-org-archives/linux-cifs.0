Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A96330D24;
	Fri, 15 May 2026 10:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778839927; cv=none; b=sASQgVMN6R4oD5U1fDZRcw8iMaGPuRcJVi/MiVUTiXko7MIaOhHhvLivAwBFKYGCHfki7G6B0EmVIOaxhvdvlMEB8daQDwO5g3wP/9OPBYy8B3jxwVMTWI4TBfGdyKBfQ3+6Pl/WMrtD29CucyeQ20k2e9Uyc0JwqAjVtLTgxss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778839927; c=relaxed/simple;
	bh=5a9rQy2fx66ID1NvQa43SYTCasp5uNQwN9IwfRDHL34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDSh3GHHFlQyfMjOBR7HOWi0H5yc3gKUsuPvE6wqA+UEt/sZrIqCGfg6ttA9qJFyzXuWFSk5RYyrDeauRH2ddYJhhqH4zPfbCL6STnEtauhZFdcUfHghprya225+OeNdtLXaPGDq/x3nWHLZ0MnQOCw10JFGZdgLxrjGOHI3qL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4edfcrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4edfcrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B18C2BCB0;
	Fri, 15 May 2026 10:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778839926;
	bh=5a9rQy2fx66ID1NvQa43SYTCasp5uNQwN9IwfRDHL34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n4edfcrjIDqXEkDPoTP0t9m70vjESL47nwGlgAjqoQU7x1R1mOKFtCzfRUUfcBdJE
	 lH2hl0keanRi+FaQR9l4pHdxMFoNXmsYEmItvtJXQiqRxJrjaBt4ffqsrClG49yDkP
	 u5iYELMJQYOFS94Jimp7ufWFEwcQAubl/qEhPSRE=
Date: Fri, 15 May 2026 12:12:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ferry Meng <mengferry@linux.alibaba.com>
Cc: stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 6.12.y,6.6.y] ksmbd: make ksmbd thread names distinct
 by client IP
Message-ID: <2026051551-chlorine-credible-86a7@gregkh>
References: <20260512023427.90371-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512023427.90371-1-mengferry@linux.alibaba.com>

On Tue, May 12, 2026 at 10:34:27AM +0800, Ferry Meng wrote:
> From: Namjae Jeon <linkinjeon@kernel.org>
> 
> commit 5da92a251e41f824d7e6b4d54d65dcdcfd69fda3 upstream.
> 
> This patch makes ksmbd thread names distinct by client IP address.
> 
> 100943 ?        S      0:00 [ksmbd:::ffff:10.177.110.57]
>  or
> 101752 ?        S      0:00 [ksmbd:10.177.110.57]
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Stable-dep-of: 77ffbcac4e56 ("smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()")
> Stable-dep-of: 97f8d2648ef4 ("smb: server: fix active_num_conn leak on transport allocation failure")
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
> ---
> v2: Replace verbose [backport ...] description with standard
>     Stable-dep-of: tags per stable tree convention.

Why is this needed?

Is this part of a series?  If so, what is that series?

confused,

greg k-h
