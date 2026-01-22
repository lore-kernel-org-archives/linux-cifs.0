Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC2A2FE579
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769085135; cv=none; b=omUfmHiY1dv+maf1O2ZqAjDw0Gv0xtmmGPX2nDkC7NicIVCxNzU9rFWWuHjGD0dOTJaBdeh3mtdfNJRAE/A1cX3sW5ZPaQJLwNCPZCGq9psh0fU72sO79A6R6l5hHDEfglzVxlHA9BJxx+Jl41WOiYXa3giUiOepP7H5aox5wxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769085135; c=relaxed/simple;
	bh=d8Def9PVTqewssSlh9dZ/Q2Y8Z89O1Lw2ILvhmm6flg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YuE8E9QWncHo2QBA+34hLVyNPcCoZhefLiJqQPn+7juVhKvDV2wDZ2BZ+Irk7/heGq0//uE0dhmIu73LqngJS/yJeGXHL2Mjq9FVuQSBd9ZHgWBYEqCJDgtjsVdiYK3j1xjdwTZuA0L4/VTYxFNnqBBhEmMvI5LCoLv6fROMvvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3fQ6Rqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3fQ6Rqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D187C4AF09
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769085135;
	bh=d8Def9PVTqewssSlh9dZ/Q2Y8Z89O1Lw2ILvhmm6flg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=n3fQ6RqaTDre0jKXjOOMrzwL2UsSQSWIOzPzmC6s+mjieiaumvykG9+F/0jmXVKi0
	 V3j/UKZgSJoLC9GQfMTO4LrWtck+sHD27nd9QqqnGGmhUA1kxH4i2Ta9bpDRAANn+Z
	 MXchKolNrH3CzgzJ2KCXDg+m7XYtDXv6JFDzKJ2v5R0jSFS/7W83O5JqKxu/M+91tY
	 NBmSzIu41/PlJIluX45pKxeFdnq3GsgjJTOVl95UFlk9crupJu0XNhke4qloqSNaD1
	 JJrfedkbJXrLetuqiqjyVSjCguYaPBNnLBI9vg3sdT0kWcZvuXdRNsz+gv7ZVxdjQw
	 fhWNikzHXOM+A==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65813e3e215so1772493a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 04:32:15 -0800 (PST)
X-Gm-Message-State: AOJu0YwfxMvTfhvlaTprYo2z1lPSGiYqxDjLXDzLkDKW6gHqMiuoyVOS
	bbNOp9sr4wX343+jK+Qj+tDZmAg0kEG5+vHBt/vr7sWk0/niLoV0Jjx2688/cIeuEByQS0s1+qH
	4/hcd27olcOfouBgSeFyswCShCei6Moc=
X-Received: by 2002:a05:6402:2342:b0:649:815e:3f9b with SMTP id
 4fb4d7f45d1cf-654b9364eaemr15295455a12.3.1769085133730; Thu, 22 Jan 2026
 04:32:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769024269.git.metze@samba.org> <1f60cea1eae937938070f66f1b8343107a1155fd.1769024269.git.metze@samba.org>
In-Reply-To: <1f60cea1eae937938070f66f1b8343107a1155fd.1769024269.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Jan 2026 21:32:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd96QRnjDmQRRy9BDN+4ikec1DAbT8FCESwMVL8+PJebVA@mail.gmail.com>
X-Gm-Features: AZwV_QgitcCrjyLBq2mrXyuQ8g1zGXIhjdfOfnkcuui8dGFK79XQBXvC5CAuw6E
Message-ID: <CAKYAXd96QRnjDmQRRy9BDN+4ikec1DAbT8FCESwMVL8+PJebVA@mail.gmail.com>
Subject: Re: [PATCH 01/19] smb: smbdirect: introduce smbdirect_socket.recv_io.credits.available
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 4:51=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> The logic off managing recv credits by counting posted recv_io and
> granted credits is racy.
>
> That's because the peer might already consumed a credit,
> but between receiving the incoming recv at the hardware
> and processing the completion in the 'recv_done' functions
> we likely have a window where we grant credits, which
> don't really exist.
>
> So we better have a decicated counter for the
> available credits, which will be incremented
> when we posted new recv buffers and drained when
> we grant the credits to the peer.
>
> Fixes: 5fb9b459b368 ("smb: client: count the number of posted recv_io mes=
sages in order to calculated credits")
> Fixes: 89b021a72663 ("smb: server: manage recv credits by counting posted=
 recv_io and granted credits")
> Cc: <stable@vger.kernel.org> # 6.18.x
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
