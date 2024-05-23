Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0AE433C4
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474047; cv=none; b=IEz5spTSLZ50WvKtlaPyjfMKNrmB736FoaydtL4krQObJzRhqXtfBALI7Ac2KkBjuETrii+r03doN7jeYc0DcYt4H2cLDmE7f6bvAZw/CFr16umML+AlsQaoecTAVzzb2cJ3TXQ9cAmdkmboaSeksPHJmmMnsRnBO2fm6/H6PuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474047; c=relaxed/simple;
	bh=ggQ+kGdve8EMW6FC4QtRavfJdejR4Nr4Q8GCsK+07f0=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=gvf/RUW8hlIPZ5lVFXuXe3pvZFJZ2VANePoTmEWG4Q+KWwE/YHnvOboGaXjrY/RPROtyGvfHcmOFturIJUriVqTMco6byKPbibecSv8BjOK5M21ImI6brTZMsZwPrXCyrGHMp1bRkbYUitgnajTi8n87sZZkQ5iZ+z5ZxrQ1zgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IsSagm4O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IsSagm4O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716474044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1RQ+t8SrCZPwxt4wDFVx+0NZ732xQjzneGUmgGhLAZ4=;
	b=IsSagm4O4l08VxitCWStm3I6bnamZkDFQYT8Ouke2gwS1hLP6RTVSkYWyVDo4lzD9GRMYi
	rIVMxbq7KkqmN7+H56R1RJDCO0FsFPFmQMumgVhhzCM8+/XavhVbK7jKCHO2wr0jS2LuAZ
	MOKadUUPJBLHk8nOmh0MLG5xOp0J+Xs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-WRFXR0-FO16KwzF_P6VcBA-1; Thu, 23 May 2024 10:20:40 -0400
X-MC-Unique: WRFXR0-FO16KwzF_P6VcBA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFAA7812296;
	Thu, 23 May 2024 14:20:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E9C49C15BED;
	Thu, 23 May 2024 14:20:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>,
    Paulo Alcantara (DFS, global name space) <pc@manguebit.com>
cc: dhowells@redhat.com, linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: Add some debugging for the add_credits() warning induced by generic/014
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <578386.1716474032.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 May 2024 15:20:32 +0100
Message-ID: <578387.1716474032@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

    =

Add some debugging to try and work out what the cause of the add_credits()
warning that generic/014 and generic/074 cause.  There are two parts to
this:

 (1) Add a tracepoint to track credits flow in read/write requests.  This
     can be enabled with:

        echo 1 > /sys/kernel/debug/tracing/events/cifs/smb3_rw_credits/ena=
ble

 (2) Add a three-state flag to struct cifs_credits to note if we're
     interested in determining when the in_flight contribution ends and
     also note the request/subrequest details for logging in the event tha=
t
     we encounter a double-credit add.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/smb/client/cifsglob.h  |   17 ++++++++------
 fs/smb/client/file.c      |   33 ++++++++++++++++++++++++++--
 fs/smb/client/smb1ops.c   |    2 -
 fs/smb/client/smb2ops.c   |   32 +++++++++++++++++++++++----
 fs/smb/client/smb2pdu.c   |   27 +++++++++++++++++++++--
 fs/smb/client/trace.h     |   54 ++++++++++++++++++++++++++++++++++++++++=
+++++-
 fs/smb/client/transport.c |    8 +++---
 7 files changed, 152 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 73482734a8d8..2f8c9ce5d0ee 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -290,7 +290,7 @@ struct smb_version_operations {
 	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     bool);
 	void (*add_credits)(struct TCP_Server_Info *server,
-			    const struct cifs_credits *credits,
+			    struct cifs_credits *credits,
 			    const int optype);
 	void (*set_credits)(struct TCP_Server_Info *, const int);
 	int * (*get_credits_field)(struct TCP_Server_Info *, const int);
