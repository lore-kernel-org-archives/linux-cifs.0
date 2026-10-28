Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201700;
	b=DBzmQSDhr21XhMKNp+5KDUyACbfoTG+8asZfpDKaKvYqXLqNE6Y9g3O9cd34dzrEsiGO
	 HFVUpvI8V9+bhrH+v54sg+TV4hYh5Hs8Qb/5FbIdlW/0qGNWeY9YCtf0GeKOL4RQLRM0e
	 TfYUNSvxD+M8eVwjjKOoqiA5fLK+poXmcFjUoahP4gGPHpmpz8Dxww4FktBXm/CpA4tl/
	 Vro80ZsOGTHb5O+xzNubrgNx/3uCq/F+VJzfOJWJw81L/vBcoXu34oLQMPJqlsy8j88yX
	 pcZAPmEA8fReqGYpXfMW9sqkL1QX573sH6j9zg7uVNs9+7UeL377sx6e7X4b8kFkEbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201700;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f+sh3eLCEJjsdZNca9JJWno3mJYy344nLRxVP4YWReQ=;
	b=y0PQyovQTV57y6SsPQfLNOzhWEekMomXiV8BTxv3ImwWfO4SxGmF49q6HZ8vZ7HwNevb
	 WeByRq/t+E8T3VWwqXHEkQOoNUDNLtDwKdPkfJIgnZkKB0OdtSdLc+aT7MtjpPTpHPeOO
	 7F/ppjgPjzYzn7mPywB1Uguqz7UYqJyi9mDg6INjHONZbyYQrPQsv8v6Eg5V0bF88/IUR
	 a5wAChB/uMDsv/3iuVcv+ujfWfRnrplD7B0Cr+2ChIlIChRn3xyrxz1psiWU1Eu8s2qeM
	 p4n2jyW0hS3KpiKH0TBel/1+JtmXnnM2WzQVWXQl8UbBYTTb+t8giQJH25x8CqEB+sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=nYMUyrZ0;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=LJS09rJf;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4C7606A31D
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 15:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D4C7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=nYMUyrZ0;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=LJS09rJf
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A45BB14000ED
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 11:34:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 28 Oct 2026 11:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793201698; x=1793288098; bh=f+sh3eLCEJjsdZNca9JJW
	no3mJYy344nLRxVP4YWReQ=; b=nYMUyrZ0k6YIBTVLXIYWNQ48ITsEAFdm2ebWw
	mR98WJry2+0uYOHoBnYlqkAqtR1dyiIUk0ZCRY6vgmvSAou6/nMmqa8ChT45k/vW
	gv5OebTofBf09b9VjWPHs8xGdFHRck6bNNlCbJyYbG+tXDllcMK4u8/5O/o1KxCR
	mZiBzISLrRYGnYcUDX6KXuQK2njtHHnlFLPdjv44NGT4/N3CAHKvtaFZ0yrGFs0S
	1DgfqkzA+uVMm1urLURJVftmfj0iPKeRTvfJYAqH236PdN8ubVOhpt5bO6zy04qI
	yFPoXsZh1h/K+QyFE4KH4D99FgaO7Gk/QRE8I/20PP54vwMPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793201698; x=1793288098; bh=f+sh3eLCEJjsdZNca9JJWno3mJYy344nLRx
	VP4YWReQ=; b=LJS09rJfMo+esiAYtVJr5zaY4zg7RwF+G3/EDlxuOh7Bzp1A/I2
	//uaM/D8B5V0tvpukjJqQgGKbX5nXdms64tdAwRC3Y7X2EQ/+8oV4VDGSiWbxMev
	oEuX4twhsp4Hty2tGosPiLmMgSPhbSNf1gAMogVMztW/N6F5zhJ6Y67Kp+pFMAtw
	yUIm40TuQjUHjHpk3sQvkEMFL65kSHPWzdOVmhnlKWz6teGPeeiz7zGzgId19r+B
	r8VwdvKTNZ+tzTwXAEqSdh1LyduFi4ZbKN7mxik9kHr41qQj7aaEEe4GQbGKYsW5
	eO3flBSA+jyWR3sX6WednMyMr1FZBrWL3lA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793201698; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:HP9NPN9KGe2Hw9X97WeImYR/2UmQkGbsiAbLSLpkJNfPpEK
	t4B6Tn9P9gqJhqsRfjAlkM7Fpjtg72mvs4Cjgax1TesSE3hFMbxuWzO/XdtGaXxy
	dLyLTqUNqVY0zxhEMdl/w4WWx4tA3PU/X6eCiFRnSJmqK3CVGHDNjMkasYuaIjz6
	ebY7bowP5Vj5erH3GebBAnVVIEPKr79HavKXhRzdPRfYV9wmxha+Vs96UKxmUEIq
	ulPms9oZ1C6z6zvTWID3ANDJSi3WUdfur/tvQ/3usd+xjR0yd1YR/mobDVBf/VIe
	g/XN9eG+yQWooDScO8QSusmSjYoJLYL0ER3MMlw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:hdG9nUMpQsiAckjRh/4lhGRVdWFx8ooX2uAdy6lnoHY=:5BB05nk+MUudlhjPiALkpUNSqEUptJW5R6zJR8ZqNgc=;
X-ME-Sender: <xms:IRbiaqFFTDvy1GUg7j08IFV3s4rAeu8jAVTiqmw_M7LYolwFldVTWw>
    <xme:IRbiarwBFqaWn4_0B8_wSqqV1tFG2krtRTXDQl5xZg_mDXZgiA7-zYUZ2a1eorc9b
    yxzeAoPibnsmFqqZWJ41XH3gNClZnjpawzFWqdTd2LuEOYaazvdx7_w>
