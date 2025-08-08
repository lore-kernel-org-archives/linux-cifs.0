Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A218E377
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754665824; cv=none; b=OQvnjTctHYCdP7o+ijBy1ZPqmvcLSWZaTUGWlkCd/Hli6i5pMmBrKnfbnG1+1NTt0x4oa2xNyLRvQXYXgnPDSVMZ1QC6d/D+31MqZO2i5ku9bOCjZpB83fPa5xad8XbaOGUQDVan4N8oQTOTHwlIcrDf1ZOWjNfrB23xlg6SVgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754665824; c=relaxed/simple;
	bh=umcvyVklicbzq/kBy0WmrsbaWF0kIcR+4L2lO8UDxYY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=WUFU9m+LkOujUd4yVeC8ClQbOW7W5pYssqup+EKDW0W3Bq3KIANFJy26G5HSq4LYTW5yWUDWf7NELuN5GnIGJUy7k1pUBT2Smj7pVttVbjaJUVA83jc6lKYeMgALdbStniOjZnd9mkkbn9IrfGdRklciqG1BafkLuqhV8b6y5wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MEvX42r4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEvX42r4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754665821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sb1xY4mkvRwciVCfa3SBcbz2VY+53NejsonXd/nwxL4=;
	b=MEvX42r4q+pqA4cGu6C8QqRY1tZ9IJIyY7fE2L3NsnmkHnIdGsoOGLjUR5F9ac6NZE223W
	VxelG041HKzcD29yIXzY3t62PGUK6B70ipV3UlBLmlMr+NACgBagXQth3DML6vxb457HH8
	6T9WDJh2fOYWCTn98sWWNBRpRLGOagQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-0hywt-IUNPy6Fruejruu2w-1; Fri,
 08 Aug 2025 11:10:18 -0400
X-MC-Unique: 0hywt-IUNPy6Fruejruu2w-1
X-Mimecast-MFC-AGG-ID: 0hywt-IUNPy6Fruejruu2w_1754665816
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FE8F18003FD;
	Fri,  8 Aug 2025 15:10:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.17])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28773180029B;
	Fri,  8 Aug 2025 15:10:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <zt6f2jl6y5wpiuchryc2vdsmtkiia7s5mligm7helffkanxe3o@2f2ksngn5ekk>
References: <zt6f2jl6y5wpiuchryc2vdsmtkiia7s5mligm7helffkanxe3o@2f2ksngn5ekk> <20250806203705.2560493-1-dhowells@redhat.com> <20250806203705.2560493-25-dhowells@redhat.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Wang Zhaolong <wangzhaolong@huaweicloud.com>,
    Stefan Metzmacher <metze@samba.org>,
    Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org,
    linux-kernel@vger.kernel.org, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 24/31] cifs: Convert SMB2 Negotiate Protocol request
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2926139.1754665810.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 08 Aug 2025 16:10:10 +0100
Message-ID: <2926140.1754665810@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Enzo Matsumiya <ematsumiya@suse.de> wrote:

> On 08/06, David Howells wrote:
> > ...
> > -static unsigned int
> >-build_netname_ctxt(struct smb2_netname_neg_context *pneg_ctxt, char *h=
ostname)
> >+static size_t smb2_size_netname_ctxt(struct TCP_Server_Info *server)
> > {
> >+	size_t data_len;
> >+
> >+#if 0
> > 	struct nls_table *cp =3D load_nls_default();
> >+	const char *hostname;
> >
> >-	pneg_ctxt->ContextType =3D SMB2_NETNAME_NEGOTIATE_CONTEXT_ID;
> >+	/* Only include up to first 100 bytes of server name in the NetName
> >+	 * field.
> >+	 */
> >+	cifs_server_lock(pserver);
> >+	hostname =3D pserver->hostname;
> >+	if (hostname && hostname[0])
> >+		data_len =3D cifs_size_strtoUTF16(hostname, 100, cp);
> >+	cifs_server_unlock(pserver);
> >+#else
> >+	/* Now, we can't just measure the length of hostname as, unless we ho=
ld
> >+	 * the lock, it may change under us, so allow maximum space for it.
> >+	 */
> >+	data_len =3D 400;
> >+#endif
> >+	return ALIGN8(sizeof(struct smb2_neg_context) + data_len);
> >+}
> =

> Why was this commented out?  Your comment implies that you can't hold
> the lock anymore there, but I couldn't find out why (with your patches
> applied).

The problem is that the hostname may change - and there's a spinlock to
protect it.  However, now that I'm working out the message size before the
allocation, I need to find the size of the host name, do the alloc and the=
n
copy the hostname in - but I can't hold the spinlock across the alloc, so =
the
hostname may change whilst the lock is dropped.

The obvious solution is to just allocate the maximum size for it.  It's no=
t
that big and this command isn't used all that often.

Remember that this is a work in progress, so you may find bits like this w=
here
I may need to reconsider what I've chosen.

> >-static void
> >-assemble_neg_contexts(struct smb2_negotiate_req *req,
> >-		      struct TCP_Server_Info *server, unsigned int *total_len)
> >+static size_t smb2_size_neg_contexts(struct TCP_Server_Info *server,
> >+				     size_t offset)
> > {
> >-	unsigned int ctxt_len, neg_context_count;
> > 	struct TCP_Server_Info *pserver;
> >-	char *pneg_ctxt;
> >-	char *hostname;
> >-
> >-	if (*total_len > 200) {
> >-		/* In case length corrupted don't want to overrun smb buffer */
> >-		cifs_server_dbg(VFS, "Bad frame length assembling neg contexts\n");
> >-		return;
> >-	}
> >
> > 	/*
> > 	 * round up total_len of fixed part of SMB3 negotiate request to 8
> > 	 * byte boundary before adding negotiate contexts
> > 	 */
> >-	*total_len =3D ALIGN8(*total_len);
> >+	offset =3D ALIGN8(offset);
> >+	offset +=3D ALIGN8(sizeof(struct smb2_preauth_neg_context));
> >+	offset +=3D ALIGN8(sizeof(struct smb2_encryption_neg_context));
> >
> >-	pneg_ctxt =3D (*total_len) + (char *)req;
> >-	req->NegotiateContextOffset =3D cpu_to_le32(*total_len);
> >+	/*
> >+	 * secondary channels don't have the hostname field populated
> >+	 * use the hostname field in the primary channel instead
> >+	 */
> >+	pserver =3D SERVER_IS_CHAN(server) ? server->primary_server : server;
> >+	offset +=3D smb2_size_netname_ctxt(pserver);
> =

> If you're keeping data_len=3D400 above, you could just drop
> smb2_size_netname_ctxt() altogether and use
> "ALIGN8(sizeof(struct smb2_neg_context) + 400)" directly here.

Yeah.  Probably would make sense to do that with a comment saying why 400.

David