@@ -550,8 +550,8 @@ struct smb_version_operations {
 				size_t *, struct cifs_credits *);
 	/* adjust previously taken mtu credits to request size */
 	int (*adjust_credits)(struct TCP_Server_Info *server,
-			      struct cifs_credits *credits,
-			      const unsigned int payload_size);
+			      struct cifs_io_subrequest *subreq,
+			      unsigned int /*enum smb3_rw_credits_trace*/ trace);
 	/* check if we need to issue closedir */
 	bool (*dir_needs_close)(struct cifsFileInfo *);
 	long (*fallocate)(struct file *, struct cifs_tcon *, int, loff_t,
@@ -848,6 +848,9 @@ static inline void cifs_server_unlock(struct TCP_Serve=
r_Info *server)
 struct cifs_credits {
 	unsigned int value;
 	unsigned int instance;
+	unsigned int in_flight_check;
+	unsigned int rreq_debug_id;
+	unsigned int rreq_debug_index;
 };
 =

 static inline unsigned int
@@ -873,7 +876,7 @@ has_credits(struct TCP_Server_Info *server, int *credi=
ts, int num_credits)
 }
 =

 static inline void
-add_credits(struct TCP_Server_Info *server, const struct cifs_credits *cr=
edits,
+add_credits(struct TCP_Server_Info *server, struct cifs_credits *credits,
 	    const int optype)
 {
 	server->ops->add_credits(server, credits, optype);
@@ -897,11 +900,11 @@ set_credits(struct TCP_Server_Info *server, const in=
t val)
 }
 =

 static inline int
-adjust_credits(struct TCP_Server_Info *server, struct cifs_credits *credi=
ts,
-	       const unsigned int payload_size)
+adjust_credits(struct TCP_Server_Info *server, struct cifs_io_subrequest =
*subreq,
+	       unsigned int /* enum smb3_rw_credits_trace */ trace)
 {
 	return server->ops->adjust_credits ?
-		server->ops->adjust_credits(server, credits, payload_size) : 0;
+		server->ops->adjust_credits(server, subreq, trace) : 0;
 }
 =

 static inline __le64
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9d5c2440abfc..bba4818a9c9b 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -80,6 +80,16 @@ static void cifs_prepare_write(struct netfs_io_subreque=
st *subreq)
 		return netfs_prepare_write_failed(subreq);
 	}
 =

+	wdata->credits.rreq_debug_id =3D subreq->rreq->debug_id;
+	wdata->credits.rreq_debug_index =3D subreq->debug_index;
+	wdata->credits.in_flight_check =3D 1;
+	trace_smb3_rw_credits(wdata->rreq->debug_id,
+			      wdata->subreq.debug_index,
+			      wdata->credits.value,
+			      server->credits, server->in_flight,
+			      wdata->credits.value,
+			      cifs_trace_rw_credits_write_prepare);
+
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn)
 		subreq->max_nr_segs =3D server->smbd_conn->max_frmr_depth;
@@ -101,7 +111,7 @@ static void cifs_issue_write(struct netfs_io_subreques=
t *subreq)
 		goto fail;
 	}
 =

-	rc =3D adjust_credits(wdata->server, &wdata->credits, wdata->subreq.len)=
;
+	rc =3D adjust_credits(wdata->server, wdata, cifs_trace_rw_credits_issue_=
write_adjust);
 	if (rc)
 		goto fail;
 =

@@ -160,6 +170,16 @@ static bool cifs_clamp_length(struct netfs_io_subrequ=
est *subreq)
 		return false;
 	}
 =

+	rdata->credits.in_flight_check =3D 1;
+	rdata->credits.rreq_debug_id =3D rreq->debug_id;
+	rdata->credits.rreq_debug_index =3D subreq->debug_index;
+
+	trace_smb3_rw_credits(rdata->rreq->debug_id,
+			      rdata->subreq.debug_index,
+			      rdata->credits.value,
+			      server->credits, server->in_flight, 0,
+			      cifs_trace_rw_credits_read_clamp);
+
 	subreq->len =3D min_t(size_t, subreq->len, rsize);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn)
@@ -203,7 +223,7 @@ static void cifs_req_issue_read(struct netfs_io_subreq=
uest *subreq)
 	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 	rdata->pid =3D pid;
 =

-	rc =3D adjust_credits(rdata->server, &rdata->credits, rdata->subreq.len)=
;
+	rc =3D adjust_credits(rdata->server, rdata, cifs_trace_rw_credits_issue_=
read_adjust);
 	if (!rc) {
 		if (rdata->req->cfile->invalidHandle)
 			rc =3D -EAGAIN;
@@ -331,6 +351,15 @@ static void cifs_free_subrequest(struct netfs_io_subr=
equest *subreq)
 #endif
 	}
 =

