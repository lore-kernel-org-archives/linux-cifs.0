Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4562A1632E7
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 00:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791245972; cv=pass; b=lnj2yz4yuwaRuxQAVNX7+beiXu5613bxH0ZfCLNrpgKhy0t3EG2s2dWHnlHSGqjQqaSKsPPil/9vUnpIZ/V0CnyS6I99q0SY6WhEv5Y+AmNZA3Tfpc6kW4HtfLbgEZt+XL7+zOe0eDXYuoi20KmB/8Z9dSgsFgPgt2+F3OyFBRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791245972; c=relaxed/simple;
	bh=IRtAO0XO3Q7Uzu453GhI6i+OPtP8nBOA25PY7VuAvxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gJ5Cb3FV8jTZHnnAT68bG/zPHcNDU7javcd5CQhso4dufzPU4SY0o9RzEuW1G5PkDG7dON967TSzytgB5vrToDF4Wx9rW8oaJEH1xqyXsKUFDYahZO3xK/EHc58rlbAfda6rdZyuJqP40dkIO0NtzdA9+utDIZgrYYcHOFr3FaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lfjUPFzc; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfjUPFzc"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6aa850436d3so2836833a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2026 17:19:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791245969; cv=none;
        d=google.com; s=arc-20260327;
        b=UN6fLb2UIZphFKk1Wmt5h6bQBQVEBPw0zPYNt0QBHICYp10Zt+/NV+9FkASakB5SGk
         iDDXSbyEr37OUYDI7+VRH7U1DI7FxwbRw34yYRI9pZbSOdIIVCQJGKNjxcXVK+ns7T/5
         la94ohsXiH5W0TvuDTnYnc4eCl/kkWp59LnnalrD1zVszi51b892RtDdPN4auRKXgDEx
         vv1XXXQSlUzpHNeIYW3BYmfHSJwVemDyrzslEuzGBfYalLjSJ6+8875mJfivzCsxfVC/
         wUbGnqojkaOVoV6y7V1hY9tZdcyLvMCU2L8LcpDvjKQPfa0kFkfzY5M95cx4dt0NrH98
         DV7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8FEv7jkCCNLUQv3ycCL+U/9EmHpW5bd+AjGJiAXIBk4=;
        fh=XlDoGL6y/oYXZc27kzje7Gv2tJaGTK9CPm2ipAKfBCs=;
        b=VdZ3uDDcvNti3QPeIQVdmAh+EqdsomK7yFLywGAU8jTdcDamrunHiEBFXXrgdfsyJ3
         rrvMi8H3xqfuI+xUGFmmNw32iMfBQznGcn5R/ym5y+KsB2FB0j1+KtADHydDSGBUOf7J
         kHGrwrQ6GeAFLPVrsW+s0qfBB9T/NYt2K9pg/ic1hX1ynPasjjx5Tqu9OfxNkGQpWmcQ
         GR1K88UDxlauEtqxeG2EbP+4ETxpimUmsP25O+y/dGUQ1OfVdxtK8TJ7NNUYInxS/Zgt
         p3fmjngCx1Vme3zkIBft4TWJDsFtIIFsI/P2GAJlD1kcHHqcFT6rx7B/j8MMNny+KsWt
         jUnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791245969; x=1791850769; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8FEv7jkCCNLUQv3ycCL+U/9EmHpW5bd+AjGJiAXIBk4=;
        b=lfjUPFzc6VWc0bJ5QxKsZZM7+hyc+DiEYnekDTJacQNkEZQ6tApqUm99GMB+5io9d3
         Ki2poR02lanOJ9B8Ge9adUrDQnD5z+qIICcGJwDDo8U4mX0NWcBAc8cfw/gdSLEA48l9
         5wE5pinDazkTJYtjs4oYnsKBZ9OcO741JJ4yCreViJ8UcZr5/OmAoVMZ8AIkOxQ/tiad
         OvHBi/04FE27Wq3OUW3eIPq3zq/LiotPjcP+BbN2hcuAFHcicR4SVMfuUMoHoiHT/c7h
         WxY2RO1q0E3Czsz5ekDyF/RyOEd97YXiUdHc9+UZOuS7KbqK4Il+/ajvAXSL+MKQROmo
         qyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791245969; x=1791850769;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8FEv7jkCCNLUQv3ycCL+U/9EmHpW5bd+AjGJiAXIBk4=;
        b=Nfs5ziW4JDCYb41feKG8XF594niG7IHdmEWN6ByacgVGrIbZ597Vl/VSfLZ8NwQZMz
         dZ2CKcdAV0bZOCR0vE7OvAPUzrVcdjmlnlI7XacZHet5I+vjCXSLOvrT/mj9BM8MKp9l
         6NS0NeCxX2Ufns4xRJmTsWx7I7rTO/6KOip4nUmmNhJvoQilFbO9xKlFzRzi52LlcRcV
         jHgeQz7/SKfTYjBzZjvTVE6xda3Eei24oX62OFcDlVtOYQJtyLsndHPYENZckbVQlTS4
         UP3ia1sCLM+VZDYdTO3b9meS3QMyTzycTHziIjEwDKuPWfG+IAMC36JoVJesUshoOJd7
         C3Fw==
