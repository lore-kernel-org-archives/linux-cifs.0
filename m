Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B804A3E
	for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138314; cv=none; b=HLd8COLYcClh9dwzGBkdOiDzkc8SeoP0CXyXhmGwf/+rCJeyfxqUuskFLGZaiMRiuDTEbycpBFe1Da98pWhy1E/iVel77U/HxvlPB5mhekWez5QSE5StRsgsoECFU6YQFNYtNydeWF501fsuwOXFz3PiYXxZWGokAJDV+KFzmNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138314; c=relaxed/simple;
	bh=Slu/X9FIo4J4MC9hpJSXM/My/TcGjzuyB76uj13580U=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=sma75t9qSQ5pQlOdLOWz7YAF/EwygE/snPve7nkKFJFYP9dDPMB5P+FQU25dyykOf/rvxlM0Q8XklnsOQrXU5DpSAoTYQ3KPXo/k174lll8aRNwVKL7m+ZecVJTZfYICxDKM2SNaFcXumso5WhZL0xAlksKqwFjClD14jWTkp+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gID9vQUW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gID9vQUW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779138310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gnP7QPdnSSBzUYY1NZF/8o1bCibnPHaZYJ5PJSKTNv0=;
	b=gID9vQUWsOTHonMwAMCoML0QA6SnxOd4zL83if+RHoyMfJVY5/b/h3l85VqbhZ6h5OG/aN
	PnO1yw3UggfX2iWPqHAldz/KXxSHNflUx7don2WhZoQpp3Pws+kqYtJE7HlIfw+ROj0c+b
	ZeF4wUx9e2Qt7gv4nOwcIdFaaa0pKJU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-100-13NvZVqUNBSJRTG9OSSpnA-1; Mon,
 18 May 2026 17:05:06 -0400
X-MC-Unique: 13NvZVqUNBSJRTG9OSSpnA-1
X-Mimecast-MFC-AGG-ID: 13NvZVqUNBSJRTG9OSSpnA_1779138305
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B9111956089;
	Mon, 18 May 2026 21:05:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BB9E01956053;
	Mon, 18 May 2026 21:05:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260518194622.GA2914683@ax162>
References: <20260518194622.GA2914683@ax162> <20260518-vfs-7.1-rc5.fixes-3eded3a501f4@brauner>
To: Nathan Chancellor <nathan@kernel.org>,
    Steve French <sfrench@samba.org>
Cc: dhowells@redhat.com, Christian Brauner <brauner@kernel.org>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>
Subject: Re: [GIT PULL for v7.1] vfs fixes
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <406980.1779138300.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 18 May 2026 22:05:00 +0100
Message-ID: <406981.1779138300@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Nathan Chancellor <nathan@kernel.org> wrote:

> > David Howells (22):
> >       netfs: Fix potential for tearing in ->remote_i_size and ->zero_p=
oint
> ...
> >  fs/smb/client/cifsfs.c       |  38 ++++--
> =

> The changes in this file from that patch breaks the build with clang:
> =

>   fs/smb/client/cifsfs.c:1390:29: error: variable 'old_size' is uninitia=
lized when used here [-Werror,-Wuninitialized]
>    1390 |                 if (rc =3D=3D 0 && new_size > old_size) {
>         |                                           ^~~~~~~~
>   fs/smb/client/cifsfs.c:1307:37: note: initialize the variable 'old_siz=
e' to silence this warning
>    1307 |         unsigned long long i_size, old_size, new_size, zero_po=
int;
>         |                                            ^
>         |                                             =3D 0
>   fs/smb/client/cifsfs.c:1375:13: error: variable 'zero_point' is uninit=
ialized when used here [-Werror,-Wuninitialized]
>    1375 |         if (fend > zero_point)
>         |                    ^~~~~~~~~~
>   fs/smb/client/cifsfs.c:1307:59: note: initialize the variable 'zero_po=
int' to silence this warning
>    1307 |         unsigned long long i_size, old_size, new_size, zero_po=
int;
>         |                                                               =
   ^
>         |                                                               =
    =3D 0
>   2 errors generated.

For some reason, make W=3D1 with gcc doesn't seem to generate uninitialise=
d
variable warnings (though maybe clang does?).  Is that specifically
suppressed?

	ifdef CONFIG_CC_IS_GCC
	KBUILD_CFLAGS +=3D -Wno-maybe-uninitialized
	endif

I guess.  Can we remove that?

> There were no -next updates last week, so it seems like the majority of
> this pull request saw zero -next testing time. I see two kbuild test
> robot build reports but I guess they were ignored.
> =

>   https://lore.kernel.org/202605031459.eX5UbO3K-lkp@intel.com/
>   https://lore.kernel.org/202605021450.ca5QGqLH-lkp@intel.com/

Gmail labelled them as spam :-(

I think this should be fixed as below, but Steve needs to look it over.

David
---
commit dd962b95985a8b5bc564c5c4f6c48edbc2cbc02d
Author: David Howells <dhowells@redhat.com>
Date:   Mon May 18 21:45:45 2026 +0100

    cifs: Fix undefined variables
    =

    Fix a couple of undefined variables introduced by the patch to fix tea=
ring
    on ->remote_i_size and ->zero_point.  For some reason, make W=3D1 with=
 gcc
    doesn't give undefined variable warnings (but clang does).
    =

    Fixes: 2c8f4742bb76 ("netfs: Fix potential for tearing in ->remote_i_s=
ize and ->zero_point")
    Reported-by: kernel test robot <lkp@intel.com>
    Closes: https://lore.kernel.org/oe-kbuild-all/202605031459.eX5UbO3K-lk=
p@intel.com/
    Closes: https://lore.kernel.org/oe-kbuild-all/202605021450.ca5QGqLH-lk=
p@intel.com/
    cc: Steve French <sfrench@samba.org>
    cc: Paulo Alcantara <pc@manguebit.org>
    cc: Matthew Wilcox <willy@infradead.org>
    cc: Christian Brauner <brauner@kernel.org>
    cc: linux-cifs@vger.kernel.org
    cc: netfs@lists.linux.dev
    cc: linux-fsdevel@vger.kernel.org

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index feac491c5070..f557eb7875c7 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1304,7 +1304,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 	struct cifsFileInfo *smb_file_src =3D src_file->private_data;
 	struct cifsFileInfo *smb_file_target =3D dst_file->private_data;
 	struct cifs_tcon *target_tcon, *src_tcon;
-	unsigned long long i_size, old_size, new_size, zero_point;
+	unsigned long long i_size, new_size;
 	unsigned long long destend, fstart, fend;
 	unsigned int xid;
 	int rc;
@@ -1372,7 +1372,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 		goto unlock;
 =

 	spin_lock(&target_inode->i_lock);
-	if (fend > zero_point)
+	if (fend > target_cifsi->netfs._zero_point)
 		netfs_write_zero_point(target_inode, fend + 1);
 	i_size =3D target_inode->i_size;
 	spin_unlock(&target_inode->i_lock);
@@ -1387,7 +1387,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 	if (target_tcon->ses->server->ops->duplicate_extents) {
 		rc =3D target_tcon->ses->server->ops->duplicate_extents(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
-		if (rc =3D=3D 0 && new_size > old_size) {
+		if (rc =3D=3D 0 && new_size > i_size) {
 			truncate_setsize(target_inode, new_size);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      new_size);

