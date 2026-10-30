Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793325954;
	b=RbuGWlOSWer/BFQESS0g1ycWe3CGG3Ci+2kf5mGGEdTYA0EXhFbDFkecTAPRvSqcVvMf
	 kD9AChTmRodg3tFfWo02EA1AH2OfniZ+g5Hssv+TjK06jpmhXwo75o05mQFJpzzv7fjnK
	 VTprbciaTBO6W3n0DvdVfmvLwPPePQ2+hz9kNsihzzGCms9+HArKzMiRtOHd7lNz78llw
	 D3wtcvUWAiFTPYuoE0YYLTIsWQ2cBmtCeBP+tm3SezyrwDHnODvHzzgVYDWWXAqKqYfiL
	 kNwhZhKtJ/FBoRIoMFc0nrk85qecfbOYT9Hb73o8JU3OkBMTtfmSQE11MOp3wqBBQgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793325954;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=/qptapl5AxkeeYOO6JaZVeOMFWsKEBID7YGw0sL8KDI=;
	b=QvM1SAnPXw6/TfpYBPmyNNlc6RDLEROgbmGydmNWg7cnogw7h8pyPNnybSHFAAdJok2R
	 ofvvgZawViP0lKE90EcoF7LvUFIG69txR7k9EvgnrySkzKhKU80JErSbDqa2CoeT9fjnO
	 5MQkXNUVCM9NFCi85dP+gy9gnAs7ivL7s9mIkZQxMfsljasa0ogqrwyHjAD+JmUdjpDdR
	 NDcZX9jg8Scuo/qelpXfLFjQj7+1g1ISnpQ9LTBwA2/HsbT5PY5nT9UBz7/VGmB2oYFgE
	 j+w6RK+UQGqUJgx7GXNfbg4a/kKVBkXFCFygYCCGTPYdUOSeDuNS42umk61v1HD0wog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=MukVNb21;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=RG9NTTqB;
	arc=none smtp.remote-ip=202.12.124.157
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A4C606A32C
	for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 02:05:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52A4C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=MukVNb21;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=RG9NTTqB
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BCAF17A0124
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 22:05:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 29 Oct 2026 22:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1793325953; x=
	1793412353; bh=/qptapl5AxkeeYOO6JaZVeOMFWsKEBID7YGw0sL8KDI=; b=M
	ukVNb21brNOFp4WNtl7iMxKkKZV9H6fapB5tY0JkSS4+vi5w1Q0rEXUaME2E+4MV
	iEuajKa3MVVBme+h2PIOpaDPjgJxLzad0ZFxlNBy/tG2rFAvyxnqQUo2u1mYAbdk
	9weHB75aKJ/20gUmiZENsePYi83jJKsM5LXXdo4M4e187ObUO7eSxo1U7quPTudg
	xhC79wU9TFKzmrFCiVXNVcLcF6vjy/F93gdirYqmDgUdM8oniaUobagu4oecSK8I
	bNOEj7tDzRsHUkPqeApvhnMIA3p0rg8pM87nEsHcA4sc073bYjE1g2upkLYsOBRR
	GuApJt2kjslcWoSad2Mag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793325953; x=1793412353; bh=/
	qptapl5AxkeeYOO6JaZVeOMFWsKEBID7YGw0sL8KDI=; b=RG9NTTqB3uF0hqX4N
	QETUz9YJ2k7LDXSCF4Tv+z4mjoyZ/3vTufv3hcGWofJC57KYW6s9oyBim+ickFCm
	JBAEWs5Ou7HG9B/YfIcnLkHOyM3FvqYipz1A+oCrJ6v0EofuWW/Tdn1GCabqhE8K
	yjMpyA6URCAiRDFiSq3r8ii/Ul00Jb8tfXVXvJedVYltePthYGlTsd1D6pbmXZLg
	bvUGCx8819AcANBUVRiJzyr0MD3x94OQxOF+jGXD+i1dwQ0ok/0KxKXMF4gAEdjM
	vb5JNj63M01SYZvXD/vDtNVhrZ4Zk2tXaNRc1JITOIC9z5w+13cCf9280Yk6L5LI
	1/a/g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793325953; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:NTNkC+1wyxYDDGFuk4rhypYfuMsQrzOaOCIgEP+dFzBs+yu
	JGMGdbBrppNQK2A/EROWJy6hDu+rwuLCW77NbuYkypOgfmx63SF3jx0CQjDWZYlh
	Zlj6AQORklkJCpAt1IfFF6tSvpeAjSvcu2ZXJTPGKlwu6NvwqnKCtrWYDbcz5dgR
	W60krmLJrVDPg4cfYTu2eb48n+3QGLFHGebqOxaO8FL6APUn7xpDU9zRCnUA1pik
	bVsKRH3t9STYh9eiZTb9OwF7YYGEjJ2B6X+9NTQksmCWIqHZpZoxX2U1w0A0E1kA
	RCdvaE4dtsPIHIqAkLfkyk28iNrb8xnE8cFcXSQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:cy13Bct0iWxl4uk4jNEjIU77kxSxE2CLllY8tvkVYF8=:wUfm7bm3LBiMRZ0MsxQT4D4tqQ3EjZLw2SwEaBZJsy0=;
