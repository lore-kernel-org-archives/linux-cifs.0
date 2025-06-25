Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D3D20D4E9
	for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 08:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838403; cv=none; b=tqJNSB6ofas4qwZp0JhP+0YTaGiMtHflYvhIejchL+FBdthSZH59IAUnozZkxQA/mcT0gJicnH4BUZMk3X+po7zytgcnzc002eJNFvLpAWqjtXipwptZp6n7t0WxscMTPAl3KvS7KWgjOiUJQqaHhZ6dTxqjHrZVfz+cE4OS/1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838403; c=relaxed/simple;
	bh=ok2zcduylSLPuQ08LPvrPjx7/BMsFb8nzskxeEVfGEg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jkmr7c8LdUTcbui2W9v0Y9z4q2RKT8ngq1i8tParvK40Zr3jYXBOU8NhMVZUmpn2jGyqUJ7MulFSjW3YltyzHm2URVtMnGsM9oq8WdL2smZDeasBjYTikv1TmAvXJy3QJ4WDRQprbdQUMt+8wjeanp7NTv7HpECMd+XtBqG/Na8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFEpFeE5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFEpFeE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750838400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tyi9H1qTeuJ+JiGcYYKvHvC8+lP4wLn8hRYwDmu822A=;
	b=QFEpFeE5VXh80VCL3keu9fy4v9/CSsnIamv9AzanT4at9UF7t0LbsPN5pi4VLVh+y9b4k8
	jzwCLC2m848RanGpighwCKbEGpIkL6WAeVigVCyhWu7oY0MOGOfiI/UrFt2WvtZxIt6QUh
	9aJjCXXCdJWcxrwZjJ1ziRSQSD9W818=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-J8SZNE6GNrWT-9fTAnyI5Q-1; Wed,
 25 Jun 2025 03:59:55 -0400
X-MC-Unique: J8SZNE6GNrWT-9fTAnyI5Q-1
X-Mimecast-MFC-AGG-ID: J8SZNE6GNrWT-9fTAnyI5Q_1750838394
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 354BA180120D;
	Wed, 25 Jun 2025 07:59:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A5C041956096;
	Wed, 25 Jun 2025 07:59:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <962036.1750422586@warthog.procyon.org.uk>
References: <962036.1750422586@warthog.procyon.org.uk> <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com> <cover.1750264849.git.metze@samba.org> <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
To: Tom Talpey <tom@talpey.com>, Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
    Steve French <sfrench@samba.org>
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1283545.1750838391.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Jun 2025 08:59:51 +0100
Message-ID: <1283546.1750838391@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

David Howells <dhowells@redhat.com> wrote:

> > > +		if (iter && iov_iter_count(iter) > 0) {
> > > +			/*
> > > +			 * There is more data to send
> > > +			 */
> > > +			goto wait_credit;
> > =

> > But, shouldn't the caller have done this overflow check, and looped on
> > the fragments and credits? It seems wrong to push the credit check dow=
n
> > to this level.
> =

> Fair point.  There's retry handling in the netfs layer - though that onl=
y
> applies to reads and writes that go through that.  Can RDMA be used to
> transfer data for other large calls?  Dir enumeration or ioctl, for inst=
ance.

Actually, I'm wrong.  We do need this because we can come down this path f=
rom
non-netfs generated RPC ops.  I stuck a WARN_ON_ONCE() on the path to see =
what
generated it, and got:

 WARNING: CPU: 0 PID: 6773 at fs/smb/client/smbdirect.c:980 smbd_post_send=
_iter+0x768/0x840
 ...
 RIP: 0010:smbd_post_send_iter+0x768/0x840
 ...
 Call Trace:
  <TASK>
  smbd_send+0x1bb/0x280
  ? __smb_send_rqst+0x7c/0x3c0
  __smb_send_rqst+0x7c/0x3c0
  ? rb_erase+0x30/0x280
  smb_send_rqst+0x6a/0x150
  ? remove_hrtimer+0x5e/0x70
  compound_send_recv+0x31b/0x650
  ? __kmalloc_noprof+0x262/0x290
  ? kmem_cache_debug_flags+0xc/0x20
  cifs_send_recv+0x1f/0x30
  SMB2_open+0x22d/0x4b0
  ? smb2_open_file+0xd3/0x310
  smb2_open_file+0xd3/0x310
  cifs_nt_open+0x182/0x280
  cifs_open+0x463/0x650
  ? __pfx_cifs_open+0x10/0x10
  ? do_dentry_open+0x218/0x390
  do_dentry_open+0x218/0x390
  vfs_open+0x28/0x50
  do_open+0x216/0x2c0
  path_openat+0x140/0x1b0
  do_filp_open+0xb8/0x120
  ? kmem_cache_debug_flags+0xc/0x20
  ? kmem_cache_alloc_noprof+0x201/0x230
  ? getname_flags.part.0+0x24/0x180
  do_sys_openat2+0x6e/0xc0
  do_sys_open+0x37/0x60
  __x64_sys_openat+0x1b/0x30
  do_syscall_64+0x80/0x170
  entry_SYSCALL_64_after_hwframe+0x71/0x79

David

