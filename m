Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEA61684AE
	for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 22:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365572; cv=none; b=mC0JOkg0A2eRwxs6IX3odjg48YUkt0JZ+nkOIOiYzqFrlidNWHsAph18KL3Z1SPuLN1bH6TX1WFP+N6bjZcjItlkpbBzJsFKGmafN5ZndvyNvyUkE78U5a7J3wt86WLLMZmjH9yiU3drpsyr6Rz1gcvOjj4Lq6Ge3fx0xxD2Jfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365572; c=relaxed/simple;
	bh=ecbDJvUHeP5FFoJYtntbEBhkbNUCDGOwX6Bch9xL+0I=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=fycy3EGGO8safoDL0E1IuO+l1rN0mzq+FfHZ+wa2WiT44qMqlSE+bh7iGdX3tCLTpUG7Zn2wU9wUv+aDdpih7pAMt9KAflxh7KdlmSpKvvjjMUP/PJbTxAipKwGMWVlRGss2fwDDsk8Wsqq84TF+D5lZ5eHtt+p1Wpsm85m9Ksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i2oGOXwG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i2oGOXwG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724365569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YoHc0DrXDUx2XRqsKC2VlLahjN/YyNxJ34WemSxbwPs=;
	b=i2oGOXwGp50NyQ/MDissHkWiVcai6U6gTyIu4nubS3SAapttUmwqNM3E8sQfoCYT2lS7sA
	aPAZ2u6/CKAixvA4jBouZBMeKe+DgFlyjLDq8QPYKPGARGAYEETXxxI32+ZOSn9mijwp8z
	sTj+V07T9cQ3xGUqzNpuZ9IvPvNoukE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-TJpQT-S_M0CCfP_wVZAPXA-1; Thu,
 22 Aug 2024 18:26:06 -0400
X-MC-Unique: TJpQT-S_M0CCfP_wVZAPXA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C4591955F45;
	Thu, 22 Aug 2024 22:26:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A089300019C;
	Thu, 22 Aug 2024 22:26:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation>
References: <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation> <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com> <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk> <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna> <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com> <476489.1716445261@warthog.procyon.org.uk> <477167.1716446208@warthog.procyon.org.uk> <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com> <af49124840aa5960107772673f807f88@manguebit.com>
To: Jeremy Allison <jra@samba.org>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.com>,
    Tom Talpey <tom@talpey.com>,
    ronnie sahlberg <ronniesahlberg@gmail.com>,
    David Disseldorp <ddiss@samba.org>,
    David Howells via samba-technical <samba-technical@lists.samba.org>,
    Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <319946.1724365560.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Aug 2024 23:26:00 +0100
Message-ID: <319947.1724365560@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Jeremy,

> Bug is in fsctl_qar():
> =

>         ndr_ret =3D ndr_push_struct_blob(out_output, mem_ctx, &qar_rsp,
>                 (ndr_push_flags_fn_t)ndr_push_fsctl_query_alloced_ranges=
_rsp);
>         if (ndr_ret !=3D NDR_ERR_SUCCESS) {
>                 DEBUG(0, ("failed to marshall QAR rsp\n"));
>                 return NT_STATUS_INVALID_PARAMETER;
>         }
> =

>         if (out_output->length > in_max_output) {
>                 DEBUG(2, ("QAR output len %lu exceeds max %lu\n",
>                           (unsigned long)out_output->length,
>                           (unsigned long)in_max_output));
>                 data_blob_free(out_output);
>                 return NT_STATUS_BUFFER_TOO_SMALL;
>         }
> =

> I'm guessing in this case we need to just truncate out_output->length
> to in_max_output and return STATUS_BUFFER_OVERFLOW.

Do you perchance have a fix for this?  I'm seeing it cause failures in
xfstests when running against cifs connected to samba.

Thanks,
David

