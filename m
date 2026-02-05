Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32E71A9B58
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327103; cv=none; b=rau1cUoSP3u8+Lj/ssLq7rvDP5daqV3P6FhlylruFMUP86712OQkUw4g8sbdcVc2IB8IxQ/j12/lCBGKrzZEB9vKJ8yOwSsu3LTjT0ogsl1yU1rkddbtPfC8tZ3IyCR1Ljo/MeGY5jKanUpp4UrEHmdSMzqHKJI5uFYWJ15TXcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327103; c=relaxed/simple;
	bh=4sfOJbZcSFjdcBWJN3QuBaRuBziYUbTJMaMP0k/lmdg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=BhW+2/VZY4i60/QSLhdZXjqUpR7+80vkPzd3hlmu2KLu+7C/cpELRYLOdCVwtuYJzyYuUkB82DPX5f7ZQwkOJ0XKEdG74EXuScP+nVKE2LqHv0vy7mwv5wFsUXXZrQkcoQ37kt/LNsgzHmAgdm2sYDCJGXBXbD91jlrtk4iAC7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OI53xlTW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OI53xlTW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770327102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5lKWBa2K5H8FYCNGLv7Gn5ymoWWPf340tLeqiUKw1Q=;
	b=OI53xlTWQXv0BA+2RC+CYqNWJ1chaa14Js/ZK5QK5mvmEuyQ8kCxlCjlrMFzFIf2zb1K/E
	TOv0u+J/T1zfENRgrjOLUgzMUVoTHChXzMi1RW9WZiIGANQvjkz4vm/8B6eMj+cK0y/XNE
	AJyCNqYtKL+HkxjcMUmOFUDwwXVmsI0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-LdQO0BiBO8WNrpFy_RisYw-1; Thu,
 05 Feb 2026 16:31:40 -0500
X-MC-Unique: LdQO0BiBO8WNrpFy_RisYw-1
X-Mimecast-MFC-AGG-ID: LdQO0BiBO8WNrpFy_RisYw_1770327099
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58FB61955F20;
	Thu,  5 Feb 2026 21:31:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C3FF1300DDA1;
	Thu,  5 Feb 2026 21:31:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <e2726e90-3645-44ef-9af8-2d390c4d5bc6@samba.org>
References: <e2726e90-3645-44ef-9af8-2d390c4d5bc6@samba.org> <20260203152012.914137-1-metze@samba.org> <68046261-f2d9-49a2-92ea-9c7abb97cd5e@samba.org> <46c9afa7-7834-4ac4-8509-b7087f358c96@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
    Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org
Subject: Re: [PATCH] smb: common: add header guards to fs/smb/common/smb2status.h
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2901814.1770327095.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Feb 2026 21:31:35 +0000
Message-ID: <2901815.1770327095@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Stefan Metzmacher <metze@samba.org> wrote:

> diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
> index 802dec276e15..3abd357d6df6 100644
> --- a/fs/smb/client/Makefile
> +++ b/fs/smb/client/Makefile
> @@ -47,7 +47,7 @@ cifs-$(CONFIG_CIFS_COMPRESSION) +=3D compress.o compre=
ss/lz77.o
>  #
>  # Build the SMB2 error mapping table from smb2status.h
>  #
> -$(obj)/smb2_mapping_table.c: $(srctree)/fs/smb/common/smb2status.h \
> +$(obj)/smb2_mapping_table.c: $(src)/../common/smb2status.h \
>                             $(src)/gen_smb2_mapping
>         $(call cmd,gen_smb2_mapping)

That looks reasonable.  Do you have a patch for it, if so, you can add:

	Reviewed-by: David Howells <dhowells@redhat.com>

David

