Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4753A3E9F
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186134; cv=none; b=g0o087acySGOq+CemmNPxy1Tb7Ef0JZ5z73UgPVE1LiuO7IC/71jDeGSOPStRVntECN/T1ZDqA6crGnVVCI/5qewRMndS8ubuyWZ1BP373rGc9SL1/VRNmZXmXJMxYAPPuUDrPcVN4xPldxedbXdImeO0yoJUMDQ6YRRYt6qxP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186134; c=relaxed/simple;
	bh=Wl1El617KwtxPJb1MT/QV1XZttOPwcdsJRlljRhhZE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XG8/H+n9ItnbbPVj1YOE0Q1+Wby2onUdooL5yUUKJe+pn+EcMUAseVKWgWpJkozQroFv8hOJEFzmTFbvdLNjQzkKA+R86JnGw1HjLL++UW7q1W8jDGXMd3Oh+u62wsioqG4EErVhZ3VgPHx45eRRnclngWeSkRErDcjyME0d4R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LW2u2+N6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LW2u2+N6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G5/U+/nskChDo36IpLuSFXzWEKNDLgAKzgBWQxFbw1c=;
	b=LW2u2+N6KtuZNLqKuFUnkNZkvlAYN+qAKeyU5nTxKlGkUaCV1X61oll7+Gf0IPcuohs5TZ
	w2FCtu5usSJh2YrhsR8zxSvcaNgzdHE4z1f+x5nU1/Huw6eyNXSM0Q5a1VGGr5OBG1q/Tg
	5L5gdBgP0wmTddecznhuiku/hNgCqGM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-AgBq3erhPyyKFLSBndB6Hg-1; Tue,
 19 May 2026 06:22:06 -0400
X-MC-Unique: AgBq3erhPyyKFLSBndB6Hg-1
X-Mimecast-MFC-AGG-ID: AgBq3erhPyyKFLSBndB6Hg_1779186124
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FADB1956053;
	Tue, 19 May 2026 10:22:04 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 926BD1955F22;
	Tue, 19 May 2026 10:22:01 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/36] cifs: [WIP] Overhaul message handling and improve nework transport
Date: Tue, 19 May 2026 11:21:18 +0100
Message-ID: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Steve et al,

[!] NOTE: These patches are NOT FULLY WRITTEN, won't necessarily compile
    all the way through and haven't been fully tested and this is intended
    as a preview of what I'm working on.  Basic SMB2+ has worked as far as
    "cifs: Convert SMB2 Write request".  Encrypted and signed messages
    should work but haven't been tested; compressed is disabled.  Assume
    that anything beyond the specified point won't work.

    SMB1 should work up to somewhere around "cifs: Rewrite base TCP
    transmission", but somewhere beyond that it won't compile.  I need to
    go back and fix this up.

    RDMA almost certainly won't work.  Ideally, I would like to make RDMA
    message passing (rather than direct data transport) supply the received
    fragments in a bvecq to the message parsing routines.

The aim of this patchset is to build up a list of fragments for each
request using a bvecq.  These form a segmented list and can be spliced
together when assembling a compound request.  The segmented list can then
be passed to sendmsg() with MSG_SPLICE_PAGES in a single call, thereby only
having a single loop (in the TCP stack) to shovel data, rather than loops
within loops.  Possibly we can dispense with TCP corking also, provided we
can tell the socket to flush the record boundaries.  (Note that this also
simplifies smbd_send() for RDMA).

To make this easier, I want to introduce a "request descriptor", which I'm
calling "struct smb_message" and allocate it at a higher level, notably the
PDU marshalling routines in cifssmb.c and smb2pdu.c and then hand that down
into the transport.  It will contain the list of fragments that form the
message.

mid_q_struct is then 'absorbed' into smb_message.  The transport then
doesn't allocate these, but uses the ones that it is given and the I/O
thread gets to simplify its refcounting and do less of it.  The rule is
that smb_message gets an extra ref when it is enqueued and whoever dequeues
it gets this ref and either puts it or hands it on.  The PDU encoding
routines get a ref when allocating them and keep the refs until they
complete.

