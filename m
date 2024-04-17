Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0158F1420BB
	for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2024 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713364705; cv=none; b=Zri3zSl2on15TU2Gzua5TFL4UWBR6i5p2IEygkXaFchTIOZg6b4T6H2kmmvcueVqOl+Zr2UVXsUZI6bLSVuPoeIJeQ6pJ7dhEa7xKI+RT35nZ1mEmlDZ9VOHLMbgeugaF0XwRgJ2tuL+LkOwhapHSvMlT8SrRCABwNqISnhXa50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713364705; c=relaxed/simple;
	bh=KoYtxC55Ohj6Lf9NvLZyrFVpFV90+1Yse/ygPWxNqOY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=BESL2SFd/KQEFbs6vfsNOe6YGn9Qdfes2lVV3iGw7jRq1D79zn/iIHpX7Nt1swQ4Q6QFjGS9YrKUW2HcZg4kUbixDVO7PvSswpI0nlrbkO9ewR+1HA3so6xrR8XP6D0Gi2OLNyl/yMq2bLmJi3WQ4HwZEJuEr+w+oxyErbrtwCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DGwqZ3zG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DGwqZ3zG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713364703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zDU7e9X4ZusOLu7T2w8qLW/ur2IZiAOdvpcSe/vwEi0=;
	b=DGwqZ3zG3T2U5pmM5NMOJQR5yGMoRbh0pTqqBXCEIH089lddpZ7s8j2Q5QagktZPD3dYDQ
	gxxT0Vp8B4eX0fIgrk7sIn+hPwMSySiBWi1V4OkunAxGedxBlYjm685mlHbx/t45FZnly2
	IDQphDayxmd2glCtdCOH79oOG4TlpQI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-UL2Iqt2XMpycvVM7LVyaIA-1; Wed,
 17 Apr 2024 10:38:19 -0400
X-MC-Unique: UL2Iqt2XMpycvVM7LVyaIA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E2EC3C025A1;
	Wed, 17 Apr 2024 14:38:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5EC07492BD4;
	Wed, 17 Apr 2024 14:38:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1a94a15e6863d3844f0bcb58b7b1e17a@manguebit.com>
References: <1a94a15e6863d3844f0bcb58b7b1e17a@manguebit.com> <14e66691a65e3d05d3d8d50e74dfb366@manguebit.com> <3756406.1712244064@warthog.procyon.org.uk> <2713340.1713286722@warthog.procyon.org.uk>
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
Content-ID: <277919.1713364693.1@warthog.procyon.org.uk>
Date: Wed, 17 Apr 2024 15:38:13 +0100
Message-ID: <277920.1713364693@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Paulo Alcantara <pc@manguebit.com> wrote:

> Consider the following example where a tcon is reused from different
> CIFS superblocks:
> 
>   mount.cifs //srv/share /mnt/1 -o ${opts} # new super, new tcon
>   mount.cifs //srv/share/dir /mnt/2 -o ${opts} # new super, reused tcon
> 
> So, /mnt/1/dir/foo and /mnt/2/foo will lead to different inodes.
> 
> The two mounts are accessing the same tcon (\\srv\share) but the new
> superblock was created because the prefix path "\dir" didn't match in
> cifs_match_super().  Trust me, that's a very common scenario.

Why does it need to lead to a different superblock, assuming ${opts} is the
same in both cases?  Can we not do as NFS does and share the superblock,
walking during the mount process through the directory prefix to the root
object?

In other words, why does:

    mount.cifs //srv/share /mnt/1 -o ${opts}
    mount.cifs //srv/share/dir /mnt/2 -o ${opts}

give you a different result to:

    mount.cifs //srv/share /mnt/1 -o ${opts}
    mount --bind /mnt/1/dir /mnt/2

David

