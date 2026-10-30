Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793325951;
	b=G9GcRcEvKVsu/5jLARmrpIG4x5TW9HPD2oJVV8dDGs+BpdhsXET00iLTl70kvlrxwoeW
	 D0rkgWy+qXKMXxwxU73tgmQswYZlW5xWOlgze/6IuiBN3NGNo3o0bidEL+RFHxW6k9Q45
	 hM+dhr0tTG/Eyp7pvMIQRu2czf4IAdz2p1rnCNPihlF2AH324m7nzsLfVmBle9B9fTqUC
	 Ug38Fcm66hrFgpCk1XonuHNsYJVuthsQ9dgKEsv8iwIWTf6F5l9OeoEl9v7o5EtgrYAjF
	 1HaClTvkZR8i9EDOu0zyomOZNtYFdhmPI4WFt7AUhH2NHWZ2QSnwfcyjnD4NEW8rfOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793325951;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=Gl4Mnl1de8y8qX+Z1yRANIuNnN3G2IMMvqjWCKdjyF0=;
	b=KtPxObzKH0tWtV+Wc7ZY4Tr2kS56rWX33qdSZO9JAE0BlfZthh8Tr+imgV+ZSBLOpSXT
	 70Mjmyba+KLgT+9hcFONYE8XwwLzkSzF040KgK8rgSEEef5ubSqfMsxUdYowHFaErWe9L
	 S+0cda1eK1cnkYJivKmkey+ABq2HAhoJ+z0/eGNd77RxJQ3gM1UEtuvxj1FKh4HLEweEF
	 6EnnjlpluaJYP8rYUBj7pye9FdD5a51W7LSmsfV6ZlQMohCljWQKh3zjy3dgBMILQtv7q
	 SjimJKNJuax7fpG2o7Kle4tQ7kGZ+i9X7T698qYNdJEeT+SAOn9K/Kjf10Y3+mhtAyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=XawUOY68;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=eUBSs+LQ;
	arc=none smtp.remote-ip=202.12.124.148
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166AC606A31D
	for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 02:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 166AC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=XawUOY68;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=eUBSs+LQ
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 55D731D000E1
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 22:05:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 29 Oct 2026 22:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1793325949; x=
	1793412349; bh=Gl4Mnl1de8y8qX+Z1yRANIuNnN3G2IMMvqjWCKdjyF0=; b=X
	awUOY68dfSlLupblnO+nQixzNXlqanocNgwKPBt7BuhybXlqUf2np0Il+0Hv3wP9
	E1pYMN51qGPKqRH/JE7+uggct37ILvWLrS5VnhwCm9R5rIYkzwobj4/r9B7mvkQc
	KdBVJOU/2qBhXVhnTLSc7G2BZtOUCyVr5X80j3EgZQtJmi/8wF0W0S9JoekbDaGK
	RODUHqy5Ome9nFQj/mfsf/G1x6uD4PK6lQmrgLr5na6ob0Gh/ihQisHwVi7y8yUn
	MH3uOnBYIUGAuvx18kof52pPVQJ8NJb1Bd5WAFjS10+zWirWRSWTK4lpqjTDQQIq
	52SYjG9dHgt38e3WOcvcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793325949; x=1793412349; bh=G
	l4Mnl1de8y8qX+Z1yRANIuNnN3G2IMMvqjWCKdjyF0=; b=eUBSs+LQSK2jiEUUZ
	3yxynF52NUgiLXIA2SlmB7aZZxj0xP3WM3RcW1ekgIcOI934ZBoINfbwb63MnbYS
	tUdql3UKppd+tULENnVqCL2E4wqhZdkr0vi1iVBwsxgKTmRFeqC2Y8Pob6CrM6wN
	v0TRVSKLbU6DjHfGe0BohGENnzlGJl8p7QSRO1xRQtsuffI2fEdxVJkVGuExow2z
	1m2g55D8Cw7y4NzW6j2nstw6VjtMXHXUyaaI484b3riI5u63Ew1VbaOisX2DBBT8
	UoceGwb4MdRXg73iNldKf8dE/S5zITtCQt+iez04C+nWPIlJkhR7D37MP/+zB6FD
	x/qPg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793325949; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:YLxS1Z9yMjON05F7uBfyOpPAYXPSptSduyR/TvDplHB6OJt
	LBnLHNLHje2nJPn7BJvKafgYAXcNZ5Me+PxgLQlF5VUM29R5ZXP2Tpo+Crx1O/Mv
	NFsNvFfpXq1kROqdYoKnwvFtTaVFXzDKkZWPn5Z2gr2J6xKBmIkK90BMF3kpnOKr
	pe7+qfTIZs5EtSmZ1VSTFMfYFVY3b/FG+gqti8qR4RoL+eLQefOAGclc74q8SDSQ
	onHAJ82KDGhGJwupcNPN5USp1fS7AQzi5msK4CSqsbRvOp6erImuLMdPkeoJLGwm
	bzaM+mxZ26FAQSyXo1NSV5MWN5ZpgTYFT2XuhZg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:AYPZDYNGNlmtYSPsCXIAKIGijze+ZlsfU8uxzc0a9wM=:hI4dfG8bOVojDRq5BHyZs1fYi/smlVhSBL+L+IXTwL0=;
