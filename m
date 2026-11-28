Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827678;
	b=MpkPJfHnJLBcrIstcGtvhcj5yZo9OXJ5AEqIv/OoA8XZ/EnnEnApQF7IId/PfqxISJrX
	 uYKMjLZfMFJjgVTJfH47TCe4y2jw2zWOSNNKK6oWrzNGlrJcBWHrisfqipPSuxoQRJYhe
	 6QXwPDXeorlX4OLT4I9jPMkuNr/K+m8l+fYYxleV4m7M+SWpbw/rb7+ZTbZcYKXR6Q1vp
	 XeZHnn7jx31NRwBEC3jNCrPInyatIz2R+zjuLoeevkikWYmiQGm+ggaAFMsMJLHQv4SJI
	 ZrbBi+Mkq8xiOkPKpogexV2Uu7weZXGyqCVszKZDJjvFXXuOzys/KWsAE7w1DAYNxbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827678;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0wGpPTxMeeUVM4PnMceaZN+y2MmyAYLse/1AjGk2D/o=;
	b=lJ155sVCRD+tKaiMf3IOPc7GVd0fQUuVOn8XaDH/M7HrjfEkdb2rgdX2lEITmdCy44UE
	 LaLTB96APiEL17qFYvoYIbO+fgKoC2ajGAvZga00tn+L1pu/1hRex4vHtDG4HYnsPHAkw
	 nSZJ3dnkbxfA4A18q4GpkmqGYO+Bm3vEQoNQ5rWimJEnJBtrWIzwi9zGcm58pBg9AjxUM
	 wNtEgUfGcox2gC+UqZzUvHj/Spqjehsm+oPgScwd9zD7HXsStaLFdv7G9r7w2a+PZsmYN
	 fbn+EMIn5k8kvO+mEfTtPsIPvnicE5i5k39lKfegA4/InhRlus1BEi5BAq3jZOd+JoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JQW4P5s/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E61606A31C
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JQW4P5s/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3661F0089C
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795827678;
	bh=0wGpPTxMeeUVM4PnMceaZN+y2MmyAYLse/1AjGk2D/o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JQW4P5s/ehH1IV0Rr7w0TZvqnVsBdmWMOOuG9WEmQsmHicv8aRFaAvVZuV6lDWPIt
	 NjXWJ+hcStcptzO4mGRH1Uv6J/a+nz5vaoRHryAbF7DrLIQSSoW807LAhHe9W9cdPK
	 +nQf3nU4mWJU1enusacQ47RElxEk72SRdMYmX6fASLGbSmmFxKoNrfuVTyt/+QRjPt
	 c1oK+exDj5vEQdVgrk0bVJ4jnfKcvQquvB+TbgG3daIDVG4yg0gyYwlJYDKFskIe0C
	 Qh7WOMWSPa6FFjRFjuerixrTQszDnkV0t/OHUGltyywN63TyjerkC1iTo0l2nyt79+
	 e+enf9p672bVQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c516a1623d0so1005312366b.2
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 17:01:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGXRBPZt16kwmKhlDNpwEuK1Ba3tdZLfmbh7ehLMh3FfhIwBVmkWsUtQ86fa8/CwtIYMfQWRWJxbYg+@vger.kernel.org
X-Gm-Message-State: APuU4Z9Paur3XDELYpP9U+wwN+hbmxkeUXW14eQI8TNFeAkUvPD8c+f1
	yUQ5tEa37/Va0C9QVnYJf8S5PcaeKDvXj3/T3iwLI3enljOS5bd1zDO8xGOJug7TRvUKKo040uA
	y690HANgiMqXb49d8kSWomdeCO+iPnXs=
X-Received: by 2002:a17:906:9c03:b0:c46:2987:2169 with SMTP id
 a640c23a62f3a-c513a84c864mr1726939866b.24.1795827676552; Fri, 27 Nov 2026
 17:01:16 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795782695.git.metze@samba.org>
In-Reply-To: <cover.1795782695.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 10:01:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd84J71+-AYqt-F=jzHo83AQdR6qFO3=7RXOe_6GTcg5EQ@mail.gmail.com>
X-Gm-Features: Aa3M54pUZPaSc0dpz2dNDNC4Pj-m2v6SS48E3FsDnwjcPmExlEYlg-YhRLhwdC8
Message-ID: <CAKYAXd84J71+-AYqt-F=jzHo83AQdR6qFO3=7RXOe_6GTcg5EQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] smb: client: fix use-after-free of server->smbd_conn
 and the encryption nonce
