Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827556;
	b=ks7ScA1RcokB26tva7Ocd/ROCYK3VVFvpj0SGz70Uoe5UBFyfcm6wxTL750NVUKtvfSP
	 5qFSvjvWTw3ujFQd3TAVhhvIGA4Vh8LQV4ln9BPsLXGqls1yVBySe62r/VnJO8OeKcTIX
	 VHywM26ThfArT8fCme7FK4cZnDVP0F++c9353+DsUHRi8XAftC1lw2Y28kBg4VDNvmLLO
	 xyW/AswfEWFAzyDKpORdTXJYBBHjJUF6pvXRR1e5M6FKM+CFusLtFWpR2VgDx0MyAtHU0
	 23mQenLU3y5HZJJ6s8qoSyuxYV/3RUvtWSfiiW7xkHtFSVD4OG5q372/MNXmkjeIw2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827556;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EoGG5JezqOoctvzDjTmDHAfEA/W071CvbYrBp09Kog0=;
	b=m2lk9kq0FnDp6o3izPGlv2Z0CrkIAVNskyMI03Jbgv1kDvFxWHxHc5UFx5YqUOtMNRVV
	 L2mqtO4Aeu9vKxOT4/HlGhOG60VthxTf1U74N6SlCmuMMtJwraFGZiddbk5WKVjaA2U7j
	 f+tXTQwKspWrHC8qcmdyCjoNwhQ5gIw9qIb3x2motaM+PRnrOSBeVGjbpmXnAHqPZ8CKS
	 dBQBxa9qHPsSD5ECl+UY9mUeCrPKGAyrgW9e7ioEq7iFBa/RmTB/NLWYcYXmYmLvD7uvg
	 LZoswhVQQ9Y3q9LimEQ4D8UkysIIPP2B61pI6G+enYeb2+VnoNdzWWcqF8qMioYyIWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=JeNucQMf;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=IZsSrTlX;
	arc=none smtp.remote-ip=202.12.124.158
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2D0606A31C
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 00:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D2D0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=JeNucQMf;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=IZsSrTlX
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6E4497A0514
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 19:59:15 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 27 Nov 2026 19:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795827554; x=1795913954; bh=EoGG5JezqOoctvzDjTmDH
	AfEA/W071CvbYrBp09Kog0=; b=JeNucQMfh8/z+3Z2B8b1TnSXnklpIIM/Luus7
	o6z4R/jgkXg6RhLOVP1FKByvSuq0sdgf0OIysk+Ynqw2XDftc2lL7GKxoKZbGzIM
	KneA6zLjIrJ5GZ88M7aFgLMOzF9vsbFoKZzTPjEXZP2xRkRU4nrMqnF0TPeC/w5V
	rBt+S5hzoZd/l2brfJ5hEGO9VXes4OOhM1u9KM/UPG3HootId7/ZSzM60j+HGQcy
	uMhPe1cAm1XhLE5dPejehlenGLUBnp3xyyFps5VAzKgNVpZVDWwuq9Vmump6HaHX
	2+JUyhRfyLSoXd/Khy1QcUkb80d4UKQUJJNuUYfEsxVn0JnLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795827554; x=1795913954; bh=EoGG5JezqOoctvzDjTmDHAfEA/W071CvbYr
	Bp09Kog0=; b=IZsSrTlXRa8p9P/TEhkPHWdZJbf9MEPm15WihkKUp5EodPKK1+s
	Tbssqc4cjgBQIhA+RbhOqAyw8elzy2Edbncd//nOEF3QcX1VSD4Ke9W7FvA37UwE
	loKuVwqjypGYhMoUjTQKX3C6DbUMVqcn3xEwCO66EWAqIpk2ZxdzfnkilLzKtTHK
	vwLoBOUR+o1uANoYptqodhdWTl+CCdpJ6aZK/4ERmxo0z9Wh7aOyODiDZHH9uWOA
	/g6E6+h5ofHx0aNpXVz2XmCzhmJ1JOeKrBhMJF45ptKX/kOPV21NwmtGTNs9x9NP
	GmWvJBvbUhmJEIZWpLWxUpZT0kKUakj1/+w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795827554; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:yxGoGM9KvjoEWNdpWC1p3jn35icFEU2NdzRlfApMVC2AeJp
	EaWV+pmrDYAhpnOE3XGpiEDRV9gP6pU8wpsgewRNXbXOuhmlmzQZIX7UplRBN6Ew
	/hdejcqNwYrjK+0/5DdAyZW31+IkD5CNRj8w/nmzYLm2UM+I/BM1vxoFjTpAZJpL
	bzR6PQQdR+egvFGvtOtC/vEZTS5FBBlZx6JbB5+U/YBMF44dE2YcreVkWNde5BEP
	sbLyuZIxMFg6LDJGnQk7jSXYr/aqTRYFGsnm2L3/xA8D4ISMz30kvYaeF6wMWiDr
	xE0Yo9o2+gXrQLHjE1lXdAP7LSRrXOpVdnCq9Sg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:sVhSfqXgyCDzxITgUoonktwH/+kv8Djq02eURlbgIz4=:jIhRGZdfhgzP/h52OVJE7rZ9POebyJq0f6sas71yeV8=;
