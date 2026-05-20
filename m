Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8652A31BCAE
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268376; cv=none; b=uPLJFJiG0S3pYOk9HuBW606KNIfMWg6pjL6hMDKLGKqlh/baWtSy0C8VXF/e+cDDyVvF8y2KSUtbHd+vY0xmw7HLF4SY3QTC0xCI/mJM51QmXK6o5LN0k0jGd3ZDARbwKEA/l9gUMfGbOKY7PLWogDJv7ZQ9YIcz9m6DtHx0vME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268376; c=relaxed/simple;
	bh=loJEUUn0Fg6X5xQlHSpuqVmad2nLqKTouOwsQXZWUb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VaT7dfjXDze7oHJIgBsx7moYGalXYMGBTYhs5S9TQh4Yi/a1mhXr0OVp9lMirjPVLvKcjzo0ez/EoT+LH7V+KR11kvffR/Hx8kY+EJnl51JxhX6re/AoXstM9360lt7PjXpvEqu4mWQ8sEvpFe2yi+owu7z28Nzie7GnZ81N6Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZpEU1bCm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZpEU1bCm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=loJEUUn0Fg6X5xQlHSpuqVmad2nLqKTouOwsQXZWUb0=; b=ZpEU1bCmFVB5TztnLRk3QbVCFj
	kdlgOpYgtx9yI8bBDE/oBAScjokfD47e66c2SjBYT9LE7nlz+MQ/U/FSwswCj+EQ7+leq13aE2utK
	Ps5rLs4eTzDzV/TvOaY4ewi2PSHDXhNg1KQarfXZa+UnyDnxpqtub4LFs8iDnw5HcK0/uKhiuJX0T
	9hgp2SzKaNIPArA1deQJfT0bO/p0CSewBU+0IYz9MDnkBb8EKf7wzd8UEpdye3wbVGMiwpx4OOaLZ
	1cqLo0IZ9SLUo92o1fgWOWRgomMKO6yaHtkyoUk/GPg5uX9fZ8tIpGPNYmPCSpxkTO89ALReuA9i4
	PAEF3/2fFZAWy2iQDrg4JdX7FoGL2qDi82OvTnRlMJVN6zLGTwhzLhH2LSHuddQv4UpbA2tiilqtS
	BvWFYr8ZIPz8eXokao8fEA1A5iMm+gs4TX0J157DRQILmxGA3jdpiS3/V+1AF30d5n010KAntKK8S
	wqiI+S7yxDypZz+dE9sMWDWV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wPcyr-0000000ALt3-1Oxp;
	Wed, 20 May 2026 09:12:45 +0000
Message-ID: <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
Date: Wed, 20 May 2026 11:12:44 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
 Samba Technical <samba-technical@lists.samba.org>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> I added cancel notify support to smbclient of Samba to make it easier to debug the ksmbd notify I am currently developing.

Have you tried to run the smb2.notify test of smbtorture?

metze
