Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0C938D3EA
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782238976; cv=none; b=DtkZV1Je03XPXkrjH0AVfgf73rvW+2cKNYN6Lyg/UQEO0ChMJvBrkm8FUNfDxez6CDcQJYA05z25VAeqwoBa2+aBZfTNSafC3A7r204NzvPoarFGgDDYWidZde/zFBmXRK/VPgm1IIq3fhDFRSwdWmU/jm81Z+kI5LP4znkUxAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782238976; c=relaxed/simple;
	bh=ThOxreZY0Px0YkyjluzAjsGay/TS3rChyLyU5g/7vI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=X2F4ZS2XdW0/G9YlUiVqm7BxU8e7kor2UYUEDfuiWIiCqOxAxJNVCRraO2IoBhZm/Wa/8DVR1knW9K27TYz6W3PiDmVBFQ4bWfjHLt/69Wf08LDnOnAf0cN+y1kNzT8SafNF1iizc6L4J/CUH5C6sySzcWmwK1yvf7K+l+PNBXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=N2OqxzCm; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="N2OqxzCm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=bCO4lwawIu8brQJMDOsOCANUNcLnKJpF9a8Ox/cdBZc=; b=N2OqxzCmzRNgFW3IMa+7v07PLt
	hwoCWDg4bvm8NvaUJo6Hcdfr8E2c2tAbmH4bCukXI0q3TvR4LucTv9PW8YyQ/HGRohNN8ZOVnIZGV
	ZjuFhboFJzvxbzb7lhpveC280Vvo0ddO5xV1lqgZQlODWvAVpb+IMVq6pxsTdtwLELoL3qjQL5bYH
	fyLkGrud/dRZ1Hgh8VpZcho7oP8NSn5HfSGq69ffChuaZH4uFUfMKiaubUPn9pBz0KQuzEqBeD8Dh
	gijaq1YtlcvVOFfK+Vj3Gjg2dmAkpEoiq6cdjQqR57nEMPMTkE15UCQ4EAptWglWr1DsxDc0lF+nH
	tW+ncd1A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wc5Vt-0000000201r-0g82;
	Tue, 23 Jun 2026 15:06:21 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] cifs.upcall: fix compiler warning with -Wvla
Date: Tue, 23 Jun 2026 15:06:20 -0300
Message-ID: <20260623180620.373135-1-pc@manguebit.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The length value for @path array in get_uidgid() needs to be evaluated
at compile time, so replace strlen() with sizeof() when defining
PROC_PID_PATH_MAXLEN and then fix the following warning:

 cifs.upcall.c: In function ‘get_uidgid’:
 cifs.upcall.c:1400:9: warning: ISO C90 forbids array ‘path’ whose size
 cannot be evaluated [-Wvla]
  1400 |         char path[PROC_PID_PATH_MAXLEN] = {}, buf[256];
       |         ^~~~

Fixes: 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org
---
 cifs.upcall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 01690dfcade1..5bb3e6881491 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1376,7 +1376,7 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 }
 
 /* cover worst case/impossible scenarios, + 1 for NUL */
-#define PROC_PID_PATH_MAXLEN	((int)strlen("/proc/2147483647/status") + 1)
+#define PROC_PID_PATH_MAXLEN	((int)sizeof("/proc/2147483647/status"))
 /* max valid UID/GID is (UINT_MAX - 1) */
 #define INVALID_UIDGID		UINT_MAX
 
-- 
2.54.0

