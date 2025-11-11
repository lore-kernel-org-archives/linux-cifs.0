Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1B534D38B;
	Tue, 11 Nov 2025 07:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762845396; cv=none; b=iYLHVQNRBy6RHlXX8HpFjjO29ZGNHd/R9w7DAUvkpv+tIQALlTI1MYnU2blO/m+j8ZN3W2Oq65jY+cmRXIm7Dl5ce18FV+mu0s3gfAB/BGGEu2HwOCcn2WTSI0fAbg/Vme0w03R92OyiWF5nBWusZjN4wiiKLdWgcsSVcrjU198=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762845396; c=relaxed/simple;
	bh=tgRN+3Ff01SBIW4c46omJ2zyYnVI86tEs2SnSuHespA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DGygfqex3fSSsTDTsoPIS3V/QDu7+W1aquE7mZP+GDKMtb1SbYAvOqlSZI9fZlP98rw7TFTV7UtRH2VrkAghY7PoqiX1seZhp5TMM0SxM7ZVzvSezYreIN2SI5mpd7LXrcun5/s8QOjhAbJHT8uXlCN7YHiGwH1FgLzzicumIF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uPwfVwpY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uPwfVwpY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=w+EJWcxfCKB7hHIJqXC79RKDukiV8IvOIbkLhkk22F0=; b=uPwfVwpY9mYy7lFIUV0vGENAdl
	ho3zdIXXQvIa+h/tDfeGfNMnmCeZy7+/ePzXMowqVr7uBjiRoL3c/YadnaPn7IWAxfkQkE7NWGR2X
	8/03QlTNBVbUChKI7/WbBGPcySPewpd9I7VBE9j6ynA5R3uj9ZTzAVHy7vcbBpxYT/Nji8ZEAUzvb
	iwLVsG2ws2zJmchL9saRKRT59HnK/mWZ30glO8GDx8NqoiycodCNocXwH3Gg2l/r3x3wkjHqLo6RL
	OubPU/Q++hrl/9tLyUr8y94kJ2jsGLyJcBVbCkY8tmYswnZO5BIM5e82Wjdumih2gVLhysrcZXeKh
	qFJ7a28W62MVFKPmWkpSufDcdsvpj3vlOZYojeG1BnrdOtMr9JnIR03VVmOgAZ8Jyu52OovXuRfno
	PDtmvkXvLfEB1a2YNvzAKk+irt+UM14UWl2qpSEMlWpPs0WZ3wLvS/l2QQgz4bWC/V7IKrO0QBPFC
	yKvJdutZWBcnrqB/k8u5sg6O;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vIic9-00DZNA-36;
	Tue, 11 Nov 2025 07:16:31 +0000
Message-ID: <10da0cb9-8c92-413d-b8df-049279100458@samba.org>
Date: Tue, 11 Nov 2025 08:16:29 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: server: avoid busy polling in accept loop
From: Stefan Metzmacher <metze@samba.org>
To: Qingfang Deng <dqfext@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <20251030064736.24061-1-dqfext@gmail.com>
 <2516ed5d-fed2-47a3-b1eb-656d79d242f3@samba.org>
Content-Language: en-US
In-Reply-To: <2516ed5d-fed2-47a3-b1eb-656d79d242f3@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 11.11.25 um 07:55 schrieb Stefan Metzmacher:
> Am 30.10.25 um 07:47 schrieb Qingfang Deng:
>> The ksmbd listener thread was using busy waiting on a listening socket by
>> calling kernel_accept() with SOCK_NONBLOCK and retrying every 100ms on
>> -EAGAIN. Since this thread is dedicated to accepting new connections,
>> there is no need for non-blocking mode.
>>
>> Switch to a blocking accept() call instead, allowing the thread to sleep
>> until a new connection arrives. This avoids unnecessary wakeups and CPU
>> usage.
>>
>> Also remove:
>>    - TCP_NODELAY, which has no effect on a listening socket.
>>    - sk_rcvtimeo and sk_sndtimeo assignments, which only caused accept()
>>      to return -EAGAIN prematurely.
> 
> Aren't these inherited to the accepted sockets?
> So we need to apply them to the accepted sockets now
> instead of dropping them completely?

Actually the timeouts are added to the client connection,
but not the TCP_NODELAY.

But looking at it more detailed I'm wondering if this might
introduce a deadlock.

We have this in the accepting thread:

         while (!kthread_should_stop()) {
                 mutex_lock(&iface->sock_release_lock);
                 if (!iface->ksmbd_socket) {
                         mutex_unlock(&iface->sock_release_lock);
                         break;
                 }
                 ret = kernel_accept(iface->ksmbd_socket, &client_sk, 0);
                 mutex_unlock(&iface->sock_release_lock);
                 if (ret)
                         continue;


And in the stopping code this:

         case NETDEV_DOWN:
                 iface = ksmbd_find_netdev_name_iface_list(netdev->name);
                 if (iface && iface->state == IFACE_STATE_CONFIGURED) {
                         ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
                                         iface->name);
                         tcp_stop_kthread(iface->ksmbd_kthread);
                         iface->ksmbd_kthread = NULL;
                         mutex_lock(&iface->sock_release_lock);
                         tcp_destroy_socket(iface->ksmbd_socket);
                         iface->ksmbd_socket = NULL;
                         mutex_unlock(&iface->sock_release_lock);

                         iface->state = IFACE_STATE_DOWN;
                         break;
                 }



I guess that now kernel_accept() call waits forever holding iface->sock_release_lock
and tcp_stop_kthread(iface->ksmbd_kthread); doesn't have any impact anymore
as we may never reach kthread_should_stop() anymore.

We may want to do a kernel_sock_shutdown(ksmbd_socket, SHUT_RDWR) after
tcp_stop_kthread(iface->ksmbd_kthread); but before mutex_lock(&iface->sock_release_lock);
so that kernel_accept() hopefully returns directly.
And we only call sock_release(ksmbd_socket); under the iface->sock_release_lock mutex.

metze
