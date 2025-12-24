Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5870C2566F5
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 08:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766564272; cv=none; b=s4LzFh1WOGUo8GnoqRukvaMu/uvHn7lUkcyphzHfrap3u2BAyL7NSJ2k3A2oIOsLqgTLLj8od4TbvJcgC2YfUt+WNdI3n9mIgcJIt2fAi+FmcquYfwp1nnQUKzIeAcLBJjrypRYfqQkBPxvhlZmcto4sIOROS3B8fsttI6Xfh84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766564272; c=relaxed/simple;
	bh=ZE/wH1iCnOXhVuRKUXMNUP0GyubqAjLV3kdbBH1FXu8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=d5U65vfewo/lXvL1t1+puBJPGPMTQZAz5xftvr5ex2HNuOBsSgWOBHjCmbWCPzMH9FXjTYJOeRjzq8dEtxHzNPT1CnTldCJy8L5hwVCPOCBVkijcys5F0PmL52xqClaiOCT/a2KhaxJW9SGjG9QyjEzdpNA6lv3SgM9s73rkNC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Av5N1SkD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Av5N1SkD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766564269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VNCm18jcHZ7GmdX49li6+xU+QBbxzwOlrKNE7Cf9d6c=;
	b=Av5N1SkDdnB4R/PUQTmPcKk8p2rpfbbPaT1hmQ0oSroWo8rhoeZKoxRhENuyBAW32F6kBp
	YxgNYIg1Jo+N/BrXomMoKBM5g3Vxrvcqq0+aPWIFs8J4DJvUx8CFqOK5p2O+VPldPNj1sR
	G8+l/KhHk2KknR+kBI54usMUJFRbHAs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-0cPnYIXrMaGktjUZ-doWvQ-1; Wed,
 24 Dec 2025 03:17:46 -0500
X-MC-Unique: 0cPnYIXrMaGktjUZ-doWvQ-1
X-Mimecast-MFC-AGG-ID: 0cPnYIXrMaGktjUZ-doWvQ_1766564265
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A20EE19560A5;
	Wed, 24 Dec 2025 08:17:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7030030001A2;
	Wed, 24 Dec 2025 08:17:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251224023145.608165-5-chenxiaosong.chenxiaosong@linux.dev>
References: <20251224023145.608165-5-chenxiaosong.chenxiaosong@linux.dev> <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v5 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1167950.1766564260.1@warthog.procyon.org.uk>
Date: Wed, 24 Dec 2025 08:17:40 +0000
Message-ID: <1167951.1766564260@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

chenxiaosong.chenxiaosong@linux.dev wrote:

> +static struct status_to_posix_error *smb2_get_err_map(__le32 smb2_status)
> +{
> +	struct status_to_posix_error *err_map, key;
> +
> +	key = (struct status_to_posix_error) {
> +		.smb2_status = smb2_status,
> +	};
> +	err_map = bsearch(&key, smb2_error_map_table, err_map_num,

Use ARRAY_SIZE(smb2_error_map_table) here, not err_map_num.

Also, as your cmp function is so simple, you should use __inline_bsearch(),
not bsearch().  You don't want to make lots of function pointer calls if you
can avoid it, and mark:

> +static int cmp_smb2_status(const void *_a, const void *_b)

as __always_inline to make sure the compiler gets the point.

David

