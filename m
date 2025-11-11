Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01D332AAB9;
	Tue, 11 Nov 2025 06:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762844162; cv=none; b=cbrFYcrC+3h3UXRELbt2oE9vMbgrhWy7O9d/h4cuI/+TxLgzMYsxmGaIiZmme8E3x3kjKA3Xd1iypiYg5+RDdk4B36QUHUgnVtHWMaF3VsIJPSUfT1bvFWxOrCtM94SWzPaMSSJjQAWhXtJFCXss8rEp7xBqDirwmywws4N3s4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762844162; c=relaxed/simple;
	bh=71fh2UBPGdGkeZoQJpyuGMXyOX5u4Ob1+YuT3ujhbHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IcdQVTSRk6NcEL95ocqJ2BtCYTgx6N/4B/g0LJC9NSiSuNxXcCU44NUwSFMfXRch62POuv4LvSoXB+xLm79T4Pv1pw/w66DopINj/KIe5rK7yz90maxUpY18T4sydIBkgQWKrdGiH3nSET3YNCmJeZ8PzUN+0lYJG9FWxSPL+Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0WagihGL; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0WagihGL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=iEhTHZn21i+3KF3ORBvB8TLTtcRfOa/jCYdK1CHyT58=; b=0WagihGL88GWUShAC9fo9AJqUl
	K/Hkq44o8e6JEw2w5kyMfy46JEDYaowvsP0bl/NSRzeokTUfoJLUEBJrs3M4msLf2B34gUlail1nR
	L/XkmNUG+sEq+a3Fk4Sp4Ex4lnRei2bvp+j/cCXeOOl0NyH8ao6xOZKjRX6Ha62+nOblxDwj+cPa+
	vIpCTobDyLvYxokqDe5NXb0z7L5skhN9HH0Ws+SR6o10tRE3qV9PpbtsgUJIrmut0/ECGJJWnlh3M
	gJq0rLwPHev7Awe0Aq4KvuFYYOhsD/8HmqnZh9PDpeUzf34W2Lt+dokYihjmYLnFfkke6+PorbSmz
	ZaFmjqov9UPYud+unUzeOe4qEGH1mpNZe85fsS8aSTHYpYXCAzPfpQ8Gy3ku/jolhuDznL36IzcI4
	MUN9QvgxF3MfCHhJAKSXoo10ZTN5ABNAp3EC+uk6g+L+fUD8PdVLSvkKlZLW4CFLy6n+w9MKGr4CJ
	ZK2rrzRlcHRRhs8ZrW5YDYjt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vIiIE-00DZGs-0M;
	Tue, 11 Nov 2025 06:55:54 +0000
Message-ID: <2516ed5d-fed2-47a3-b1eb-656d79d242f3@samba.org>
Date: Tue, 11 Nov 2025 07:55:53 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: server: avoid busy polling in accept loop
To: Qingfang Deng <dqfext@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <20251030064736.24061-1-dqfext@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20251030064736.24061-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 30.10.25 um 07:47 schrieb Qingfang Deng:
> The ksmbd listener thread was using busy waiting on a listening socket by
> calling kernel_accept() with SOCK_NONBLOCK and retrying every 100ms on
> -EAGAIN. Since this thread is dedicated to accepting new connections,
> there is no need for non-blocking mode.
> 
> Switch to a blocking accept() call instead, allowing the thread to sleep
> until a new connection arrives. This avoids unnecessary wakeups and CPU
> usage.
> 
> Also remove:
>    - TCP_NODELAY, which has no effect on a listening socket.
>    - sk_rcvtimeo and sk_sndtimeo assignments, which only caused accept()
>      to return -EAGAIN prematurely.

Aren't these inherited to the accepted sockets?
So we need to apply them to the accepted sockets now
instead of dropping them completely?

metze
