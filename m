Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795116014;
	b=JYDhSSFoqGHjlOWElP0/lvAq3Jm1j+BlHAu6PYwyHGaDNadi0o4CtEJXqIn6/2kMnUq6
	 6g18inve/lDWbLhQody44Tl4t/hqaTOzANxKE2ZBivbO0LEM7x9TU+GDQ3L6exfdl08a0
	 /0fI8+Frzlg4/5UAJeg/Kq3tIC1ZX4SohxhXx24PB0Ie+42SFQbN6ywhst0Gu8HFJeUnU
	 uW15g8attJ2b1mZHWnmJnxDMwybssWPYoST/vXeqWO9Bug0osxwOJSBrA8qQpZT/QaFdG
	 AfL/GdYBaulDWzAxzNnylTN3ZFdlGy9CIO1uz4gpx95lWRGHVUdeF0HHkH6TKqJPLug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795116014;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wv7me2iXP1ImG2ZXWpCgdwR4YIJXXEoQFMyFT5W6z7U=;
	b=Xb3Y2KAWr90p/wkz/1sIzS0a9Aj8IQSOT4reYYDwwfeatCq6rBU/FQqazYJ/b6zwXgvp
	 eCdUE4tgWswlq9NOxYFW7hgd3Fhn1UE4Nwpd+gtmEJ5S+1NY0xB+d+cl15Uky+gOsXwxo
	 gCNK3k/94i5EKwV0/cDW3dBSciWGNHtfdNLNUmPr4V8gbEr+Ov+VZSn+o1NPQkzU6fRst
	 PqbBnm/YeKRUTyVIGSw/dnfW28Iy55Y91hXeQIiD7uyyslyzGnfKsp8eRy6aF4zD/ftRU
	 7UPlwYPAkJVAeeCIRPOvRHWzIFTB06dZps33QQh16HxIe8+LM/hFuUXN8UBNTyCNEIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=EEtF43TB;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gwjgHzxq;
	arc=none smtp.remote-ip=103.168.172.152
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05DF606A333
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 19:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F05DF606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=EEtF43TB;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gwjgHzxq
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 29D121400134
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 14:20:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Thu, 19 Nov 2026 14:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795116012; x=1795202412; bh=wv7me2iXP1ImG2ZXWpCgd
	wR4YIJXXEoQFMyFT5W6z7U=; b=EEtF43TBjzSpeHxCfsKHqoXa45GBv6uujSzyt
	FpZKeJ8Qp3VznuEIQZ6UEChndhF+zIitokFGlCx/lF1TKMRYrKKUUPQdxOFv85NG
	iMMb5sFxX/k9ihtAaIpLiZc67PyjEQ2/SvM+CvfVbSizHsExC2F9JRRJ3zXFzzA5
	8sdZBHCm440npapH2L8xVP42BLbFIRTwJutYSRNxzSUA7JSpXpGQQwz3ZDD8MogD
	qe4CfYxdBI7ut3/K2a+F1p4RvlKpF6WnLQ+s9GKVhv3SiobMYm0gwyeRrCRzyb3z
	MbUOog/z+Q0ND83Ncbm1bypUdgyM1pjUrV0EDM+XE+zLZm0hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795116012; x=1795202412; bh=wv7me2iXP1ImG2ZXWpCgdwR4YIJXXEoQFMy
	FT5W6z7U=; b=gwjgHzxqYeSmMRp/YXcvlsrFWwg5uF25GRY3FGwRUNbwKXxXRHg
	6iNLKi0XK3egLIKeCNefaRD/cE3Kvs/Kj1Aol1lq+CQA9GTzT1sx14IeZ+8iB1gf
	/RuVPfVQM8LN6F+WcdwosxyoJ/OLwOFRHLSOMv3JqNSTXj88yle1FC3f1qP/k0xR
	rtRlfSIDB46itymBta6DtMlqYimb7wFJ7S5X8BPBM14b3vH7Vy3n+np/bO3SCxw9
	+NV4TWohCpg985mjlXrOo7XXkZ0spksJsJitHhc2Nxe64Za8nZBAaERSidMSER+T
	tylSNe5Khao4hb7/2Onfw3fmbV7pWctvLDw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795116012; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:TCuJkLxbAQ87TUpeeuYFEPei/OkMfsydCnwoaPkwdRN+oSQ
	EhI1hLrdITjFj+oyRlldULSypUvNRUPsTJZwq2rprMDwoK3ULRljQtxkLVkJOxaw
	GBidqyc9swDgNQEvHQzovmLfMJgNWxJ85/wFACrX/QvwfHBEUUhqdTQI6XB+KbEo
	Q2y7JE0OJANruuo8rhB517w6Mhkr2QEyxB/OLxMH9RyhMgF1ClBislpb2NTvbZYA
	CoaaEjiVEhfWx/RP/zu2y33uexjLpRTBGFyD6iAtwjXVtd3N+auIjj8qCNdGIEfP
	x0kg199Fr0KyN18qioWWdgHAntGsECp42hYgTFA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:cCXQDtsYhX9arB5JmmB736+eZy7+msVDW6enYqxI8Wg=:fI0NJ3/HRVLGu5s4IgwZ+FTffuBVVGh/zT8k622NL4c=;
