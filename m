Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18A279DA8
	for <linux-cifs@vger.kernel.org>; Thu,  4 Sep 2025 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757020733; cv=none; b=fG7Ae841rAWyQwUa0SlqeQfMLjya6mT4H15GgSEU6GXIA2TQGx7k5UVFPyrPc+SKMTqP33K/OnQ3iVmYRsPBgkwYSCPiEp0IPODPHWHyTRGtJuk2/8oTpRZqJ6DjnsFg0wS3e0tNEFFSnv0z7skb4OfFgs6YE8hFG5IfnTr/5z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757020733; c=relaxed/simple;
	bh=toUy770fWT5ZQQS6Bye69imEYlcZlWlQHnEEVSfF/jU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tyw87qOTH7jCiyN7SW7Ndax5mVrlfF1YNYhFwEjS5nIt2hNR9Dkxh80m9/Ugxt0uKedy2BiRN96ZOYi+1rWaHP6mxu5mxQ6H+yiYVCkNmGpx+ZOI1wUzWvG6PQvyDbIOc4CWn6gnOWqE7LKiaUKOGhKbqdgbmZWqM+J6zENB83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R5PpxJEV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5PpxJEV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757020730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1iJ0BuIyKASK0eSWO2S5y6aZpYu0xtpDA/7PvZ3J/90=;
	b=R5PpxJEVGzcBYl/vFRXRj15XdYGV2HNJewkJ8c7x4WuNKJW47VTObUM4tGYa6PXkP54O3W
	2GIs3nlpH5ppH1qAZ6ZY6y+Q44ITAme9ZP90xfBMjKuixbKzEovYdr8OB8N84ypFKDj6uL
	3trNW+5V0lK+wQZWqjO0bRsne3esC+A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-HiyZMTghMRGnWATvJvbbZA-1; Thu,
 04 Sep 2025 17:18:45 -0400
X-MC-Unique: HiyZMTghMRGnWATvJvbbZA-1
X-Mimecast-MFC-AGG-ID: HiyZMTghMRGnWATvJvbbZA_1757020724
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F3CB1800378;
	Thu,  4 Sep 2025 21:18:44 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C2A5B3002D27;
	Thu,  4 Sep 2025 21:18:42 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	linux-cifs@vger.kernel.org
Subject: [RFC PATCH 0/2] cifs: Organise declarations in the cifs client header files
Date: Thu,  4 Sep 2025 22:18:31 +0100
Message-ID: <20250904211839.1152340-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Steve,

Would you be interested in this pair of patches?  The second patch
organises the declarations in the cifs client header files, naming the
arguments the same as for the implementations, inserting divider comments,
ordering them the same as they're found in the files and dividing them
better between general, smb1 and smb2/3 categories.

The organisation is entirely scripted with the script in the second patch's
commit message.  The first patch does a bit of preparation to make sure
that the second patch's output will build.

David

David Howells (2):
  cifs: Do some preparation prior to organising the function
    declarations
  cifs: Clean up declarations

 fs/smb/client/cached_dir.h    |   19 -
 fs/smb/client/cifs_debug.c    |    4 +-
 fs/smb/client/cifs_debug.h    |    5 -
 fs/smb/client/cifs_spnego.h   |    2 -
 fs/smb/client/cifs_swn.h      |   15 +-
 fs/smb/client/cifs_unicode.c  |    1 +
 fs/smb/client/cifs_unicode.h  |   16 -
 fs/smb/client/cifsacl.c       |    1 +
 fs/smb/client/cifsfs.c        |    5 +-
 fs/smb/client/cifsfs.h        |   64 --
 fs/smb/client/cifsglob.h      |   19 +-
 fs/smb/client/cifspdu.h       |   12 -
 fs/smb/client/cifsproto.h     | 1228 ++++++++++++++++-----------------
 fs/smb/client/cifssmb.c       |    1 +
 fs/smb/client/cifstransport.c |    1 +
 fs/smb/client/compress.c      |   15 +
 fs/smb/client/compress.h      |   18 +-
 fs/smb/client/connect.c       |    1 +
 fs/smb/client/dfs.h           |    4 -
 fs/smb/client/dfs_cache.h     |   16 -
 fs/smb/client/dir.c           |    1 +
 fs/smb/client/dns_resolve.h   |    3 -
 fs/smb/client/file.c          |    1 +
 fs/smb/client/fs_context.c    |    2 +-
 fs/smb/client/fs_context.h    |    9 -
 fs/smb/client/fscache.h       |   13 +-
 fs/smb/client/inode.c         |    1 +
 fs/smb/client/ioctl.c         |    1 +
 fs/smb/client/link.c          |    1 +
 fs/smb/client/misc.c          |    1 +
 fs/smb/client/netlink.h       |    3 -
 fs/smb/client/netmisc.c       |    2 +-
 fs/smb/client/nterr.h         |    2 -
 fs/smb/client/ntlmssp.h       |   13 -
 fs/smb/client/reparse.h       |   11 -
 fs/smb/client/sess.c          |    1 +
 fs/smb/client/smb1ops.c       |    2 +
 fs/smb/client/smb1proto.h     |  230 ++++++
 fs/smb/client/smb2pdu.h       |    2 -
 fs/smb/client/smb2proto.h     |  536 +++++++-------
 fs/smb/client/smbdirect.h     |   27 +-
 41 files changed, 1157 insertions(+), 1152 deletions(-)
 create mode 100644 fs/smb/client/smb1proto.h

