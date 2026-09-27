Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015DF26158B
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 01:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790472779; cv=none; b=E+RvGUIsHNcULge6T8j2ne4ztmPvMlEGsK9UFOjsuWx/D3ULopF8HBhwW+4M/MIVI2YEFSgS4RYwqtoqXrUveggJpHgl4UyZm2rAePAjJmlvI4yD3QPVoAAWA/2Vt/lVpuKqQcc9KIlHy60Wz3AZLZhSoAF/2B0EHw/hRybKCu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790472779; c=relaxed/simple;
	bh=3RqPolZNKqfuMrSOidK90RRpD+aYp7x9syNCo45Ffto=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pMYoFwaFlrxeel7cAcbWvd6CzCa19uwnuxWz22hsvB5iuLC4+ymNcoXQ0bGbfVT97yt9tDRetgtYTlXbsWH75XRb0slM2rfmXAbFuMQQ9qEM++VBOXvQfskkZEqgP9QpdBn0Qj5rOn2iTrAv1vKMJ2aDpY8HbllEPIBZqOTEVOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCk/xVAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCk/xVAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807DF1F0089A
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 01:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790472777;
	bh=BR1lI2p7VMMep+ifiaJyCRvXH3+Dsp5olsruzMYwqBI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fCk/xVAAT7mgX3t1V48h/pTwMrIJWnKA6KxfuVZ4lXspwm7KDu8KdckzmVOk5vSZH
	 KNQwHhI0nvLYUEpW4bsEYVvbLGvc5UVXnAw54ZMRAo0UX1ls0qN5k2jJmIVDIoKTpH
	 oXX83SLacYhQlQvZ7NdYpofB3vQWXD/fyZOVkPSAcoXv1Y9u14UiWvFmkICw27hBY5
	 YMvegazUH4c3Z02KChBPOJT24kBKeV8n87PKsUuWaldldrXtqkJOwSXakRaWDr/21Q
	 iqiMbzKs6KWKyXD5HDGcnutiPgpCkt4LOBz1DCmNi7WbeuXb/jlW8mcPFOYqXOMoZi
	 /tXjJrCGyFhgg==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af7721e4aso206220966b.1
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 18:32:57 -0700 (PDT)
X-Gm-Message-State: AFuF++kn2HZFoTothyTyvlbocD1PngC/cOL6lZfnKTmMSHYOloiPPFPy
	3VYm5tIuetBus9A2LfnJetfgZzfSyOiXrZ+4sYPDmOAYjrYacevSnwUC6YJ9DMxc7nHZF3aSniu
	8ERgFgaEmQqDbI0xuVL2uj5ePhcAZPzE=
X-Received: by 2002:a17:907:3e88:b0:c2b:898e:24fd with SMTP id
 a640c23a62f3a-c2b898e3d80mr282661566b.33.1790472776127; Sat, 26 Sep 2026
 18:32:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926080224.1671214-1-zhangdairui@gmail.com>
In-Reply-To: <20260926080224.1671214-1-zhangdairui@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 27 Sep 2026 10:32:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ATgduq==_gWm5sHpNds4TtMt7d7_tt=MGSNjXzkH3oQ@mail.gmail.com>
X-Gm-Features: AclHuK9ZWgEJltsKQmjyLPmsYfmFQKQYQZoN4ENIdlG8OhR9JsjSxA1cuvIL-q4
Message-ID: <CAKYAXd-ATgduq==_gWm5sHpNds4TtMt7d7_tt=MGSNjXzkH3oQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: verify transform SessionId matches the decrypted header
To: Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> @@ -10890,6 +10890,22 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>         if (rc)
>                 return rc;
>
> +       /*
> +        * The decryption key is selected by the transform header Session=
Id,
> +        * while the request is authorized under the session named in the
> +        * decrypted inner header. Per MS-SMB2 the two must match; verify
> +        * that here and drop the connection on mismatch. A compression
> +        * transform payload carries the session id only after
> +        * decompression, so it is not covered by this check.
> +        */
> +       if (((struct smb2_hdr *)iov[1].iov_base)->ProtocolId =3D=3D
> +           SMB2_PROTO_NUMBER &&
If an encrypted request contains a compression transform, this check
is skipped because the decrypted ProtocolId is
SMB2_COMPRESSION_TRANSFORM_ID. After decompression, the smb2 header=E2=80=
=99s
SessionId must be checked against the transform header=E2=80=99s SessionId.
