Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC264525B
	for <linux-cifs@vger.kernel.org>; Fri,  1 Mar 2024 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709313929; cv=none; b=UmsDE4zDKQ37jEvYrHS9fkyFekuza16X6nQUSV6B3lk7EIV20U4u4kOCxgmRtjxOk0nw7/8mlCImO5PkI9192pKH/G0dwj08s0YsqxP2CHURlrReItipY8XyCoDLZMO9LEIl7I8l/YO2UX7ZhZfuXhWfgbB22mtpelUy+KFknfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709313929; c=relaxed/simple;
	bh=YHLCDVvXHFAi15fxwDQwCjcdblHvpJ4tTJMJt03gGO0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Y+eaUoyeh9nQXaLrEqLSpO/BmYzmBOzqgHYYed11ctPS+TVuJGuvFjrWeTj4nYU8ro4eEP8GWLUv5+fRhp4fqX4n8cxROrUP0dat3yM7UCIeYADbEOY/UoEjlMa1SevfsRFwM1bKIWygfpeDtXSeEmQrDaFnwxeW/YFGDS167SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KVbfe/vs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVbfe/vs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709313925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OWSj3sg21fom9JcxUVeu//rtnK7+rJnHHzBS6FEQKNc=;
	b=KVbfe/vsMLC0HCU5k2zVaS8XE2gsGvQaSl58qc/kQfzeMq7eKv/lNvjXobXlI1HMe/ke1x
	++FFDvFoCWwTYpCfJTw4earOT1NhsCMcE8Tt69PtyvYHAOFFs8SI9jy0phQnh8Cp/2pbx1
	+P4HpdHkXR7M9xjDWEmnj/cVLY4fA0I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-gSx1KF2dMSG8qfoiOeVveg-1; Fri,
 01 Mar 2024 12:25:17 -0500
X-MC-Unique: gSx1KF2dMSG8qfoiOeVveg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACD363800083;
	Fri,  1 Mar 2024 17:25:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.114])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 454DF40C6EBA;
	Fri,  1 Mar 2024 17:25:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <862d95d6-5aa5-4542-a22c-2be58fd5c733@moroto.mountain>
References: <862d95d6-5aa5-4542-a22c-2be58fd5c733@moroto.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org
Subject: Re: [bug report] cifs: Fix writeback data corruption
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <450033.1709313916.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 01 Mar 2024 17:25:16 +0000
Message-ID: <450034.1709313916@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Dan Carpenter <dan.carpenter@linaro.org> wrote:

> =

> The patch 374ce0748c79: "cifs: Fix writeback data corruption" from
> Feb 22, 2024 (linux-next), leads to the following Smatch static
> checker warning:
> =

> 	fs/smb/client/file.c:2869 cifs_write_back_from_locked_folio()
> 	error: uninitialized symbol 'len'.

Good catch.  len should be the length of the start folio we're given:

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2749,7 +2749,7 @@ static ssize_t cifs_write_back_from_locked_folio(str=
uct address_space *mapping,
 	struct cifsFileInfo *cfile =3D NULL;
 	unsigned long long i_size =3D i_size_read(inode), max_len;
 	unsigned int xid, wsize;
-	size_t len;
+	size_t len =3D folio_size(folio);
 	long count =3D wbc->nr_to_write;
 	int rc;
 =

@@ -2793,7 +2793,6 @@ static ssize_t cifs_write_back_from_locked_folio(str=
uct address_space *mapping,
 	 * immediately lockable, is not dirty or is missing, or we reach the
 	 * end of the range.
 	 */
-	len =3D folio_size(folio);
 	if (start < i_size) {
 		/* Trim the write to the EOF; the extra data is ignored.  Also
 		 * put an upper limit on the size of a single storedata op.

David

