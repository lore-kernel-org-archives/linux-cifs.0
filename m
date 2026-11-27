Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795787723;
	b=aF/HK/NmLoK7lYHK46OvksfnBsnX7QkSEbo0XyVJqlQMZHCX/abYQdvPpHhOtRUUqJCS
	 FUmaXA0YRJoHApJ3uhG70PFiuYQa0u+q69Vt4d7S2L8n1BJJxfzrrQr1PecpZN/wkd9ZN
	 0CtlqbJ5553QeKFXY9UQTiu/QFzVs/NavVYrr4KBTYfC509X2C4uWqvNhcJvJyKHNrXzT
	 U1/r7BKvlIjmBN88EIgXGk56C/Sr4Eur61HV/9jtEvPx/mRi2Lh4Nv98P38kbqpRDzJDb
	 FGJAxnFH96GWyCtXlP/Y6tOAlKrqOFu3pBwTeopFdvWnJOFHcgvkyH/UPnuIeeiXDqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795787723;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=6G5Wc9NcRb8mKkj+PgIkAhgqqUY/7YAY9/trV4Hu2TU=;
	b=yxP/5Akyqh+llx5gU2WvkDQRuN5gYxJ+Cw+vRB/BlIM3zI1IaJ/7BNGAUA7TxNfSk5tl
	 RuJLw7WzZGvwUijOe+sexRUgvVdQH5s2i5J6boi5I39p6x/0q+ejQG/+FKuiT9omajgih
	 X5VfpTzD5w9zRbFEgxXYXsddWrIN78pbaAo+0+ucp/DDHMmpfGjJvOK2TX1sOs2wIfipO
	 tMbvRc2FLDriT8KeCcoFKKTTaXxdhxOPr3zK/0qYWJL9/cCZSqDrSL6m279uIdVV3+7GX
	 WzpR1Z7B4GMJ267kd/yjRcxEyM4zXAfcn2vJMbrtSKv1bR98Oaz/ib6IMMZV1aLIeVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=CVEs+XrB;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AAD606A31C;
	Fri, 27 Nov 2026 13:55:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79AAD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=CVEs+XrB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=6G5Wc9NcRb8mKkj+PgIkAhgqqUY/7YAY9/trV4Hu2TU=; b=CVEs+XrB31Ck7NMy00kKXiKhhy
	EVa3bV301ekWmEFNysMg7LRgue9y09es3j+VS+FewuzzSQ3lWa88qObbcQtPIPQB3BzlR22rs3JOA
	Sq3C7zPu8aEnOIghsM3E+e/sogq7u1vLpeLez+nMisIwhiUMt2cUhzCE0mvdyhfMyyblG1LBo9j78
	mFiUFncBdnAlrU4sGQTXXBNjGHwegjGVPAxVYRULrRUmXNTpgvvYZSqbSq7tcG4zbwJet+ZiAhEeK
	2XVPGWkkzy5pOZZLPi6D+kK/UgMlq5IigeRT9X2FZFbxYUd3G08Abq0LY+ds9vIpxmI7fXEvViWVE
	H2jMg99EPI2hky0tbYC6cVlBgy9KHpHUnr2FvZua3p2jvyhBOCchaq8gg2638QLUA0FnjYplfO7Zr
	75osA43Vdm/frkcQJoZm7hiQBUHj5xZDUJCIg9QGfnJPhEF2ZWIGsYa37XVDKL8wvdzW7exiSBNjZ
	X6JdZiUbYzU95uYtrDzWOLL+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWwQ0-00000001NGZ-3eHg;
	Fri, 27 Nov 2026 13:55:17 +0000
Message-ID: <43f22183-f059-4084-bbe7-21bb7ac61ebd@samba.org>
Date: Fri, 27 Nov 2026 14:55:16 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] smb: client: fix use-after-free of server->smbd_conn
 and the encryption nonce
To: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, stable@vger.kernel.org
References: <cover.1795782695.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cover.1795782695.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Paulo,

FYI: Sashiko reviewed this series against cifs-next, without the
urgent smbdirect fixes:
https://sashiko.dev/#/patchset/cover.1795782695.git.metze%40samba.org

