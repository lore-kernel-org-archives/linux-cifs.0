Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CBB18B0A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 06:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787033315; cv=none; b=pS1Gq2y0YQyfwny/3imP9NCTtmJBEcbcAhN10UJqvSxy1WfX0j7BTjIN0iWshYSgonyDx7SqXFBcH05ScQMCj3VYPKRxeOMu1mGvD2Z/Q7lnvZPEo26VLq1sGRyvtPjDMp2ELZgiQpDN1SaUsheaGxzH/IY2G+8WpI7P8EpeNYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787033315; c=relaxed/simple;
	bh=f/hCM9N9Ntz8wexDXdVQp8+SXLgTcHxstwRLt59Ite4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OfUumFzc3YaZdMbhm1ikALDww46f6nj77cDaeyGNiQtQ8Qvc3Ice+HpgcU9vrj1OId0JD5LrNTCwFjXvy3Qmcwb/JIv1L2MClA9Sk/lwCjOppn5F/hH4F4hWo4PCtnSymgnI4Q/1XBRkbd9KSe6NOWG9PZNApadY9BTYq+B5qA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xdxq6Wnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xdxq6Wnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD481F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 06:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787033313;
	bh=BwyIpY/AcE/hLv+Cxg5S0crgQT0ug8B2N+u7FM4hmEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Xdxq6WnxOiTBnfu8aQ36JwYxh1sfXaMQe0gjWlj/2I2lKwIDzaRs3g8TX8/cJ2hNx
	 rRLygc/AL3+gI7IFtBWldgt0b2yoO3WSPlxfFv6lIt8BV26HDzlhA7PTHmW4rOAOUP
	 79rUYsGU/t2Gd1zhGiFzZUrsIE+qCCmsyWwV6u64hr1bQPO6Wfcd5tt/H+x3JlXdRW
	 fofqomSKfUWAN7aoC2rajBPPxcWzWymw/lvdGb+Nl6JZ6+Rx7y2v/GMvhePTIZGvpM
	 FzJfBrv1a6GVBnUQX7iIk2syKkJCN4RB9dymc5LIehJExBN331KlhLnebBPsv95CWQ
	 wftXeqNsBXSjw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so441675266b.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 23:08:33 -0700 (PDT)
X-Gm-Message-State: AOJu0YxuhQ75xPdKt7fJwU+qlMul9HHrjltCio97CQYuRHSqBXD4boyA
	zxRAdVx/4oddy3MYP4k3zFbO1UCvbPxdlsZ+5s0ztue3C4zuSwKlLnn/2fWV89zCpTlyKxkErwn
	uifB+TCYcw0oD1XRtgPiIqYl0NW1Cbmg=
X-Received: by 2002:a17:907:1ca1:b0:c17:cf99:6154 with SMTP id
 a640c23a62f3a-c212a1d6bfdmr1195897366b.16.1787033312494; Mon, 17 Aug 2026
 23:08:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813023951.1846143-1-sorenson@redhat.com>
In-Reply-To: <20260813023951.1846143-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 15:08:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_3303gs1eYXMYbceGdm=iF4BsX0v-6sLHbdhW7CUe8Wg@mail.gmail.com>
X-Gm-Features: AcwNN1VstbMOI8yxIJav7Wr6Jox_CuuvVTI3_YFKVRBwwIUcOe-7-q6TJPNkgcc
Message-ID: <CAKYAXd_3303gs1eYXMYbceGdm=iF4BsX0v-6sLHbdhW7CUe8Wg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix UAF and buffer leak in
 cifs_check_trans2() for malformed secondary T2
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 11:40=E2=80=AFAM Frank Sorenson <sorenson@redhat.co=
m> wrote:
>
> When a valid primary TRANSACT2 response has been received (mid->resp_buf
> set, mid->multiRsp true) and a subsequent secondary response causes
> cifs_check_trans2() to return false -- either because the SMB header is
> invalid (malformed !=3D 0) or because check2ndT2() rejects the PDU --
> handle_mid() overwrites mid->resp_buf with the new buffer (leaking the
> primary buffer) and, because mid->multiRsp is set, skips the
> server->smallbuf/bigbuf NULL-out.  When the user thread frees
> mid->resp_buf, server->smallbuf or server->bigbuf is left dangling; the
> demux thread reuses it for the next packet, resulting in a use-after-free=
.
>
> Combine both early-exit conditions and, when mid->multiRsp is already
> set, abort the pending transaction inline: set multiEnd, call
> dequeue_mid() with malformed=3Dtrue, and return true so handle_mid() exit=
s
> without touching mid->resp_buf or the server buffer pointers.
>
> Fixes: 316cf94a910f ("CIFS: Move trans2 processing to ops struct")
> Cc: stable@vger.kernel.org # cifs_check_trans2() is in smb1ops.c on kerne=
ls < 7.0
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Will apply it to #for-next.
Thanks!
