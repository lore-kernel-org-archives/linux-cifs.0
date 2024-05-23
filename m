Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D040C2D05E
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 06:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716446218; cv=none; b=IbjyBgR6q8AGK9pUH/y2Ak7WIywpWv5WCfuobWDnmhBHTcUewT/ehdEh4KauPbXXXmPvjJpilRbOOpkmSc0ow9jUu3U4bf58dhcRiJcCrfoxPye2AENlVmjNlqV+Y/SiKRUClro2oi4PhML9RFtmtYj+4DKVTm/KPIW1CRGLEEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716446218; c=relaxed/simple;
	bh=+jFHf/SHm34pgbj6y9PIQfO2eIqUYyLBFj3V/fPXwzE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=UdOgzT4BA/0rTtK8r3FvzkXXHxxZI+Lpex1/jnzc+pjFreFfSGibTcfM0Xr0ZtbnY/0hFPMANpOCacN4RsVfJW0unn3NhxZHH+wWLo27UdPt28hu8QlWlokOgpJYSYJdI021hoVmIJ6VkxqeekYdY2PrkouBN9F7T/K/bPBlIMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hR1JqRAq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hR1JqRAq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716446215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xMLnNxFTnCaK5JR2bSI2SHt3ZvEw03w9pPGa7xZnUmo=;
	b=hR1JqRAqi/jq/AlOmJf9vEidHdjy/lMxNpgilg6LxtWBExSfN9NpVih5JkgbIrWX5NlQ9a
	fyxRN0XmLSoOAFZ022SHrBG00iSVXlNwfwB1jCQBMe0+az0zihBtQh63ceHK9be0Ffmwfx
	Fq/JS+izSAsp/rhtkKlQTpQ96CeGZNU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-Qh2tz4yBPKikznTeAPwIyA-1; Thu, 23 May 2024 02:36:50 -0400
X-MC-Unique: Qh2tz4yBPKikznTeAPwIyA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B582585A58C;
	Thu, 23 May 2024 06:36:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D13C440004D;
	Thu, 23 May 2024 06:36:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
References: <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com> <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk> <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna> <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com> <476489.1716445261@warthog.procyon.org.uk>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: dhowells@redhat.com, David Disseldorp <ddiss@samba.org>,
    David Howells via samba-technical <samba-technical@lists.samba.org>,
    Steve French <sfrench@samba.org>, Jeremy Allison <jra@samba.org>,
    linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <477166.1716446208.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 May 2024 07:36:48 +0100
Message-ID: <477167.1716446208@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

ronnie sahlberg <ronniesahlberg@gmail.com> wrote:

> > The problem is that it essentially renders SEEK_DATA/SEEK_HOLE unusabl=
e for
> > applications on cifs.  If there's more than one extent above the start=
ing
> > position, they'll fail with EIO.  The only way to do it is to provide =
for a
> > sufficiently large buffer to accommodate however many extents that the=
re are
> > (and there could be millions, in theory) in order to get just the firs=
t one.
> =

> Wait, I didn't read all the text in the initial posts correctly.
> Do you mean if you ask for "max x bytes of response, enough for n
> entries" then if there
> are > n entries on the server you get nothing back?
> =

> I am pretty sure Windows will return as many entries as fits in the
> reponse out-data-size
> nad some error code.
> But you are saying that instead of returning a truncated out-blob that
> samba will return nothing?

It returns a STATUS_BUFFER_TOO_SMALL error if there's more than one extent
record to return.

David