X-ME-Sender: <xms:60v_al1SxSlRAeFrBInsHSur9D6gI88iuGjt9O8XxHV6Yo5Tjm_4QA>
    <xme:60v_ashVYbYQlu5hCi0Qn2JyTCbb05AMONGz7u1yoMWOftW06Nvbg4iWNBA2Ng0z9
    u2j62ZzqetPNxfEMbJ8xLSPDX92kBEyNPugRujNj7iGWgecATfjbDkw>
X-ME-Received: <xmr:60v_amky6mcHCboDAKOAEOSJ9FodWfiDkZryhD_vydWwdREc8iuj0HuFIZ9Avr8n>
X-ME-Proxy-Cause: dmFkZTE7ccEftIdaGzVvEpGNmivS36tOWNZGwhj8tgj0iJ07c4smmDRo9eupzB7KMMdZiN
    l3KpTGbIBZhMB9aejkW8W+RalTvIhfoXfhP8KtoUTaO/FsBESMcxD0Nreo43qO5Yz831qa
    KVW/RZO1in3c3hmxKXl2lwj9TucIRXCVWVk5GgXkD98PkYflXp2LeHzpKUduTBOzC2x/uh
    3ArJu+YBYedh0C820GTKXw2Im3Kdqp0AABTemwbl4inATJQ85J7nAMqDRG3b6f34fSV3vD
    KsgyXd+rLEbS0UCL3gpME6ZsCsRlLVPNA1DuXZHEpLTEnrELK8lWfBXwkQryF7evlz4lGV
    QrwIHQ23DZ5RCXk8zXebBrhdIZ4E//drwi2nFoWAOG0BZZdJwD4KCIbYlmZLADaeWuUOob
    WsV2MC3hQ+5PKO74PzjIH+KjGDfNqMYDkIQtZA7urcb9tnjskKAUXUU84JN8mPsJSL6nzb
    oXt6eK+0YZph5wH1QjV+kJ00TxIfK+kW8n8ZIwxv6bf2cjg4U1WBIkmmgBETEPValzcLIJ
    CdJakkWsj2vkHRpEq+PGQLCBrs3QvLa3LZ81Po35rEVpLEn4MNzNe4sBmP7Bk3K1KRbIh5
    NE/JcGt9M/3HijQiCX/8nkdEWvVqsMwq7beBHTtxqHmhYP0kTgCx2zYVzpdQ
