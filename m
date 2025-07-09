Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488A122256F
	for <linux-cifs@vger.kernel.org>; Wed,  9 Jul 2025 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752087888; cv=none; b=XXqgR4/qsUGEVuPuqHxF6YyKjvjNaA9YtuGQ/kjsLYptLnPSwqQuEhGOWLoKFoYwhNEoi2fir6m+pf9spv4M9D5bqMAKj8jjtpAazD1hD+1EVgaNIZf9bD22fi3etClER1vIZw+n2rH8ypP8pTKHfBIHe7HdlHmWE1acs3qpzVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752087888; c=relaxed/simple;
	bh=oRGJxOoY6Sb9QvNhIjZ1ZJhSnfSKCQdsXzj4pLtR8xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IFpdQNqOOUX+LhbD/VhU4PwJgRK/t+yczcZNN+cBY2DuhXRO9bheYM7VOuTV6+BjPjEw1QOFgzl82HHvoF5qsjRapU6OsLlOtraMrvUbb75lcIz4wP1052v0IWan7hIfHEGuPHfTb9M8wIZuAUQGhj7GX7vS7LUi5PSorP639CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gNSh2cAx; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gNSh2cAx"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6077dea37easo216740a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 09 Jul 2025 12:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1752087885; x=1752692685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oMoCHTAV5NeIpZMq+DMEKC+TktfxuQeI3NG81ytBeE=;
        b=gNSh2cAxDTBJoHztwizWyZZ3DiFKTi3wxKyznQsDnWmd1QbZGN06zsxFOINFhEp7IB
         yfLbtqYSVkGMDhyxZGxjcQN0jFYGzFPHVc2AZqXty9tL0Ju71UroMih9Mr3iu6qqV7nj
         lw3c1trpU/sgXaZdW46x5q3VycvC+Kx/pxnQQXN9w6q3xMS7sKadXvuhVHVnzfWr63rJ
         u3NymWMMO1a7A8hAtX4WzUdkDKBocrk80U9+CLlbQYfVpTVOE9lLlTSmGtusmKB//WrA
         AnSkmEGx+FU8/5DPnl1aVOIkMS+Pl+t1jRpA/y/1wOVURm5tvoZL7W7LiTNKp7/jsU5m
         hanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752087885; x=1752692685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3oMoCHTAV5NeIpZMq+DMEKC+TktfxuQeI3NG81ytBeE=;
        b=Vul3DpG+xXmn/XdziiWso6ipFNDI68+WX7SdHdg9AOuGQavLeAVdgdNILqZ5Kh4c1p
         kLn5BH3/8YRmpcP0ZckbyGVq+BzSiutgSILmaGPIc+2U5H1nKKR1LD7UYOqoYDpYFTW0
         0hjm8MkqWdBq9MKer4sZNkq3ExlIFH6pSk8O3AoZHiqUU5I6mXAYHRw0Nfdd7E46eT3b
         34EvCpyiuQVR1pXshi8GZ+IrcD+AFxW+Ou3RwbSkYQ3qc5+oVMNIwPEgY+yEh7EURxaf
         cLqCyU1ZQKMfR46zGRLHh7bsPNKZMQVzr0jxbP4apa5K63mOR7zymv+EJVFPwCsuXV41
         S1yw==
X-Forwarded-Encrypted: i=1; AJvYcCXQjl2DxOOkjnQp3pZ1iHcfDmoYAFV5XGuuHuoU0r2FiQHtXP4SIaF1qLDcdt00XJfHjxvtb1XQZFDp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2qojMfVihcyEZzJDDR419I67/tIzv1wTW7aVqjoB8w7/VGJZU
	fyinje7zn9qBUThusDa3znpSSc8r2Z9XQfSx2oHXU84NHRvtTLePbvq7qMfBfzjF/XrmgIjoMGn
	FHKiSM4UfM+wDxFsH/gximoIObxrMztmKbAMzp0ioCg==