+	if (rdata->credits.value !=3D 0)
+		trace_smb3_rw_credits(rdata->rreq->debug_id,
+				      rdata->subreq.debug_index,
+				      rdata->credits.value,
+				      rdata->server ? rdata->server->credits : 0,
+				      rdata->server ? rdata->server->in_flight : 0,
+				      -rdata->credits.value,
+				      cifs_trace_rw_credits_free_subreq);
+
 	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	if (rdata->have_xid)
 		free_xid(rdata->xid);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 212ec6f66ec6..e1f2feb56f45 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -108,7 +108,7 @@ cifs_find_mid(struct TCP_Server_Info *server, char *bu=
ffer)
 =

 static void
 cifs_add_credits(struct TCP_Server_Info *server,
-		 const struct cifs_credits *credits, const int optype)
+		 struct cifs_credits *credits, const int optype)
 {
 	spin_lock(&server->req_lock);
 	server->credits +=3D credits->value;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b87b70edd0be..44bc8b6ebc1d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -66,7 +66,7 @@ change_conf(struct TCP_Server_Info *server)
 =

 static void
 smb2_add_credits(struct TCP_Server_Info *server,
-		 const struct cifs_credits *credits, const int optype)
+		 struct cifs_credits *credits, const int optype)
 {
 	int *val, rc =3D -1;
 	int scredits, in_flight;
@@ -94,6 +94,12 @@ smb2_add_credits(struct TCP_Server_Info *server,
 					    server->conn_id, server->hostname, *val,
 					    add, server->in_flight);
 	}
+	if (credits->in_flight_check > 1) {
+		pr_warn_once("rreq R=3D%08x[%x] Credits not in flight\n",
+			     credits->rreq_debug_id, credits->rreq_debug_index);
+	} else {
+		credits->in_flight_check =3D 2;
+	}
 	WARN_ON_ONCE(server->in_flight =3D=3D 0);
 	server->in_flight--;
 	if (server->in_flight =3D=3D 0 &&
@@ -283,16 +289,23 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server=
, size_t size,
 =

 static int
 smb2_adjust_credits(struct TCP_Server_Info *server,
-		    struct cifs_credits *credits,
-		    const unsigned int payload_size)
+		    struct cifs_io_subrequest *subreq,
+		    unsigned int /*enum smb3_rw_credits_trace*/ trace)
 {
-	int new_val =3D DIV_ROUND_UP(payload_size, SMB2_MAX_BUFFER_SIZE);
+	struct cifs_credits *credits =3D &subreq->credits;
+	int new_val =3D DIV_ROUND_UP(subreq->subreq.len, SMB2_MAX_BUFFER_SIZE);
 	int scredits, in_flight;
 =

 	if (!credits->value || credits->value =3D=3D new_val)
 		return 0;
 =

 	if (credits->value < new_val) {
+		trace_smb3_rw_credits(subreq->rreq->debug_id,
+				      subreq->subreq.debug_index,
+				      credits->value,
+				      server->credits, server->in_flight,
+				      new_val - credits->value,
+				      cifs_trace_rw_credits_no_adjust_up);
 		trace_smb3_too_many_credits(server->CurrentMid,
 				server->conn_id, server->hostname, 0, credits->value - new_val, 0);
 		cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)"=
,
@@ -308,6 +321,12 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 		in_flight =3D server->in_flight;
 		spin_unlock(&server->req_lock);
 =

+		trace_smb3_rw_credits(subreq->rreq->debug_id,
+				      subreq->subreq.debug_index,
+				      credits->value,
+				      server->credits, server->in_flight,
+				      new_val - credits->value,
+				      cifs_trace_rw_credits_old_session);
 		trace_smb3_reconnect_detected(server->CurrentMid,
 			server->conn_id, server->hostname, scredits,
 			credits->value - new_val, in_flight);
@@ -316,6 +335,11 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 		return -EAGAIN;
 	}
 =

