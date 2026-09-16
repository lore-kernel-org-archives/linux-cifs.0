Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55343BB689
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594459; cv=none; b=nEmVxcKGZWpfHIDnG1mQqWQDsIkbRVC9eas2DCi2kh5e4G9dKUNOjbVLzl7nzPDmUjdL3pD59l9k/PIx7LgrlS0SzzmiaHBaPk5BmgqClvfVlom67EHsNluVvbFTOWgyUbKS+kOoOMx2TG+/7WFYBBwiM2GuPpR32m+FEW+3M3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594459; c=relaxed/simple;
	bh=wk6vygH8NJfDOcKXAaJfgbMl5gGSxrJpO6cdJSZ6zZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5UXhUry3H9RNnaiE7PLsZbEchulvLcYs2ypIAqNO/NceBSueutwPiNE15lTen0+Fz0oEtxpMe3QsGk88Vd7ExAPrPE0ghllavR20mRfjvLLbRU2SN2/d2b9tzFszchcwf2rzV7pdmUirVdd76J4cGYMyh0r1krzgqP5VpaJDVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IuFW4RmL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hmQaRpBv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IuFW4RmL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hmQaRpBv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9V0qAlXWmLruJLZFHIdq+0l21ICiVDZYVMxBS+fFubs=;
	b=IuFW4RmL0RS4awu+8sG1cnFkZUzBrmnbHG/15wxs19qPNfvWxEamKWElFvpFxHkKGjsbA1
	6vyRQ+HasgYnsHOInYOi5XULtUcIDPrGYZs5eQpdrmo9F4RTc3OWATwqXr+a1VwAwF4Wd0
	0CCWE/juTs9ohw8LlxQtiWdM/EAfrhE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-Iakgv9fSM1qjweq4Z6uGBQ-1; Wed, 16 Sep 2026 17:34:11 -0400
X-MC-Unique: Iakgv9fSM1qjweq4Z6uGBQ-1
X-Mimecast-MFC-AGG-ID: Iakgv9fSM1qjweq4Z6uGBQ_1789594451
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-530d206e2b4so3034541cf.2
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594451; x=1790199251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9V0qAlXWmLruJLZFHIdq+0l21ICiVDZYVMxBS+fFubs=;
        b=hmQaRpBvj3r2+m8F+KVoHfJAfVaDCbzFQB1YrnZXcsGI2uE/15rOq3rafwIUaDA7E/
         eIDQtHf1O5cGXrWrLFHXiLzaiEb1Rz/LI5BB/y6PGBwfiyGOm6xBkEGuw2Phpimwi+ck
         WsOCgWmi7eObEhMgHwOgSCMlKm6ga1Gr4AFW9DpfhgltmTcglJvutLAKCKw+tA8iY3k/
         OLVjIpnMfzFEXApHSjo3LiN4p9Fk7gNBVv32/2SdWWY2FcyeSFjHJLoMl5LDa03980dz
         b99M2DSPDoCwxdKA72RzFbv8oMVrCpn15L8u+gooKqiNl8LmweU8mt/SVWP1gtBuSv4z
         soAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594451; x=1790199251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9V0qAlXWmLruJLZFHIdq+0l21ICiVDZYVMxBS+fFubs=;
        b=Z36FLKQ/ftJZM5tG/kikJMcJ473/Z1O9+eGN7IkLqMg0P+VTh8lR9zD+ovsZ7o7Jf5
         VeqBTMhwjg9kfvISNc906fPd43ees9dC7x0LOs2YomLrqhP61gOcdoCHsQudYgCY/Pso
         x+kXkGgtikExTXbcUx1kxTa7DBmXH+V6lxnND6th9nSJ7DAejZbFwoSPmz3YYUqHeOij
         gVND0BULziLdcPKp08K4v6xDiNgX/GrG2wcZN2vrd4AMUvXSveWavES9Cu0FSH+qoZuO
         Y5MoEbuECv/N6nS++xMOtkPcSe4rjUWzL4Eqsl6A5Dj/HdHlPeZrr7Nh+41Rf1Z4kdL1
         ItfQ==