smb_message is then given a next pointer to allow compounds to be trivially
assembled, with the protocol wrangling being done in the transport.  This
next pointer also allows a bunch of fixed-size arrays to be got rid of
(which were imposing weird restrictions like reducing the maximum component
count of a compound if we stole a kvec[] slot for the transform header).

Request buffers will be allocated from a per-connection page frag allocator
rather than from kmalloc(), thereby allowing them to be passed to
MSG_SPLICE_PAGES.

To this end, I make the following significant changes.  Note that some of
the changes are a way to transit to a later stage.

 (0) Make SMB1 transport use the SMB2 transport rather than having parallel
     dispatch code (now upstream).

 (1) Make skb_splice_from_iter() special case ITER_BVECQ-type iterators and
     walk the bvecq directly rather than calling iov_iter_extract_pages().
     This allows access to the information on the bvecq about whether a
     memory fragment is held by a page ref or by a pin - which is something
     sk_buff needs to take account of at some point.

 (2) Provide netfslib facilities to splice the receive buffers directly out
     of a TCP socket into a bvecq, allowing the socket lock to be dropped
     earlier and reducing the amount of time sendmsg is held up.

 (3) Replace mid_q_struct with smb_message and also include credits and
     smb_rqst therein.

 (4) Rewrite cifs TCP transmission to be able to use MSG_SPLICE_PAGES:

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

 (5) Rewrite cifs TCP reception to use the facility to splice the receive
     queue out of the socket and into a bvecq rather than using recvmsg()
     to read it.  The bvecq is then processed through helper functions to
     parse incoming messages for both SMB1 and SMB2/3.  This allows reading
     to be deferred to avoid blocking the I/O thread.

 (6) Clean up mid->callback_data.  Replace it with a waitqueue in
     smb_message (for most commands) and a cifs_io_subrequest pointer (for
     read and write).  Make request completion wait on the smb_message
     waitqueue rather than on server->response_q to avoid thundering herd
     issues.

     (Also, I note that under some circumstances, cifs just wakes up the
     first thing on server->response_q without any reference to *what* it
     is waking up).

 (7) Add some more bits to smb_message to hold the buffers in a bvecq with
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

 (8) Convert PDU encoders to allocate and use smb_message and pass it down.

     (a) So far, SMB2 Negotiate Protocol, Session Setup, Logoff, Tree
     	 Connect, Tree Disconnect, Read and Write have been done - and
     	 though they build if SMB1 and compression are disabled, they won't
     	 work yet and so haven't been tested.

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

