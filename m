Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1F233F5A9;
	Mon, 20 Apr 2026 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701429; cv=none; b=lagEQ/MfSW3usHZWms1xARoMu4IRig3xrduFtxzyqXFfUkSKBeIVyAHzVzo9PDNFb+Dz3P/Sad7yYccZt4SBJArzDTs56PqQO8efls8c7A7KQN02vzwwfOn6L0zcr9MJ/W7ZyFUpgP5jAqA1Qdw7Z/i6NoPaO3Tpa84sBZ8LI0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701429; c=relaxed/simple;
	bh=B0xknbStO549k1VP3VlMj9q0eHnq2JDjcyk74mNx9Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlIJ6SO6hhxMGGYroL4/CWz6PHkiOT5klTzozrHVdptcKeU/KRQS8+KmfSRMUWDZBZCVzJZwqpcXy2PGRQjVXIjdngdsPm+Zv7I0Q2++iKayuQGKQIgzxh13kQoK54gfAcAi6PsjVFTrEs+t0sGBCzSh1FwYW6JWQk2rhRWQYB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7YKR8Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7YKR8Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F34C19425;
	Mon, 20 Apr 2026 16:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701429;
	bh=B0xknbStO549k1VP3VlMj9q0eHnq2JDjcyk74mNx9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7YKR8KkDg3Sjp2Ps039U9nDliTnz7u7FY2p3bLh1fjC4z0iYY9ohM4RBhvo6cYeH
	 SPHddzeZYs0kYn0m67Aph7UJxMX6JGmNQw4KbRi80L+n7cuwKFO445u7NE4eJkb7VP
	 ir7aDh2gdo1SCTEupYzXSuIT1Hjfu8Z/xOffxYt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	stable@kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 110/162] ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc
Date: Mon, 20 Apr 2026 17:42:22 +0200
Message-ID: <20260420153931.025296062@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit ad0057fb91218914d6c98268718ceb9d59b388e1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    1 +
 fs/smb/server/smb2pdu.c    |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -39,6 +39,7 @@ void ksmbd_conn_free(struct ksmbd_conn *
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
+	kfree(conn->mechToken);
 	if (atomic_dec_and_test(&conn->refcnt)) {
 		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1921,7 +1921,7 @@ out_err:
 	else if (rc)
 		rsp->hdr.Status = STATUS_LOGON_FAILURE;
 
-	if (conn->use_spnego && conn->mechToken) {
+	if (conn->mechToken) {
 		kfree(conn->mechToken);
 		conn->mechToken = NULL;
 	}


