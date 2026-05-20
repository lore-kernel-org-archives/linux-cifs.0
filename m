Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917313FB05C
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 18:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301435; cv=none; b=qweP2ci1KO7G4VEm8aEa2rLeuD6lT9e/USMkDyQax4f0SoeyiCQqvzrOgBh3waWiGK34PyOT8BJIMeiGZuM8ZA68ykzUTC0TBXSRgCAvtWW0GrNedye5Njchb57VBo/ERKEa6lblUClzHQjejxJORmUQgC9RbeNpp3hFHL89JRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301435; c=relaxed/simple;
	bh=jTF76+RwiZwrVXfaL0XRkTxviXaJE0GtqX6lN1bqbbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOl5HaysPzkLJZh20jVgWrfyFzVrAgtTz1oCXCJZN+e9M3sLBdxqx2QBOBBW/WvFInqT38Sl3xWTKFbQ7/VeMm6AXaUZZHhvTH9q3uqcrHxUMm9BRq/J9zbVZ+skZRFWo5TbqHe1PLJVIPEl4TViQOAt88UaBeirfZ8mzX/ZRGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rZBNrJQz; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rZBNrJQz"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-94de664b541so1343759241.1
        for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 11:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779301433; x=1779906233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aufPc2eUKmrda3It1Y+eMbVsuY7EmCiSbAc8gz4isCc=;
        b=rZBNrJQzgPjj6na0hMSEdegvNpfvNmG/uiN/ZE2WRNfKmWAqaGvBQ9+m7GRaUytt8M
         3BghGiFjOETK+1GsqAyPmdY3Lpo6b55BTfeWzq6aQQRmD2P/wxe30kAo/UMLokuu8oNE
         0xiPW506aCrw7D4Wiw6yWLsw8XJ2PvUckuzfllUo9Hxzve21s2TGYi+NzmRt8JnCLfie
         vGvRy6T9qdUXBhVW1hWPCIRGUgOEMohAqRMESYP/VAGPHXin7oaquYVhPbxdf6YHzk0Y
         NM32TCUXYfJjPm3qBRh+xHVnYMdIvkYjwxye6QAQgdFeQEUP4MxVQPv0K9IIzZfsIiih
         J+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779301433; x=1779906233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aufPc2eUKmrda3It1Y+eMbVsuY7EmCiSbAc8gz4isCc=;
        b=brcSFbUyuDSoaH0qTni0hlH5PyGVcESklpEvCczyO+jYnmdCy2SkgluWtYh2ITxRoM
         gpwCMeCQ7vjq5P+eNn+2MBIOjEaZ857RhBAPOyWlL7KxyREJIU3CWhu2Hu1WagICuJB/
         QDgeTNnPIlxdT+yT/VtjFnpjcxThRg0dAyy/tfn8yT3xL0K2BLJmAxIQ2UEgbV9snLKn
         G6LQZO/utltqaAjeBlm2ZhbkeYem10TUZBpDuGmaPTPnmy+ixTERGr57meTic64S1KCj
         mB+RNrI4F0JncKUhNMFhQSnka3v4nCj4PqZYaskXWWyzs8BlN2GnXi9OmFPCvN6eIyLb
         iKVA==
X-Gm-Message-State: AOJu0YwmqYs1GBgIJs83tWOIZUCAPTitdAq44JF4Coh/G5fKvUVnv4+m
	1ZwjiewvFYju4vtHeUKQhdDkM6QfyXDGg0RRt7Hi19ibBrwrxtfynFfDx8EKMEmXyS4=
