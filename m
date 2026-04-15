Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7682F2D1931
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776252323; cv=none; b=pamChB/ALMi2G+VqmPBIAN5dXK/PnTJt6EhZuDPfxfxAnv0FpvuL3OpXSsnQKFIy2BHUdag0D/RMjcMZlj50q3qX/pNJAN8tTaQFY5CXkX6NWtj9lO53Ua2tK9uimLhVmuxzC3iiZfDi6IeT/N6in7dhw5ebgeLtU7ggEzUrnKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776252323; c=relaxed/simple;
	bh=U5CI1dkHZFucrf1FtoI0iIBoTcbsjPIrp1ozHF2ILDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEHFgm/57rf+QxulE2hO1SvPYI8cwhe3DW+5ujnu8b1uOVFcmpDQCE0k58n3TJs4qrwl0IkevABk0H8+Db0SIL7t1Od2VcbtbPHV+8k69EHzvC2Tq6VQmF1DXUooMtn4Xd6IzpO6dwH3ZkA1+/I9+y4JOJKugcyKA62qXEbdHV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diaIpdD7; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diaIpdD7"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d876329bbso69217051cf.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 04:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776252321; x=1776857121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJ7blFUvJD3xjZodcquJvVuRqv0FWfvmqE9ECTkmuRY=;
        b=diaIpdD7PJZCVVUdkz47Bvbnl/9i6EqWNx4TEdt1M21S+sElexqNmmpSlHHbGC9212
         4rsRFEDGrsj8h1XLlighPrI0uG+0MMZ6W1wLpe9+ZBnp/nM2IaQjO4bmJFvXV+QA/BEm
         K1+mZooyELk7t6nHyUp7jHBB9bw9YrphScFzrdyNU2SaEVAIi5lNWeAEv9iQSAa+jEeQ
         kAsTxmSstf63eWc9Adf4twsFHUjI2ok+aPlnF2Fq7lz9nBJkfmC6ORd9KVn58iK4BTtf
         e5PFZ/Ci51IZUorchkyyePUeI4PAqSka7dTLHlA5yFrNfK4+3R+83B4FwW578uih/usU
         Da4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776252321; x=1776857121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PJ7blFUvJD3xjZodcquJvVuRqv0FWfvmqE9ECTkmuRY=;
        b=h9tQQL9DhpLlJ+/vrP0eYhjfwFIVj0/Vqwjjc7RQqR5m09tQzmBHM+bLszIkAzoWCM
         M9embEx8+j1FRzO4yxrcbR97ug2qPoRnnH6EA76SSNwQuG58NbwUMZYBAr1HnFfRYX4d
         JsyxX9UmxglHaBVcdNKZGSwi1xIR7V1xeybgVBq9JLUlWomTjFog0JS/JG0jusOxSb17
         kZkt8Yak07ImHM9zJubJjc/i8FRgrXQPaMDqDTpt1SugDAGXgo4UZ8hZ0HfJjFQanDvG
         QZ7tDLXvFFPxAefK8JK8mS8yEJ4be0qxYS7A9G467qphGza7ZaR2kpk2ONHw3SPWdWT+
         RFJw==
X-Gm-Message-State: AOJu0YwAyHvL0PmUP6r0su8jMzC9DW0HlOo1P9FtFlt18+wbAa3RcaCY
	wLo7MVAZkelDqkVULsnKGco122dkUa4AQqjEcYhqe1wfoXEguAgSmx2MeoP55Q==
X-Gm-Gg: AeBDievcKncocaFLw2ZjQCnfPhxQ++B+rEaQAgMUdtZJHE4Zo/YHV0Gy5wJx/5LPq5M
	TdrZwPRB242W4EfUsvFj6jlChxBbdRc9D2aUnETFxHD3ca8QULFdli8RKXkJEJCvAfvYTwuNL1B
	kr+xqUwwsJwEcPhfdZjQqxJJ/KSuk9sEv31YY/BwLMSxTfn+/TU7HE16jFe7L6i8+xxxlwXrl4K
	IL9TGQWWeybDGNmfH2CpR481Kzbu6GhJA4RRP29A/nNrLYObW1KBb8MoJCYW1+UL5qnRcEMkSJ1
	rwufZWGJF3ZVRmbAqXnTCUyUmKgN/piahQCuUhhjua19x8BRPjKo5Vqr8pR5gdHK1EXOzpDWdLo
	LXBRJF/YkroKEFgNonxqEGNe5V/LcJ87r11+efEDhguBxaouTqomncJC0NBPEWYdwA7hai7YVur
	OKOBzyLkQa+fYU1NLfDIh+xifoSBkuFhGe4Fv84GX0g/8y87yxKg12E3YYPuiKLEHvWlsy04XRw
	ZTnt6L2bJ27CktkYIgLbi57HRVrnO7Ap7784NGc00CKI1xpUOhL1Q==
