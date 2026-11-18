Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017504;
	b=Jxb/Otbq4ZCVcimWAlXvfQ8coBP7G0nzl2PcUQfg3VCyzbLqHphjbvmu9aqisv/8lgO6
	 EaYw54hia9uperBTefaX0BPXgMNqW+/m6lVUg3u1z8OaAMx4v1PDkrFHq3JTEiQBGYl2J
	 jjhF2p/Bw6rAfy9cbsPX/t9dX2Xp+wPuVOCTm+eKdPjTPlU1yqyWHV3Y4gEP5O9e+yF/s
	 SnHZ8y7Tm+9D/hIryjR5HcnRsMZsvA6guSINCs7Gonh41EG2TbthB7k/V1hBDz4xAoni7
	 IWypY9NQ4iI3Qn1gl41v9x71hVTGjmuaVYB2mC/IHqUO0ClBL9AVKOaCE0JQH3TTR1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017504;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tmZ+lh9571Vlds0QrPGYojBFXpoxRFH+tRyrL8fP1OU=;
	b=2VKz/hM2b2ypTT+g3bT3NQNzbFVPilLID4LpcvfR1sdskSHa1UtujGZ2B6CXjgl4Fj06
	 fBrPZB3GKtKxdh8OTzZODKZ78wzN0Hck6U4jXJckweyJg6HJwfymlU30fsA/BKUmtigLs
	 ukoKTQ4UZy+jzz3QKxhEjqEBh1eirew3mAwpcucr5bEwCUyv9999NDN/HBXJCE5mr0mj7
	 jvOT44v8pRjKcNLNiVEouks1t6Jc9nMRkMSXZjQhJolqerSG/2hf/K/JRf5cQ3WyW05Yt
	 JQaDlgXX0N/BNWcmdeRDCVF5L15cspP5RgR2SVmSeYG9fs+8AgVbiYQ0bFQtmAMOLZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Dlty34gy;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=hSlAucXp;
	arc=none smtp.remote-ip=103.168.172.159
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170BD606A333
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 15:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 170BD606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Dlty34gy;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=hSlAucXp
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 487BC1400150
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 10:58:23 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 18 Nov 2026 10:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795017503; x=1795103903; bh=tmZ+lh9571Vlds0QrPGYo
	jBFXpoxRFH+tRyrL8fP1OU=; b=Dlty34gyQGVwU87TR76947oQbDCUp7yuExtX1
	FjnTnexKQRfue9T+V8ruvh3xYbyOAvCwIies5b7hgkeK5ZeofFmRMNG1o19x627I
	Iluu1R3mgHKSHvpBkjTbjHmjHo0pYD8Wh0cCcJo6g+Jt/DbLjUCCn5J49g9PMBCq
	PCEZclYamR3sioeDX7JMXbSTW0KFKm7wmTLFRANifiqesZLYrY21s/ACkapQG+eF
	H6eO7LcVAzK8UqrH+01Ast/Vm95n94nf4LN61AYd7Lnn7+vjmX/99dj0sJyNBHD6
	lhmgSsIrdqHFJw7351rYSb30Ry3L0/NJPcv129srJW7HW+hLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795017503; x=1795103903; bh=tmZ+lh9571Vlds0QrPGYojBFXpoxRFH+tRy
	rL8fP1OU=; b=hSlAucXpmZpVTVfs92zqpc+dMhI/TfzbRGwTxtu/1DRq2SApsM3
	VxtcaY4uEmsE8CBgNoGCW0VSMLGkry4eaoNdDznlG6i5Fj4N0uhnLhwvfArYX3qq
	gluJfRPb9cSHexGFrJ2o70xxoEbTiaBKqCHLaHo8GezJDmNsIeFotc9IlEHLihuV
	8Gr94jPEzaa1C8/YXH7XCueTLxjTHYiQMHve2h66MrLobwfychy1fkkSsh2C/Zo4
	RAX9AZJMqWf0TeKBwsAKzVs/qgwjvdbylt+/wD7UN2chjecfuM9y3ONivnPdWxgW
	5PbEzIAbYtLxDQs5GpuW674RxU95vRC/jPg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795017503; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:0oC/xAiXQrCaIMoeuHy+uBssBH47UgnmtCWc2ikJCocxrSL
	Abu6GpQHvP0mIMkHM9aarjV9Z+BenbccnhZ4/Yd5tJk2zDKkrMmubkOC16xZ6Ifi
	slbbUZZEeJ68baqgv9E8p1nUhANOxy6NnYmkJuBfg4mrdy9TmhSyR0Vipt6IBEU5
	2DPNBvNIjixW/ouLXzQJe00vCbg62Kl8IHOkvW+H7lAhF7M5ow43fhAm6RHJLX6v
	5wABIAA+UKFU7TYVs3KQXmwWq9foWTo0JJWDBO4AY0adE9b0feV+3/eUwVEk2L6R
	Vb1qUCX5aI3n2rbcCqpviJcAW+ax3FRYWorFXcQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:LO/ETnXj2HgP0r2HrilzaIGma0kHzcTarKoIJkjwxFw=:DQ8eEkJ3zSz2wDEhZ5nPp3BPh92NGDBGTnEfeREFXx4=;
X-ME-Sender: <xms:H8v9as5dOGH3WV4cRdqCQp6XUYhvRFlANVpMYEuYcLxIPnobxSoVYA>
    <xme:H8v9auly3rXVgz3f66I9msrM5nHqGALa_-XdiEJQTVQnB81Qj3P9Pa8ceaeJmxgic
    44o0wTjRqU_VONUdfFsRy3L5QXHMlaf7nli3fb_vKz30ozJr5JNBD0f>
