Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0002264AD
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 20:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754685201; cv=none; b=eMZ25hapjlkcovhrpS+KAJEUU1QhU3kcixr9//KYPNvieET6n+3BchNygWMK9ukGOYZvoMfJBN3R08Gzeq9LUTDpE3fCG4/FPoT4NAfNpEGFOO1atrJElrZ6G0MyRqqxpYxBVIqFU0TtOcw03DWnoeLUY0GnM0A/G0zx7g87YKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754685201; c=relaxed/simple;
	bh=RS5B5cyKl6ICqS957iW8mhc8OHHq0JfLXet8VhHLYbc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=HxL+ffr8CiubQGogg78EIacoRuYiKWFyfjHceap2ktm+8Y/mYpPMrBWvhJ+epVq8fynaM3Xn8TBOYQsrL7vxeVXmnLGufZvPqjuQxS3l2PaqWcca7+DGFKvBV/0ySYYbmCzO0Lwyry4zY6jsSUVqaitFhygYXkzyPvxEM7U1wBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WA5wgSaw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WA5wgSaw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754685197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VF/ecjtThhWGy+i8Zkh8JXBPgtOI7EqWXlR0uJBrg+g=;
	b=WA5wgSaw09JFXQdDFlu0iEdJwqjZgoYD38y4zmGzYNbi5OVzps6lY7ESCgL1+ZB7o71jFZ
	Ju/AUjYum4LrPprcvAkZ+FZnI/oXwfLGzaGp4lrblArom4tfF3yN8Cc+1D8mnj5MGTfPs4
	NIS55zWu4H0JPWiEJ1/IChaKB6io5Ac=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-OIDZeLw8PGuix2iF-cifWA-1; Fri,
 08 Aug 2025 16:33:12 -0400
X-MC-Unique: OIDZeLw8PGuix2iF-cifWA-1
X-Mimecast-MFC-AGG-ID: OIDZeLw8PGuix2iF-cifWA_1754685190
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FABA19560B2;
	Fri,  8 Aug 2025 20:33:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.17])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6127F180029E;
	Fri,  8 Aug 2025 20:33:07 +0000 (UTC)
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
Content-ID: <2942077.1754685186.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 08 Aug 2025 21:33:06 +0100
Message-ID: <2942078.1754685186@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Enzo Matsumiya <ematsumiya@suse.de> wrote:

> Anyway, if you want me to test, just send me the patches.
> I have your linux-fs remote as well, if that's easier.

If you look at:

https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/=
?h=3Dcifs-experimental

You can see a patch with the subject "cifs: [!] FIX transport compression"=
.
Grab that and everything up to it.

I'm pretty certain it won't work, but I can't test it.  Well, maybe I can
force it on and look at the packet trace if wireshark can handle it.

Some things to note:

 (1) In smb_compress(), netfs_alloc_bvecq_buffer() is used to allocate the
     destination buffer and attach it to a bvecq, which it also allocates.=
  An
     iterator can be set on this to define part of the buffer to operate o=
n.

 (2) vmap_bvecq() is used to map the source and the destination buffers.  =
It
     extracts the pages and then calls vmap() on them.

 (3) Space for the compression header is allocated by smb_send_rqst() in t=
he
     first bvecq slot along with the rfc1002 header and transform header (=
if
     sealing).  A pointer is passed down to smb_compress().

 (4) It attempts to adjust the values such that the compression header is
     included in the encrypted section if also sealing.  However, it might=
 be
     better to have smb_compress() place it in the output buffer.

 (5) If compression is successful, smb_compress() switches the original bv=
ecq
     and the output bvecq and moves the header segment from the original t=
o
     the output.

 (6) If the compression algo returns -EMSGSIZE, then the compression heade=
r is
     excluded from the header segment.

David

