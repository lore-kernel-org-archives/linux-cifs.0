Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D038B283C83
	for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2026 08:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785746896; cv=none; b=re6vFhuqZz0skk0d3jwqkkgn10LefSG3MnAcsglfPipRTWtzPzRPjULzAKgR5r1zT5gXAXbrJKjK+ek2vxhRIcuZ0A28QRe5J5CheEyYwIccFGV1O6DlLPgkfNHPx4roTH3cw1WR0/UbqKK6UIttJu53A9GlQ0ZHxMuuKEYCErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785746896; c=relaxed/simple;
	bh=vmQIwZ78xLcr+m4GRvF0L3rqlL4HUbzKoLAzPb0dXT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Adv+DMx80GHezHVEk/4R32NMp02hpY1yZ54cgx/ohaFk6mPXISsFPWt4Wd5dPqrD5qaKOxcYn75Ej4/1QrOIEvvR4Qy4SyFMUg8nPo3o7RdsLp+QqWcJfOXIfElAXrdOJoyk72hEdJD+WCxBIG5pRG5QS6XhK1gYjuCIesq3WTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlNbRVPe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlNbRVPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633BD1F00A3E
	for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2026 08:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785746894;
	bh=9cy3OgJNhxGUKelGxftv9Ml2jZM9PDKUGlLGLz1zbfM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BlNbRVPedd1i0Ml77qFNdwbyjsUEPlRqruaDpROwoU5HYI4L6lZqI7KCsogQK7S1e
	 wJKVZS/LSa+sJIzRc2nsdbqRd0kxmiRkeqCwKoMNlas7FTrkoGKoU9Znsnmi3TLQAw
	 5VNjml+tG1MChl9HPJa6OioFX26WW9vXapwL/Vwoq5zzrqBXvoX73cSxdyqifopeKy
	 an471Sor38Pqb3wipDchCkeNYN1XzzMZ4s3A363WemPLeSfCDeAley57/7of3XXoAp
	 ecnI9LBlXVJ5Jgrkkc3/5g3f14BfGRufmiwkdDm7TZEZi33FRgy2zL4DA/T46Pd6oW
	 RPKloofvfRoaA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso371337466b.1
        for <linux-cifs@vger.kernel.org>; Mon, 03 Aug 2026 01:48:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq0NmqK+hzYVpjbVmywmtRIN+IRkN3KX437E2VKtP5eRtQN6H6YNprPcx8tXKWD0uNsLIjxbdj4p3xQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+9QAdZpIqcvZTHSIsY1zbBBxJad6dcaMCokc37wAffatIG/G4
	qXWmBe/NZRP1BrfTEZ0KeOIS+z+98n+3jHyohbgwuK3g/10tveOTcpHHv4BiGEQthZ3r/kUouby
	tqcxvc9osT3SHvs/kKQuSJHMw91JzFq8=
X-Received: by 2002:a17:907:3cc2:b0:c16:3074:6593 with SMTP id
 a640c23a62f3a-c1fe7ec89f6mr764356566b.12.1785746892948; Mon, 03 Aug 2026
 01:48:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 3 Aug 2026 17:48:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-aWSnucKnhX=AkGu=4VJVNQuwy0xjXAFCb_SriAtOz8w@mail.gmail.com>
X-Gm-Features: AUfX_mz42yileiMNXaa4Z9eO1NZ3S9ve7E0EV0I5kfEKeawHz6sj5oAlQWpUHIw
Message-ID: <CAKYAXd-aWSnucKnhX=AkGu=4VJVNQuwy0xjXAFCb_SriAtOz8w@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb/server: fix posix state check for directory rename
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	slow@samba.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 2:09=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> ChenXiaoSong (2):
>   smb/server: pass source ksmbd_file to rename helpers
>   smb/server: fix posix state check for directory rename
The argument-only change in 0002 patch has no standalone functional
purpose, so there is no reason to keep it as a separate patch.
Additionally, 0002 patch must be applied first, and applying only 0001
patch can result in a build failure. This is another source of error
caused by unnecessarily splitting the change. Therefore, I squashed
the two patches into a single patch and applied it to
#ksmbd-for-next-next.
Thanks!
