Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585D113F44A
	for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2024 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713361320; cv=none; b=qCuEnKcSXAOmLt20hvUCDMvpmy4oKu1z4TRqDPscGR5pCg8XtCK34xzqlLA958quFVEUGeQnObB31MiWpnKr/PQ4KHL/E+Ke3IlcoqVAk0+oVwGH5Rx5b6d618octK40jo+WrnT8xCP9YvPQRetmgRMR+glAg3xxsWf3xy3mFC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713361320; c=relaxed/simple;
	bh=HLLrrxZ3arOPYNguUU/bPL7+NzL4etri3swaPdLmmJk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=j853H00djkFJ6aEQI2nyfslXMr3HhImSax0pyC3+J+PuDvtqJO6gpR1KXLZY+gkDpPl8bo2zFQ9xEZ3YYCyMGdZjWMG0uM1yFX3D1teefd7fA1jPfBbJkjMX7BOsBbusO8V/NtROh2y5aqdztFb9gX+aejSrwqwPUaHvh9XnoL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahlOyYZq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahlOyYZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713361318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ngr4Dloj5AAsga8HGwFtYZk0llTT/AWVSmDZpIb9UnY=;
	b=ahlOyYZqvcAzXXi79Iv841pxZmdwyLzmx2iyGhHzRlkyGA+XdbKk4fF9nztKtlI+Hmd86/
	YNlrKyNGLiEl3LphHZRWS64aVl5DZgTCzv0WZx/ImSU0y6lQGkUUclVEdXWPruIgIFn8Qf
	9eBCGw/0ezEv/HsFSkTjB5GddeUo4ZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-YrR0vHqyPQOHTneSpW2ncA-1; Wed, 17 Apr 2024 09:41:56 -0400
X-MC-Unique: YrR0vHqyPQOHTneSpW2ncA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CA2B8011AF;
	Wed, 17 Apr 2024 13:41:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7059D492BC7;
	Wed, 17 Apr 2024 13:41:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <14e66691a65e3d05d3d8d50e74dfb366@manguebit.com>
References: <14e66691a65e3d05d3d8d50e74dfb366@manguebit.com> <3756406.1712244064@warthog.procyon.org.uk>
To: Paulo Alcantara <pc@manguebit.com>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix reacquisition of volume cookie on still-live connection
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <188148.1713361310.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Apr 2024 14:41:50 +0100
Message-ID: <188149.1713361310@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Paulo Alcantara <pc@manguebit.com> wrote:

> > [!] Note: Looking at cifs_mount_get_tcon(), a more general solution ma=
y
> > actually be required.  Reacquiring the volume cookie isn't the only th=
ing
> > that function does: it also partially reinitialises the tcon record wi=
thout
> > any locking - which may cause live filesystem ops already using the tc=
on
> > through a previous mount to malfunction.
> =

> Agreed.

Looking over the code again, I'm not sure whether is actually necessary - =
or
whether it is necessary and will be a bit nasty to implement as it will
require read locking also.

Firstly, reset_cifs_unix_caps() seems to re-set tcon->fsUnixInfo.Capabilit=
y
and tcon->unix_ext, which it would presumably set to the same things - whi=
ch
is probably fine.

However, cifs_qfs_tcon() makes RPC operations that reloads tcon->fsDevInfo=
 and
tcon->fsAttrInfo - both of which may be being accessed without locks.

smb2_qfs_tcon() and smb3_qfs_tcon() alters everything cifs_qfs_tcon() does=
,
plus a bunch of extra tcon members.  Can this locally cached information
change over time on the server whilst we have a connection to it?

David