X-Gm-Message-State: AFuF++lOtDbttameOZ9fxxoeBxEE1O7XA5OF+HaALBodSnAyr6gOgUcX
	/+VNn1io/uNtWowT3LoAdrsFMzsZWsMZ2RjmoCUG+TErXUaqPCEjjTDW7tYlvk3DIZurklUDSSV
	Qv2K3rPyNlFehpY2ur1SON2ChqxoLLl+GB8wY6S/rQa2/yas80egj0Q1an1DghQ9qpCf5x6zHjU
	THy6kz15lWlwp1srmJZ4e+3vJ8Nf45j0UltCiV9uq81duXUzKeuQ==
X-Gm-Gg: AYBFou3J0/hNxKXAXnwkKUijaZxd1hPaluMAat2VriGCej52rcF5N0E00PCaCeV9CHb
	WsRKoIQXYaMaYdx5WGaaOmcI55ydkJfJKSZ3R+HaAhf7em8hHtt8JWCt4C76L7/n+Abqj9sZEMB
	m1bmkxMQriZVaHsktvbgYIJREAAP+8gvwIP0Jgqux0jYMGr5Evd5jsqVGAtE6vVJSmjtZCCCPp3
	mmlqeVU+g+jJk+k3KioVXB1RxO4a5NXBsgVh4LQGyic3R/Ci8CtV7kyszcjBS30uHjqay6f3gPD
	uRtXGmcL5TvFmRUwZ67U219gVna2s1lZTj96mA4hZoQIPyHBcoPcWJT7ek/zb5qMFTx5GKBHTAc
	C4qWGYNy6hC4FfcLTv0iEnsI9y6p5FSMCKabes9gplVenABvJAgIh59GI5uObpix7Pw==
X-Received: by 2002:ac8:5a11:0:b0:531:17a2:4e4a with SMTP id d75a77b69052e-5327eedc606mr72964321cf.47.1789594451098;
        Wed, 16 Sep 2026 14:34:11 -0700 (PDT)
X-Received: by 2002:ac8:5a11:0:b0:531:17a2:4e4a with SMTP id d75a77b69052e-5327eedc606mr72963851cf.47.1789594450635;
        Wed, 16 Sep 2026 14:34:10 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:09 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 1/9] smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs
Date: Wed, 16 Sep 2026 16:33:52 -0500
Message-ID: <20260916213406.1496960-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix several related bounds checking and pointer lifecycle issues in
receive_encrypted_standard()'s handling of compound encrypted frames:

- Clear next_buffer after assigning it to server->bigbuf. A stale
  next_buffer pointer can lead to a use-after-free on subsequent
  error paths.
- Update pdu_length to the decrypted plaintext size (buf_size). Using
  the pre-decryption length allows NextCommand to point into stale
  ciphertext residue.
- Reject next_cmd values smaller than MID_HEADER_SIZE(server).
- Fix an integer overflow in the upper bound check by verifying
  pdu_length - next_cmd < MID_HEADER_SIZE(server), ensuring the
  trailing slice is large enough for a header.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index cb4fd09f996e..fcf7033889c7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5365,6 +5365,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	length = decrypt_raw_data(server, buf, buf_size, NULL, false);
 	if (length)
 		return length;
+	pdu_length = buf_size;
 
 	next_is_large = server->large_buf;
 one_more:
@@ -5377,8 +5378,15 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	}
 
 	if (next_cmd) {
-		if (WARN_ON_ONCE(next_cmd > pdu_length))
+		if (next_cmd < MID_HEADER_SIZE(server) ||
+		    next_cmd > pdu_length ||
+		    pdu_length - next_cmd < MID_HEADER_SIZE(server)) {
+			unsigned int max_next = pdu_length > (unsigned int)MID_HEADER_SIZE(server) ?
+					pdu_length - (unsigned int)MID_HEADER_SIZE(server) : 0;
+			cifs_server_dbg(VFS, "invalid NextCommand offset %u out of range [%zu, %u]\n",
+					next_cmd, MID_HEADER_SIZE(server), max_next);
 			return -1;
+		}
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
 		else
@@ -5414,6 +5422,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 			server->bigbuf = buf = next_buffer;
 		else
 			server->smallbuf = buf = next_buffer;
+		next_buffer = NULL;
 		goto one_more;
 	} else if (ret != 0) {
 		/*
-- 
2.55.0

