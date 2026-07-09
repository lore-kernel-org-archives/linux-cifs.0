Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0B83D3337
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 20:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783630448; cv=pass; b=ThxKFXzqxJc01J7ItcjsZbwQ4FecwgAU1JmO1RDNNI43ceDZFzfM5tSqGYWsjenCkiH7lgqvku7+bALE2fXV5UokGUZGMwdD/sXg/jEcKnZaqh4lsUwxw9GnIJ7tqCfdrf+xrzmF6J1pktiY+RTdQl7h+yQZlwNvwRn/c0R2IbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783630448; c=relaxed/simple;
	bh=6CpaLGU5EUy0vMVHx3KnNb4rh6my4kZN9Yxb54V1PDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bm+1rIoKJoRENUz9E6dWvrgRXoyHHhDE79xMlsFhbxzLxWj8jASTY7GcWoKmwacRs0d4BM8ZtqwqIjUUe57LuvnLkfhJesqm03f/m0UXuQfa3iwg8tz3YrXoDdsQqPf7Bnukeso0e5WE7SaG0zJreuIdJMbz1Oe/ZAoLLwKJP9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rZtxIq3u; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rZtxIq3u"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51bfbe05683so1332631cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 13:54:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783630445; cv=none;
        d=google.com; s=arc-20260327;
        b=F6si2FtiB3OadaJKLbhew4g+GyG69OnF6P+Ud4J4eENbgshKB8MWL10zc9JzfSFA4Y
         9aorGky20QKaxUGshyVzNMyUhDSzc/KEg5ts6NvZC0+GSP8iBs1fa7Jkq5RCNdTllree
         RdDJAXQ56+cfFtjAM7HDxTtRwDI8ER/HCThMFB/zHR9G1spMbXWMtD9c+PJiDEiDOr+c
         fv7YLg5jH3wpx05jGHvroWEdq5EphKetZDuzr9GquEJ+rtG9VzDoBMM9Xco6jnK37Ht7
         6AwAk55ION7KM6OsOHYwLpYRwLHAZvwmqwROYvRAYXJotR8s0RX9x4sjnVUi3tZOXfQv
         GV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x5evxCKgLnEs0QTFditB/MvAAlaTMW3SCAomkp6FBCA=;
        fh=H6RCowqLNHRvxc6IiH6RZRq7LQJ7PNMrfj5xiJcoU/k=;
        b=cBULijmGTcYpdIMzfv8bWvnS8YjenWJy9JsrnIXNv9VDeS9PHgRLPqNHv1E+zZ3UHa
         yanY+j+/SIzkvyYAZHYFUZ92ehu9lT0p1MgnvTASyz5o96FdN0ouoJbOCvFyMqPz3bWF
         p3x+dfyPo9UH9TOIzXomjgBI+0z7geIhp41/EQq0JkOupHHJw5MJL7UhTPkG6OYEpWF1
         5ku+OP9GD/CgfGJoUYQLZffjGZjbDtShjPHai1hinsysk5HIGARwN4a8I/vMADK8j+Km
         a2fF2c4yQBk+KI/P1wf7g55P0Ps2gNppygoiI4fpKgd0o9Bc5Z+B6DtmqotV2yMiLD34
         vfHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783630445; x=1784235245; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x5evxCKgLnEs0QTFditB/MvAAlaTMW3SCAomkp6FBCA=;
        b=rZtxIq3ucANik3O6tyHtVpY3ik9fVH0fvBT4g2sfeKyXnH5FGpn/CZAtH8O6wU9ywk
         E5742fXSo0Zr+VEiqyPWRTUkujF4/hK/Rg2/FJi/GD9hPiHLuTp0Ede1OoWculBEsUtG
         Z/OBROWxtThsbwncLzq9OEUGI3aqHMySO+gbup0foDTiHAHcG4hxKldx8/q/Gq1BMAyb
         E4wBO5hQJxIVCyYfxP9sFWZwEQiirKMq0f2dL5gN0T+y6LOvmlaeAMxLe/9MSEPH0aSH
         8eW7deSw2st2Xf3KXHRKSOapxDaQZHN1sqQ3utQlozkQsZUSzf1MzWIP8LZKI/RuePtD
         yelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783630445; x=1784235245;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x5evxCKgLnEs0QTFditB/MvAAlaTMW3SCAomkp6FBCA=;
        b=Ab5Y7rKOVbFszVrGUAZLkM+FgqsE4j0jUghscjZGCP/MoZ/mAxPQtv7O+dOibb4Yly
         4pivIPOV2QHr2t/BSZzOcGxRTTlVaBi41qGSndKovSUZiLN8ZIgbSXKlSRDpA1Vs0UJD
         ZgyPuDEnwNf1oxsIpfCiMqBoClNwH+YTN6BOiClkg2ME/fYjt+XUyoWvDi3/h6K8lLZf
         ZA6fZcV4QoHUbPbKCIR9Va0b9IzuDneslfadahpaZpFFKutzdF3LYEJ11UQ84sNF85vz
         BKbast3MlE5iCFpB+ehEgx0DKuOSLdSB3RE2VCdYyRuPUDTQcRhuOrup1tNjhJjKPLX+
         /xwA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/rT4rM7iGgdG5I0400+5VLUqqjR3C4cy7HSW0oVfZFG5uRksw7fRDv5ZAMDU2DKTmxduiN9ja4qr0@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh4DLOXAbBHQ6JSfGWogg+ZOL/6TFXqDR+b/dymCPs0QwWc3xF
	CQkMoRyvzxs5uTU7/4SxucLpUedG0T3OT1PMeLWqU1Sfkpc8wZuV/5fPO9YQV0WBP2hLrWsUHSY
	x4YOEx6lxPURHU2B8d1rkFn3LwNojOvk=
