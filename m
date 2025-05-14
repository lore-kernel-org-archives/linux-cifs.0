Received: from emily.smtp.mailx.hosts.net.nz (emily.smtp.mailx.hosts.net.nz [43.245.52.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540FC15AF6
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.245.52.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747229868; cv=none; b=plIBFbAzexDyLrMoXpWbJivLg4moo2MemdCiDcDvLWsVm0yTHauyiPYDTCDZbV33kIoJPOT42e/ZYLcSrhPLkyyGvWwyTEEbLK3c3eMFB962Z9d61tcKE6XYuqL+Mpa05Dpobqy6bGtZnlI6/EzPTwr32DkAqxtjfjRY5byz1Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747229868; c=relaxed/simple;
	bh=ZEuvAh06m1pwIoRgmlidNTEyohnCdEAatmYP4SX6YBw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Vxj82EYr413yGok48WpTAzHLx1rc8WO4Jbv3g0rafj8UYDe+AHzc56xsqjofk+mYg51P6JPcSy0uS5IcPDjnxREo6DLiVs7IUWseP3GEpYMF4c1sz9fWz1CY5HaonjqNaDPpGCAzajOeAUlvQgjiIptUa52JHJ+s+Di31kUW6vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jro.nz; spf=pass smtp.mailfrom=jro.nz; arc=none smtp.client-ip=43.245.52.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jro.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jro.nz
Received: from [101.53.218.81] (helo=deetop.local.jro.nz)
	by emily.smtp.mailx.hosts.net.nz with esmtpsa authed as jro.nz  (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <devel@jro.nz>)
	id 1uFC2n-004Jhz-15;
	Thu, 15 May 2025 01:21:09 +1200
Date: Thu, 15 May 2025 01:23:23 +1200
From: Jethro Donaldson <devel@jro.nz>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org, pc@manguebit.com
Subject: [PATCH] smb: client: fix memory leak during error handling for
 POSIX mkdir
Message-ID: <20250515012323.28f38839@deetop.local.jro.nz>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Hosts-DKIM-Check: none

smb: client: fix memory leak during error handling for POSIX mkdir

The response buffer for the CREATE request handled by smb311_posix_mkdir()
is leaked on the error path (goto err_free_rsp_buf) because the structure
pointer *rsp passed to free_rsp_buf() is not assigned until *after* the
error condition is checked.

As *rsp is initialised to NULL, free_rsp_buf() becomes a no-op and the leak
is instead reported by __kmem_cache_shutdown() upon subsequent rmmod of
cifs.ko if (and only if) the error path has been hit.

Pass rsp_iov.iov_base to free_rsp_buf() instead, similar to the code in
other functions in smb2pdu.c for which *rsp is assigned late.

Signed-off-by: Jethro Donaldson <devel@jro.nz>
---

Follow up on "smb: client: fix zero length for mkdir POSIX create context"

Am tempted to change all the other calls to free_rsp_buf() in smb2pdu.c
to pass rsp_iov.iov_base, even though none of the other cases where *rsp is
passed seem to exhibit the above problem. Reasoning:

 a) more robust to re-ordering during future change, 
 b) easier to follow (acquire/release via same pointer), and
 c) more consistent

If that sounds like a good idea, please advise if a separate patch is
preferred or a v2 of this one.

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e7118501fdcc..ed3ffcb80aef 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2967,7 +2967,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	/* Eventually save off posix specific response info and timestamps */
 
 err_free_rsp_buf:
-	free_rsp_buf(resp_buftype, rsp);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	kfree(pc_buf);
 err_free_req:
 	cifs_small_buf_release(req);


base-commit: e2d3e1fdb530198317501eb7ded4f3a5fb6c881c
--
2.49.0
