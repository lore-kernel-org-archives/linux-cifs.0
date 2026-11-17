Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927011;
	b=3xjk/rnoruDD2ZX9xqMoy3kL3kW2F8oR67IsD8ni+oeHnbvafQ9pfE3EDx+3AhQzBSd+
	 DX5g6Tdmqc55lWvVmwdGXWX9suEZk0KFZJ0SxJUaiGH1yUhlRLvPRWsKL4RibD/A3qYey
	 n9H2BE6oQ/ms5nI8UawUPlhW0uv0/yLNj7AOhlT7Acrh8X/o0pc4mUnjNvgOXqqMNx/e6
	 5I+wNBJT/uThcpLN0Jk+NQGbwosTyHaSkAITPP0uOYDeyePCG45jqjbagqevEsyFG5hOI
	 L6Q2IJMu9vqqiZLM2jF6F+upE4XIrA5cZp4UQCKUcSW2MwHKFwx+WpPBQIhxZZ9Dwxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927011;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xZcMI80vkbrPSsjuRNnpfexDQWW5J8D26iu4OpFJ3Ks=;
	b=hV07iOmYGo7MEvBw5IQWGEcivpzxYjTrjl8LlkB5KWtmVndJJW8gwILt0CbXXdwjPBbr
	 oBtv3p4zw7ml9X6iZuawp8xWNklIxu+86VCrWq43njARe/IDNP6gFIeE7sdLRsSDJPl1x
	 Jbt757sH+2weNviISYqnCUunX7E3q0h/3Ak/1Tjp1jV+eXZCLaQzr4DOcgAVTXujd0GAb
	 oTKknhIfq0MYVhEYzERNGRI69CAs0eCi5QsGO31lqPeHhCsfORvbR1UzFPgLsu4ddOKMM
	 xb6SG8/rNKJPg1BgyffnSoN7w/EQPzBTIYtW76CFJqu5eBYboHXTzqC0aOpUjkL9OEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=apXMITRD;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Ng+X994s;
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0205606A339
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 14:50:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0205606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=apXMITRD;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Ng+X994s
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id DF392EC08B3
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 09:50:09 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 17 Nov 2026 09:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794927009; x=1795013409; bh=xZcMI80vkbrPSsjuRNnpf
	exDQWW5J8D26iu4OpFJ3Ks=; b=apXMITRDmKddTWnmpPeVfRSyfifJXLWbton7p
	bjrxP3iGs7SQ/KvOSuqHz8VHnKNRqgGFVaCK1I2qJmwx0cbZDqIH6yL6L2xWAV0C
	68fOLC88wI/mvetLQU5IdoboYeOAcbfEPftv9i7b0P9yaerOn6qBiygKJvYhNFHX
	MT6sJSn46coAkxcVIqOorr5fEPVcIRWwd5+YenVm+/YpMxkxyJDJGZd/HmgO5mlX
	93k3t27LCjl2hB0PubPogjvOvtqc5lue4p3QP95pfXo2/RvNts1v27Jyr1teaWx5
	2tcnKxvgxOXpnW+gqcSUQmy46pqSuQYct5Q0lXA1/jyyCuVuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794927009; x=1795013409; bh=xZcMI80vkbrPSsjuRNnpfexDQWW5J8D26iu
	4OpFJ3Ks=; b=Ng+X994sn88uSRfvQ4iNgAahigacaejavG2b1Q5XITSizvu7uW9
	00hv1hcwVZivLzTW5DlXYdQ/R4gX+WuxZUbTViqR098Tn3ewMeBerK0/Q7497KHl
	EvUjXQ4KUtRbraLF42skzIpKpweTzQljfXns5mp+32U2txwJV28ONcsAg6wRuckk
	vLpBnhmXSb3fa2EuHJyLgCV9vQwQEO8opOYBwbMGTLlk6w7bt0rRXUBuOdqn57pE
	L8EqqIRxfRCScOaxENgqdX9zEQ6gmATFxhip9wESssTMO2xlKCPARNeYlJwSirV7
	ZIaIXxKPkREO2LJpzzKsObNwFQLDgWl5zdQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794927009; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:h0Xjw/djvhVOsmP2q2DlUmUGuTxz3xeJEaIHdkDNusdAE5n
	YREzIuTAB1CQID+BT+ER5Nj1NbhCh0lRtbA2Gd/RXi9pYjws0afxnNsyFsDgdizv
	7JvFVCUvSoCnuYtvRDRJgdY2v2sO4wCk8Q9yrbBH7Vo8ssEQvq3+7XxSCwiM5I6l
	9d/qaoSxADjE4KneZuqvhAbGNx2AH17BF9+UcS9pVoTDyfczv/2PQjg9vBpgUas4
	iAI3xW3KQCln7wm4te0EucP/kS9nUetEBDh0Z04EQnaLlDltnCCzxyFh6A3uFouP
	EtM9fCkyun7SnejGBwnGWwyL80cfgEWKaOm8Xdg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:s1vYgnlYDBZT7u7R0PmJbmbP6TNgHOmorG1PkYF2pes=:NrSGhQ2L8Usbg0xHiRyq46LfCjp9A/xEvlmwa12Kqj8=;
