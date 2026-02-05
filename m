Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4F442DFE0
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306665; cv=none; b=rAaE8owekejd2zl5oGvHIA67T9QpY+Lc6o+cezr/vAHP1wVOwrq7m+tG3sPHK0NhHY0WWV/TZOJ7sJLohScMzsXLottTF1UR93DC+eXV6XeppGnNvuNzPUEodwqXVBMgFqgVTCk4/smECI+rsEEC2y0COiuVV/BwwogcGUweHIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306665; c=relaxed/simple;
	bh=1EnFx7GcjJUkrhE9NTVfctHqdWnXf4mZEXaMAm/AK5w=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=D1u8VkGJVL/80075JDd++Hb5+oqyU1Wj7XD0z77T8D4+8gUc9o6UJDJR8pGVg426TjHft7lOBqvQIIpDiv4mUsmu2dV27bSsYJyODgPDpfB3D+pg0LUX0QipuZQROr30iM6dP2+OSet162k0FMAiIYX84slWBy7xJYy0j1xMIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVNX7r6L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVNX7r6L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770306663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79E3S7ZlvMoYYhjBeumot8W9GOh2YZ9cul/cCTPrSYw=;
	b=IVNX7r6LNp+4UgenJhq2PSMWipyTFu8YgF8JB+rW9VnOBIAIWJ67Y4aqRIdgHKfxIFCL1w
	wTm9FCbJXliKB/ZpbHr7XzsTvEf+ack0ECx8vawk+altza0t4oeKRDozBQvDTYOVV1zc6q
	plDll/+vPQw+kvCmCN38Vu/Im6A8tQE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-TKvniQW3PnGBAA4jk-H3qA-1; Thu,
 05 Feb 2026 10:51:02 -0500
X-MC-Unique: TKvniQW3PnGBAA4jk-H3qA-1
X-Mimecast-MFC-AGG-ID: TKvniQW3PnGBAA4jk-H3qA_1770306660
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23FA818002C3;
	Thu,  5 Feb 2026 15:51:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29076192C7C3;
	Thu,  5 Feb 2026 15:50:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    nspmangalore@gmail.com, henrique.carvalho@suse.com,
    meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, pali@kernel.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/client: fix memory leak in smb2_open_file()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2892311.1770306653.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Feb 2026 15:50:53 +0000
Message-ID: <2892312.1770306653@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

chenxiaosong.chenxiaosong@linux.dev wrote:

> @@ -178,6 +178,7 @@ int smb2_open_file(const unsigned int xid, struct ci=
fs_open_parms *oparms,
>  	rc =3D SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL=
, &err_iov,
>  		       &err_buftype);
>  	if (rc =3D=3D -EACCES && retry_without_read_attributes) {
> +		free_rsp_buf(err_buftype, err_iov.iov_base);

Since err_iov is going to get used again, it might be worth NULL'ing the
pointer out here.

>  		oparms->desired_access &=3D ~FILE_READ_ATTRIBUTES;
>  		rc =3D SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NUL=
L, &err_iov,
>  			       &err_buftype);

David

