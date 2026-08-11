Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9AE429CDC
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786452616; cv=none; b=Gf3OLHBFVtze4bEaa/cKPURrDh35dp0OAU4VpG0JoeoBYQLu2fzKu6kbMfqtut2cL6el5lME/AcoFNRB0yt3X4H4qMRBLnXvEpqr47KzgnA8FskDxZuOLCyDKg2LUrc9DxjfVhXO3mXkT3hlK8DP2Hz8UD/F3V0zck1iKwsBK+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786452616; c=relaxed/simple;
	bh=xms1KOihBo+14lGtWLx45Kr+C393u3Ho17vLSkOIE0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dPQe7dAy1MNDTlJijW8hvu/1yr//XRVDMvvLr/nY2lhrivsxTzp/Qr5GvtKbA09e/D4fsGKt6u79G8LCbX5GJT98rNuaMsDyGCHshsZjhRtYVURt7yfvXqKGF/yQb5nNE57mDy+zgZDgxgMAL5y0gzWlX9mlVeOywL4MLFZ5uZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxfng/sj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxfng/sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5165D1F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786452614;
	bh=xms1KOihBo+14lGtWLx45Kr+C393u3Ho17vLSkOIE0I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lxfng/sj7Tp2EZ1qa7DBxDi9tlpIWwFYJ1v+vVziu1oF2MiLA11XN6VqnQ2Z8rCEy
	 NtY7Z8bf1HcyDbRTf5y804hJ0zao91UxXCcyuOntYRHtVMbJq7rT4+LgXAT23aQqY8
	 /W1Kc+4GMH15tjOitd/TDWj+xy3U+/RIQtgzpij5dJhlvChEUwZwSZ0WrWfVXh1OI6
	 pr8y+HD+8TsEit0mQdP0fZuiWFTwHL9wGCbTCNlLzRUpsLsI3RA4TY99wAuI3nX9Jf
	 2wBGzFbcI5JAWS/ROwugwfLH706Cjc9KrrZ4CD2sybrKquOPhhWpeAXtirEAaMKxPM
	 1EIpdziU4Z0Ig==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so295886066b.0
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 05:50:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoKVskwnvIx8Q2VIlRPmxF7vzwM4GlNcVrmHDiu0QbETxclT/iVFt1O3dxeiLnP9Sk0n/sPZ1mKGDGj@vger.kernel.org
X-Gm-Message-State: AOJu0YxgeRfxNgDjdxqpVNCmoqWGXlGE2sW+ajvfnXJbUFsQwg/+NutZ
	BdlbvnLj2DX9kZsgWpJbrBqCZuiQobmGkPFUh/DudQ2LfvAd3EFKFGuFjO0dRBYel8YGdt4D0/L
	LOFBFaFqv3j9sL7DpX/PI7nvu1PEozs4=
X-Received: by 2002:a17:907:c0a:b0:c1f:5d05:34e8 with SMTP id
 a640c23a62f3a-c20e6225e0bmr142934566b.21.1786452612941; Tue, 11 Aug 2026
 05:50:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 11 Aug 2026 21:50:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
X-Gm-Features: AUfX_mydCX-MqFLT7EWPXMWA3YBhE4x4SETdBnNdaKZ2Y4FpcqhZBpwKVsgNYcY
Message-ID: <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com, 
	senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 1:20=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The next version of my complete notify implementation may still take some=
 time to modify,
> so merging Gael's patch sooner would help avoid repeated rebasing.
Can you check two smbtorture failures from this patch-set ?

$ ./bin/smbtorture //ksmbd.test/cifsd-test3/
-Ulinkinjeon@KSMBD.TEST%1234 --use-kerberos=3Drequired
smb2.session.expire2s

smbtorture 4.18.0
Using seed 1786452357
time: 2026-08-11 12:45:57.628809
test: expire2s
time: 2026-08-11 12:45:57.629426
query info =3D> OK
lock =3D> OK
1st notify =3D> PENDING
sleep 10 seconds
query info =3D> EXPIRED
set info =3D> EXPIRED
flush =3D> EXPIRED
read =3D> EXPIRED
write =3D> EXPIRED
ioctl =3D> EXPIRED
oplock ack =3D> EXPIRED
lease ack =3D> EXPIRED
query directory =3D> EXPIRED
1st notify =3D> CANCEL
2nd notify =3D> EXPIRED
time: 2026-08-11 12:46:07.761775
failure: expire2s [
../../source4/torture/smb2/session.c:1482: status was
NT_STATUS_ACCESS_DENIED, expected NT_STATUS_NETWORK_SESSION_EXPIRED:
smb2_notify returned unexpected status
]

$ ./bin/smbtorture //ksmbd.test/cifsd-test3/
-Ulinkinjeon@KSMBD.TEST%1234 --use-kerberos=3Drequired
smb2.session.expire2e

smbtorture 4.18.0
Using seed 1786452388
time: 2026-08-11 12:46:28.839654
test: expire2e
time: 2026-08-11 12:46:28.840279
query info =3D> OK
lock =3D> OK
1st notify =3D> PENDING
sleep 10 seconds
query info =3D> EXPIRED
set info =3D> EXPIRED
flush =3D> EXPIRED
read =3D> EXPIRED
write =3D> EXPIRED
ioctl =3D> EXPIRED
oplock ack =3D> EXPIRED
lease ack =3D> EXPIRED
query directory =3D> EXPIRED
1st notify =3D> CANCEL
2nd notify =3D> EXPIRED
time: 2026-08-11 12:46:38.954222
failure: expire2e [
../../source4/torture/smb2/session.c:1482: status was
NT_STATUS_ACCESS_DENIED, expected NT_STATUS_NETWORK_SESSION_EXPIRED:
smb2_notify returned unexpected status
]
