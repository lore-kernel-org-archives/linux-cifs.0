Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485662D7380
	for <linux-cifs@vger.kernel.org>; Sat,  3 Oct 2026 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791060407; cv=none; b=MyRxpvzgXiC+83MtDaJdreHtjih088j3PwHoYDCV+KzufH1i0OTA1WwzFAX60xujLeDksrQxcsIzj+0UanmK3dVfmwmTM7xKckE+NHxA1m8CHsjtPBCn50H6dXdzbdVeA4a49d3LM6XuVF4jIhi7O0NeUQ+zmMdszz60OaGRbVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791060407; c=relaxed/simple;
	bh=Aus/gvHHy5RdLI8kP7Xa3ogxapcAskLUbf3EOij07x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lXF304ywaAZYy7hUey8w4XsWIWC5Vu6keSDkUiOBm/CDRmauzMA8DrLwYHgCDOUtKyhKNKDLiDqd8q0OygBIsXKcauwv4dyGsZjEXl8ReR53GHoJf5EBpvEtKhhVpqZtRgEImsL98BVoenSnDSu0UvZ3GhjNrmyVUQz47O2BiIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XyHIL4QG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XyHIL4QG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=nZjn+ZaTjynGm1Vm9FFVAj8RXKSMS8bH52MaDJIqb5Y=; b=XyHIL4QG08ATgM5jgM4wuarJg6
	kCZ/Dt4yuQQ9Vzg6vJBIomNH3AsafGP85AIRVehLuyjKroNASvAt1j6iTBDlUhVchcXp4DwtjSP2h
	tGD4HrRfTKts0yvkyn5LhwAJeGueC0BGOQv0HkPcwNryf9YrKKH/JFJ+AlAR9BNYW1DeLuaqJRdz3
	TC9+7ARp/Yk0l96rsaPZgsYmJsOWSf4IKbDihbrj6rwveTcOL7m3gfON7Z03WvzoDn+3lpWtDxc5T
	tPCUAicqWOKHhDhkufuTdSzYr6UyKGTkMnDJZrWaRMRL1ti6vysNFPUc1m47nljqG27+tvdevRiFq
	YGMQ3CMN2oNEXch5qnkBpH/l9QEWna8sZ3ovDUf5WB0mgL+aGVjUxQn49tuhRRPxj3jJUeEAF04sJ
	RDdyGrmr9LZNVmbeMd1x3+EEIkYWdlU4URVGx0N0jYOI6I5Flb2www9GvTw9U+zenNCpWRvtib99D
	WmYpkdxuidnqExkyuPnTUeQ8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xD6cu-00000005Erb-2ilL;
	Sat, 03 Oct 2026 20:46:36 +0000
Message-ID: <e6d9409a-5648-4133-973a-70316214bb61@samba.org>
Date: Sat, 3 Oct 2026 22:46:35 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: pre-auth remote DoS via SMB-Direct listener backlog slot
 leak
To: =?UTF-8?B?66CI65Oc7YyA7ZWY6rOg7Iu27Ja07JqU?= <ihopenre@gmail.com>,
 linkinjeon@kernel.org
Cc: tom@talpey.com, linux-cifs@vger.kernel.org
References: <CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi 레드팀하고싶어요,

thanks for the report.

I actually fixed the same two days ago, but a bit different
as I did it based on my IPPROTO_SMBDIRECT branch.

I'll check this on Monday.

metze

