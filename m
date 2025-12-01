Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCBC313297
	for <linux-cifs@vger.kernel.org>; Mon,  1 Dec 2025 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764595535; cv=none; b=DzUzlWeoyiqE4BYpeYksNutligEidSUi+TGeaG1XdZsjpvTYKgD0RmWKMsIuQhGxGJO/S65aeDmM9wOwjTHeF0W0pkxMh1ICN8E0OKkcvImPbWGKPSppYv8ZSjSLHCzbeKA1HYuwsOVfOJn389TO7sYAV+AcKQW/xNg2uG/C2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764595535; c=relaxed/simple;
	bh=sJExTUbJidl8r24l5M+JYo7E2xb5R4+Oqfz/PfooY8g=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=Y+HaXJnKOxR/EVsd4OcNw23QcgT6r1azNIamSm+skPpTgfAkjZ1njx9ViXwSZOig2m8EqQ2Kbu9HAYPbDVVgh0G6+itcwzyrt0OeqVc6Oqg8PSq2D0Bv76pY4KzeWKvxfPSsG5wc0fdQJNt3wK5K2eJaguVTX/NKjkrDLlGlNDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PxlR+Ilr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PxlR+Ilr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764595531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1e3FaU1cDXTnLIRcihA3zwmvx0iyBQUKIPR8Yt5LULg=;
	b=PxlR+IlrlJiIlrRpV1oDoAoAoctGcsPVPOmfAyBvxnJEOsJNK1Q5YJn5DcUMfvJf1/v3UL
	s7hUdTFYv7IwYyFPBfI48B0+yJD7npEx/Vue0GH4yZOzS5Cgr7brLEzOevwPCKDrFP97QO
	d0N0I5d5bkqcwAPLSGgFlOCVNIzRhuY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-jSU61sI5NsSf3J579WYf2A-1; Mon,
 01 Dec 2025 08:25:30 -0500
X-MC-Unique: jSU61sI5NsSf3J579WYf2A-1
X-Mimecast-MFC-AGG-ID: jSU61sI5NsSf3J579WYf2A_1764595529
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3B821800EF6;
	Mon,  1 Dec 2025 13:25:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E607819560B2;
	Mon,  1 Dec 2025 13:25:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Paulo Alcantara <pc@manguebit.org>,
    Enzo Matsumiya <ematsumiya@suse.de>
cc: Steve French <sfrench@samba.org>,
    David Howells <dhowells@redhat.com>,
    Shyam Prasad N <sprasad@microsoft.com>,
    Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Can we sort out the prototypes within the cifs headers?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1430100.1764595523.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 01 Dec 2025 13:25:23 +0000
Message-ID: <1430101.1764595523@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Paulo, Enzo, et al.,

You may have seen my patch:

	https://lore.kernel.org/linux-cifs/20251124124251.3565566-4-dhowells@redh=
at.com/T/#u

to sort out the cifs header file prototypes, which are a bit of a mess: so=
me
seem to have been placed haphazardly in the headers, some have unnamed
arguments and also sometimes the names in the .h and the .c don't match.

Now Steve specifically namechecked you two as this will affect the backpor=
ting
of patches.  Whilst this only affects the prototypes in the headers and no=
t
the implementations in C files, it does cause chunks of the headers to mov=
e
around.

Can we agree on at least a subset of the cleanups to be made?  In order of
increasing conflictiveness, I have:

 (1) Remove 'extern'.  cifs has a mix of externed and non-externed, but th=
e
     documented approach is to get rid of externs on prototypes.

 (2) (Re)name the arguments in the prototypes to be the same as in the
     implementations.

 (3) Adjust the layout of each prototype to match the implementation, just
     with a semicolon on the end.  My script partially does this, but move=
s
     the return type onto the same line as the function name.

 (4) Move SMB1-specific functions out to smb1proto.h.  Move SMB2/3-specifi=
c
     functions out to smb2proto.h.

 (5) Divide the lists of prototypes (particularly the massive one in
     cifsproto.h) up into blocks according to which .c file contains the
     implementation and preface each block with a comment that indicates t=
he
     name of the relevant .c file.

     The comment could then be used as a key for the script to maintain th=
e
     division in future.

 (6) Sort each block by position in the .c file to make it easier to maint=
ain
     them.

A hybrid approach is also possible, where we run the script to do the basi=
c
sorting and then manually correct the output.

David