X-ME-Sender: <xms:oWn8asOxZ6CdqvmyuoWOmnZn4TNJFuX7GIpE8mpqQlrPN9BD4yMxAA>
    <xme:oWn8ajpQT_6Nm4FnAIRG9zGZSxsxenQyn0ox4n02LFaaIcJxpAY1X9NIwpjcLDGJm
    NuRBQokr197h7asyunzslPLxXk5h9ujwBJJ0nGFKnIUCs6lc6wpGBM>
X-ME-Received: <xmr:oWn8ahcZBhNpgbzspqF5yWWBoduastEXloOx-jVs75WakrTEqH8ke1lZeh9_l1hO>
X-ME-Proxy-Cause: dmFkZTFlkzG3C+xQNkiy52LhTtmSDdbD5pvVz2yNNzVQq5HZ2kh8/C9ETKvP0bbwnMUWBv
    WU+aiQhjnVDxyXzILp9x61q3jWtLUYglZcTBVrMHoM64PA07s8Rr/PlJQMXdYjEACz/bSV
    J5sd/3Xef7uYN8auEwXxjOcHqAkgC8cTRVdJ/6+kaS7htRI+VJpj9yto3DWETl0bfTB2Fc
    MoGRJAciEMuHbTJHVK9P57t+6bAlFIZ82ZXrFwx0S0DuCXK+aQn3S1d7EpGTDowGeRgK9t
    UhzptvLBIRI9EX8VYcVTBmFTYIldiL9pX1SQY1CZqsv1S7nQCRiF6z+terab9h+/dTuHiO
    VZJB8N56JYBWy7U41+FU7zVa/pQV9Vy4PIP7mMFFDPSMAo0xFHvJwLpZtRARxsV/896bsd
    60FtofCojEhsUJGlM3caDCPcUZ4oooSAbtJbt8jOb2aomgTSZFL6TF+nJ1vR4ttiDifDyY
    xoeuBp6dRhA4tKMtq+q5g7p6PFzvmcIQXUPIbY6JdfvID4eivpqbzKreoGw85ZNaax/rrk
    oaRveFYUzPhM8qobGqj1++/csod1SJC1A8fKok4GIIdYAXtuEpbUrP3QgtelZnN0j0ZjRg
    bZ07M0VsOdQ3UdgHAnmZRpCslTT4S+rSf4XC4jBlHbK0YZqux/vSBwB6sEJg
X-ME-Proxy: <xmx:oWn8apS4pPn4fCVlDwgs9lzlbX2O23u6lwFSNpiw8HV0JOdrPbRXrQ>
    <xmx:oWn8aqbqQT0uyxP0reBpkO5F9LmTsXo84boBo3TruGFGiPwubWCltg>
    <xmx:oWn8ascHUyHFJhs11DE7K201-apBrlHvBwwiYUPEYovwPOXFCjRWYQ>
    <xmx:oWn8arLXVxpzbuVl_CiTz9pndsQQN3-S9iaSLPHTwrb_zZjY-j4Zmw>
    <xmx:oWn8agKXh1UljBs6CcnRLnKd1CJut8hGOdcAxk-CjR_ROYeoAmvO4oef>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 09:50:08 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: do not log a stale security descriptor as an error
Date: Tue, 17 Nov 2026 08:50:05 -0600
Message-ID: <20261117145005.2638107-1-icb@fastmail.org>
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

ksmbd stores a hash of the file's owner, group, mode and POSIX ACLs with
each security descriptor. ksmbd_vfs_get_sd_xattr() recomputes the hash
when it loads the descriptor. If the two differ, the descriptor is stale
and ksmbd treats it as absent. That is expected after a chmod, chown or
setfacl on the server, but the function logs "hash value diff" with
pr_err() every time.

Opens, security queries, hide-unreadable listings and inheritance
can all load stored descriptors. Repeated opens of a file with a
stale descriptor can therefore fill the kernel log.

Report a stale descriptor with ksmbd_debug() instead, and include the
file name in the message.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Tested on ksmbd-for-next c1a783037082 with KASAN. Opening a file whose
stored descriptor is stale no longer logs an error. With SMB debugging
on, each open logs the new debug line. smbtorture results match the
base.

This patch was developed with LLM assistance.

 fs/smb/server/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 1114f2503ea7..83b0bf783886 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1829,7 +1829,8 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	sha256(acl_ndr.data, acl_ndr.offset, cmp_hash);
 
 	if (memcmp(cmp_hash, acl.posix_acl_hash, XATTR_SD_HASH_SIZE)) {
-		pr_err("hash value diff\n");
+		ksmbd_debug(SMB, "stored SD of %pd is stale, not used\n",
+			    dentry);
 		rc = -EINVAL;
 		goto out_free;
 	}
-- 
2.47.3

