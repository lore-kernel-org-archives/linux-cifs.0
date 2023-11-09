Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2862232C
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DcKUgNKo"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF99198
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 09:29:23 -0800 (PST)
Message-ID: <482ee449a063acf441b943346b85e2d0.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699550961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UlG1yfOKC057AfhXCFBaEX2L8Z1Zuj2OsLTQXBmgg4M=;
	b=DcKUgNKozr/Wj+mJ5HOEhyssMVdzzWEvC2kTw6C8z7oLVXS9OwqyTeEHruXzbNieN+HbYZ
	D5pho8T/QK+UMZlm5jUF9WWmfV+vuV4WJH5YpLKfxDrS7RG0iAAskYGY9EcPkGuoKy3YDb
	AOP/n1LH9Q6On153OaFPX5ESCUI8VMon1GwM+7HE9E6eIgcz/ouPDAMMvroro7O2/aEsbh
	f9C207HX2ox0t/WLZpUGE3vbP/btIvcLjLdA7y5bSdte6PSFqbFHgBt7b8FAsbTYAJ8K9b
	lMrWUo8QsnnUAKMe9tgQeyJKIbcK/MTvhrIztf4U7w7+h1d7QSkrR76FU74hzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699550961; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UlG1yfOKC057AfhXCFBaEX2L8Z1Zuj2OsLTQXBmgg4M=;
	b=KxgM6n7wcD9jLpVa83yPSCpSWPbfQxN0bUk9Fs74ExPchqAIbLN4uuwG7WjUy9UR0NGcPH
	jbRq6GVnstlrgh8L/Vz7H918S/S6L5305nSEpVDOZxopK27ba8Nwc8GXEZL//qGw4aAvXc
	rlJtN+ZZvH5tDaDgAOmZiCxr6UDyhvQV417M1sj3JSKGTC6wh2w/1Uuu2J6XRcYwNZ5JXr
	jTiAnkr5rOQwwBTbf/qa++iDxm9k1TgeBKHEFk/cx2f8TqrPdUe3OzylnPrjOLZhJ6XxWz
	C0RlfWqi+ZAaw+E5zkySO6fJuS9HNnhidVb/jEVgFou7hMwbzvBjwCQsd461GQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699550961; a=rsa-sha256;
	cv=none;
	b=Il5izdUgAqMIl4dr8u7ygA0NZgSC+cK+QZtus4bG04pP1iD9FwAg4Ya9P8tq80SdoqJ092
	7ipbnpWOGVFQtNufpuBeFB6clwKRBGpgiqxivInWSan3ETA/4jpveMtLvgw8VQueDS0dBD
	Uy7VSqIf1deDxI7aMQKmpCehx2XN6b/iQU6vB2dq034qZC3BcDK6Xs2LqP+ESWgji00+Dt
	gmJ0l6g7MiYNL8Z5E9hA4YF+Uhqo/59v/xELY9QHE3UMy9abvefJ895fLJri+0HWFntayH
	/i6wWiO4BZ2p7Lnqye1cHylU2rZx1pdZHRM9Dz14o/soOebcw7VIjBVdudHZgw==
From: Paulo Alcantara <pc@manguebit.com>
To: Eduard Bachmakov <e.bachmakov@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: Unexpected additional umh-based DNS lookup in 6.6.0
In-Reply-To: <CADCRUiNSk7b7jVQrYoD153UmaBdFzpcA1q3DvfwJcNC6Q=gy0w@mail.gmail.com>
References: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
 <d2c0c53db617b6d2f9b71e734b165b4b.pc@manguebit.com>
 <CADCRUiNSk7b7jVQrYoD153UmaBdFzpcA1q3DvfwJcNC6Q=gy0w@mail.gmail.com>
Date: Thu, 09 Nov 2023 14:29:18 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Eduard Bachmakov <e.bachmakov@gmail.com> writes:

> I don't see is_dfs_mount() being called so in my scenario we're simply
> relying on kzalloc initializing dfs_automount to false.

It's expected.  If your share is DFS and client finds a DFS link or
reparse mount point, the dentry set for automount will get mounted with
new fs context where where @dfs_automount will be set.
