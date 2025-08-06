Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B1E21C179
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754512643; cv=none; b=ZBZVLeZMcCHAJxWBcV1o5OQPpkB3Jh4o57CiNiw3gMij6exZy2BDViaYOX/qI3PwQcs5Z0F5gL9fAohEXwcB2JKoa828oWcbUytQUVCviCcRzmUQH0x3EOZwfznIMSlO6PrINDu03s7xlv0x4q/o6Hd2Bph67S5niANPj1KXlLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754512643; c=relaxed/simple;
	bh=156EHPjhWzUxzJB/4SYjHDeRq2mO+UxugzR7hwf+WMM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TThiMv/owP32hng4/jydOKydbqTfG8sb+uF0KWtxZErOsDsQEw+F1LcNZeRHWsNjqArZwG8kv1QAt8ugKYHFo1r8c7DEKi4JWAmgVPKsxNE2QKxEVBhoebR6AKjTLKAhrWveURVQ8Pr6TBpEZr803JaFH6NHlH9UadABJsHKoJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S3MTZOPu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S3MTZOPu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754512640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jeuEbb8zJCtpDnK+vT4c/1frCm+lprzodC4xYiTtKIQ=;
	b=S3MTZOPuYldl5PZvGqt7mjw0EhWmPJEwM/tLM09yhcOHTaQxaHIxYjJ/XbX1wX3MlJsJWo
	TvdRbU5TEB7Bj2sVCS/p5HF3OUpn0/9DJNyAohJdp9J4l55F8Hn80zR168UoJ7WdQH+ISh
	uVcQxqdVJgBnacDnyhw4fXgbTyIsCl4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-aNBpNrxBMSeZZnRFT-wnzQ-1; Wed,
 06 Aug 2025 16:37:17 -0400
X-MC-Unique: aNBpNrxBMSeZZnRFT-wnzQ-1
X-Mimecast-MFC-AGG-ID: aNBpNrxBMSeZZnRFT-wnzQ_1754512635
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1365719560BD;
	Wed,  6 Aug 2025 20:37:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.17])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1DF171800447;
	Wed,  6 Aug 2025 20:37:11 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES and use netmem allocator
Date: Wed,  6 Aug 2025 21:36:21 +0100
Message-ID: <20250806203705.2560493-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Steve et al,

[!] NOTE: These patches are NOT FULLY WRITTEN, won't necessarily compile
    all the way through and haven't been fully tested and this is intended
    as a preview of what I'm working on.  Basic SMB1 and SMB2+ work as far
    as "cifs: Rewrite base TCP transmission".  Encrypted, signed and RDMA
    may work but haven't been tested; compressed is disabled.  Assume that
    anything beyond the specified point won't work.

I'm trying to work towards the network filesystems being able to use
zerocopy facilities such as MSG_SPLICE_PAGES and, in doing so, I think the
cifs driver can be simplified quite a bit.

However, making it possible to use the zerocopy facilities is probably
going to mean moving away from storing the data to be transmitted in slab
pages as slab pages don't have refcounts and their lifetime rules are
unsuitable for splicing.

So what I'd like to do is to allocate protocol bufferage from the netmem
allocator.  The netmem allocator, if I understand it correctly, manages DMA
mapping and IOMMU wrangling in bulk, and works as a bump/page fragment
allocator - which has the potential to improve performance a bit.

The aim is to build up a list of fragments for each request using a bvecq.
These form a segmented list and can be spliced together when assembling a
compound request.  The segmented list can then be passed to sendmsg() with
MSG_SPLICE_PAGES in a single call, thereby only having a single loop (in
the TCP stack) to shovel data, not loops-over-loops.  Possibly we can
dispense with corking also, provided we can tell TCP to flush the record
boundaries.  (Note that this also simplifies smbd_send() for RDMA).

To make this easier, I want to introduce a "request descriptor", which I'm
calling "struct smb_message" and allocate it at a higher level, notably the
PDU encoding routines in cifssmb.c and smb2pdu.c and then hand that down
into the transport.  It will contain the list of fragments that form the
message.

smb_message then replaces mid_q_struct, absorbing its contents.  The
transport then doesn't allocate these, but uses the ones that it is given
and the I/O thread gets to simplify its refcounting and do less of it.  The
rule is that smb_message gets an extra ref when it is enqueued and whoever
dequeues it gets this ref and either puts it or hands it on.  The PDU
encoding routines get a ref when allocating them and keep the refs until
they complete.

