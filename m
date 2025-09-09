Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C7E2638BC
	for <linux-cifs@vger.kernel.org>; Tue,  9 Sep 2025 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757388079; cv=none; b=XsfJhXJGcny7BN3as6zY33+OvmOBhmKT58diEWewhNKGdZLQ3imQqS6W3H0Os/9X4hS+TvyAEchyCs7j4hFuvovJPKDD4Jp9z4kBDBat9KhE35cinHcbC7aeTOIzDS41c9jiBQX9dWoTWj1r7ehsWRDyz380r32OM6/tlO+Y6/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757388079; c=relaxed/simple;
	bh=TjvyMu4nJgFvUOMVWMMxuDTtxScDbxUzPGutvqLHVso=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RNkD9Vlpf0WpRHV/DT87WVdTwf6O6uCp/cmm24x/0kk1M/y/nRR193Y9B614oe3MZy9UKxmjUkcYzcbb7pppI565nl5w0zrn/aZqnIPn6EfeapDVc7Hn2M5SXumFnYbA5gTVvYlmoG7TxNFEuRteEST4pOsY71M+QZB8qdeHjX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTfQBrOU; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTfQBrOU"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-722e079fa1aso56975676d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 08 Sep 2025 20:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757388076; x=1757992876; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xM6DAFM+mOdhh6MiwSrl8NGrZTtD5weThZx2/4pTTRw=;
        b=OTfQBrOUHB89dSCzxt24xFYPaa9aPz/AoRCEvNEuXeUEsuSTXn7xRlnP0QQBRQR9hW
         zqwhwbl94bKOiyow/YFGTNlAGO2WXUoFZgUdSfgNL3Qf12Gv//tmYdeppN8XULfPy92K
         EeeoUgOZVAZSrq5ftKO5MXkgOGgdttGgsEXB4FI6JJolXzkCOlJYvRaLaPaxQvDIyIbb
         kEiIY/LcCvl5bxB/eAVch7V24Psj3zieHVdY6mQu4KFRvPAWORFc/JPIpAPx5dMyero9
         aUiDt3yL/eHDs28nRwpsfg7POojR1bYOyLMDxvzjWo/IscyHPu1gBpOVftm6bqEVzYp5
         JmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757388076; x=1757992876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xM6DAFM+mOdhh6MiwSrl8NGrZTtD5weThZx2/4pTTRw=;
        b=EiZOYgS+x8t2yJwSHPbOweiQsMub+sg3Ysmn+rPJULZo+yYt8/9QTAIPecuRZ8L/s6
         YliPge3PfuEki6eQ0+cxV1ENPITISzctsg0KxUX2rXxdi8U+fCV9OvQDjhC3sz/r22D/
         8o5JvxfDsH3Tn99kWxFa3aiEZ4lmOcLiLNzj01+AJATodeiOFR/Jb1cjXE1E25UYXz9H
         xDMB0MkJYYt6XXAsmbpTLQ+r1fZBIsiPoOeF5jEoNax6bHnpIytwscn1mVPbVVGy3KIr
         uQFeL8IXuNB6W9zBc5dw4qpQ+n2Qq8oVCdckzCPCmKGsrkqN02tEh9RvfhCH4Mw/SHM1
         jmHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsn+CuKCkQvCwRkwRgbuXIVHTlb4ywadKKn3HN9e8aff2Ynv12Kq7clMqDo6VEkNK+wV2JL5GdcWyN@vger.kernel.org
X-Gm-Message-State: AOJu0YyUl4KoZSWCLHkp3aLpdt4QMuVRiFaR1qcoCFsVjwJv0+o0FQHA
	p5wyge0La5eK5WrBKOWyXR7fESTjgDgi/6Qnl+koKXw34WoMRGmGc0geQ+46vMM25p8WFsLwWAf
	4dppMhGKDcP+SfMKFooRHolWoS6tygD8=
X-Gm-Gg: ASbGncs4brquKk23pSXrYpYlabCCAjvhHXkFOcb83G3AsDPLgbJpzX/jFzdipZ8GiZY
	fxVg/akaRR8dLgrkWxp8pIqF9PJ5zBT6wgBteBpa353BjoFJq6rIEwrsbBAy9B7ksxof4xTbBDV
	ewUE+qmVVLXSBri64veQqvFbOQ+9ORi9NhDq1HUVDcrJkdgj3vjQvkZbaNZXWcEpruBALJhcxgn
	RDfH3fYBl5r7MJx7xUvZZK5+1/5ASk3uoMqEQH5AvhtIVlxropiDpxsZJxpwSMOAhfpOeURrt90
	YhIPOBu8TKz1FX/kJp/ACK0lts6KnzrIiTu26tyK8VRJZVwCQy3aI8J4XlQY6PtZqGpt24KplmE
	e
X-Google-Smtp-Source: AGHT+IEuHTOEMJEEvn5oTD1uLMiu9JigdP4R59mwysqFwwXQeNdCLjGkN2/g5GKzHarJWvbFDN45Zh3+iIZI+whN8Kg=
X-Received: by 2002:ad4:5bef:0:b0:72b:dad9:bf31 with SMTP id
 6a1803df08f44-7394425836bmr99143626d6.57.1757388075775; Mon, 08 Sep 2025
 20:21:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908120723.1614-1-chenyufeng@iie.ac.cn>
