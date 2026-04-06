Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9ED14BF92;
	Mon,  6 Apr 2026 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775483229; cv=none; b=mOxEGU5O1B54MmWrGI8fLXwohQGAs7p2FeD45yydhKk8A4pefflqvyu8NvJg2DAkzgehpn2419ZAOz3bTV5Ao4WlRWFuWHLL+feYvbLCfo/xONm4iKHae4D4+s6KQyhBXmYVKnkXl4pwNE2+ASUKl7SMpUeGcJ+IujPZdQ/uWgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775483229; c=relaxed/simple;
	bh=4ZQRFVzdUCijd8idg1rAWi6+HbzaURjFDDhmzLTKBPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXWKjz2ByVf4OCk0sKMPFK96xtRYLfsKpGt+POLtnshXpXs+E64biiz/SfxV9EAwwWpOMb/NrB0lvvUbgDt1IPZ7hG+u6RM+jwAAw6N/9w19l6dioPptXHGUFJoL+IQ9cdRLFjFHAU2c8xTDA0kq07jaOunF0YBNFQ6NLxcZkko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eJ/mcVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eJ/mcVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E06C2BC9E;
	Mon,  6 Apr 2026 13:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775483229;
	bh=4ZQRFVzdUCijd8idg1rAWi6+HbzaURjFDDhmzLTKBPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eJ/mcVd3fMZ6m3/BWlT1UZwgIiCtE2SPxk9SaIE1naduA0M3HGVf0yJnWxVW4vr6
	 yorsihbLnZ8BPbK66ozekiC6J9gZzfwrFYcypmgpm5JcKo/9fjnrsbrODv8Spsszpt
	 8ziLXJLKo7bWfuwDEzitK92lufx+A8xvOX87e/e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable <stable@kernel.org>
Subject: [PATCH 3/3] ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc
Date: Mon,  6 Apr 2026 15:46:48 +0200
Message-ID: <2026040647-reset-uninstall-1145@gregkh>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026040644-brussels-dab-6f99@gregkh>
References: <2026040644-brussels-dab-6f99@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2611; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=4ZQRFVzdUCijd8idg1rAWi6+HbzaURjFDDhmzLTKBPU=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmXd7r/q+V5ZHeAwbvDvqp/SfnK1mPVKXOYVNkEjO9sM GLf1LCyI5aFQZCJQVZMkeXLNp6j+ysOKXoZ2p6GmcPKBDKEgYtTACby/inDggW+lQWPis6FrDjd 9qXZy/aMh1uLN8P8qJq4zVP3X2FRvaw0p+9s3ovlekfcAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

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
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c | 1 +
 fs/smb/server/smb2pdu.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 1bb2081c492c..26cfce344861 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -96,6 +96,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
+	kfree(conn->mechToken);
 	if (atomic_dec_and_test(&conn->refcnt)) {
 		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6f658dc20758..a344937595f4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1915,7 +1915,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	else if (rc)
 		rsp->hdr.Status = STATUS_LOGON_FAILURE;
 
-	if (conn->use_spnego && conn->mechToken) {
+	if (conn->mechToken) {
 		kfree(conn->mechToken);
 		conn->mechToken = NULL;
 	}
-- 
2.53.0

