Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115443;
	b=k1BzDHohLcDxjGo3e1dW91VFRoY3hs0q2+tKOXnfGaAqwqA3op9Arwxi+dydeOgJCh7/
	 43NIrcGA9wO6cZ+UGfNCpfeKv3BOWhzwG+ELSKZHUBw5AqKFwUvSDXHmY3S3DhDWqDd6S
	 XQXEU+SZjMrBGNBYsEBt80DpJtPM25NsNd9mgRy6mE+bgUqnBGDUiNa9tJCtF88H4Hjkk
	 4y2zisNoaAfFmknf0EiWn2VuwrMfR+DAKjP+5930WjwyBuWRfYXmTU95/o0HoHUwKHwZP
	 OmstvO5EzIIPr18p+nQ6QDyHqNhVsaKwd5Z2mfp6R0/ot7ExdvsIv7kuCeEuTBeKcnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115443;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QhS3+5ZWFz6FmTqcuqu7zzkTtZ4CAdsfKAs5TGkgHgU=;
	b=XpIoLNo9n67Yo17/fzeNlTY5hi9FRLPG/ydCNnlSjtPE00Nqwh67SqC8v0aNGD99Rm5Q
	 oIF2zgGWkX4BAvF0w9705936ErB2GqccP2s6OHlyh8dUd9eeQP5KqAykTyelppXSTtrBu
	 mu8+qn3+lA5OL674aVC+Dns/4fgYfdk0zXtTJ2EBV+HFEbn649HCzplrdzBcUyPpCBMRG
	 e6S6mRXhbBVBXgeNso+6JmUjPnp7ylDtiTClkl4vp1VBOYLQweHvZY9HrF1RZropAf6Ct
	 0RI9AbB3pqkg887Ii6nlZAKyWa/sHwXliKliT4Tb+dDHrp+I5TQfGc/PRSwtBNFslKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ZNzHW0nW;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RdwjBXeA;
	arc=none smtp.remote-ip=103.168.172.144
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A6606A335
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 19:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 348A6606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=ZNzHW0nW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RdwjBXeA
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 55DE4EC05AA
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 14:10:41 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 19 Nov 2026 14:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795115441; x=1795201841; bh=QhS3+5ZWFz6FmTqcuqu7z
	zkTtZ4CAdsfKAs5TGkgHgU=; b=ZNzHW0nWAAfboU8EyKQwwgw1uQks0clxMbXAf
	9VIyKmBsupWzAbiR1OQ1MsyBmleCW7qMR6u4MkkNIpOejcxoumhYPlblXXNmGxK8
	BvvqBJs622jDLLTtejIkRTqEvAQgjfApgsMYcht/bllL64xsEHHxlv+5m2PNfLZD
	/Yq3HC+12K1ZhtFCtiyydxIcXtThxVgF2pUjx1nZaBXHe8sPVd2tl/C15bc+1kiG
	1Usw9hulVGMClOt4Rrj0jOM0mbBl8pova78yU2mdjaiaT0OumpLRWMevOmPIVsT7
	O25jS8lU3n/gvqhJ/PsOaKFB3DoO4wBWpj/WZQLoECwIvqGHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795115441; x=1795201841; bh=QhS3+5ZWFz6FmTqcuqu7zzkTtZ4CAdsfKAs
	5TGkgHgU=; b=RdwjBXeAofrvIM3iV5eVbF7DfiEvObND7GwRBVljJ2zUvaKNHJ5
	T7RAcbZWQIZfLh8/i6Ii4nNnZr4ToYUORgXYReTpv6DNvf1pP9rtSbTm9CNMCIsm
	8lVD9WTEZbvy3wDPKMmQF4SU1q0RnWclQBlqLI7BU1CcYbgNFDVMLSR/DVln5E5K
	NtJNa0gcWrlxodydwWapFIMulahvJhB79dXCZtcxQyXAmCr1OHiKSER5R4ODU7dY
	IHLsmO8Mp+iEjBHpP9VGwGiKNoG1Jvy9kuwtZDLatQCPHY7cr4J/Am4YGswsSegk
	IJC7DI0t8/mhyJyalgesm+30IgF2vALeGjA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795115441; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:jF38uomELZCGgNepln7eAAe91D0FTJBjJ5cGVdaq9GS6Xt4
	olvgsXYJxCqSyxxNWSwYYRgWkLQP2IZbD3JhRPPAgx02ax+NmHIhEYdVjQsqAMiG
	AKg9TCGAbvzJdhmo9q5JFsXQgjd7ATaHB6vQftySNCN0hKsZb0m6SXEpIf3jENPt
	MsYwZCVHQvjM0wS9K7y+S0fzfkPkHu+dfHJ56tN+UXX/d8D9W4yitrsAXL4D1dVf
	Ioij1+dMkBmCr5zMUw1rGonmtc95ogO6bZgaMavYm8I/yCOkorfIvd2lY/MwHDoi
	ycqtqzTFUgRtUfPPmIsTHWVgcEYF9IroLT3WyuA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:wlB2svHdKyZa1viQV5vX71PPiuMCapCRlfsHesGu8zs=:9fqV3LrC0at5NyGG27h8nb7q9IdGyAW/RBSfSqamxE0=;
