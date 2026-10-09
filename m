Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09C54E66A7
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557423; cv=none; b=bBv231grmsgnY6XCU0S7bK4rpsp/NYjknLmfGRZDaVYsW8mRT8x7BxQQ+GP4hm/gVT2KNqM2CQkxK2FkakauuD7P4CBiojrCpa6q+SlEbWfEUsN/o9F43voS/qn7iZEKicaCqho2V/a0XM8C6Gg9sewNyi9JvditxLxBc3uo5OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557423; c=relaxed/simple;
	bh=QMBBcDwgjsDjyl3EBe3JFAp/DeQlExENh9tN3Jkup4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C3fHO+mTk4G4ZBenP+7gtZMSzFaSxQx5ha+Eb2oJpGn/QeaNzfGqXtJqcFlEjCrDpjnjFYnq6hHZ5O0GE1d+UZh1VRonWz6/bv+wpXZEYSIbSUl5FH8BZaxl/DUN5TecxwaWmu+MEXzMYo/Xhe6XdP9wMuqmmvp7bZ44UxCPu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpHOh6jH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KpBa0oqT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpHOh6jH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KpBa0oqT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791557419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=denjLYVgwbF9iEIwmMqmhaeRtlsrnClW1EGbNR+b3NA=;
	b=CpHOh6jHykJJlPnf7tOaBKRZX/GfZAzyBSIAOgMjGdSqaOhzDAEH0/QikgWnOihWa2XVzq
	Oa1gUDsXDpWoIj5MsM1cHEpT28U7DQCcoVjKWo02d4lCgI9FHOsht+92b+q+r92r/KVLHH
	BY5+FvpEOYt1r6O1aPK5LKefH2Tx8WQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-S2Ab2C8VMby8H-8RqOKkww-1; Fri, 9 Oct 2026 14:50:16 +0000
X-MC-Unique: S2Ab2C8VMby8H-8RqOKkww-1
X-Mimecast-MFC-AGG-ID: S2Ab2C8VMby8H-8RqOKkww_1791557416
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-917a2de2cc1so90825916d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 07:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791557416; x=1792162216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=denjLYVgwbF9iEIwmMqmhaeRtlsrnClW1EGbNR+b3NA=;
        b=KpBa0oqTj9m5sD41mCfx7jGDTOnLdHFeZUPB67cJE+y/DXq5ITUrYNE2jmaIzF2sAS
         yn47mDu9Scz+ie+NxBLJ7INu2cefHnqmJ8uhblfw1GnT6zke16lQ0RA2qj0st6zY96Mi
         8RVokFXlBz0vU6x5KUvj4UVBtLyHebY3TvE2dH37638/HZyeb3DFgV2MsxQkc7Ag15KX
         vptR0DP2JMZ6ocV7Nq8R1pdlyy5goDIFUinfqmMeWF8Ze1RQ6vYSiZyDKKqy62/XzCKz
         LbBFBEHo+E2N34l6FqYzZZ1tpEr5hmUlrnFFOPJLNvUKl+T4mkV6HozQ9+q3gFjjLHo5
         Wmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791557416; x=1792162216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=denjLYVgwbF9iEIwmMqmhaeRtlsrnClW1EGbNR+b3NA=;
        b=yOkl24u20N9A20Y5C+gZOvNexoYmHI+/cU42mwGLgH4fas3Xgp1bundEQBUgp73Xoc
         mVnJY8+IyN77kH5UX4o/ZHAWwCiO1y+kO0S6kbkeMR05ZxNLDaHBFxCWJeIKz3lJ/9LW
         3Jv0CBhhMTZSDt9nopeZqvQCPQn6Iip+QGs7akDRkGxLsS8ZQ3v/PynDdORYZO9SlPJu
         Oh946BIABdrOd9iDqX+qIg3M7TDOJd84jrSEoUYGomRKV7ThwhN86tA7HKz0VuTRkI87
         f1SO4H+DYrOIGPrHHZAjd8CXd0YHSuIDhGN+iCcUqVCj5+46dRuyfQU3Zledq5kSWdc5
         F05g==
X-Forwarded-Encrypted: i=1; AKwUvBzqWt3L/5fcS97Wfpp9ub81DcgiqAVVNPXJ4lnfsl83ZgE4gwJZeONChlB3DP6Vi4fX+XugidmpxqSe@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0f08DfAegH4ZqeZ+5r2tMkBSaZYHtqnQXY5ZFLBn/QLzWJLW0
	pK6vhhD17/9S0J2mie0Dfpzxi+JOUBNFBAQXBXBjFeCBralYgOJGo9HyQL6n3N75xR9VFaLUOKz
	ExbTB8DacPFedHPxMBz//ncwy0jMgpJ41Sr03VVVrI09mxzyR2rRMab1Isd6Gz4I=
X-Gm-Gg: AYBFou0osV3GMNKZ7ViJ7L2wXuYU1pDrVqHLsMq5AM//bPNIV177De0yqUGv/XIxMrQ
	swx4XJLU9+e+3Tt+JDUt2EwiAZ0Z4gHsKS1pYrtjd7ZnGABfaZUslT0ABqaLhO+Srpscz3io1XL
	sMsHf2lPUhr7KW8Omq/AFU1EV+7l6xU9E8BpAvt4tBcuBayGnhSkMk6sgb41N+q7dA7G+vSYvqh
	zEoBWu+iK81cmZEr1NO86hlX7Fav7D4mYaa+d0izseokuevThPBNAiaqOJHMNwVxOhJ4EXmr2+0
	dfWb5wwLHvLdpZP7O52aZZ2QCrynPJ6NFJra2I0FKc1jGC7iLq7fxMMpkgVQieVmllYI6x4KTG1
	OV5UPRQe8CnB+pjo0IGS69q+r8eJgfmCDEHNn3ZEo3DX3/2QKzjY3cA6pYIIn+KjYjO57omHwUA
	ZHsES9uKVLE84F2A==
X-Received: by 2002:ad4:5def:0:b0:91b:53e5:9263 with SMTP id 6a1803df08f44-91b55531337mr36208286d6.21.1791557415631;
        Fri, 09 Oct 2026 07:50:15 -0700 (PDT)
X-Received: by 2002:ad4:5def:0:b0:91b:53e5:9263 with SMTP id 6a1803df08f44-91b55531337mr36207516d6.21.1791557414875;
        Fri, 09 Oct 2026 07:50:14 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550dfb6csm20185456d6.45.2026.10.09.07.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 07:50:14 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	v9fs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: Re: [v3] fscache, cachefiles: Fix resize handling
Date: Fri,  9 Oct 2026 14:50:10 +0000
Message-Id: <20261009145010.2380147-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1091807.1791483394@warthog.procyon.org.uk>
References: <1091807.1791483394@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi David,

Reviewed this on your netfs-next-5 tree. The resize helper it changes is not in our testing branch.

For Ceph this is the right split. ceph_fill_file_size() stores the new i_size before __ceph_do_pending_vmtruncate() trims the page cache and the cookie, so the worker can no longer see that the file shrank. i_truncate_shrank records size < isize at the truncate_seq bump. Without that, a truncate that is still above the stale cache size takes the grow path and leaves the backing tail in place.

IMHO the same flag is right for the other filesystems. AFS, 9p, and cifs_resize_file_locked() still have the old size at the call, so shrank is a direct comparison. The grow paths pass false, collapse passes true, and cachefiles shortens only when the caller says the file shrank and the backing file is actually larger.

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

-- 
Alex Markuze

