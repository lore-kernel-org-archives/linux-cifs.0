Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76899132103
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750333323; cv=none; b=W0YmOEBEmZTjH/QXrXilrZ/B7IZR4G6cBrtowh0chhtNLrUzlISMy9weUJIk+8Adp4DTApXpbtRSGrs5RkUCqzNyy6attX9RTysvcARLvW4ifLwxIeSY7EuuDvKtESbhqrnCag6FvUnDQRsC291ht9id1b4VF0CtOM3TDVKrmVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750333323; c=relaxed/simple;
	bh=BuXdtIdbpoq2mfwjmvaUtv8Vl30VP1eUbsu1BLkkWoY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=XMK6sR+rLosWAN8slfz2rFPgND/W/hM0U75lM7eFdUG1Gv3p0S48+ptmRhDd67vAjB3Cl/YfKZcGl69/L3/Tu26CBpE/xBtEGP/vVOb9VJkYawHl2/e0XloUPniiv/HGJoD6Xy/HwkbXWir4lNVyIwBxs0ha604UMsbPw+7ecDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WUAzLjjf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WUAzLjjf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750333320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKfWnpo+4ughX5EUL9WsFbpBW+HuGqDUdvc9TxPrsMY=;
	b=WUAzLjjfMjus/uyNeSiL3Dkn39KoPWp5h19Job6BCOBW4y91EJGTPLkQ6OBQCZ3+0mAv7X
	vjGWF+y0JZr8PdXq+2oaxu//QpaQISRDzg0SClzQWthuB5WMHqfAFTkRfTFiL18Zo6Bu3o
	PkMSf07MH+m3kyJoENuwFCJapb+Xvg0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-HuOTAKv6MCmGMsKhNq11Gg-1; Thu,
 19 Jun 2025 07:41:57 -0400
X-MC-Unique: HuOTAKv6MCmGMsKhNq11Gg-1
X-Mimecast-MFC-AGG-ID: HuOTAKv6MCmGMsKhNq11Gg_1750333316
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F55F1956088;
	Thu, 19 Jun 2025 11:41:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B6B4219560A3;
	Thu, 19 Jun 2025 11:41:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <530e18dfe16eaba6fb66d9d8a9a93d50e99f5c1c.1750264849.git.metze@samba.org>
References: <530e18dfe16eaba6fb66d9d8a9a93d50e99f5c1c.1750264849.git.metze@samba.org> <cover.1750264849.git.metze@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
    Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH 1/2] smb: client: fix max_sge overflow in smb_extract_folioq_to_rdma()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <850216.1750333313.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Jun 2025 12:41:53 +0100
Message-ID: <850217.1750333313@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Stefan Metzmacher <metze@samba.org> wrote:

>  		if (offset < fsize) {
> -			size_t part =3D umin(maxsize - ret, fsize - offset);
> +			size_t part =3D umin(maxsize, fsize - offset);
>  =

>  			if (!smb_set_sge(rdma, folio_page(folio, 0), offset, part))
>  				return -EIO;
>  =

>  			offset +=3D part;
>  			ret +=3D part;
> +			maxsize -=3D part;

I don't think these two changes should make a difference.

>  		}
>  =

>  		if (offset >=3D fsize) {
> @@ -2610,7 +2611,7 @@ static ssize_t smb_extract_folioq_to_rdma(struct i=
ov_iter *iter,
>  				slot =3D 0;
>  			}
>  		}
> -	} while (rdma->nr_sge < rdma->max_sge || maxsize > 0);
> +	} while (rdma->nr_sge < rdma->max_sge && maxsize > 0);
>  =

>  	iter->folioq =3D folioq;
>  	iter->folioq_slot =3D slot;

But this one definitely should!

Reviewed-by: David Howells <dhowells@redhat.com>