X-Gm-Gg: Acq92OF70qtijHF4WDvb0/Hr0htCCM5nPIIuRkvMA5VZkSIQIDj3zYsgmeWBtGiy6n/
	HJDguwZuXl70g/C8VT06iCpxb4NKhodRaZc7ozQTZCvZt28+yQDqhHVH71RJXieCtJqHz0kwFKF
	6ToZ/TmqdNuTQAagDOK+x6NKM3IaX3Oys3zvYe+ws9j5Ryyqcum67ZNSmpIpBBWQySGZYBnQhHh
	qtNZ3ateRXJvNnhXkvjBkAtTS2xn4tLqpElkVqmIM/osSsnRSL8RxfxTI+R2eZpz4pMu/u8Hadq
	RLOHGvEbAMdwVNFn2sXwWFBY8DdZrYgQox4DOE7yYYrGiWXhxc7v7Cs1BAcv69H/6MaMLpYJYMj
	Frzuh1F6+kZln24UZNKCToSkrWNjrekdJT/On0j4AkHcuinRjQQrvLMBohbRvsmNQhB651xXCIy
	JOshR8Mt5oPNJ8w8mPSAlyDk8qSsmIITQLvmi/oRLn3LNXILk6DCpjiiX4GQUontQTwySO3ht+R
	88LCuBzY0k20ns=
X-Received: by 2002:a05:6102:6a8c:b0:631:b834:e05f with SMTP id ada2fe7eead31-63a3d42d713mr14996691137.11.1779301433384;
        Wed, 20 May 2026 11:23:53 -0700 (PDT)
Received: from jeremy.kali (srv1619992.hstgr.cloud. [2a02:4780:75:55a3::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3608c424sm129087886d6.3.2026.05.20.11.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 11:23:53 -0700 (PDT)
From: Jeremy Erazo <mendozayt13@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	tom@talpey.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Jeremy Erazo <mendozayt13@gmail.com>
Subject: [PATCH] smb: client: detect short folioq copy in cifs_copy_folioq_to_iter()
Date: Wed, 20 May 2026 18:23:31 +0000
Message-ID: <20260520182341.2995005-1-mendozayt13@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515193141.542623-1-mendozayt13@gmail.com>
References: <20260515193141.542623-1-mendozayt13@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_copy_folioq_to_iter() copies a requested number of bytes from
a folio queue into the destination iterator.  Since the encrypted
SMB2 READ path was changed to pass the server-declared payload
length (data_len) instead of the larger folioq buffer length, the
caller can ask for fewer bytes than the folio queue holds.

In that case the helper continues walking the remaining folios after
data_size has reached zero and calls copy_folio_to_iter() with
len = 0, which is unnecessary work.

The helper also returns 0 (success) when the folio queue is
exhausted before data_size bytes have been copied.  The caller has
no way to distinguish that from a full copy and the reported
transfer count ends up larger than the amount of data placed in the
iterator.

Add an early exit when data_size reaches zero, and return an error
when the folio queue is exhausted before all requested bytes have
been copied.

Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
---
 fs/smb/client/smb2ops.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ee8370026..1dd06c31f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4696,9 +4696,15 @@ cifs_copy_folioq_to_iter(struct folio_queue *folioq, size_t data_size,
 {
 	for (; folioq; folioq = folioq->next) {
 		for (int s = 0; s < folioq_count(folioq); s++) {
-			struct folio *folio = folioq_folio(folioq, s);
-			size_t fsize = folio_size(folio);
-			size_t n, len = umin(fsize - skip, data_size);
+			struct folio *folio;
+			size_t fsize, n, len;
+
+			if (data_size == 0)
+				return 0;
+
+			folio = folioq_folio(folioq, s);
+			fsize = folio_size(folio);
+			len = umin(fsize - skip, data_size);
 
 			n = copy_folio_to_iter(folio, skip, len, iter);
 			if (n != len) {
@@ -4711,6 +4717,12 @@ cifs_copy_folioq_to_iter(struct folio_queue *folioq, size_t data_size,
 		}
 	}
 
+	if (data_size != 0) {
+		cifs_dbg(VFS, "%s: short copy, %zu bytes missing\n",
+			 __func__, data_size);
+		return smb_EIO2(smb_eio_trace_rx_copy_to_iter, 0, data_size);
+	}
+
 	return 0;
 }
 
-- 
2.53.0

