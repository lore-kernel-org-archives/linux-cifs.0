Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EB5337108;
	Mon, 17 Nov 2025 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763391159; cv=none; b=X4A4+H/bNuEAGDyYBHnjDwzii+IqfFSi+kjQfV+BV+EVFse3bpbHLKd8IPZzBL0JmFLqSbV2+dro+JzuxPLxvAN8H2qSVzFunRZhAX9WJAWwK9VU/Nf8En848eLb4vvNr6Q98tjwS6NZ9xu84crwSVbvpRw2sNM0AhvJH0+fMtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763391159; c=relaxed/simple;
	bh=d0gJRFe5O5oxyfdofN6O/gPpe8rbSohYEpWcmPKF9fE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cT2G08fkwaVDkfMQ25gUCwT8wyaHKNiof4Agt19NZvbCbGNaAatUhrE9VeRu75tkst+Mh/IhuWXM7VfhpIEtOn/P3GEG8C1F5CzrkBEc67hpFhLL/7pHFu0wGc9z/LJ7KDLN7cXhc019AuEyX39czGaGtxBYsJQ1MxwSbK1f7Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BgbXCrLZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BgbXCrLZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=IyCngOossDPyBLMWLzMAJqaoi2OoRGy3Rcpb86+lvr8=; b=BgbXCrLZROEZYf/vnpjgp1FFOs
	7O30kOwROiOrpCKUv3imsp6Pmu1BooWYQu2dGPNe0pEhnCYpD21e1lIPKEgl/fnyEZR0wejDU190X
	dNc6MsdpdnFzLG3XtVsxah9Y6kM3sjJS3JjsFVWbgk3mXa/MC9YI1QqA1R3t2i/FahzautgQU95nh
	MRjZycc7INttfqOmpeDA25KeZTSR3djUyWlED11KHCq6T5VuDOFS9dsmOzdu/m5O6B9iBJRhj5oQZ
	K0AaKumdOVxPhbPMz1RJU1Nj5Fsg8ycbbwhdJHyZNmj6R/XHU4a2FfnIMCPnOKx8QP9R5okO459he
	P3i/VMmioabpYfSJGDKsvQ7il5oYZpx6k0vd4ebgTxrDCAMIqmVz3D96ceyN1CiUngEX4DYRl9Q7k
	d9qUpqxMVU4bR0XMXgY5OI7z5BZahka6EzGW6eVS70CBBmeobi5ybprlSFK/j8vtzlMq02Aw5Q2BD
	cwwWbIJQyWsTh61dUw/hMoeZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vL0af-00EOL2-27;
	Mon, 17 Nov 2025 14:52:25 +0000
Message-ID: <cc80596c-f08d-465e-a503-bdb42fddbbae@samba.org>
Date: Mon, 17 Nov 2025 15:52:24 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksmbd: server: avoid busy polling in accept loop
To: Qingfang Deng <dqfext@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>
References: <20251117085900.466432-1-dqfext@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20251117085900.466432-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 17.11.25 um 09:59 schrieb Qingfang Deng:
> The ksmbd listener thread was using busy waiting on a listening socket by
> calling kernel_accept() with SOCK_NONBLOCK and retrying every 100ms on
> -EAGAIN. Since this thread is dedicated to accepting new connections,
> there is no need for non-blocking mode.
> 
> Switch to a blocking accept() call instead, allowing the thread to sleep
> until a new connection arrives. This avoids unnecessary wakeups and CPU
> usage. During teardown, call shutdown() on the listening socket so that
> accept() returns -EINVAL and the thread exits cleanly.
> 
> The socket release mutex is redundant because kthread_stop() blocks until
> the listener thread returns, guaranteeing safe teardown ordering.
> 
> Also remove sk_rcvtimeo and sk_sndtimeo assignments, which only caused
> accept() to return -EAGAIN prematurely.
> 
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
> Signed-off-by: Qingfang Deng <dqfext@gmail.com>

Reviewed-by: Stefan Metzmacher <metze@samba.org>

