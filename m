Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114509;
	b=udlp/QTLTVerNyb9MD8CT7Om2FoSbe+2/2cTP6OKPmzjaPelgJao4NzX3KXRlKyiELzo
	 5UIslumqvCsPAWFW5wyc7iN+OtveCczxADCt62E2xgVB93g3/c0avXdWjcigPVoT+SjSD
	 LnQNGNkvnVrczqb7MGYb+xm/5huy1YSLw11PH1rOfMRieiYj3YGMCbmU4jEFuP290YfZx
	 qo0TEtQWSXfkY8z2aYHYp/kjyeoQRqMCE5LoXrf0Jr7JqNMDgMcLKWoeBNq/FJTT9PIjM
	 18oCQgfiuKBbO1iEt/6SNo6yjDpEdzYFwLdWZ3oaINw0dBBGchuMZs7WGowRxpNg9yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114509;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lg7ricNjsihrhZdu+HxttW8s2muYiAp/wLN4SAfTLNg=;
	b=sY6MSLbqLXHL6q8QErb9+KYLvESVF5SyJ7YPDw+99sEOASsFd2FFSE2iEHw5QyQxpEkl
	 Dy85iXzK87urujHqkQ/B45QCm3kIDRtBouk+rwlA7FAO0mdLTSDATb0bEzb4f33liy5U9
	 aVMWjeKuj+9r7Db75jYAxcLE6bCOzZWp24SnqOrxRiHlPBjdISE8xcS8SimhpWqcYRw88
	 iJh6OUX7XBGSqSIArZdHi4/trrOWriQNsP8RNXsgcTmLBIzQGeFNyZ226NzcvNVrjfZjI
	 0YKnHHsqSbCaTiCelzUZzgeXrSjTcX7A14B60oZKmfZ09UPzieEbsfgX7Xw8yjayFyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b="lJ/+Gir7";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=C52S9hHA;
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1B7606A320
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 15:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD1B7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=lJ/+Gir7;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=C52S9hHA
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id E6158EC00CF
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 11:21:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 27 Oct 2026 11:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793114507; x=1793200907; bh=lg7ricNjsihrhZdu+Hxtt
	W8s2muYiAp/wLN4SAfTLNg=; b=lJ/+Gir7oE8spvleM7UyqsOssQS3/ZhHpEg8n
	lJcUV7sd5Eb/jGVAVln3MysdQVskl/KaTrqKsiTM1jRX+h+mkplHxsE2WrfvUWE/
	8UuMNmE5rYIU4o8GQ7dxrC9EabUtH0kNivj5XorEEspQeUvOhFCslscu5Z/e1e3D
	NulyW9b4VqT8pE0clVDLUOejLYHZO07gvQE5lDLN5wbFSzhwcFuWk6OicbhUkPUp
	2H2om7fApJ0bZGMNHby1WDugnYNVoj9woPhZo2cbDPYHR/0grZMPdz54Hq5nE25b
	SG9K5vSatV7mPlK6kYuFgsrw9510YgV17BUbzyskc6UlrM5QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793114507; x=1793200907; bh=lg7ricNjsihrhZdu+HxttW8s2muYiAp/wLN
	4SAfTLNg=; b=C52S9hHArXVKC3ikcey4YPI6fhFNTUghaN2JlpnCYRPVN+vhJhX
	7GJ7tgjMiZwjTg8lnJqmjpUVZaqBmjucRm0aWjdH4hXIxzUd0KgoomDmswIUOWXH
	urHKEli8c6jq2KvB5jI8naMFvPJGELOlgeAluix8yNxvxD2BNkqKmhGC+khRLIM0
	SvY8B25USlu/Ba/FVcYj+yvN8SyzMzi5eXgRUTc9C24mtbKXq7k6412wnjHYF/yL
	nl71BtXTT0Iddwa4V5xyBe4EfjRjQVtkZMpw+/HivdvDFpkqbWCSzXRl52FNUJEr
	NKiHW/nQcb13SWSts9HbpJJ4rBFm/Jlj1+g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793114507; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:SI1D+Ukfp7whgY0ts4Yi7oWL8vidxzGB4BmAvOHVEe5jN9W
	u6ORQjYtGlSDV4pGaNDmHnmhv2Ty/n9L3UnetivxJ4o1JTj/bjyBQt9lKKr877Y0
	nMoI4YQDTBCA1w5LjzMwvPUX1e1tLVXAuAVkFOdgfn0JARdqEM1Xjf258S/GZniv
	f/3htK+tAfedsfOvMyjlLV9EzIBYnSykw63cR+vYhvviiRn2MyobZVGi27QdIMuT
	Y3Nae1LDQsYIo2VBf9HV2eeNnqvotkbuBiZD1elyejS5LkSaY+xP2uPNsgFzhpow
	03x9sgDyouzt9jqSjYNK7LS/oODG/3c3awbY1ng==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:Agl46WJE4hi5pPDRHQ0YdL2pYKz8tOWD0csprg9fNQc=:cq4xNvG/sxAkb1hgRNOLhxsnj/T+nWg/hbu6JRtCDOk=;
