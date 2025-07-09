Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544D42E2653;
	Wed,  9 Jul 2025 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072794; cv=none; b=Fu53fHlEaKR5PsWxLmwisENCo1TwDGJRQfBzuYg8zz4wPdI3GboNuThlszmeBPhJS+tjtLI1IKV6UM+Sf6E3fkcaXDe6DYJGvrf3m/j3HPmbPwLqEqupuJEiAhDDTvGoOsB6GpTuZ3x7iM/K75T6Ep3jqWvm8vK4L5CifzHT/BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072794; c=relaxed/simple;
	bh=jPRX4Sap/8GRTBZpWK9P9CBzfDmuRAsuRNhbipq4yfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IMPZcejOEycyOmu4uDUGoRmopL28Smc204lEXbX27vq1XcSmrLeLiJZaekgK+/jG18dVmvodKFsYydrYOYKtIgW3txWVoRfiUgPZGRWm5JvMu8D+Tmd04pprUodzVerRewhNIkE47zwLelV3JCttIvfvZuHgb7X6xp2ZLF34TAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A5KztfGL; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A5KztfGL"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3df303e45d3so17398135ab.0;
        Wed, 09 Jul 2025 07:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752072791; x=1752677591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ce1CmkYRBQVzTjh/d+4qI/RIXf7zJn+MvFyGg8G0AGA=;
        b=A5KztfGLHt3lYQk6fZpo/B0wtwT9a9HY8QCawAVRG+nlnCxbzhvo9eW+qTpDBsaCjy
         h8UHVeSzbILiR1mO1HULmkVQZYhYpIlUGpDF5LGgvEsLu0VabYJaKlnWfH7ZDIDu5tc2
         sgooCnbx2aKx9wvKMLUF8CR7evLmdhDX4HVQE+UuCQo+Z9GCX+Ba7ImFRv2ReZYKl9C/
         l5pJIJ5C+FMA44bN9lJ6KRce8uuGMFPxELU72kpQ9jWnz3RLKl21eUvz5RdMqsUhwGqb
         DfpD9hO0cox1CJqwY2VImf3Zj82ui7jLKmBFQ4qaiOFExL9qcTqfgrfOj2HQzupFGbhJ
         oJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752072791; x=1752677591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ce1CmkYRBQVzTjh/d+4qI/RIXf7zJn+MvFyGg8G0AGA=;
        b=QSUcXUXfhEHu5nXsJtTWwov7jrlG+DzpT6Bct9CBj3wjOQXeH1ymjFG/WccvcIL86v
         MPee5gciLQWAE6NKoNTBw3uT1rDRkH4iyqwXKm6faEvAXVjvMOd6iZbQf0nvmmvps59r
         vZzwKxY2vEaFpcXA3HUNJ9yVDgAvEdMkdpiGbtEckMTIJpv3waJx8yVMaC+Oe/DdiTvk
         l+iIjnvMHzCtwJZEUmHpC13mxVR0xRQA3HyaGE57vfztfohmBe8oumPgmBqq/wQbAS33
         lZCbfNeQJxFUqkMJkii9ucUzl+OnvamRhbA9pQFm2ImYHLro/s8xQveLjuwTLUaE3yX1
         rigQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiC2osKVDhz9UUKE6Cgigm9FjsVALJYor/CILyoBgAt9pF8vZ1FSWvuvHbDFiXWjU9vOq4bdqHjQt1@vger.kernel.org
X-Gm-Message-State: AOJu0YzoZsKjZ7BZPvpm0fwSTYgSAQeBsMwi3zaomgMMNCKXY+5GV+oK
	id8pMNPjWZrE9ZFHKjcSPGkF3Cxpwh19ccb5UE3YdpOpTuQSpJYRunN1sID4ilsJRO++nrzmEsw
	c+nr3/gzjhihBUWKcesf5zIt61pLOGPM=
X-Gm-Gg: ASbGnctzusnUKeAGMcEDIth7lQ59ML1Jk1g5ktZVI3wLt8mNQjlaE9zeHoWFLwLcFtT
	IqgiNbmNQovPjQRX5iB4sxZokUXYOczAuOImseCYxa4GG5GTA57WU7ARLwyoHjLH1C2DMOcQoNb
	Gi/pIKBVndZvaOZR72Z3thpDgBnV3mfE3ml+x7KWp++ZofBEBzmjlip5xrOCl52rnluY5lFm1Qu
	Z9WVg==
X-Google-Smtp-Source: AGHT+IEz2E0d+HK64OuD1uw+y2e1HeVW68ZVG5JBVhNwb1az7fykUxkIZwtwiEUda3UIVaFQUBIAYtXACT2l3y0Ymc4=
X-Received: by 2002:a05:6e02:1c2a:b0:3dc:8b57:b76c with SMTP id
 e9e14a558f8ab-3e16702baa3mr24944315ab.9.1752072791204; Wed, 09 Jul 2025
 07:53:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1751743914.git.lucien.xin@gmail.com> <74b62316e4a265bf2e5c0b3cf7061b4a6fde68b1.1751743914.git.lucien.xin@gmail.com>
 <20250708073427.6ba38b45@kernel.org>
In-Reply-To: <20250708073427.6ba38b45@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 9 Jul 2025 10:52:59 -0400
X-Gm-Features: Ac12FXw4T8WkSPuPx8iY7P1m_t_n5Fw0GYfKAJYEdZpzrCcph37m-pIeEwqF1s0
Message-ID: <CADvbK_e4XvwVcGSyu64Q0bhfXvn0onnwhOvreDt=r1jYYFmU2w@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] quic: provide quic.h header files for
 kernel and userspace
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 10:34=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Sat,  5 Jul 2025 15:31:44 -0400 Xin Long wrote:
> > This commit adds quic.h to include/uapi/linux, providing the necessary
> > definitions for the QUIC socket API. Exporting this header allows both
> > user space applications and kernel subsystems to access QUIC-related
> > control messages, socket options, and event/notification interfaces.
> >
> > Since kernel_get/setsockopt() is no longer available to kernel consumer=
s,
> > a corresponding internal header, include/linux/quic.h, is added. This
> > provides kernel subsystems with the necessary declarations to handle
> > QUIC socket options directly.
> >
> > Detailed descriptions of these structures are available in [1], and wil=
l
> > be also provided when adding corresponding socket interfaces in the
> > later patches.
>
> Warning: net/quic/socket.c:142 No description found for return value of '=
quic_kernel_setsockopt'
> Warning: net/quic/socket.c:175 No description found for return value of '=
quic_kernel_getsockopt'
It seems kernel-doc only recognizes "Return:", I will replace "Return
values:" with it.

Thanks.
