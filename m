Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154AC224AF2
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 08:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790409750; cv=none; b=Z1b9/T+oAS/A8HrcyhP1w295GarAbziuakTqa7mqlRJKpZcaD2rYJA5hev+yc22W6Nn7V8jAreJE3+m0FX3/cMnLrXltgeyvWBI75bOiE7sVpBDUWifEhr21Lq3OznP/8GEQeYfkCFUqrIxF3fgE1KKouqUq50T/ZKSxkOoDnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790409750; c=relaxed/simple;
	bh=JO526X/6Tt2mXMMyzxnEn8I9inabf6bHTO7ljFpjf1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gu0UNNbpXqJd+I10iwR3YQq1bUeDEI0o3DFl2QiLXKcrOsYqRVHCe2z2ekKqflxpOAkoEOJt3mD+KH8+m1RlxLJcML8FToFd0w1jMtN0NJFltexj47v2coRr24H8qHvEIr6t019F+3tmIGMeKU/7Z46j+M8NY3ERffYoxGW8jSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wnq4v0xN; arc=none smtp.client-ip=74.125.227.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wnq4v0xN"
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0dc47fee0so185287a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 01:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790409748; x=1791014548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1QOIpORY6Eh+rWA+8y7RMDhGXP2bTeo70K5JN02r+40=;
        b=Wnq4v0xNOWnDzD4ZSQiZqv41jmnb5WS2fguemQMuW9BI+zbaJnKuZbcq7owA81vEs2
         ugD0O99tUvkVpNy+uZRG2Tk4rcCTUYEmWGZPZwo89vP3eij5tt1tW2S6gE2w5MjlVgSQ
         +wcHFzHJZ2ql/8IU6PIJUDWiUOAvp9ZJ13DKVBpQyuwpH7Gz3SCcBKLHrrz9Tu/cQb/o
         niFHrCeQXtu6AHSKZgirdkMb6Ccaf1KsIQtcojUoUZ8JTPV3SPD+PrExAcoflAIwWiuh
         TFbVlzx45m6ZdD76zBFUAHnyKZht/qS+mynkLPsbxADZ/tYiljY11SJoEepFsQyd99jN
         fLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790409748; x=1791014548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1QOIpORY6Eh+rWA+8y7RMDhGXP2bTeo70K5JN02r+40=;
        b=QXEv55tvOsZpNKkJmOVS1SROFs9Tf4qbWpA1ZlORw5AqzRrPp1QgattgnSZX23eOlp
         lug4MPb0eyMzkmFlNrEljdV7aNvacqQRu53TvMe80kgoZ0/lOxSy7Szwap8F3xYuK8rQ
         1oHK4kyyU66+j+F5+GIGtsMP+9yQTSXGky4O+oEeMzVydNgalCRDR5rVrdIqiKbz2p9T
         YTUv7sXQkyvBuoPSb+NvGoEvcY//lVFSTQv0H3yj3C81UNCudnsy4ZeuY0EBgPjpdKbW
         GdM8msbPdykKV2g473wwDfu53feq33PxmQvjC1GCeEaERELp04QOEa7la+R9DTNfRepR
         EmMA==
X-Gm-Message-State: AFq9FYLLFMNOhAT5e3hGSjgL00jt+fEpEtA2G55S/Mg/gSGB74h88Viy
	E/Lq7nVGkCSxtBtMue5z8JKCdwtepdzHVYia1/KEc6okwsLtn8Kxhm97hceKAGZLB4o/TQ==
X-Gm-Gg: AYBFou1a3iML9S9f9Ton8QfjzrYagU+keo2h6ayxgZWK6pyn4CHE/k00MMkvbXQD0j7
	tQDQ92Mtj1QUHpJVcquvOXd1B6iDkxA6TUxuPf8hYA21CCTd+fsBam5RBlrIiBGuLWHBD5qf48U
	KdgaEfLS0Zuza0hsJOJ0+8yI5epihQ/jBWhgZ6am3K3FXuT0wI51xSuToVndn+lnssr+Cwp1LGj
	kgmGxW5FQ4/NQRWWOmTcZO9QWIf9h0vKtXpd1yHKYbSJhW3sB2GPp+22KxZrba32gVRn83lyX3B
	nQQIm1sCzoUChbeDG6bs/kKsDAmAs1W7PTUtNvU6T4K8ZsSB8jA2gq787SFYx3CTxvKu6LfV8og
	5sRlKhBkjJ6dqj/7sWc0EhlPm3pmxeIuhP8hgmVszjLKVEnDl3MOVctTQfO5qtc1kaEMatZh2wg
	tAVTcL6gZ842umPWNkVUijj2d8isaq7Mn4cRQEGxfp2u+WKGEpdpKfYXMZ/6m7vd7uY3RL01s=
X-Received: by 2002:a17:90b:4c42:b0:39e:4c80:f680 with SMTP id 98e67ed59e1d1-3a098bb66d1mr7292603a91.31.1790409748275;
        Sat, 26 Sep 2026 01:02:28 -0700 (PDT)
Received: from localhost ([180.184.92.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9355e54sm8355171a91.5.2026.09.26.01.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 01:02:27 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Dairui Zhang <zhangdairui@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: verify transform SessionId matches the decrypted header
Date: Sat, 26 Sep 2026 16:02:24 +0800
Message-ID: <20260926080224.1671214-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The decryption key for an encrypted request is selected by the
SessionId in the encryption transform header, but the request is
then authorized under the session named in the decrypted inner SMB2
header. Nothing compares the two, so on a connection carrying more
than one session a client can have a request decrypted with one
session's key and executed under another session's identity. Since
encrypted requests are also exempt from the signing requirement, the
AEAD tag is the only proof of session identity, and it is checked
against the wrong session.

Per MS-SMB2 the server must verify that the SessionId in the
transform header matches the one in the decrypted SMB2 header and
treat a mismatch as a protocol error. Compare them after decryption
and drop the connection on mismatch.

The check only applies to plain SMB2 payloads; a compression
transform payload carries the session id only after decompression
and is left as-is for now.

Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
 fs/smb/server/smb2pdu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4cf7083..e4cfbe6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10890,6 +10890,22 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	if (rc)
 		return rc;
 
+	/*
+	 * The decryption key is selected by the transform header SessionId,
+	 * while the request is authorized under the session named in the
+	 * decrypted inner header. Per MS-SMB2 the two must match; verify
+	 * that here and drop the connection on mismatch. A compression
+	 * transform payload carries the session id only after
+	 * decompression, so it is not covered by this check.
+	 */
+	if (((struct smb2_hdr *)iov[1].iov_base)->ProtocolId ==
+	    SMB2_PROTO_NUMBER &&
+	    le64_to_cpu(tr_hdr->SessionId) !=
+	    le64_to_cpu(((struct smb2_hdr *)iov[1].iov_base)->SessionId)) {
+		pr_err_ratelimited("SessionId mismatch between transform and inner header\n");
+		return -ECONNABORTED;
+	}
+
 	/* Drop the AEAD authentication tag from the inner RFC1002 frame. */
 	memmove(buf + 4, iov[1].iov_base, original_msg_size);
 	*(__be32 *)buf = cpu_to_be32(original_msg_size);
-- 
2.53.0