X-Gm-Gg: AfdE7cnECkTmsJltGNHZhNnyfJPM7K9o/h+CERk0spDtVqBT77U9CLiEqp0LUeNMq3N
	xdCceBF1Hk6rKESrybA3smJEffn49fOiRxzVp8cMYE6d0TmN4zDC9xYVxfmQKtMkcgoWoHEI2Ls
	iv0h9VoGv5W46m2CVxhmlicAEjfVsD9zzIjXz+QY1GBPjBb+KKys9lj94WbrbVEBgoLZivR9MNt
	R0Dg5VmA3Ke4Z1PidFWlef842AhSVnNlfiPilHw+hMhIdJdnbLlrBmSfFuzBj/5MGp5t4RPaXfC
	gqAOipLqVsRhTDaysCBhNJIXFdY9UGMSjI9WRrCSNImZvel6Hf5yYp9lcbazbEL/k4dMb6aHKvs
	QQPeZlxmrWetswXDmaDKjYC+g3KaTgs6/Z9jZNFKgmkIulO/GZyo+wLrUxVSa0PMV+1G2BvXUpi
	BtCgrPgn0cVbI=
X-Received: by 2002:a05:622a:4d86:b0:517:906b:c043 with SMTP id
 d75a77b69052e-51c8b30194dmr112033741cf.36.1783630444769; Thu, 09 Jul 2026
 13:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709155440.2132459-2-doebel@amazon.de>
In-Reply-To: <20260709155440.2132459-2-doebel@amazon.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Jul 2026 15:53:51 -0500
X-Gm-Features: AUfX_mywyJw7Jb2CzVjlGHcEYnBTz-s8FGewaFQhIIMmJBSp0jiEvTm8UOBbBuo
Message-ID: <CAH2r5mtg=Ko8FMO0dkTw72wu8rVJuC312bQ9QKUyNaL3gf_wbA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: mask server-provided mode to 07777 in modefromsid
To: Bjoern Doebel <doebel@amazon.de>
Cc: Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, nmanthey@amazon.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Thu, Jul 9, 2026 at 10:55=E2=80=AFAM Bjoern Doebel <doebel@amazon.de> wr=
ote:
>
> From: Norbert Manthey <nmanthey@amazon.de>
>
> When modefromsid is active, parse_dacl() applies the server-provided
> sub_auth[2] value from the NFS mode SID to cf_mode without masking to
> 07777. Apply the correct masking, same as in the read path.
>
> Fixes: e2f8fbfb8d09c ("cifs: get mode bits from special sid on stat")
> Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
> Assisted-by: Kiro:claude-opus-4.6
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/cifsacl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index 6d572dd995d79..a0a68404fbff7 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -962,7 +962,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *e=
nd_of_acl,
>                                  */
>                                 fattr->cf_mode &=3D ~07777;
>                                 fattr->cf_mode |=3D
> -                                       le32_to_cpu(ppace[i]->sid.sub_aut=
h[2]);
> +                                       le32_to_cpu(ppace[i]->sid.sub_aut=
h[2]) & 07777;
>                                 break;
>                         } else {
>                                 if (compare_sids(&(ppace[i]->sid), powner=
sid) =3D=3D 0) {
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
