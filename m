Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A012772D
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 00:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776643916; cv=none; b=MTNjv3Ij57EpMQ/VjhNc7I27NGJde6QOmYSFilMa1ie+rhxNd0kuWFhvMfWLXSj378oKMIL9w5ZvkLylUg+REzUoyC13EgFyfD1aGY+lGfjSlEY+HbrtUaJijN+2Au5+BxK+q2mlzJKPuS89aDA7yVTQ+FZ064+Eza1Nv+EobuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776643916; c=relaxed/simple;
	bh=J0TaXRSUoiYBKYMpUV1WlkKcXmHlIrtK82jnx1iaS8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhvoMhtfU2gKwkyLCsIDMNHSEAqPpsd8p9h/5lrt2x8oCsQpGL4LmQiU+sT27BRcWzuu7MiqXmH4QB4F8mb7cp2QHwNTS8Ow+mFg+BeUU0EaaE808FdWD8+8Hh9ARnb4YbRlAKR2Nz+TxgR5NIpuCtoYWgSz/zYMhsB/AY0Dyeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+kuI2uw; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+kuI2uw"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8d428da4300so273103085a.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 17:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776643913; x=1777248713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xQF2kYy2mawb58IYNylnXRWgmSB/uAYm2CtIu/gV9E=;
        b=a+kuI2uwbQXvOGkzTWXIcL9ln2Y+lrEuhnYVur2heeY5ZBwqj+De3+VXEPSNgWarvc
         NGmJpIFL06FiJXo/+6DTYsWrRq+wUX2ZY5CAv8fiDvy2n1+DRaDbPjDZd7AMQJfDStqR
         rZC7+WS8FOYY6UWIvIu7VZV1DsGDi/x96rhT6zc8PcUO0HU7TUAXis1z0wL5MwFkZWy1
         vUDS82Pw6IB9ykhygoQuRpwWQyaKf6fN4SWGtfovW/ayfz5r2W+Ty3O/OFjCO4dsJA6s
         RdZ6xRtz1ZiXuoH0zpmxX0So8HAXBAlUJsZ8zf4dDPQVZsoHa0obuQRy5+qIJk4I0A+n
         OkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776643913; x=1777248713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7xQF2kYy2mawb58IYNylnXRWgmSB/uAYm2CtIu/gV9E=;
        b=PKMwM7P1l7FK34HCWaNNqfYj8MZ4qq5HB6Dj/pz/lT6QpCPZxbqNTIh5aldteMGUCl
         Y5sT7qFn1e1QvBubPqCMO7n0z5sryRPuf4rOZyx1JVymmR9XmmEaxCqi6ed7Vh8QOjRz
         1IMuuQWifJKJ6iZ1JQZQXOB/v5ah2XgiIoYXnvV5JVsg1bFcSBhVsmt/yhgSAqhb4LWC
         2x7tpWm3RttyeduEYWHvvMf3Q5Lg7YAEvJid/KaXYDS0tRda3wmTUPZH0TSpbHHCR4aG
         FAZjFhQSs1M/dEeP9veLlD3xxCC5xvj8ISDqNG9ZYj1/CnYe8Mt5kmKlbmdiQV6vb3Wf
         dQDg==
X-Forwarded-Encrypted: i=1; AFNElJ828dVxkBUwtBdzIMFZMg8Ofes2HEJzUeO5reydZxwnDwe99x/EGuapzesLb67/xiSbNg5R0O+a/qf9@vger.kernel.org
X-Gm-Message-State: AOJu0YyjKkIaxtHs9gV/2ByLXHd/uzPgvlNwxVKCT7d3Lm5/2aH7TXMV
	TF2zklsFhZCcPUNT56FE5544Z9NdAbEwdaXZwCbBuWu1jYd9Idyn+MFo
X-Gm-Gg: AeBDiet09lLfSuy3cBm8nliEDRccAn86pVQomdENENKe0ZcPh8TF/j/f1B6dFVh89pw
	TS0I5Pl6CXyO120hS2XxByN6YLtC7ENK2Bny8k6PSFGC0KxQk9MJBS6zbFAqr3gjTU5y9CtAFGl
	8BmVxLiOUiv9QEp0ddmUujyysx/qX1aCYqUYXbURGeCEPLSMX7RJmsv3OeMqx6hH/vwEdE2GgY5
	bW0d8FQc1rObpWp6XB8+PQVKNxulmSKuF9DyP5m7QO6R8PSqYDGl0NgyHIxIFYz50sUb9nqWAEf
	zNngP2KPPvwrGj8FlZw2chLzmwrElD82Tsgm9mwBko7hDk9EuCACyvMPB4Z6vUg/WByWTjQ6oyN
	9fsJboD3jlfibYKzOORbxT/09YGzu8CQe7bX9g3J3moPjtn4N1gyHBSBeCVn7RYJ1yEGXS4NF21
	JGQg2/OrTscJrjuh48nj6uMzCnmokUwH3FkzmCZNxHNHN1A4zrgiaVhJPS5aolx7hGunoLfed5H
	TgusfvLOYqTqXXZhBEKUTnHhrFes3c=
