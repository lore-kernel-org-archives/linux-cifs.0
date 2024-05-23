Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7904414B941;
	Thu, 23 May 2024 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470694; cv=none; b=HF957S2PUhrNT1uw2YHQchoue6aIKqLOQmqbQ2oL7/f8PavxTH4cd9wN5b4cWfzayu3paF6uOxZhRipvI1spcXO24r/jMr9U+U553qQ/AzVdYZr2bt3OsN90eHxKQVRM84mtRcl1xYuBzG8NINSjMCcbDB6oiiyXcV+0jVCA+5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470694; c=relaxed/simple;
	bh=9hIp0+VlXg/wlkW6hJzxAsexjBfYzP96CZ3pGYQIeGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBMhjGkPBQxhQICEF5n7PPwMn0plYGfUvUV2oDmSYFSUp0PfoPX0T59G+sqIYjgIIAm3ukk+ZBp5V0we7cTIZnr5oFVk7OevpN4m61WkhrolAGfx73ja+cznqkaKc95ewA+76abVDym1Hl4ixJSioKqRANxjXacTmpf5/TMx758=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKDkYEME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKDkYEME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0126EC32782;
	Thu, 23 May 2024 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470694;
	bh=9hIp0+VlXg/wlkW6hJzxAsexjBfYzP96CZ3pGYQIeGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKDkYEMErzbtnlpU29ZSmf130nWdgYCJMHfnMIO2lkV4PFQz05BF0Pf+J+ycvQlzR
	 LImyGYMPmi5z7+uQeLnA3lsrnDWhP0TJ0M2P7q0V0VvcvkVfEcJhSWnqkN/8Cjy1cl
	 XQhrorjAw0LESX2mhzLTqBrw+JpKXk3YkHZ5gnGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/102] ksmbd: auth: fix most kernel-doc warnings
Date: Thu, 23 May 2024 15:12:49 +0200
Message-ID: <20240523130343.375559595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b4068f1ef36d634ef44ece894738284d756d6627 ]

Fix 12 of 17 kernel-doc warnings in auth.c:

auth.c:221: warning: Function parameter or member 'conn' not described in 'ksmbd_auth_ntlmv2'
auth.c:221: warning: Function parameter or member 'cryptkey' not described in 'ksmbd_auth_ntlmv2'
auth.c:305: warning: Function parameter or member 'blob_len' not described in 'ksmbd_decode_ntlmssp_auth_blob'
auth.c:305: warning: Function parameter or member 'conn' not described in 'ksmbd_decode_ntlmssp_auth_blob'
auth.c:305: warning: Excess function parameter 'usr' description in 'ksmbd_decode_ntlmssp_auth_blob'
auth.c:385: warning: Function parameter or member 'blob_len' not described in 'ksmbd_decode_ntlmssp_neg_blob'
auth.c:385: warning: Function parameter or member 'conn' not described in 'ksmbd_decode_ntlmssp_neg_blob'
auth.c:385: warning: Excess function parameter 'rsp' description in 'ksmbd_decode_ntlmssp_neg_blob'
auth.c:385: warning: Excess function parameter 'sess' description in 'ksmbd_decode_ntlmssp_neg_blob'
auth.c:413: warning: Function parameter or member 'conn' not described in 'ksmbd_build_ntlmssp_challenge_blob'
auth.c:413: warning: Excess function parameter 'rsp' description in 'ksmbd_build_ntlmssp_challenge_blob'
auth.c:413: warning: Excess function parameter 'sess' description in 'ksmbd_build_ntlmssp_challenge_blob'

The other 5 are only present when a W=1 kernel build is done or
when scripts/kernel-doc is run with -Wall. They are:

auth.c:81: warning: No description found for return value of 'ksmbd_gen_sess_key'
auth.c:385: warning: No description found for return value of 'ksmbd_decode_ntlmssp_neg_blob'
auth.c:413: warning: No description found for return value of 'ksmbd_build_ntlmssp_challenge_blob'
auth.c:577: warning: No description found for return value of 'ksmbd_sign_smb2_pdu'
auth.c:628: warning: No description found for return value of 'ksmbd_sign_smb3_pdu'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 229a6527870d0..09b20039636e7 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -208,10 +208,12 @@ static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 
 /**
  * ksmbd_auth_ntlmv2() - NTLMv2 authentication handler
- * @sess:	session of connection
+ * @conn:		connection
+ * @sess:		session of connection
  * @ntlmv2:		NTLMv2 challenge response
  * @blen:		NTLMv2 blob length
  * @domain_name:	domain name
+ * @cryptkey:		session crypto key
  *
  * Return:	0 on success, error number on error
  */
@@ -294,7 +296,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
  * ksmbd_decode_ntlmssp_auth_blob() - helper function to construct
  * authenticate blob
  * @authblob:	authenticate blob source pointer
- * @usr:	user details
+ * @blob_len:	length of the @authblob message
+ * @conn:	connection
  * @sess:	session of connection
  *
  * Return:	0 on success, error number on error
@@ -376,8 +379,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
  * ksmbd_decode_ntlmssp_neg_blob() - helper function to construct
  * negotiate blob
  * @negblob: negotiate blob source pointer
- * @rsp:     response header pointer to be updated
- * @sess:    session of connection
+ * @blob_len:	length of the @authblob message
+ * @conn:	connection
  *
  */
 int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
@@ -403,8 +406,7 @@ int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
  * ksmbd_build_ntlmssp_challenge_blob() - helper function to construct
  * challenge blob
  * @chgblob: challenge blob source pointer to initialize
- * @rsp:     response header pointer to be updated
- * @sess:    session of connection
+ * @conn:	connection
  *
  */
 unsigned int
-- 
2.43.0