X-ME-Sender: <xms:ffvjaqtjYpwqe_Qb7z03OIBwKTmrUZnTYPhIDImEdYjZlMQAv27H1g>
    <xme:ffvjarcPzAdOxs_UIHJ_HbWiOvxCT_xjDNhklSVH1Ufb79zqyOLycm2SL2ydIlnlI
    pRaG18Nt4x1kjxwSTj-CTWo3nFKe3JhoyTeDUPcljw-9p_VMZM_rpOK>
X-ME-Received: <xmr:ffvjan9reFnl6axcYuuURQdf2DPaNJc7bdzs2QQLKEGIR0xbyz7nOIkfcEVlL1l9>
X-ME-Proxy-Cause: dmFkZTGdyebkjfFGwvw42pLtM2g+hGtQgI/Hybub609FUMzezdgSM4HnHbZ4/p6BDqSRj8
    5+7U9MTk9tzrtwPOpAWcCB2jGtUqI3FOkxwrH0y3ki4faABM1CfKiwiRHYAD5xczxUrICw
    mDUHSD4z0Ebm9lsDIVcyzMdFBbjN4YFGyNU21gJepvWCvv7rFwCEe2UQQQve1OFv0it5gb
    v9b+iUGn2jISUE7EGf701DJwNKbE8m3Ih2w2aiMeDtESg08yG8+wW/907AIJNNHuNOFD8K
    oMs3sJ3CqKeruuw6RTMGNWKSNtjHiK4m0lv8+8wCa1NOhNMgZ8737FCud09wdK4+h96eBo
    cFmTaPvwe8gkXD0l9dldbMkYWfrC93OiggGI/YFbiMDIHabK2lEOzsDqwfbw23E5sIBsnk
    5GIH4vt8ID7JFu5npRPxAylBJDA0hqxUCV4vEDCdUoIx1vkMRrJryLrqm7SbTFgq7Yxsaj
    2PtRQ6STddovxMSimIy5TDap939apnOZyT3I9mJvqgL5KYX2hrOw7EU11dqIBIIwwCu5n9
    ty/UG8dWZF0oTijLPc8358EUfiTdjA5R+ihimmgoXg1WultOZ/jWPtCklQv8tGKos5PolT
    hM0kA4p0B0Q8gFfbzp/Ap5/QEdVSyaJdWEdBMzSzbfMj98P6NpXgzlWsbJWA
X-ME-Proxy: <xmx:ffvjamS_obYwWXvppterL0-ZcEM-yhEJB9QstTty3K8cpqRsx_WBYg>
    <xmx:ffvjaooqIMR2lGlMk7D5Y5gAZN3EYkhlWDtgI5hHAWa7QyldZbblCA>
    <xmx:ffvjajnOrliWOVmTe8GJ8jF2fFPERG-UFOnZont47hxNSoouelpobg>
    <xmx:ffvjahc0wdthgiKBUlp6YbqEO6YYcb4bDNXEOD3cE7-XkbXTASaQnA>
    <xmx:ffvjar05d5wf9lewaf0g9Zvqozvb7P5ziBtDkMEK24Tf3-5EggRwHD9w>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 22:05:48 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: evaluate the DACL in order for requested access
