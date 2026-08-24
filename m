Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D6334C3D
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 23:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787615453; cv=none; b=lFQMwao0kEu219HgIJzragLGQCBV8uXftDxKG4NSKbGfkfYm1v6hNiT9lKu/jK/fN71HdH5liBxYrNhDNGWik0mfgnaJB0GhlJ0SqyWNjI0Ho9OaT/yHP/af3NeRqlFQh8gLgjZEQMDrXcj/+i7Aj5+fDT68DDFbMIfAzTPp+5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787615453; c=relaxed/simple;
	bh=2b9h6pGiLZD2WRcgoOrhSLVmbDn1wudO9py0PQ/8ZVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QKjqfAFBB6UjNRK2X07yuFU3//3iCUTXqtRbfceknZ3fs+tQvFizoZaheJqHKQA5kMZzbh5rIVIbfs+2J1XaL7Uz3dC0VnzGiW42W3aTSwJRUdSCqlUFSnCH1g4EciRL4nBSdCoGm2LPPgIGeG1uXfIMoLdfA3pZIU6C7WoJ+Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sbtpv5K6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sbtpv5K6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CD51F00AC4
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 23:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787615452;
	bh=O1NxW5UCrvqxpbTSSg1+ct0wHpVvYfk3nZLtWuhg7kc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Sbtpv5K6ESHpgj950NVUnDDytVN76zeS4qC7r7a2/vwgbwUcVJI+xwQK6WaUPysap
	 G1l5XGH9ZW6X7oSEcCzUpuc37yU1aSosnIDCKVlZbSkCL2O0Gr+hOr4ToLZB9s9xMD
	 eQ1GmVg0dcEh6gfwBmBqfuB3Q+YqEhey++UJBegL1JnhQJIb3Z9mYPrn9pr5CFjRuQ
	 ok5Qhfcw43/qnVctT4OorBbZKS5cWSHR2uPRff2hAs66Cp+D3nRZp8SBLZrinsc1KU
	 AJyflmpXbMwkRFV2v80Wo4mk94Nrna20o+L5zpmaEVJz1i6rtpXD+b8D1nngI3cPwy
	 sJSfzx6J9uFUg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1f758014b8so451183466b.3
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 16:50:52 -0700 (PDT)
X-Gm-Message-State: AFuF++m57UjWoVRekgINfNqNwI2LFJdu92KFsZ/TCcXg1mom/NmkMJ2O
	jwOK4xPnzAphPFm+0WCppz+th6PMcwLr5Z4U0n5b4WiXfFenL3+K79eRb1LH9obD6/8RYfAb4Nt
	CTnkzEZsx2IWg9sKcE74Vps4Ey7MDN+0=
X-Received: by 2002:a17:907:1c1f:b0:c20:31d1:a899 with SMTP id
 a640c23a62f3a-c246a4ad97emr3431061066b.4.1787615451207; Mon, 24 Aug 2026
 16:50:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824195912.634526-1-pc@manguebit.org>
In-Reply-To: <20260824195912.634526-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 25 Aug 2026 08:50:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_wGZ_YMOHi7f-EE1-PVkCt6Qbt2Uh6LwYLB_+gW3F36Q@mail.gmail.com>
X-Gm-Features: AcwNN1UWU_hePnn2jkBxdvdyARMOqhYPQjt55Nmla25GoReja-9jO_lTJaa1DX0
Message-ID: <CAKYAXd_wGZ_YMOHi7f-EE1-PVkCt6Qbt2Uh6LwYLB_+gW3F36Q@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix multiuser mount with krb5
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Jacob Shivers <jshivers@redhat.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 4:59=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Customer reported that they could no longer mount their SMB shares
> with multiuser mount option and krb5.  Turned out that the client
> wasn't duplicating username option when creating multiuser
> connections, therefore failing to retrieve credentials as
> cifs.upcall(8) couldn't find them in keytab.
>
> Fix this by duplicating username option (if set) from original fs
> context before creating multiuser connections with krb5.
>
> Reproducer:
>
>   ```
>   $ ktutil
>   ktutil:  add_entry -password -p testuser -k 1 -e aes256-cts
>   Password for testuser@ZELDA.TEST:
>   ktutil:  write_kt /etc/krb5.keytab
>   ktutil:  quit
>   $ klist -ke
>   Keytab name: FILE:/etc/krb5.keytab
>   KVNO Principal
>    ---- ----------------------------------------------------------------
>      1 testuser@ZELDA.TEST (aes256-cts-hmac-sha1-96)
>   $ mount.cifs //w22-root2/scratch /mnt/1 -o \
>         uid=3D1000,sec=3Dkrb5,username=3Dtestuser@ZELDA.TEST,multiuser
>   mount error(13): Permission denied
>   Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and
>   kernel log messages (dmesg)
>   ```
>
> Reported-by: Jacob Shivers <jshivers@redhat.com>
> Fixes: 12b4c5d98cd7 ("smb: client: fix krb5 mount with username option")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
