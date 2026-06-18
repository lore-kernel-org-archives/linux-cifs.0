Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB573403FD
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 20:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781815103; cv=pass; b=DD1LB+BiOv1JJ+WgC8j5WpLoj1IYxcA9P3dU5Tc/GMpbRQC7ZBknfRya6sjwRufq3BVymKF9OC8xEXoE55g0Qb5BgFEUY9oFvunyCyEhYRKVB9FUzh5bq2JDdNhTKFOvPWiS4kHHe9ksBgWC/TyWa6kMLKgVNCvJHKZYAnO6/cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781815103; c=relaxed/simple;
	bh=7WSTUoGHGrU/6/+nLs4z71POiUf/UjAJqb690o5xC68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uqx7aC+Zq+ZNWJMMMVcZjhozorXajFF6WGWUzmuRiZblNkIH9khsEwKYCgP9fjTysm1//sdkRChVDoTrIXoxnd/upWMcCJMh6wWgNhj6WCvXuRmZuO01q37s6VCIYTNwOmFhwxOg4IeUYbepywWD4Z93P2Wfd8LScAhJcrZiSbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DLTPt9nx; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DLTPt9nx"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6974ef0c3b1so6539a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781815101; cv=none;
        d=google.com; s=arc-20240605;
        b=Aukdt2bI1lpJ1ExA5Wf2irsVc1XkVxavA2w9A4LzB8dWvpdAGq5PHuKcppUx51z6mq
         zC6LydYJQc9YDmcTlgkIFSPWUzYJyrbDM1S/wNbzXC2i5kJv787Z/VG8xxJ4qTpbYEma
         5u/wCRjupvqntQJm2K4xykDyFZNq3dbCuLkKqfS/NqJnDnI6mzj/j6UxBv2M9xjKU9Ix
         vAbkb+E9dbQI/s0/RN5cJ/+XMYYmHICCfu5zCvMN6UAjjVEfC0hah/YhH9s6TDcmsTKE
         rZvY3X21eZV6QJt29+g4toZ5KAMvXCbsCGdzolH16bO4UvSZaW3UC+9FX9ttwObWNwB+
         ymKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xm8cRsJgKhleptk7QWvSZD4pMUhWO0W5LdjrkZ/1NSw=;
        fh=zzf+b+FDHRblF/v1m5nyQA1KhWDQdBOKREINw7ezETw=;
        b=NIi7ajCAgb+CSxNM+X6Yh8ODDYpWuyejMl3kmr4LtQSTxn9iH+z641D5dA3/vEFb3N
         0ybrCyrVywudDPo0surEgddTwgjg630gq4s/u05n2i2t22QboKY1GYsQPE3JNDKby64t
         fFoXqyA9vXqldiUwoQx/0NljFYXOi3jnHch2Pt1HgF44uGBlUsyuRISeB04p3Skl0ETZ
         nU1WOWazRO/VSVlbD464VIuqlMrHpE80siyqabgS5Ep4tn8LIo+9SRbR9s4uiVx1aDsx
         054GzOFbVV8ymxTd4fsen0ddoM3bHXNfkZ7FceYYTaUOTOznmWclgJmezxzttKwGYIws
         Weqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781815101; x=1782419901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xm8cRsJgKhleptk7QWvSZD4pMUhWO0W5LdjrkZ/1NSw=;
        b=DLTPt9nxRjNosNQCi2ORG4nGjhY9X1PJfYxMWLcnYB3Trmpj6k+8tW5sjtUfwGJtqR
         j/J3ElFc+ThwsSY0k7d8k6XdFAg7t5BOJHz93xTUS81ZuN6feCQNSE+tbyF+sI8G8qm7
         U2QcqwqwOvaXQGSZbgmWKQBAaShZEd04MxWpz8OgZygqfM4xTxm+3lwbCdn/RzpmA6vs
         tBd4ZyKirPK6snLyZIdOELMyGjwdwZ8tHLaScHMwoFNbKD+Sj8pzlVPfUrWxArsgkCr6
         xRQBMjnyldhck6rBXu7S63A7NFtmslvUWAYMLAwbbQqMpt2jxqdBY2srcDKVE66f2S5V
         l/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781815101; x=1782419901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xm8cRsJgKhleptk7QWvSZD4pMUhWO0W5LdjrkZ/1NSw=;
        b=YKJzdQm+d0kUwKtfh11w6g+9vqlLbzRG/PGm/A5J5oS+I6VBhufV6H/CWfgTVKFoWF
         gZTBx7yI6kPIE5Pt4hWPpkoyHsfLwrtHcx4u+GnCtEhnLE3OVvacEcaFygMk18nmVM5O
         LcLsKgHrOvJZ53IqQIFgbj8/hV8eqgIWM3Irpey8KA/4/lixuZAwzAlA1FaA8tiuc7Qu
         OKm5sPvo17MVtQSxJdmOAx26Iu+9/Can57+PJ56zh8jpOix3Pz8r5A4tf5YpxsJ/l0fG
         hMIn37/Pqco7MicyVFaoyYk2XuHJMEfn9r2SmseG0wga5Y+94PiaTwwB/7NfGXxSyDEL
         Z9og==
