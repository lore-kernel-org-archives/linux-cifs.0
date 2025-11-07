Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9731F305940
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 23:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762557231; cv=none; b=AoHtc7W7Qk0uoohp4dGERZa33ISk4E9tkYzKoEz52EigtlrCv/QHzwZF5j1DcycxdLiUIUndTSGWSWcgl4fI0eQO5DMj7y7l78UqlF1GGxxdqECo9Oow5wRnNoB8R9i3TD+BdKqXqaWYmtVdr90iaxbrkXILjVmaDiP1vwVZAMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762557231; c=relaxed/simple;
	bh=pet8rWW7aUiDSviXBQsmh4R4tyWYtu9DVNq8R1EtPXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UFg8Ton+qYHIbifusrWaYX6CLt2mgOXVKJmMgXOIhEjjDAmDHidNxLncsLqOYxHPtox5OEtOz+OyqHL94oEoyadZ8bg85D+rAbTG96GTh6hCOpCCkg2lLndak2Ja2eU9PNWeMI9xXEyG40ibZ//MZfprKq5qB3tdbq0X/YU+4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Shu2R5w6; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Shu2R5w6"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88033f09ffeso13530366d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 15:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762557228; x=1763162028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kt3D1TmcP0AJ6u8sCwidbX6WgpFhU5yRA/oCNK9E4NE=;
        b=Shu2R5w6TUnPQ32VSX5Qy2aoLGfaa7CJKK+v2Cp1XMfsiNFAwuJuhCiG5jBMW+Q64J
         bnlQNnTRBppxYbQ7B3172jB9RDdHlyGEe5tHUsMZTLRGuGxAOd6g/sr3Avwyi1Bw+YAI
         WZlg7/sgcYqncn+RRGkjy4FS9JTGYpEfA81PRNIJK6vbbAXOVXY2nrwe1aAkjIGtch9Q
         a5lbqEEIH5fHeG9eJ+v4ScN2m6HJ2I4R57ACVazWpufyoHjBIC8QfxbvugpSjavjScr8
         +AkZ2VRisoRMydbE0Xm+8xcJrrtsWr+qKGEzjp1cuMOr0zvcP6sTEBXrI20Qxg+6Y2qx
         7DBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762557228; x=1763162028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kt3D1TmcP0AJ6u8sCwidbX6WgpFhU5yRA/oCNK9E4NE=;
        b=DVwe9rI8H8HiybMU9AljfhZ74s3VSH9TcRxdXxWcTL3RbD0y6drzf56jBd5vauk0l9
         skzKUv7aZzM7z5QxRZ2CX2UeGcR0xuFwrYvyFwEFeMTXg+TCkDBVCQwvsO5CpivrROqS
         GvhyL7xVsoKEBpp+1DuKFwlpUNBIhFE2Tn1NXLDpEPjR7NcXHFpdYnzUPrmpzZ9iQzGF
         b5qZvmTB4EQQbifh0MrQ3vNUPlDA4W0AGxaLxk6/Nzjv1STjs4w1SwwxN0IKjaJac6hn
         gcK/UG6O5tJdmSOO7jQJc5p8mlJTkaWeKsglH35T7bq1yLbpSQAbBqOxNWYs2ouEy0ii
         c9Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVLFq6MZ0rbZ5keagfv3YgwF7xw5p0p3ckmeTUZZF9eCslk5xZ6oQSpdGiiMm/11HZMj+pT1PWfjSCF@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8wvPIRP/VYPbSLZB+oBw33ft0c6XijZaK58cQIkd9zXCxeTcl
	15X2yw0f+e6Jsy4w7VgvLDi2GtRe+0tnb57jtzG+Tep0Jfly4LL4ZGvENVAU2aDjw0yngVkOWPu
	d/2R0tVpSAlDSI+0iAFTItfyqdEBH550=
X-Gm-Gg: ASbGnctQjggBhhNpa4egKH7cLHhajHBKUJKpAJj2ZuLUfKfvPGfWKctznbM2B0LRvhU
	0WVhQqfQ6aqoq8xr9wfnlbBQ7RMLs67qLKBoCEyZwf8StDDLbXCSE6lgGkN9PdbtL7Qm7S+RyfE
	FcM3GX5x8IZr62AHcbd84eLJi4FjpRNvLD8lCyTnInskazw5JZwn7h5hOxISKJUrduiDhajijzO
	elosFK6lpNyJf91Z/8Ew0zGtAj7smyAaWHQS2XLb1mnN2w9GnAmtuqz0kInFiDGhxTcfnN1YJRe
	yLnkElliq8oJtV7z9QtRk/Y2owqCK4WqgvDLfqz0wMXbsqcl/HlSkMefm0mvQVGbKHKHro/e/Kj
	q5QSEHAbFz/Kgqrq+5G/YEXML8dLLn87Ii6rp2feAg2UmkI8vPtdSoNlxdP2+Sc33T++WQZrPaf
	6UN2R83Q==
X-Google-Smtp-Source: AGHT+IEME6f7u2cK0xk+i4J3Df7k5bc3uoxDL+t5ZEmb9Bsgrsi6vgxtaAzbVGVmFKgfpLF1Dhz9bXPrzcLaD63Za8A=
X-Received: by 2002:a05:6214:40f:b0:87f:bd05:1c74 with SMTP id
 6a1803df08f44-882385eaa5emr13302956d6.17.1762557228482; Fri, 07 Nov 2025
 15:13:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107215953.4190096-1-henrique.carvalho@suse.com>
In-Reply-To: <20251107215953.4190096-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 7 Nov 2025 17:13:36 -0600
X-Gm-Features: AWmQ_blDbLkfybLo241VMZrtt-HuKlh2cj6n-t5UMD8aTcXGXVpHn6yT_De7Vhc
Message-ID: <CAH2r5mt979CqEHa8wTEV3U+qCVnBqB2N7fCYynQqE2=214Cy7A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix cifs_pick_channel when channel needs reconnect
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, sprasad@microsoft.com, pc@manguebit.org, 
	ronniesahlberg@gmail.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

On Fri, Nov 7, 2025 at 4:03=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> cifs_pick_channel iterates candidate channels using cur. The
> reconnect-state test mistakenly used a different variable.
>
> This checked the wrong slot and would cause us to skip a healthy channel
> and to dispatch on one that needs reconnect, occasionally failing
> operations when a channel was down.
>
> Fix by replacing for the correct variable.
>
> Fixes: fc43a8ac396d ("cifs: cifs_pick_channel should try selecting active=
 channels")
> Cc: stable@vger.kernel.org
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 051cd9dbba13..915cedde5d66 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -830,7 +830,7 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs=
_ses *ses)
>                 if (!server || server->terminate)
>                         continue;
>
> -               if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
> +               if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
>                         continue;
>
>                 /*
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