X-ME-Sender: <xms:gPvjao_Y1cRoOc_jSzrcuJDpVmv3y5dH5IL6fKpBV9wBOxXVHrWIIA>
    <xme:gPvjasusKXa1k99ctXBO36KnBc9B78Or9rncFp0sj99xkcgnImkQbsBDShTX7a5Zt
    H0Tu8U3nVXKQknBIJhwHfnFnKNXm0bHU4zS7SYZV9wl7jTaLLs8ILU3sw>
X-ME-Received: <xmr:gPvjagNF5Jh8OWnp-j-ktOFU-Im7XkEE3qnyI8BRjth1G0lSPTsdDxgAtCdutg8j>
X-ME-Proxy-Cause: dmFkZTF1P4tGd5t1oYC66SYLCGuJ10fu8KFL2ynIhs6gl36O8PRC2EfpkKNKRWec4KpwyM
    Mn0KqIaREB2A1uoRIYNBSSfsRS70IYLuoj+Nfk/za4dIzlxNbtLqDqzFVhXSeWzERhOHeT
    AxXNuIz4CMi9NFxghcZSJBbL7rn5/ZrrO96LD4U7QWkSH/TOrdPVqWXZFZ0SjgjfuFKXpW
    Ks9pFeI8PvkuemjrQEW/6NdBLWeRC+VoBHQFK+/cB1w5TqVsYqBaNCEj01DcEqKAd58e7m
    wAhiVXoh2wCkd7pJ9xlh7NMXxbBsfdyZ50ImRnHtRE/k/1VB5f5YECaEP2pIPF+CIfN5Vz
    ALXN05tQl2cEILeeJdwBlPjZh7GKoBR7n5YMJUP+Suu/uplE8snrZRaS4cxegEa5NmjotF
    ySphBaifbJ6ruq+k/gKsZdoEs3LrrSR9aau0qHADq9dpEpbDrwGEd4qeYfjrOWDRnVpLrW
    lrKY/JiyH5PAkMzmc6LCVNITCGZg2TSYv3NZjwnCIA5aZjXmVPY6/u0YHssb/5vteNf/tg
    3UB3cnszbEyrP9XjuntFW1Demm5ZSnYOqYsOkxf+eOKcZNWOlVRwcsDGUIjHuWfDIH+zLY
    8hI3UD5W5qyJYSxCUwTOl7Es2MYhP7A1b78auoTCm2nbZ8s6M69A4ACeblfA
