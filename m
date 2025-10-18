Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1CE1E9906;
	Sat, 18 Oct 2025 18:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760812963; cv=none; b=FOw734M2ugepDcy8BYkgWu0BSdIZy2ExjKkclL6RSTlql3ZJGKAKYCZf0VHpa0aiYM3hZPCM3R/S6NUU+IxO7IY7PeD08WeNZv1vPFaA/uBKfXPPwOAGuou4hbGRpTNLhwfy1o6guY7N6vsRwtj3504fTJyE0x0e51BQoRBdTks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760812963; c=relaxed/simple;
	bh=6fpb0nwTttUDBQPYQISAGcgKDy1G4Hi4Cf6QVh8fq18=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=D33KfyUQOTsUrXku9bFDGlNdSVKCbDVpgfMf6u0OrMB4wHwUcrnePV8pP5YhqZyPPNd0ZW0z3iUSIYZ0PP/VIS800BbbGjeP6NEo4bsBaHkuUDUju5CMq5JDKeN3j5hyjFiTBUnO4wWMEDEsnzCYc3EmUlzh27w3jhhGacZ9sjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=j5IHt1vC; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="j5IHt1vC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760812939; x=1761417739; i=markus.elfring@web.de;
	bh=6fpb0nwTttUDBQPYQISAGcgKDy1G4Hi4Cf6QVh8fq18=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=j5IHt1vCIQM8ZY5WGQeVk1OsCj/d6XSZhuGp/QPvRHCLbhcuAiUO1XeHOLbaDcg3
	 cEuAthnwEzdclpLeaoIgtPyzSY/RleSkC8QuI5s4T/Dp3ZeVnj7OYPpEwqeJshRVO
	 9S3m9WpCZkTUgNLrPWrT+BMuU8SYC0rv5yamt28/4UxzWjkFi6JcAx1Pp2UFlDOqt
	 xw8xfbCR3Eja9TSwNhoi/9HQwqJIz/1rOECXEUcW5NEA+r01mEKmuQM+nl38cmaaj
	 XeZWtppLzp+zHIp1WIRgjUfbK1GXt/vQhHwsBLZQB8EI8fJRNITmkl4E7HTq1eQ6o
	 OlsIzHQuyNp42kZiBA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.233]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mi4yz-1uWA6U0mqv-00joyA; Sat, 18
 Oct 2025 20:42:19 +0200
Message-ID: <441b1b8f-5fcf-4908-aadc-2fc16f559fb0@web.de>
Date: Sat, 18 Oct 2025 20:42:16 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>,
 Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>
Cc: chenxiaosong.chenxiaosong@linux.dev, LKML <linux-kernel@vger.kernel.org>
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Subject: Re: [PATCH v2 0/6] smb/server: fix return values of
 smb2_0_server_cmds proc
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Xd+gYBBn0Lom1AodwHwy9FFinLJPuWcF+qXgHTzOcqFJlc9DKuy
 9yRnVW+nRwr0g1YyVWyE+D/A8OtOBv3Tf1rZ036TFbscWatRiGc2ZNEgVNPmx+S6gYVo6WY
 MAURRL9QKwB9R86Q/ySea4apEo7NkAoB5WNz6BUz9LGN3hlLTPI8o/xgFIVekESz9xuX8D5
 ZfePYSzoYj9eElZbcaC8Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uJRs+3aZtow=;oil6YLSNquBHDSxW2L2F5eiAorD
 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
 iDl54udpOQ/8bfKmcXoisT1qUni2Aijqjwg=

> These functions should return error code when an error occurs,
> then __process_request() will print the error messages.

You propose to correct some questionable implementation details.
How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.18-rc1#n605

Regards,
Markus