X-ME-Sender: <xms:YicKawRpds6WQe5Ljhe6ESxCwDL98Mui7IptjOMkSoFoMAkE9TwdMQ>
    <xme:YicKa5xMLHNaZX367qqM4Nia0UvUdWRA44MwpzG-Kz_79rNKHLJdRprM9lG7Q6kZQ
    emoCu3JBOzPZLdcKiieGkhVCi5o0G7tXHjdm23PcpScKHmCFUepyQ>
X-ME-Received: <xmr:YicKawAXREFcRI4sQ4Tqrd42J6LfllfQtGy4xLtP2PqbzEBZIPOBk4KFIgSKBNNW>
X-ME-Proxy-Cause: dmFkZTGp5TyTVMSpMlehxn0m5AMoe1BoMUUA5FYia5UJnrxaWn4iHdutWfSO5R+utGRj+E
    Ql941HjJ3ZCygkkncsiihDgcsbpL67Rr/I2poMhlrJxS+rpOUIprnRs/V9hTt3wZAU26gq
    Y4ddyn4lADKM4msC0O1prt2y9hvSv4ljh9fOcrqe+C5hSf0qldeK+Z3IO72cTYbFGowHT+
    DbaoQQ1i9qNpjDRfwujnn+hGggeqS1cyxJRRkA3+hw1kOVZ4fZ/S/0X4l/FCq9j1Pw6aib
    inEONaV/kACdLJuY3RY6KulT4xCQSVEqSC4VjKEywc7ACfhIOLPTXKuy6ZuweD1axn71Vy
    JR0Hw78VK5+zNougOQbWEOMjLkAJJAc7Nk/7JGLe9MBCwighwdwkyAumiWmwrHJEGYc+7v
    43nDb27wMNzpay8BYJfzGgg+BibiKYYi0ow+xqzsGiXMQ8e2S9ymgFv3DZbH6Ojpny6Yj4
    ClYqnyXfE1rk3z3bVU35YtB2igvdqxY7rqDD8EgqBRC7ryxdBed+1zQtKAUwKY8CImBBqS
    /cVrViZp7g8j+2rXCYjS9hLaPhM8ViAEEbpz8Eu4qhJBue97IUghD+3GoUymfWQvVxES7S
    i/iv4ubNgX1lrW4/ujBugbgd2O90v5eNN3gXf7ssEPaKZiqgT8qPdyZCBFSQ
X-ME-Proxy: <xmx:YicKa1GrW122XdfGvp-MEgyeQ56rpDa0t_yoQyTqOl7IuPQSoDRw_g>
    <xmx:YicKa3OMvM8Dn7oYVOW_xdVtqmFg4jy2bI_39SU-4tbPdHvGVoBRmw>
    <xmx:YicKa27UBxuc4iZVm6alSs77HgLEARg14Xb6vOLzS9YJzkZ08BIjVw>
    <xmx:YicKa6h2GEY7zaInzH8icur3d5Qjfl7BYXAl5-80WgP4m0tiAFNWxw>
    <xmx:YicKaz63f-zEKBX2NDJJS92TIXykLOX67bdx8f3EriSJ__OrtnCmaIxa>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 19:59:13 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fail an open whose stream cannot be created
Date: Fri, 27 Nov 2026 18:59:05 -0600
Message-ID: <20261128005905.1687065-1-icb@fastmail.org>
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

When smb2_set_stream_name_xattr() cannot store the xattr of a new named
stream, it logs the error and returns success. The open then succeeds
with FILE_CREATED, although the stream does not exist. This happens,
for example, when the caller cannot write the file. Return the error
so that the open fails instead of reporting a stream that was never
created.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Tested on ksmbd-for-next b9eab18ab72e with KASAN. A user created a
named stream on another user's file that the user could only read. On
the base the open succeeded with no stream. With the patch it fails
with STATUS_ACCESS_DENIED. The same holds for a new stream on an
immutable file, where storing the xattr fails with -EPERM. A stream on
the user's own file is still created. smbtorture gives the same results
as on the base.

This patch was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f286f9818643..3eb275a2ed5e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3751,10 +3751,12 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EACCES;
 
 	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, true);
-	if (rc < 0)
+	if (rc < 0) {
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
-	else
-		*created = true;
+		/* smb2_open() reports -EPERM as a sharing violation */
+		return rc == -EPERM ? -EACCES : rc;
+	}
+	*created = true;
 	return 0;
 }
 

base-commit: b9eab18ab72ec25abf431cba58e5239f695632f7
-- 
2.47.3