+	trace_smb3_rw_credits(subreq->rreq->debug_id,
+			      subreq->subreq.debug_index,
+			      credits->value,
+			      server->credits, server->in_flight,
+			      new_val - credits->value, trace);
 	server->credits +=3D credits->value - new_val;
 	scredits =3D server->credits;
 	in_flight =3D server->in_flight;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 993ac36c3d58..9b53158f5300 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4494,6 +4494,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				(struct smb2_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits =3D { .value =3D 0, .instance =3D 0 };
 	struct smb_rqst rqst =3D { .rq_iov =3D &rdata->iov[1], .rq_nvec =3D 1 };
+	unsigned int rreq_debug_id =3D rdata->rreq->debug_id;
+	unsigned int subreq_debug_index =3D rdata->subreq.debug_index;
 =

 	if (rdata->got_bytes) {
 		rqst.rq_iter	  =3D rdata->subreq.io_iter;
@@ -4579,11 +4581,18 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	}
 	if (rdata->result =3D=3D 0 || rdata->result =3D=3D -EAGAIN)
 		iov_iter_advance(&rdata->subreq.io_iter, rdata->got_bytes);
+
+	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.=
value,
+			      server->credits, server->in_flight,
+			      0, cifs_trace_rw_credits_read_response_clear);
 	rdata->credits.value =3D 0;
 	netfs_subreq_terminated(&rdata->subreq,
 				(rdata->result =3D=3D 0 || rdata->result =3D=3D -EAGAIN) ?
 				rdata->got_bytes : rdata->result, true);
 	release_mid(mid);
+	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
+			      server->credits, server->in_flight,
+			      credits.value, cifs_trace_rw_credits_write_response_add);
 	add_credits(server, &credits, 0);
 }
 =

@@ -4640,7 +4649,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 				min_t(int, server->max_credits -
 						server->credits, credit_request));
 =

-		rc =3D adjust_credits(server, &rdata->credits, rdata->subreq.len);
+		rc =3D adjust_credits(server, rdata, cifs_trace_rw_credits_call_readv_a=
djust);
 		if (rc)
 			goto async_readv_out;
 =

@@ -4760,6 +4769,8 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server =3D wdata->server;
 	struct smb2_write_rsp *rsp =3D (struct smb2_write_rsp *)mid->resp_buf;
 	struct cifs_credits credits =3D { .value =3D 0, .instance =3D 0 };
+	unsigned int rreq_debug_id =3D wdata->rreq->debug_id;
+	unsigned int subreq_debug_index =3D wdata->subreq.debug_index;
 	ssize_t result =3D 0;
 	size_t written;
 =

@@ -4831,9 +4842,15 @@ smb2_writev_callback(struct mid_q_entry *mid)
 				      tcon->tid, tcon->ses->Suid,
 				      wdata->subreq.start, wdata->subreq.len);
 =

+	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, wdata->credits.=
value,
+			      server->credits, server->in_flight,
+			      0, cifs_trace_rw_credits_write_response_clear);
 	wdata->credits.value =3D 0;
 	cifs_write_subrequest_terminated(wdata, result ?: written, true);
 	release_mid(mid);
+	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
+			      server->credits, server->in_flight,
+			      credits.value, cifs_trace_rw_credits_write_response_add);
 	add_credits(server, &credits, 0);
 }
 =

@@ -4966,7 +4983,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 				min_t(int, server->max_credits -
 						server->credits, credit_request));
 =

-		rc =3D adjust_credits(server, &wdata->credits, io_parms->length);
+		rc =3D adjust_credits(server, wdata, cifs_trace_rw_credits_call_writev_=
adjust);
 		if (rc)
 			goto async_writev_out;
 =

@@ -4991,6 +5008,12 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	cifs_small_buf_release(req);
 out:
 	if (rc) {
+		trace_smb3_rw_credits(wdata->rreq->debug_id,
+				      wdata->subreq.debug_index,
+				      wdata->credits.value,
+				      server->credits, server->in_flight,
+				      -(int)wdata->credits.value,
+				      cifs_trace_rw_credits_write_response_clear);
 		add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
 		cifs_write_subrequest_terminated(wdata, rc, true);
 	}
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index af97389e983e..faf5697a5b6a 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -20,6 +20,21 @@
 /*
  * Specify enums for tracing information.
  */
