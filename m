Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1242D20C488
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 21:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767128917; cv=none; b=ddzc1XdoRUrhy3D4h0M1Z/RcvhkNN+dFH2U7ufqsu40Ewi6SkVSCaMEwDHuJYk8hsOLXHszvRJcTnusOKFMi5ihtZXo1kQOM/pbuju/d2yntKJgILjaxoGv0B43xQzhpB4sCifO6HBjXUibGZIQGrLmvilElIGXXi/vpp0QoBp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767128917; c=relaxed/simple;
	bh=CkbotS+gAADWCeFYCRYX85fNXTCG4nzUodq9ULElZrc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=PeXiYBh5pJ4E8iPsbiztoIFkPimQpjTtjSbNotTj3BsWxBs7jO8bHAC08VzKouhSKRdmjGvEFN3UVVvtqbGh0/qfVNN36xc+20TYAUJoo+M2yTrgn04aLmpZXXXziXTNrJJKvhffBgOTurUHQbU1/CVS63Wr5E0Le24FJ9I9NBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H4fn6uXV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H4fn6uXV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767128915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ebQgUi5UBXG00bgFkSG8AeqibNO0RnZezPSGcPybLw=;
	b=H4fn6uXVcGu15kBS0jD8Wco+CIYrchYwJjtBma7BzAQYwKPUolJllG83lyNx+My7Wswrrt
	0QwMEldacmmcRFHvXVT9XnqFQDVesP61vO7JYV8mYIULCNT5F700yOeMXtzoNRu5EYMRCe
	mauaHbcVFS6tZp/iBFI5p24/g/Ev9jo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-1hvPyb7qPzexdGd_uHbnsw-1; Tue,
 30 Dec 2025 16:08:30 -0500
X-MC-Unique: 1hvPyb7qPzexdGd_uHbnsw-1
X-Mimecast-MFC-AGG-ID: 1hvPyb7qPzexdGd_uHbnsw_1767128908
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87331180028B;
	Tue, 30 Dec 2025 21:08:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCB64180049F;
	Tue, 30 Dec 2025 21:08:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <00150dea-4a30-49e3-a1c2-cd6e6561e238@linux.dev>
References: <00150dea-4a30-49e3-a1c2-cd6e6561e238@linux.dev> <5b74f84d-3de5-40fd-b0c8-f2743834bc1a@linux.dev> <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev> <1266596.1766836803@warthog.procyon.org.uk> <1276266.1766850638@warthog.procyon.org.uk> <1692b7a8-c208-4aa7-a9f4-02fea6d31733@linux.dev>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
    sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
    senozhatsky@chromium.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Dec 2025 21:08:24 +0000
Message-ID: <1368893.1767128904@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> David, what do you think of the modifications? Call le32_to_cpu() to get a
> cpu-endian value before comparison.
> ...
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u32 key =3D le32_to_cpu((un=
signed long)_key);

This should be done before calling __inline_bsearch(), really.  You only ne=
ed
to do it once.

David