X-ME-Sender: <xms:sEn_atjXM_dSoO7dM3vRa_wm0JW2PjMl2BpJ3oeF0GiBSITZLvO5uA>
    <xme:sEn_aoxH4qINCH6s9Uz0c7JuC5mkkO3jzt5WzQnkOJR83m_9Yl-OdTjJMjOwm5HVX
    VePdaCjbtNlGN7OgZgEUIigf2Ha0KxhLioORJ_4jF4XLjBmxqCWhR71HQ>
X-ME-Received: <xmr:sEn_au0eZDY7xi-csq2vmSyqHUSW79Tw-Q_mjW9ML-skeOLfgA6eRPw1I8est_Q8>
X-ME-Proxy-Cause: dmFkZTGUt+/3QKC1CH1vRfgQM6ezMSGdit/xsisMl79bbyGJuqdQRHAHbQ0xVFcvlX2FwK
    Pyg0tyLLdzZ3sF9Uwqa2uCeuhpqdFrJroejVz/rwAKhVxzQKf/zf1WIoRSHDe5ZcAlP2sN
    c6SsS0w3zV9GKmXzZz1vNFcCPgjlN8DNVJbAMuxyJ3iTj9wFLB9gRYJ8ptfNackdAaflN7
    p4RNzDS2YwDjD4JPWnSquPXlzz9lPTIka6YJPjkFzVNP+P9gX0If7erpvBIA5hcvVcK8oQ
    Lmv+VxNNcwNX/nfqxzOLsKvkixmdluwg0yrI0kYfkj/F+8SpujIfimcbJCPVriKKyYHYsn
    5gYei5oi7C/PcFBQAKita9XQh72RgG2Af+oQJp+plQ9vwbmbZ6jFlaQHnNjV+Zi/qkCIic
    eEicZF/7TdZbljaxuqXWqB4BatOub8NWpK0erAgje5GzYo6eU15HYWXvsMQ5symtvfGy8o
    Pkbow55yktakEp0C2RpWhi49bfrLxWJF1fpGG48J8TscxhNJSZtHoD6f3SLzZjkur/5mRs
    zcC4AUkCPR5HgX1yNQc6HaBJfjelx7E8zRmclj9uEr1S72Y1fQCLd21GZDa1IdHzHYN/kq
    as64TPHNvwXvVGFMoijI3UzO1np3c6HcNacZyX20xGHxbhvvsDbQTcDAroPw
X-ME-Proxy: <xmx:sEn_at_tA6wh6FVM1UuXlNQU0DiOOptAyHLUjge3QFfCq9f_mcKrcg>
    <xmx:sEn_ampXg37vyS3pUlhZR1V9_q3B40tUZuTCO5LpYvmRnsDjCz1LbA>
    <xmx:sEn_avSjreEGNleRkSrGaiqBPXyJ9Z79kwB8190m0IZDJ0B2JbRTIg>
    <xmx:sEn_ahO9zeZ6xeyXqqugg3s1cOow10loBbvV7ojIIjgg_q1fmpCdZA>
    <xmx:sUn_aiwF_bYQYNIRIgU5mN9DIpev5DSDM983oLEcYigvAku1WRdUouho>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 14:10:39 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: compare the whole SID when adding POSIX ACL entries to a DACL
