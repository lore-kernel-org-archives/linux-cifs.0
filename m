Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5929321C16A
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 23:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765407817; cv=none; b=Wt0loxuSs4367feLAAh/5yZ7poU8YDAgI55oaq6n2z2vhSi1TmaMNSy5GM+KyL4LzFBAT1AsOSiV9Riu5scMoAXoGF3XWBMQvL9ii69ZfwD2A+9H+TL9SqKzrTUJm3ipJyQPj0zoDz5vslvX+YOvK9/4kDofsndJkCx2PDLGh8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765407817; c=relaxed/simple;
	bh=Uz4GO2oiNbbi7dgQJOngsBxO23uhUn/snPeOxrcS2DA=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=J1mIIHeOT0DeO43L+80sWjvAcrQlvFjVoX+iYtrFZo7Xh8oo79dv6z1VgPkBt5deGrHw29kCcoaRdh0KtE6oTfbM35PGuGsdvm+iHNYP/av0xBkss2jsnmpNVdKLG9fNVN59FZ9s/s7+NkRBKzhVLKpTKIdsIMVCu80BLCH7394=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cn85AKQu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cn85AKQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765407815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=fmyXaxCJoN6MzTuqWuFIJ3FLOSxsgdOG0B+SwznTV5Y=;
	b=Cn85AKQuILkgEcGLjOcbBwGM04USeuu/Ngg+lP/SvR1pqV2GsB/IRslPKG+5o9e4wgQc2o
	3QvyXTnE5Ff1QeSQwKP7/mXwv2FSEL0JTTevL/KKJ6nOSd2Qi5/pa0C95xE2h9cG5bCsFx
	+IhuspPonXSuZ3zARh6p3R81gBMiikg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-YE8vUAjfM52ki_bsiTdwHA-1; Wed,
 10 Dec 2025 18:03:29 -0500
X-MC-Unique: YE8vUAjfM52ki_bsiTdwHA-1
X-Mimecast-MFC-AGG-ID: YE8vUAjfM52ki_bsiTdwHA_1765407806
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1379B1956089;
	Wed, 10 Dec 2025 23:03:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C5E7F180035F;
	Wed, 10 Dec 2025 23:03:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: ChenXiaoSong <chenxiaosong@kylinos.cn>
cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>,
    liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
    Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Subject: Can we autogenerate smb2_error_map_table[]?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <650895.1765407799.1@warthog.procyon.org.uk>
Date: Wed, 10 Dec 2025 23:03:19 +0000
Message-ID: <650896.1765407799@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Chenxiaosong,

Can I suggest that rather than doing your "[PATCH v4 05/10] smb/client: sort
smb2_error_map_table array", we autogenerate the table from the header file,
putting all the info there?

One problem that we have is that we have multiple copies of the error table -
and keeping them up to date and strictly ordered is problematic (hence your
kunit test).  Further, each error number is mapped to an error string with the
name of the symbol (I think they're all exactly equivalent).

So, for example, I do this for the ASN.1 Object Identifier (OID) registry.  I
have a perl script:

	lib/build_OID_registry

that parses the enum here:

	include/linux/oid_registry.h

including the comments and generating tables for looking up OIDs:

	enum OID {
		OID_id_dsa_with_sha1,		/* 1.2.840.10030.4.3 */
		OID_id_dsa,			/* 1.2.840.10040.4.1 */

This is built by rules in lib/Makefile:

	#
	# Build a fast OID lookip registry from include/linux/oid_registry.h
	#
	obj-$(CONFIG_OID_REGISTRY) += oid_registry.o

	$(obj)/oid_registry.o: $(obj)/oid_registry_data.c

	$(obj)/oid_registry_data.c: $(srctree)/include/linux/oid_registry.h \
				    $(src)/build_OID_registry
		$(call cmd,build_OID_registry)

	quiet_cmd_build_OID_registry = GEN     $@
	      cmd_build_OID_registry = perl $(src)/build_OID_registry $< $@

	clean-files	+= oid_registry_data.c

Now, looking at smb2status.h, for example, we have a lot of:

	#define STATUS_SUCCESS cpu_to_le32(0x00000000)
	#define STATUS_WAIT_0 cpu_to_le32(0x00000000)
	#define STATUS_WAIT_1 cpu_to_le32(0x00000001)
	...

and we could generate two parts of the table from this.  The third part could
be placed in the header as well:

	#define STATUS_SUCCESS	cpu_to_le32(0x00000000)	// 0
	#define STATUS_WAIT_0	cpu_to_le32(0x00000000)	// -EIO
	#define STATUS_WAIT_1	cpu_to_le32(0x00000001)	// -EIO
	...

(There's also the possibility that we don't necessarily want to list all
statuses in the table.)

David

