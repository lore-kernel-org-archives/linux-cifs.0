Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785533;
	b=e/Lay8r/m/0wJADKdXPcw1SKOvr8yevH89YRXW6U4+cVGyGTIEw4Xij6ahlDPB/IZagk
	 fs4lg3oYE1JMu3cqxwRxfqKbu64o9fBEfiVdekqvFslJ8dQxw9sib1jZWTpF+Wrs219XU
	 DXqC2AnSZIyv8QB7dQmS1/wpSs7QbZfEnxYM1jkeZl3adimfdyPVHGdgpqoS1H8VLe8Ir
	 thtP/VZwsGqOgSZaX6IbOVXoDTVPQeq/xm0ZcDlGacrc5MvEkt/p4Inx12Qyh/V+RC9m2
	 4vLLZY7wttbeNrS4Fz9GXaUonQx7yuJDF7ro90phkwh15nGexlOpMjNSqi1TD1448wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785533;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=BIyxUvx+GxegmDGYWviZ9wHfx3LHRQyas6rnO09Diqw=;
	b=gUB8lXcyayN1tNljlnSuBD4377+Tzo/dL6MTjmMvFxVkJGoS/WraX7RMNqwNcMFMIiwp
	 HdE/JHAI8xexHkwAamWNsm+fCpN/+yQTbHDnRQhckGbG4/E97FmKcL2bQYRHl/6E75vC0
	 AqV2wQ/X6RKXS95r3ffR/0RSHqrQ8ol9YabMFSwyvvpEe0HujIiB/dATEbydfTJR/P2Hq
	 krd1hqs3MBLY6SXItfJMa84DXSrBr8sCC2mipUjLOhNw24nCGmngKgq+APrFeolJ8YG8E
	 AkH1waSdRlkJKsWT4+gbkHRsfbZsQdZYLpeEoTQSHUApqfaNCFVcmuTHlpS/4i89xag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EFVPxEnL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8949606BECE;
	Fri, 23 Oct 2026 19:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EFVPxEnL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7971F01825;
	Fri, 23 Oct 2026 19:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785532;
	bh=BIyxUvx+GxegmDGYWviZ9wHfx3LHRQyas6rnO09Diqw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EFVPxEnLiGkEdQ1gNldP3EGOdM/N9qTDm5YjNx5NcTbgZe7F/AWKBP9XNrHa7yulw
	 i2ywhZVTSKhBmb3rIBm4FFm15D6UhoZb2QjigxSM0SeemGZmJsZf+++/tcsz19nvfJ
	 m57cjOUUomFeonEHLtquhAjHFpGrL4hfSvTeNkavKGRnBxoeKC5qpJFOMSqzvqft5f
	 Up/99jFRTh34g+kMkY7rpo51TQjeCo20Fn0oN60vIUm58tOeQXV978HHnDPzl4OLA0
	 k8J9Ri5D7GA5CDKesOS6r5n9z2VS2bIUvTWa9uIJmETgzeFbvkZ5Lyxexg7GwTMLBd
	 WL7DhkGl9ZnRA==
Date: Fri, 23 Oct 2026 09:58:51 -1000
Message-ID: <89ba20818d083796e6150c2bf697b5cb@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] workqueue: export attribute and sysfs setup helpers
In-Reply-To: <20261022092514.2590010-2-huiwen.he@linux.dev>
References: <20261022092514.2590010-1-huiwen.he@linux.dev> <20261022092514.2590010-2-huiwen.he@linux.dev>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Thu, Oct 22, 2026 at 05:25:11PM +0800, Huiwen He wrote:
> The workqueue attribute helpers are not available to modules.
>
> Export the allocation, application and release helpers for GPL modules.
> Also export workqueue_sysfs_register() so a module can apply attributes
> before exposing its queue in sysfs.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
