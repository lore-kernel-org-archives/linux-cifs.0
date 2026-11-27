Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797721;
	b=LMW5c/XmFu62+YiZlo/aijJ+AqCPn45FDv2e3DdukMeenP/b7Gm0u6Kj60WzFpfGyhAO
	 05fX6oI/RsAOGeePEFb8637X0Eab2qdL/5twnkOsToUnb5k85FRtjuCYofgasL0w1u1R1
	 NAEnwB6zPdJ8vV3tUdn6+3pCWpVLT7TxHrtWlTc8VNWdqf/03LmgvCITMcrEEa58CVTf8
	 icW9KJra/LQWwXXOw/1A962m2qdTBcH7xQaHBmySMAmvpBKtEuXDJNEH6IWQubK5+Fq4R
	 FGfgYbQJrcG31VAy5PpDUj1F1jAALYtc0XYtKOQOJHZxIrQpxt+EWs1o35KIxtkou3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797721;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ncQQlWeM4VgWwcnSMChsXbUpUMCE8+ZfA4Ko9AgAfIU=;
	b=flxdu6Pw55D7sRFDaibtMZB/SpWFvHp+YMA+GujL7ydXTrYtpRNyB8DQFr4kRX8cCAfy
	 xhMS3yJpNohZIOwlMV+fI4900h7dl+JFP5sds2Oxkexw99GyiIvAtuzQLFZHMXHUUPk4q
	 Hnfq+OAE/sMUo9n36F+DbRHoaWDsAQfVc5BbJMBRZkjeJTFY9aqXcGsCliGD8TYKqHACy
	 rZ2BeW01noKAi6rKZ9ML1i4M1/DJSGpBCvrPcWYzlWnY7MooG2HKG2GkwO6rkMBqlznir
	 VPhDJmeaEfTdiOkV3D46zPpIUAN+DzvlWPM3r1TfN0nLHYdjxBx1MU6IRhEWvgD+nRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=ycc5iojd;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1627C606A31C;
	Fri, 27 Nov 2026 16:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1627C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=ycc5iojd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ncQQlWeM4VgWwcnSMChsXbUpUMCE8+ZfA4Ko9AgAfIU=; b=ycc5iojdzoP0oTo19OTNUy8UF+
	jFcdl7vBAo/fO5lHvjyXYtFK01MU79qARBmT9O0Ftu05eCEMQoXMQCI08gbe/KEbkR6oV6CRQCk9f
	VdpP9Tdrg4zpVTRYg3W4axSHVlmU4rwEruYdiZWnlKHdkrHcSYRhJ80DPVnMnb6y1xi6PJ1hAvfdV
	cu4rdWBxcvO3/B4wjX+/MJsMWxnMPiA2BwkRydSknZ7EfSfX506JP++9+BE2GxHZJGIUGPse4/CD1
	3ch74+sTbn/U9QppiD+L1ijEZiR9St4/50ljy60RjVvkzvGc2bopspfRzi/crN1yIH7TI0J1o0Elv
	fmt4QIV8H+3HKWczt/oFuTJ27T4W/OnwufRPG8zh5IPygcR+umrb0syvNxpb1G4fBpj0zu9iTWJWt
	UqIrhYMdg7HmL/t3c6uBFHp67dUU/g2K+gXYQDuIiISgBtcsKAG033GbLRWcCTA26tv+SkODkzjNz
	4Kose5Aj5Q0ZUSlhyqY+jNpy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz1H-00000001Q6l-0OQl;
	Fri, 27 Nov 2026 16:41:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 13/13] smb: smbdirect: give back granted receive credits if a send fails
Date: Fri, 27 Nov 2026 17:40:32 +0100
Message-ID: <af8c6ad7af50aa5c166b7906cc2f5653a53964e2.1795794871.git.metze@samba.org>
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

smbdirect_connection_send_single_iter() moves the receive credits it
grants in the message from sc->recv_io.credits.available to
sc->recv_io.credits.count before the message is allocated, mapped and
posted. If that fails, the peer never gets the message, but the
credits stay accounted as granted, which permanently shrinks the
receive credit window of the connection.

Give them back to sc->recv_io.credits.available on the error paths.

Fixes: 54abc694ebb8 ("smb: smbdirect: introduce smbdirect_connection_send_iter() and related functions")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-27f04b17-0356-40b9-94be-b0b865fde826
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/connection.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index 837de712db65..9d054eb81d81 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -1352,6 +1352,13 @@ int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 	smbdirect_connection_free_send_io(msg);
 flush_failed:
 alloc_failed:
+	/*
+	 * The peer never got the credits we granted in this message.
+	 */
+	if (new_credits) {
+		atomic_sub(new_credits, &sc->recv_io.credits.count);
+		atomic_add(new_credits, &sc->recv_io.credits.available);
+	}
 	atomic_inc(&sc->send_io.credits.count);
 	wake_up(&sc->send_io.credits.wait_queue);
 credit_failed:
-- 
2.43.0

