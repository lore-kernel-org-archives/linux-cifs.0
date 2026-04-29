Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C0C3FFAD0
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777470236; cv=none; b=K8+S9Zlo0iab0Xc2CY905gzzmoKS6pQQ7Dt1xT74kLVwGE7ruF+5KS9+jlIwSbYlbTAvG3RKCrMl8mNrKCORQqHAEMXmiQEp7tTmBu6uV7Ps3izjfcGkUStHG3zRiYxe/3xbJbzMguvfmekRk4AY9XrWyTqXlEjzTHSpy+yUR3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777470236; c=relaxed/simple;
	bh=RFAVRTHYsipI1EkYUDtesDR1w0I7Wo0hYpZ5dwD4/BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dgxGyr1E9N1N2npD55wlBQx4gsyxBVt0w+6pCtAStkDc5lBjyIamnMg+yn7UtOkL2bnQNAdDZoV7i4EhMEhSU8oq3f0J6nvCa0PCMtWKVHXhYuhbAsZDfo7clCmVNtLM9vB3e0r9eunrS54XAQdIu88lGAmIhwJRnvMeq/ObZjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ji6lM81X; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ji6lM81X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=wMuL3I7GmXsrX5RdFSQMN1VkhDhHDubuhhH4nP0ADEg=; b=ji6lM81XcgaqMmGk85ZRseacb4
	eghzrs1THu+QpeBjFHPPECmzYplaRjzbWAIukOSANa+hb1Relv34NJ5JPmTY+LiFkIaQ6A9WRgSPo
	qgySUMNwdz2UNhoEFBouDgjrp7z3+JBQFG1UhilpLW5GJnwQX4Ml3ZMxqbcui6bcL7BWRIh/D+B/B
	V4dt4oS5YvfW6DBGWYEH0bB9ISjCOuOKAihjspYK3U4ax0Ayz8MyP21GSyjN7U508dkeQS3PXWT5Q
	cXmdcXVB+YEchzLW48T8VmmiuA/F7MAOCH7xJqXrRovW8SVx4GuCN3Zfm2BzThIdN2mQNpNkUiSzR
	HpINnN9VYuAD6OTiC8HdG8MPN9JPiqzMh5aJ1+T/Alv0FwmfjJe7px4V0aKU+sSBZCVFsgWGA+W/Q
	AZ8kxu1lkrT9l1tryDnJ05ak/J6cSF4OXQfkzeqY9MrUPYpb/7vejUtpxzYAJaD5ckMMv1k8Eoyr/
	GofKVPM5lBbmAqo/FadSgWPF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wI5Ca-000000050XN-2pCA;
	Wed, 29 Apr 2026 13:43:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/2] smb: smbdirect: symbol export and header cleanups
Date: Wed, 29 Apr 2026 15:43:34 +0200
Message-ID: <cover.1777463800.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

as suggested by Christoph here:
https://lore.kernel.org/linux-cifs/aehrPuY60VMcYGU8@infradead.org/

I've moved to use DEFAULT_SYMBOL_NAMESPACE and EXPORT_SYMBOL_GPL
for the smbdirect symbols. This actually fixes a problem
with out of tree builds.

And I've created a include/linux/smbdirect.h
which also make out of tree builds for cifs.ko
and ksmbd.ko easier.

Stefan Metzmacher (2):
  smb: smbdirect: make use of DEFAULT_SYMBOL_NAMESPACE and
    EXPORT_SYMBOL_GPL
  smb: smbdirect: introduce and use include/linux/smbdirect.h

 MAINTAINERS                                   |  1 +
 fs/smb/client/smbdirect.c                     |  3 +-
 fs/smb/client/smbdirect.h                     |  2 +-
 fs/smb/server/transport_rdma.c                |  3 +-
 fs/smb/server/transport_rdma.h                |  2 +-
 fs/smb/smbdirect/accept.c                     |  2 +-
 fs/smb/smbdirect/connect.c                    |  4 +-
 fs/smb/smbdirect/connection.c                 | 16 +++---
 fs/smb/smbdirect/debug.c                      |  2 +-
 fs/smb/smbdirect/devices.c                    |  2 +-
 fs/smb/smbdirect/internal.h                   |  4 +-
 fs/smb/smbdirect/listen.c                     |  2 +-
 fs/smb/smbdirect/mr.c                         |  6 +--
 fs/smb/smbdirect/rw.c                         |  2 +-
 fs/smb/smbdirect/smbdirect.h                  | 52 -------------------
 fs/smb/smbdirect/socket.c                     | 20 +++----
 .../public.h => include/linux/smbdirect.h     | 52 ++++++++++++++++---
 17 files changed, 82 insertions(+), 93 deletions(-)
 delete mode 100644 fs/smb/smbdirect/smbdirect.h
 rename fs/smb/smbdirect/public.h => include/linux/smbdirect.h (76%)

-- 
2.43.0

