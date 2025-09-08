Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1882E7BB5
	for <linux-cifs@vger.kernel.org>; Mon,  8 Sep 2025 08:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757321642; cv=none; b=PW/cQ1bJFVf0iI0FCpAkWnSMRXVrO25VxHPgDOoL0XOVr4uDE01DPVu/3mcXWudjZ0VPkwJJNaoy0NmEAigOkaxMKbGNBiRUlobhCfQUuKJjAmjB4CIInHnjwpHRv5rI+eoG+XKEw7a+MA4+AGXfAsBzdxnU8H2vgo3Wdxny8Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757321642; c=relaxed/simple;
	bh=8CQoG6n55tHDJ82u9GnQNZ7/W31zUwm1XeibDKGcH3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CBUzjSuQaq86CRh/WhTix5LkZOir1GfoGucn8kioaHmI6t/PtaBnJJaP/vuMPVp9YPrQkDaZKW8SawlLDTwuz3LGHkjpY24vD6xibeBCLlnD3vCj97nbxlilaZ7mGI2qP0tVFa/YCYKfa0Q7pUAbGy44zvK1IXT121lNGB6o4ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Yy1D05ra; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Yy1D05ra"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=v1fYxg3XlYOY3lKTyQIPhBZVMVTl+PB8qiL1nCc61pw=; b=Yy1D05raRLhcHPbkbgzwSGZ/9S
	2lzVqKrzyOtXxyVcO+QfjNPjJ4WkK2IuoPlooMGsvTESRxkGhNRJBdRPR/BiYKThMSEOdEH6N+TzI
	e93nqsljO62kZ+iWyPfE9yw2fmFJcem6B9TwZApzMftEd9YuFZhMEMj1O3gNsUFN/TrbonU9XnGlt
	NTNKxd/0xfC1VU2Z260PJG/lHtcpeH0V6i+YLkuOgV3ZJBf4b08JDZCbdkt9c9m56sbzfc3le4OtF
	KgNod2qvbOpE8xCe+z1w+dlOMl9KU70dKZ0cnpaLerfTJeJsn0/36ih6lCWI1vAbNKxwv3vIGWwOD
	go9IfyGhbUcGjRAfgNbwW4N4A0d03JeSyvYdLmidJSwh+SSUgzwnnaRbhm/bWcPVRcbBqwXHxXnOb
	F2YxzFWoxy2Gg7vCBJqpjXM1P5U5tgrFxo+xJ1X7uQ5/8l9UL0WURs5HbFk3j/U9a0viMQiJP1cJY
	E9034Hqj/qFUEz0H6l/bzTs4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uvXdN-0030Is-2o;
	Mon, 08 Sep 2025 08:53:57 +0000
Message-ID: <552c9115-1b7a-4108-9e0f-7a1fee29ac68@samba.org>
Date: Mon, 8 Sep 2025 10:53:57 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 026/142] smb: client: make use of
 smbdirect_socket.send_io.pending.{count,wait_queue}
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>
References: <cover.1756139607.git.metze@samba.org>
 <91e2aff5324573c3c99590a28fb3a66c525a0bfa.1756139607.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <91e2aff5324573c3c99590a28fb3a66c525a0bfa.1756139607.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 25.08.25 um 22:39 schrieb Stefan Metzmacher:
> This will be used by the server too and will allow to create
> common helper functions.
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/client/cifs_debug.c |  2 +-
>   fs/smb/client/smbdirect.c  | 25 +++++++++++--------------
>   fs/smb/client/smbdirect.h  |  2 --
>   3 files changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index beb4f18f05ef..7df82aa49e48 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -480,7 +480,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>   			atomic_read(&server->smbd_conn->receive_credits),
>   			server->smbd_conn->receive_credit_target);
>   		seq_printf(m, "\nPending send_pending: %x ",
> -			atomic_read(&server->smbd_conn->send_pending));
> +			atomic_read(&sc->send_io.pending.count));
>   		seq_printf(m, "\nReceive buffers count_receive_queue: %x ",
>   			server->smbd_conn->count_receive_queue);
>   		seq_printf(m, "\nMR responder_resources: %x "
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 58db3e7d4de3..dd0e1d27e3aa 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -391,8 +391,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
>   		return;
>   	}
>   
> -	if (atomic_dec_and_test(&info->send_pending))
> -		wake_up(&info->wait_send_pending);
> +	if (atomic_dec_and_test(&sc->send_io.pending.count))
> +		wake_up(&sc->send_io.pending.wait_queue);
>   
>   	wake_up(&info->wait_post_send);


In the rebase on "smb: server: let smb_direct_writev() respect SMB_DIRECT_MAX_SEND_SGES"
I'll change wait_send_pending to become 'pending.zero_wait_queue' that is woken when
'pending.count' reaches 0 and change wait_post_send to 'pending.dec_wait_queue'
that is woken on any decrement.

