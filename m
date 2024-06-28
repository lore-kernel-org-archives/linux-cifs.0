Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997E24B29
	for <linux-cifs@vger.kernel.org>; Fri, 28 Jun 2024 00:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719535176; cv=none; b=Pj5JM9rjHe+BWVhnxZIem3EPCM1MBEeZP1YRLH9wricc6qVo4LX3J8ezFoBDtlJZ7ZLP1jtJ3DlJR3/I9dZa9xPx2Al4YDg1qmXXk/ZvPJWhZeS/oyhHj062sYep4wupy1dz88XpHRajM93nx0L0dk0qfpXmw9OvhTl+o+7BpUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719535176; c=relaxed/simple;
	bh=k/GYj49tNHRu9Cr1Jzcr4L9WQKK7GhbiY7wTq6I033E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dyF0OhDwqS71CHX0igTj6fxRAu5CcnxnTkeK3mP6kXHvKf6i4sHNyY8Zm2Iefdurp8/mABtgByIR2jf/PLa5oE16xymYy8ncmdTC5/XitlBGiUFhHpu0lS2NrGjda7rB8GgkWQpt1C432GhDnsm5CTlr/Kspv8QwZi+uhSwDc2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BBAMSYpt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BBAMSYpt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719535173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L6lVI4UdpUrrU7t2THONNRQMSPsMiPCxjmcMgqZQjHI=;
	b=BBAMSYptzc+5ZhPpEgD3YZaabfh/Lms+FkkNQ8JKR6Lhl6e1KIcndXZOqUh5gGN2v4gUWw
	U5cS6PIGnuHExEiAHUaD5ReSVZGduqhFHOwOgpfdwPnCD7SPxYpe6ulMXtBZKJqzmXwsjZ
	n/Ck1Z29AODUKrzQkBQI4i3fMs7i91E=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-0p5u3bT7Oxy1xrK8gqHtnw-1; Thu, 27 Jun 2024 20:39:28 -0400
X-MC-Unique: 0p5u3bT7Oxy1xrK8gqHtnw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-37623e47362so1281915ab.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Jun 2024 17:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719535167; x=1720139967;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L6lVI4UdpUrrU7t2THONNRQMSPsMiPCxjmcMgqZQjHI=;
        b=c6BuC04N6YEUsUgDwbtUJp/raGGaLznQsTT0lMFWSNCZLjaL9pgP/N+3WkQFa0ieu6
         NQzxbX5us/iAFbrJcPVUqp9C5EAodsYfoxh1FYdOow0cne0xau2Rfukqnhe7r9zy8FeI
         M2wA0O7BNpE4XOc0d8zPpY+5+iDc6HPD66e2Ql/MPhH8J5EmCiYpzoAr2G1OeCvPeLIP
         B3YCOBNAyqQsK0BJ4rNua447rcUEm8GbdLmcXH6TQrx4itqTXsYI+5rGPp+JwkPRq2UY
         HWD8OmS9CyroxsKBUkCBnoula2ISExF+mhJMUpnTQAUzAJ9rla4fP9QPHl6l7w9RBJws
         Toqg==
X-Gm-Message-State: AOJu0YyQQwq2fKkFizapppSU6N6CYhkmGXL/6LWfpPfYTAhV5cmekZi7
	cPi+62uTOUe/29/YmhbbWzRatf/kvIgXqNdft7a2OO4xxGkJn7hhKDGJEtwJJpiXXhg2OjN3EKn
	UX28r7Oet0Hvos6Q/305PQ2d4XroUGLQOx6v/GewndfMxGoU7zvh8sDvNs7s=
X-Received: by 2002:a05:6e02:1b08:b0:375:be9e:34da with SMTP id e9e14a558f8ab-3763b0b4a4cmr217561765ab.2.1719535167763;
        Thu, 27 Jun 2024 17:39:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUkR/svSoWco43afklhPBsywxkUN6yiEPhjVFS6DjWiJxJqu6iv90RyIE35M2Q0SO3H2GPzA==
