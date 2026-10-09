Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8F943B4B7
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 12:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550027; cv=none; b=mduCSf9BU0u14VdEzQO0G9hxTM68d9hjtdm+VC+GkGPvv2LoM3OXx7pzByHoPiriXJS5s19ARRE21tBSu7A2j5agL8U+hbRfyMX0WIn8UIQvXkUmhqIV+XM68RcHVEcg+swuTaehdYlRsdf4DQyHklY4uDSNOLlPJ48H/d4lc/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550027; c=relaxed/simple;
	bh=Q+AQdPJeF5sFBFojmzLUvnJsvVrwVNsLxUw1Tahiln8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LedERFMttTeRrs+IsrmmOqPMpba9K2hlZIAqTFZ6+2wTUQkyuRXrK8AoxDRNVG/3aT0avu3R3HV+zg/26tAYTd2O5Pc5n9G2eAaTkDgUGo0iVvLNQkwGBGot7UZDCCI6UdmgZ/oRecJtJpeaqIaaCIUnCXSImcP0Ct9lnjZlvOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1cHnBWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1cHnBWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0B71F0089B
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 12:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791550021;
	bh=hc/HBR/hzYkH6wgSJKOhvYBbNWp8cSKSThGMRRRRWMU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=K1cHnBWS1hjxW9UZEiPxTKvszXio8ZWIq1o/J9atmwhWRk+LTe07AwYJvDBzkjYO+
	 frvXH7vSbGkdxBCykFJBRjpsLwgbURPfVyMaCn2bHv7GH9iCl5OprOXt6sqLKW6Op5
	 ZJvz1cEEkHM22j29G47yuTObTOXhp1m8ii0hNjqMZEFOAgkCzBGo4lkv85SYSnW5Sp
	 /O01VAiOtobNOBb3ysc/ps1rGIoT4SYAQDxpZzL9Oq8gF+fmwG2G/Z9oUQPaVRItgf
	 4+RX2t4nWUOOTTSAiaekgQspg6HeZDUq+x6fgN4tSdT4HmG4vHENQcjGZmZXzsrv0f
	 pgvJYCorTzfpw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2e6df2742cso612816766b.2
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 05:47:01 -0700 (PDT)
X-Gm-Message-State: AFq9FYJ5JSzPnjIhQ/wVfutVIo76dSi87QbEXD1s/C2dPXMOBjDOIopg
	4mi45oKfDAVG2lilGBHeGIx31XBN5TwKnseOucJ4WqtMnfsNvPkMMH4iawQTYq+1nL2sdybBUzP
	x+6lT4xDvb9EjYV6jbddVA5ZrlmUrouE=
X-Received: by 2002:a17:907:971a:b0:c2e:378c:8cee with SMTP id
 a640c23a62f3a-c31aa05bf43mr180583866b.34.1791550019963; Fri, 09 Oct 2026
 05:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791540051.git.metze@samba.org>
