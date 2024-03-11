Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9507EC
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 01:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710120283; cv=pass; b=Sb1bLAfof8/xP373W609gJIt48u/f8/jKW5PLIlg2lq0dEept9/Y7JyAiAHNg3xZav6xtp/aCwhq5IWQPscNR4ALqVhHXb9HlkgwsDkSBoSqB4II6nDk/2Qq2Tago1m6Hux2h2AumnVayMl1p3nfISssc5HYVcY6lMrPHTfWM80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710120283; c=relaxed/simple;
	bh=qGL2SCi4dcY+9C+bfNKwwDNy4yApM+ogyrctGAim0B8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V9KlRN12jH/DTAX2SKOfZuDgjP8gXIoC5NvyJp+GERPkbv3Quc5Z8xrwnEPZAZTADqn1izYcGG1i9KMhz/g2dUHwbNisN0p/8QEUyngl8TMmTbQmxdCTAm6ZTJyZYuX/2EQLDwSor/AM9vdTgmt0xZ21nQrebqAKb+eKU6YFbk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Zzrbyqu/; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Zzrbyqu/"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1710120272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2xsObA8cjX2fxwl7noEbrFqWP41plg5g4gUiF+71Aak=;
	b=Zzrbyqu/5rOMBLh5R6z/vDfiYN2LnrQGx2godLQbdEXfaMPJlzlZEBjEhYDXnpXQC5f0yj
	IxosUokYsceVzRRfnoFibGF7m/iO84kUnNZQOHMjhMQ1RFHWyDKWdBM1tp9/AsgJuEcW1D
	ADfQdewWa+5aMjWont5ucMnZS90e47tja6S7+TipbIHRNzDVoWF9KS6PePws77s582e3BZ
	WpW5GFr3GFr9xY44t4fZxLqqmT2PHDZ1AfWnJM4Y16R4HEQzk7o1j54xyQ5xx1vT7N9xNK
	ybw3Mzi5NH7kJxwRN2SuGjD6l7YeXeYyIQgLfWR+V0Q/g9m81UZhJ3XVFsBk8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1710120272; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=2xsObA8cjX2fxwl7noEbrFqWP41plg5g4gUiF+71Aak=;
	b=ZbXtpRG+q4mmevN0O5IdwNoatxxLXZz41FKYIac9Kn2xrnKWb95QosYjljhNCu41+uUBqu
	Nms+B/EJJxuxBqgvq2kpXXBu88x+w9Jb2gY5PNTHNnvyHFeqZcWbqNnWlJyUSwIzl14ulh
	+0aY1LNniJcV7Tf/UwCQYD4Y02WFAG/ZoRkOtk+FM3uibI4smbW7pLRyOnm6Xlk21VhdOg
	LrgiRDcKOdarwtpcfufFJbh3IOvh0rOy2rJ9CWssBSx0j2oUY8X2oxTuGQgOeUVersWCkn
	xHd6pkm+vWDitQesBTXoahEZB11EAi989TwSY/uMk88nCgY4B6j58yfucwgy/A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1710120272; a=rsa-sha256;
	cv=none;
	b=kWot9lQ7TE7b8Rt8dSbJDdBCjdH1xeQnrl4kJwY4i5Z3UQl4SLV5QOh4Tg054PfwoGPdSh
	yW3mOsdMzIlNftNRLrOjqSybcLbZmwrw0nO4RHQB8hUTKwiZSqb7xwbdk73x7V8bCB4kWC
	0cJqQ7AgPYLNaJ/kwJHsu/Wje9OCn9P+wl4K6czIVtYalXbUDagkArD2KddiPy2+M/vnyN
	K9RvuQXspAgRLsLL5J0pF1nmzmxpMgZ7F5AEmo0P8WQAFrVBft4KiKNBw9CUfw9aEZAhay
	UqUEwisYMLJiWE5anMBohM2YWGj5OqVAyDey3QDrcMloDojWjkeRsRGGw7M+jA==
To: piastryyy@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/2] mount.cifs.rst: add missing reference for sssd
Date: Sun, 10 Mar 2024 22:24:24 -0300
Message-ID: <20240311012425.156879-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reference sssd in mount.cifs(8) as it can be used instead of winbind
via cifs.idmap utility.  It's also enabled by default in most systems.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 mount.cifs.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index 9d4446f035b6..f0ddef97a0e8 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -761,10 +761,10 @@ specified in the following Microsoft TechNet document:
 In order to map SIDs to/from UIDs and GIDs, the following is required:
 
 - a kernel upcall to the ``cifs.idmap`` utility set up via request-key.conf(5)
-- winbind support configured via nsswitch.conf(5) and smb.conf(5)
+- winbind or sssd support configured via nsswitch.conf(5)
 
-Please refer to the respective manpages of cifs.idmap(8) and
-winbindd(8) for more information.
+Please refer to the respective manpages of cifs.idmap(8), winbindd(8)
+and sssd(8) for more information.
 
 Security descriptors for a file object can be retrieved and set
 directly using extended attribute named ``system.cifs_acl``. The
@@ -780,10 +780,10 @@ Some of the things to consider while using this mount option:
 - The mapping between a CIFS/NTFS ACL and POSIX file permission bits
   is imperfect and some ACL information may be lost in the
   translation.
-- If either upcall to cifs.idmap is not setup correctly or winbind is
-  not configured and running, ID mapping will fail. In that case uid
-  and gid will default to either to those values of the share or to
-  the values of uid and/or gid mount options if specified.
+- If either upcall to cifs.idmap is not setup correctly or winbind or
+  sssd is not configured and running, ID mapping will fail. In that
+  case uid and gid will default to either to those values of the share
+  or to the values of uid and/or gid mount options if specified.
 
 **********************************
 ACCESSING FILES WITH BACKUP INTENT
-- 
2.44.0