X-Gm-Message-State: AFq9FYIld1/Qo8cwlawOe7hQgbETQNXnTHwqUXrXG0WKiev/lmlPL+Lq
	pwl0uXjtLXYPCDX0eZQ/fRUiWg72Kx2qPc/niNJD7kZKz0xrs5beHg49Ihc4d1kvD/jGT5FFGJW
	xexmXlr+stmw0gA6IOf4N/R0GFEF8RdY=
X-Gm-Gg: AYBFou3xq1G7UDjjQb1FYXdJIVud9A8/sNmidIXyOgOYe0WYWE/mg5P0XKdqQPK9jk2
	/t4M/bzAHsL+PMi2QoQ9gLcIm4HpQUfmo6naQKe7JrZOIFrNLyHiFyRGefsGY6kHl9haq6qYR1k
	F39I7d3LdmKSQNj6wkfdBmU7h36w2KexXSLMqewsEFURMZuFait4TVEB/kFL1SnbhhuayXYQLJx
	2h2STkxbwABqO0UjswraS5HOevc0t0WrAWO5iND7WmCH5yta3T5v6OMuEEbBYn3jcxxcSSD+Y8Z
	ypyJUfvocKtWgVAg+rf0HYLsKYoVHdrVy3xpQD+79AeTF17SA0strREIHckorsLjZ6pzSNQxyo2
	yGo+Oe44REBfUEDfAx5zIARlVH3B7Nn41faGVJryll6Ed6Mc=
X-Received: by 2002:a05:6402:3228:b0:6ab:81e:e827 with SMTP id
 4fb4d7f45d1cf-6afada34a25mr8748667a12.43.1791245969046; Mon, 05 Oct 2026
 17:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791229120.git.metze@samba.org>
In-Reply-To: <cover.1791229120.git.metze@samba.org>
From: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Date: Tue, 6 Oct 2026 07:19:17 +0700
X-Gm-Features: AclHuK-i4AWA3kavt6m2b6Bqb2rgg8sHrkcQqA-9pA72QCsD7NRf0aSEwwolvzY
Message-ID: <CANTrAmwHqivuuH9UhPL=744OQTZ=qzahqHV6k5eLEPgap3uBdg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and
 teardown races
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and teardown races

Hi Stefan,

Thanks a lot for the fix and for crediting me.

Could you please use my real name instead of the display name in the
Reported-by: tags (patch 2/3) and in the cover letter, i.e.:

  Reported-by: Lee Seong Hyeon <ihopenre@gmail.com>

The address stays the same. If it is easier for you, I'm also fine with
you fixing it up when applying, or with Namjae doing it.

Thanks,
Lee Seong Hyeon


On Tue, Oct 6, 2026 at 2:41=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
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
> This was reported by =EB=A0=88=EB=93=9C=ED=8C=80=ED=95=98=EA=B3=A0=EC=8B=
=B6=EC=96=B4=EC=9A=94 <ihopenre@gmail.com>:
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
>     orphans such a socket and tries the next one.
>
> I tested the reproducer and the problem is fixed
> and I run various xfstests.
>
> I think these are important and should go into 7.3
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
>
>  fs/smb/smbdirect/accept.c     | 138 ++++++++++++++++++++++++++--------
>  fs/smb/smbdirect/connection.c |  12 +--
>  fs/smb/smbdirect/internal.h   |   2 +
>  fs/smb/smbdirect/listen.c     | 124 ++++++++++++++++++++++++++++--
>  fs/smb/smbdirect/socket.c     | 113 +++++++++++++++++++++++++---
>  fs/smb/smbdirect/socket.h     |  37 +++++++++
>  6 files changed, 373 insertions(+), 53 deletions(-)
>
> --
> 2.43.0
>
