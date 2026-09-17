Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BECD3537C4
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 00:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789606647; cv=none; b=CGMfz9EzUaloBPIKDSwHmCstCU91E7OIQeirHU8kGkmhzbP7KO3hE95/mou66zQyL/9tNkJxgRDgXk4AJAWSFj7X4U/+mBT2rjrddfXGnnuysWCGcPiBcDNPe0zHO9WUqtXGyKPxsWRYHD6l0MaUO8t8HSHZ+vUKx1Px6w9/AMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789606647; c=relaxed/simple;
	bh=UKPXcD/cbJeKjfeMhxw+5M4QcvqxKl6PoHk+T9eJ08k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BP2BUAvd9wQUdL+jAov1abeR0kefypOi1o0LsszgnZ2+HAw/e92TOBjYqk0tWlU0qKupEWRvlS/qRxVM1y0qyLpto4Wn9VLGSiUvCYLER7YqKnetqexup9QcS2xxjN1Dt1LB7+Nb3+MFjW8t0Avc2E1141tD94W3xbym0lO//ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=MkAo2HoV; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="MkAo2HoV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=U52/ekkLnaGcNBiKzWawZQX+/fTqOQSbBc5GKz+K/vs=; b=MkAo2HoVG4NsgdmS4vmxcFnUuD
	8leggkQqvcwPgRHb+U3yuzfEEJvn21BDyEMeJjwII6R70qLA3zysb6EfvuvGzUW1E/gQ61IeCF7k5
	ZQmOSWr0JWjuccslDhkczLQAuPZWd8tjd8ZfAnAVjvofe8RKS9N9eVHfD37C/SQP992qo+6vuEYsp
	nyAXs2yGDBDxYg6co0oSmoOVcmNd+71ATCZC8z9dpDZ4GbGEAnC4DpOYITQnNtVLewaB5QH0PqxGo
	ouC2Hz4Ahq6cpYqmBtZR/O6IoRA28CgI2tl3n67vW1JP4cc276i0zCDJ/ERZ7q+OYYghPezv6cDiw
	hIcAespg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x708M-00000001byE-3WtS;
	Wed, 16 Sep 2026 21:37:50 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Alexander Bokovoy <ab@samba.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] cifs.upcall: resolve scraped ccache name explicitly
Date: Wed, 16 Sep 2026 21:37:50 -0300
Message-ID: <20260917003750.1790143-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

get_existing_cc() selected the credentials cache scraped from the
initiating process' environment by exporting it via setenv($KRB5CCNAME)
and then calling krb5_cc_default().

MIT krb5 reads $KRB5CCNAME through secure_getenv(), which returns NULL
whenever the process runs with AT_SECURE set.  The request-key upcall
that spawns cifs.upcall triggers an SELinux domain transition, so on
systems with SELinux enforcing cifs.upcall runs with AT_SECURE=1.  The
setenv() is therefore silently ignored and krb5 falls back to the
profile default_ccache_name (KCM: on many distros).  As a result, a
valid TGT living in a FILE credential cache is never found, and the
mount fails with:

  cifs.upcall: main: valid TGT is not present in credential cache
  cifs.upcall: Unable to obtain service ticket

while the same TGT in a KCM cache (selected via the profile default,
not the environment) works fine.

Resolve the scraped name directly with krb5_cc_resolve(), which takes
the ccache name as an argument and does not consult secure_getenv(),
so the FILE ccache is honored regardless of AT_SECURE.  Fall back to
krb5_cc_default() only when nothing was scraped.

Reported-by: Alexander Bokovoy <ab@samba.org>
Fixes: ed97e4ecab4e ("cifs.upcall: allow scraping of KRB5CCNAME out of initiating task's /proc/<pid>/environ file")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 cifs.upcall.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 76e88b79a760..8fdf1af710ef 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -534,15 +534,31 @@ get_existing_cc(const char *env_cachename)
 	krb5_ccache cc;
 	char *cachename;
 
+	/*
+	 * If we scraped a cache name out of the initiating process'
+	 * environment, resolve it explicitly instead of exporting it via
+	 * $KRB5CCNAME and relying on krb5_cc_default().  MIT krb5 reads
+	 * $KRB5CCNAME through secure_getenv(), which returns NULL whenever the
+	 * process runs with AT_SECURE set (e.g. an SELinux domain transition on
+	 * the request-key upcall).  In that case the setenv() is silently
+	 * ignored and krb5 falls back to the profile default_ccache_name (KCM:
+	 * on many distros), so a TGT living in a FILE ccache is never found.
+	 * krb5_cc_resolve() takes the name directly and is not affected.
+	 */
 	if (env_cachename) {
-		if (setenv(ENV_NAME, env_cachename, 1))
-			syslog(LOG_DEBUG, "%s: failed to setenv %d\n", __func__, errno);
-	}
-
-	ret = krb5_cc_default(context, &cc);
-	if (ret) {
-		syslog(LOG_DEBUG, "%s: krb5_cc_default returned %d", __func__, ret);
-		return NULL;
+		ret = krb5_cc_resolve(context, env_cachename, &cc);
+		if (ret) {
+			syslog(LOG_DEBUG, "%s: krb5_cc_resolve(%s) failed: %d\n",
+			       __func__, env_cachename, ret);
+			return NULL;
+		}
+	} else {
+		ret = krb5_cc_default(context, &cc);
+		if (ret) {
+			syslog(LOG_DEBUG, "%s: krb5_cc_default returned %d",
+			       __func__, ret);
+			return NULL;
+		}
 	}
 
 	ret = krb5_cc_get_full_name(context, cc, &cachename);
-- 
2.55.0

