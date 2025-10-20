Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884F0261B9E
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985374; cv=none; b=Ym6AxaK1acEqCeA/vZoUdzCXQOGmDmxd2Dea0/qr2LZeo81Qs0KQwi7A9nlmqJVMYqtm5KqbNH5LwVyGnerYdlR0uAzb9VOoezFXsWMOT4VoQq4aYX+dAjC9s3pXdyAGOGZamAbyRFCW+fh9axkXDWpU+vm73vXN6QSlS2itciE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985374; c=relaxed/simple;
	bh=42BMAvA1Hd5N4Vwk5N0m6ZOFLmdxqqHfbDa/faoIYow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VmZPuhVI+1qfJIg/TlW6gyJOFxrWAhpdWRe5naUyTis+GjCiC+xv9ZaQU8rVXHArQor09Cc7w7iwqRIMy0BNtKpvAmIdXuKRZfr3z2fDyhQ2xO22TDnPaHSfzqQn18AKD0VBddO7cJwkvOKQoeGlx6oY+2nYNHkjvdV8t55TCy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IY6D5MU4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IY6D5MU4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=KZq8yJS6P7GhtA6jAmeV72n9c7cr6e4dDAA8rc3T/rY=; b=IY6D5MU4m8Kg24zE/5OSzUV3iG
	E4FbbNa/8oyMZfNuDL4zQYl12DEhxigEB97c2w3VYZqhA6WwJWt62pIbNzfZcpVjxdMrA1DcWQ0ka
	oJ3p6EQGqSvi0AGR9h3xeInT4hhk0SeUEQXjygZeFqXOWTewOH4yMr97JbGnGb8n9sYVgXMWKTKEv
	rk1wrLRecZNrdm9MDoVfh3/q9s1Vf9RDqfdEFeWrYnn4TES8hlJSG3mPbPC/UifJWO0zGYzdECOo0
	Tk2T0po2C2EB5/cBQRj+BWAlW0+n+9qTaCi/fS6cUOg1lgaGunXFyLG+qVqn4kvppYe+1PVF/HzDZ
	/qnUTdU/WMmtBWdzLIFXCgU3FmSdhv2jmph0PKvJlRzdLfdZPUgkxMvtPehgAobUBkE96ZDZgdG7K
	TjDDDPtULc9f49GNl8SZb+B/ciwVGso9fIEF6cKFZhxvdAkJ7N8ubZHXKLcW0FlXYMcl5b67ZWBP0
	RVLVOc2Ilgb61yZhqqFNxFll;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vAujp-00ACN6-1d;
	Mon, 20 Oct 2025 18:36:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org
Subject: [PATCH 0/5] smb: smbdirect: introduce local send credits
Date: Mon, 20 Oct 2025 20:35:57 +0200
Message-ID: <cover.1760984605.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

our client already has some logic to prevent overflows of
the local submission queue for ib_post_send(), if the peer
granted more credits than we asked for.

But it's not as easy as it could be.

I guess that won't happen against Windows, but our git
history indicates this could happen.

Now we have a loop of local credits based on our send_credit_target.
With that we always try to get a local credit first and then
get a remote credit. When we got both we are able to
mark the request as pending in order to keep the
existing logic based on the pending count working.
Removing or changing that is a task for another day,
when all code if in common between client and server.

For the server this is a real bug fix, as such a logic was missing
before.

For the client it's not strictly required for 6.18, but
I think we should keep things consistent, as it will reduce
churn on my 6.19 patchset, which already has about 100 patches
and brings things into common code. And more is comming there...

Stefan Metzmacher (5):
  smb: smbdirect: introduce smbdirect_socket.send_io.lcredits.*
  smb: server: smb_direct_disconnect_rdma_connection() already wakes all
    waiters on error
  smb: server: simplify sibling_list handling in
    smb_direct_flush_send_list/send_done
  smb: server: make use of smbdirect_socket.send_io.lcredits.*
  smb: client: make use of smbdirect_socket.send_io.lcredits.*

 fs/smb/client/smbdirect.c                  |  67 ++++++++-----
 fs/smb/common/smbdirect/smbdirect_socket.h |  13 ++-
 fs/smb/server/transport_rdma.c             | 106 +++++++++++++++------
 3 files changed, 129 insertions(+), 57 deletions(-)

-- 
2.43.0

