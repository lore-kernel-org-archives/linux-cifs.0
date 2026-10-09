Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DCF4C14E5
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552373; cv=none; b=E6qxCrMOOAlbX0fZGQ5QtScuFCbkDRuSNG8Q1U75pHG4EWaeCMP1J1toIsQphiE5ETt6jLDT9sPgIg7VjaPQuP2mesXqSdxtMMGsv5ujlQcD+NDdBWYP0zz4evMwDilSsmbapZ3Ac+mENuanDImimwXXHSeGPpxvMeNJ+eWuH5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552373; c=relaxed/simple;
	bh=muiSCbOtfw7xCz5d6PXMqVBBFpKtOLkKFWgZ/p54B2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=otDliyBuLFxnym2mARH6S2ly9Z/i65Pu10Tvl8WjMfO6JJs1VQX9xnd5XzXu4OYSVpTTZ9SIrs7juTzpSl+RlkVW75mondJL7GOtMKwPsOxG+lVOwEOgpc8PleHYFGDa3N49eVPbVfCJedff8V83aKib0aB7E0Tr9auTglRHYg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahr5xlA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahr5xlA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED2F1F0089C
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552370;
	bh=eUzSBtKPP6ltgiCOjSRwDDobCiRzZ3Q45nA9wRVgtb0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ahr5xlA4f/wj2DUdb43PI6POD8ReNi4uv50aJklEk4gFCENVBrWnvey8MLRxFRauO
	 FvNSxx5s9YJAAjDbvjZBK3je6czGY07uunAV1iIJSNCYQQV6AyvatCyX7UDBNVpY//
	 oDvK6jkhxlx4wUTbFfoWLHMiJedMSZxeahdKz7Z4XXR3E7ZAPEvKGX4PfwYxeTkgeM
	 gORb1ZhjGx3KpT6JrvBk/+oQXWifdRuEjRhWWII9s1rTyWW0ldwQe8poNuMNJOs8Fq
	 eS8XlggngxkVuJCHMFiqK+4MT7o2flTZ6z56WDC5WbvgDeoN+6gqpBEUDn4Rwdriod
	 fkM7jCNZ36cKg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2e4df2e26fso549838266b.2
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 06:26:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByiKVyFIrDRCcHDpIDRSG8yD7ihVS/WFFlCNfOePNxhN3O1OusTO/bedbweLTgSeps7GSdtuOPzs6Eg@vger.kernel.org
X-Gm-Message-State: AFq9FYKO/us3GLM/WyNX/FRbDMX8zIzIJQGIDGBq054+IdejcMvMUPgD
	uwUl2lcpcvtaofGlNpxopDujpAQiCV1SP0e1lBm2aje3UJk9EF/ivHLETZQQoUEcojS4q8X83If
	p3hdPB3Jo+3U7z1vG75oLfHgMuyXu8xE=
X-Received: by 2002:a17:907:a310:b0:c2e:4e08:19ab with SMTP id
 a640c23a62f3a-c31a9afb4b9mr197608566b.16.1791552369360; Fri, 09 Oct 2026
 06:26:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007063046.26260-1-tjdqudcks0424@naver.com> <CAKYAXd9p2u3KiC1a-cOeCNcW0rMPpS7cge8rVE3uyUrgHiLOFw@mail.gmail.com>
In-Reply-To: <CAKYAXd9p2u3KiC1a-cOeCNcW0rMPpS7cge8rVE3uyUrgHiLOFw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Oct 2026 22:25:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd___5z5QMar-GkTZHihU+=_k_dXD5-3PhvpGZGnEnpF-A@mail.gmail.com>
X-Gm-Features: AclHuK_BIZ-v6X1pi8GxTOeWFPCL7DdWKaf53BT2GhcNw_iA-HtXUiDlibKN-bg
Message-ID: <CAKYAXd___5z5QMar-GkTZHihU+=_k_dXD5-3PhvpGZGnEnpF-A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: hold TCP session for async decrypt work
To: Sung Byeongchan <tjdqudcks0424@naver.com>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 7, 2026 at 4:20=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org> =
wrote:
>
> > @@ -5384,6 +5385,9 @@ receive_encrypted_read(struct TCP_Server_Info *se=
rver, struct mid_q_entry **mid,
> >                 dw->buf =3D server->smallbuf;
> >                 server->smallbuf =3D (char *)cifs_small_buf_get();
> >
> > +               spin_lock(&cifs_tcp_ses_lock);
> > +               server->srv_count++;
> Shouldn't we check under cifs_tcp_ses_lock whether srv_count is zero
> before incrementing it? If so, we should skip queueing the work and
> release dw.
Are you checking it ?

Thanks.