X-ME-Sender: <xms:i8HgaoaMFIWwCTpvCuH1-HsOcjQsSkQVLWDlirsMtlPk4PlPFzuQjw>
    <xme:i8Hgaj3vKfE8-S2sRWUs49VQuDVXITfIGJfoa4jb7FZNYkyWFtU3MGAVpgBhaHeZ2
    nR-6JF5-RyHBPDlx_Kp_55PTYYcKlybw9rpOt6BoAp4Lmr1UVTtUlA>
X-ME-Received: <xmr:i8HgajqnDpfD71jYb80b4fQwoiPR-fNlcl_nN7pjOACYqwcj3i1kW7a1SM6tX03U>
X-ME-Proxy-Cause: dmFkZTEY0hqEvExQfHV6cxC6UqEohEli4kd2Rib2z7xPHr2/LMCPhaUHUtfYW+lU0I5Aww
    oGYAZHMf5OP3Kdg+v+8iRaFN5Prw7oD+g8XPM1iLULMnB6pnfbUcJydyuHzmEhR4gnWpBQ
    TptWhK1Nz7NXUxt7QXtM+aCADuc3Z8EoopnWPtOjFpDE0vgV1ZXUX3AHGqiCLtt3lMkjd6
    fWhK0iO+w/nonSyaIZNKsN6AJ/AVv0C6NztSQhfns45jsZ4yglShdnYkapCqzGfXbintj0
    Zi6N1XgD3kMQj8FnpNh4kXhho88xNbl6ku4fcVBJXrl2BqFNrUTfPA2GveE5pel0YtPQlr
    U5ONpcz6J8qenKgNdsP9q1RMhX5H5Awy6MKn8eIo2M52Lq+Ez8JK2EYfiBZbu/stqJG/9v
    49uSTU8ieycaJUKPNyndIo5wgwPYRZHSEGz45CIEbOcEsur6gLc3ucHVZm2EGObJKBBk8O
    jpUFlQsf0+nPWpuiBXp1pIjlXBB6BtN8JbNsfQdJz8gKQOkA61y49jRfAvI8qqjHKM2FB6
    hvIwHLu7LX1odEpshUB+z2Du73kXiWcrJkAlitqO5aJf4AYdvzg8J666A+5zOt1oALeVaS
    L92DEPAlPq4BLHwGmvQnZzJqn4d6d9hszq8i4GF9Vns9RuQRlL1C9Pl1iV/Q
X-ME-Proxy: <xmx:i8HgaqM2v2ig7TLJ9iUqKF35p62DGk6Tzhu23ubnGJVcFRnzOYPfxw>
    <xmx:i8HgakruapBVITfEaseHTbCzmdHQUFY-74xYJ9P4lhwHhDpBnhUT5w>
    <xmx:i8HgatvySpjBkvyFbu4zh7_MQNgl7mNU-8KoaYKHL6qcl2INNc7Uzg>
    <xmx:i8Hgaj0BHFawMkW8rOqH49qhx4zLzaHjdtxi_Fqx8KKQ7_CSap_M9A>
    <xmx:i8HgahzKxmRPbor3Jlhd-TiIvyxm3I4HG7hAaHA5akX8HqiPhD2pLYAw>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 11:21:46 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix session reference leak on compounded SESSION_SETUP
