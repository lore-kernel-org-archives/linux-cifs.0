Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0973835965
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154642; cv=none; b=WIXH8L2rFrB2DGyTmg9PbIHdwVhLBk/8LibhfFbOljwkw2X+aE65Kaqxr6bOWJ8CSktamPb3PlPv91AI1rZZepdtwu+le0734auEBNifchjdAM7NW9XCzocvLrx2bsAp9GxANFO4mvvteNCvAVIxtLmaN0R/NAJUCCD5s2sk4bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154642; c=relaxed/simple;
	bh=xehPDtm9bmHLEDcMXLU/IxcZPmW43N5ivDpU1uKEF6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J52bqF4n7JGFCPYnQBkCZOrWjUloxG9W5/gWOOCwpzq4OHoWgh7wONlgxS4tThi1aif2J7LCm5VD5V3ohDtAihJpbZHoNBWVjyPBi505GmpzPJ2kR+zsY5Q56AyidXs4vZjqAW2B0yYzottUYdjI30BojZ+maWvSBNW/1ngI50M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CMvuGSZv; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CMvuGSZv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ZffG182R1r9Ny2Y/EqPIvW9iN+OdUAFdhj4/4je5/+E=; b=CMvuGSZvB1LQoG5w4pL434/Lct
	sncVZhvhJ+qCKoFySu5DmJpamojq5nt03z/UsUJzYsuOHyE17BOjSHPUC+o248/vwetDdF+F5c/KS
	2Y4jG0A63s2VGvdcUhAeHMRwP6savXzF9wLIZ5bH+pcJAr9elPSgh7J1wvL4bgXUBjJS78FVqc/4F
	23Rje6eIm7YAe4CI0qJzmDcAKKGpOsAKHMa2j44re4MbDNk6xAfXY8TLSLNtaArniamLvAIid5XBj
	fMLj2jll56P43fLfpFlKDtFaY1FfQVKsroDDoX8g0b0XQrGsdsQ+QQGOk1B6UsAgysMcr5pzFgg59
	YUG97dH2pNDhxfIe97g9BY9xSftpWEeN9pjpjUC11RVIsVPcFyYFXXKGCbcJHQjRcxlF411ydGQgn
	/7RdfQiVd9lnmhgymRu3CGY017MX9VBVKVkYUe5u4gV8y5yk6W0XWyUIh8qDAV4H9pcaA3kQlD/Zs
	2sXuVnkqeQbDzM3C9fVitJSs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe2k-000jZg-2w;
	Mon, 25 Aug 2025 20:43:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 012/142] smb: smbdirect: introduce smbdirect_socket.rdma.legacy_iwarp
Date: Mon, 25 Aug 2025 22:39:33 +0200
Message-ID: <48bcd83eab19ef812d192cbc743657fc814612b7.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by client and server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 09834e8db853..11f43a501c33 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -27,6 +27,10 @@ struct smbdirect_socket {
 	/* RDMA related */
 	struct {
 		struct rdma_cm_id *cm_id;
+		/*
+		 * This is for iWarp MPA v1
+		 */
+		bool legacy_iwarp;
 	} rdma;
 
 	/* IB verbs related */
-- 
2.43.0

