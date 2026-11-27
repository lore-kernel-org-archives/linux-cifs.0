Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797650;
	b=ShqN2ERC+GJ0bPp9YLerBnfCcBxz9mtFLnYj/7rQppkqp4w6FgisQvADc1oS2yTMeqm0
	 bNe8fQd2rucPxfgTpqMh3fQ8UsmnvjMooHUDEY5K0r33w98ym7OPx0eZXgiNYglJ8gqSM
	 XAME1cQXdB/jvSZ9jIeRXRVGZ1Uw/KYHZHEMsDl8xNM2Iu6mpVBNH4byiLmnUoCflPvXr
	 D/WFfxb3xVIoBPqysKYaMTfOyXRoTfGBAhqNPNha8K+Tkgt0vz9dLHKxBkvtpvzFL2hhB
	 VEknQOtptX/QpL2R5/YN1hD3rnikiGBfnWqwynVoNKV2YLSL8lcU4DhoAgzLUhMQ4kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797650;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gO1amLFICKE2WSedMd5rkghZaJ5DeTXXa/aoHnoVbE8=;
	b=O9bmU2yeyiCnKvJM63QTTYw2M9Q8XUk7JM5UfZANU+JykPAxMbSCG4apW856KBdjrZ/C
	 Xqwknzly/gbWSLYaVj5WvEX8CWmuW1XJCG6vnn4CLkA9VZzXlXAUYnMfaUtQnA7wQx3aD
	 NZXCwsuovi6FAONO5gjty+cbXtTYugDLS4sIkC4tHW/R+FrX5Sh2fg5xJpv6BMI3pb5zS
	 arYEB1ZWOqSAEkK/0roD6VXCEWM6V9PuNBHrL6ZBm9f/w6CSEJsWrzeJpjsJSQEzhuWeO
	 WThHp+6lm2j9Q9/ZE7Xm1K84OW0veqZ+CaAo+VY9nbHXhIxMo8+jBxbHavDgB5btiWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=H2S9Uvwv;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42003606A33E;
	Fri, 27 Nov 2026 16:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42003606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=H2S9Uvwv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=gO1amLFICKE2WSedMd5rkghZaJ5DeTXXa/aoHnoVbE8=; b=H2S9Uvwv3QKXLkNoo7Uqe/cx+w
	hRG1vX2e1bdaTcIc8IwLcPeDOt4C3gmeK19I5A/MGS3JpX4NYHTBKmbx1DyYieMTlXjd+WMB4gObx
	/jFAuU6bF3FiVKW8z3FrEpXxh5ALGl/BSR3TYJPew3lWdoGhRdU0AaiEjyBnk+EFvD2jJ5Xa9bw5x
	t5GNB5lAngyqcBSeOpmYyiipwuzvdFp1sZCr39+eZ8iJN2XNTCPGszaf8o1haRDy5YmMrfEG+6qKw
	Tnr3QO6HKcHxUMsTcr4iJf8FIdVUsznMCOxkH1aEmKlpoRgryBmfFtPso6lKAsyVYQXVxQDmadUdJ
	Cg25TJiKP12qlvSTN2ZgN6cEwVNTzXPx1YWJN78KgA60d9CVvcnWnsTwdV3wHtLxsvwFmECT8M50/
	vGX1DhAzrbAkikzuFEP+Wkfli/bLQwyfE615YpP2JGIkwjuQuyR3DWuHZ8/UK0pUfWntxcUtTGphv
	tkfVB/gtPPRCxCIP9kSl9+a8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz08-00000001Pv4-1Obg;
	Fri, 27 Nov 2026 16:40:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Sashiko <sashiko-bot+sashiko@kernel.org>
Subject: [PATCH v2 01/13] smb: smbdirect: don't register MRs on a torn-down connection
Date: Fri, 27 Nov 2026 17:40:20 +0100
Message-ID: <fa09dd8d61bf840afa0ee56368c16eb0731afef2.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
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

If smbdirect_connection_destroy_mr_list() got mr->mutex first, it
already disabled the mr, detached it from the socket and dropped its
reference. Then only our reference is dropped, without setting
mr->state to SMBDIRECT_MR_ERROR, otherwise the final kref_put() would
call smbdirect_mr_io_disable_locked() again with mr->socket == NULL.

An IB_WR_REG_MR posted after smbdirect_socket_destroy() drained the QP
can still complete after smbdirect_connection_destroy_mr_list(), that
is fixed by "smb: smbdirect: don't let MR work requests miss the QP
drain".

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
 fs/smb/smbdirect/mr.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 15c6363a2f97..af613a7405e7 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -295,6 +295,31 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
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
+	 * ib_post_send() below.
+	 *
+	 * If the teardown already disabled this mr, it also detached it
+	 * from the socket and dropped its reference, so we only drop
+	 * ours, without changing mr->state or touching sc. Otherwise the
+	 * status is no longer CONNECTED once the teardown started, so
+	 * bail out.
+	 */
+	if (mr->state == SMBDIRECT_MR_DISABLED)
+		goto put_kref;
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		ret = -ECONNABORTED;
+		goto dma_map_error;
+	}
+
 	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
 		"num_pages=%u count=%zu depth=%u\n",
 		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
@@ -363,6 +388,7 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 
 	smbdirect_socket_schedule_cleanup(sc, ret);
 
+put_kref:
 	/*
 	 * smbdirect_connection_get_mr_io() gave us a reference
 	 * via kref_get(&mr->kref), we need to remove it again
-- 
2.43.0

