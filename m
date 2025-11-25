Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BF632AADC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093471; cv=none; b=kL8QZ2QT532oHgER9Ac3Xn9K1ox6VJaGquZEyzE/XpbGr5g8K+j3pKMIwpRmlDPP8zSK3ABCPXu8Xe/kklLgVqtRae+x311mSBVhI5/x0AIgvqH2uLAj6y8BOa4RnQf2rFoe7bJwMcKuKK6SBj6+b6D1EDnHxibii9k0N+ybtqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093471; c=relaxed/simple;
	bh=oWkrJNJzffJkcHQqD7003XVKxEs13eWuP76lvKKuUZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpynwsEbGicxPVT7L68Dq1Zg5TVnIhHd5YtR07LYMUxkyBH/N+H+svrIHBlS9mXM192arAmnS/91hdFhz6qZHey/Dw/cx7FpE9AWK/4HPC3tjIFsq749ml/PdNfzTuyChzBAfWP24FXc5zRcUk5cVhHiuXIopdNfO2/X+YKqjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YsBhvy0X; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YsBhvy0X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=njbxxn/KwvlJ3DBgxw474uzlc7FEesNvYsndVO1Y2RQ=; b=YsBhvy0Xx3XZvBNo9nEwsdlTV7
	26I0Eng2nrPeRboZYFjeqG1P4MokRYjirJUbi+sQTrlb1VQZh+qk7jEgs4KKegep7R/tp5/00Ql+L
	hYZYorXn+MeGJw/3eElHFWuGkJ2/j6lCof7msBRxsADniN6vfNG/V6kaWZKW13YOm68yRXB5RahcL
	Cm4aINJOz+JKSfXVz5tIK8fC3IrBpjnlS5SzlAoO8m0B2y6D4xTkhWmYvdGtEMSpzk6kytcxUE0+E
	izG9grjWWd7SpNgR2CiWWweqGFDcGPY7aluadwJdrgoFRwrIYvl7kZRV0Q/86eMnPjVpGOLZ6cozA
	URQ65QB9YfaBErSDyds1f6FUSacutabNj+qzzizzW5Bf1eJlFytS9r05VJjA4y/1akZA8Dp/D/2oo
	1Aw/uytCi5HXu70nWEJvKhpIjHXNaUbnKTTzU8ZyDJxN8Xh+Zu4iTurTY8I+lh2meCZOpJq5sD/Gx
	N+v0sNPGFafOASJP8tsX43uJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxIO-00Fcev-22;
	Tue, 25 Nov 2025 17:57:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 011/145] smb: smbdirect: introduce smbdirect_socket_set_logging()
Date: Tue, 25 Nov 2025 18:54:17 +0100
Message-ID: <576d7313b59f5e25455e193d78037e42d10a5191.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by client and server in order to setup
their own logging functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 421a5c2c705e..6c2732496cf7 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -24,3 +24,23 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	 */
 	sc->workqueue = workqueue;
 }
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
+					 void *private_ptr,
+					 bool (*needed)(struct smbdirect_socket *sc,
+							void *private_ptr,
+							unsigned int lvl,
+							unsigned int cls),
+					 void (*vaprintf)(struct smbdirect_socket *sc,
+							  const char *func,
+							  unsigned int line,
+							  void *private_ptr,
+							  unsigned int lvl,
+							  unsigned int cls,
+							  struct va_format *vaf))
+{
+	sc->logging.private_ptr = private_ptr;
+	sc->logging.needed = needed;
+	sc->logging.vaprintf = vaprintf;
+}
-- 
2.43.0