X-ME-Proxy: <xmx:60v_aqazmaYyEs5pvnLCjU8-HV_v75ngsgVhaTx7_tE0Fx7GtbTNNw>
    <xmx:60v_apHahgvLbIsZAQpt9onXmbhvL7VjQE4aNp1kdLjwaL6HQ37ozw>
    <xmx:60v_ahZX6nwhe3UlfFsZHamcktmlTq7jwaOZEVy4pTc_L86R8B2i7Q>
    <xmx:60v_alywanIkQ0UGdCJzYqTo-F26to2ADgqyaOyewabQP2H70vLtSA>
    <xmx:7Ev_ando-lwvPNltHdhxeehhXvSFixEmuYtugRj2TlMiCdoFQUnJZqVZ>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 14:20:11 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tristan@talencesecurity.com,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: count the ACL header when bounding the DACL size
Date: Thu, 19 Nov 2026 13:20:07 -0600
Message-ID: <20261119192007.198258-1-icb@fastmail.org>
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

set_posix_acl_entries_dacl() and set_ntacl_dacl() stop adding ACEs when
their total size would no longer fit in 16 bits. The 8-byte ACL header
is added to that total afterwards, so when the ACEs take 65528 to 65535
bytes, the DACL size wraps to a value below 8. A POSIX ACL with about
1800 entries is enough, and tmpfs and XFS can hold one. The security
descriptor built for a new file is then stored cut off before its DACL,
and a query returns DACL_PRESENT with no DACL, which reads as a NULL
DACL.

Leave room for the header when bounding the ACEs.

Fixes: 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16 DACL size overflow")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Tested on ksmbd-for-next 4616bbc5389a with KASAN, on tmpfs. For a new
file whose POSIX ACL has 1819 named users and one named group, a query
now returns a DACL of 65516 bytes, which leaves out the last ACE.
POSIX ACLs with 1800 and 1820 named users give the same results as
before. smbtorture results match the base.

This patch was developed with LLM assistance.

 fs/smb/server/smbacl.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 2651214c939a..86a59878ae87 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -628,6 +628,18 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 	return ret;
 }
 
+/*
+ * Add the size of an ACE to the size of the ACEs in a DACL. Fail when the
+ * DACL with its header would no longer fit in its 16-bit size.
+ */
+static bool dacl_add_ace_size(u16 *size, u16 ace_sz)
+{
+	if (*size + ace_sz > U16_MAX - sizeof(struct smb_acl))
+		return false;
+	*size += ace_sz;
+	return true;
+}
+
 static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 				       struct smb_ace *pndace,
 				       struct smb_fattr *fattr, u16 *num_aces,
@@ -685,8 +697,7 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 		ntace = (struct smb_ace *)((char *)pndace + *size);
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
 				pace->e_perm, 0777);
-		if (check_add_overflow(*size, ace_sz, size)) {
-			*size -= ace_sz;
+		if (!dacl_add_ace_size(size, ace_sz)) {
 			kfree(sid);
 			break;
 		}
@@ -700,8 +711,7 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 			ntace = (struct smb_ace *)((char *)pndace + *size);
 			ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
 					0x03, pace->e_perm, 0777);
-			if (check_add_overflow(*size, ace_sz, size)) {
-				*size -= ace_sz;
+			if (!dacl_add_ace_size(size, ace_sz)) {
 				kfree(sid);
 				break;
 			}
@@ -746,8 +756,7 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 		ntace = (struct smb_ace *)((char *)pndace + *size);
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
 				pace->e_perm, 0777);
-		if (check_add_overflow(*size, ace_sz, size)) {
-			*size -= ace_sz;
+		if (!dacl_add_ace_size(size, ace_sz)) {
 			kfree(sid);
 			break;
 		}
@@ -798,10 +807,8 @@ static void set_ntacl_dacl(const struct mnt_idmap *idmap,
 				goto next_ace;
 
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
-			if (check_add_overflow(size, nt_ace_size, &size)) {
-				size -= nt_ace_size;
+			if (!dacl_add_ace_size(&size, nt_ace_size))
 				break;
-			}
 			num_aces++;
 
 next_ace:
-- 
2.47.3

