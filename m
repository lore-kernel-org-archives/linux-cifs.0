Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A532FEE1D
	for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750265526; cv=none; b=OUj2EBY/tA/VzMRfZJu8l8NBxn1xvB1Ng8jp1gYgLKNBBk5s0cJSxceRTBTpOxMMS7R0EgIvk7tnqTUthR1lns+lvd3llgxCJjCt5emXhpoQ5gaHCAZrnXdfq3mdHI3w7MjQ06fo3OuJ10NPi/voB7pHcwqlCFOgcMIdiujNX7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750265526; c=relaxed/simple;
	bh=zoEi4NDGBgcrWkSlrqFce92KrON2DU33kE4/2/cy7pc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OIyNcFEv7QWW6Qb5NR+MrJVqwPXVYPvozfwL8I78h7fISq8v9JarDedS+fOsqdYKvDe0sNqevDO+F4r2vdD9fBVKiiFbucYYQbHt32oDnO2CMEY7GeCqnjzEdw5ujwy/QkrOAP9LoAMvdeuF/xkCb/44qoLLGI821yfwQSzT0oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=KAtZVTA3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="KAtZVTA3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=EPr9l8XKcvKJEfwbuFXiQIT2Q7aI8orx6ZDgoIxdFXg=; b=KAtZVTA36J8WzET1YzycNAZI1V
	qsz3YDAHehKSMcmAJ1GADHorv/yNEccg0CQwfqfqyLgjFfpPTWjysZS7QaUyxu4ku1eNPGz3VaBdm
	IxD5ttGI4OZYeRkXwbEfVxkJzCKjetPkr388MZOPpenGYiQc5Fj2g6AJeUjjTURb2V2s+Sj443wo4
	yp7I9rapnC/7HhNDSTggtlDWuoakWBw8jDvuovQcjT5ZfvWESIb7ijftnunGb7UwxSkbH7x++YYqA
	gxe8acq+gGluqS6UvhnDlCUiaPajd24J+DUqXLDbDLkh/txQIF90l4aiwWK9hMDaAFmPfbrtOvTkj
	JgOyAjqrk+T5d3lq/lkWB3tCb5/ugBZo5l42CTQaUfiD3fyx/iUACwWH8IfQZ3bAuSuA9Em3VVt9E
	kDfH48a96RG1qChhIkf5Q48+2zXrhE/qO8zacW+JFXtU86uIQIYlrYQz3dWc0jtaVcaG2JsCGR2DX
	XhLG4yh++AzgwIGbKSFJf9cD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uRw12-00BL6R-2r;
	Wed, 18 Jun 2025 16:52:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <sfrench@samba.org>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 0/2] smb: client: fix problems with smbdirect/rdma mounts
Date: Wed, 18 Jun 2025 18:51:39 +0200
Message-Id: <cover.1750264849.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

here are two regression fixes for rdma mounts using smbdirect

Actually I haven't verified it all worked before
commit 3d78fe73fa123964be30f0acec449dc8a2241dae
"cifs: Build the RDMA SGE list directly from an iterator",
but from reading the code it might be possible that it worked
before.

Stefan Metzmacher (2):
  smb: client: fix max_sge overflow in smb_extract_folioq_to_rdma()
  smb: client: let smbd_post_send_iter() respect the peers max_send_size
    and transmit all data

 fs/smb/client/smbdirect.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

-- 
2.34.1