X-ME-Proxy: <xmx:gPvjapj0qZrjbsTHb6pqcbN7iU21GFXpfFbJlAkwW55AgYYN81rNpQ>
    <xmx:gPvjaq6JW1_xOROGTJhBLGu0Qy5hHWmy-P0kOFt2gbwdnBFKC8wgiA>
    <xmx:gPvjao2ooLW7z5tWbQVcCX9zDlPCCYAvW8pA7aTpsK4zaXu6KmiI4A>
    <xmx:gPvjatuhUtYjWa4Q_0wRoq2uesk2VlgeSWnHaEmNZZPrXwD2YYaIKQ>
    <xmx:gfvjakFbBeCD1ScEi--1XlWEavulMj_OtsFIBf8lApRO3EgIbrGQQaa3>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 22:05:52 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: exclude guest and anonymous sessions from Authenticated Users ACEs
Date: Thu, 29 Oct 2026 21:05:23 -0500
Message-ID: <20261030020523.302085-3-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261030020523.302085-1-icb@fastmail.org>
References: <20261030020523.302085-1-icb@fastmail.org>
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

smb_check_perm_dacl() matches an Authenticated Users ACE (S-1-5-11) for
every caller, guest and anonymous sessions included. MS-DTYP 2.4.2.4
says users authenticated as Guest or Anonymous are not members of that
group. As a result, on a share with guest access a client without
credentials passes the DACL check with every right the DACL gives
Authenticated Users. For example, it can read a file that only
Authenticated Users may read. Access-based enumeration also lists that
file to it.

Tell smb_check_perm_dacl() whether the session authenticated. A guest or
anonymous session then no longer matches an Authenticated Users ACE but
still matches an Everyone ACE. An authenticated user matches both.

Fixes: cc2f133e80eb ("ksmbd: fix maximum allowed access checks")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable on a share with "vfs objects = acl_xattr" and
    "guest ok = yes", for files whose DACL grants Authenticated Users. That
    is enough for an anonymous session. A guest session for an unknown user
    also needs "map to guest = bad user". These settings are off by default.
    
    The match came with cc2f133e80eb, first released in v7.3.
    
    Tested on ksmbd-for-next af8c72f65507 with patch 1 applied, before and
    after this one. Every combination of one or two allow or deny ACEs for
    the caller, Everyone and Authenticated Users was tested, with READ_DATA,
    WRITE_DATA, WRITE_EA, APPEND_DATA or full access as the mask (930
    DACLs). Each DACL also ended with an allow ACE giving the owner full
    access. The DACLs were set on a file and probed with real reads and
    writes as an authenticated user, a guest and an anonymous session. The
    authenticated user's results are unchanged. Every guest and anonymous
    change agrees with MS-DTYP 2.5.3.2 and 2.4.2.4, and none moves away. A
    guest or anonymous session no longer reads or lists a file only
    Authenticated Users may read, and still reads and lists one Everyone may
    read. smbtorture smb2.acls and eight related suites match the results
    with patch 1 alone, apart from smb2.create mkdir-dup, which also fails
    intermittently there.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/mgmt/user_config.h   |  5 +++++
 fs/smb/server/smb2pdu.c            | 11 ++++++++---
 fs/smb/server/smbacl.c             |  8 +++++---
 fs/smb/server/smbacl.h             |  2 +-
 fs/smb/server/tests/smbacl_kunit.c |  4 ++--
 5 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.h b/fs/smb/server/mgmt/user_config.h
index cc460b4ff7d3..43c55357b95b 100644
--- a/fs/smb/server/mgmt/user_config.h
+++ b/fs/smb/server/mgmt/user_config.h
@@ -66,5 +66,10 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 		struct ksmbd_login_response_ext *resp_ext);
 void ksmbd_free_user(struct ksmbd_user *user);
 bool ksmbd_anonymous_user(struct ksmbd_user *user);