X-Received: by 2002:a05:6e02:1b08:b0:375:be9e:34da with SMTP id e9e14a558f8ab-3763b0b4a4cmr217561645ab.2.1719535167496;
        Thu, 27 Jun 2024 17:39:27 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-37ad29827d6sm1751535ab.32.2024.06.27.17.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 17:39:27 -0700 (PDT)
Message-ID: <2543358a-b97e-45ce-8cdc-3de1dd9a782f@redhat.com>
Date: Thu, 27 Jun 2024 19:39:26 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 12/14] smb: client: Convert to new uid/gid option parsing
 helpers
From: Eric Sandeen <sandeen@redhat.com>
To: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Cc: linux-cifs@vger.kernel.org
References: <8dca3c11-99f4-446d-a291-35c50ed2dc14@redhat.com>
Content-Language: en-US
In-Reply-To: <8dca3c11-99f4-446d-a291-35c50ed2dc14@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Convert to new uid/gid option parsing helpers

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/smb/client/fs_context.c | 39 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 3bbac925d076..bc926ab2555b 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -128,12 +128,14 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag("compress", Opt_compress),
 	fsparam_flag("witness", Opt_witness),
 
+	/* Mount options which take uid or gid */
+	fsparam_uid("backupuid", Opt_backupuid),
+	fsparam_gid("backupgid", Opt_backupgid),
+	fsparam_uid("uid", Opt_uid),
+	fsparam_uid("cruid", Opt_cruid),
+	fsparam_gid("gid", Opt_gid),
+
 	/* Mount options which take numeric value */
-	fsparam_u32("backupuid", Opt_backupuid),
-	fsparam_u32("backupgid", Opt_backupgid),
-	fsparam_u32("uid", Opt_uid),
-	fsparam_u32("cruid", Opt_cruid),
-	fsparam_u32("gid", Opt_gid),
 	fsparam_u32("file_mode", Opt_file_mode),
 	fsparam_u32("dirmode", Opt_dirmode),
 	fsparam_u32("dir_mode", Opt_dirmode),
@@ -951,8 +953,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
-	kuid_t uid;
-	kgid_t gid;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -1083,38 +1083,23 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		break;
 	case Opt_uid:
-		uid = make_kuid(current_user_ns(), result.uint_32);
-		if (!uid_valid(uid))
-			goto cifs_parse_mount_err;
-		ctx->linux_uid = uid;
+		ctx->linux_uid = result.uid;
 		ctx->uid_specified = true;
 		break;
 	case Opt_cruid:
-		uid = make_kuid(current_user_ns(), result.uint_32);
-		if (!uid_valid(uid))
-			goto cifs_parse_mount_err;
-		ctx->cred_uid = uid;
+		ctx->cred_uid = result.uid;
 		ctx->cruid_specified = true;
 		break;
 	case Opt_backupuid:
-		uid = make_kuid(current_user_ns(), result.uint_32);
-		if (!uid_valid(uid))
-			goto cifs_parse_mount_err;
-		ctx->backupuid = uid;
+		ctx->backupuid = result.uid;
 		ctx->backupuid_specified = true;
 		break;
 	case Opt_backupgid:
-		gid = make_kgid(current_user_ns(), result.uint_32);
-		if (!gid_valid(gid))
-			goto cifs_parse_mount_err;
-		ctx->backupgid = gid;
+		ctx->backupgid = result.gid;
 		ctx->backupgid_specified = true;
 		break;
 	case Opt_gid:
-		gid = make_kgid(current_user_ns(), result.uint_32);
-		if (!gid_valid(gid))
-			goto cifs_parse_mount_err;
-		ctx->linux_gid = gid;
+		ctx->linux_gid = result.gid;
 		ctx->gid_specified = true;
 		break;
 	case Opt_port:
-- 
2.45.2


