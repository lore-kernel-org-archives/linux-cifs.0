Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718C44FECF6;
	Fri, 11 Sep 2026 19:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789154880; cv=none; b=XNlQyebS8cjLLtMwPX2Od3ETgsc2cd0G15anjBV4L0zPFfiC2fW64hJeHZyf1LFSRemzbGPX1KylAL/WgXNn64v4b2GjTM5DcTgOscFqKNMGbFoaiswyLdVajTbjbQYQB2nZd/aJoi9/QzU0SkS+AqdJdfc+9tRbdAevVBWa0hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789154880; c=relaxed/simple;
	bh=KpDrJISlaF6H/M0MMFyA0RGb7eh15mdVcRTNvu1Wy5U=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NJAN93pls5hf3/3d6rnHp6sgjk22UuhfjUSzNyAwj3VVGZpJRFJx2N83uWS/ASKpNijpqbquAVQ9GlK0FUYmLTrSnzzU41qjvH1D/+iQzl3kQpW3BRK/2kmTp7ayAES2GesxEihA5WJqOYVneZ7BnIQrpVe7iQnHZ+/RPcxrRu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=lEbbRtOo; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="lEbbRtOo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=KpDrJISlaF6H/M0MMFyA0RGb7eh15mdVcRTNvu1Wy5U=; b=lEbbRtOo45j4MXVpsX4v4PWFoI
	CuKF9lYGgjtBd9tsOVTinG8ncuzVQ/6stZDO+GDk6c6kD2b2RUA2oF6DB9hJytT/aSkEU4bKuEOKX
	bJOkPaE9X7AJu3g20w0HqJZYqGAfJ9n6kRHeOqy/k0qUWUc3ajEJAm5waR0NxRyZoEOmJgqZdirZL
	Ir6VYWVFL+og9yQ+JJIKQCH66LBnDWStm0JOlteM/JBv/TDBSfxdg0M2BVIUIZv2p+zX053976Fpd
	vt3pxdwE4ObXzYhSC3LRSIz8F9EDs0MSfTUoxGQA/AhOr8XWJmfy01kYiMxVbX3XfZ+qNaTgU0AIt
	QKHXlksQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x56uV-00000001Ek3-27YU;
	Fri, 11 Sep 2026 16:27:43 -0300
Message-ID: <35fa98de2def19bee8e0bdc1e82d83e5@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>, Namjae
 Jeon
 <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 =?utf-8?B?SsOpcsOpbXk=?= Jean
 <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: Re: [PATCH] smb: client: validate absolute native symlink targets
 before NT fixups
In-Reply-To: <20260910183742.4029092-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260910183742.4029092-2-Jeremy.Jean@oss.cyber.gouv.fr>
Date: Fri, 11 Sep 2026 16:27:43 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr> writes:

> With symlinkroot unset, an absolute target is copied without conversion
> to an NT drive path. Later code still assumes an NT prefix is present
> when modifying the target and calculating the print name length.
>
> For "/ab", this causes two failures: sym[5] and path[5] are written
> past their allocations, and plen -=3D 2 * poff subtracts an assumed
> 8-byte prefix from a 6-byte UTF-16 target, wrapping u16 plen to 65534.
> That underflow causes another overflow: memcpy() copies 65534 bytes
> into a 24-byte buffer. A user with write access to a mounted share
> can trigger these bugs with default settings.
>
> Validate the NT drive prefix, including an ASCII drive letter, before
> accessing fixed offsets or subtracting the prefix length.
> ...

Applied.
