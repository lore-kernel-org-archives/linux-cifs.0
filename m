Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62E21FDD
	for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 20:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548730; cv=none; b=phq9/PPogXGTMKeY+Oq8KjU8vw+WasLn+c+5wqt5FyFFDk7z2KghZIyDX/IIIZ8l0zJwrzHSut44ICPQcvFn24b3/Ky2zVOg5Naet9QhSRTcK3tCpUE1CInlclr2kyr+GGs9x2DYJxeHmB09RgyPvTpxjCWo83/wbLo5Rhz9iyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548730; c=relaxed/simple;
	bh=/nE7ce9RnhZqaBcTRXozKel7GBqLy8Vpb/7yhHk5IyM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ObnikXz0D8NoBpNKgGy4esxvvzWUEMEdG5lv0Z+qGpJHDU096nJEqa8ZfZTmB/+Ppe+B7DYW0LNjQGlFMd9xmCwDkUq4crhR4UdhCl8VFtzUJp9a0o6mxmK50j/wrufHAr9gfyovKtXfZBgROdTN8Qb5BzewDpyerXToXolraHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MIfyifTC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MIfyifTC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=/6qw7UXvIeheSrNYve+OT2MBciJ0q6Owf7qjCi5txnA=; b=MIfyifTChNv3oQ017D6HlNu0Xa
	diTvBZzZHEx7IqrGBiCg6YL9ho05pFbfQMtn1nXgrqgLaN20Tkkgh/bQ1dNvFbfSIV1WxjWdSyMbi
	Cz47XjKA4PkKHxZ6zAT27RsRyTCg1ohoAh56X2BssyqfdvspUPfjSdIPjPTfoTmQwPj2wOhbF86Kl
	AWnlKtY9VcP/meVdWM4UdfpK9F05/UcyJheaW9GoM8ciHeHvpaBje983qt4MEZznzcm8c0IpjbCAk
	3OClp41lwlYe2JsoG8BgfpO3rJTLlPpE9fl9mTG+4Ji2sHzVNeHAc3TcIqAGL3zN1q9oJpzPyPSwF
	DCcj4c5RF3ZFTQqlTMzheGLyxqNAtOfk1w5iErdyCFOzJlIrjHqiGWzJm6ijItMypxVbtvFYIh8ic
	FjNh6oV5B3yZAOuGoK/9UxJj9Lbnd4eX//fx/KMklKS8mnyMGnbecTSb4lsiFIxm9DN6QzGFjH1cH
	1HskZnqBw5qW7IV/F3y/x6hZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uo6Q2-003WkK-0a;
	Mon, 18 Aug 2025 20:25:26 +0000
Message-ID: <c2d9d516-d203-44ff-946d-b4833019bfd5@samba.org>
Date: Mon, 18 Aug 2025 22:25:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 Samba Technical <samba-technical@lists.samba.org>
From: Stefan Metzmacher <metze@samba.org>
Subject: Current state of smbdirect patches
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm at the point where server/transport_rdma.c only has there
local structures:

struct smb_direct_device {
         struct ib_device        *ib_dev;
         struct list_head        list;
};

static struct smb_direct_listener {
         struct rdma_cm_id       *cm_id;
} smb_direct_listener;

struct smb_direct_transport {
         struct ksmbd_transport  transport;

         struct smbdirect_socket socket;
};

All others are moved to smbdirect_socket.h.

For the client I'm almost there I just need to
finish the move of struct smbd_mr.

Should I post all patches including the ones already in for-next and ksmbd-for-next-next?
But resorted, first all fs/smb/common/smbdirect/ patches, then
all fs/smb/client patches and finally all fs/smb/server patches.

Maybe we want a smbdirect-for-next branch, which could be a shared ground for
for-next (client) and ksmbd-for-next[-next] (server)?

So how should I post what I have?

metze

