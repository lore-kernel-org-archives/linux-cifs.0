Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783322;
	b=Hmnj8Nsu4jYgDuPfhZi13tiri8EaooF+Z+/uyKgyTyOTo6k5kJCWjlmPztWi5/Upg6oq
	 R7LQiU5beMRKaHdrWmAOtVBCi6BkQF/EW/BNRcQRYbyPwRSiOl8n01z20+eGosVehnowz
	 x5TDGCqB4BpmbzUY5CklsemOJZnqTUfgK/Z4mIxPppfOesETDUUD9WeaCfeMHauvIr1mQ
	 JCJhziPPhne9eVCRqjnBiJJZZy8BZeIwd+9KoyUMplHpVBLByeWE6fm/exVKs6vXIbtxO
	 3XxUrFCoAUOiM8guEtkbrGMIuPJ5Vk+WWSp8UtmvakssyfrQn/c8U4MvAdEoPyjp+Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783322;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1NMP7m35jSVPZCBTl5RqMzu6gbfqhEPBLsMl8ocNjQA=;
	b=df+MufDIE5zNKPdutk7nA/xEnHevbVYNtV7nXBJGbNZtATIGytlYV5vaftCMLTromxBW
	 Z5vUcXI5ZqrRyihfIZBquhnUNRVt3I04JSqVxH7AB4scHLl9sP2oQ7xGLy3dKUQ5oE5es
	 KbMBWmKZxb+RVDWFGXjSEDrta14Y5/dgplcnQzTlUxcpikVFMKqF2iqLsr24v6Soxvdmg
	 KHFqYrBKx4ETIWD2cMY8QiNkwvJncbU8/b9gNMgsqDCZD7UXM7ZfLtxeGBX6puNviLzr+
	 WQ++M4Wcn8BcutjTW9VfpGoqPeukhfabUdWjnckAjl7W1RH7+a5CRLQMpUOTgRSXVSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=vbCUqXCB;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B896606A31C;
	Fri, 27 Nov 2026 12:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B896606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=vbCUqXCB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=1NMP7m35jSVPZCBTl5RqMzu6gbfqhEPBLsMl8ocNjQA=; b=vbCUqXCBYzlhA3ThDp0vydl3HS
	UkBSpcNh4yTsd6EtiKqrtfCkaoBgu/HIZHpc05fsoWMsLchhfJkjpZL0O5do+xxS4PUIsafl9WdUG
	bRzQEmXHkLJquIbiaEFp8SRZrgJCfNGjMxhupde1SD8e0A5eFBGtRrqAERAZIKhuiOKr0nKlASKGe
	7KXHjyQK5Vs9+cpH3q9jClGxeLBpqrlLW+Su19RdrwGK34SpGfMNqZVFD8XRPGyQZjJWYkRt72Khb
	SOA8NGudo1eLWORW84l6dPgbzERW2xwNInItlgqun+6b2AeDNZy3gyFTUP41cKAAjaVSqApdCr0L/
	CkJl7tTVmyUJUUKaCjdhVT++D+tOq7DK26NCmB7zeBOL5Hu1EfxpA3V9xZ93ikqfAtZ2KDEB5rRWN
	xDZtRT/9TSbdBfygW/RtIXfLtiyP7HMOo3Jk2s7rL0H3ICMA+ssocVaNd8jsSX8Farj82mpsFdYBU
	kzzEG5HHEUwnOOoiSAB3TJa2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvH2-00000001M70-2Gdy;
	Fri, 27 Nov 2026 12:41:56 +0000
From: Stefan Metzmacher <metze@samba.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	stable@vger.kernel.org
Subject: [PATCH 0/8] smb: client: fix use-after-free of server->smbd_conn and the encryption nonce
Date: Fri, 27 Nov 2026 13:41:33 +0100
Message-ID: <cover.1795782695.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Paulo,

