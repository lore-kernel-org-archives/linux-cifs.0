Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C68D2797AD
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410369; cv=none; b=gNeSTuQ+BHJ+/PF0/RQ21RX9ep1+aZU+DjCs+vnPlROXWs+iLi9jhvwROzEPoBwwAb/LLRKyEw/qK1DLgEO/si48GKQPy8yPEBBvTQXidLNn7I13DpkSkUi2JBx9WG2mH9KecmVK7bfPaDLTFndV5JwpLKzlQhCJ2hj4sJqwMAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410369; c=relaxed/simple;
	bh=tFAJnSzLwDr3coCHa2Mt4AfXNQh+L/CSliedA0vHvm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu5BAsZfjXKTFJh/VYsrRuggANvAlWdQ0Ipfmkinw0zF8dMfK3jKisL8g8yC7FI3gSiK2EgJeaHJIxNDlQ8LM8jvm081pE/7YO64yce7VYb8YAnWXY8g9lWFhVRlT9BHjAQHiu9L1VpkxIwhofjDaOv8S2no79zci4nKDSuQeJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2uUXnKKA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2uUXnKKA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=W7cgvWLjtj1b7cYPEx2c6e/4EocgzbRHcks6YDfjLWk=; b=2uUXnKKAgF+X06Z4GlpU0vW3JJ
	IIVvtkqNlTbBLqJMAV39tTb3GKNwp2Ci9rx/pQNYd6CUxIurx5dIfHm6QsC9e/phpP8TmK4+wxpZs
	P/NZrlQnlZwaX3lwSQ3aqbZdKWUffF70P5IXwXaddXtmsUBkqyrwVwCDaH3ZVLYZQ63D0nE7+WYoK
	dp+9+Or9fND/dmHGHFlIsYANXLQbfREH9rp6UcjlBfSc54hk5V9uu+fi2mxZSENCVGT4YHCH4zxsp
	VRwKtFH3bRvyd9EDRYgszO2eGmQC61aDFvbpdfvp2SL7b7+TrY1ETjGYT6KIcNCbwXWePCTd5WMQS
	AgtTdoj0aPlur4Oe00UGLdZ7InwpR0vOcefHtZonXhGrU9vvDS5jy0HTYKtFWjo+amb4LfkxLpY+5
	7IonRQugVyw4rd0uJ3zNWr0DrRJ2wmqBGaOuUaILhy24W8qWrVwgnhOeuLcUdoEEXqfUZzEhK97JG
	BXNd7c7bzDV7lDAUw4sIn3Dp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKHM-0019h3-2f;
	Tue, 05 Aug 2025 16:12:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 06/17] smb: smbdirect: introduce smbdirect_socket.recv_io.free.{list,lock}
Date: Tue,  5 Aug 2025 18:11:34 +0200
Message-ID: <5bf7bdf82254d326e9b560365fced62eae7bbec7.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow the list of free smbdirect_recv_io messages including
the spinlock to be in common between client and server in order
to split out common helper functions in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index a7ad31c471a7..21a58e6078cb 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -51,6 +51,15 @@ struct smbdirect_socket {
 			SMBDIRECT_EXPECT_NEGOTIATE_REP = 2,
 			SMBDIRECT_EXPECT_DATA_TRANSFER = 3,
 		} expected;
+
+		/*
+		 * The list of free smbdirect_recv_io
+		 * structures
+		 */
+		struct {
+			struct list_head list;
+			spinlock_t lock;
+		} free;
 	} recv_io;
 };
 
-- 
2.43.0

