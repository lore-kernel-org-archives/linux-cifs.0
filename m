Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0CF23ABB9
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 20:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781209013; cv=none; b=r9f7aIxc2OCC6bqb09poisy7FrWaaKKm2kfZ9xXpo+KdwPZbArvB/9IMHDI+L4AeSzs7OgwS42K7QpC1PuPvhoiw5jLTmHJYGLt8/RNuc5MTaJT/zYyfvtAmDgwPQe6Qp06KTJv5upI9OeJDaz4NX5SJkG/Vr5tmi0CJN+hllBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781209013; c=relaxed/simple;
	bh=NMkbh057J24aHDqsYzx2ibh/YDUpnvQPkOdEgVtPwu0=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=WwjC6eoCbpj2k3j6eKKfByaIKgkxFK/A+jmK7/VwyWKWyhySZKl/QhIrAwIzhkoklooT511ug8iS9GLkkFLr42WTh9pn92tn+kyW4DmLaJq0Fq83B7jvhj9oXa6klGDffcSJZKoM04ho/s0dHWRznWSoi0fdDogRfH5GU7In9mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=GhWygI3a; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="GhWygI3a"
X-KPN-MessageId: 76975509-65d2-11f1-beab-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.189])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 76975509-65d2-11f1-beab-005056992ed3;
	Thu, 11 Jun 2026 22:16:43 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 76ae9011-65d2-11f1-b5d6-0050569981f5;
	Thu, 11 Jun 2026 22:16:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=sajW0Ch0nksNTuYo29HQejiwyBpSZF5Jwb7Qzw+MhCg=;
	b=GhWygI3aCB7U3hjNn8LzubTyr9qETscOX1zIeMkA0Ps8WhuIA7k9xX87UmH96vaXkn7WBR/DZw08z
	 JK0ND4zQs612ubVOpGVV0otOGV9YyrGqeXV1fpiVP6cmLg4FaP51LM9fja1VwaNnME+4YyTos4Xmii
	 DqXj4Dp+YKX6oR7LPOPG4QL5gwGrQuN60kfSihMsJjT+uqZvIx78DQiyviVbCFriBRgAEfMW2Ieic7
	 EuR3oFy6T09ZQrm8ssdYnQShU9efUL5xXY6xPWHTdaUajGPf4db4vgvi3QBxyCb9am7LO2xmUCVKb+
	 CmgsEEUH1dlPCUhsIEXmjlARRx6r3Lg==
X-KPN-MID: 33|jZCmO+gn4/esF2b7pLUfZ4erNaLOc0YSFBZlrZoADDuOhjg6mbxeclqfb0ZGfJ0
 7eXRa7HF65m+3GT2V3HWG1xynghsX2xaLv1gX3NnoOzo=
X-CMASSUN: 33|92ofUAkRi0LEhLoamGqCiyViLemvDyOs3FJnkyP44/MzjDlekEjwkC6Ic7VddV+
 cmepqVAIbjsTt6iy/c3XmyQ==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh04 (cpxoxapps-mh04.personalcloud.so.kpn.org [10.128.135.210])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 769d33bb-65d2-11f1-b8d7-005056995d6c;
	Thu, 11 Jun 2026 22:16:43 +0200 (CEST)
Date: Thu, 11 Jun 2026 22:16:43 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>,
	NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <794378689.1433974.1781209003271@kpc.webmail.kpnmail.nl>
In-Reply-To: <20260611163736.GM2636677@ZenIV>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
 <20260611163736.GM2636677@ZenIV>
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal


> Op 11-06-2026 18:37 CEST schreef Al Viro <viro@zeniv.linux.org.uk>:
> 
> There's a missing bit here: what's the point?

To clean up a bit ahead of O_CREAT|O_DIRECTORY. Specifically, in lookup_open()
we need to replace the vfs_prepare_mode() with something that also handles dirs.
I don't really want to push the odd

    mode = vfs_prepare_mode(idmap, dir, mode, S_IRWXUGO | S_ISVTX, 0);

further into that code, and neither do I want this to be different from the
regular vfs_mkdir() path. We can then also match on S_IFMT in may_o_create(),
instead of passing a bool to signal whether we are creating a dir (and assuming
0 means a dir is really ugly).

This was discussed a bit in an rfc patch for O_CREAT|O_DIRECTORY, and Christian
said when he wrote that comment he "might've been overly cautious"[1]

I should have added this explanation to the commit message, you are right about
that. Thanks for pointing that out.

Best,
Jori.

[1]: https://lore.kernel.org/linux-fsdevel/20260527-fotowettbewerb-abwinken-einfach-83db3411945b@brauner/
