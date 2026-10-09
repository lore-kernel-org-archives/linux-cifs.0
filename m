Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B9472F7B
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550002; cv=none; b=PsJ/REwuGekmdJfNLrq47TP7rNvqbnzFX5I0QKwssy67PeCnwS9UPgkN1TBpN86HPMyVaS9MrYoZ0WZboa/TfasSvdtR1p0/WcbXZ1oyGO18IY+lm5g+/n8byzwj2NbOkIIPrikhPpMZRoGq1ZE5SDJI1KbP6kptuGYKa92RTbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550002; c=relaxed/simple;
	bh=yop+plU1jE/48o/DNLuHUNknP1uihrafbr6VYyHOjrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mR01DidBbqAMbbjXpL6uqiVbWK9gx3ZfcjPfSteUI5QmZ76djm5oZsWGR7xBZYOXIqToeTrBZhOS2QWSbhEthF+fc8ThfVtXGB9gJRiTG9QUomBlcxMTWSTP9aAnBwEh7eNy7QZmszihNLSmU1y/EM6QxT+a0K+EpwcjXtncKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCW82gcs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCW82gcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649371F00893
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 12:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791549997;
	bh=yop+plU1jE/48o/DNLuHUNknP1uihrafbr6VYyHOjrQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bCW82gcsLwe/mpryzEJl5ZtXFod/pVsPtO+vvmXdoMCC18sQTWkAFVBwv76Mhf/0o
	 U5lTZHKhRj8jWGNxV/wo9jFJ0TpFP8RDyODRSuGLJNaRlswEKNVpzvC7ParQnELw8i
	 dlk28Fnp+S93gGUmP+rqID1Y5JTYV4NdYPNoxrISZlPmQSxEFc1Uu8M9hgPj2oNNdj
	 ST0xfmv4UcEVUuudOypSJf933zkEPUDkRScnN7GV7YGWGTf9oDheEEKNyoXdGKOllm
	 53sKLqJaEk0OUZuGyvx8CAuvALY1sZMc1iPvt1UAjQl+mO1gmxnrGoH1q4MEI9CylM
	 HoHVdsPKcBN3g==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2e5f8fe879so655813666b.3
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 05:46:37 -0700 (PDT)
X-Gm-Message-State: AFq9FYLZwd13VcG5VG/x9AHU2aYte1zRn04nsfxOLiGOSlsr0YDXj0Bd
	g10oN8xs8XUqz0CsYt7ByEhuX4GU2KMDTWaKEAyvOJ+pH4MRzkgrSrd36JDjefkB5YqMKDok+cZ
	B5oqhnLHbNQKz7bZG+DQSFxKEgLvTXQ4=
X-Received: by 2002:a17:907:968b:b0:c2a:c76c:c743 with SMTP id
 a640c23a62f3a-c31aa0b353amr188187366b.35.1791549996065; Fri, 09 Oct 2026
 05:46:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009102827.1785085-1-metze@samba.org>
In-Reply-To: <20261009102827.1785085-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Oct 2026 21:46:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-XL5xm1P5WOin6h_uzqy4EuxvC1hden4UfPNnRT7TV=w@mail.gmail.com>
X-Gm-Features: AclHuK_3JbGPwqG3QkA5Y0ho--dPxJsJv-rsFfQK4-rYJoqE_j2NvoxsG9A5zhw
Message-ID: <CAKYAXd-XL5xm1P5WOin6h_uzqy4EuxvC1hden4UfPNnRT7TV=w@mail.gmail.com>
Subject: Re: [PATCH] smb: smbdirect: don't WARN on an unexpected receive opcode
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Sashiko <sashiko-bot+sashiko@kernel.org>, Paulo Alcantara <pc@manguebit.org>, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 7:28=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> The receive completion handlers smbdirect_connection_recv_io_done(),
> smbdirect_accept_negotiate_recv_done() and
> smbdirect_connect_negotiate_recv_done() verify that the completion is a
> regular receive with WARN_ON_ONCE(wc->opcode !=3D IB_WC_RECV).
>
> But wc->opcode is controlled by the remote peer: a posted receive work
> request is consumed not only by an incoming SEND, but also by an RDMA
> Write with Immediate, which completes as IB_WC_RECV_RDMA_WITH_IMM. An
> unauthenticated peer can transmit such a message, even before the
> negotiate completes, so it reaches the accept/connect negotiate
> handlers as well. With panic_on_warn set this is a remote denial of
> service, and otherwise it still taints the kernel and spams the log for
> something a peer can trigger at will.
>
> The opcode check itself was inherited from the original client and
> server recv_done() handlers (fs/smb/client/smbdirect.c and
> fs/smb/server/transport_rdma.c), where an unexpected opcode was simply
> logged and the connection was torn down. Only the WARN_ON_ONCE() was
> added on top during the socketization rework. Drop the WARN_ON_ONCE()
> and keep the existing graceful error path, which logs the unexpected
> opcode (unless the status is IB_WC_WR_FLUSH_ERR) and tears the
> connection down.
>
> Fixes: ea4151222a93 ("smb: smbdirect: introduce smbdirect_connection_recv=
_io_done()")
> Fixes: eb3ed1e9048c ("smb: smbdirect: introduce smbdirect_accept_connect_=
request()")
> Fixes: d1f187656797 ("smb: smbdirect: introduce smbdirect_connect[_sync](=
)")
> Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-5341a0c0-7b00-4eef-915c-91e099649=
d3e
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Paulo Alcantara <pc@manguebit.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Applied it to #ksmbd-for-next.
Thanks!