smb_message is then given a next pointer to allow compounds to be trivially
assembled, with the protocol wrangling being done in the transport.  This
next pointer also allows a bunch of fixed-size arrays to be got rid of
(which were imposing weird restrictions like reducing the maximum component
count of a compound if we stole a kvec[] slot for the transform header).

To this end, I make the following significant changes.  Note that some of
the changes are a way to transit to a later stage.

 (1) Make SMB1 transport use the SMB2 transport rather than having parallel
     dispatch code.

     (a) Get rid of the separation of the message buffer into two kvecs,
     	 one for the rfc1002 header and one for the rest.  This seems to be
     	 only to simplify the signing code - but at the expense of making a
     	 bunch of other places more complex.

     (b) Make SendReceive() wrap cifs_send_recv() as does SendReceive2().

     (c) Get rid of SendReceiveBlockingLock() in favour of using
     	 SendReceive() and a couple of flags to request interruptible
     	 waiting and to indicate Windows-type unlock rather than lock
     	 cancellation.

 (2) Replace mid_q_struct with smb_message and also include credits and
     smb_rqst therein.

 (3) Rewrite the base TCP transmission to be able to use MSG_SPLICE_PAGES.

     (a) Copy all the data involved in a message into a big buffer formed
     	 of a sequence of pages attached to a bvecq.

     (b) If encrypting the message just encrypt this buffer.  Converting
     	 this to a scatterlist is much simpler (and uses less memory) than
     	 encrypting from the protocol elements.

     (c) As the pages in the bvecq are just that, they have refcounts and
     	 can be passed to MSG_SPLICE_PAGES - thereby avoiding the copy in
     	 TCP.

     (d) Compression should be a matter of vmap()'ing these pages to form
     	 the source buffer, allocating a second buffer of pages to form a
     	 dest buffer, also in a bvecq, vmapping that and then doing the
     	 compression.  The first buffer can then just be replaced by the
     	 second.

     (e) __smb_send_rqst() can then do a single sendmsg() with
     	 MSG_SPLICE_PAGES() from an ITER_BVECQ-type iterator.

     (f) smbd_send() can push the same buffer to smbd_post_send_iter() from
     	 the same iterator.

 (4) Clean up mid->callback_data.  Replace it with a waitqueue in
     smb_message (for most commands) and a cifs_io_subrequest pointer (for
     read and write).  Make request completion wait on the smb_message
     waitqueue rather than on server->response_q to avoid thundering herd
     issues.

     (Also, I note that under some circumstances, cifs just wakes up the
     first thing on server->response_q without any reference to *what* it
     is waking up).

 (5) Add some more bits to smb_message to hold the buffers in a bvecq with
     the intent of killing of the smb_rqst struct.

     (a) The PDU encoders will have to work out how much memory they need
     	 for the request protocol bits in advance and tell the smb_message
     	 allocator their requirements.  This will get the requested amount
     	 from the netmem allocator, so it needs to be correctly sized.  A
     	 pointer is then set in smb->request to the buffer.

     (b) The smb_message is given a pointer (->next) to chain to another
     	 message to be compounded after it.

     (c) smb_send_recv_messages() will be used to dispatch a synchronous
     	 request.  If the head smb_message's ->next pointer is not NULL, it
     	 will set the appropriate compound chaining stuff and insert
     	 appropriate padding.  Then it will link the bvecq structs of those
     	 messages together.

 (6) Convert PDU encoders to allocate and use smb_message and pass it down.

     (a) So far, SMB2 Negotiate Protocol, Session Setup, Logoff, Tree
     	 Connect and Tree Disconnect have been done - and though they build
     	 if SMB1 and compression are disabled, they won't work yet and so
     	 haven't been tested.

     (b) SMB2 Posix Mkdir has been attempted and will compile, but is
     	 likely to need rejigging as it's a close associate of Create.

     (c) SMB2 Create/Open is partially done and won't compile.  This gets
     	 complicated because it's used in a lot of places and also gets
     	 compounded - so anything that gets compounded with it must also be
     	 converted.

The patches can be found here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=cifs-experimental

Thanks,
David

