Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201067;
	b=Xf4LH381m24+Jk8d6zZ8uZAW8SM5xqVwtQ/rZZZP5RYZ8uUph57xUFHujKcaqtfCm6Qx
	 nnTRaAS7Zjnz25xZcWaaXQKmr/KuM1TPxNOQuAKIa9K9HpoAxEFzzH49htq06RHlL/HOF
	 cKdB0oEnfkw5nZuL1heR0R00gBe6jaoP/XiIkThVGiLKAdkXr/UnFqBPb2TOYtxJFdxVR
	 qxQGNEafD8urqwiDjUfjpOx+SAvjpml3BD/7o8G3lKoUXQsucjgXnUbibfNRGaw35MisN
	 w1s84qF6iKi50nhYc//0jTxwZ4Ndq8tRWXb3lSBkyV0JMcOh2NMb5ELmTYPHrErQwFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201067;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BfcD0yOfpZZxJBlt6VkljjUOnhbxWsFVe42FO5P3KKw=;
	b=L1uwevd00J0sTUq18woOxjpNqBqLx1wwrLPYa7SQNo429HHE12cQ5gTvOWJ6lmjW4d2u
	 cdO8wDjYjEoLtfXNPvpxwgWd+dwYDugOk2YMCD4aGMk8z7JWm99knaHmg6oQh8MuYfzUD
	 bKj4Dv4jHbIYradQZrqq7zUjMDvRG6BO0TRr7e4pP96Sw/bhsyWQNy9rLw5K2AiMdGePa
	 /ujVQfUYHTPIWa7wbnTp4fldN30ahnBkxXp2vgjx3mDuNqQT1FfM5gMX0MkIQRtqU2+t2
	 QdEJ6bI5kJSbiNW37YG+yeLWZhs5TcyyB42h5gr042DQUXDV993kXU3f92/Bmlg+Tdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=JcUN2xkx;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=J4be2ifz;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04608606A323
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 15:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04608606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=JcUN2xkx;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=J4be2ifz
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3702A1400159
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 11:24:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 28 Oct 2026 11:24:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793201066; x=1793287466; bh=BfcD0yOfpZZxJBlt6Vklj
	jUOnhbxWsFVe42FO5P3KKw=; b=JcUN2xkxM5/GOXJ2pYFDP8kA3BN/fXopFzKGF
	n+EHGEjltXH7Gg5FRUSE4pL5UFHhsgf1ia8sW5e6x+A4qKshjx/6LtRcH/JgnL8d
	haP+8JCY+eird06MQFFwb6M3s6fZMd/1eTDStR6loLik1BmTvzFqRecsh5q1gSfs
	nEFa8r4gw3bev04cVQHYjCbBfNlYbfmGMlZmTjvqp2YH/iGAklmu6mSgV40t5NCN
	6MqL7LTMyZD8ZrQCzyIyHrPiEObIso2Wc2mdlNGdjRSYo3mWQ4Jf+tMOCzmxe0B/
	Mdh+Vg3fZ4ULF8+gm7mugh27mvUqZFrO589YDMz4ZuL2j4apw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793201066; x=1793287466; bh=BfcD0yOfpZZxJBlt6VkljjUOnhbxWsFVe42
	FO5P3KKw=; b=J4be2ifzmTDmdV6n0pd9nUyUMhMX5GQ6JtvoLQT6q5JJRX2gA+N
	ew5y+PiWOIEPYf7slgI8SXgyvU9sNqCf/GH1I5tG1wW1k0aoUlQz/V0oRyjRhUXc
	OiXO5wKCyfGS4nAyZ8nq7qVdSv0fcb46RquTrx+uNeBIRKolcpY2qN0tOYI4IjWT
	XPR2QE65ggxNVeBe1fwsBmnz6Ol7+1tLIJ+z8GaO/TntKSdvUPNGgqPcxiNYKaIx
	DkLhrh2wXctRldH1O6baJVkhfYKNX+2anDdGI9x/9U7/Tb1lvGcrIiWXUqGuG+7B
	vrp1crJLEvFqh1sYIkx5XEMnMUxmXEWcB8w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793201066; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:EIrvrTo8hQJVNJSZPUFHXVWgyG4fGQgtst8whc462lDhjtd
	JMooHvFT15mpZ7Lxuv2zFtEz1xPQOYCnsOPpeO53DhI4we/horRnOs4qC1nOLO9H
	XGhS4eqOkU+Z0rJmfCPOHrIRs0uLhmJ/sQxWjq5rcoRDxifmsfFe/a167yRTg3a1
	lI2El+G8Mhw3x9ZmrJXfi+nylC77vtiLuXscSy4Ie4zX/9511IO7X9MYzUG5DVMW
	wl16K+TMtvQZzTy3fLdLOnny3HF7B5LJeRGlqAMk9HZAVH9zJ8/4KJfVORv7WVVb
	Mnc6uoWFbw9OfX8QqbdYQ63GeeW1OrE7OySHiOg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:3OhkKizlT/OXYX+iSaPAuKVcUUPYGDMX8uXN0zIjV8g=:fVgbAePJvHSidSOXCkpdSAsmYCQPcvgfO9+rfnamlms=;
