Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30857233D85
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154688; cv=none; b=U3zIOl2rCFH2fR1K+/lCow5eU1f6ZbAUxoN2ifuP+3wmx/QQG7i1mxHlACtTgBXJDl30EIMzMdXpJSLi1LW9igJafDbe+Nmuo3YBbaXFY8g8M58AQS6pnSUmpanjGTvAfl6WgmOuu/GLwS5PPsH7tmWT49lcodSU2W2OSB+nxW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154688; c=relaxed/simple;
	bh=wGhfdigQQFZ/0o4rYisr9KxTIOEQzmPUJx6KzjR4vlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWgYlEVQHvWP+y+ww5YetWuUKKofocpaa1lUjuqtqBxereVKySapPHrXHOOE/YKouR/I4ZCVQ+6H8S66ND2Wzjg6WJj14+xczLgLm5jyZlZumbZ1mhCyB2/7xKDhaz/Cz8ua9zmeE7uOvuY+c69Ti9BSB+BtYFjRjnkuXB5YuYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Ek5EZnhw; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ek5EZnhw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=07DSEBWos/y6qzcwAU4kkABmbcVJKOtYqHBnQeYT+JE=; b=Ek5EZnhwZ6/7rOd/LQk9mATqwM
	uTDSk+6Jbu7TpHk7bf7xDwN50qyIC8buyuMawu9Mi08hbCxB7U+0feS8+Sz/7WD7h8EPZO6TOw4Ni
	dKswZKEWxNAoiFteW9eLiBSnBokww24Fd3j6jyJ55f2BijUFyEYfeFNE+bVt0VKIA6PvfyZLOWfus
	FwZzDGTXp7uYF6Tao4vA7j8L7cfKctAOSn4qpzXT0YHeysW8+y372JO84ZblS99IftZC+A6+SLnQk
	LKL1F8G2kuNrhrzYLurtIJ2dMMxcIl7xz1Hl+v3FyNWT1RWBoP75hbUOxIsa5yNZIoGF9qoJuEPeC
	QN6BmZdpCZIECacEmg5zwymkWSWJCJpZQwGs+xybSqhNo1nyEGst8SfpAU8S4JeCDJI7frVT0F+o8
	kctqFMxgoxjMEr2h+ICPuCa8zVzafZcr8u0ej/4SNGdbFuonBG+WVcvqBr6+FHBqEX3IqwAO23xmI
	jUaffQORl+Nv8JtpTnzhNHGN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe3W-000jho-2R;
	Mon, 25 Aug 2025 20:44:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 017/142] smb: smbdirect: introduce smbdirect_socket_parameters.max_frmr_depth
Date: Mon, 25 Aug 2025 22:39:38 +0200
Message-ID: <268c6376965096bf8b2303aaea91df616ebf3239.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by the client...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index c3274bbb3c02..05cc6a9d0ccd 100644
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -36,6 +36,7 @@ struct smbdirect_socket_parameters {
 	__u32 max_recv_size;
 	__u32 max_fragmented_recv_size;
 	__u32 max_read_write_size;
+	__u32 max_frmr_depth;
 	__u32 keepalive_interval_msec;
 	__u32 keepalive_timeout_msec;
 } __packed;
-- 
2.43.0

