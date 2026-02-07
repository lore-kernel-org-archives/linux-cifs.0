Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469A525485A
	for <linux-cifs@vger.kernel.org>; Sat,  7 Feb 2026 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770449273; cv=none; b=O9BTxE5A9kx63UBsh3KurBm2J8fU/A3qx6rES469aQccXDaaQLrcovAHFml7dug+zMBvCiRdhL7jkSVkIZeQp8P4RE/s3onXYh+VblR5d57xI27nU34DiqL7NVe9GYT7eyuSrWQ/wNHRpl4BEwfbfcnvT/x62iJ9J4DPP9P0cpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770449273; c=relaxed/simple;
	bh=aQdHqtSSWW806Mz63Pr8DLsHfxLzyz/Jaa2SLAKmme4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SDPB5D8R/YH0CBl/eFTwUPZjkh0mIx9Vr4hsyApSnpU0Of2KMkQoUt8+3zSgmilVGj81q51cEykLQ81BLruiCoUrcLGn926SNrmR/B0oysEAzpe3JlRoLHgHVq3ZIV1oHWgCs1G4n3qUh17LkjuxbHswRqORLinO3Tu4u2gGHkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLfUHCRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLfUHCRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34F5C19421
	for <linux-cifs@vger.kernel.org>; Sat,  7 Feb 2026 07:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770449272;
	bh=aQdHqtSSWW806Mz63Pr8DLsHfxLzyz/Jaa2SLAKmme4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LLfUHCRh9cmJ4aXucXKOlYASM5gQ8yxHgsHbQKmxjbtXULUYCR4zDxKzVKyxniuEK
	 PodiWU68l8s95WSluBHzw0pfe7JetAHXO1I40FEKFLEA1yOeSkFWB6xNFR1SLNYkuM
	 dRhojDA261ZkkFXSZupd+sCFVstKjYbHPFP5sTN9tRbbxFI0nNvjzw4WKS57I8VT7A
	 b+ZY2sCLu31sOG50UkJf/8sdIgww6vbJadrv7Fhn67CFO2mUYBeq6GSgn1l8hZeyVq
	 uOBzJfWx0dPd2NCmwUw+YdW6TsnuHOGTSCCCycVecRi1K61MmbFeIyJXu9oO0ymLlv
	 /rfA0Ce7+VW9Q==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-659428faa2bso2184069a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Feb 2026 23:27:52 -0800 (PST)
X-Gm-Message-State: AOJu0YxjUTHYCKDLdvPoeVmTn4O4YXbnIwwkGX34Wt1n1XEGLpFpQMxY
	7i0DZn9ohjl0pVRksLn/vjPDSLNJV1F77QnDTtNaXly3kWApCQDEPfNWkz5aPcZ5ESBdhvbInvv
	t/+ZvUd279OJIE0blOaNz3FZ3E3AUCLk=
X-Received: by 2002:a05:6402:34c7:b0:658:d405:9797 with SMTP id
 4fb4d7f45d1cf-6598415c073mr2843437a12.16.1770449271477; Fri, 06 Feb 2026
 23:27:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770307237.git.metze@samba.org>
In-Reply-To: <cover.1770307237.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 7 Feb 2026 16:27:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd88Hbe+E+i+7GDDTbG4o_dQ3u5RePJzsSvsxxE7SS_Jog@mail.gmail.com>
X-Gm-Features: AZwV_Qjus_IS8-9scPDvrXKmy9JveSGdM95K6xYWDApDm5mcuJVVWtmoJnIM6jk
Message-ID: <CAKYAXd88Hbe+E+i+7GDDTbG4o_dQ3u5RePJzsSvsxxE7SS_Jog@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb:client/server/smbdirect: correct value for max_fragmented_recv_size
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 6, 2026 at 1:14=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi,
>
> here is one additional fix for the credit problems
> in the client, it most likely happens when using
> signing on rdma: 'rdma,sec=3Dntlmsspi' as mount options.
>
> The problem is that we announce a large
> max_fragmented_recv_size to the server, while we
> don't have enough recv buffers to hold
> the largest possible fragmented message.
>
> For now we use the same logic as we are
> currently using in the server:
>
> max_fragmented_recv_size =3D (recv_credit_max * max_recv_size) / 2
>
> There's a lot to improve here, but this makes sure
> we're able talk to a peer without running out of credits
> while transferring a message that uses the full
> max_fragmented_recv_size.
>
> The server patch is basically just cosmetic
> explaining the logic we're are using.
> Note the value of smb_direct_max_fragmented_recv_size
> is never really used as smb_direct_prepare
> recalculates max_fragmented_recv_size.
>
> This applies on top of ksmbd-for-next
>
> Stefan Metzmacher (2):
>   smb: client: correct value for smbd_max_fragmented_recv_size
>   smb: server: correct value for smb_direct_max_fragmented_recv_size
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
