Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792455424;
	b=nZZIuD+UR1eZB0X4k/oI1wqdek1JnFRXnlPL78VHgICyXkbhINOgC9px+KzuTCSq9J3D
	 CQ1y4woOdG47lHe2mKVnH1ynaNk0lDiazECka07yatZdxiXUFJN+Ulv1/P72xmKBPWJyN
	 Y9FrTCRxlB5GbcP3MQxxweSlhnEUm1YPAv3iPXjuf2ujBpmFKi0GnI+EC2c1FZdsSqUJF
	 N4axMv37fWiMNX2fLvBKcEFoxLLxAniOZ8eMa/GUuQFSRtTYlSv3qOKN5PmvJTG/n7TId
	 lORknDLaqS5ieiwG1nHMA6L4juPBEklmbvDSqgsxlNInwhPDoXWWLLWk8mpDSSJNypA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792455424;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=5dXr2Vr3AQgTOje1pNgl3aTaTmOXgEBT/oO9jPFVR0M=;
	b=ifOZzMD5wYIX5ZyijxFKIvlnmgm6d+PAegF6SelbEjTClvlDUmkhb3DOgSGAuonSNMt4
	 STlNV5wtStLcbvUL8R+DF6vvAkoxpXSli9MxeKwlbdCxJIcaYTfBreqgd7EUSbGyK/9lK
	 37lYPg4wKFjg4KQl2J7JzG3t/IsZ4y8F3bA5qpwYVkne2VLIxJ4BH0r4nqiVkLgnbdyYI
	 IRHe9gkmeRCgWUM6IXnJi1Ls+rkbfPHgXEtsRoKhA+AICrG2eFL7ck6qeifqHOoQNyR6h
	 Ain8yJSXiVsfvLgNoxiNPiT/2ydDNVRMHEHQEvgZ5vB5C6H6+5yxO7gV5XoGug6cfpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X9DCHw61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6739D606A31D
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 00:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X9DCHw61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDAD1F000C5
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 00:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792455424;
	bh=5dXr2Vr3AQgTOje1pNgl3aTaTmOXgEBT/oO9jPFVR0M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X9DCHw61k+fmQtPiCoPvjbKlJ6A2BccPt95verrZLpB+W4VHPISFB/2U5WzdQbGuj
	 VcXxfovvMR4Z6yzwNJjrV02kq8HjTZmUEc0qVEl8mJncBz+x1ZnCEiQ2TEVI70zgYH
	 63xXCHWxEXzoyFxBNg/OCY9G4k1WJpQv8sX06e3yt2PskACqGCVzPMMVGFYyS0NPth
	 ALimXHVUjIDoTdjq89zWbvofVwGunE4ljFYazkp1jNtu9diyBRqAe3ZRsX6IKWCOG6
	 Fp2p1W0yzh33iSLiq5C6eOiS9A9gBIMU3Y/2fBWnEd/CMz+gtfe+dHv6LYNiHMCFvM
	 V7v/A1F3CE8aw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c43373ae89aso277116666b.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 17:17:03 -0700 (PDT)
X-Gm-Message-State: AFq9FYKv89EW9qxNsYA3afXjOfFzrLEpCd+Y5J5Cu9LPUGNJhMKSIxEC
	SB5CJ0MJsDcGj7II639uJ+t/7+zuQNX1xPjlpyrhLFKEjxyuom8+CB/u17C1yFuvVBvVrUBuloM
	lDdO7zQKwxJa52WJhtpxPH7K51zj8zhE=
X-Received: by 2002:a17:907:3da5:b0:c29:f5d5:5a97 with SMTP id
 a640c23a62f3a-c419f31bd1cmr655444466b.33.1792455422491; Mon, 19 Oct 2026
 17:17:02 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAD37_9gOExjNx7SSB3BFM-t=xCdPCFS--bMNZjQ6eMizf3pF4A@mail.gmail.com>
In-Reply-To: <CAD37_9gOExjNx7SSB3BFM-t=xCdPCFS--bMNZjQ6eMizf3pF4A@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 20 Oct 2026 09:16:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-1+zNJGBtcLeGovxMB+fCkMAiU6MWcicSm+BXGF_w-Sw@mail.gmail.com>
X-Gm-Features: AclHuK9ZRlWTgtNtGGHMW95KMRltG8s-USHZ_a5cuKPgNeM3X6y6j5GXLbkq9tI
Message-ID: <CAKYAXd-1+zNJGBtcLeGovxMB+fCkMAiU6MWcicSm+BXGF_w-Sw@mail.gmail.com>
Subject: Re: [Bug report] ksmbd: IPC$ RPC pipe handles are session-blind ->
 cross-user DCERPC response interception