X-ME-Sender: <xms:qRPiavX3MtWHEfp8G_dyL4O0FMt941IkbZexMGplt5IAFdeBD2K2eQ>
    <xme:qRPiaoBn967E35qf_i-bPp-WP846MoDbg80tNehck7p9-oUa5J7NKm_6YUWmPbSC9
    3qHRY5ZCawE6GWRhhf0aTN2Myy3nvY5b9OrVud0HldceWS8rPQw6l0yLg>
X-ME-Received: <xmr:qRPiasENW_lI3MTZ5cM92Y8WjSCqVhL6LcG2P8Xqt7Wi1gJY0-6FhvAuFhVS5rTu>
X-ME-Proxy-Cause: dmFkZTGJGW5ZmYWtjJzszk8ZC/D2ik/dKkFR69w9/H9a+W4qwaOtZbsZMuUb27wvfx07c5
    Fn6QRalC38iUHNmRL0iZUpLJ73ZyrYevJEddJmNcSX3k8MstygdQRPsulrih9+0t3A9e8x
    W+OL9nBX+iFVmNT9ZlirSMIixFyLFq7acW44x4A5oKcLoJwZRxz9YjwDG/WnX30/a8+KKI
    7q5jSmqKnYmbLqVimOmwItGikM845oDAeGuiikkNaVkYgVBR8pwVGDKaRnrt0US7usXT/u
    64Uv+Zo4tDL8ZImXmoGubo0NYMidklUIlXwNGCKIv61Rm3yT5M9Ngybcob2hpNSLB5a4Ju
    ITaf2cA5bp7MCoi9yEMlXYxchofXKedClkNY6CTEVgBcqqW6yKBnilTu50P0lRoxDITQCT
    ms8VZfkYu+8ZHtYiR2gjzEp1kadBX547vB+cdM/7c3CAvlPtY7WSXyE9ZngfYJxGLwAB4w
    GvkCICIBfSuNXoukbyTwvsg+SgO410OazrTpxVDdAiw3QpUxidJDHtZZIJ/kgsV3FHm/YR
    C3pn5aHah5c8G5SSnIZgysJk4DuaNRl8+0qub9zcps6x9wMrQG3GmD3xcclgeZ5oBJe9kM
    fZ02cjQ+WqJQ0uoajoMZvmn2u6haCk5TLzgGwz5LByj2p+Q6pF2nW8TxylsQ
X-ME-Proxy: <xmx:qRPiah4o2H2KAmV5qFXw5K-e5KX228gh65fWiPCFPtREfAWS-N6WEw>
    <xmx:qRPiaqlBYjyklEHNwNIHgHTZ8DSm6-wIN7fSJX9P7xor4LXBz3Ve1Q>
    <xmx:qRPiak7MFENzNc5qm5mpOYEmx7cP7_v92z7llARaNe7gzNUuErKvOw>
    <xmx:qRPiajTpbpf5TyLBOPu_Lk3x0GLRnkiQV1JewBrQD46VpfsR7Zuwtg>
    <xmx:qhPiarzg6weHXKxtkLMysbeycGy4pJ7X6ENBbqGXFIzXFBtcRZttMYpT>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 11:24:24 -0400 (EDT)
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
Subject: [PATCH] ksmbd: require DELETE access for delete-on-close opens
Date: Wed, 28 Oct 2026 10:24:13 -0500
Message-ID: <20261028152413.183380-1-icb@fastmail.org>
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

