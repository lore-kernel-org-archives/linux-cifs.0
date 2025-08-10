Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D892035948
	for <linux-cifs@vger.kernel.org>; Sun, 10 Aug 2025 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754868574; cv=none; b=RiswfeE55qaHr/T7YScubq7qCpQMnPs8rfMnGmPT4tWmaYpgL9Ta++JmYYfZ/v1G/qpOY5vqPzsuP0w/zXUo/T7R4AwRYMos9tbz6H4J68IUDAMolaA2QZJBPIAIEhnceK10L5NuN79yZC6qR+HwPSDKjSPRZ4VrPAwmPbadCRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754868574; c=relaxed/simple;
	bh=Uf8N1ahlwJDeAzHiB5dvYEHlUmV/fZHLmhMrdLxFA2c=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=gmtmU6vDgJ23aRQI2Xm+SOUO0TbGLlWVYxeWuEbrkGedSwZLKfqvMwZO4/2h45vkx67v80peqhpcsAdlzuaAeIZGlPjg+OfPZFoYVwz0eKPXRikpTxqvKn2TKNyUkqdgw7A7q5CiCIPMK/QXwsUClQiX7R04R1wvAZ3IWgfQJkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFoPIsxI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFoPIsxI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754868571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMxPoQZeiqEcqQUrLPVTlJKYo2zdz3EkPBJ/0rdnkZg=;
	b=IFoPIsxIPGXdQPP5K5mK5xWR4zcKKWqmSpDoO09n+ufBL5JH6cDrBNNXfwFx8TLC8IMLL6
	o2hdC/wpjbzzbiLGcVtteV7pJAHi6+5a0yEmoBHsmLITR8LX42svxVqDx2+Ri5o31P1c1e
	cJsbvnBs0v40X1R1inV6xGM23n9HRP4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-EdnN79zwPaCeFpC4QVhMLg-1; Sun,
 10 Aug 2025 19:29:30 -0400
X-MC-Unique: EdnN79zwPaCeFpC4QVhMLg-1
X-Mimecast-MFC-AGG-ID: EdnN79zwPaCeFpC4QVhMLg_1754868568
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17456195608E;
	Sun, 10 Aug 2025 23:29:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7B9C3001455;
	Sun, 10 Aug 2025 23:29:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <dseje3czotanrhlafvy6rp7u5qoksqu6aaboyyh4l36wt42ege@huredpkntg2t>
References: <dseje3czotanrhlafvy6rp7u5qoksqu6aaboyyh4l36wt42ege@huredpkntg2t> <nok4rlj33npje4jwyo3cytuqapcffa4jzomibiyspxcrbc6qg6@77axvtbjzbfm> <20250806203705.2560493-1-dhowells@redhat.com> <2938703.1754673937@warthog.procyon.org.uk>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Wang Zhaolong <wangzhaolong@huaweicloud.com>,
    Stefan Metzmacher <metze@samba.org>,
    Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES and use netmem allocator
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <308527.1754868563.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 11 Aug 2025 00:29:23 +0100
Message-ID: <308528.1754868563@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Enzo,

I now have encryption, compression and encryption+compression all working =
:-)

I've pushed my patches here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Dcifs-experimental

It should work up to "cifs: Don't use corking".

Btw, is is_compressible() actually worth doing?  It seems to copy a lot of
data (up to 4M) to an extra buffer and then do various analyses on it,
including doing a sort.

I need to extract a fix for collect_sample(), which I can do tomorrow, but=
 it
should look something like:

/*
 * Collect some 2K samples with 2K gaps between.
 */
static int collect_sample(const struct iov_iter *source, ssize_t max, u8 *=
sample)
{
	struct iov_iter iter =3D *source;
	size_t s =3D 0;

	while (iov_iter_count(&iter) >=3D SZ_2K) {
		size_t part =3D umin(umin(iov_iter_count(&iter), SZ_2K), max);
		size_t n;

		n =3D copy_from_iter(sample + s, part, &iter);
		if (n !=3D part)
			return -EFAULT;

		s +=3D n;
		max -=3D n;

		if (iov_iter_count(&iter) < PAGE_SIZE - SZ_2K)
			break;

		iov_iter_advance(&iter, SZ_2K);
	}

	return s;
}

What's currently upstream won't work and may crash because it assumes that
ITER_XARRAY is in use - which should now never be true.

Also, there's a bug in wireshark's LZ77 decoder.  See attached patch.

David

diff --git a/epan/tvbuff_lz77.c b/epan/tvbuff_lz77.c
index a609912636..13ab5c50ed 100644
--- a/epan/tvbuff_lz77.c
+++ b/epan/tvbuff_lz77.c
@@ -68,7 +68,7 @@ static bool do_uncompress(tvbuff_t *tvb, int offset, int=
 in_size,
 						in_off +=3D 2;
 						if (match_len =3D=3D 0) {
 							/* This case isn't documented */
-							match_len =3D tvb_get_letohs(tvb, offset+in_off);
+							match_len =3D tvb_get_letohl(tvb, offset+in_off);
 							in_off +=3D 4;
 						}
 						if (match_len < 15+7)

