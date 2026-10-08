Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60D722F388
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 06:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439841; cv=none; b=HhbwOAhk5ueb2bfeVSkEkQe/pNdyHyknLY1rxVuYkcjA1c/XA4BP+y7EyJtFdkrmGpQqw5Q0++6MYsP8Eyvt5iqG0SY79k4YnujjepUNSVOVPHTevydPDBl+pCaEpvoxqYRYsABdyugLwYTGPsge161vOpOXKM7VDvHWW9Lu1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439841; c=relaxed/simple;
	bh=z04krkL10WI3YRosLZwTFgun2aT/G11u+oIze0TWtvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X2ShXUOY0tfXcexKrTykTCVfdwZZVepP45rmlnR2UUVjPddegN6onfn1s0I8Yd5bNToQGtVov3vnxUN6DNuFyWmf2Pi1JuqoCsg/fEta6oI82LY4Hf1jH2rgWYPnKPdcghVIwyvVQZHrKDV5FfhOTSmE7k2iXSLmXDu101PTisg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=l3lHp13e; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="l3lHp13e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=+8D4xrFz3WP5O485LrYv3iReQZLrp566v/7kCIygxcY=; b=l3lHp13eP9g4nsOwsRQ32G+f3p
	rxFEGwXE+w//wNJ8BNrTq3mbI30ZbLmP1hZCA6VJ3OEe4JQt9Bpbipxv257Lsj8rxtT51zw9GLIWe
	ZnUSOyqwWjJyr90gNn076FgQ4LBt03PjLJbSOCqFa+F5t+i6SZlnJ9tfCn2X1uXGRJpNolebQl6us
	Ipq9KbMyRSuZvHlYe2Da/EO79DKEmnSoGHLFA4vktAnFmyD3Z4fZyQ9nLgmjIQlyht2KpoDmjy/m6
	zijOjo6Kv0llOC4TXHkxSIMwlZz3+NBJ1RZY9DHYqEF7zhjeOY9kSriUxlTi20T15qKTwr/gjdong
	AAZB/o9RulFaweGgmCqV0LFhLnL0vdmtCnookgWFv4+AM9gfBwz+Uzeb4mWtg1iDD1enKb/xorBjI
	ve/zWzAiIhXVg4kyoNfql5bTiKqwbishuxJn+t90rZEzodnAMViONPWGBI8+9eZMx/qg/txYmkOTD
	iUia6vZTREBbjoPZOEV2Z8lK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xEhKp-000000006b4-2N9D;
	Thu, 08 Oct 2026 06:10:31 +0000
Message-ID: <76ad9700-db36-4c9e-966a-3dd403706780@samba.org>
Date: Thu, 8 Oct 2026 08:10:30 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] smb: smbdirect: release failed pending sockets of
 a listener
To: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Sashiko <sashiko-bot+sashiko@kernel.org>, Paulo Alcantara
 <pc@manguebit.org>, Tom Talpey <tom@talpey.com>
References: <cover.1791311817.git.metze@samba.org>
 <ab714dc8161c7b23734d95157b0b86e5d0081f1b.1791311817.git.metze@samba.org>
 <CAKYAXd-ziPYkMzYodQ1=nEEL2JGnAeGe9eYR8d_jk5EOTOEMPw@mail.gmail.com>
 <CANTrAmz-eDf4yacfb+LKEug8Asz3cEEGg2h_6w-pmT_6L4GTzg@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CANTrAmz-eDf4yacfb+LKEug8Asz3cEEGg2h_6w-pmT_6L4GTzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.10.26 um 06:53 schrieb 이성현:
>   Re: [PATCH v3 2/3] smb: smbdirect: release failed pending sockets of a
> listener
> 
> Hi Namjae, Metze,
> 
> On Thu, Oct 8, 2026, Namjae Jeon wrote:
>> Does this make return 0 unsafe? This path now queues cleanup after
>> creating the QP, then returns before cleanup runs. If DEVICE_REMOVAL
>> event arrives in that gap, the temporary handler sets sc->rdma.cm_id
>> to NULL and returns -ESTALE. The CM core then destroys the ID, and the
>> cleanup worker tries to destroy the QP with NULL ID, causing kernel
>> oops ?

Thanks Namjae for finding this!

> I agree, and I think there is also a UAF variant of the same window.
> 
> The patch comment says nsc "cannot receive any rdma event", but that
> is only true while the CONNECT_REQUEST handler runs. After return 0 the
> core drops new_id's handler_mutex, so cma_send_device_removal_put() can
> deliver DEVICE_REMOVAL before smbdirect_socket_cleanup_work() runs.
> 
> In smbdirect_socket_destroy():
> 
> if (sc->rdma.cm_id)
> rdma_lock_handler(sc->rdma.cm_id);
> 
> sc->rdma.cm_id is read without a lock. If the worker reads a non-NULL
> pointer, and then the removal handler clears it and returns -ESTALE,
> destroy_id_handler_unlock() frees the id_priv and rdma_lock_handler()
> touches freed memory. So it is UAF, not only a NULL deref.
> 
> Also, the QP/CQ/mem pools are still alive at device removal time. They
> need to be released before the removal handler returns, otherwise the
> later teardown runs against a device that is already gone.
> 
> The old code had no such window, because the failure path returned
> non-zero and the core destroyed the id while handler_mutex was held.
> 
> Possible direction:
> - in the DEVICE_REMOVAL branch, destroy QP/CQ/MRs/PD synchronously
> (rdma_destroy_qp() is fine under handler_mutex), clear cm_id under
> the lock and return non-zero;
> - in the teardown, read/clear sc->rdma.cm_id under a lock and skip the
> RDMA teardown when it is NULL.
> 
> I will try to reproduce it with rxe + "rdma link delete" under KASAN,
> forcing a failure in smbdirect_accept_connect_request() and delaying
> smbdirect_socket_cleanup_work(), and report back.

I think while we have smbdirect_new_rdma_event_handler it's fine.
But starting with smbdirect_socket_init_accepting which currently sets
it so smbdirect_socket_rdma_event_handler, still fine until
we call smbdirect_accept_connect_request, I think before calling
smbdirect_accept_connect_request() we need to set smbdirect_accept_rdma_event_handler
at the beginning.

Do you agree that would fix it?

Thanks!
metze