In-Reply-To: <cover.1791540051.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Oct 2026 21:46:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-H6fC3GbcwZ3r9rzzrFRCLy1ZXKSy4B0OhB2zuCv-6LA@mail.gmail.com>
X-Gm-Features: AclHuK85zx79j1ulJCq5-MaUx7TbFtH34QXwcGekmfzMRsZAuPdYYuAmxF3kU-U
Message-ID: <CAKYAXd-H6fC3GbcwZ3r9rzzrFRCLy1ZXKSy4B0OhB2zuCv-6LA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] smb: smbdirect: fix listener backlog leak and
 teardown races
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>, Lee Seong Hyeon <ihopenre@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 7:02=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi Namjae,
>
> These fix a set of problems in the shared smbdirect module
> (fs/smb/smbdirect/), reached through the listener/accept path, which in
> practice is driven by ksmbd for incoming SMB Direct connections.
>
> The main one is a pre-authentication remote denial of service: the
> listener keeps every accepted connection on a fixed-size backlog
> (listen.pending, limit 10 for ksmbd). A connection is only removed from
> that backlog on the success path (promotion to listen.ready after a
> completed negotiate, or dequeue by accept()). A connection that is
> accepted at the RDMA level but then fails before it is accepted by the
> upper layer - negotiate timeout, peer disconnect, or an invalid
> negotiate request - is never removed, so its backlog slot is leaked.
> After about ten such events the listener rejects every new connection
> with -EBUSY and SMB Direct stays unusable until the service is
> restarted. An unauthenticated peer can trigger this with ~10 aborted
> connections.
>
> This was reported by Lee Seong Hyeon <ihopenre@gmail.com>:
>
>   https://lore.kernel.org/linux-cifs/CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA=
0MHsZJMesagtfzA@mail.gmail.com/
>
> The series:
>
>   - smbdirect_socket_destroy_sync() no longer waits for
>     RDMA_CM_EVENT_DISCONNECTED after rdma_disconnect(). That wait could
>     take very long (until the rdma cm gives up, e.g. a peer that just
>     vanished) or never complete if the event already happened and the
>     status was overwritten. rdma_destroy_id() in
>     smbdirect_socket_destroy() is enough to stop further events; the
>     rest of the disconnect protocol is handled by the rdma core
>     asynchronously. This also makes releasing orphaned sockets
>     (next patch) non-blocking.
>
>   - A failed, not-yet-accepted child of a listener now moves itself to a
>     new listen.orphaned list at the end of its cleanup work and queues
>     listen.purge_orphaned_work, which releases it, so it no longer leaks
>     its backlog slot (nor its struct sock / RDMA resources) for the
>     lifetime of the listener. sc->accept.listener is only changed under
>     listener->listen.lock, and whoever clears it owns the release;
>     the listener is freed via kfree_rcu() so a child can dereference it
>     under rcu_read_lock(). This is the DoS fix.
>
>   - smbdirect_socket_accept() no longer hands out a socket that failed
>     after it was put on the ready list (e.g. the peer disconnected in
>     the meantime); it checks first_error / the status under listen.lock,
>     orphans such a socket and tries the next one. And it also
>     no longer returns -EAGAIN if a non zero timeout was passed.
>
> I tested the reproducer and the problem is fixed
> and I run various xfstests.
>
> I think these are important and should go into 7.3
>
> Changes since v3:
> (https://lore.kernel.org/r/cover.1791311817.git.metze@samba.org/)
>
> - "smb: smbdirect: release failed pending sockets of a listener":
>   install the real event handler and the expected event at the very
>   start of smbdirect_accept_connect_request(), before anything that can
>   fail. On an early error the caller only schedules nsc's deferred
>   cleanup and returns 0, so the rdma_cm core keeps the cm_id - it must
>   then already carry smbdirect_accept_rdma_event_handler(), which turns
>   any unexpected event (e.g. RDMA_CM_EVENT_DEVICE_REMOVAL) into a clean
>   smbdirect_socket_schedule_cleanup(). Previously the placeholder
>   smbdirect_socket_rdma_event_handler() left by
>   smbdirect_socket_init_accepting() stayed installed on that path and
>   returned -ESTALE, making the rdma_cm core destroy the cm_id behind the
>   back of the pending teardown.
>
> - smbdirect_socket_accept always goes back to smbdirect_socket_wait_for_a=
ccept
>   when no valid new socket was found, so that we don't return -EAGAIN
>   unless a zero timeout was given.
>
> Changes since v2:
> (https://lore.kernel.org/r/cover.1791229120.git.metze@samba.org/)
>
> - "smb: smbdirect: release failed pending sockets of a listener":
>   reworked the connect-request error handling after more Sashiko
>   review. smbdirect_accept_connect_request() no longer tears down any
>   RDMA state or clears the cm_id on failure; it only returns a
>   not-yet-posted recv_io to the pool and returns the error.
>   smbdirect_listen_connect_request() now sets nsc->accept.listener and
>   publishes nsc on the pending list *before* it calls
>   smbdirect_accept_connect_request(), and on a non-zero return it
>   schedules nsc's teardown with smbdirect_socket_schedule_cleanup() and
>   always returns 0, so the rdma_cm core keeps the connection id and nsc
>   owns it (and destroys it in its own deferred teardown). The teardown
>   must be deferred because nsc's id_priv->handler_mutex is held by the
>   rdma_cm core across the CONNECT_REQUEST handler; that same lock (and
>   the listener's) also guarantees nsc can't go away under us. This
>   closes the race Sashiko reported, where a connection that established
>   between rdma_accept() and setting the listener could be left stranded
>   on the pending list.
>
> Changes since v1:
> (https://lore.kernel.org/r/cover.1791224972.git.metze@samba.org)
>
> - "smb: smbdirect: release failed pending sockets of a listener":
>   fix a use-after-free and a missed-orphan race in
>   smbdirect_listen_connect_request(), spotted by Sashiko. The
>   nsc->first_error check and the orphaning are now done under
>   listen.lock, together with setting nsc->accept.listener, so a
>   concurrent smbdirect_socket_cleanup_work()/purge_orphaned_work()
>   can neither free nsc while we still look at it, nor miss the
>   orphaning and leak it on the pending list.
>
> - "smb: smbdirect: don't hand out already failed sockets in
>   smbdirect_socket_accept()": bound the accept() wait across the
>   "skip a failed socket and try the next one" retries, also spotted
>   by Sashiko. smbdirect_socket_wait_for_accept() now returns the
>   remaining timeout and smbdirect_socket_accept() carries it over, so
>   a stream of failed connections can no longer reset the caller's
>   timeout. ksmbd passes MAX_SCHEDULE_TIMEOUT, so it is unaffected in
>   practice.
>
> - Added Reported-by:/Closes: for the Sashiko reviews.
>
> Stefan Metzmacher (3):
>   smb: smbdirect: don't wait for RDMA_CM_EVENT_DISCONNECTED in
>     smbdirect_socket_destroy_sync()
>   smb: smbdirect: release failed pending sockets of a listener
>   smb: smbdirect: don't hand out already failed sockets in
>     smbdirect_socket_accept()
Applied them to #ksmbd-for-next.
Thanks!