X-Forwarded-Encrypted: i=1; AFNElJ/FNzFEx8QiZaJOKGvVxc478Vdo3INqSBFbV96Sn06mSDsghq32x9fbmnsCXfxLzUiYUT1JuEIBYbIf@vger.kernel.org
X-Gm-Message-State: AOJu0Yywsxq6LyWRNJRKo9Wri9m9AkTtSGAtpXN9/1GUXYq22An+v89a
	oki624oqcZp2mVDrDhrsaT8xwoS+B/eaQiLDIaZowzQ8BgB9nr5X/q/OTtQVrT57RBuwDqn31Zo
	gNiYhLax3OWhnrPymB5B612K47dcec7chHQYAv42ef6ZOr4Vj6jX8rku9/w==
X-Gm-Gg: AfdE7ck6xB5wJNlWCvCaLzbZaMoxCY/e2K++H+ZoE6GwbPbZgHC+3TM7Q101zHtTJmL
	OZPRNP62mAB8HRnwCDdjtjGkWf0crrCmAJp7Y/wOX9A6HdIgncM3qqnc/LdHgS88LZ/njQYgSnk
	qmuARpv3PStebzKcuqlOK+yaPA5liKcvKMXLT3ADEoh6RZNAwbHVzJ+x28ChZHPDRC9lvL4l5L8
	nK7fKaNVaIYkpftv/r1G8i1qj2nUpZocSomr8wSaNQjkI/T6HsTn8m5uDZL621/XbNcu7SSZf4z
	4Y7s1eknV3wUwX5AyzFeEAAgb1Htzg==
X-Received: by 2002:a17:907:1b21:b0:bd1:fe8f:59ab with SMTP id
 a640c23a62f3a-c097b38990emr40815566b.23.1781815100536; Thu, 18 Jun 2026
 13:38:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260618203438.667881-1-henrique.carvalho@suse.com>
In-Reply-To: <20260618203438.667881-1-henrique.carvalho@suse.com>
From: Henrique Carvalho <henrique.carvalho@suse.com>
Date: Thu, 18 Jun 2026 17:37:44 -0300
X-Gm-Features: AVVi8CdBZ_E0i9YbxKFz2PoQTR3SZ1g0hIyOIDRZ6GXVcGF09H8qjCXH4cZ5BRY
Message-ID: <CALihoepb4m4xVDKN1-x-5Kr7nSwHJufS+_KYsdWoRYvad65vvA@mail.gmail.com>
Subject: Re: [PATCH 1/6] smb: client: fix double-free in SMB2_open() replay
To: sfrench@samba.org
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just one note:

If free_rsp_buf() took int *resp_buftype and did *resp_buftype =3D
CIFS_NO_BUFFER after freeing, this whole bug class would be impossible
AFAICS. This could be the fix, but it requires more changes.

On Thu, Jun 18, 2026 at 5:34=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> A response-bearing attempt can return a replayable error and free its
> response buffer. If SMB2_open_init() fails before the next send, cleanup
> retains the previous buffer type and frees that response again.
>
> Reset response bookkeeping before each attempt to prevent the stale free.
>
> Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay =
flag set")
> Cc: stable@vger.kernel.org
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/smb2pdu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 318559cd00db..4d6a989748f9 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -3305,6 +3305,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>
>  replay_again:
>         /* reinitialize for possible replay */
> +       resp_buftype =3D CIFS_NO_BUFFER;
> +       memset(&rsp_iov, 0, sizeof(rsp_iov));
>         flags =3D 0;
>         server =3D cifs_pick_channel(ses);
>         oparms->replay =3D !!(retries);
> --
> 2.54.0
>
