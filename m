Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B22EE274
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296253; cv=none; b=Hq+7pBLtVY/kkSpTjaour+ujgxsWKtwe3X5HoU0IRAylYsqb3ooSZEqflmN+wjcVRyOlJvUX0Y8YT91ZkhLSr5spO9+reFrIlSd2bm2k1RE9YF+WUPIPYJpRHFpBra9n2hRZ55FUm5bgOuJQIh9tngVEo3fUMg47cNd1UPihHT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296253; c=relaxed/simple;
	bh=P1FIH25b2uGocTXChbSz3TDLDvFghefeVTMas4dlYmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/IRWwt/g7u5KO83pEBG4qi/TGg16nuaGIVPgvgl+awwYdGQspPO1KFFhZ0E42K0qkrE1fHG5riwk4uM8sAVX0ipdr7qSHhgQowL689OAs1jTlMj/APDGq08ixcpF7T3ELF85qL1nmXKIvaTxnclJLBh3YXj1Z9+fNCzJfD8VwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XPixa6zg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XPixa6zg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=2IY+UvlfeOluyTVIvEJK1FsjZyuU9vFWeuHWuf/B6Cc=; b=XPixa6zglg66FFktIg9JxmbX1E
	MC61PiciDOAUt0HFruY1usNl//M11flktCjAPswmJU+DsgNTu5AwWviAERVX/dLSk9doILn9gLn+p
	sL4h17yyS5YYqs14UB+F9PdPMwqptjpJRu6bS3SpLTXCSzyPAZxRkmnqu2Cx9j1NEYqrDEKozaNAI
	AF3mKita+OJhybNj0vw/tmbas8pT+IUCPvrvkm17o7J5LO2GDVAoGAbl70UxOXZXpdH3mk4EGs79C
	yUR7CGJxoY10ikUboIdO5oUdDvKziu/4XHb7DH1fM4D1a+EEf5gPSW4W/3Eq2q8e8Xg2Kaq41nG5V
	wDrZ+GtQ/v+hulvemm37RzSoTRA7mhvIlCDc0poZWMbQ9IitelFU3Gw/PWoNIzOagjR/24g/wKEeR
	75TdNn8kytQwxB+2XiZlh/uHFXxrylZ+wJxM8zsQehSy3Xk8ZVOdRVEvR2S6M2X5m9YNhMWlfoFGE
	b+6Wy8O/keDSowj7NJGWpfoZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81Sy-008nzg-10;
	Sun, 12 Oct 2025 19:10:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 01/10] smb: smbdirect: introduce smbdirect_mr_io.{kref,mutex} and SMBDIRECT_MR_DISABLED
Date: Sun, 12 Oct 2025 21:10:21 +0200
Message-ID: <6e733a250194e07943238c8318880231e3803760.1760295528.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760295528.git.metze@samba.org>
References: <cover.1760295528.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used in the next commits in order to improve the
client code.

A broken connection can just disable the smbdirect_mr_io while
keeping the memory arround for the caller.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index db22a1d0546b..361db7f9f623 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -437,13 +437,22 @@ enum smbdirect_mr_state {
 	SMBDIRECT_MR_READY,
 	SMBDIRECT_MR_REGISTERED,
 	SMBDIRECT_MR_INVALIDATED,
-	SMBDIRECT_MR_ERROR
+	SMBDIRECT_MR_ERROR,
+	SMBDIRECT_MR_DISABLED
 };
 
 struct smbdirect_mr_io {
 	struct smbdirect_socket *socket;
 	struct ib_cqe cqe;
 
+	/*
+	 * We can have up to two references:
+	 * 1. by the connection
+	 * 2. by the registration
+	 */
+	struct kref kref;
+	struct mutex mutex;
+
 	struct list_head list;
 
 	enum smbdirect_mr_state state;
-- 
2.43.0