X-ME-Received: <xmr:H8v9apoXdY8JrTReB4aQ0vA_KKpQZZwXWqrMFgB6iTh8z2dGvZ1MEx1J9S7a2Z2Q>
X-ME-Proxy-Cause: dmFkZTEUNiVHQkD/tEk2Vljs5KgjTZfSUXf8g4zJ0Q3MSLZSMiiKW69CG49nC3D1ntDard
    5FWKTKns2qDfRmw/AJnhYvjPhZ8LANOGSyoiyThOh8rek7RCJmpvd3IKjsHdwZglEdVNnl
    Y97kNcDIj9R0QgJ6F8swyVKidsMU+K00GnTQyhF18/5Lb+nY+WkcQVQI2g/8S8HaBTTbZP
    5i8a9QgS88W75rzx2dwpIjZ9F8edlgdZ+J9yMRth8Q/ZZUVGOLS05aIH3DSma7cTZ+01nK
    37E0XByGtTPe5/dOLTzRaa6YlEo0Ifc1bnpH7A4BTl1LG88IptCcJ+Q+fQCALUkqgG2RWO
    Q3z5s9kPyGZshShEfAEHbEff3tgiy9umtTKkYYYilCSvoEcpLZyahsIibSRpm3HL4gbcxu
    tsb5wJfzTlhjWr/ScsoMU5owVWjB8Eh6yXPn6pKDeR4GGbOyBD8o00/RCpucXs5minKm8G
    ZP3kLgDsSo0JHaL7cvvBXi/is0cidKLcgp5IT/Dyni8P7QuzB/BBwOu3GiJ0yjNjzBQkC0
    b1P/UUz4V/tYf2D0TDJKRmWpNA+iO1CHLejDMKHD70Ikl5qgi2IkS5oc9OuPU5EESpiYxK
    6jPa5p3YDMkahJ0mx5Tpsr2a4D/ebO80IDDHTj8mgxvNMJ/C99tKa3hFX3Gw
X-ME-Proxy: <xmx:H8v9alvIVOiJy74i0aez9E0gOrkzyMdFRYpTeA6gKaxD3wgtNhdiVA>
    <xmx:H8v9amFs2SmPLpGQPq0_SIdaUGPEJp_tmaWEdphvPy9DzHz3aIJsxw>
    <xmx:H8v9amZGx75imP5sDSES-ln9TrCXkDNoTW_HbjE0EpREklWUTilgrA>
    <xmx:H8v9amVbrTFRC29P5BrjDLNPBLUvakO2CP1bDiYIXJMbIczNPtCDdA>
    <xmx:H8v9aoeWSobY2k4SFY892Q30Nm71kZX8lewhIpgqnNWYDnNO0UKP6iUX>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Nov 2026 10:58:22 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: rate limit the log for a failed security descriptor store
Date: Wed, 18 Nov 2026 09:58:18 -0600
Message-ID: <20261118155818.70792-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
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

ksmbd_vfs_set_sd_xattr() logs every failed store with pr_err(), with no
rate limit and without the file name. A client can make the store fail
at will. It only has to send a descriptor larger than the xattr space
the filesystem has for the file. On the ext4 filesystem with 4 KiB
blocks used in testing, a DACL of 86 ACEs was already too large. Each
SET_INFO or CREATE that carries such a DACL then writes an error line
to the kernel log.

When smb2_open() stores the default security descriptor of a new file,
it logs the same failure a second time.

Log the failure with pr_warn_ratelimited() and include the file name.
Drop the second message in smb2_open().

Signed-off-by: Ian Bridges <icb@fastmail.org>
---

smb2_open() also logged two early returns of ksmbd_vfs_set_sd_xattr()
that the new message does not cover. One is a length shorter than the
descriptor header. That cannot happen here, because smb2_open() builds
the descriptor itself. The other is a failed copy of the descriptor,
which this path no longer logs. Callers do not usually log allocation
failures, so the patch adds no message for it.

Tested on ksmbd-for-next 267029b35ad1 with KASAN. A run of forty
SET_INFOs whose DACL does not fit now logs the first ten failures and
reports the rest as suppressed. Each line names the file. smb2_open()
no longer logs the failure a second time. smbtorture results match the
base.

This patch was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 10 ++--------
 fs/smb/server/vfs.c     |  3 ++-
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 29750970f8da..987049a52e54 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5271,15 +5271,9 @@ int smb2_open(struct ksmbd_work *work)
 						goto err_out;
 					}
 
-					rc = ksmbd_vfs_set_sd_xattr(conn,
-								    idmap,
-								    &path,
-								    pntsd,
-								    pntsd_size);
+					ksmbd_vfs_set_sd_xattr(conn, idmap, &path,
+							       pntsd, pntsd_size);
 					kvfree(pntsd);
-					if (rc)
-						pr_err("failed to store ntacl in xattr : %d\n",
-						       rc);
 				}
 			}
 		}
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 83b0bf783886..39bbe6aad629 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1767,7 +1767,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 				XATTR_NAME_SD, sd_ndr.data,
 				sd_ndr.offset, 0, true);
 	if (rc < 0)
-		pr_err("Failed to store XATTR ntacl :%d\n", rc);
+		pr_warn_ratelimited("failed to store the security descriptor of %pd: %d\n",
+				    dentry, rc);
 
 out:
 	kfree(sd_ndr.data);
-- 
2.47.3

