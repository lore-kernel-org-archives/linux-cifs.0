Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778FF33D6D2
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784910647; cv=none; b=fPP8bbqEbmThP9J1Pk1agOXBqOljBvoIoVCjscU+zTAMhLOCl+4wzOXJjkq0EcfiZn8S9coOgCkYI9MGoUZjRHCtaQHq3JwkHsKAHnSq6jyXOk/SL51f01eElXaw8yK+PzfG0+cVkxRgqsLjkEaWPlfA83+4AZGTCAg+Pb/2Gx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784910647; c=relaxed/simple;
	bh=LAWBKUX68vBtFjuKrlLt+7kJegi9izWqIZ4Z6b0Alck=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho4nYiVx7q5Jv/7aOy7ceIGsIyEBTLvXXzpqxslHJ2mARP835na3uiIDg9Qyxjb21K1KJAkEvv/NEf7FdufnHmN9g/cdw/ZDZAQyUmbvNfm0QZQCf3g3oV66s7rnK3ne+VHsBy0HR8TPeqbCRkl1E6TJ9FTPYoM7TxiWxxOFPIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UFbWvbNQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pu0iNhLe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFbWvbNQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pu0iNhLe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784910645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lXjOz7YFCYFLHkS4GyCGzvBQTBo4d60zUZg7aM5eSKw=;
	b=UFbWvbNQwBXs8shAt79VMp0/QTzAyQzQwW91d2s2Chu6DSWS6z05OptX3KJ8WM8RIDCD3R
	R/CTm0J6ZLD1BQ5d1NWf8zmG6dF4N2N9KXiTW2UWXylKGhHrgedTK6Ia/GegdzjEcHObqy
	1QeOQneKc938BSs3KNw1waYcsQXMfvU=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-vNW12GMBMoWWDuOqlMy9vQ-1; Fri, 24 Jul 2026 12:30:44 -0400
X-MC-Unique: vNW12GMBMoWWDuOqlMy9vQ-1
X-Mimecast-MFC-AGG-ID: vNW12GMBMoWWDuOqlMy9vQ_1784910643
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e99ff505c2so267920a34.1
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 09:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784910643; x=1785515443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lXjOz7YFCYFLHkS4GyCGzvBQTBo4d60zUZg7aM5eSKw=;
        b=Pu0iNhLeOkmiCnjywmIzqe/OApOaRjcgmZ9yOfC7GBrb2XVBkay7XIQMrs0IhsSZ68
         xw9I8lP3rm72lhMhoEUGxxlaFO/7W2SEuAAwuj39wzqInzsVf3GCuOiqoTR+bCaqf5um
         snSxUPlPBIBCXTZqQKkccPh7HqwTnGdslNEhbbYC+gfRATsrymysMcOVjZ80zN6hS57M
         rvdFM0ohnkGfUx0mqb3bcryD0/p9uw9G3z8aYR0tK3G4idjAOirtsSTrJ//XsLK0WKtU
         T2x+Cs/W0vVPXyXrRzSMGQ+NN9Na7Ef4GgfiPuQBIQoCcWf4/B41vASEqsMWENulkI23
         i0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784910643; x=1785515443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=lXjOz7YFCYFLHkS4GyCGzvBQTBo4d60zUZg7aM5eSKw=;
        b=MhiB8Ko/RkpJFtiv831S0Jei9yv/f5o9DiYxKPUHRENr85QsZChsAq85EgPMLzdv3e
         RcJTSfEdWS2Mx/lXKg62uv6Y2PEweOqjBZ0LSJZigqSeUpRmsTNFuQVcugFmZ/Z7LmYg
         otLMn14zaB8Df79/YLcxnFExViKO6x/OVu+O1+EvBayysD8IhnGVxZfn3VBmH62mL4aH
         Ope0TB+Z6tBCMUnMdNOuyM0T7U2ItusOXZ/V6HG/9OzPf2rEPlyY3P10pUQdDqtZbqwc
         7qaccIsYQdEMuZWY0jCrBABTpnHqk65qCWeEbjNM6Nl8CUafILvf6fk118JdhWNvA4oa
         7Zew==
X-Gm-Message-State: AOJu0YxMjSsXKoycO0b+I/9N8BsMFlmKDRYdaTzjLESfFkeHrWyG0Tgi
	Sx93rPoqFVZhXQZV2AoyHmasV6uq8QsI305V7gv66vgx+hJ2n9BCo0mb3erAAo3M2ybc0BGH/SL
	1jb2+2uemJlBG4ebFsp6DIqoCcIxxEt5pCyHBGUZyKKQGLC6hE1QvJpeRuB0gexU280gFoFDxSf
	0ZdrSqRw3jg0Uwi1rGI2swvxnAiShLoOFvhJ4z4hvM5/t9ZLo=
