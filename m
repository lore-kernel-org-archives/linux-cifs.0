Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EB428BA82
	for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750842110; cv=none; b=piE9CAXSkGen03dO8yWlYmnHoAqg0oVspNYSoq++aCa3bFprdeCWHJrACh/WBOY92XIe4XRn+UTITGMVbNSpSNJk0sFcmvxw339c6adg6SM/fdttXkLJ6wyU1b9fH6eye3uiPQLr97ubUEYfExuOV0Bu4KqchxgnCYe3764+I2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750842110; c=relaxed/simple;
	bh=6PrUleXUYGJkrglYnDgm87U2trHxdb3gchAW/qkmpuk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ZVfUwKIB6VIVw9sGXSztlL2esZyZ2XXV1wKjp4IlfQcOlca0uJ8F0b/IJ3FjDkHq3fp0aCipaSk7jL9I4mmf6CwB5LRlt5+zSeVOkCIp4R/vbDKjyb03gRUYf+qJ6efJHGZ4GnMTXKOEhP4pwbKwWmZs3ANjBqt4ANb3lbH0KSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aIP/7rLj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aIP/7rLj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750842108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBwag9gY//+sYzvvjqRvddZnoX/x2SeT9w+Hu1KXyic=;
	b=aIP/7rLjm34n+/zCz8PNhbQyrNZrwimW/Ko+LodDN+atpQnO7uxpYH5fmw+pNu54+k9VVP
	Msa+ybee9Qv9dcMd6aARRcmjVA51zF5Rx3gI13AUY5VKWtH29eXU2eMFWDNrA4dOP8EKsp
	PxWKqS9VeGALvkML1Flhrn5UqmxqczA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-BBYgFwb4MEeM1WinOA2_0Q-1; Wed,
 25 Jun 2025 05:01:44 -0400
X-MC-Unique: BBYgFwb4MEeM1WinOA2_0Q-1
X-Mimecast-MFC-AGG-ID: BBYgFwb4MEeM1WinOA2_0Q_1750842101
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 648DE1808984;
	Wed, 25 Jun 2025 09:01:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 737AD180045B;
	Wed, 25 Jun 2025 09:01:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250625081638.944583-1-metze@samba.org>
References: <20250625081638.944583-1-metze@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org, Steve French <sfrench@samba.org>,
    Tom Talpey <tom@talpey.com>, stable+noautosel@kernel.org
Subject: Re: [PATCH v2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1288832.1750842098.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Jun 2025 10:01:38 +0100
Message-ID: <1288833.1750842098@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Stefan Metzmacher <metze@samba.org> wrote:

> We should not send smbdirect_data_transfer messages larger than
> the negotiated max_send_size, typically 1364 bytes, which means
> 24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.
> =

> This happened when doing an SMB2 write with more than 1340 bytes
> (which is done inline as it's below rdma_readwrite_threshold).
> =

> It means the peer resets the connection.
> =

> When testing between cifs.ko and ksmbd.ko something like this
> is logged:
> =

> client:
> =

>     CIFS: VFS: RDMA transport re-established
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     siw: got TERMINATE. layer 1, type 2, code 2
>     CIFS: VFS: \\carina Send error in SessSetup =3D -11
>     smb2_reconnect: 12 callbacks suppressed
>     CIFS: VFS: reconnect tcon failed rc =3D -11
>     CIFS: VFS: reconnect tcon failed rc =3D -11
>     CIFS: VFS: reconnect tcon failed rc =3D -11
>     CIFS: VFS: SMB: Zero rsize calculated, using minimum value 65536
> =

> and:
> =

>     CIFS: VFS: RDMA transport re-established
>     siw: got TERMINATE. layer 1, type 2, code 2
>     CIFS: VFS: smbd_recv:1894 disconnected
>     siw: got TERMINATE. layer 1, type 2, code 2
> =

> The ksmbd dmesg is showing things like:
> =

>     smb_direct: Recv error. status=3D'local length error (1)' opcode=3D1=
28
>     smb_direct: disconnected
>     smb_direct: Recv error. status=3D'local length error (1)' opcode=3D1=
28
>     ksmbd: smb_direct: disconnected
>     ksmbd: sock_read failed: -107
> =

> As smbd_post_send_iter() limits the transmitted number of bytes
> we need loop over it in order to transmit the whole iter.
> =

> Cc: Steve French <sfrench@samba.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: <stable+noautosel@kernel.org> # sp->max_send_size should be info->ma=
x_send_size in backports
> Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an ite=
rator")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>

Reviewed-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>

