Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F26B18B0A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 04:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029183; cv=none; b=hkEuFqyYZlSCNJX9Tq/2+KtTZRFTIDL4a0u6LsB6BgU6+Ao51I4PT0E/2vDo6GbqQ+m3WVzeajqp7b15ZLjbPui337a1AIFdi0puTak1Ci+Zx/YzibD0tZiAjA/MobMXvA4YAekpIPYUPGUHF2liBDi9Gz7YNorynzIHf4yRjB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029183; c=relaxed/simple;
	bh=RhhD8X5rK7aR2QKeIBtsbIH11EkBqXXvlnIo2fs37ZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftbXhKgpjunTkaOVPshKaPKYTzB/vxYkwPLIHrfB8FdoS4Gu7RGnun0Xx4+D9ShzKTCXWfmGB05cd8YXiRIHLM2DNbIdb8i1g0iEECK2QWQ9CY0elV8MsD/P0MZCyEzWwAhJlz3hb6uj9gPIw8VQHt8y8WKA4uRitQb59go9Z/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKwY9GqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKwY9GqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2011F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 04:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787029182;
	bh=U1y1bi4uQm0Vdb8yxM+FNZmowCgtftmLD5JTAPWy294=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gKwY9GqLsvxN93iTqA3ghZkUSED00XOwc8sVKYA5EPcs+rOLhSReSOmIdvy3EBlui
	 VULsJyariwO/G9UA+m4643NsZMffj6YGI+ZrTYI402zgUqQGoNTGcvplp11IIRvR3n
	 uMOYtoGPYLcJdvlvXKiltLfnYXTF0zk+RcLinv3G+2kYppZckGOANTvrItyBszi25H
	 hi6bRABsb4tzK6YUA917ShgHLRXGKXDojIM75vYv9QH0EUMGSmgOJz4xfreYEgorqF
	 6DMfarPUnPhOk7ImSabBn2+5CAMzTZ24w7nYZTDBsRHyyWzVhsuncVm/Pc4zcuzYUZ
	 My3CM0X/nuRTw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a3efa2b38aso8393a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 21:59:42 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw/48c+Hq4HJx2ozLGLSXEm7Ara4GBOlBKbhtglFmBsjFaNynyu
	qbVoe2BzkAMwSpyYF4VNUvUE04IWDvkpgJbuzSSNz2WG6ECdvr0hgAL351w+cofI6M5Ed57gkcp
	IpUH9WOJpcGwInjnzrn06QngkmMH1Pyc=
X-Received: by 2002:a05:6402:f1a:b0:6a3:e47d:d132 with SMTP id
 4fb4d7f45d1cf-6a3e47dd373mr1153018a12.5.1787029180830; Mon, 17 Aug 2026
 21:59:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808202903.172277-1-sorenson@redhat.com>
In-Reply-To: <20260808202903.172277-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 13:59:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_YuBCoyYHCUepa0EYJAJ1tJbwuB=PmVBEF7r9HTatdTw@mail.gmail.com>
X-Gm-Features: AcwNN1W_L6OBijNDhANeGR4IuZHc8Iz5VvQzEe5zCRuv_YBpvVAsRvL-bG0I4xw
Message-ID: <CAKYAXd_YuBCoyYHCUepa0EYJAJ1tJbwuB=PmVBEF7r9HTatdTw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix clearing stats for fastest execution of each
 smb2 command
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stfrench@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 9, 2026 at 5:29=E2=80=AFAM Frank Sorenson <sorenson@redhat.com>=
 wrote:
>
> The code to clear the 'fastest_cmd' statistics has a typo that
> repeatedly clears the stat for cmd 0, rather than iterating
> through each cmd.  Fix the typo (0->i).
>
> Fixes: 433b8dd7672be ("SMB3: Track total time spent on roundtrips for eac=
h SMB3 command")
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Will apply it to #for-next.
Thanks!