these are client fixes reported by Sashiko:

  - smbd_get_parameters(), smbd_register_mr() and
    smbd_debug_proc_show() used server->smbd_conn without any
    locking, while cifs_abort_connection() can destroy it at any
    time (use-after-free). server->smbd_conn is now only changed
    under srv_lock and only used with a reference on its socket
    (the new smbdirect_socket_get()/put()) or under the lock.

  - smb3_negotiate_wsize() and smb3_negotiate_rsize() used the zero
    limits of a missing connection during a reconnect, with signing
    the header sizes were subtracted from 0, which underflows, so the
    RDMA limit was lost.

  - smbd_get_connection() returns the real error instead of -ENOENT,
    the following patches depend on that.

  - The nonce of encrypted messages is a 64-bit counter of the
    session followed by random bits of the session, like Samba does,
    instead of random bytes, which only made a reuse unlikely. With
    AES-GCM a reused nonce reveals the authentication key.

"smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()"
touches fs/smb/smbdirect, it's only used by the client changes.

Reports fixed by this series:

  - https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
      smb: client: don't use server->smbd_conn without a reference or lock

  - https://sashiko.dev/#/bug/linux-211bb822-8907-4243-9dd3-da2595595552
      smb: client: don't use server->smbd_conn without a reference or lock

  - https://sashiko.dev/#/bug/linux-d40006cd-d7c3-4ea8-8ebb-1bf2b55b0db0
      smb: client: don't use zero RDMA limits without a connection

The other urgent fixes for fs/smb/smbdirect and ksmbd (including
the same nonce fix for the server) are posted separately, they are
independent of these, the remaining smbdirect fixes follow on top of
all of them.

This also covers the problem addressed by "[PATCH v3] smb: client:
protect server->smbd_conn with RCU and refcounting" from Qican Ma
(https://lore.kernel.org/all/179570959875.92741.4311009098248753929@gmail.com/),
without waiting for references in smbd_destroy(), which is called
with cifs_server_lock() held.

These patches were developed with the help of Claude (Anthropic),
which was used for code analysis, writing parts of the code and the
commit messages. I reviewed all changes and take full responsibility
for them.

Testing: on real hardware, client and server running the urgent
client and smbdirect series together, over RoCE with mlx5 (ConnectX),
irdma (Intel E810) and rxe:

  - xfstests (59 tests of the cifs and generic groups) and O_DIRECT
    reads/writes with data verification
  - removing the local address or setting the link down while a
    connection is established, the umount finishes in time
  - 2x10 ksmbd restarts while I/O is running and
    /proc/fs/cifs/DebugData is read in a loop, each restart reconnects
  - mounts killed by a signal while their RDMA connect is pending
    (the syzbot case), no tasks in D state and no warnings

Note I didn't test with iWarp as there are existing problems with it,
I have patches to fix iWarp, but I'll post them later, as they
also rely on some rdma-core changes.

As we are already late in the 7.4 cycle, I leave it up to you to
decide if they should still go into 7.4 or into the next merge
window, all of them are marked for stable.

Base: v7.4-rc4, like the other smb series. The patches also apply
cleanly (git am) on cifs-next (61c581ea62ee), on ksmbd-for-next
(3c31349456c5) and on both merged, with or without the urgent smbdirect
series, and build on both merged.

Stefan Metzmacher (8):
  smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
  smb: client: return the real error from smbd_get_connection()
  smb: client: change server->smbd_conn only under server->srv_lock
  smb: client: pass server to smbd_get_parameters()
  smb: client: pass server to smbd_register_mr()
  smb: client: don't use server->smbd_conn without a reference or lock
  smb: client: don't use zero RDMA limits without a connection
  smb: client: use a counter for the nonce of encrypted messages

 fs/smb/client/cifsglob.h  |   3 +
 fs/smb/client/connect.c   |  18 ++--
 fs/smb/client/file.c      |  12 +--
 fs/smb/client/misc.c      |   2 +
 fs/smb/client/smb2ops.c   | 111 ++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c   |   4 +-
 fs/smb/client/smbdirect.c | 170 ++++++++++++++++++++++++++++++--------
 fs/smb/client/smbdirect.h |  11 ++-
 fs/smb/smbdirect/socket.c |  27 ++++++
 include/linux/smbdirect.h |   3 +
 10 files changed, 291 insertions(+), 70 deletions(-)

-- 
2.43.0

