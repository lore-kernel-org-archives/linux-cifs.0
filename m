Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184AF86262
	for <linux-cifs@vger.kernel.org>; Fri, 24 May 2024 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560632; cv=none; b=tN8Kj7q2i+OT0s+iPLIyWFFBAb8vAwvmmzXUxD5d1/f2tAtea73Mz/i5Glf9qNnmgYgiWIaAGah56+k5nis502vDe9CTXBFUKTHpwuVn0KnRvo2sNCs0eVrkWSzbP8HxWRUlPc6LCkXzpEArXeEkDm2JqOkn2BzA+LxLBAz6A54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560632; c=relaxed/simple;
	bh=EpoHsjB4EOCos3U2u+XvJyYSt6At/bEiZlRNqBU3718=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=gb2/I5Knqg3J5REt/J1dxUFfGn4YcKF24HkGxxgBOHBnM4msSF1aOz/bBrV7OZYRnSnwQdVHAT8zX33qkrnD5dbeL08fyXe1FzvEm8dJq/miGfLRVsoULjGKSFBcijomGwtWx+w4E/4FG1Bm3cVtu1hCO1hacpQfMw4JFWENSGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hPbKOQgK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPbKOQgK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716560629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0AzS/2TqPoHiXyqv0zYxlSb1DTSMYdwN2BmrfNFCiwg=;
	b=hPbKOQgKxcriIcktceY+ylUSWQqprd7xN1c6EpXxn58Zzy3BS4E7PXwRtgKeQLvtL3+UQf
	i7JZZed1MbxKXTdXx+uu5FkdHAM4IOBIoAjW6ushCzdt9qkTuF/4A8iWxfN+9kh6swUDPe
	BJUZqp03M6Ow0llndvXPazw4V1RuK/M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-yPthP4h7N7-bmYUuQbCbkQ-1; Fri, 24 May 2024 10:23:45 -0400
X-MC-Unique: yPthP4h7N7-bmYUuQbCbkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B384881227E;
	Fri, 24 May 2024 14:23:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B0D740C6EB7;
	Fri, 24 May 2024 14:23:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>,
    Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix missing set of remote_i_size
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <755786.1716560616.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 May 2024 15:23:36 +0100
Message-ID: <755787.1716560616@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Occasionally, the generic/001 xfstest will fail indicating corruption in
one of the copy chains when run on cifs against a server that supports
FSCTL_DUPLICATE_EXTENTS_TO_FILE (eg. Samba with a share on btrfs).  The
problem is that the remote_i_size value isn't updated by cifs_setsize()
when called by smb2_duplicate_extents(), but i_size *is*.

This may cause cifs_remap_file_range() to then skip the bit after calling
->duplicate_extents() that sets sizes.

Fix this by calling netfs_resize_file() in smb2_duplicate_extents() before
calling cifs_setsize() to set i_size.

This means we don't then need to call netfs_resize_file() upon return from
->duplicate_extents(), but we also fix the test to compare against the pre=
-dup
inode size.

[Note that this goes back before the addition of remote_i_size with the
netfs_inode struct.  It should probably have been setting cifsi->server_eo=
f
previously.]

Fixes: cfc63fc8126a ("smb3: fix cached file size problems in duplicate ext=
ents (reflink)")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
---
 fs/smb/client/cifsfs.c  |    6 +++---
 fs/smb/client/smb2ops.c |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 14810ffd15c8..bb86fc0641d8 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1227,7 +1227,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 	struct cifsFileInfo *smb_file_src =3D src_file->private_data;
 	struct cifsFileInfo *smb_file_target =3D dst_file->private_data;
 	struct cifs_tcon *target_tcon, *src_tcon;
-	unsigned long long destend, fstart, fend, new_size;
+	unsigned long long destend, fstart, fend, old_size, new_size;
 	unsigned int xid;
 	int rc;
 =

@@ -1294,6 +1294,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 		goto unlock;
 	if (fend > target_cifsi->netfs.zero_point)
 		target_cifsi->netfs.zero_point =3D fend + 1;
+	old_size =3D target_cifsi->netfs.remote_i_size;
 =

 	/* Discard all the folios that overlap the destination region. */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
@@ -1306,9 +1307,8 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 	if (target_tcon->ses->server->ops->duplicate_extents) {
 		rc =3D target_tcon->ses->server->ops->duplicate_extents(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
-		if (rc =3D=3D 0 && new_size > i_size_read(target_inode)) {
+		if (rc =3D=3D 0 && new_size > old_size) {
 			truncate_setsize(target_inode, new_size);
-			netfs_resize_file(&target_cifsi->netfs, new_size, true);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      new_size);
 		}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b87b70edd0be..4ce6c3121a7e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2028,6 +2028,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		 * size will be queried on next revalidate, but it is important
 		 * to make sure that file's cached size is updated immediately
 		 */
+		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
 		cifs_setsize(inode, dest_off + len);
 	}
 	rc =3D SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,

