Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5153F4207A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 04:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787026300; cv=none; b=Jg1f3WcS+IeCd1CpeXJeoaeOw3SZubgIat5BssxHoYGs8aIM8mYa24zUvqsicuSw4zqmZaV1X5jSZmuiQ06HW0PIX4j7UKH9/dZKwxQs7x+QI64iouaVMCQXqq9rf4DDYgMBQUVbhd3hZ1QyIVhNqEbgd2JzSMKqgTfxho1JP+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787026300; c=relaxed/simple;
	bh=Z4K/ihWjviWB/tKnNjeIDWxYhpRRCwm3+HAlYkxJejs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FJz3KQqByIwHQG1TGDYKWLSXTf3iKh0W+OtTGuSzVnFtTq2b3bREbQWMUwraAXAHLMCN8mDinXuNWI7qN8kvPkMhNInvXNSTSR6j36msgc1ShmiqdOORN55FJEaDmbtx2gxnQR9wonS5HL/4EC4J9iUp3Ni/st07w7/Yd8zOd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hg00Xi7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hg00Xi7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288991F00ACA
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 04:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787026299;
	bh=540QcSr75PQ/ZOyK33VSAsJ+U3W5UxWId0Js/IarnC4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Hg00Xi7EwJIVW+RAkugB+5rWsPDwRb2Vzs7SZQXH6Wk9kao+cscyxBczx4e+dep46
	 p5CQuMCRhTY7laTrFsOEb0L9JNeLY/dOtoZSXl9PRaqkFFn8wTnDCah5QqB6Q5iIGt
	 FaDxdiYwkdDV5WhXTOXEZWLlfBCynWthPH/qgJ0J5lGQhe5QCEfiKswzVLgWDhik3g
	 0IDpAoXjbvQV6Da4jndZacK5UGmAGGk3vIq5qrfrRUbqpYfSxIO0uqiDp0QXQds/FG
	 a/8NVad0p50bDtzsR4/iSWtSf/YonWoXVytnWfEhs27VoAs5tykxTo2NefCwGdbX3/
	 QJhmgSVL+iUlQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1712a04ddaso694434366b.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 21:11:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RotSw2jlRvg6iTZQYi29rOF4Z1zhMuAh7KMiFKqv3cRrwtMxEHwCpxuiWfjND2aQY9Hd21MIjrTvltz@vger.kernel.org
X-Gm-Message-State: AOJu0YyvlufkfSqe2hDmlSBJHpdPKgc5p32l07CmuyedqES04XE2/vt1
	8r95kSlxUyNmcgo3bksTIDhA+RvdqmbutT4RLIyL7aNJpvtUQVhoOz+My8P7/8jo9mqnMuGhNQD
	92MAUX1L0iX3+zsqunmzgcduYO0egqeE=
X-Received: by 2002:a17:906:9fc8:b0:c20:768:af62 with SMTP id
 a640c23a62f3a-c212a18c634mr1442007866b.22.1787026297767; Mon, 17 Aug 2026
 21:11:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260805015447.15488-1-huiwen.he@linux.dev>
In-Reply-To: <20260805015447.15488-1-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 13:11:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9gZeRhL5Pt_risHwU-GQp=_3Tv3kHVoA0qPMrYOCA4iQ@mail.gmail.com>
X-Gm-Features: AcwNN1UDLANC_ZdBCSAOewl1JmcKk6FLru6qYM4dyZ4Ak5gujq6TukloXwEuOSA
Message-ID: <CAKYAXd9gZeRhL5Pt_risHwU-GQp=_3Tv3kHVoA0qPMrYOCA4iQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/2] smb/client: handle compression flags through fileattr
To: Huiwen He <huiwen.he@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 10:56=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> This series moves CIFS compression flag updates to the generic VFS
> fileattr path.
>
> - Patch1 implements ->fileattr_set for CIFS compression flags so
>   FS_IOC_SETFLAGS uses the generic VFS permission and serialization check=
s.
>
> - Patch 2 removes the old FS_IOC_GETFLAGS and FS_IOC_SETFLAGS
>   handlers from cifs_ioctl(), which are no longer reachable.
>
> Thanks,
> Huiwen
>
> Huiwen He (2):
>   smb/client: implement fileattr_set for compression flags
>   smb/client: remove unused file flags ioctl handlers
Will apply these to #for-next.
Thanks!
