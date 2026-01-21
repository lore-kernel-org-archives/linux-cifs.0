Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE64366DB4;
	Wed, 21 Jan 2026 19:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025064; cv=none; b=uDderhsfPJQCjspldP1e/FY40zKgO5GWag/2HQBXBAfglwaDSVTUt0PgrPzLNONeYkBCPzSPwM2yY6f2rNeSdnTI7hJbS9Zb+d8r3DzpkYZ+RDrS+PVINJ7NLSNR5f94LHjfkX490kC7NTlFFY8+2sYI/lQo7wP/4DmBLvyRFuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025064; c=relaxed/simple;
	bh=Pemh6rlGGV9lkxUPKKC9yBPCa/gHohfxJNa19OdMp8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHm+PqbB9Lg3ZsOFCrB8Y5OV5ihxNWkIkRb78gJfy56vDmi03HYLRiBIDjEoPCtz6BtLTdo4+MB62j0MSDKJ254ZE/uhjLd4vLn/9CTja+rc9SyanU69kvAAJmVq4hfcDu2xKeUYw3bNBJCvxyxY94NQvfv9pOqcq103ep/UMeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PRy4ZUNf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PRy4ZUNf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=QMaKCo9jK007YuWfsvuB0Dm5RGJe1N+wLPeQMaZO+vI=; b=PRy4ZUNfMemMONK4jFfOL5eecB
	TNsjJ0XRSAFO/L07QQsVYv42IKXPqmv/pc3F3T/kyFGFKdfV7gjMLH+oFdoawAoY57n9tDFNWwQ0d
	DqutPfpALdEOp8oFhcvZzc9eXhzDWpVPUOcE8opnaEO9dkhuhf+Rm8RfxlzyaJpwNVqtPNx/5lM72
	CUvJnAPpaIZ2Yb8EcOn6GMTyidgtvZDa3/QFsrdSRQgEgeUb0k7CTWKR+sCbNSMl5sl9/44Fp85hT
	XzrMUHsJmRQKoujo7cWU86pWPBJHSJMcdc1fWZzxTvSOOiJnvifotdr2kYRLx3YVuvE2EbfsXlXmH
	ie8WthdyyQM23EcmxplSlyVBT7L9Js/Kd7oKF7JqPwdPsmpyb8Fx++A4OmQ+sNK1jVbRMlgPUqEYV
	wl8sH5IcaPOUnZiqn4npMdIAFZpy34xslGJLzYqHCh5yoLylhyQRbvyYS901qlUA7la3DDnwO0djj
	+y3hf8bqoPudjQp6GtrnRyUE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEA-00000001dye-3Wjg;
	Wed, 21 Jan 2026 19:50:54 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 01/19] smb: smbdirect: introduce smbdirect_socket.recv_io.credits.available
Date: Wed, 21 Jan 2026 20:50:11 +0100
Message-ID: <1f60cea1eae937938070f66f1b8343107a1155fd.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The logic off managing recv credits by counting posted recv_io and
granted credits is racy.

That's because the peer might already consumed a credit,
but between receiving the incoming recv at the hardware
and processing the completion in the 'recv_done' functions
we likely have a window where we grant credits, which
don't really exist.

So we better have a decicated counter for the
available credits, which will be incremented
when we posted new recv buffers and drained when
we grant the credits to the peer.

Fixes: 5fb9b459b368 ("smb: client: count the number of posted recv_io messages in order to calculated credits")
Fixes: 89b021a72663 ("smb: server: manage recv credits by counting posted recv_io and granted credits")
Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ee4c2726771a..403a8b2cd30e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -239,6 +239,7 @@ struct smbdirect_socket {
 		 */
 		struct {
 			u16 target;
+			atomic_t available;
 			atomic_t count;
 		} credits;
 
@@ -387,6 +388,7 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_WORK(&sc->recv_io.posted.refill_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 
+	atomic_set(&sc->recv_io.credits.available, 0);
 	atomic_set(&sc->recv_io.credits.count, 0);
 
 	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);
-- 
2.43.0