David Howells (31):
  iov_iter: Move ITER_DISCARD and ITER_XARRAY iteration out-of-line
  iov_iter: Add a segmented queue of bio_vec[]
  netfs: Provide facility to alloc buffer in a bvecq
  cifs, nls: Provide unicode size determination func
  cifs: Introduce an ALIGN8() macro
  cifs: Move the SMB1 transport code out of transport.c
  cifs: Rename mid_q_entry to smb_message
  cifs: Keep the CPU-endian command ID around
  cifs: Rename SMB2_xxxx_HE to SMB2_xxxx
  cifs: Make smb1's SendReceive() wrap cifs_send_recv()
  cifs: Fix SMB1 to not require separate kvec for the rfc1002 header
  cifs: Replace SendReceiveBlockingLock() with SendReceive() plus flags
  cifs: Institute message managing struct
  cifs: Split crypt_message() into encrypt and decrypt variants
  cifs: Use netfs_alloc/free_folioq_buffer()
  cifs: Rewrite base TCP transmission
  cifs: Rework smb2 decryption
  cifs: Pass smb_message structs down into the transport layer
  cifs: Clean up mid->callback_data and kill off mid->creator
  cifs: Don't need state locking in smb2_get_mid_entry()
  cifs: [DEBUG] smb_message refcounting
  cifs: Add netmem allocation functions
  cifs: Add more pieces to smb_message
  cifs: Convert SMB2 Negotiate Protocol request
  cifs: Convert SMB2 Session Setup request
  cifs: Convert SMB2 Logoff request
  cifs: Convert SMB2 Tree Connect request
  cifs: Convert SMB2 Tree Disconnect request
  cifs: Rearrange Create request subfuncs
  cifs: Convert SMB2 Posix Mkdir request
  cifs: Convert SMB2 Open request

 fs/netfs/Makefile             |    1 +
 fs/netfs/buffer.c             |  102 ++
 fs/nls/nls_base.c             |   33 +
 fs/smb/client/Makefile        |    2 +-
 fs/smb/client/cached_dir.c    |   41 +-
 fs/smb/client/cifs_debug.c    |   15 +-
 fs/smb/client/cifs_unicode.c  |   39 +
 fs/smb/client/cifs_unicode.h  |    2 +
 fs/smb/client/cifsencrypt.c   |   77 +-
 fs/smb/client/cifsfs.c        |   31 +-
 fs/smb/client/cifsglob.h      |  254 ++--
 fs/smb/client/cifsproto.h     |   91 +-
 fs/smb/client/cifssmb.c       |  123 +-
 fs/smb/client/cifstransport.c |  251 ++++
 fs/smb/client/compress.c      |    4 +-
 fs/smb/client/compress.h      |    6 +-
 fs/smb/client/connect.c       |  158 +-
 fs/smb/client/netmisc.c       |   15 +-
 fs/smb/client/ntlmssp.h       |   20 +-
 fs/smb/client/reparse.c       |    2 +-
 fs/smb/client/sess.c          |  271 ++--
 fs/smb/client/smb1ops.c       |  101 +-
 fs/smb/client/smb2file.c      |    2 +-
 fs/smb/client/smb2inode.c     |    6 +-
 fs/smb/client/smb2misc.c      |   80 +-
 fs/smb/client/smb2ops.c       |  570 +++----
 fs/smb/client/smb2pdu.c       | 2616 +++++++++++++++++----------------
 fs/smb/client/smb2proto.h     |   65 +-
 fs/smb/client/smb2transport.c |  229 ++-
 fs/smb/client/smbdirect.c     |   88 +-
 fs/smb/client/smbdirect.h     |    5 +-
 fs/smb/client/trace.h         |   61 +
 fs/smb/client/transport.c     | 1372 +++++++----------
 fs/smb/common/smb2pdu.h       |   92 +-
 fs/smb/server/connection.c    |    2 +-
 fs/smb/server/oplock.c        |    4 +-
 fs/smb/server/smb2misc.c      |   14 +-
 fs/smb/server/smb2ops.c       |   38 +-
 fs/smb/server/smb2pdu.c       |   66 +-
 fs/smb/server/smb_common.c    |    2 +-
 include/linux/bvec.h          |   13 +
 include/linux/iov_iter.h      |   77 +-
 include/linux/netfs.h         |    4 +
 include/linux/nls.h           |    1 +
 include/linux/uio.h           |   11 +
 lib/iov_iter.c                |  406 ++++-
 lib/tests/kunit_iov_iter.c    |  196 +++
 47 files changed, 4177 insertions(+), 3482 deletions(-)
 create mode 100644 fs/netfs/buffer.c
 create mode 100644 fs/smb/client/cifstransport.c

