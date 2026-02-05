Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8C6436361
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308079; cv=none; b=YNQjowUPfe7xO8PuC3D+NGLdG8JYAlCwsVto+29KrXXqu0C6IXvmy7GFPAG7UkTxc/PaXWwpZBHwEzPrpuxYxGAqNu45E5RaD29lQf3GoBi1QsqwXnLLZ0nvPixHXXuuOFQvUYRzr4+BjN9bv7QC4FCJM/inVab+DZaj7EEnf78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308079; c=relaxed/simple;
	bh=rwP586sYVYdw8F9lcVMZnt1GXwOuqtLtEC1pSkzam7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JhxF4EFPmGowjgP3ZKwY21mB5RBNxWpQemwxRdcrhc9x19B5tu5oiw21+l9UPrFG94o0W9ZZm3Mtga78BsHv+TqMolwyasMZCc4EzGO6aPpvu6J9UisTq+Fns76xCYlHGP8pL0mpISFKZYKqj1Y+wQgAWsix++tdue+nXhr/GDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=G56pWmr3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="G56pWmr3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Na1VYNvsgpvtMERemJLKJJbNXd/5h8y0mpwNqLDo+ck=; b=G56pWmr3ROs27IhxAnPX/QB8wX
	6IgmJxc/EXvYQ2W1BXX6dCAzTVOyIRyZw8A7Pa16QMtUTLh0uNrqfgTE1nDh07MfE50JQZI3HC+de
	L7vMzISqdBn7h05ZWcPsXu78mFmLFXCY3KXyaTGEZOOgHtYs0pfM3ExXGWiqQSia+HNBvuKH4b6Dv
	tUO5oTJGRGZfPSPPMvVow9rJEipMw0DsR94W4e1Pw2Ae6SwPN840qla4e579ejn9mHV9QL+0A0JOK
	x/ude6dl0SEWmVBsGcpHzcpZ/yBg7U4jwc/OGWNr06HgVci6oQ2TwMUIHpRHvyEfPTNKS+y3hwtfj
	XZN0At09vgc6u4S5Em9B3LG3Ed5W5kVoYbwJxwM837HFQJZ4kZH7mT18AdUoCAKG62o1U4eT82ch0
	98CHtYIEkrkbHkgk4kMuiw+0uR78/Gt66nKMhjRL8FjaSA3I9SBWkEkdhVhVEc1feIDfsvEq+v2Fl
	hAaMCD7w26PikCIAghb8K0jP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vo1zx-00000004THK-2N2o;
	Thu, 05 Feb 2026 16:14:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 0/2] smb:client/server/smbdirect: correct value for max_fragmented_recv_size
Date: Thu,  5 Feb 2026 17:14:13 +0100
Message-ID: <cover.1770307237.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

here is one additional fix for the credit problems
in the client, it most likely happens when using
signing on rdma: 'rdma,sec=ntlmsspi' as mount options.

The problem is that we announce a large
max_fragmented_recv_size to the server, while we
don't have enough recv buffers to hold
the largest possible fragmented message.

For now we use the same logic as we are
currently using in the server:

max_fragmented_recv_size = (recv_credit_max * max_recv_size) / 2

There's a lot to improve here, but this makes sure
we're able talk to a peer without running out of credits
while transferring a message that uses the full
max_fragmented_recv_size.

The server patch is basically just cosmetic
explaining the logic we're are using.
Note the value of smb_direct_max_fragmented_recv_size
is never really used as smb_direct_prepare
recalculates max_fragmented_recv_size.

This applies on top of ksmbd-for-next

Stefan Metzmacher (2):
  smb: client: correct value for smbd_max_fragmented_recv_size
  smb: server: correct value for smb_direct_max_fragmented_recv_size

 fs/smb/client/smbdirect.c      | 19 +++++++++++++--
 fs/smb/server/transport_rdma.c | 42 ++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 4 deletions(-)

-- 
2.43.0