X-Received: by 2002:a05:620a:2914:b0:8da:cfe6:c67c with SMTP id af79cd13be357-8e7918a348amr1630968185a.28.1776643913509;
        Sun, 19 Apr 2026 17:11:53 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe98dcsm697020185a.7.2026.04.19.17.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 17:11:52 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] smb: client: validate the whole DACL before rewriting it in cifsacl
Date: Sun, 19 Apr 2026 20:11:31 -0400
Message-ID: <20260420001131.2865776-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416193325.2950619-1-michael.bommarito@gmail.com>
References: <20260416193325.2950619-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

build_sec_desc() and id_mode_to_cifs_acl() derive a DACL pointer from a
server-supplied dacloffset and then use the incoming ACL to rebuild the
chmod/chown security descriptor.

The original fix only checked that the struct smb_acl header fits before
reading dacl_ptr->size or dacl_ptr->num_aces.  That avoids the immediate
header-field OOB read, but the rewrite helpers still walk ACEs based on
pdacl->num_aces with no structural validation of the incoming DACL body.

A malicious server can return a truncated DACL that still contains a
header, claims one or more ACEs, and then drive
replace_sids_and_copy_aces() or set_chmod_dacl() past the validated
extent while they compare or copy attacker-controlled ACEs.

Factor the DACL structural checks into validate_dacl(), extend them to
validate each ACE against the DACL bounds, and use the shared validator
before the chmod/chown rebuild paths.  parse_dacl() reuses the same
validator so the read-side parser and write-side rewrite paths agree on
what constitutes a well-formed incoming DACL.

Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
Changes in v2:
Validate the whole incoming DACL before the chmod/chown rewrite helpers
use num_aces or ACE contents, not just the smb_acl header fields.
Factor the structural checks into validate_dacl() and reuse the same
validator in parse_dacl() so the read-side parser and rewrite paths stay
in sync.
Reran UML synthetic build_sec_desc() tests and confirmed that both the
exact-end dacloffset case and the header-only num_aces case now fail
with -EINVAL, while an empty valid DACL still succeeds.

 fs/smb/client/cifsacl.c | 116 +++++++++++++++++++++++++++++-----------
 1 file changed, 85 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index c920039d733c..cb4060ba5e31 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -758,6 +758,77 @@ static void dump_ace(struct smb_ace *pace, char *end_of_acl)
 }
 #endif
 
