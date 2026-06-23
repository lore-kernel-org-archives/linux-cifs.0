Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C538550C;
	Tue, 23 Jun 2026 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178262; cv=none; b=m12G94oOWgCCNNAqtmERdZtdcFAnT1W1CywnjFBOMRrrmlyVFwg6PSemA0mZMDY6brDvrAENeJIPMzh8uIVND7TI6qjpNWjoCE0uwr25XG3i5N7xujWtW3nq+rrRFLDLmmUbyuuKDMHGSrKPXoe7xX45JlIp7QRQjzsyEeURic4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178262; c=relaxed/simple;
	bh=hsZFSpuWuKfkBO6Ib3TB93YPcOhXKvdXpVhXCXtENXc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=j98txIeWRaBsU0wqV3Fl6V3Y+e+aJTEtc85KI2+Fma0gpxh/XL34r7RgQ+KLb5TY+qNvV+YYRjclsys1zh2IZmERoLqrb79PFmguKS3ZciXWJfsw6XSz2pMRqhJthRKfv3/4N+8RiZquqGW43F7LYTjqIwwWqVTOoo5IpTf4ILA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=KQLHAC0k; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="KQLHAC0k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782178254; bh=YN/+jA2vorfABFRiMwtxCUBqFoApvmFlPzqehN6P0HA=;
	h=From:To:Cc:Subject:Date;
	b=KQLHAC0kztInWNrtqfmKWaqvFxPSNBgiX988jUMutmGbD2f7fMpEjFcuBfZU5OfsW
	 iagBow9Vkp5hajIlVeoZxotjjbsjeLgG2wRenYbkNSANS3YHvi362DV/blJVXxB2Qv
	 fg9zB5D5cY/ACMOdmdR4QMmi7CA2gRIXSsmpuX/o=
Received: from localhost.localdomain ([116.128.244.169])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 7B287AE8; Tue, 23 Jun 2026 09:30:50 +0800
X-QQ-mid: xmsmtpt1782178250t0ijgme3x
Message-ID: <tencent_61D9C47692BD8C4063364E24FD8181DE1007@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+fX5AdylPrpvLBzx1ZeLmZKodswKh3exfiyUoRT51blQCD++JG3
	 ZjVftW5lwjWuELhP5T/UTo7ZLO1ESobtEhFt07XclwClLLwX4Xw/ILLm/idWJgJjR6gK+Udo7hI4
	 SbYQbNii15/VxzBnWnSjilS6Jm2zoQe6dUnr8SWNz66zNLnuX9KW15qfX4E9Oo6FY7xhUFz9aQiP
	 Hjz/b6cIi5OrRtkRSKpmeZgQaN4/og6V9lxpxMcxXz8B24PSp3nFf1XnRIWXbbJSu2jEWG6eZRVo
	 oNa1w88rx4uxUoh8c8Ijj2pjnPQOWir2TsdNkWimDC28cjYhNaLf4osj+QgXuXvuUjQ9+XfiOV5X
	 WgvizIvWnkzwgi/KHIFh+veLCmRKgFafhmpeZjOcf1D+k/1dv4nDsKcHkB4JLzC9VBcTZ29C3NwO
	 TaQ0k2pX6TioPsDPGoML6YhU4824VyCSGyjCJlVbKwMYDv++S+QVwUXx1SWQ00fKTrDKmdh5RG7X
	 WliQpuswutuKio2yiU1ISSTc7tceWH5m7Oi0efrksGKNUnw3kAqi4JzaKjVgMQfnd9IzejF8ZGSq
	 tVqmQ5wHaR5LFAxmEX1Hu6dH81MjyufJUzWssALvqhnf9jWcYy/9e0SpA8Mc7pw1hsmvJWxdMr1m
	 rvdZAMsBovO99/zayyp47+NKVJHWuDlUTK22ZlxdwKRR4V2kUvUEqY9ehBsnbj1y4a0IO0FC6mJv
	 hA1apJHqQiM156s1GB8G1lm4Ldt9Tz7nmEcVGgYQCqpRqRNZIXVlwGNBlMdvJENIhQ4yPZqn0pgW
	 zBy7xL97c65EVC7+XZYCp1tj2yQRRjkjLTIb7ratESFOM8lZyS0PCCUX/owkaiNGn7m4NeFYrKY6
	 Ceeq/TWdv7bWn83NWqApVY01/lpkfB8Eu5ZSNBghzM0iVPsBZ0knZir/2dR29KGmS/qYkapEhYLY
	 cztEOviJcgvydmGTBQOUnp1hVRMSxyDhb3eDQfvZZG93OAE6TxK0tD5lDjrGoz18IlxuYKpP++1D
	 5iD7O34X/yoKwkHt4e
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Haofeng Li <920484857@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Haofeng Li <13266079573@163.com>,
	Haofeng Li <lihaofeng@kylinos.cn>,
	stable@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] ksmbd: validate NTLMv2 response before updating session key