Date: Thu, 29 Oct 2026 21:05:22 -0500
Message-ID: <20261030020523.302085-2-icb@fastmail.org>
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

On an acl_xattr share, smb_check_perm_dacl() evaluates the whole DACL in
order only for a MAXIMUM_ALLOWED open. Any other open is checked against
a single ACE, the first one whose SID matches the caller.

If that ACE is a deny, the caller gets every right the deny does not
name. For example, a deny for writing grants read. Later ACEs are never
checked, and an inherit-only ACE counts as if it applied to the file.

Evaluate the DACL in order (MS-DTYP 2.5.3.2) for every open, as the
MAXIMUM_ALLOWED path already does. The extra rights that path gives the
owner, and the execute right it adds, stay limited to MAXIMUM_ALLOWED.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable on a share with "vfs objects = acl_xattr", for a file whose
    DACL has a deny ACE. An authenticated user reaches it through a deny
    that names them. A guest reaches it through a deny for Everyone on a
    share that allows guests.
    
    Tested on ksmbd-for-next af8c72f65507. tester2's file has the DACL
    [DENY tester WRITE_DATA] [ALLOW tester2 FULL]. Before this change tester
    reads its contents over SMB. After it, the open returns
    STATUS_ACCESS_DENIED. Every combination of one or two allow or deny ACEs
    for the caller, Everyone and Authenticated Users was tested, with
    READ_DATA, WRITE_DATA, WRITE_EA, APPEND_DATA or full access as the mask
    (930 DACLs). Each DACL also ended with an allow ACE giving the owner
    full access. The DACLs were set on a file and probed with real reads
    and writes. Every result that changes for an authenticated user moves to
    what ordered evaluation gives, and none moves away. smbtorture smb2.acls
    and eight related suites match the base results, apart from smb2.create
    mkdir-dup, which also fails intermittently on base.
    
    The ordered walk this reuses came with cc2f133e80eb
    ("ksmbd: fix maximum allowed access checks"), so a stable tree without
    it needs that commit first.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smbacl.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 664f01263611..3542ae9a605c 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1481,6 +1481,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
+	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
@@ -1523,7 +1524,11 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		goto err_out;
 	}
 
-	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
+	/*
+	 * Evaluate the DACL in order (MS-DTYP 2.5.3.2) for every request, so a
+	 * deny ACE only denies and a later allow ACE still counts.
+	 */
+	{
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
@@ -1570,15 +1575,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 next_ace:
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
-		if (is_owner && !owner_rights)
+		if (maximal && is_owner && !owner_rights)
 			access_bits |= READ_CONTROL | WRITE_DAC |
 				FILE_READ_ATTRIBUTES | DELETE;
 		access_bits &= ~denied;
-		if ((raw_daccess & FILE_GENERIC_EXECUTE_LE) &&
+		if (maximal && (raw_daccess & FILE_GENERIC_EXECUTE_LE) &&
 		    S_ISREG(d_inode(path->dentry)->i_mode) &&
 		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
 			access_bits |= FILE_EXECUTE;
-		granted = requested | access_bits;
+		if (maximal)
+			granted = requested | access_bits;
 	}
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
@@ -1651,18 +1657,6 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		}
 	}
 
-	if (!(*pdaccess & FILE_MAXIMAL_ACCESS_LE)) {
-		switch (ace->type) {
-		case ACCESS_ALLOWED_ACE_TYPE:
-			access_bits = le32_to_cpu(ace->access_req);
-			break;
-		case ACCESS_DENIED_ACE_TYPE:
-		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
-			access_bits = le32_to_cpu(~ace->access_req);
-			break;
-		}
-	}
-
 check_access_bits:
 	if (strict) {
 		access_bits &= granted;
-- 
2.47.3