+static int validate_dacl(struct smb_acl *pdacl, char *end_of_acl)
+{
+	int i, ace_hdr_size, ace_size, min_ace_size;
+	u16 dacl_size, num_aces;
+	char *acl_base, *end_of_dacl;
+	struct smb_ace *pace;
+
+	if (!pdacl)
+		return 0;
+
+	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl)) {
+		cifs_dbg(VFS, "ACL too small to parse DACL\n");
+		return -EINVAL;
+	}
+
+	dacl_size = le16_to_cpu(pdacl->size);
+	if (dacl_size < sizeof(struct smb_acl) ||
+	    end_of_acl < (char *)pdacl + dacl_size) {
+		cifs_dbg(VFS, "ACL too small to parse DACL\n");
+		return -EINVAL;
+	}
+
+	num_aces = le16_to_cpu(pdacl->num_aces);
+	if (!num_aces)
+		return 0;
+
+	ace_hdr_size = offsetof(struct smb_ace, sid) +
+		offsetof(struct smb_sid, sub_auth);
+	min_ace_size = ace_hdr_size + sizeof(__le32);
+	if (num_aces > (dacl_size - sizeof(struct smb_acl)) / min_ace_size) {
+		cifs_dbg(VFS, "ACL too small to parse DACL\n");
+		return -EINVAL;
+	}
+
+	end_of_dacl = (char *)pdacl + dacl_size;
+	acl_base = (char *)pdacl;
+	ace_size = sizeof(struct smb_acl);
+
+	for (i = 0; i < num_aces; ++i) {
+		if (end_of_dacl - acl_base < ace_size) {
+			cifs_dbg(VFS, "ACL too small to parse ACE\n");
+			return -EINVAL;
+		}
+
+		pace = (struct smb_ace *)(acl_base + ace_size);
+		acl_base = (char *)pace;
+
+		if (end_of_dacl - acl_base < ace_hdr_size ||
+		    pace->sid.num_subauth == 0 ||
+		    pace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES) {
+			cifs_dbg(VFS, "ACL too small to parse ACE\n");
+			return -EINVAL;
+		}
+
+		ace_size = ace_hdr_size + sizeof(__le32) * pace->sid.num_subauth;
+		if (end_of_dacl - acl_base < ace_size ||
+		    le16_to_cpu(pace->size) < ace_size) {
+			cifs_dbg(VFS, "ACL too small to parse ACE\n");
+			return -EINVAL;
+		}
+
+		ace_size = le16_to_cpu(pace->size);
+		if (end_of_dacl - acl_base < ace_size) {
+			cifs_dbg(VFS, "ACL too small to parse ACE\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 		       struct smb_sid *pownersid, struct smb_sid *pgrpsid,
 		       struct cifs_fattr *fattr, bool mode_from_special_sid)
@@ -765,7 +836,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	int i;
 	u16 num_aces = 0;
 	int acl_size;
-	char *acl_base;
+	char *acl_base, *end_of_dacl;
 	struct smb_ace **ppace;
 
 	/* BB need to add parm so we can store the SID BB */
@@ -777,12 +848,8 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 		return;
 	}
 
-	/* validate that we do not go past end of acl */
-	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
-	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
-		cifs_dbg(VFS, "ACL too small to parse DACL\n");
+	if (validate_dacl(pdacl, end_of_acl))
 		return;
-	}
 
 	cifs_dbg(NOISY, "DACL revision %d size %d num aces %d\n",
 		 le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
@@ -793,6 +860,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	   user/group/other have no permissions */
 	fattr->cf_mode &= ~(0777);
 
+	end_of_dacl = (char *)pdacl + le16_to_cpu(pdacl->size);
 	acl_base = (char *)pdacl;
 	acl_size = sizeof(struct smb_acl);
 
@@ -800,35 +868,15 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	if (num_aces > 0) {
 		umode_t denied_mode = 0;
 
-		if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
-				(offsetof(struct smb_ace, sid) +
-				 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
-			return;
-
 		ppace = kmalloc_objs(struct smb_ace *, num_aces);
 		if (!ppace)
 			return;
 
 		for (i = 0; i < num_aces; ++i) {
-			if (end_of_acl - acl_base < acl_size)
-				break;
-
 			ppace[i] = (struct smb_ace *) (acl_base + acl_size);
-			acl_base = (char *)ppace[i];
-			acl_size = offsetof(struct smb_ace, sid) +
-				offsetof(struct smb_sid, sub_auth);
-
-			if (end_of_acl - acl_base < acl_size ||
-			    ppace[i]->sid.num_subauth == 0 ||
-			    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-			    (end_of_acl - acl_base <
-			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
-			    (le16_to_cpu(ppace[i]->size) <
-			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth))
-				break;
 
 #ifdef CONFIG_CIFS_DEBUG2
-			dump_ace(ppace[i], end_of_acl);
+			dump_ace(ppace[i], end_of_dacl);
 #endif
 			if (mode_from_special_sid &&
 			    (compare_sids(&(ppace[i]->sid),
@@ -870,6 +918,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 				(void *)ppace[i],
 				sizeof(struct smb_ace)); */
 
+			acl_base = (char *)ppace[i];
 			acl_size = le16_to_cpu(ppace[i]->size);
 		}
 
@@ -1293,10 +1342,9 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	if (dacloffset) {
 		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
-		if (end_of_acl < (char *)dacl_ptr + le16_to_cpu(dacl_ptr->size)) {
-			cifs_dbg(VFS, "Server returned illegal ACL size\n");
-			return -EINVAL;
-		}
+		rc = validate_dacl(dacl_ptr, end_of_acl);
+		if (rc)
+			return rc;
 	}
 
 	owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
@@ -1662,6 +1710,12 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 		dacloffset = le32_to_cpu(pntsd->dacloffset);
 		if (dacloffset) {
 			dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
+			rc = validate_dacl(dacl_ptr, (char *)pntsd + secdesclen);
+			if (rc) {
+				kfree(pntsd);
+				cifs_put_tlink(tlink);
+				return rc;
+			}
 			if (mode_from_sid)
 				nsecdesclen +=
 					le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
-- 
2.53.0
