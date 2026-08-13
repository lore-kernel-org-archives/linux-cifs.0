Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908983E171E
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607134; cv=none; b=riEtdXCbzIVpbvRy3+uyBqz1kg0pcPjrTW2vw7tfC+KtI0kzuEK5RK2XAbPkxPJ9zPXD5ewQRtY2psYXwK82RMRRmuIzNrQNaRo/t6NQgT7sh+mrX3kV8sXmqCRmIwV74X0qYSOmom85GZ7DdqmYPfe+eVYd+vBwe1akgl3mRjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607134; c=relaxed/simple;
	bh=gsUYnVwatn5Kl2SbyTKwCkMjIxPpKHshq21iM0xLZ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uIBuWeV8zvw9zdeBWBgoLDbKVMiJX43yglJJ+shbM4LPx0Q+wNFNosS58d1ZbVWo3VD2bx77zwnfvJSr5rhIr80+xeOlzHAjpkh1v05YB1n+36LE7uqrJR2bgmuPYJq79j3dWDzG7etJ/U/HQHP1H9oDs+A3lFs3w8QDjok4v3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGzLYjz2; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGzLYjz2"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso17888575ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607133; x=1787211933; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=INQpddQYGxbdS3AZPQaRlhc8r+29QVvcQA4ufVXdZpw=;
        b=ZGzLYjz2ZZ7aa3XdlDoXWjRoZw9rlYPQlGWLqY3DqiH6+7LgKLr/KiFRkTHb51yyNk
         x1LMGRaxCaWDEf6aknW9KMHgv3vWvmREUyl2sGexDRM2tZ1vFhtCe7AQMeNLk9rMeXff
         S5DwME3+Xbm/q0ypE7KjPPjQxXKQS21J+44FmmSfWb6h0/tPNGo4b1BPFtcLBwtwEtVd
         pIOjQK/3502rzbRyH1ni5u2VxBfwgnBN9VCvKTVW1p59k4zt6X+LEi0QXmJJp7KdvDVu
         noZ10qsDRQ2XzfCcykwOj87Mi5+jhZQWmlsgvCQ7lJTsPl0vyZJbLw/TK12tLQqFLKB9
         1RnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607133; x=1787211933;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INQpddQYGxbdS3AZPQaRlhc8r+29QVvcQA4ufVXdZpw=;
        b=Nxza7LVfgt0/si6qXAy/qr2VLFtXh52j/IzMaSe58BlgKTFDS6YJhmw0lOjMkm2QWx
         68UczfUfVz0obXUf9UqQAbQTP9ykAVshUn1Byc8yrQvSwIP+SllYC2+tHlNjwqms7iqk
         KDs4AQ5aIZeZmY5oPs8VzlmSsEchy4B6PaGT4uqxo4Khvbf1NSxS++WMTZx6Idf6/qes
         qyzGM/ox2s231m4yGuSH48yFQJggU0RcDxG5couue+G3ErNZPJQOMGfKCBC9b9wbIVpK
         H8646pAVs2dRDsSNMpCf3h1ZvEJuUVxSNymAGfKSY58kt3hnT391bwiFr8vDmMWIBvIc
         Hi6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr6GOM290+OaCbqYzWBCaczjyVXUU1/e28yLshufyS2EKgdOgsmbpi8W4pqSDpXIbkTD60w8kSmwPaV@vger.kernel.org
X-Gm-Message-State: AOJu0Ywur8nvCHgE3MO4nAp8fb7+25A+O4oBDabOyqsiee6kwhuiVsTx
	4AWH2nIpC658cao1Qn4x+wdPPqG2owTaw8cGIbajgj6ws0uxk8dfDcIN
X-Gm-Gg: AR+sD13jCdixvefg9xqyO0NSXWOeLggfGDYSUhSzaV8ADTqLjLGYI0V2FDcvUrVOg0s
	qZ+bFAm2EnpnGD9qZHZ+/dI6+s4/9wKJNR5+d9b/+4IB8IaV8ebdsbBEHRAjHb6uKMJx03UIVxu
	O+fJsDhzcEMWiyBL7zmJthZZq3sd3T4uD3h4WY6mCE7FTSgjRKfwaHxq1abr3wmwtXtASFvDiTh
	BlAmhD/BKlK5ljieqrIbDO0VuvnEmGKFz/3iDiIiFziUvdcfQGkZijWwDk8EheKkIFSJXh7HKWV
	A02O1HpjyItcXD1AMzjYodLPmGwpUqWb/LoQAO8lu08yVf6KnxmrgzfSEDkLK06u0j6hz/Sm8vs
	gWf51H+vgOZHE172I7Nxz8CBviAONtxqqvtsOQv3iOQr21apP2tDbSUoLLblgfP6Y6QxvE58VY+
	FFpi4IC93wf3Y+OI4zJKBYyn0M4Z6snuACaQYh8gOvr8+DpT+x5o/Uur0aS2BoSY5VwDvaSOAQw
	3jSQOv8HPCAd7pnaM+xrBLgLrn4lFBgqgbzeVSQnQMMyjdQxTYcr422ZGNKl1YUtmnjKBSYTNMI
	9C/y9+He7AbQLzQBCA9+ORUDCzw=
X-Received: by 2002:a17:903:1ace:b0:2c0:e2ea:6b0c with SMTP id d9443c01a7336-2d37f0bf777mr47425815ad.21.1786607132805;
        Thu, 13 Aug 2026 00:45:32 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:32 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 4/7] smb: client: block cache=ro and cache=singleclient on remount
Date: Thu, 13 Aug 2026 07:45:14 +0000
Message-ID: <20260813074517.607275-5-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

cache=ro and cache=singleclient are mount-time environment declarations
where the admin promises that the share is read-only or exclusively
accessed.  The client bypasses server-based coherency (oplocks/leases)
and caches aggressively based on this promise.

These modes were intentionally excluded from smb3_update_mnt_flags()
when it was introduced in commit 2d39f50c2b15 ("cifs: move update of
flags into a separate function") — only cache=strict, cache=none and
cache=loose were made reconfigurable.  However, remount currently
silently accepts cache=ro and cache=singleclient without actually
applying them, which is confusing.

Add explicit checks in smb3_verify_reconfigure_ctx() to reject
attempts to change these options during remount with a clear error
message.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2fb40e9e1652..4a319c113196 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1261,6 +1261,19 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change rdma during remount\n");
 		return -EINVAL;
 	}
+	/*
+	 * cache=ro sets cache_ro and cache=singleclient sets cache_rw; the
+	 * other cache modes (strict/loose/none) leave both clear and are
+	 * handled separately in smb3_update_mnt_flags().
+	 */
+	if (new_ctx->cache_ro != old_ctx->cache_ro) {
+		cifs_errorf(fc, "can not change cache=ro during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->cache_rw != old_ctx->cache_rw) {
+		cifs_errorf(fc, "can not change cache=singleclient during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.43.0

