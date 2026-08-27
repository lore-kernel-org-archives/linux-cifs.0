Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBF5381EB9
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 02:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796823; cv=none; b=LCp4xhWcAV5s9kru53yrYNFggi7V61ss6rY+7O/mw1sfZ8R7DIUCeRfgNXAlGXQxdJoIG+DMTgIo5k4YgHv3Ln5zHtZOQdZG15o6ne8n3s8Zh/7zHax/jpFGJVeHbefqAyT40M8Ye/JjKRjWehteyXrsN7HTJA00GWvP5487SGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796823; c=relaxed/simple;
	bh=r5WyFxlK3Amcgl3/tAI4LEiiX0RhsYvq4LAbGIQ/hS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkIqoJfHEGIvJSLoGUFhzrC6Gooh6/5GSh6enetn5Xi+SSo7emgHegHvoH9erPx0iL+kKzGTY5lBexujBlrAhNXmYzmX6X6AUEa3m4WglFsHt223RxNU5t1QIdNeldjHAVO5RR5cQ7lkH6CXDQUQf4TKYQXx7qXMLvdvCuYTLF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7Tgsa5p; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tXfc2a4u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7Tgsa5p";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tXfc2a4u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787796821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2JbehUP7qomYIbQiqGXFb55EKFYCc8LKqBzMD3RPWKM=;
	b=L7Tgsa5pRYr5Kd6ltcw+xiMu1KNubyHpuidl+P76fYuewkVYLAopjxfhf39FMaivGnqodJ
	YWlPKiaByOXKaJwucotef5o942KJioQQkjngo9yFL0tdcDPn2t+9C3b1GHsWsV8gJbw6Xj
	QH2ch4xYee+u1//xKkFDxd4HrEDEwdc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-RgiT_AeXMYuT0Ddi8KbpCg-1; Wed, 26 Aug 2026 22:13:39 -0400
X-MC-Unique: RgiT_AeXMYuT0Ddi8KbpCg-1
X-Mimecast-MFC-AGG-ID: RgiT_AeXMYuT0Ddi8KbpCg_1787796819
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93903982af1so49331885a.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 19:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787796819; x=1788401619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2JbehUP7qomYIbQiqGXFb55EKFYCc8LKqBzMD3RPWKM=;
        b=tXfc2a4uhle16h2IM3fTRY1t7EdReewjOUdEt22LYSrTtQ9jXe9WaNHsdCJ7QB4jBq
         d4GoKayJoobrhJFmWLthyUlxdByUEi5GPY8bmpyb7IW1+HV6rTxlZSHWQV8iVrsnVUSV
         Uc5AaIO/QOadeTF1oHU1psEGTUDhl1kQdBujj3b7tRIkmK2FM4mN2/olfAtFm8zDQ1Ca
         3MyMwXDtk2NKm/Ga/2bh/tzouEHISQaYxHGUqRcV7BspHH89RYay8yCZOms3UK2UztHY
         3b2RaLfLvpLS/kaOQZt0H6l1fYzZKdi9TuAn40rUfvbEClo0reFCedzF+fzuKF9YKcEP
         NDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787796819; x=1788401619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2JbehUP7qomYIbQiqGXFb55EKFYCc8LKqBzMD3RPWKM=;
        b=MDZbHRBCiAytCurCR4Kd44si/NwBZ8t8sq0IngZd293wqQzxJ1g6754NnulF1JRvow
         3525x0BDJSa0zYXfI0q//v9YA3Mq4K565LtfyhLCl9GwPTF5oNuTLoyZiQ9Ht31RTuEh
         g1a/HTmo38GknAfNqY908Rp/dzU1tSoWALtyqDsU363oijgoCqBNrUbdz/5PQg47Myol
         m1FewSC1RdAl1mCBVER//O2tDFXPlCcu4SZf9H5Su5775d3a6+IM423RHegMjc2mGej4
         qVUDi6qp2cKaZ8ppkURj9RF7DOTQIOmPCfceFJeT34KorQyvO3U6tk1AAlfQ1L/PwaL8
         OgsA==
X-Gm-Message-State: AFuF++nriYZalkzMnPw9xr/J4nhHlrbhaBIDtvAJLg9xj3jJC+zcuTMP
	aElXZgz8p1EmSy4AyhKAjBV2mv3Z3Qjt0GksAYPH8SjZ9H3W8W+PWmHxQBTGFJhjV512fZWuTUz
	m8rrbv3/nRbZ3seSdO+CWZurZRRMhTCAAJr5BrSBbCy673WCK9KeBNC1VmUGONsyGDqptSxL4m0
	5vFQkkeIJT9lvPo0pBA2Xb61BzGeFRdTUC5GCJStick/VLNgc=