David Howells (36):
  net: Perform special handling for a splice from a bvecq
  netfs: Add a facility to splice TCP receive buffers into a bvecq
  netfs: Add some TCP receive queue helpers
  cifs, nls: Provide unicode size determination func
  cifs: Introduce an ALIGN8() macro
  cifs: Rename mid_q_entry to smb_message
  cifs: Add "Has dynamic part" flag form SMB2/3 StructureSize LSB
  cifs: Add an enum to hold a trace value for the command/subcommand
  cifs: Institute message managing struct
  cifs: Split crypt_message() into encrypt and decrypt variants
  cifs: Add new AEAD alloc and setup routines that draw from an iterator
  cifs: [WIP] Rewrite base Rx to put data off the socket into a bvecq
  cifs: Remove validate_t2()
  cifs: Remove cifs_io_subrequest::got_bytes
  cifs: Pass smb_message to cifs_verify_signature()
  cifs: Rewrite base TCP transmission
  cifs: Don't use corking
  cifs: Use page frag allocator for Tx buffers
  cifs: Try to better handle the "Dynamic" flag in StructureSize2 in
    SMB2/3
  cifs: Pass smb_message structs down into the transport layer
  cifs: Add a tracepoint to trace the smb_message refcount
  cifs: Trace smb1/2_copy_to_prepped_buffers()
  cifs: Clean up mid->callback_data and kill off mid->creator
  cifs: Add netmem allocation functions
  cifs: Add more pieces to smb_message
  cifs: Convert SMB2 Negotiate Protocol request
  cifs: Convert SMB2 Session Setup request
  cifs: Convert SMB2 Logoff request
  cifs: Convert SMB2 Tree Connect request
  cifs: Convert SMB2 Tree Disconnect request
  cifs: Convert SMB2 Read request
  cifs: Convert SMB2 Write request
  cifs: [WIP] Don't copy new-style smb_messages to a set of pages
  cifs: [WIP] Rearrange Create request subfuncs
  cifs: [WIP] Convert SMB2 Posix Mkdir request
  cifs: [WIP] Convert SMB2 Open request

 fs/netfs/Makefile             |    4 +
 fs/netfs/rxqueue.c            |  532 ++++++
 fs/netfs/tcp_splice.c         |  269 +++
 fs/nls/nls_base.c             |   33 +
 fs/smb/client/cached_dir.c    |   41 +-
 fs/smb/client/cifs_debug.c    |   53 +-
 fs/smb/client/cifs_debug.h    |    3 +-
 fs/smb/client/cifs_unicode.c  |   39 +
 fs/smb/client/cifs_unicode.h  |    2 +
 fs/smb/client/cifsencrypt.c   |    4 +-
 fs/smb/client/cifsfs.c        |   30 +-
 fs/smb/client/cifsglob.h      |  297 ++--
 fs/smb/client/cifsproto.h     |  168 +-
 fs/smb/client/cifssmb.c       |  345 ++--
 fs/smb/client/compress.c      |  155 +-
 fs/smb/client/compress.h      |   14 +-
 fs/smb/client/connect.c       |  707 ++++----
 fs/smb/client/ntlmssp.h       |    8 +-
 fs/smb/client/reparse.c       |    2 +-
 fs/smb/client/sess.c          |  306 ++--
 fs/smb/client/smb1debug.c     |   56 +-
 fs/smb/client/smb1encrypt.c   |  132 +-
 fs/smb/client/smb1maperror.c  |   15 +-
 fs/smb/client/smb1misc.c      |   22 +-
 fs/smb/client/smb1ops.c       |   96 +-
 fs/smb/client/smb1pdu.h       |   62 +-
 fs/smb/client/smb1proto.h     |   58 +-
 fs/smb/client/smb1session.c   |    4 +-
 fs/smb/client/smb1transport.c | 1154 +++++++++----
 fs/smb/client/smb2file.c      |    3 +-
 fs/smb/client/smb2inode.c     |    8 +-
 fs/smb/client/smb2maperror.c  |    3 +-
 fs/smb/client/smb2misc.c      |  423 +++--
 fs/smb/client/smb2ops.c       | 1190 ++------------
 fs/smb/client/smb2pdu.c       | 2889 +++++++++++++++++----------------
 fs/smb/client/smb2proto.h     |   83 +-
 fs/smb/client/smb2transport.c | 1172 +++++++++++--
 fs/smb/client/smbdirect.c     |  105 +-
 fs/smb/client/smbdirect.h     |    5 +-
 fs/smb/client/trace.h         |  180 ++
 fs/smb/client/transport.c     | 1254 ++++++++------
 fs/smb/common/smb2pdu.h       |   55 +-
 fs/smb/server/smb2pdu.c       |   22 +-
 include/linux/netfs.h         |   37 +
 include/linux/nls.h           |    1 +
 include/trace/events/netfs.h  |   28 +
 net/core/skbuff.c             |  119 ++
 47 files changed, 7135 insertions(+), 5053 deletions(-)
 create mode 100644 fs/netfs/rxqueue.c
 create mode 100644 fs/netfs/tcp_splice.c