X-Gm-Gg: ASbGnctAMlpIeNFxukz5FS4JUmXNJ6FjjMmZv9+ijU1PPe3WjHzICfduKWYxZolQLdG
	KLeo8ZhGMZB6M2IGWN/NDgMu+r6uRB4QRIHvt+jHUTQvctJ9yAG24zsP6lNqxJ7x/SncLumM5dx
	wl2ezUrqcuFB0hsdSpkwPjJOzgdpJW7boNClLcMnVhQnfl27sKGqGW0BN30e84zdiUfv0MmpAPu
	THq/V2X3A==
X-Google-Smtp-Source: AGHT+IHHFatUYcYPUIaiNLDpnLA9ZJlzI11FgOes6AgoJS9tnoz2rAKkdasV4aiimfA44DVTmm7JJ+DkAfN2TlJGB04=
X-Received: by 2002:a17:906:c116:b0:ade:450a:695a with SMTP id
 a640c23a62f3a-ae6cfbea8f3mr343461166b.61.1752087884599; Wed, 09 Jul 2025
 12:04:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250701163852.2171681-1-dhowells@redhat.com> <CAKPOu+8z_ijTLHdiCYGU_Uk7yYD=shxyGLwfe-L7AV3DhebS3w@mail.gmail.com>
 <2724318.1752066097@warthog.procyon.org.uk>
In-Reply-To: <2724318.1752066097@warthog.procyon.org.uk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 9 Jul 2025 21:04:31 +0200
X-Gm-Features: Ac12FXxBjj4Q8rQSAFMTvxq4Dux5Rk-Aycgaq2Qj_9vYK8pVlc0gHVgIsMegDWo
Message-ID: <CAKPOu+_ZXJqftqFj6fZ=hErPMOuEEtjhnQ3pxMr9OAtu+sw=KQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] netfs, cifs: Fixes to retry-related code
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, netfs@lists.linux.dev, linux-afs@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 3:01=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
> If you keep an eye on /proc/fs/netfs/requests you should be able to see a=
ny
> tasks in there that get stuck.  If one gets stuck, then:

After one got stuck, this is what I see in /proc/fs/netfs/requests:

REQUEST  OR REF FL ERR  OPS COVERAGE
=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D =3D=3D=3D =3D=3D =3D=3D=3D=3D =3D=3D=3D =3D=
=3D=3D=3D=3D=3D=3D=3D=3D
00000065 2C   2 80002020    0   0 @0000 0/0

> Looking in /proc/fs/netfs/requests, you should be able to see the debug I=
D of
> the stuck request.  If you can try grepping the trace log for that:
>
> grep "R=3D<8-digit-hex-id>" /sys/kernel/debug/tracing/trace

   kworker/u96:4-455     [008] ...1.   107.145222: netfs_sreq:
R=3D00000065[1] WRIT PREP  f=3D00 s=3D0 0/0 s=3D0 e=3D0
   kworker/u96:4-455     [008] ...1.   107.145292: netfs_sreq:
R=3D00000065[1] WRIT SUBMT f=3D100 s=3D0 0/29e1 s=3D0 e=3D0
   kworker/u96:4-455     [008] ...1.   107.145311: netfs_sreq:
R=3D00000065[1] WRIT CA-PR f=3D100 s=3D0 0/3000 s=3D0 e=3D0
   kworker/u96:4-455     [008] ...1.   107.145457: netfs_sreq:
R=3D00000065[1] WRIT CA-WR f=3D100 s=3D0 0/3000 s=3D0 e=3D0
     kworker/8:1-437     [008] ...1.   107.149530: netfs_sreq:
R=3D00000065[1] WRIT TERM  f=3D100 s=3D0 3000/3000 s=3D2 e=3D0
     kworker/8:1-437     [008] ...1.   107.149531: netfs_rreq:
R=3D00000065 2C WAKE-Q  f=3D80002020

I can reproduce this easily - it happens every time I log out of that
machine when bash tries to write the bash_history file - the write()
always gets stuck.

(The above was 6.15.5 plus all patches in this PR.)