X-ME-Received: <xmr:IRbiak2hROd5aqrcRe_AzkdCbpCByD9gLJUJ88wfGGqdUac2BWbopcrLPnmSkqM9>
X-ME-Proxy-Cause: dmFkZTE567ZNzEvzo3WVeepFO3ZYx2PMoyLnCk4K7y5QktSoN2rSACYVcPW9OuUm3jQr+G
    nOnoXi11i12t322N7pl+ftt4boiV+wcpsvbcoiLFsKZBpRU58KqHtGzCnA1hUVbbisRA9D
    BiiSGmYnAnudnvVvtbDHQhuxvZOHozpti8lUgNBnrGenfq3UQKBERSBWl0qIf8OWdnBf3L
    HCZ/6PMABiyb/Xue3LqRoV3hWeRz6zqzCiDd64PaZLZiWqFip649Ipy56eZ9WerlzdUxMg
    jvzhetm8HfRLUKuy5s47OxYeb3ziqCiXQ7ZnUtvPCw9NgyLZcdUlnFTMvt9fbh4WOT8xGB
    yOyQ5ztLxD63hapBAd2N5uJDUc+kj4ZWSMfmTV2LbnMzO9z22oZohqqy1E21K9ghmungtw
    XwUpzOgUzRrUZDTRovF8gEA8mrYS0kghBM5GWQzfPLKOe5k34kUYVcX2Jm+Rb51rQIPrhe
    nq1WaEX7VTplMXtke83oI3tkguSJNwMe5yM2X3NatTV9NNVy7izAy30MDEognJ7trd8kaP
    3Fee5+U0hsWGu28YjN2cPqBI49C6PaM28cz3PZx1AJG7eQXJaKfaoqdbpg1pDZpmDbl2TR
    9d38u8YfDWlkFp8f+j3oGp1wO5wgkUSxUDPP2At6htsWLfIEluF4kM4ENQUA
X-ME-Proxy: <xmx:IRbiarrC6xEdHvfNglbuRyxz9u53RFirlLKTLDDfzbdZyDOIlRubqA>
    <xmx:IRbiahU-c7Wm0zwqOV-uGPFm9oFDmRaQ2f1Ufkf6SX4eQO2pf6nbSQ>
    <xmx:IRbiakpOqW3xIVw313J21LsZfHkYxyrI6eAXWjclRoYRsnu1d3pVtA>
    <xmx:IRbiaoCpwoGsDXosK8kHObzfwih-_Rbo4Vv_943GZvsaN2jtge9jVw>
    <xmx:IhbialhQfm4I1WhqtRTVhfykg1RRSuvspqtf0hCOlgl0LAyjIpPa_DZY>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 11:34:57 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: enforce the DACL permission check on delete-on-close opens
Date: Wed, 28 Oct 2026 10:34:41 -0500
Message-ID: <20261028153441.184701-1-icb@fastmail.org>
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

smb2_open() runs the NT ACL permission check, smb_check_perm_dacl(), for
an existing file only when FILE_DELETE_ON_CLOSE is not requested.

On an acl_xattr share the stored security descriptor is the authoritative
permission model. set_info_sec() maps a descriptor into POSIX ACLs and
mode, so its read and write restrictions are also checked by
inode_permission() when smb2_open() opens the file. A file's DELETE right
cannot be expressed in a POSIX ACL, because Unix delete is governed by the
parent directory's write permission and not by the file's own ACL. So
only smb_check_perm_dacl() can check it.

Because delete-on-close opens skip that call, a client can open an
existing file with DesiredAccess FILE_READ_ATTRIBUTES | DELETE and
CreateOptions FILE_DELETE_ON_CLOSE and have the file unlinked on close,
even when the descriptor grants the caller no access at all. Only the
POSIX checks remain, read on the file and write on its parent directory.
The normal open-for-DELETE path is denied by smb_check_perm_dacl(), so
this lets a user delete files that a normal delete request could not.

Run the DACL check for every existing-file open, so a delete-on-close
open gets the same DACL check as any other open of an existing file. A
caller the descriptor does not grant access to is denied. An authorized
caller is unaffected, and shares without a stored descriptor are
unchanged.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable on a share with "vfs objects = acl_xattr" by an authenticated
    user who passes the POSIX checks for read on the file and write on the
    parent directory, for example a shared drop-box directory where many
    users can write the parent and individual files carry restrictive ACLs.
    Impact is unauthorized file deletion. It is not a privilege escalation
    and does not expose file contents.
    
    Reproduced on ksmbd-for-next 206fc30f71b0. tester2 creates a file and
    sets a DACL granting only tester2. tester's open(DELETE) fails with
    STATUS_ACCESS_DENIED, but open(FILE_READ_ATTRIBUTES | DELETE) with
    FILE_DELETE_ON_CLOSE succeeds and the file is unlinked on close. With
    this change that open returns STATUS_ACCESS_DENIED and the file
    survives. A file's owner can still delete it with delete-on-close when
    the DACL grants them access, and shares without a stored descriptor are
    unaffected. A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index be226664b8af..b664a02057eb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4836,7 +4836,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	daccess = smb_map_generic_desired_access(req->DesiredAccess);
 
-	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
+	if (file_present) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
 					 req->DesiredAccess,
 					 sess->user->uid, false);

base-commit: 206fc30f71b005156085fd8523ccc84a2c67791b
-- 
2.47.3

