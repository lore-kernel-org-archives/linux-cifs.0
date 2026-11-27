Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782570;
	b=MJhctyhs5A1CVWOIWKK8Xm/Ckfz1wBcvW51HaLRNYSLrJjoZa+J+ijxppOdWdJWOyjY5
	 fNVOLTf5JchxW5T8lpozqCl3MYRiaJ8kpLDEnetK1LgNzcmxVR0tuA9n/4d1JeM0niGDX
	 5ah6bYYndHk1ZSV7+61Lajf8raCumPhRoF7XGYqfBKkyYj+0SSNSbe34YZzOBKiY4RHR6
	 DI0zjlNUm4lVDcRbZ2C2Ibbf+p3py6jq+yH+89QcOTrMZCk92bLkCuJYVLJKE7lUvxhHN
	 Zriwy86ihCYfPtYwW4POYwypWeKPnEbtcs5wtwCBip5dxZhLOCBg2T4qtRVx9VGGnRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782570;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hhCL98BTq8yTjm4zbNbKW4zScsx73edsNCUOYdINb4E=;
	b=eExEcNDDv0z6nDZk3XYhqi+/OcbmY0HSx+FE/dT4HbpT6llsodQcWmPEVD6R/OuAmjvx
	 OYBjhK0nQK1+81zNj/EDZg2fWWQ3is2Frze+M4aSv/kVukunshiEjqaIjFHfdNLLKnGjS
	 0C/cf87ObyjWmvqZ6oV2JE56UBdkvYfsyVA9lfs6n8klyxrG9a5J4YcvDRH2hvbviC7iq
	 1oMCSFihFvv24gCm1F7pEnqF426C5gxxU3Pny+u2DL/3DpyxSmjVzegC7MmkTmA7x4sM2
	 W0C8Rc2RzmXNQEYeuwB7kIpmclBip1nwuN/M7yBx30I+rrI4gYmmnuuBrkuaD1PrfLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b="zd/rSDsN";
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85714606A32D;
	Fri, 27 Nov 2026 12:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85714606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=zd/rSDsN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hhCL98BTq8yTjm4zbNbKW4zScsx73edsNCUOYdINb4E=; b=zd/rSDsNiQFKIR6p+tdT5zYZ6o
	zVde1FGKzvh3ppL/VWibbFmJJanxC/w3P2cdvmYtKvmmGAPl6GuSMLVyL5/gRc2t8JjfdoUfGrv2M
	Xcd3iXHVT6RUqFuHCuEcH+49/OJPn9MRZurVbulZw+F8eP590S6xmnWGVvywuiHMhc+XKknlQjES0
	pIKC6wTQMP3TepFBsKBES0fRgJK7CnezQ9dSh2bcZfKQS/MS2I1reSHAXP+xu9DkSsHGh/VPwc9+S
	BWPqV/YETpGC6w7Kc+LVPU9tIyk7xMXWSk0/n0lyTskLAhx2STqbXxsVtKSVEGAfDeA3vT5PQHCuS
	HjJWcL5ElH52XeFCTGY9BH6SDq0kgQ3EloUj2VU7CdFo3VchixpH7hhUraGdF5q1Eogym2CMOBvmM
	VWr+Fd0vmW9I18jJTfGQm3NhNZ63HMaIviOThEJ7Zzn35nqnM8+u4xzltuzDL7DPKscs8/oQ7850C
	aIhcti65AyEJPS1V+KrER+h/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv4w-00000001LZp-2yWN;
	Fri, 27 Nov 2026 12:29:26 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Sashiko <sashiko-bot+sashiko@kernel.org>
Subject: [PATCH 01/10] smb: smbdirect: don't register MRs on a torn-down connection
Date: Fri, 27 Nov 2026 13:28:58 +0100
Message-ID: <3c99d454d41eba7f96e784ca653b0c728c6b8b96.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
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

smbdirect_connection_register_mr_io() took an mr from
smbdirect_connection_get_mr_io() (which checks the status while the
connection is still connected), then dropped out to acquire mr->mutex
and only afterwards touched mr->mr and sc->ib.qp via ib_map_mr_sg()
and ib_post_send().

A concurrent smbdirect_socket_release() can tear the connection down in
that window: smbdirect_connection_destroy_mr_list() disables the mr
(mr->mr = NULL) and smbdirect_connection_destroy_qp() zeroes
sc->ib.qp. The I/O thread would then dereference the NULL mr->mr /
sc->ib.qp. Keeping the memory of the socket alive doesn't keep the
connection connected, so this race is reachable.

Re-check sc->status under mr->mutex before using the mr. While we hold
mr->mutex and the status is still CONNECTED,
smbdirect_connection_destroy_mr_list() - which runs before
smbdirect_connection_destroy_qp() - blocks on this mutex, so the QP
can't be destroyed under the ib_post_send() below; if the teardown got
there first, the status is no longer CONNECTED and we bail out via the
existing error path.

The similar unlocked sc->ib.qp access in
smbdirect_connection_post_send_wr() is fixed by "smb: smbdirect: don't
post sends on a torn-down connection".

Fixes: de5ef8ec3c46 ("smb: smbdirect: introduce smbdirect_mr.c with client mr code")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/mr.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 15c6363a2f97..20620fb043bd 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -295,6 +295,25 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	mr->sgt.nents = 0;
 	mr->sgt.orig_nents = 0;
 
+	/*
+	 * smbdirect_connection_get_mr_io() returned this mr while the
+	 * connection was still connected, but smbdirect_socket_release()
+	 * may have started tearing it down since then. Re-check under
+	 * mr->mutex before touching mr->mr and sc->ib.qp below.
+	 *
+	 * While we hold mr->mutex and the status is still CONNECTED,
+	 * smbdirect_connection_destroy_mr_list() (which runs before
+	 * smbdirect_connection_destroy_qp() zeroes sc->ib.qp) blocks on
+	 * this mutex, so the QP can't be destroyed under the
+	 * ib_post_send() below. If the teardown already disabled this mr,
+	 * the status is no longer CONNECTED and mr->mr would be NULL, so
+	 * bail out.
+	 */
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		ret = -ECONNABORTED;
+		goto dma_map_error;
+	}
+
 	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
 		"num_pages=%u count=%zu depth=%u\n",
 		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
-- 
2.43.0