Date: Thu, 19 Nov 2026 13:10:36 -0600
Message-ID: <20261119191036.197225-1-icb@fastmail.org>
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

When a query returns a stored DACL, set_posix_acl_entries_dacl() adds
an ACE for each POSIX ACL entry that the stored DACL does not already
have. It checks that by comparing only the last sub-authority of the
SIDs. A POSIX entry is then left out when a stored ACE for another
principal ends in the same number. For example, a stored ACE for unix
group 1300 hides the POSIX entry for the user with uid 1300, so the
query does not show that this user has access.

Compare the whole SID. A POSIX entry for uid 0 is shown as S-1-22-1-0,
but sid_to_id() maps the domain SID with RID 0 to uid 0, so a stored
ACE with that SID also counts for it.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Tested on ksmbd-for-next 4616bbc5389a with KASAN. A file whose stored
DACL has an ACE for unix group 1300 and whose POSIX ACL has an entry
for uid 1300 now shows both in a query. A stored ACE for uid 0 with the
domain SID still covers the POSIX entry for uid 0. Queries of the
other tested files are unchanged. smbtorture results match the base.

This patch was developed with LLM assistance.

 fs/smb/server/smbacl.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 2651214c939a..03d771ea6676 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -628,6 +628,25 @@ static int parse_dacl(const struct mnt_idmap *idmap,
 	return ret;
 }
 
+/*
+ * Whether a stored ACE is for the principal of a POSIX ACL entry. The entry
+ * for uid 0 is shown as S-1-22-1-0. sid_to_id() also maps the server domain
+ * SID with RID 0 to uid 0, so a stored ACE with that SID counts as well.
+ */
+static bool ace_is_for_entry(const struct smb_sid *ace_sid,
+			     const struct smb_sid *sid, bool root)
+{
+	const struct smb_sid *dom = &server_conf.domain_sid;
+
+	if (ace_sid->num_subauth == sid->num_subauth &&
+	    !compare_sids(ace_sid, sid))
+		return true;
+
+	return root && ace_sid->num_subauth == dom->num_subauth + 1 &&
+	       !compare_sids(ace_sid, dom) &&
+	       !ace_sid->sub_auth[dom->num_subauth];
+}
+
 static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 				       struct smb_ace *pndace,
 				       struct smb_fattr *fattr, u16 *num_aces,
@@ -646,6 +665,7 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 	pace = fattr->cf_acls->a_entries;
 	for (i = 0; i < fattr->cf_acls->a_count; i++, pace++) {
 		int flags = 0;
+		bool root = false;
 
 		sid = kmalloc_obj(struct smb_sid, KSMBD_DEFAULT_GFP);
 		if (!sid)
@@ -656,8 +676,10 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 			unsigned int sid_type = SIDOWNER;
 
 			uid = posix_acl_uid_translate(idmap, pace);
-			if (!uid)
+			if (!uid) {
 				sid_type = SIDUNIX_USER;
+				root = true;
+			}
 			id_to_sid(uid, sid_type, sid);
 		} else if (pace->e_tag == ACL_GROUP) {
 			gid_t gid;
@@ -672,8 +694,7 @@ static void set_posix_acl_entries_dacl(const struct mnt_idmap *idmap,
 		}
 		ntace = pndace;
 		for (j = 0; j < existing_nt_aces; j++) {
-			if (ntace->sid.sub_auth[ntace->sid.num_subauth - 1] ==
-					sid->sub_auth[sid->num_subauth - 1])
+			if (ace_is_for_entry(&ntace->sid, sid, root))
 				goto pass_same_sid;
 			ntace = (struct smb_ace *)((char *)ntace +
 					le16_to_cpu(ntace->size));
-- 
2.47.3