Am 03.10.26 um 03:21 schrieb 레드팀하고싶어요:
> Hi Namjae,
> 
> I found a pre-authentication remote denial of service in ksmbd's
> SMB-Direct transport. An unauthenticated peer can permanently stop the
> server from accepting any new RDMA connection using about ten RDMA
> connections, with no valid credentials and without completing the
> SMB-Direct negotiate.
> 
> This affects deployments that run ksmbd with SMB-Direct over an RDMA
> device (CONFIG_SMB_SERVER_SMBDIRECT). It does not affect the plain TCP
> transport.
> 
> Summary
> 
> The SMB-Direct listener keeps accepted connections on a fixed-size
> backlog (listen.pending, limit 10). A connection is removed from that
> backlog only on the success path: promotion to listen.ready after a
> completed negotiate, dequeue by the accept path, or a synchronous
> failure during connect-request setup. A connection that is accepted
> onto the backlog and then disconnects before completing the negotiate
> is never removed from the listener's pending list. The slot is leaked.
> After ten such events the listener rejects every further connection.
> 
> Root Cause
> 
> On an incoming RDMA connect request, smbdirect_listen_connect_request()
> (fs/smb/smbdirect/listen.c) checks the backlog, then adds the new child
> socket to lsc->listen.pending and calls
> smbdirect_accept_connect_request(), which does rdma_accept() and arms
> the negotiate timeout.
> 
> The child is taken off listen.pending in only three places, all on the
> success path:
> 
>    - smbdirect_accept.c, after a valid negotiate: list_del() from pending
>      and list_add_tail() to listen.ready.
>    - the accept path: dequeue from listen.ready.
>    - listen.c: synchronous failure of accept_connect_request, before the
>      connection is live.
> 
> If the child is accepted and then torn down before the negotiate
> completes (peer disconnects, or sends a malformed negotiate), the
> cleanup path does not apply. smbdirect_socket_schedule_cleanup() and
> smbdirect_socket_cleanup_work() (fs/smb/smbdirect/socket.c) only walk
> the pending/ready lists of a socket that is itself a listener; they
> never remove a child from its parent listener's pending list. The child
> stays linked in listen.pending, the pending list holds a reference so
> the socket is never released, and the backlog slot is leaked permanently.
> 
> smbdirect_socket_destroy() has WARN_ONCE(sc->accept.listener), which
> shows the design expects a connection to be delisted before teardown.
> No code path performs that delist for a connection that dies before
> negotiate.
> 
> Trigger
> 
> Repeat about eleven times:
> 
>    1. RDMA connect to the SMB-Direct listener and reach ESTABLISHED.
>    2. Disconnect. Send no SMB-Direct negotiate.
> 
> Each connection leaks one backlog slot. After the backlog (10) is full,
> smbdirect_listen_connect_request() logs
> 
>    ksmbd: smb_direct: Backlog[10][10] full pending[11] ready[0]
> 
> and returns -EBUSY for every new connection, including from legitimate
> clients. The negotiate timeout (SMB_DIRECT_NEGOTIATE_TIMEOUT, 5 seconds)
> does not reclaim the slots. The service stays down until ksmbd restarts.
> 
> Impact
> 
>    - Pre-authentication: no credentials, no completed negotiate.
>    - Remote: any peer that can open an RDMA connection to port 445.
>    - Permanent: slots are never reclaimed, so SMB-Direct service is dead
>      until restart. Roughly ten connections are enough.
>    - Availability only. No memory corruption, no information disclosure.
>    - CWE-400 (Uncontrolled Resource Consumption), CWE-404 (Improper
>      Resource Release).
> 
> CVSS
> 
> CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H (7.5 High)
> 
> Affected
> 
> fs/smb/smbdirect/ (the shared SMB-Direct module). Confirmed on Linux
> v7.3-rc2 (commit df2908090). The backlog handling in listen.c, accept.c
> and socket.c is the same in current mainline.
> 
> Reproduction
> 
> Environment: a guest with ksmbd built with CONFIG_SMB_SERVER_SMBDIRECT
> and an RDMA device. Soft-RoCE over loopback is enough:
> 
>    rdma link add rxe0 type rxe netdev eth0
> 
> PoC (attached, poc_smbd_dos.c, built with
> gcc -O2 -o poc_smbd_dos poc_smbd_dos.c -lrdmacm -libverbs):
> 
>    ./poc_smbd_dos <server-ip>
> 
> Output on the vulnerable server:
> 
>    [*] baseline: does a legitimate client negotiate?
>      victim: negotiate OK (service alive)
>    [*] opening 12 pre-negotiate connections ...
>        conn  1..11: ESTABLISHED ...
>        conn 12: REFUSED (reject status 28) -- backlog already full
>    [*] waiting 10s (> 5s negotiate_timeout) ...
>    [*] legitimate client retry after the flood:
>      victim: connect REFUSED (RDMA_CM reject status 28)
>    [+] DoS CONFIRMED
> 
> I verified this over Soft-RoCE (rxe) on a loopback setup. I did not test
> it on hardware RoCE or InfiniBand, but the backlog handling is in the
> transport-independent listen/accept/socket code, so I expect the same
> behaviour there.
> 
> Proposed Fix (attached: fix-smbd-backlog.patch)
> 
> Reclaim the leaked backlog slots in smbdirect_listen_connect_request(),
> before the backlog check, by removing from the listener's pending and
> ready lists any connection that has already been torn down
> (first_error set), and releasing it. This runs in the listener context,
> so the release is safe there, and it mirrors the delist that the
> success and listener-teardown paths already perform. Doing it on the
> child's own cleanup path is not an option, because that would release
> the socket from inside its own disconnect_work and deadlock on
> disable_work_sync().
> 
>      struct smbdirect_socket *psc, *tsc;
>      LIST_HEAD(dead);
>      ...
>      spin_lock_irqsave(&lsc->listen.lock, flags);
>      list_for_each_entry_safe(psc, tsc, &lsc->listen.ready, accept.list) {
>          if (psc->first_error) {
>              list_move_tail(&psc->accept.list, &dead);
>              psc->accept.listener = NULL;
>          }
>      }
>      list_for_each_entry_safe(psc, tsc, &lsc->listen.pending, accept.list) {
>          if (psc->first_error) {
>              list_move_tail(&psc->accept.list, &dead);
>              psc->accept.listener = NULL;
>          }
>      }
>      spin_unlock_irqrestore(&lsc->listen.lock, flags);
>      list_for_each_entry_safe(psc, tsc, &dead, accept.list) {
>          list_del_init(&psc->accept.list);
>          smbdirect_socket_release(psc);
>      }
> 
> I built this on the KASAN kernel and retested over Soft-RoCE. With the
> fix: the PoC can no longer wedge the listener (30 aborted pre-negotiate
> connections all accepted, a legitimate client still negotiates, no
> "Backlog full"), a normal "mount -o rdma" still works, and 500
> connect/abort cycles leave the service healthy with no KASAN report or
> warning. This is one possible fix; you may prefer a different spot or to
> reap asynchronously rather than in the connect path.
> 
> Regards,
> ihopenre-eng
> Github: ihopenre-eng

