Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7732797B5
	for <linux-cifs@vger.kernel.org>; Fri,  6 Feb 2026 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390588; cv=none; b=fvNNMiSdfoqxbu3+IQuVn2e77UhlOY3Nbk+CESxEcI9b8xMDTy1hmYwKNaZ8VUI9u2rGSqIGg1jD+4nJOTr1wNWjQX8lShmiReCX4vAo1jdxTzueLPUM0B+JvokuG6cux0oMXTJ6YE1Vg5qx9H5QdOJlvU2cYhPKOBDM7OH+914=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390588; c=relaxed/simple;
	bh=VQpGvR/EQs8HRIQ8AgtJsCKAMsKXllPdFMudlJHMHA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oadLmUUPEDB3Jbk24ihhrqhan1yf9KonL5cC8Oa5/dV1doIMA4mWGZhzxWn9T8Ksh2p1PV2/bFPVZsxlxZsLyFCbIItAcYtHqhrIy6M+LWU7mB4kMfE0rXCIhSQI7ukxKbEuyYUEo18WUSWHCCzfn5DhKcUXYoiiFSCKJaM/TRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be73Ve+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be73Ve+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE02C19424
	for <linux-cifs@vger.kernel.org>; Fri,  6 Feb 2026 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770390588;
	bh=VQpGvR/EQs8HRIQ8AgtJsCKAMsKXllPdFMudlJHMHA8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=be73Ve+ENWtCNS7yW8KdFq/lzRHo0H7QmE8YV1ZFqqb92h0H4fM+8Gl/1Lok43wcL
	 +5BatwnnIs+0Jx2K+P1pfJC2vO/ii8UMaysrZO6gnV7GVv1kq+6rcKAxyfRmCSwW0U
	 lMMxiGlBIAY6y2z3H+wpWXsWn9j31sgWbklQAoPSjD7TYy2RNg+IaFTgQscsEYZSPl
	 Jd2056SGSbeFgJjfXKaBZY7zagBfp5QbHIv+F0teVBXL+/iMF5a4PY/rr74EWS/l8r
	 SE87uKh/eIiyCzHyNZWRCcZIxl8KFEbvxNlRER81hzrmEs6HvlhY7YVDQ8V9vzulK1
	 iUbOR5M8AwZhg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b885e8c6727so22312466b.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Feb 2026 07:09:48 -0800 (PST)
X-Gm-Message-State: AOJu0YwtZVNwy+Af5cq51m9JmxSkwcpY68XnFTNC5bd4VmgzBtQ9QTnx
	uaClywOa3YBp6/w4rlLG2ok4yQ/Rb+b0rEMquA+BlM9Orwl8/lbuXpvndmVxYCCQSTwDZe72hDs
	YB/+RpxkmvPztDLv2DH1IleXiu6H0XIM=
X-Received: by 2002:a17:907:da17:b0:b87:105f:312b with SMTP id
 a640c23a62f3a-b8eba228279mr427984266b.16.1770390586929; Fri, 06 Feb 2026
 07:09:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770307237.git.metze@samba.org> <2e28ef145e4d88216e52f156ad592085adc55e61.1770307237.git.metze@samba.org>
In-Reply-To: <2e28ef145e4d88216e52f156ad592085adc55e61.1770307237.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 7 Feb 2026 00:09:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-FraxgAm-yO6dM5XZF_MgOS0JzHhfwqVTZA1NkPztGew@mail.gmail.com>
X-Gm-Features: AZwV_QhxOAPxHJ9fy4uLXn8WyYakssgDA41WnR3PqKnia6lXsfokCGEyL-uHBnU
Message-ID: <CAKYAXd-FraxgAm-yO6dM5XZF_MgOS0JzHhfwqVTZA1NkPztGew@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: server: correct value for smb_direct_max_fragmented_recv_size
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"

> -/*  The maximum fragmented upper-layer payload receive size supported */
> -static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
> +/*
> + * The maximum fragmented upper-layer payload receive size supported
> + *
> + * Assume max_payload_per_credit is
> + * smb_direct_receive_credit_max - 24 = 1340
> + *
> + * The maximum number would be
> + * smb_direct_receive_credit_max * max_payload_per_credit
> + *
> + *                       1340 * 255 = 341700 (0x536C4)
> + *
> + * The minimum value from the spec is 131072 (0x20000)
> + *
> + * For now we use the logic we used before:
> + *                 (1364 * 255) / 2 = 173910 (0x2A756)
> + */
> +static int smb_direct_max_fragmented_recv_size = (1364 * 255) / 2;
>
>  /*  The maximum single-message size which can be received */
>  static int smb_direct_max_receive_size = 1364;
> @@ -2531,6 +2546,29 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
>                                   le32_to_cpu(req->max_receive_size));
>         sp->max_fragmented_send_size =
>                 le32_to_cpu(req->max_fragmented_size);
> +       /*
> +        * The maximum fragmented upper-layer payload receive size supported
> +        *
> +        * Assume max_payload_per_credit is
> +        * smb_direct_receive_credit_max - 24 = 1340
> +        *
> +        * The maximum number would be
> +        * smb_direct_receive_credit_max * max_payload_per_credit
> +        *
> +        *                       1340 * 255 = 341700 (0x536C4)
> +        *
> +        * The minimum value from the spec is 131072 (0x20000)
> +        *
> +        * For now we use the logic we used before:
> +        *                 (1364 * 255) / 2 = 173910 (0x2A756)
These comments explaining the calculation is currently duplicated in
both the global variable declaration and inside smb_direct_prepare().

> +        *
> +        * We need to adjust this here in case the peer
> +        * lowered sp->max_recv_size.
> +        *
> +        * TODO: instead of adjusting max_fragmented_recv_size
> +        * we should adjust the number of available buffers,
> +        * but for now we keep the current logic.
> +        */
>         sp->max_fragmented_recv_size =
>                 (sp->recv_credit_max * sp->max_recv_size) / 2;
>         sc->recv_io.credits.target = le16_to_cpu(req->credits_requested);
> --
> 2.43.0
>
