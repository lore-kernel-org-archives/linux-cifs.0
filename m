Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9347F8
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 01:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710120283; cv=pass; b=dY50fMi7e3Hzwr10cSMI2BDBiLWnE3b5Rihk0qUzaUXbswDjbuPjN3gUNLAJtAn3+al+sFxEzZEXH4goV3nH5k5yRu67RK2CxM3nrUtAcXchhjM7IRxm2iNvb9BfsbMKaEsHnUPmG8ZHhBbv70nRDxfJhpdVpFmmmdW9bPWh7Bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710120283; c=relaxed/simple;
	bh=IJfFIEbKEJIz+ekp18XYHk3MiaoejZunH2QRICpmr7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCS/sM8m3Z+4k7mOAHfOhys2oKBr9sFgYFa6pgoU7F3mGDsYibe8sxASv40Xm3YonxUSUEsaQL/3aiOkh7/y5H3FFdixCJuMFdJ5PAftzpEExo0tvK4lNKF+tNIziB2tmTksoj39aQ4mD/gxcjr7LarKLgAZ84UIvpm0u01vpUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Y3+VGfMV; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Y3+VGfMV"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1710120274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4U5TxTlQLjqlMT3RBkTJtlh9CLdvrOu0LV+ykOnGj84=;
	b=Y3+VGfMVyaGK91V9ntB9Xeu+BQoAHtDXog+P0BcXGoolb7Re1OGYkR2WsL/vpMi0dLEnTQ
	DrrON9bihjnhpHNYfMHG96kfupPPZXTq7kQKh4ZxaaMnNCAHXVzQHP7jIkIopETqRv6r2m
	gbxh3iWPXQ3VhmonLT+/Pe/ko87RdAZk9/kqBCOiKuO4mjnfpwzTiN+jvhiUtJEz1vermt
	vU1TtTLoJ8qU/7LXFogZI8KCFg9L7fqehyphN+pQZwKIS52jbPAqiZYbtdTvM7Qkx4cgoR
	nSMGhnMbvY36xyGA5gmVaLk3d4UAYSbuSilIZ99b49SuQ8spw9XsfEsIfYF/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1710120274; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4U5TxTlQLjqlMT3RBkTJtlh9CLdvrOu0LV+ykOnGj84=;
	b=G3qFMoRp2CyzKtkGDtNSpXthsgiih6HUeuVjRShPGr6ZKsisOaKWzWzcxL8bu2jdjVmgEG
	iO9IhOXoRRG4Tm3R4Gllf3a6IjxtCl5BKumD0/71mfur6EpNJp5aWxtCAk33M2rPpw5LM7
	/2LZfKSJBjjUyBIHX1TBA/ziWMmvarftrfmmHHBtv7b8BFzOmUOSkYjvp/YRkakWYmSx0o
	D7a/OaMvJ8AoL7r80N0m8sCpxaRlO5e9eNq15yyElK2e74wwXhrgz0nrbxl0SlNSu05S1a
	kIdSOL3WstrrM9BL8PY+h4al/DR18znf8XTUJWUK0NpxqZdJiSke2qcMcJyx2A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1710120274; a=rsa-sha256;
	cv=none;
	b=VMhudpATcG+XqWe7YdhMFt6PNc8lf6b9av1frfY0ArVqDjLbcwrKBmd1FcVnfZB8Yvp7cP
	LRX5YWNkr5iCr1jRx3PGNRICrNdrrKLWSZlsiU0Ak+0o8sMmbtVtGcABWY3a+3/LLNB2NK
	6OUoqhATvcYuswaAH73dhDyDeKhgs0tXW45JqrNYV2ycrFLI5xhZf8KIkUjKkwcPPIPdKe
	GdBm8JMKNfCmjlY4iPxiXhy7Vg03uR6nXcEbbjohfJj0gyT+hf26U8ga3d3DylkhUwhJhv
	+KD3WyAdmuf9s0l2MBKLk2pM+8s9+S6Vxqi0bscg0WM6nFRyPLQdHpKvyE1BhA==
To: piastryyy@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/2] mount.cifs.rst: update section about xattr/acl support
Date: Sun, 10 Mar 2024 22:24:25 -0300
Message-ID: <20240311012425.156879-2-pc@manguebit.com>
In-Reply-To: <20240311012425.156879-1-pc@manguebit.com>
References: <20240311012425.156879-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update section about required xattr/acl support for UID/GID mapping.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 mount.cifs.rst | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index f0ddef97a0e8..bd39c165c130 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -321,11 +321,12 @@ soft
 noacl
   Do not allow POSIX ACL operations even if server would support them.
 
-  The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to Samba
-  servers version 3.0.10 and later. Setting POSIX ACLs requires enabling
-  both ``CIFS_XATTR`` and then ``CIFS_POSIX`` support in the CIFS
-  configuration options when building the cifs module. POSIX ACL support
-  can be disabled on a per mount basis by specifying ``noacl`` on mount.
+  The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to
+  Samba servers version 3.0.10 and later. Setting POSIX ACLs requires
+  enabling both ``CONFIG_CIFS_XATTR`` and then ``CONFIG_CIFS_POSIX``
+  support in the CIFS configuration options when building the cifs
+  module. POSIX ACL support can be disabled on a per mount basis by
+  specifying ``noacl`` on mount.
 
 cifsacl
   This option is used to map CIFS/NTFS ACLs to/from Linux permission
@@ -750,8 +751,19 @@ bits, and POSIX ACL as user authentication model. This is the most
 common authentication model for CIFS servers and is the one used by
 Windows.
 
-Support for this requires both CIFS_XATTR and CIFS_ACL support in the
-CIFS configuration options when building the cifs module.
+Support for this requires cifs kernel module built with both
+``CONFIG_CIFS_XATTR`` and ``CONFIG_CIFS_ACL`` options enabled.  Since
+Linux 5.3, ``CONFIG_CIFS_ACL`` option no longer exists as CIFS/NTFS
+ACL support is always built into cifs kernel module.
+
+Most distribution kernels will already have those options enabled by
+default, but you can still check if they are enabled with::
+
+  cat /lib/modules/$(uname -r)/build/.config
+
+Alternatively, if kernel is configured with ``CONFIG_IKCONFIG_PROC``::
+
+  zcat /proc/config.gz
 
 A CIFS/NTFS ACL is mapped to file permission bits using an algorithm
 specified in the following Microsoft TechNet document:
-- 
2.44.0

