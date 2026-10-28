Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168416;
	b=rxotEUM5jal7Q/iCvrq7euEaRGfCDqSf2BOfZZvp0v3ev0cIYxS602/zY7o1sPp3nZqa
	 RdHtWPqFm7wsnYfXoTlhRon3WUweMgeYEoIC1H8/N/2KmIr8YaKEx0shTIL4QnwV2vgWw
	 jqpEEKBzfgmJ/Y1pGU08HU7P7IRWtAJBAdhQdydnT1hruvnznGswRohxqMpQMmt6lyEMB
	 NSxBlLoX19VDLLYe4JopQpl3WqYd4gus6eywP+5uF3eXDJPCyhxhiECTaMogS1Dpq2C12
	 zBgBMRckc2Bit0BLNsXm7Lv1pmOUa5hlnAk31qSjrqAEPtYIs205rhwC673va5m6iDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168416;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:In-Reply-To:
	 References:From:Subject:To:Cc:Date;
	bh=m4IQ4Pm4PXxCZTpkciy1gGIzoMDodk3bBPfcnrQxOPo=;
	b=bGRRNhc5cfkhPUE4XiQJlZPqCcyadTfMQW1WTQ2+E1BDmkimH2Exgx3/LG+aU1xfyBzI
	 qzrqjjvIeKQ6Rn8YOPX3mgU4WIDjpGTDcsORqkdnerH6tOZSyRnrzkYq6NiEuUuth4A3u
	 HYGLPoUhcyiub1wsarHLkJBSeNZJO3m13NQwAdjs+hSRbBnKXNH8ElzGEsudmpwLKa8i5
	 cD1s6V5RdqRVu6RNkA7eSmF3ko6I6PWUM+jeoDr/GEWrX8ogQBuTXpIdnC6T380WCaWlh
	 zavtbFQU+VJ5t6aOQe25/MczSfyGj12pfdF0OvEl3g/VZTV7dC431t9kUqLVFX1KR2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=fail smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b="Fp/YcHl7";
	arc=none smtp.remote-ip=173.212.254.19
Received: from groupware.tuxist.de (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B78606A322;
	Wed, 28 Oct 2026 06:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00B78606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=Fp/YcHl7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tuxist.de; s=201705;
	t=1793168414; bh=2ps7K+buL0YkhooKtwBQxLEjTj8Kr5NqdgO0RcIHkik=;
	h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
	b=Fp/YcHl7+vJ5GksRMAHUYLVdIVfHvO932pv+MFW82l8LPmPI6VVs6ij4wkZYpTp4h
	 NUM7ddk5U1xhZx3aXTTl5PHRy/0Ii5Txmhf1csRX6oEay4MpUEWYVmgC9KehBxD17d
	 XAChyQZRhhc1j4P7cT+qFR38eyVFmFhlyY1pXv1zBp+9We2XMBi64MMCjYH+jAVfdj
	 L4FJGOlrAWCviso6Q8533TDYeAzWwNZ/dbwY5xnaUwZZ0ij9qKljpW6UlUecsDJ2on
	 IFr7OgRgpMZtciUxYMhTNK8WtM3QdY2y2zvC+5NadldZz9gRrSDKdcP02Yx70tJ7YY
	 xWnp4fS22s0Jw==
Received: from [10.1.1.106] (unknown [10.1.2.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by groupware.tuxist.de (Postfix) with ESMTPSA id 36AB58A09A4;
	Wed, 28 Oct 2026 07:20:14 +0100 (CET)
Message-ID: <0b04ce416d93dfe319363357931b474022bb6e8f.1793168155.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1793168155.git.jan.koester@tuxist.de>
References: <cover.1793168155.git.jan.koester@tuxist.de>
From: Jan Koester <jan.koester@tuxist.de>
Subject: [RFC PATCH 6/6] Documentation: uid_r: describe ksmbd's SID mapping
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Christian Brauner <brauner@kernel.org>,
    linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Wed, 28 Oct 2026 07:20:03 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

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

