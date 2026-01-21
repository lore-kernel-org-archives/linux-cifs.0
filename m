Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF1136CE04
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 23:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769038594; cv=none; b=SBoa8Ce83mICnzS3lXrKrqwrFUoEdnilkppAkiHF2EDpN5PVYOasw/1iELjnNjyvtbx5/K19fIph7zk2AemhCDw9eZJSZpdomETX2o1nCmNClq6llAGSC3O7BO6JRuiwg4U+Q2lpZs8coD4kUiKqD1gJHnJmgJDsswcgLLkrhsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769038594; c=relaxed/simple;
	bh=lP3eQ7fMrH64ZHZOKxcQwzmsZbc974t6RPxLqwhBZxA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=DHD8LsDUvAZ0axoGuo3iviOitA3BW8lnbuHtJBUOWUbbfWIZBGsaSW4zjVYjLyhhdf5xBXDZdw1ph/9JAmJHj10+NBvNXhxLzdwJvbO4PTU2gKM7qymPeMoST9qRXrG/G7rH7esPwMAXHdaBoCAQNS81MAXYUWiDPTHI3rLCYUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHdf7Yr+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHdf7Yr+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769038591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JgOfwTTXR5hZJEmugy7AmQ4bkPqQHIBMTcEnV2wyaKw=;
	b=EHdf7Yr+0SHEqUZse2rr3p01VSoOtOvHxjo3bWVrk+qKNXCFT9Qz8Ft/ohxdQyPzt10tSo
	eHoeQ63uxM3HLtdhUv/qgaSYLjUSigsVx0S8aPI4TE/42d/zDH7+/vow1xc7PnHJHGIdgR
	P2Mq+UJCsI42++04Dyo5uEe6Qwkjv64=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-oC8w937GMoGu4WcoeWyACg-1; Wed,
 21 Jan 2026 18:36:27 -0500
X-MC-Unique: oC8w937GMoGu4WcoeWyACg-1
X-Mimecast-MFC-AGG-ID: oC8w937GMoGu4WcoeWyACg_1769038586
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AACF19560B7;
	Wed, 21 Jan 2026 23:36:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F3C4219560AB;
	Wed, 21 Jan 2026 23:36:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260120062152.628822-4-sprasad@microsoft.com>
References: <20260120062152.628822-4-sprasad@microsoft.com> <20260120062152.628822-1-sprasad@microsoft.com>
To: nspmangalore@gmail.com
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.com, bharathsm@microsoft.com,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/4] cifs: make retry logic in read/write path consistent with other paths
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1653030.1769038583.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Jan 2026 23:36:23 +0000
Message-ID: <1653031.1769038583@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

nspmangalore@gmail.com wrote:

> @@ -4994,6 +5014,14 @@ smb2_writev_callback(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
>  			      server->credits, server->in_flight,
>  			      0, cifs_trace_rw_credits_write_response_clear);
>  	wdata->credits.value =3D 0;
> +
> +	/* see if we need to retry */
> +	if (is_replayable_error(wdata->result) &&
> +	    smb2_should_replay(tcon,
> +			       &wdata->retries,
> +			       &wdata->cur_sleep))
> +		wdata->replay =3D true;
> +

This is really, really going to suck performance wise.  ->callback() is ca=
lled
in the context of the I/O thread for that socket.  smb2_should_replay() do=
es
an msleep() of up to 2 seconds.  That means you aren't going to be process=
ing
*any* messages coming down the socket from the server for the duration.

Better to offload the pause to netfslib if we can.

David

