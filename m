Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF636605D
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046140; cv=none; b=V9dX9Bbsdfi2CZQB4c/o9qu7atPO8UHgXxX8aRp2jVeYpqsuMx7PoHZ3Q3h21VUbsX+dDwjVvk6NmX98VdZnsAYsLXPhanonI+2b2qgpnOsMD+hHYE8Eet0CDwyXXdYsC/kcWgKnJ0IpQco/xME0zCy66j5Zf8lNsvqBlELyBOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046140; c=relaxed/simple;
	bh=kiqBz4HJfCwS9x7IBn+x3Dm4sz8N+IzXM6ez8rucLGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d8/y1WVcZQZ8Oyc+quLVhZsv4cju/pm1gZERWfK/s9a17EH3IPdJQkEyyv8bfPvV2ZL2lUNDrKbHGy0KnnMJTGU70vj5eEeltay84/Xk7aolc1EZAsCM/JoKIwTIKc+m+y5uYY8zo+7swGSeEZdItWFE6YDzg7NDW4r6y3smyT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwL7dEnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwL7dEnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980481F00A3A;
	Sun, 21 Jun 2026 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046138;
	bh=8ATTGLN/7co6p3Wx8E02disp1I9SKulVeKNqnJxmqnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwL7dEnP/4nsFsgWMOsftmC9sL1bkgnmzTBUxAwgCls2sjAnslw1Hz/rd/KiYlP81
	 kVSN+C2GgKnslxjnk177leaoDktonqijSrOZFBGS0HTARaI++5ifLIgZU5sbOCSzDL
	 26ihMJ6CRhQBswHsqFFPkLHKB5BXTcEdahA9k6aeeb8UvWfApgMehCHTVx4U9Wcnfe
	 MoaMS5UrFOmYOYIVriIiqRdfYMAeyXAIAwCK4y7deELsJvRkHR6IYSAnDn29BaTbr1
	 ljMyJ6HddS8oW7V9cR/hi/hcM0IMqsrjWby95+U95WBcmH81q6UxRs7Tx/AnRRzRrz
	 Xw1w5es213lww==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 04/29] ksmbd: fix durable reconnect context parsing
Date: Sun, 21 Jun 2026 21:48:19 +0900
Message-Id: <20260621124844.6235-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB2 create context DataLength describes only the create context data
payload. It does not include the create context header, name field, or
any local padding that exists in ksmbd's helper structures.

ksmbd validated durable reconnect contexts by comparing
DataOffset + DataLength against sizeof the whole helper structure. This
rejects a valid durable v2 reconnect context because the wire DH2C data
is 36 bytes while struct create_durable_handle_reconnect_v2 contains an
extra four byte pad.

Validate the durable context payload length against the corresponding
payload member instead. Also keep the reconnect context authoritative
when a later durable request context is present, matching the existing
durable v1 reconnect behavior.

This fixes smbtorture smb2.durable-v2-open.durable-v2-setinfo, where
the durable v2 reconnect after SET_INFO was rejected with
STATUS_INVALID_PARAMETER.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f700f2f94ff2..35db86da79d3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2845,9 +2845,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (le16_to_cpu(context->DataOffset) +
-				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_durable_handle_reconnect_v2)) {
+			if (le32_to_cpu(context->DataLength) <
+			    sizeof(recon_v2->dcontext)) {
 				err = -EINVAL;
 				goto out;
 			}
@@ -2892,9 +2891,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (le16_to_cpu(context->DataOffset) +
-				le32_to_cpu(context->DataLength) <
-			    sizeof(create_durable_reconn_t)) {
+			if (le32_to_cpu(context->DataLength) <
+			    sizeof(recon->Data)) {
 				err = -EINVAL;
 				goto out;
 			}
@@ -2931,9 +2929,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (le16_to_cpu(context->DataOffset) +
-				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_durable_req_v2)) {
+			if (le32_to_cpu(context->DataLength) <
+			    sizeof(durable_v2_blob->dcontext)) {
 				err = -EINVAL;
 				goto out;
 			}
-- 
2.25.1

