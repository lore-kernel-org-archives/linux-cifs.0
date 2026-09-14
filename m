Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB803B4407
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 10:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789383587; cv=none; b=Rca2+hwPVeAfaR0f4oranSZu3NXDq7sBc7FhUsAQqEw0IBvwjfaB28sKPdnEeCEsCic/KfEgFKLnHfh1lQoj/fyFT9ipHhuNM4Q6RN+x8O/3PjbOyOuHdW9qAZPu7fwAOabdQyx9qB3rJP0muFPOvIXkaddDR0VcYD0SU3FUIsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789383587; c=relaxed/simple;
	bh=BSjDe0k1pBUOvAtXMORF+4033poOVBthCDau0CPKRvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tI446G2lOUsHzs5PtKAEvGOdpmaEtFV+nO76iS8eOJBt9OiUnUvA6fE15tQkVETzjMxB0bpdWL/nzMQyXXrI6zuTIAHW9RWREurTQcJOFdTRCx8cXTY/nTbT4WdKnosFp02OhxgAUcUiMa+r7UaX/OZrNzyB/3lHsjqFRpVq1VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbOuq7p4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbOuq7p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB1F1F00898
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 10:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789383584;
	bh=+FnaHS+rMA3Agp5RiQH4maxvZhdE3kEiXwudb9Savas=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DbOuq7p4XFTkG659E3HqNUmvpscxQVQ+I4Rto26j9u4x3eBzJ0yuriVUsrfXVJDlL
	 X3SABk4+UjJPMZFNQeBCunrNMHBrfCmVcpmEEvh2T9oMWGf2pugzHJuqBUQPRBd1ob
	 0S9RnsbKzp4GrxGgHKc/Dkkcz39vAm+EI5msRoGc3vycGs1nQtUoIUQC65gSZoPAPW
	 ZWj9/D0ix6RYTrdu5+QJ77E6GtQj5MRCpFV0ChtpVt1lypnR5xSW+2W/unlAV+3+wQ
	 k+0MbaSs9TEXboEFz1NhA5nwAnXMLF5tPfjiNB2W0UbgSZ9+rB3AyARoY3sSH/kWZn
	 yH4XYd9pNvaEg==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1fso312661766b.2
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 03:59:44 -0700 (PDT)
X-Gm-Message-State: AFuF++laeY00jZ8bsbzPxs6Ck0zhE9fUHrknI/KAKcv7BZe/GHRanRmR
	RHDfZTBpkAxJAM5jJzHqxDYp2r4GV5//iTTGq1EJ3EjZWMoWsIf+PCdtU5J0qbpILWWK0/vnaRv
	uiPz11ax/+gcCiMgEdg10UO5iwAfERm8=
X-Received: by 2002:a17:907:c5c6:b0:c29:29e1:2a07 with SMTP id
 a640c23a62f3a-c29b85fb015mr270930666b.7.1789383582768; Mon, 14 Sep 2026
 03:59:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913232737.51704-1-g.blivet@me.com>
In-Reply-To: <20260913232737.51704-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 14 Sep 2026 19:59:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd85uqffxAQQS4UDqihFdr7UWTRiLJZ4u49daWRaPiNuYw@mail.gmail.com>
X-Gm-Features: AcwNN1XTeyY7swWfH3YzhTBcvhCO_r7MifsJOcW5CvjcC97uk9I3ryR6Z1tWMvw
Message-ID: <CAKYAXd85uqffxAQQS4UDqihFdr7UWTRiLJZ4u49daWRaPiNuYw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ksmbd: stream xattr and procfs fixes
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 8:28=E2=80=AFAM Ga=C3=ABl Blivet-Bailly
<gael.blivet@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> Four independent fixes.
>
> Patches 1 and 2 are named stream bugs: renaming a stream produced an
> empty target, and stream enumeration sized each stream with a
> case-insensitive lookup, so two streams differing only in case reported
> each other's size.
>
> Patch 3 corrects the header of the AFP_AfpInfo xattr ksmbd synthesizes
> on Time Machine shares.
>
> Patch 4 fixes the procfs listings printing a native IPv6 client address
> as a bogus IPv4 address.
>
> Gael Blivet (4):
>   ksmbd: copy stream content when renaming to a new stream name
>   ksmbd: look up stream size by exact xattr name
>   ksmbd: fix AFP_AfpInfo header fields in synthesized xattr
>   ksmbd: print IPv6 client addresses correctly in procfs
Applied them to #ksmbd-for-next.
Thanks!