smb2_open() accepts FILE_DELETE_ON_CLOSE on an existing file without
DELETE in DesiredAccess. When the request asks only for
FILE_READ_ATTRIBUTES or READ_CONTROL, it also skips inode_permission()
and the parent directory MAY_WRITE | MAY_EXEC check that delete-on-close
is meant to get. The file is then marked for deletion by a caller who
could not delete it.

The unlink happens later, in __ksmbd_inode_close(), when the last handle
on the inode is closed, and it runs with the credentials of that handle.
If the caller closes last, the unlink fails. If another user who can
write the parent directory, such as the file's owner, still has the file
open, the file is deleted when that user closes it. Until then new opens
of the file fail with STATUS_DELETE_PENDING. So a user with only search
permission on a directory can delete a file in it, or block opens of it,
while the owner has it open.

A MAXIMUM_ALLOWED open that also requests DELETE has the same problem.
The requested access is replaced with the maximal access, which does not
include DELETE when the caller cannot write the parent directory, and the
later permission checks are skipped as already done.

MS-FSA 2.1.5.1 requires an open with FILE_DELETE_ON_CLOSE and without
DELETE in DesiredAccess to fail with STATUS_INVALID_PARAMETER, and Samba
does the same. Add that check to the CreateOptions validation, using
the generic-mapped DesiredAccess so that GENERIC_ALL still qualifies.
This also refuses MAXIMUM_ALLOWED with FILE_DELETE_ON_CLOSE but no
explicit DELETE, as MS-FSA and Samba do. When MAXIMUM_ALLOWED is
requested with DELETE but the maximal access does not include DELETE,
fail with STATUS_ACCESS_DENIED. With DELETE requested, delete-on-close
opens go through the existing parent directory check.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable by any authenticated user on a writable share, with no
    acl_xattr or other special configuration. The caller needs search
    permission on the directory, and the file must be open by a user who can
    write the directory when the caller closes. Impact is unauthorized
    deletion of files that are in use, and denial of new opens while the
    delete is pending. It does not expose file contents and is not a
    privilege escalation.
    
    Reproduced on ksmbd-for-next 206fc30f71b0. tester2 owns a 0755 directory
    and a 0600 file in it, and holds the file open with ShareAccess
    READ | WRITE. tester is denied open(DELETE) and open(GENERIC_READ), but
    opens the file with FILE_READ_ATTRIBUTES, or with MAXIMUM_ALLOWED |
    DELETE, plus FILE_DELETE_ON_CLOSE, and closes it. tester2's next open
    fails with STATUS_DELETE_PENDING and the file is unlinked when tester2
    closes. With this change those opens fail with STATUS_INVALID_PARAMETER
    and STATUS_ACCESS_DENIED and the file survives. Delete-on-close with
    DELETE, GENERIC_ALL or MAXIMUM_ALLOWED | DELETE on existing files, new
    files and directories still works, as do smbclient rm, rmdir, rename and
    deltree. The Linux client always requests DELETE with delete-on-close.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index be226664b8af..c626cb3bece1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4606,6 +4606,14 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 			}
 		}
+
+		/* MS-FSA 2.1.5.1: delete-on-close requires DELETE access */
+		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE &&
+		    !(smb_map_generic_desired_access(req->DesiredAccess) &
+		      FILE_DELETE_LE)) {
+			rc = -EINVAL;
+			goto err_out2;
+		}
 	}
 
 	if (le32_to_cpu(req->CreateDisposition) >
@@ -4875,6 +4883,13 @@ int smb2_open(struct ksmbd_work *work)
 		maximal_access = daccess;
 	}
 
+	/* MAXIMUM_ALLOWED may not have granted the requested DELETE */
+	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE &&
+	    !(daccess & FILE_DELETE_LE)) {
+		rc = -EACCES;
+		goto err_out;
+	}
+
 	open_flags = smb2_create_open_flags(file_present, daccess,
 					    req->CreateDisposition,
 					    &may_flags,

base-commit: 206fc30f71b005156085fd8523ccc84a2c67791b
-- 
2.47.3