X-Gm-Gg: AR+sD10WB8qSy83QDyV+c1VQVNT2VhxP8B8BC0LRq71KU4MMD1OcE6+nek9GmAr9U1a
	uvK9D46eqnbPXsFy1hnkjG9XxlKwN9BwI4a4lHwNqePdbw8ETgOBBPstaXNMdHb+PXqEUMDUeNW
	omWy1sOmp0tNyW+ntFzilnZgG5Vhcb48LDYBk6dH9QgMwW0qG5H0oJmMgFHcCPy64IOG2FzRPRS
	qA/ZSa2+cYyD9j+x4Zi6XhXnzHxDWpK2zL+XSbmwcF1Q6z2lW+c6YvumyRc7U0LsTmEAEnjbkkV
	iB/Ah21h8/KyS2Ix3lHNCh3VPvG6e2PBSNDHMzRsEBfZjW/DK2i3QO6hU19QgVm1kX+fEIxTKlR
	AaTfTidUxctT3bZ2lzl1hW6a46jrP2BdVfFYqUC8AscYETrZU7SGWvDGxdWwr
X-Received: by 2002:a05:6830:8385:b0:7eb:3af8:8c06 with SMTP id 46e09a7af769-7ee43ae38e7mr5710670a34.12.1784910643091;
        Fri, 24 Jul 2026 09:30:43 -0700 (PDT)
X-Received: by 2002:a05:6830:8385:b0:7eb:3af8:8c06 with SMTP id 46e09a7af769-7ee43ae38e7mr5710617a34.12.1784910642388;
        Fri, 24 Jul 2026 09:30:42 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a03d30asm6351819a34.18.2026.07.24.09.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 09:30:40 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 2/2] cifs: fix time_last_write stamp placement in setattr/truncate paths
Date: Fri, 24 Jul 2026 11:30:36 -0500
Message-ID: <20260724163036.2670328-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260724163036.2670328-1-sorenson@redhat.com>
References: <20260724163036.2670328-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_file_set_size() calls cifs_setsize() on success, which calls
i_size_write(), updating i_size to the new value.  The subsequent
check attrs->ia_size != i_size_read() in both cifs_setattr_unix()
and cifs_setattr_nounix() therefore always evaluates false after a
successful cifs_file_set_size(), making the smp_store_release() of
time_last_write dead code.  The truncate path was unprotected against
stale readdir size updates.

Move the stamp to before the cifs_file_set_size() RPC call, guarded
by attrs->ia_size != i_size_read() to exclude no-op same-size
ftruncate(2) calls from stamping time_last_write unnecessarily.

On the error path the stamp remains rather than being restored:
restoring a stale snapshot (prev_tlw) could silently erase a
concurrent _cifsFileInfo_put() close stamp if that close arrived
between the READ_ONCE and the smp_store_release.  readdir is
suppressed until the stamp expires, which extends beyond one acregmax
if the caller retries failed truncations.  stat() is unaffected: the
cifs_revalidate_dentry_attr() path calls cifs_fattr_to_inode() with
from_readdir=false, which bypasses the time_last_write check in
is_size_safe_to_change() entirely and always writes the authoritative
QUERY_INFO result to i_size.

Remove the now-unreachable stamp from the dead block in both functions.

Fixes: e8a8d54c2d50 ("cifs: prevent readdir from changing file size due to stale directory metadata")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/inode.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b2806371bfde..808085eb0cdc 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3190,6 +3190,17 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if (attrs->ia_valid & ATTR_SIZE) {
+		if (attrs->ia_size != i_size_read(inode)) {
+			/* Stamp before RPC. On failure the stamp remains: restoring a
+			 * stale snapshot could silently erase a concurrent
+			 * _cifsFileInfo_put() close stamp.  readdir is suppressed
+			 * until the stamp expires; stat() bypasses this via the
+			 * from_readdir=false path in is_size_safe_to_change() and
+			 * always returns an authoritative QUERY_INFO result.
+			 * Pairs with smp_load_acquire() in is_size_safe_to_change().
+			 */
+			smp_store_release(&cifsInode->time_last_write, jiffies);
+		}
 		rc = cifs_file_set_size(xid, direntry, full_path,
 					open_file, attrs->ia_size);
 		if (rc != 0)
@@ -3279,8 +3290,6 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
-		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-		smp_store_release(&cifsInode->time_last_write, jiffies);
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
@@ -3370,6 +3379,17 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	}
 
 	if (attrs->ia_valid & ATTR_SIZE) {
+		if (attrs->ia_size != i_size_read(inode)) {
+			/* Stamp before RPC. On failure the stamp remains: restoring a
+			 * stale snapshot could silently erase a concurrent
+			 * _cifsFileInfo_put() close stamp.  readdir is suppressed
+			 * until the stamp expires; stat() bypasses this via the
+			 * from_readdir=false path in is_size_safe_to_change() and
+			 * always returns an authoritative QUERY_INFO result.
+			 * Pairs with smp_load_acquire() in is_size_safe_to_change().
+			 */
+			smp_store_release(&cifsInode->time_last_write, jiffies);
+		}
 		rc = cifs_file_set_size(xid, direntry, full_path,
 					cfile, attrs->ia_size);
 		if (rc != 0)
@@ -3482,8 +3502,6 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
-		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-		smp_store_release(&cifsInode->time_last_write, jiffies);
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-- 
2.55.0