In-Reply-To: <20250908120723.1614-1-chenyufeng@iie.ac.cn>
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Sep 2025 22:21:04 -0500
X-Gm-Features: AS18NWDJYwKBbg5lzDw3_5hRsoi8dJoGyavoQYDq7I9xb44D2bBjeFEytPTlPrc
Message-ID: <CAH2r5mvQM_wWmAjbUohe--eeCgtPcsnxSSP3c_xsHfGDx2v6FA@mail.gmail.com>
Subject: Re: [PATCH] smb: validate command payload size in smb2_check_message
To: Chen Yufeng <chenyufeng@iie.ac.cn>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Did some test runs with this and it failed a lot of tests (see
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/1/=
builds/42)
with e.g.

[Mon Sep  8 21:23:18 2025] CIFS: VFS: Invalid response size 9 for oplock br=
eak
[Mon Sep  8 21:23:18 2025] 00000000: 424d53fe 00010040 c0000034
000c0006  .SMB@...4.......
[Mon Sep  8 21:23:18 2025] 00000010: 00000005 00000000 0000003f
00000000  ........?.......
[Mon Sep  8 21:23:18 2025] 00000020: 000011bf 00000009 6c000031
01814003  ........1..l.@..
[Mon Sep  8 21:23:18 2025] CIFS: VFS: Invalid response size 9 for oplock br=
eak
[Mon Sep  8 21:23:18 2025] 00000000: 424d53fe 00010040 c0000034
00000005  .SMB@...4.......
[Mon Sep  8 21:23:18 2025] 00000010: 00000001 00000050 00000040
00000000  ....P...@.......
[Mon Sep  8 21:23:18 2025] 00000020: 000011bf 00000009 6c000031
01814003  ........1..l.@..

Even running generic/001 showed the failure (and failed to multiple
different server types in various test groups)

On Mon, Sep 8, 2025 at 7:08=E2=80=AFAM Chen Yufeng <chenyufeng@iie.ac.cn> w=
rote:
>
> The vulnerability addressed in the patch for smb2_check_message shares
> similarities with the previously identified issue in ksmbd_smb2_check_mes=
sage
> from 2b9b8f3b68ed("ksmbd: validate command payload size").
> Both functions are responsible for validating SMB2 messages, and the core
> issue lies in the improper or insufficient validation of the StructureSiz=
e2
> field, which indicates the command payload size.
>
> Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
> ---
>  fs/smb/client/smb2misc.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index cddf273c14ae..2b5f42adc401 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -143,6 +143,7 @@ smb2_check_message(char *buf, unsigned int len, struc=
t TCP_Server_Info *server)
>         int command;
>         __u32 calc_len; /* calculated length */
>         __u64 mid;
> +       __u32 req_struct_size;
>
>         /* If server is a channel, select the primary channel */
>         pserver =3D SERVER_IS_CHAN(server) ? server->primary_server : ser=
ver;
> @@ -209,16 +210,9 @@ smb2_check_message(char *buf, unsigned int len, stru=
ct TCP_Server_Info *server)
>         }
>
>         if (smb2_rsp_struct_sizes[command] !=3D pdu->StructureSize2) {
> -               if (command !=3D SMB2_OPLOCK_BREAK_HE && (shdr->Status =
=3D=3D 0 ||
> -                   pdu->StructureSize2 !=3D SMB2_ERROR_STRUCTURE_SIZE2_L=
E)) {
> -                       /* error packets have 9 byte structure size */
> -                       cifs_dbg(VFS, "Invalid response size %u for comma=
nd %d\n",
> -                                le16_to_cpu(pdu->StructureSize2), comman=
d);
> -                       return 1;
> -               } else if (command =3D=3D SMB2_OPLOCK_BREAK_HE
> -                          && (shdr->Status =3D=3D 0)
> -                          && (le16_to_cpu(pdu->StructureSize2) !=3D 44)
> -                          && (le16_to_cpu(pdu->StructureSize2) !=3D 36))=
 {
> +               if (!(command =3D=3D SMB2_OPLOCK_BREAK_HE &&
> +                   (le16_to_cpu(pdu->StructureSize2) =3D=3D 44 ||
> +                   le16_to_cpu(pdu->StructureSize2) =3D=3D 36))) {
>                         /* special case for SMB2.1 lease break message */
>                         cifs_dbg(VFS, "Invalid response size %d for oploc=
k break\n",
>                                  le16_to_cpu(pdu->StructureSize2));
> @@ -226,6 +220,14 @@ smb2_check_message(char *buf, unsigned int len, stru=
ct TCP_Server_Info *server)
>                 }
>         }
>
> +       req_struct_size =3D le16_to_cpu(pdu->StructureSize2) +
> +               __SMB2_HEADER_STRUCTURE_SIZE;
> +       if (command =3D=3D SMB2_LOCK_HE)
> +               req_struct_size -=3D sizeof(struct smb2_lock_element);
> +
> +       if (req_struct_size > len + 1)
> +               return 1;
> +
>         calc_len =3D smb2_calc_size(buf);
>
>         /* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so=
 might
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