X-Received: by 2002:a05:622a:a945:10b0:50b:5336:1d20 with SMTP id d75a77b69052e-50dd5beac96mr247328681cf.53.1776252321175;
        Wed, 15 Apr 2026 04:25:21 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1af9dc5fsm10621191cf.16.2026.04.15.04.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:25:20 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] ksmbd: require minimum ACE size in smb_check_perm_dacl()
Date: Wed, 15 Apr 2026 07:25:01 -0400
Message-ID: <20260415112501.116426-3-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415112501.116426-1-michael.bommarito@gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com> <CAKYAXd9EBFBcy9bJ3=sJiYVYHAYjKYqOqD53UCJ8zWKXF0sAeg@mail.gmail.com> <CAKYAXd8B78Gde_7+Ph0cSL998k4qqs_okB0jky0m5h8i25_AGQ@mail.gmail.com>
 <20260415112501.116426-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both ACE-walk loops in smb_check_perm_dacl() only guard against an
under-sized remaining buffer, not against an ACE whose declared
`ace->size` is smaller than the struct it claims to describe:

  if (offsetof(struct smb_ace, access_req) > aces_size)
      break;
  ace_size = le16_to_cpu(ace->size);
  if (ace_size > aces_size)
      break;

The first check only requires the 4-byte ACE header to be in bounds;
it does not require access_req (4 bytes at offset 4) to be readable.
An attacker who has set a crafted DACL on a file they own can declare
ace->size == 4 with aces_size == 4, pass both checks, and then

  granted |= le32_to_cpu(ace->access_req);               /* upper loop */
  compare_sids(&sid, &ace->sid);                         /* lower loop */

reads access_req at offset 4 (OOB by up to 4 bytes) and ace->sid at
offset 8 (OOB by up to CIFS_SID_BASE_SIZE + SID_MAX_SUB_AUTHORITIES
* 4 bytes).

Tighten both loops to require

  ace_size >= offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE

which is the smallest valid on-wire ACE layout (4-byte header +
4-byte access_req + 8-byte sid base with zero sub-auths).  Also
reject ACEs whose sid.num_subauth exceeds SID_MAX_SUB_AUTHORITIES
before letting compare_sids() dereference sub_auth[] entries.

parse_sec_desc() already enforces an equivalent check (lines 441-448);
smb_check_perm_dacl() simply grew weaker validation over time.

Reachability: authenticated SMB client with permission to set an ACL
on a file.  On a subsequent CREATE against that file, the kernel
walks the stored DACL via smb_check_perm_dacl() and triggers the
OOB read.  Not pre-auth, and the OOB read is not reflected to the
attacker, but KASAN reports and kernel state corruption are
possible.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/server/smbacl.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c30d01877c41..d5943256c071 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1341,10 +1341,13 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = acl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-			if (offsetof(struct smb_ace, access_req) > aces_size)
+			if (offsetof(struct smb_ace, sid) +
+			    CIFS_SID_BASE_SIZE > aces_size)
 				break;
 			ace_size = le16_to_cpu(ace->size);
-			if (ace_size > aces_size)
+			if (ace_size > aces_size ||
+			    ace_size < offsetof(struct smb_ace, sid) +
+				       CIFS_SID_BASE_SIZE)
 				break;
 			aces_size -= ace_size;
 			granted |= le32_to_cpu(ace->access_req);
@@ -1359,13 +1362,19 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = acl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-		if (offsetof(struct smb_ace, access_req) > aces_size)
+		if (offsetof(struct smb_ace, sid) +
+		    CIFS_SID_BASE_SIZE > aces_size)
 			break;
 		ace_size = le16_to_cpu(ace->size);
-		if (ace_size > aces_size)
+		if (ace_size > aces_size ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			       CIFS_SID_BASE_SIZE)
 			break;
 		aces_size -= ace_size;
 
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+			break;
+
 		if (!compare_sids(&sid, &ace->sid) ||
 		    !compare_sids(&sid_unix_NFS_mode, &ace->sid)) {
 			found = 1;
-- 
2.53.0

