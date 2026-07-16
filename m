Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BF630F55B;
	Thu, 16 Jul 2026 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784216230; cv=none; b=iHAarfZ1v+VgG58iPY1u8R4Sn1POEGoP+sm3mrw3kGHzjtWvdL3k1lWDgKp/88OpHwbE10VK72YU73uKz8BiOYBWz6BmPbElYKO8qgzWNrsU7t3oDbktjWt9FOu/ls2sEHHPIeNyQHzszoo3fK+f7PlAKSP4DFHNt0lUquLrCjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784216230; c=relaxed/simple;
	bh=7FQkFjFCRyBVR+FvZ4xm8/TMVQDGDuAYw6VlkHyBKsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZHRP18lRNEGR7JM9lDWv9WyLezgg4+8kDhu0UzIz6BhhXuqyHwkM4bXPS2jlTeEwmvCDpgM3N4IdhGo3M/0KPLRlnbGyIIQJiJ99gR+qKhlTDlJVzyPOCeYD4ynC+PX3XKiJpExGrZmw6EBUuzeXGcCfvjqeP+X9r+QwVpbzCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mB20yKhC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mB20yKhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506101F000E9;
	Thu, 16 Jul 2026 15:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784216229;
	bh=9yMSEpcxokYlbr1pI3HxhioNdh8t09miV4mATsF1wF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mB20yKhCGBrLytuyCNFCXLHU7+i/U2LnVIbXRbVhWjZBipv3XhPm7r80NXZ1Zo/J3
	 OKR41JOGl103KN7CBncAxH1XbfN2xIOYbgw3646rZYdNJ4qhrqZg1P4fXKc3MOxygt
	 wjGgGUNUdL3GlJ/ixt77FyhxBf3VJ38P3AH8UdSD9zpSVXMuKORkFpUnyJhI9raWQ9
	 CEAOxV5/rdnoBXmfZOe+0ZRwRbyIVfxlHpv251vB5z6Evm9hLk7/jJCwQhiTJ6ilg8
	 mqsTWbJPCIcgEi34RvPhInzDrOkYenUbW2ywlBci0+DcH2HoPHun1/wqo4AC8Xy4qF
	 ytGhm/1xKkWLw==
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
Subject: [PATCH 6.1.y 4/7] ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc
Date: Thu, 16 Jul 2026 11:37:01 -0400
Message-ID: <20260716153704.583869-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716153704.583869-1-sashal@kernel.org>
References: <2026071414-kosher-parsley-920b@gregkh>
 <20260716153704.583869-1-sashal@kernel.org>
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
 fs/smb/server/connection.c | 1 +
 fs/smb/server/smb2pdu.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 92d8a0d898ebd7..ae21de810e5870 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -39,6 +39,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
+	kfree(conn->mechToken);
 	kfree(conn);
 }
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ff1615f9d63b69..e0f0e738a2e49f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1909,7 +1909,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	else if (rc)
 		rsp->hdr.Status = STATUS_LOGON_FAILURE;
 
-	if (conn->use_spnego && conn->mechToken) {
+	if (conn->mechToken) {
 		kfree(conn->mechToken);
 		conn->mechToken = NULL;
 	}
-- 
2.53.0

