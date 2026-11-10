Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301410;
	b=gcQ6nz+weW9Vmj1P5p29E6qgVQyPO8ZygSUQx/E1rSZyjNTBTFCuLNazshqFsL2aXXtT
	 TkPT1KEVVeqGKKUWcVbKbMbsbFUSW/hvqApG2qQf2/ld2GxlBg2jYyvWjQuvJ0b3xNPNi
	 iDhScNG0sW2E1XcMIMZRcT3BLLI5fIxGB1AFnAx+babsM/bwGBsmmHxGZ0goKkZUkOugO
	 3o2L3Pm4LLF5RT51zUTOOdwXPilrLeJ6HtgPFXxUCZYgWRnR0cfjJOJlop2vnEPlwuayZ
	 pZgVfhTy0EtZXvsOWiD8vUwXloKBuNmywrTc2/NBd8e5yNjKb4S4q9CCqFe2Xd4wZTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301410;
	h=DMARC-Filter:DKIM-Signature:X-Virus-Scanned:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=m4IQ4Pm4PXxCZTpkciy1gGIzoMDodk3bBPfcnrQxOPo=;
	b=cvBj/zfQVSoaP3f19nk9ZBuYzi7vW+K3lDcm8TbhSq1ibNIfmTXqX237ignU6Kcs9J8K
	 tPtMm0fQ+/tqKyJwLSmVrR3AkFY94Dm6Cb+rbyRsutXpjOzn9DpZCM+PJHvv0x/snskwz
	 UN8eUOyuyunF1zH6pvL5bc/rQRfaUk6+h4t06Y3jb9b1Z2gzY3t/GLfoYiQApFa7qlYL4
	 QQ+M3drj7ZO2BwjkPo+FG114br80L6ZJdmRKKwdJ5/2lF79xorjKeBlSmBZyiQbQsl1Tm
	 CW95R+SZqyhd41TgDGOeD9E9mL4zl7zfDMp5u9HuQJ+zslK6X+hN6hu4DWEWcveMgKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=pass smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=GiwVMABM;
	arc=none smtp.remote-ip=173.212.254.19
Received: from proxyplus-primary (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BDA606A32A;
	Tue, 10 Nov 2026 09:03:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64BDA606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=GiwVMABM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxist.de; s=201705; h=from:to:subject:date:message-id; bh=m4IQ4Pm4PXxCZTpkciy1gGIzoMDodk3bBPfcnrQxOPo=; b=GiwVMABM9vCnIEw3DlNLPgWYSRt7q9rhVS7QxzIFbILinN3KB/kBVGye0drO846NdBnbqcvo7q0Q9guD9RTKBpZ6IfRK/SkaYAelWPnvsCx/9spVTLb7WYfiJlz6S27wd5qEK/KG8O8SLRBUBIegg3dyo4UMurDqx0a1ycpHUEyCrU9uzH3w0L5Ng7AnjSmwOaxjcDoSp35vrpS1oDUfXfkphbpMwRMavBhhZIQrf2751CCUAgXt63YSgDgK9DMKGNtHnCy0rdTpSdYXOAShTMEe0EcwgDU1tJHuXpcTt9I9uxERvIT44w10HqvGsqoCHJ+n/Pj3NgolOQcxWKRiqw==
Authentication-Results: proxyplus-primary; auth=pass smtp.auth=713ee033-d4f8-4c9d-9e24-a891eb9c547d
X-Virus-Scanned: proxyplus-clamav builtin
Received: from groupi2 ([10.1.2.46]) by proxyplus-primary (ProxyPlus) with ESMTPSA; Tue, 10 Nov 2026 09:02:48 +0000
From: Jan Koester <jan.koester@tuxist.de>
To: linkinjeon@kernel.org, smfrench@gmail.com
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, brauner@kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/6] Documentation: uid_r: describe ksmbd's SID mapping
Date: Tue, 10 Nov 2026 09:02:57 +0000
Message-ID: <ae30e40693d0f8b9f21a27e0@groupi3>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Name the SIDs ksmbd gives classic users and groups, and describe
KSMBD_EVENT_SID_MAP_REQUEST: what user space is asked, the caching and
what happens when it can't answer.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@tuxist.de>
---
 Documentation/userspace-api/uid_r.rst | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/userspace-api/uid_r.rst b/Documentation/userspace-api/uid_r.rst
index d16d4317f5..2e887c296d 100644
--- a/Documentation/userspace-api/uid_r.rst
+++ b/Documentation/userspace-api/uid_r.rst
@@ -167,7 +167,23 @@ SMB (ksmbd)
 	groups appear in security descriptors as
 	``S-1-22-<kind>-w0-w1-w2-w3``: kind 3 and 4 for a UUID user and group,
 	5 and 6 for a GUID user and group, w0 to w3 the 16 bytes of the id as
-	big endian words.
+	big endian words; classic users as ``S-1-22-1-<uid>``, classic groups
+	as ``S-1-22-2-<gid>``.
+
+	A user space that sets ``KSMBD_GLOBAL_FLAG_SID_MAP`` at startup is
+	asked (``KSMBD_EVENT_SID_MAP_REQUEST``) for the Windows SID of every id
+	ksmbd shows as owner, group or ACL entry and for the id of every
+	domain SID (``S-1-5-21-...``) a client sets, also for accounts that
+	are not logged in. A mapped account appears with its own SID (e.g. a
+	directory's ``objectSid``), others keep the SIDs above. ksmbd caches
+	mappings for five minutes and "no mapping" for one; an answer user
+	space couldn't give is not cached: descriptors then show the SIDs
+	above, and setting an owner, group or ACL that needs a mapping fails
+	with ``STATUS_NO_LOGON_SERVERS`` instead of being applied in part. A
+	domain SID that maps to no user (as owner) or group (as group) is
+	refused with ``STATUS_INVALID_OWNER`` or ``STATUS_INVALID_PRIMARY_GROUP``
+	rather than ignored. A session's user matches ACL entries naming its
+	own or its groups' SIDs, mapped or not.
 
 NFSv4
 	Owners and ACL principals that are UUIDs or GUIDs travel as their text
-- 
2.56.0
