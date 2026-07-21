Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A39C43B4AB;
	Tue, 21 Jul 2026 22:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672863; cv=none; b=T8tQDUbfMZFw5bB6TJAHTeR2HwWIUsU/eclb0+pSyn2swZRJECJJtAIcaS5Xu+ShdTGoY5FdAGs798cckDBnysFkZ7WLEuaSiEIw6JohCwH/Wg+g09Ouhbh6EucmspafqY0T8pog6jYNxfWK2TmlofbXmZ7jw+XD12AMC+qs3e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672863; c=relaxed/simple;
	bh=dyK+VBmkJw7LSukkFaW1Nxm0vyUx/k5uxmngXp/Y1AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5fQ5oM/PzVPCQWDoIYou+aTkycibLeShUb6UdDLAJ0MAtcDLcCrXPy5/9/NEpUnoEQNbH3XfpyFwPXYALzSSvwzA4LZIGP1FzArW9iNvCtCYMgzDUhECnxgZQ9Uf2eBZGJemYgfVOKntVtzwWDSUXHYIiiaZUT3MBtcsHtmuUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPCUL4s1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPCUL4s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA8E1F00A3A;
	Tue, 21 Jul 2026 22:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672862;
	bh=Of6Db9Ku1hSVriEYp4NiwvX1+Th8UIoKoyvuaZBW0cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPCUL4s1V4j4CcwIdLq4P1KSam4Op9PNjwUj+8fWyHkKS9lJNIJx2mnxx03IZZHTS
	 il4VB0wcaqebfNuo0yT36rb8MCwjbWwtUkdASzJ9Xhry6NinQdDLbjwuBqhPrzpUsl
	 f+9Mkt0ZrqlrR1r2Me8x/nE3vmROGZ/qKHU31XMI=
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
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 786/843] ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc
Date: Tue, 21 Jul 2026 17:27:01 +0200
Message-ID: <20260721152423.744843981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    1 +
 fs/ksmbd/smb2pdu.c    |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -39,6 +39,7 @@ void ksmbd_conn_free(struct ksmbd_conn *
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
+	kfree(conn->mechToken);
 	kfree(conn);
 }
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1920,7 +1920,7 @@ out_err:
 	else if (rc)
 		rsp->hdr.Status = STATUS_LOGON_FAILURE;
 
-	if (conn->use_spnego && conn->mechToken) {
+	if (conn->mechToken) {
 		kfree(conn->mechToken);
 		conn->mechToken = NULL;
 	}


