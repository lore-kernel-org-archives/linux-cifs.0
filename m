Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E6D1EEA3C;
	Thu, 16 Apr 2026 22:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776379171; cv=none; b=Z6M6OeVIex0O9+0GbvS9g5s5LSTiKJTzjLV+0pyBdIu5J3ZfG6J6jil/90il+Zld4mzjqfaBrHTCwNHXfWerLrUZFb/BtSt2+2jB2iUJ0OhSCCfINJR3ucMb10TLnXNKDD3/uc4WduXTrtmD8VzjwTh2OHgOdA3Av92tHfISG6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776379171; c=relaxed/simple;
	bh=M6MEtYZgwyBUvY0DzYJj79BbhVpDuuKR5yZPKef031U=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=q75rwwdzdCl0zq2fiZv/sRZHX8uqJL7o/EqeKu8m1Juvlx6TBCgcFKQ5v7Y2G+ZKWBeRt6AeQo6i1Q3SkRcd1RzYkhfwJPujCcUIi0uckJvSKUN4u46d/zEgFw2ewrBZMTaSB2smOSEAcyWry6WNG4b/ZetPRVDCPtt/LYirchA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=E40E2nvg; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="E40E2nvg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c5E3+2kIXLzzP6I5UWQUKTou9IfvDQG4/ARPk5KjOyc=; b=E40E2nvgWxBnHl3S9IA4G6jSxn
	rMDH2KGgotCa/cR+OakYhb5eGuPgAwFCy1Bot/QkdUKkG6+RXmuZxKI3wfSRnUg9/5vNwH/2J3YHw
	Uk4Sr9jhSQ2ifLSF1szXsNmWAmNJbj4GNmZ046C/LyT5bdHIDyetdn6c5KvVk4l+TToZP4P+cXNfY
	85AJiiTNzNIyg51Z8c/iDnzUckdo5aeJyIwKLgUGwOIoQBgWCEEnT8EH+UrkhVREbSINX9PMczDZu
	w7IrYep8IuLlog4NJnXfO1nwLwJilq82iCBYhrwrLJi/P7wu9Nx6svNp9k+3XbDodqXixZYP7ta8t
	eH9moWXQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wDVMk-00000000IrL-2ATX;
	Thu, 16 Apr 2026 19:39:18 -0300
Message-ID: <9271841dd415d9d0b42ab91c575a1f91@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Cifs <linux-cifs@vger.kernel.org>
Subject: Re: [REGRESSION] in Linux 7.0: empty CIFS mount point with vers=1.0
In-Reply-To: <f758f4ff-4d54-4244-931d-38f469c3ff14@moonlit-rail.com>
References: <f758f4ff-4d54-4244-931d-38f469c3ff14@moonlit-rail.com>
Date: Thu, 16 Apr 2026 19:39:17 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com> writes:

> A bit late to the party, sorry, I should have reported this in 7.0-rcX.
>
> When mounting a CIFS share with vers=1.0, the mount "succeeds" (is added 
> to /proc/mounts) but the mountpoint is completely empty.  Even "." and 
> ".." are missing.  Blindly accessing a known file results in "no such 
> file or directory".

Thanks for the report.

Does the following fix your issue

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 69b38f0ccf2b..7a4249628ac4 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3628,6 +3628,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 		sbflags |= CIFS_MOUNT_POSIX_PATHS;
 		sbflags &= ~(CIFS_MOUNT_MAP_SFM_CHR |
 			     CIFS_MOUNT_MAP_SPECIAL_CHR);
+		atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
 	}
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
@@ -3652,6 +3653,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 		tcon->unix_ext = 0; /* server does not support them */
 
 	/* do not care if a following call succeed - informational */
+	sbflags = cifs_sb_flags(cifs_sb);
 	if (!tcon->pipe && server->ops->qfs_tcon) {
 		server->ops->qfs_tcon(mnt_ctx->xid, tcon, cifs_sb);
 		if (sbflags & CIFS_MOUNT_RO_CACHE) {
@@ -3675,7 +3677,6 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 
 out:
 	mnt_ctx->tcon = tcon;
-	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
 	return rc;
 }
 
