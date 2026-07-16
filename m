Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FCD446072;
	Thu, 16 Jul 2026 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784226139; cv=none; b=ouqEqDtU/be35/uTdowrnDE9uBCKHX3EoGDUAHjPQPmUjd8U/IELDd++6Qk2rpyUU15aS3VMcTnDxyUGGvXLqnyv8jYqmSgWHwNco17mC92RZ9rsWJCTrqnGoU446TQLsnrUxi5cfcqi6WpCKoI8+c/SRBzdieIE1IV+/yx9yFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784226139; c=relaxed/simple;
	bh=kNPi6pA+SRJTGfGulqUHyhvPI3unB2m0lySgnyzDc9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ba5dWBdSxIO0lBauN8UA6XwNyPuO4EgxkVd+ZDsKFiwTWwyxPQnxCOko0BNwE8zPiJH4CZHY3XVE3rOdLKqg5TP4+PcrIZMXoJYuIAqFBfQ1GGcghdOyE5Bmpx6tTGe/DzjQ7CxrsnfJ6WSV/HkJpT3jZaNeRpblQGDnTXNqw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImDq0oFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImDq0oFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17D51F00ACF;
	Thu, 16 Jul 2026 18:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784226130;
	bh=Cw1/b6JLbNyPN4ogntGJaoqzdeHTObSMsULLRlJB8Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImDq0oFL2XnUrXjlrzGzkeKd3xuUWLwU1k+D13OjLxGq0tZe8G4FteCqoHXp/iJLE
	 E/tmT20QVkcMa7OIi67boWC61/2QDDMbVrQ+UTu230Ljfw1RZAGm8EYkMbtwn+h2bk
	 yA4AO7Ks61JGvvHAM/iAR9SZTTL3/btBXCJjry/zZI7kFfT/ia/GC+Tfcd8FesYbmr
	 sJ8OdaUFlJe3Ro4ZzLGWhCYqiLIQw79seWj8wHfuwWRdxKoH9J+KtoHix8s2lkNEX/
	 7fPIhVpTik3fPCs520/OrCJMB4bpJ/4sIifRJxkW4S5fiAW6SwSms331Q/EhybwPRy
	 TyQgkR5GL79EA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	stable@kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y 4/7] ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc
Date: Thu, 16 Jul 2026 14:22:02 -0400
Message-ID: <20260716182205.921233-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716182205.921233-1-sashal@kernel.org>
References: <2026071415-rambling-chooser-b760@gregkh>
 <20260716182205.921233-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ad0057fb91218914d6c98268718ceb9d59b388e1 ]

The kernel ASN.1 BER decoder calls action callbacks incrementally as it
walks the input.  When ksmbd_decode_negTokenInit() reaches the mechToken
[2] OCTET STRING element, ksmbd_neg_token_alloc() allocates
conn->mechToken immediately via kmemdup_nul().  If a later element in
the same blob is malformed, then the decoder will return nonzero after
the allocation is already live.  This could happen if mechListMIC [3]
overrunse the enclosing SEQUENCE.

decode_negotiation_token() then sets conn->use_spnego = false because
both the negTokenInit and negTokenTarg grammars failed.  The cleanup at
the bottom of smb2_sess_setup() is gated on use_spnego:

	if (conn->use_spnego && conn->mechToken) {
		kfree(conn->mechToken);
		conn->mechToken = NULL;
	}

so the kfree is skipped, causing the mechToken to never be freed.

This codepath is reachable pre-authentication, so untrusted clients can
cause slow memory leaks on a server without even being properly
authenticated.

Fix this up by not checking check for use_spnego, as it's not required,
so the memory will always be properly freed.  At the same time, always
free the memory in ksmbd_conn_free() incase some other failure path
forgot to free it.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c1016dd1d8b2 ("ksmbd: track the connection owning a byte-range lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.c | 1 +
 fs/ksmbd/smb2pdu.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 63815c4df1333e..524caba512e79a 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -39,6 +39,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
+	kfree(conn->mechToken);
 	kfree(conn);
 }
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a31a1561540960..af1e386cedb43b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1920,7 +1920,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	else if (rc)
 		rsp->hdr.Status = STATUS_LOGON_FAILURE;
 
-	if (conn->use_spnego && conn->mechToken) {
+	if (conn->mechToken) {
 		kfree(conn->mechToken);
 		conn->mechToken = NULL;
 	}
-- 
2.53.0

