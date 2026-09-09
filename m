Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7FA33EB01
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 02:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788922562; cv=none; b=ZHgTne0KDvySerkhqJORTsUGWzG1hRJClxulTK/IKRJmcNU/wPGQhLexg9ZnmdmM1BJijM91fpR+mIhToGcAjotJAComEoXxljqQXa8bS8dDnvMa/IqtSj1X7075NqgW5w/JSFJcbcFIzBFfJ8SGXRGvl/OwQuvo5F/smnr+v9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788922562; c=relaxed/simple;
	bh=l6LGxDGHF+eDcoMXHrxI/whvyp6dixIL/oRPs4Usrmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H6w98a04wkHGi8N/ufQq0xXSvW+dHZZTw6bVpA1j8Xtcy8n/T/Q39Bmd0iXG3mgHqEsPuGhwn64MoaPADXUD5K21LqWdNLBCfc8gVGakQLTSEqXkAAPTDopZnNQz4UTBSsN0VL/MqHqR1OE/1Q67kP1YHXSZGY1D1YZ5KMNJ8q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtbMhApa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtbMhApa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B491F00A3D
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 02:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788922558;
	bh=l6LGxDGHF+eDcoMXHrxI/whvyp6dixIL/oRPs4Usrmk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WtbMhApaIp0etxcSlfp77RHASEir3oE6em3Xx6mpsQaRsiXemYz05NJWMt0KazvTi
	 JefzswCuQNePAuprqVSomZiHA0Ji94QK8zZLObK511WENfBfoLoROBqzVOsGXvkVGJ
	 4c3bfWE6tw4ecaiCts++sml+pnn3rTDb+GLGTc/VX1vxWh+EwJcVBuRpDGA4gWCDcP
	 ciGbs7/F7tAzgOXmiYJDMcr5dVvZI9IGqwKC3iHKJd7+GIKRcgVZh0Q6HS4MmBDCqd
	 sfc+E3Oz+Ltwkg2+rciD90dRHYkXsyLmJ6lgxRznFgaxD0bvVdHaDAlOh8m3FMsZ59
	 CzFqRhZL2cg8Q==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a20319d030so7215636a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 08 Sep 2026 19:55:58 -0700 (PDT)
X-Gm-Message-State: AFuF++k/I1/NnVtc1z/viqt6pwPK6xFDMyQyT1PC8YhaA5nIEMTqQKd7
	zbB+BP3aB347ZiM9kmCVhDRXJe1Zd8QxQgQD5p8eeya1tBvtu5qHIhuL8qS2knS0H7WhIrZAqjW
	w9NPHw8HlhAIbpotNRH5OZ2a5+2vTJvI=
X-Received: by 2002:a17:907:3d44:b0:c27:420b:7c90 with SMTP id
 a640c23a62f3a-c27420ba0camr812879466b.48.1788922557334; Tue, 08 Sep 2026
 19:55:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904125844.1803343-1-doebel@amazon.de> <20260908161001.2603610-1-doebel@amazon.de>
 <20260908161001.2603610-3-doebel@amazon.de>
In-Reply-To: <20260908161001.2603610-3-doebel@amazon.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 9 Sep 2026 11:55:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8s4Bp49YRxGM=W3a1STE3+PPVmR-N2a+=RCpHtigLkYQ@mail.gmail.com>
X-Gm-Features: AcwNN1X0gTC-HlnXYdhW9zVt8bmrKrFLNngA0BusTz14uy_4lHbUHjbj2Oo8kLQ
Message-ID: <CAKYAXd8s4Bp49YRxGM=W3a1STE3+PPVmR-N2a+=RCpHtigLkYQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] smb: client: fail DACL rewrite when the new DACL
 exceeds 64K
To: Bjoern Doebel <doebel@amazon.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 1:10=E2=80=AFAM Bjoern Doebel <doebel@amazon.de> wro=
te:
>
> replace_sids_and_copy_aces() and set_chmod_dacl() accumulate the size of
> the DACL they build in a u16. That accumulator can wrap.
>
> validate_dacl() caps num_aces at (dacl_size - sizeof(struct smb_acl)) /
> 20, i.e. 3276 for a maximally sized DACL, while each rewritten ACE can
> grow to sizeof(struct smb_ace) (76 bytes) once its SID is replaced with
> one carrying SID_MAX_SUB_AUTHORITIES sub-authorities. The worst case is
> therefore sizeof(struct smb_acl) + 3276 * 76 =3D 248984 bytes, far beyond
> what a u16 can hold. A wraparound is reached with 863 ACEs.
>
> After the wraparound, ndacl_ptr->size becomes meaningless and the offset
> will point anywhere in the ACE array. As a result, we will see
> corruption of the DACL, which then gets sent to the server. This is not
> an out-of-bounds write as the allocation now covers the worst-case
> expansion, so writes will always go into the buffer.
>
> Adjust the code to use a u32 internally and return -EOVERFLOW in the
> overflow case. The operation must be refused, because a DACL can only
> hold 2^16-1 bytes on the wire and larger DACLs cannot be represented.
>
> set_chmod_dacl() carries the same pattern and is fixed the same way. It
> only wraps once the source DACL comes within roughly 380 bytes of the
> 64K ceiling, but the failure mode is identical.
>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: f5065508897a ("cifs: Retain old ACEs when converting between mode =
bits and ACL.")
> Assisted-by: Kiro:claude-opus-5
> Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