+
+static inline bool ksmbd_user_authenticated(struct ksmbd_user *user)
+{
+	return user && !user_guest(user) && !ksmbd_anonymous_user(user);
+}
 bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2);
 #endif /* __USER_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2e955d272f4b..8c7aba240e71 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4330,7 +4330,8 @@ static int smb2_handle_app_instance_id(struct ksmbd_work *work,
 	/* Authorize the referenced open even if its name changes meanwhile. */
 	old_path = &old_fp->filp->f_path;
 	rc = smb_check_perm_dacl(conn, old_path, &maximal_access, 0,
-				 work->sess->user->uid, false);
+				 work->sess->user->uid,
+				 ksmbd_user_authenticated(work->sess->user), false);
 	if (rc) {
 		/* Access denial prevents takeover, not the CREATE itself. */
 		ksmbd_put_durable_fd(old_fp);
@@ -4851,14 +4852,17 @@ int smb2_open(struct ksmbd_work *work)
 	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
 					 req->DesiredAccess,
-					 sess->user->uid, false);
+					 sess->user->uid,
+					 ksmbd_user_authenticated(sess->user), false);
 		if (rc)
 			goto err_out;
 
 		if (maximal_access_ctxt) {
 			maximal_access = FILE_MAXIMAL_ACCESS_LE;
 			rc = smb_check_perm_dacl(conn, &path, &maximal_access,
-						 0, sess->user->uid, false);
+						 0, sess->user->uid,
+						 ksmbd_user_authenticated(sess->user),
+						 false);
 			if (rc)
 				goto err_out;
 
@@ -6326,6 +6330,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 			rc = smb_check_perm_dacl(priv->work->conn, &path,
 						 &daccess, daccess,
 						 priv->work->sess->user->uid,
+						 ksmbd_user_authenticated(priv->work->sess->user),
 						 true);
 			if (rc) {
 				dput(dent);
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 3542ae9a605c..b83aa84815ce 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1461,7 +1461,7 @@ bool smb_inherit_flags(int flags, bool is_dir)
 
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
-			bool strict)
+			bool authenticated, bool strict)
 {
 	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	struct smb_ntsd *pntsd = NULL;
@@ -1558,7 +1558,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			    (compare_sids(&sid, &ace->sid) &&
 			     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
 			     compare_sids(&sid_everyone, &ace->sid) &&
-			     compare_sids(&sid_authusers, &ace->sid) &&
+			     (!authenticated ||
+			      compare_sids(&sid_authusers, &ace->sid)) &&
 			     compare_sids(&sid_owner_rights, &ace->sid)))
 				goto next_ace;
 
@@ -1611,7 +1612,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			break;
 		}
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
-		    !compare_sids(&sid_authusers, &ace->sid))
+		    (authenticated &&
+		     !compare_sids(&sid_authusers, &ace->sid)))
 			others_ace = ace;
 
 		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 3342cebab333..bbd35948a379 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -97,7 +97,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     unsigned int uid, unsigned int gid);
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
-			bool strict);
+			bool authenticated, bool strict);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write, bool posix_open,
diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
index 33496b4d31a3..bf28439a7696 100644
--- a/fs/smb/server/tests/smbacl_kunit.c
+++ b/fs/smb/server/tests/smbacl_kunit.c
@@ -229,7 +229,7 @@ static void ksmbd_smb_check_perm_dacl_boundary_test(struct kunit *test)
 		goto out;
 
 	rc = smb_check_perm_dacl(NULL, &file->f_path, &daccess,
-				 cpu_to_le32(FILE_READ_DATA), 0, false);
+				 cpu_to_le32(FILE_READ_DATA), 0, true, false);
 
 	/*
 	 * The post-boundary ACE (ACE #2, beyond pdacl->size) grants
@@ -271,7 +271,7 @@ ksmbd_smb_check_perm_dacl_maximal_boundary_test(struct kunit *test)
 		goto out;
 
 	rc = smb_check_perm_dacl(NULL, &file->f_path, &daccess,
-				 FILE_MAXIMAL_ACCESS_LE, 0, false);
+				 FILE_MAXIMAL_ACCESS_LE, 0, true, false);
 	KUNIT_EXPECT_EQ(test, 0, rc);
 	if (rc)
 		goto out;
-- 
2.47.3