Date: Tue, 27 Oct 2026 10:21:35 -0500
Message-ID: <20261027152135.138259-1-icb@fastmail.org>
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

A compound request can place SESSION_SETUP after another command. That
earlier command leaves a reference to its session in work->sess.
smb2_sess_setup() then overwrites work->sess with the session it looks up
or creates, and the dispatcher later puts work->sess only once. The
inherited reference is never dropped. That leaks the session, together
with its setup connection and socket, and every repeat of the compound
leaks another.

  unreferenced object (size 512):
    __kmalloc_cache_noprof+0x32c/0x3a0
    ksmbd_smb2_session_create+0xf6/0x9c0 [ksmbd]
    smb2_sess_setup+0xda4/0x6280 [ksmbd]
    handle_ksmbd_work+0x88c/0x1cb0 [ksmbd]

Save the inherited session on entry. After the request has been
processed, release it once, but only when smb2_sess_setup() has replaced
work->sess with its own session or cleared it. Do this after
ksmbd_conn_unlock() so the put does not run under srv_mutex. An error path
may instead leave the inherited session in work->sess. Keep it there, so
the dispatcher still puts it and the error response is still signed or
encrypted with it as before.

Fixes: 7aa8804c0b67 ("ksmbd: fix user-after-free from session log off")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    The bug needs a compound in which SESSION_SETUP follows another
    command, for example TREE_CONNECT then SESSION_SETUP. When the later
    SESSION_SETUP replaces or clears work->sess, the inherited session
    reference is leaked. The earlier command only needs an established
    session, not a privileged one, so on a share that maps unknown users
    to guest this is reachable without credentials. A guest SESSION_SETUP
    reaches a usable session, and the compounded SESSION_SETUP that leaks
    need not itself authenticate.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance (code review and kmemleak
    reproduction).
    
    Tested on ksmbd-for-next 714f27729121 under KASAN and kmemleak. A
    compound [TREE_CONNECT] + [SESSION_SETUP] repeated on fresh connections
    leaks ksmbd_session objects (traced to ksmbd_smb2_session_create()
    through smb2_sess_setup()) without the patch and none with it. KASAN
    stays quiet. The four reference-balance scenarios (new-session
    replace, failed lookup, same-session reacquire, and a forced
    ksmbd_session_register() failure) each leave no leaked session with
    the patch applied. The register failure was forced with a temporary
    hook that is not part of this patch.

 fs/smb/server/smb2pdu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b306bc6e21ee..a21ee045848c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2563,6 +2563,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct smb2_sess_setup_req *req;
 	struct smb2_sess_setup_rsp *rsp;
 	struct ksmbd_session *sess = NULL;
+	struct ksmbd_session *prev_sess = work->sess;
+	bool installed = false;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
 	u64 previous_session_id = 0;
@@ -2679,6 +2681,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			int sign_ret;
 
 			work->sess = sess;
+			installed = true;
 			if (sess->dialect >= SMB30_PROT_ID)
 				sign_ret = smb3_check_sign_req(work);
 			else
@@ -2731,6 +2734,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		conn->binding = false;
 	}
 	work->sess = sess;
+	installed = true;
 
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
@@ -2928,6 +2932,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	}
 
 	ksmbd_conn_unlock(conn);
+
+	/*
+	 * Later in a compound, work->sess holds the reference that an
+	 * earlier command took. Drop it once this request has installed
+	 * its own session there or cleared it.
+	 */
+	if (prev_sess && (installed || !work->sess))
+		ksmbd_user_session_put(prev_sess);
 	return rc;
 }
 

base-commit: 714f27729121d59f103ca4dad7b0c2d1c125cd71
-- 
2.47.3