To: Stefan Metzmacher <metze@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 9:42=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Paulo,
>
> these are client fixes reported by Sashiko:
>
>   - smbd_get_parameters(), smbd_register_mr() and
>     smbd_debug_proc_show() used server->smbd_conn without any
>     locking, while cifs_abort_connection() can destroy it at any
>     time (use-after-free). server->smbd_conn is now only changed
>     under srv_lock and only used with a reference on its socket
>     (the new smbdirect_socket_get()/put()) or under the lock.
>
>   - smb3_negotiate_wsize() and smb3_negotiate_rsize() used the zero
>     limits of a missing connection during a reconnect, with signing
>     the header sizes were subtracted from 0, which underflows, so the
>     RDMA limit was lost.
>
>   - smbd_get_connection() returns the real error instead of -ENOENT,
>     the following patches depend on that.
>
>   - The nonce of encrypted messages is a 64-bit counter of the
>     session followed by random bits of the session, like Samba does,
>     instead of random bytes, which only made a reuse unlikely. With
>     AES-GCM a reused nonce reveals the authentication key.
>
> "smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()"
> touches fs/smb/smbdirect, it's only used by the client changes.
>
> Reports fixed by this series:
>
>   - https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
>       smb: client: don't use server->smbd_conn without a reference or loc=
k
>
>   - https://sashiko.dev/#/bug/linux-211bb822-8907-4243-9dd3-da2595595552
>       smb: client: don't use server->smbd_conn without a reference or loc=
k
>
>   - https://sashiko.dev/#/bug/linux-d40006cd-d7c3-4ea8-8ebb-1bf2b55b0db0
>       smb: client: don't use zero RDMA limits without a connection
>
> The other urgent fixes for fs/smb/smbdirect and ksmbd (including
> the same nonce fix for the server) are posted separately, they are
> independent of these, the remaining smbdirect fixes follow on top of
> all of them.
>
> This also covers the problem addressed by "[PATCH v3] smb: client:
> protect server->smbd_conn with RCU and refcounting" from Qican Ma
> (https://lore.kernel.org/all/179570959875.92741.4311009098248753929@gmail=
.com/),
> without waiting for references in smbd_destroy(), which is called
> with cifs_server_lock() held.
>
> These patches were developed with the help of Claude (Anthropic),
> which was used for code analysis, writing parts of the code and the
> commit messages. I reviewed all changes and take full responsibility
> for them.
>
> Testing: on real hardware, client and server running the urgent
> client and smbdirect series together, over RoCE with mlx5 (ConnectX),
> irdma (Intel E810) and rxe:
>
>   - xfstests (59 tests of the cifs and generic groups) and O_DIRECT
>     reads/writes with data verification
>   - removing the local address or setting the link down while a
>     connection is established, the umount finishes in time
>   - 2x10 ksmbd restarts while I/O is running and
>     /proc/fs/cifs/DebugData is read in a loop, each restart reconnects
>   - mounts killed by a signal while their RDMA connect is pending
>     (the syzbot case), no tasks in D state and no warnings
>
> Note I didn't test with iWarp as there are existing problems with it,
> I have patches to fix iWarp, but I'll post them later, as they
> also rely on some rdma-core changes.
>
> As we are already late in the 7.4 cycle, I leave it up to you to
> decide if they should still go into 7.4 or into the next merge
> window, all of them are marked for stable.
>
> Base: v7.4-rc4, like the other smb series. The patches also apply
> cleanly (git am) on cifs-next (61c581ea62ee), on ksmbd-for-next
> (3c31349456c5) and on both merged, with or without the urgent smbdirect
> series, and build on both merged.
>
> Stefan Metzmacher (8):
>   smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
>   smb: client: return the real error from smbd_get_connection()
>   smb: client: change server->smbd_conn only under server->srv_lock
>   smb: client: pass server to smbd_get_parameters()
>   smb: client: pass server to smbd_register_mr()
>   smb: client: don't use server->smbd_conn without a reference or lock
>   smb: client: don't use zero RDMA limits without a connection
>   smb: client: use a counter for the nonce of encrypted messages
Looks good:
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