X-Gm-Gg: AR+sD131ZmsIBNzCBqrQvL2Gyl0s9NDR40P4ojAgIAPRP2mJCQ10HkvKN9s82Np1oeP
	LXtR0OB5ttIoEaFcSPxHklfqi4Xg4uJkIxwYP7gfC8iBqrxKusEJy7GWD8Y9HUfDWA9QetzbUlo
	CjxLCrWx3UJs3wJyJF4GVKetL4TYsv7LrQ7Zn2WmpWKWdWWs4qKbHT3xEqNYOXre1HSDdZmy6vl
	VpoJ2L+/TVTyqv1P2zfOhO6xFbqPyU0JPGf72vVFIJhGRNlbO/g4bLNlJjcJQLvUk0jJtgYt6HM
	EqK0aJxFPh14Ia3l22xsohQ90bXOWociMimSZb5v+18PlLva3kQG3zCLzEg04UbSyNsV1VdeuxD
	IJyclM1CugNKN8RPzapYxKmVI7t22YeknLR829mWt0yAe3+d5mK6U9yqGCko1
X-Received: by 2002:a05:620a:4f3:b0:936:dbd7:fcb3 with SMTP id af79cd13be357-9378019b06cmr895173785a.21.1787796819000;
        Wed, 26 Aug 2026 19:13:39 -0700 (PDT)
X-Received: by 2002:a05:620a:4f3:b0:936:dbd7:fcb3 with SMTP id af79cd13be357-9378019b06cmr895171385a.21.1787796818570;
        Wed, 26 Aug 2026 19:13:38 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377f1d1419sm338623785a.12.2026.08.26.19.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 19:13:38 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4] smb: client: fix heap overflow in cifs_do_set_acl()
Date: Wed, 26 Aug 2026 21:13:36 -0500
Message-ID: <20260827021336.82730-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <4475a3bab754e633b20f78a6827cbc75@manguebit.org>
References: <4475a3bab754e633b20f78a6827cbc75@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_set_acl() validates ACL size using posix_acl_xattr_size():

        4 + (count * 8)  // 4-byte header + 8 bytes per ACE

cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
wire format into the same buffer:

        6 + (count * 10)  // 6-byte header + 10 bytes per ACE

An ACL that passes the xattr-based check in cifs_set_acl() can
overflow the heap when posix_acl_to_cifs() writes the larger CIFS
format.

Validate the CIFS format size against the remaining buffer space and
USHRT_MAX before converting--data_count is __u16, so sizes above
USHRT_MAX truncate the on-wire packet length, causing the server to
apply a partial ACL.  Replace MaxDataCount = 1000 with
min(CIFSMaxBufSize, USHRT_MAX).

Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
reproducer script which sets 1800 named user ACEs will overflow,
throwing KASAN error or silently corrupting heap

v3/4 changes:
 - change header size to use MAX_HEADER_SIZE helper

v2 changes:
 - Add USHRT_MAX bound to prevent u16 truncation of data_count for ACLs
   with more than 6553 entries, which would cause a partial ACL to be
   silently applied on the server
 - limit MaxDataCount to min(CIFSMaxBufSize, USHRT_MAX)

 fs/smb/client/cifssmb.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..230af243247c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3555,6 +3555,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
+	size_t cifs_acl_size, bytes_available;
 
 	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
@@ -3574,8 +3575,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	params = 6 + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
-	/* BB find max SMB size from sess */
-	pSMB->MaxDataCount = cpu_to_le16(1000);
+	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -3587,6 +3587,15 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	parm_data = ((char *)pSMB) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 
+	/* make sure we can fit the larger cifs_posix_aces in the buffer */
+	cifs_acl_size = sizeof(struct cifs_posix_acl) +
+		       (acl->a_count * sizeof(struct cifs_posix_ace));
+	bytes_available = (CIFSMaxBufSize + MAX_HEADER_SIZE(tcon->ses->server)) - offset;
+	if (cifs_acl_size > bytes_available || cifs_acl_size > USHRT_MAX) {
+		rc = -E2BIG;
+		goto setACLerrorExit;
+	}
+
 	/* convert to on the wire format for POSIX ACL */
 	data_count = posix_acl_to_cifs(parm_data, acl, acl_type);
 
-- 
2.55.0