Date: Tue, 23 Jun 2026 09:30:26 +0800
X-OQ-MSGID: <20260623013026.1122043-1-920484857@qq.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haofeng Li <lihaofeng@kylinos.cn>

ksmbd_auth_ntlmv2() derives the NTLMv2 session key into
sess->sess_key before it verifies the NTLMv2 response.
ksmbd_decode_ntlmssp_auth_blob() then continues into KEY_XCH even
when ksmbd_auth_ntlmv2() failed.

With SMB3 multichannel binding, the failed authentication operates on
an existing session and the session setup error path does not expire
binding sessions. A client can send a binding session setup with a
bad NT proof and KEY_XCH and still modify sess->sess_key before
STATUS_LOGON_FAILURE is returned.

Relevant path:

  smb2_sess_setup()
    -> conn->binding = true
    -> ntlm_authenticate()
       -> session_user()
       -> ksmbd_decode_ntlmssp_auth_blob()
          -> ksmbd_auth_ntlmv2()
             -> calc_ntlmv2_hash()
             -> hmac_md5_usingrawkey(..., sess->sess_key)
             -> crypto_memneq() returns mismatch
          -> KEY_XCH arc4_crypt(..., sess->sess_key, ...)
    -> out_err without expiring the binding session

Derive the base session key into a local buffer and copy it to
sess->sess_key only after the proof matches. Return immediately on
authentication failure so KEY_XCH is only processed after successful
authentication.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: f9929ef6a2a5 ("ksmbd: add support for key exchange")
Cc: stable@vger.kernel.org
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/auth.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index e99409fa721c..86f521e849d5 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -142,6 +142,7 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
+	char sess_key[SMB2_NTLMV2_SESSKEY_SIZE];
 	struct hmac_md5_ctx ctx;
 	int rc;
 
@@ -164,12 +165,21 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	/* Generate the session key */
 	hmac_md5_usingrawkey(ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
 			     ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE,
-			     sess->sess_key);
+			     sess_key);
 
 	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
-			  CIFS_HMAC_MD5_HASH_SIZE))
-		return -EINVAL;
-	return 0;
+			  CIFS_HMAC_MD5_HASH_SIZE)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	memcpy(sess->sess_key, sess_key, sizeof(sess_key));
+	rc = 0;
+out:
+	memzero_explicit(ntlmv2_hash, sizeof(ntlmv2_hash));
+	memzero_explicit(ntlmv2_rsp, sizeof(ntlmv2_rsp));
+	memzero_explicit(sess_key, sizeof(sess_key));
+	return rc;
 }
 
 /**
@@ -226,6 +236,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 				nt_len - CIFS_ENCPWD_SIZE,
 				domain_name, conn->ntlmssp.cryptkey);
 	kfree(domain_name);
+	if (ret)
+		return ret;
 
 	/* The recovered secondary session key */
 	if (conn->ntlmssp.client_flags & NTLMSSP_NEGOTIATE_KEY_XCH) {
-- 
2.25.1

