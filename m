Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37951C7012
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766850654; cv=none; b=EZJMsdlcEDe8BBwbbgnzc4AsCdISzZJtmPDuQwFczeWxTmHjMrMkcNCMFkkuIttmOvZC0c3RIpMs/64RzfFdqDE3BNYiE0tyk4Jx6thCohsZONid6fh+zovGwHHd6uxDuCrcQ5s7zQzHLwgm1Z6O7lKtrP9PHZwt9/ye0LP4sp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766850654; c=relaxed/simple;
	bh=mH6PfhdMJFS3fu2x/8dBMWsJ+EHvbFiMOp3a/EZzJ7Q=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=o0h/mAQqikoFd7CPbwf4wdEzxG/obfOp9UG3toOvqFBKoFz4mujOwacK+b1uBTrRpK3NSfM+uMK5ylHq9OfNleSjoDnv4Bh6qxRtRIJjQvMK7TsiPSrpebQUnpgEaRGcxbqKAJWBv+fsNSoD0bealWAHqQGGhIntwYWI2JJqIUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=In43fB0x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="In43fB0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766850650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mH6PfhdMJFS3fu2x/8dBMWsJ+EHvbFiMOp3a/EZzJ7Q=;
	b=In43fB0xWTQnPVmF8+cRCKjjmljbTi4Y5x6nZiAHB0JLu3kwYcb6CAQNqKoTOdEgBEBBdq
	2iuZ/dg2bQiCnBQiUylswInWIgR7rbXSdGAh52UvE2uaezrzApSTNhB9azXL4EBzt9rOWv
	qkxnQTxT2q87LhVYEBBHnY79beqepw4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288-kDMMxiPDO0yHD_RP4xkXig-1; Sat,
 27 Dec 2025 10:50:46 -0500
X-MC-Unique: kDMMxiPDO0yHD_RP4xkXig-1
X-Mimecast-MFC-AGG-ID: kDMMxiPDO0yHD_RP4xkXig_1766850644
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CFAF18001D7;
	Sat, 27 Dec 2025 15:50:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1446F19560AB;
	Sat, 27 Dec 2025 15:50:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5b74f84d-3de5-40fd-b0c8-f2743834bc1a@linux.dev>
References: <5b74f84d-3de5-40fd-b0c8-f2743834bc1a@linux.dev> <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev> <1266596.1766836803@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1276265.1766850638.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Sat, 27 Dec 2025 15:50:38 +0000
Message-ID: <1276266.1766850638@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> The `smb2_status` field in `struct status_to_posix_error` is `__le32`.
> =

> In many functions (e.g. `map_smb2_to_linux_error`), we compare `__le32` =
values
> directly.
> =

> Should we convert them all to cpu-endian? Should we remove `cpu_to_le32(=
)`
> from the macro definitions in smb2status.h?

Personally, I would, but I don't think it's likely Steve will agree to tha=
t.

David