- The integer underflow in smb3_negotiate_wsize()/smb3_negotiate_rsize()
   it mentions for patches 2-4 is the existing problem fixed by
   patch 7 ("smb: client: don't use zero RDMA limits without a
   connection").

- For patches 1 and 6 it points out that smbdirect_socket_get() only
   keeps the memory of the socket alive, so
   smbdirect_connection_register_mr_io() can still race with
   smbdirect_socket_release(). That's correct, but it's not a
   regression: without this series the same race is a use-after-free
   of the connection, with it the socket stays valid and only the
   smaller window inside smbdirect_connection_register_mr_io()
   remains. That one is fixed by the urgent smbdirect series, "smb:
   smbdirect: don't register MRs on a torn-down connection" in v1
   (https://lore.kernel.org/linux-cifs/cover.1795781300.git.metze@samba.org/)
   and, for the remaining cases Sashiko found there, in v2, which
   I'll post soon. Both series are needed for the complete fix.

metze

Am 27.11.26 um 13:41 schrieb Stefan Metzmacher:
> Hi Paulo,
> 
> these are client fixes reported by Sashiko:
> 
>    - smbd_get_parameters(), smbd_register_mr() and
>      smbd_debug_proc_show() used server->smbd_conn without any
>      locking, while cifs_abort_connection() can destroy it at any
>      time (use-after-free). server->smbd_conn is now only changed
>      under srv_lock and only used with a reference on its socket
>      (the new smbdirect_socket_get()/put()) or under the lock.
> 
>    - smb3_negotiate_wsize() and smb3_negotiate_rsize() used the zero
>      limits of a missing connection during a reconnect, with signing
>      the header sizes were subtracted from 0, which underflows, so the
>      RDMA limit was lost.
> 
>    - smbd_get_connection() returns the real error instead of -ENOENT,
>      the following patches depend on that.
> 
>    - The nonce of encrypted messages is a 64-bit counter of the
>      session followed by random bits of the session, like Samba does,
>      instead of random bytes, which only made a reuse unlikely. With
>      AES-GCM a reused nonce reveals the authentication key.
> 
> "smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()"
> touches fs/smb/smbdirect, it's only used by the client changes.
> 
> Reports fixed by this series:
> 
>    - https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
>        smb: client: don't use server->smbd_conn without a reference or lock
> 
>    - https://sashiko.dev/#/bug/linux-211bb822-8907-4243-9dd3-da2595595552
>        smb: client: don't use server->smbd_conn without a reference or lock
> 
>    - https://sashiko.dev/#/bug/linux-d40006cd-d7c3-4ea8-8ebb-1bf2b55b0db0
>        smb: client: don't use zero RDMA limits without a connection
> 
> The other urgent fixes for fs/smb/smbdirect and ksmbd (including
> the same nonce fix for the server) are posted separately, they are
> independent of these, the remaining smbdirect fixes follow on top of
> all of them.
> 
> This also covers the problem addressed by "[PATCH v3] smb: client:
> protect server->smbd_conn with RCU and refcounting" from Qican Ma
> (https://lore.kernel.org/all/179570959875.92741.4311009098248753929@gmail.com/),
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
>    - xfstests (59 tests of the cifs and generic groups) and O_DIRECT
>      reads/writes with data verification
>    - removing the local address or setting the link down while a
>      connection is established, the umount finishes in time
>    - 2x10 ksmbd restarts while I/O is running and
>      /proc/fs/cifs/DebugData is read in a loop, each restart reconnects
>    - mounts killed by a signal while their RDMA connect is pending
>      (the syzbot case), no tasks in D state and no warnings
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
>    smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
>    smb: client: return the real error from smbd_get_connection()
>    smb: client: change server->smbd_conn only under server->srv_lock
>    smb: client: pass server to smbd_get_parameters()
>    smb: client: pass server to smbd_register_mr()
>    smb: client: don't use server->smbd_conn without a reference or lock
>    smb: client: don't use zero RDMA limits without a connection
>    smb: client: use a counter for the nonce of encrypted messages
> 
>   fs/smb/client/cifsglob.h  |   3 +
>   fs/smb/client/connect.c   |  18 ++--
>   fs/smb/client/file.c      |  12 +--
>   fs/smb/client/misc.c      |   2 +
>   fs/smb/client/smb2ops.c   | 111 ++++++++++++++++++++-----
>   fs/smb/client/smb2pdu.c   |   4 +-
>   fs/smb/client/smbdirect.c | 170 ++++++++++++++++++++++++++++++--------
>   fs/smb/client/smbdirect.h |  11 ++-
>   fs/smb/smbdirect/socket.c |  27 ++++++
>   include/linux/smbdirect.h |   3 +
>   10 files changed, 291 insertions(+), 70 deletions(-)
> 

