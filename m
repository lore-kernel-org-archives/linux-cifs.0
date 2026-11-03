Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676001;
	b=1Zt5JOnGGngepJa31MLV4kwJmPcjNkgnxzKczaZYifrR9uUd2R8u+Vezyv2YKAC7J4iH
	 s4PIjXXOWPcgCP8rqP4XwgdYeCEIOL58Bts+Ke3J9NIwNhPiU/eEOKqda9sl52dml3Ypw
	 jsWZiYJ99T195WCiN+vo/ABGLwr1Bbe7ds97QhU70h8cVn6anLEmvDBJPCRIHudq3JvOG
	 7TWC+PiDP18WfJhvA8SY5GQGfpv2xg6K18XpYOcvFwjUQ/+2DSYgRacXNmSPyD9//GGba
	 kt329EHr45PAb34BpZLmdkySMzze3i5vC4+hWYq4qm4adL9YDlKIxG/2W1j1Yzz8w+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676001;
	h=DMARC-Filter:Received:From:To:Cc:Date:Message-ID:Subject:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=oJMGcv9Tp+qvWDAs1MK8yVtD4KDhsi+aZLYZ0K0RUgw=;
	b=EzSr0i0IMOBJCra1M55QRnvqIt6IVEMnOi2GAQAdXeUQHfcT83Wxp908uYkK+cO6memY
	 kxpG+mwd10b7u/WjfcSZxxhK+No+nk84eWUoPw14Wfcz0YbbcWzSBCMFTQybg+V/xxbbo
	 x1DBE9pPh0434KTRX+/PouhEZ7kRkFLTNDUlKtUTdJ6U+etJLWZVbpdRZANTZF4VvFED9
	 g81SlssUz6VX0ycYAR8dLtuSJfr9g5arjLu+Gbj0XQ9855XSzSq9pGvfBC1FqX4bX368Y
	 nqUKddzsYalbIeYKpDtKm127duRSg+rSugMdo43lyhjqKIGtvxbTZ0V6W6sxNZ+VmLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=stu.pku.edu.cn;
	spf=pass smtp.mailfrom=stu.pku.edu.cn;
	dkim=pass header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=Alf1+nJs;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B1A606A32C;
	Tue,  3 Nov 2026 03:19:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52B1A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=Alf1+nJs
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (unknown [IPV6:2409:8a00:3c11:dbc0:2581:8e:ca0f:59ab])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5344a3159;
	Tue, 3 Nov 2026 11:19:55 +0800 (GMT+08:00)
From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
 Hyunchul Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Date: Tue, 03 Nov 2026 11:19:54 +0800
Message-ID: <179367599474.14819.859478551395391125@stu.pku.edu.cn>
Subject: Re: [PATCH v2] ksmbd: require NUL-terminated EA names
In-Reply-To: <c02b4586-522d-49bb-87d6-69277b45add3@chenxiaosong.com>
References: <179367391951.8187.2063761250230294066@stu.pku.edu.cn>
 <c02b4586-522d-49bb-87d6-69277b45add3@chenxiaosong.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-HM-Tid: 0aa19f6ba91303a2kunma4aa6ea610c5cb
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGEoZVkxLTBpOGUwZGE8eTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaS0tBSBhKSkEfGRhLQUlOQ0pBQx5BGBpLHUFOQh
	oZWVdZFhoPEhUdFFlBWU9LSFVKS0hKTE1DVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=Alf1+nJsTBwt3b7HXfz/bwJyXt/g2p0wetc8hbvsGY42feuYvNOP0i+otKB4N0MAxn64dUwoVvYySOli8ODXWQS2pc7x/JoQkitI67CiDcPqDKoWTuKVzq69UkJtSvgQ7Vk6Nln+lXHgR1koIV8CPVVE+5slsau64wLpNrbHrU0=; s=default; c=relaxed/relaxed; d=stu.pku.edu.cn; v=1;
	bh=oJMGcv9Tp+qvWDAs1MK8yVtD4KDhsi+aZLYZ0K0RUgw=;
	h=date:mime-version:subject:message-id:from;

Thanks. I will add:

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>

in the next revision.

Regards,
Yifan
