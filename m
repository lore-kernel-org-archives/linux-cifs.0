Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A691D7E42
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766825618; cv=none; b=VoOXRvHDoyQB6T4A9wAVVgtQGjjrPcMIHKurJuJj39Lx/yPpqZT3UQJYhhVr5ImIwZxTp3aUSW10SSSjk8O62sGxChbYhYpJXnAqMq9ZBukrgaZ9MGGovo2hOV+Ri6rKGsDONdk5OotdoCmpzebrRLXL+G/SkCwPksHWZ/wjWVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766825618; c=relaxed/simple;
	bh=FoQwo/kxr+zLqqFISNwxMBY1uzKTsuWIdSMoRf1IH7s=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=MHj/M4NwPiQj/0PwG/6Tb6DzNz81w+NuB/BBjBo+jlsTdCr2WODRc/HbnhDc/8G0RmESvAxJYcSrMoarkFeCIruXxDoOjDgsumKFxJZfHbBsev0bcdAKr3NFg5YeDjMK6pQtH8XUj/JlpWhfKCZtJ659q03D1HrqF6EyrLMEPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MtYQrftp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MtYQrftp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766825615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FoQwo/kxr+zLqqFISNwxMBY1uzKTsuWIdSMoRf1IH7s=;
	b=MtYQrftpy+QpaNmWhBh0/22fW7VtD0enWMBYBAbtZIcW7FMIvGD1Bc7qjzxgDgnSI3mgyq
	OsTnRgwYdeEF7x8xpX25F7KpcERdMg23YYtPaTMMBlQ2Rq8qMT15ZU63h4tS55qZk00z1Z
	gixWc+H4ysAEZmcEhElJhW5c0doamf8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-GEda5LGYPSyrp842FZqZVg-1; Sat,
 27 Dec 2025 03:53:31 -0500
X-MC-Unique: GEda5LGYPSyrp842FZqZVg-1
X-Mimecast-MFC-AGG-ID: GEda5LGYPSyrp842FZqZVg_1766825610
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29B3F195DE48;
	Sat, 27 Dec 2025 08:53:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD17119560A7;
	Sat, 27 Dec 2025 08:53:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev>
References: <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev> <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <1236711.1766750798@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1263962.1766825603.1@warthog.procyon.org.uk>
Date: Sat, 27 Dec 2025 08:53:23 +0000
Message-ID: <1263963.1766825603@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> We cannot use "return b->smb2_status - a->smb2_status".

Yeah, not unless we change the sorting on the table to match.

David

