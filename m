Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93985128816
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766825824; cv=none; b=jKOOlPhOj2KGjs5t+azVo2g9qaXzgMH/DHJu3j0ZpoMBRw4GgQ4jW7KOJ6bwUSsKU8Apom5leDtDG6aYrQazTnqT2W9z8lRaaIMVpQcQjQG+nIruwPxdE/OwfSluaceptjA6x+rtGuwiFB3MO6ZwHDZmpCqb0gda4KSoaa7XzMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766825824; c=relaxed/simple;
	bh=VFnVAXdKRoA6BeG1WHGis2e3Am56dPK5opTVj8nldfI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=UC1UAM4nzrIDdDtgmX4w0qeuaPsjMDISmneNcZc1mhOqfkpqaYo0trOK35HfYILZjHLXTts8RjYEa0aDj8SpyV22/NLwupbA/9sq1E6Ek96Xt0eJOkwWZQ7sTtm80/ftzmU1AMu+lPjD9ePKBfM9InpKvozwHz20OI4Gsm5uBU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Al+xsEYV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Al+xsEYV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766825821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hEkHfYrWdAIbVHaBbFJnk8vye3Rde4gJI4d8WS/RB2Q=;
	b=Al+xsEYVLoVz2H+EetwFOzZ4B78qaGXXu7I3i4xmsqPVOFJDNrp/uBpOydZaAV1osx5Hu5
	svmQtSW9taW6t35S4Q4a2bsF7rCzQG1du9QbwOdHX87NyXLDYJJ+El82qPc9oYKIQtnqrl
	hxRT+UqNPnfqWLByyFHk5lHCyRcgWWM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-YOB3X3D4OXugunMxQCTuPQ-1; Sat,
 27 Dec 2025 03:56:58 -0500
X-MC-Unique: YOB3X3D4OXugunMxQCTuPQ-1
X-Mimecast-MFC-AGG-ID: YOB3X3D4OXugunMxQCTuPQ_1766825817
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D3B3180028B;
	Sat, 27 Dec 2025 08:56:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5F7FD19560AB;
	Sat, 27 Dec 2025 08:56:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <f0740fbf-1142-42f8-b56f-937fa915a4bb@linux.dev>
References: <f0740fbf-1142-42f8-b56f-937fa915a4bb@linux.dev> <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <1236711.1766750798@warthog.procyon.org.uk> <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>, pc@manguebit.org,
    ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
    bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1264022.1766825812.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Sat, 27 Dec 2025 08:56:52 +0000
Message-ID: <1264023.1766825812@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> Your second suggestion looks good. Should we change it to the following =
code?
> If you are okay with these changes, I can send the next version.
> =

> ```
> __inline_bsearch((const void *)(unsigned long)smb2_status, ...);
> =

> static __always_inline int cmp_smb2_status(const void *_key, const void
> *_pivot)
> {
>         __le32 key =3D (unsigned long)_key;
>         const struct status_to_posix_error *pivot =3D _pivot;
> =

>         if (key < pivot->smb2_status)
>                 return -1;
>         if (key > pivot->smb2_status)
>                 return 1;
>         return 0;
> }
> ```

__le32 key =3D (unsigned long)_key;

Ummm....  u32 key?  I'm pretty certain it's sorted in cpu-endian order.

Also, check the assembly - it might not actually matter as everything is
inlined.  The compiler might well optimise away with the thing being passe=
d
through _key and any dereference of that entirely.

David