To: Mohammed <mohammed.saad.alquraini@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 7:15=E2=80=AFAM Mohammed
<mohammed.saad.alquraini@gmail.com> wrote:
>
> Hello Namjae,
>
> Reporting a missing-authorization issue in ksmbd's IPC$ named-pipe RPC
> transport: any authenticated SMB user can have its IPC requests processed=
 on
> another session's RPC pipe object, receive responses produced for that
> session's calls, and disrupt that session's RPCs. Found with an LLM-assis=
ted
> code-analysis pipeline and verified by hand against the source. Low sever=
ity / isolation-hardening, not an urgent security issue, so sending to the =
public list.
>
> AFFECTED
> Present on mainline commit 70dd4ee7 and in current linux-next. smb2_read_=
pipe(),
> smb2_write_pipe() and the FSCTL_PIPE_TRANSCEIVE ioctl all pass the
> client-controlled VolatileFileId to ksmbd_rpc_read/write/ioctl() with no =
check
> that the handle belongs to the requesting session. Not a regression (date=
s to
> the original IPC transport). Distinct from CVE-2026-89794 (uninitialized =
padding
> in smb2_read_pipe); the recent FSCTL_PIPE_TRANSCEIVE no_fileid_ioctl exem=
ption is
> a Windows 11 interop fix and adds no ownership check.
>
> MECHANISM
> 1. RPC pipe handles come from one global IDA (ipc_ida, via
>    ksmbd_session_rpc_open()) -- small sequential ints in one shared space=
.
> 2. smb2_read_pipe() passes the client's VolatileFileId straight to
>    ksmbd_rpc_read(work->sess, id) with no check against sess->rpc_handle_=
list.
> 3. handle_response() (transport_ipc.c) matches responses to waiters by ha=
ndle
>    only -- the IPC payload carries no session id -- and wakes the newest =
waiter
>    (hash_add =3D hlist_add_head). ksmbd.mountd mirrors this: a global pip=
es_table
>    keyed by the same handle.
>
> So an authenticated user issuing SMB2 READs on IPC$ with a forged Volatil=
eFileId
> equal to another session's in-flight pipe handle receives that session's =
DCERPC
> response. The attacker cannot execute RPCs on the victim's binding
> (ksmbd_session_rpc_method() returns 0 for a foreign handle, so the daemon
> refuses method dispatch) -- the flaw is response-side only, which also ma=
kes a
> received payload unambiguously the victim's. A probe also leaves the vict=
im
> pipe's RETURN_READY set, breaking the victim's later RPCs on that handle.
>
> IMPACT
> - Cross-user interception of IPC$ RPC responses between authenticated ten=
ants on
>   multi-user servers (srvsvc share enumeration measured; lsarpc/samr etc.=
 use the
>   same path). Timing-sensitive: deterministic inside the victim's in-flig=
ht
>   window, narrow under real client load.
> - Per-user RPC disruption (more reliable): probing poisons the victim pip=
e's
>   state so its subsequent RPCs fail.
>
> MEASURED (reproducer, one run each)
> - Deterministic (both roles timed by the in-tree client): 4 responses
>   intercepted, up to 180 bytes -- the victim's srvsvc NetShareEnumAll RES=
PONSE
>   PDU (share names in UTF-16); victim RPCs broken.
> - Realistic (victim =3D real smbclient share enumeration; attacker =3D se=
parate
>   remote user, 8 sessions, pipelined forged READs): 1 interception in ~52=
,000
>   probes, victim's 40/40 enumerations still completed. Real but noisy wit=
hout
>   tuned timing.
>
> REPRODUCER
> Self-contained SMB2 client (C, no deps) in a qemu VM with a CONFIG_SMB_SE=
RVER
> kernel + ksmbd-tools: two ordinary users; the victim does a srvsvc RPC on=
 IPC$;
> the attacker (no pipe of its own) issues IPC$ READs with VolatileFileId s=
wept
> over the small handle space, timed into the victim's window. No code chan=
ges and
> no non-default server config. I can send the source on request.
>
> FIX SHAPE
> Reject any handle the session does not own, in ksmbd_rpc_read/write/ioctl=
()
> (transport_ipc.c), using the per-session lookup already computed there un=
der
> sess->rpc_lock. smb2_get_info_file_pipe() already applies exactly this ch=
eck on
> the pipe query-info path; the read/write/ioctl paths are an inconsistent
> omission:
>
>     down_read(&sess->rpc_lock);
>     if (!ksmbd_session_rpc_method(sess, handle)) {   /* 0 =3D not this se=
ssion's */
>             up_read(&sess->rpc_lock);
>             return NULL;   /* -> STATUS_INVALID_HANDLE, no IPC round trip=
 */
>     }
>
> A more thorough fix also scopes the handle_response()/ipc_msg_send_reques=
t()
> waiters by session. I can send a tested patch and run the reproducer agai=
nst
> candidate fixes.
Thanks for the report!. please send the patch to the list and me.
