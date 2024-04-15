Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493022E83F
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 07:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167278; cv=none; b=pwJgMZ0AdBCh6F+/ZSix6bTdfnKReZSZPc9mwQ5P1cbtoyljVHIVwOTl+gyd6Ji4a84PBEKuoQf5QjwNcWofKZqE4Jg1+ol/wIJLKQ7ACPZb1QCLfWRDq3PQs4vy8EMS6AE96hv77eI42IgLa6ezP2sjTQaz1Q7IKvJRZ/4/AJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167278; c=relaxed/simple;
	bh=9IatEviYhS2luzBbrGx3L04KVJ7F62NEknoj5G7BurY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=WKwu5wraCSZiS+w2txD4ZTkKdYoPFIraxpZbuNIZjA/EJnSIwACGF8fcKlYaWOeUXhoO/uuM4C10f5UpaC1DdGJrisdVxFevOiNVHDNr7zzZpkps39n/ttZWdcBpRMlvGh+QuEbBrm03AiW8VSfp7UEDWTbWZgCKOP2x27+TDgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7HIcyJ/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7HIcyJ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713167276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1cNSMGKUuSYp4mOn/xs8/bRq/9QYJDWeod7dfRVhzw8=;
	b=Y7HIcyJ/igVvr6/kzyde6racnu/fjRduU1y63MTGFLqiuwEGPBH+Ey/U8wDQ6Jjo5I8Fwv
	XkJSUTcocfaf0iWSp5O/6x5ncxQSYDiqbR22rMsKY/3A0phzosNibGg825n9o2NUWZGKko
	8GbqAIGAaueEtY0BVWKPQpf0OTHC2ME=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-5WtRQS6mMj6Y3CKHAGCyWw-1; Mon, 15 Apr 2024 03:47:54 -0400
X-MC-Unique: 5WtRQS6mMj6Y3CKHAGCyWw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-78ee46449aeso51316985a.2
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 00:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713167274; x=1713772074;
        h=content-transfer-encoding:cc:to:content-language:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1cNSMGKUuSYp4mOn/xs8/bRq/9QYJDWeod7dfRVhzw8=;
        b=J10gTOilW/An4+sqZrNMsy8kKVbyq2fPGoNsVxVw6YKweXIlfTdj5J9OSI7SZXj9+t
         szR7b85uYRYdp9ycS2yFk8zhnmG1HHGTVXUciiKqyCkEIqO3a8bmGQDnbQvW+wSVsaoA
         /hEmBIVgsqfepbsXw2bDLqBa48kPu1elUmBKN5l8fOeTyOvTgVA5nBUWkXr7m8rJk/r4
         uxZQIGihJOJH+hJinqemXJ+Is44/Azv9xJQ7siwKej59Ix63BfeuWQwABu3dX/fSqpM/
         l58xz7mQyXUf3+1/7oOA48eJulaQisRQ7it48RyyX4PIxPKk2wvGjrYad5FEUZxsF1xI
         J5Hg==
X-Forwarded-Encrypted: i=1; AJvYcCUj+0jPQvvISwS2drWZVwtdLhvT9Ea/hiv+O2/i2OfhH1ZyRY4DS9jfkAHoLNCV9GUaOo4OQrS5A3Muccm16HrmyFsc9B+1Rp7hSw==
X-Gm-Message-State: AOJu0YzHtI3PDeA1tfy/TSsuyY2NXP2HuIBqIc7QEAq5N8HgAA9/8uKk
	e96IFmHC2gEF6rIAUW3XLqH3zScbTs9R6Q2DcBaYP9Dp7yIRYMsiRzuri7diGBI1mSLa3tLBodS
	bfu20iABouYiCbYPkHeBYacsHoxjYB0N8gBWBuSiujx8MS5eyFUURJg4UGx8=
X-Received: by 2002:ae9:c207:0:b0:78e:5148:b04f with SMTP id j7-20020ae9c207000000b0078e5148b04fmr10300924qkg.61.1713167273971;
        Mon, 15 Apr 2024 00:47:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHg5fqW6s8pj1NPtj1wMNWczGTHUNXl8r5Fn3MOkX7UMkVNm2rNWd4KD3xLeAkkFdf0OxsvKw==
X-Received: by 2002:ae9:c207:0:b0:78e:5148:b04f with SMTP id j7-20020ae9c207000000b0078e5148b04fmr10300911qkg.61.1713167273633;
        Mon, 15 Apr 2024 00:47:53 -0700 (PDT)
Received: from [192.168.100.225] ([133.32.172.110])
        by smtp.gmail.com with ESMTPSA id g24-20020a37e218000000b0078ede0c25b5sm2229775qki.23.2024.04.15.00.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 00:47:53 -0700 (PDT)
Message-ID: <f34949c1-4180-4ede-950d-ddfe2106e640@redhat.com>
Date: Mon, 15 Apr 2024 16:47:49 +0900
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Takayuki Nagata <tnagata@redhat.com>
Subject: [PATCH v3] cifs: reinstate original behavior again for
 forceuid/forcegid
Content-Language: en-US
To: sfrench@samba.org
Cc: pc@cjr.nz, lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 tnagata@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

forceuid/forcegid should be enabled by default when uid=/gid= options are
specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
changed the behavior. Due to the change, a mounted share does not show
intentional uid/gid for files and directories even though uid=/gid=
options are specified since forceuid/forcegid are not enabled.

This patch reinstates original behavior that overrides uid/gid with
specified uid/gid by the options.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
V1 -> V2: Revised commit message to clarify "what breaks".
V2 -> V3: Introduce forceuid_specified and forcegid_specified variables
          to identify if [no]forceuid/[no]forcegid options are specified,
          and it is used to allow uid=/gid= options with noforceuid/
          noforcegid options. In addition, add notify messages that are
          shown when uid=/gid= options are specified without [no]forceuid/
          [no]forcegid options.

 fs/smb/client/fs_context.c | 12 ++++++++++++
 fs/smb/client/fs_context.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index bdcbe6ff2739..4698667e25a7 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -745,6 +745,16 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 	/* set the port that we got earlier */
 	cifs_set_port((struct sockaddr *)&ctx->dstaddr, ctx->port);
 
+	if (ctx->uid_specified && !ctx->forceuid_specified) {
+		ctx->override_uid = 1;
+		pr_notice("enabling forceuid mount option implicitly because uid= option is specified\n");
+	}
+
+	if (ctx->gid_specified && !ctx->forcegid_specified) {
+		ctx->override_gid = 1;
+		pr_notice("enabling forcegid mount option implicitly because gid= option is specified\n");
+	}
+
 	if (ctx->override_uid && !ctx->uid_specified) {
 		ctx->override_uid = 0;
 		pr_notice("ignoring forceuid mount option specified with no uid= option\n");
@@ -1014,12 +1024,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			ctx->override_uid = 0;
 		else
 			ctx->override_uid = 1;
+		ctx->forceuid_specified = true;
 		break;
 	case Opt_forcegid:
 		if (result.negated)
 			ctx->override_gid = 0;
 		else
 			ctx->override_gid = 1;
+		ctx->forcegid_specified = true;
 		break;
 	case Opt_perm:
 		if (result.negated)
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 7863f2248c4d..f559ed252cee 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -164,6 +164,8 @@ enum cifs_param {
 };
 
 struct smb3_fs_context {
+	bool forceuid_specified;
+	bool forcegid_specified;
 	bool uid_specified;
 	bool cruid_specified;
 	bool gid_specified;
-- 
2.44.0