+#define smb3_rw_credits_traces \
+	EM(cifs_trace_rw_credits_call_readv_adjust,	"rd-call-adj") \
+	EM(cifs_trace_rw_credits_call_writev_adjust,	"wr-call-adj") \
+	EM(cifs_trace_rw_credits_free_subreq,		"free-subreq") \
+	EM(cifs_trace_rw_credits_issue_read_adjust,	"rd-issu-adj") \
+	EM(cifs_trace_rw_credits_issue_write_adjust,	"wr-issu-adj") \
+	EM(cifs_trace_rw_credits_no_adjust_up,		"no-adj-up  ") \
+	EM(cifs_trace_rw_credits_old_session,		"old-session") \
+	EM(cifs_trace_rw_credits_read_clamp,		"rd-clamp   ") \
+	EM(cifs_trace_rw_credits_read_response_add,	"rd-resp-add") \
+	EM(cifs_trace_rw_credits_read_response_clear,	"rd-resp-clr") \
+	EM(cifs_trace_rw_credits_write_prepare,		"wr-prepare ") \
+	EM(cifs_trace_rw_credits_write_response_add,	"wr-resp-add") \
+	E_(cifs_trace_rw_credits_write_response_clear,	"wr-resp-clr")
+
 #define smb3_tcon_ref_traces					      \
 	EM(netfs_trace_tcon_ref_dec_dfs_refer,		"DEC DfsRef") \
 	EM(netfs_trace_tcon_ref_free,			"FRE       ") \
@@ -59,7 +74,8 @@
 #define EM(a, b) a,
 #define E_(a, b) a
 =

-enum smb3_tcon_ref_trace { smb3_tcon_ref_traces } __mode(byte);
+enum smb3_rw_credits_trace	{ smb3_rw_credits_traces } __mode(byte);
+enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 =

 #undef EM
 #undef E_
@@ -71,6 +87,7 @@ enum smb3_tcon_ref_trace { smb3_tcon_ref_traces } __mode=
(byte);
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 =

+smb3_rw_credits_traces;
 smb3_tcon_ref_traces;
 =

 #undef EM
@@ -1316,6 +1333,41 @@ TRACE_EVENT(smb3_tcon_ref,
 		      __entry->ref)
 	    );
 =

+TRACE_EVENT(smb3_rw_credits,
+	    TP_PROTO(unsigned int rreq_debug_id,
+		     unsigned int subreq_debug_index,
+		     unsigned int subreq_credits,
+		     unsigned int server_credits,
+		     int server_in_flight,
+		     int credit_change,
+		     enum smb3_rw_credits_trace trace),
+	    TP_ARGS(rreq_debug_id, subreq_debug_index, subreq_credits,
+		    server_credits, server_in_flight, credit_change, trace),
+	    TP_STRUCT__entry(
+		    __field(unsigned int, rreq_debug_id)
+		    __field(unsigned int, subreq_debug_index)
+		    __field(unsigned int, subreq_credits)
+		    __field(unsigned int, server_credits)
+		    __field(int,	  in_flight)
+		    __field(int,	  credit_change)
+		    __field(enum smb3_rw_credits_trace, trace)
+			     ),
+	    TP_fast_assign(
+		    __entry->rreq_debug_id	=3D rreq_debug_id;
+		    __entry->subreq_debug_index	=3D subreq_debug_index;
+		    __entry->subreq_credits	=3D subreq_credits;
+		    __entry->server_credits	=3D server_credits;
+		    __entry->in_flight		=3D server_in_flight;
+		    __entry->credit_change	=3D credit_change;
+		    __entry->trace		=3D trace;
+			   ),
+	    TP_printk("R=3D%08x[%x] %s cred=3D%u chg=3D%d pool=3D%u ifl=3D%d",
+		      __entry->rreq_debug_id, __entry->subreq_debug_index,
+		      __print_symbolic(__entry->trace, smb3_rw_credits_traces),
+		      __entry->subreq_credits, __entry->credit_change,
+		      __entry->server_credits, __entry->in_flight)
+	    );
+
 =

 #undef EM
 #undef E_
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 012b9bd06995..adfe0d058701 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -988,10 +988,10 @@ static void
 cifs_compound_callback(struct mid_q_entry *mid)
 {
 	struct TCP_Server_Info *server =3D mid->server;
-	struct cifs_credits credits;
-
-	credits.value =3D server->ops->get_credits(mid);
-	credits.instance =3D server->reconnect_instance;
+	struct cifs_credits credits =3D {
+		.value =3D server->ops->get_credits(mid),
+		.instance =3D server->reconnect_instance,
+	};
 =

 	add_credits(server, &credits, mid->optype);
 =

