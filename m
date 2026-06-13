Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDCE271450
	for <linux-cifs@vger.kernel.org>; Sat, 13 Jun 2026 17:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781373146; cv=pass; b=cIN8UaaJ9P5UTfOpyzhnVzmKcGdlQH4shIcUiyWMOJoqYrt8YEqEIcDVGz/8IJmS1MDSrGC0Ni4FIsWirOEW9TNEdBzTn7JFIEqy8w3z7MTmaa1Mc6y1JIKbjX0WJgPft4ch+/E1cAFLh48rKTFi7Iu7DfD4GUBXTcXwiK4QAd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781373146; c=relaxed/simple;
	bh=oPyb0QIusLKLe1VTEUswUezwdvG8zbMH3cL8AjXEh3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=URqvD/4ewAgihgVbDGLnSOX8++TyDeM3rXLeI3EJlOv4FLLwwfTjx6NXD4FrcmoUcscwTNLUnUYJgb51Wryt82aHEcA5gn7ZWwjV7iFvg0N5yF9iWzoXwSzUKPvtd3RK3OKmsily3SEV7YK46r/lu1BJuil2Tzg/twJR4R0m/5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iZGRkovZ; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZGRkovZ"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-517b1f2c6adso19539101cf.2
        for <linux-cifs@vger.kernel.org>; Sat, 13 Jun 2026 10:52:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781373144; cv=none;
        d=google.com; s=arc-20240605;
        b=J438FQ+h/F+nKiZ7J1SuQhI6eJtxM/qA8FC9NdNa8HVdumGFco1GnXbM+a5IHYRfQn
         DJECxK8j/Tbn5HWGzCwTalHKnikN9DdpfyqMxGeH/LRxVQHEu9GvAsnQTcRvwYppwstC
         zTWYW75kEsJ7naBWqGR1xOWcAwJBp3d9TiX+pGNa/s5gIp98+lh0MKX6/2y/pmDKsLMJ
         GIgzBH8G9SqdqK34hnPznQxLShlL7o3uyPX/rHxXrqqevqitOb0ZBqUZ9fdMOV+OwuEa
         7ZlzZO4fpNZ7af3QLYDbZhCAktd61zht0AtRiT9v4eFjbMOj7tQilFeyrdmNKbvAi4TY
         mf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mn+CuNpS8z+VZDajYXqmdYYU31t3iBNBoN1HnRgWcpI=;
        fh=LoxB1xUDBMOp5bQsmfNQrEHO2zd60vmBCtRr42BZgD4=;
        b=N4OqogIgmBAKnfqC9lpfmLh5qfMBFLcl3ad7Xuedyz1Bm1TKoBjHUXa5ZVawQ0o717
         A+KimkM7nUwqSREn8bWJWYwFZXfZnzuWYTj0mthWQ2OAYLnIGPF5YM3a3IwfXMgCAsNB
         ulGCJmaunMFHcU3yNhf8MJHrUPwm9tR6j+9jEv5EKxKQLBz6Vsuk7V5dqtMnNVyaiTGC
         /JwhXZYtW7q5Q0kjM9zL0/yyzBHMKFF1PUJvBLaDJifVDLHfhJ7ei9dKL9JwBZgXcMIT
         Ho9dmYsjZdr+xUFHJn+oPv5Qvxp3EvuCi7NTvoX8EfW/s0Sm0Cv1qGKhMjHOaAMeeLZB
         mshg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781373144; x=1781977944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mn+CuNpS8z+VZDajYXqmdYYU31t3iBNBoN1HnRgWcpI=;
        b=iZGRkovZyRwfIBY/Z7sOPtmDTdEHLxy61j4a/BJ+ke1dvVH66SF4p0y3Af+K9wIAk7
         +GvygH4W4fWrxFh/ia5XLLSWKvdGscoW7kI/V7dnuvemW3PvscFrFtsenJjGbL+RHuPl
         YclOTw5vvfMUY+Jbvo1qdjrP5rx9i30FpoM/OkyMzQ3zQOA5MfWeQK+gX0v4Cn9Nj4xF
         JkbI9MdS/ziK528YTC/HuUhIV1LHOMDGpi5e3C7+AzGcaoAp7uUWjr3O88v7TE1j0njS
         Kjouslwl7/BEI4WFgBRdROw72FjX4ShPseaTU62Ggk4BrOmJNM06TZhJAICtniBpkqoW
         DBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781373144; x=1781977944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mn+CuNpS8z+VZDajYXqmdYYU31t3iBNBoN1HnRgWcpI=;
        b=MkPkBBBimS171KDSLlBhMrhqKyokvXrEB7NLD/M4Y9h2nPP5x0pWa/KdpoPtY5uMe+
         mEvQ7McQkeahuXUCG1wqPRpr+rLa0vRrxe7lsDbxjr4SAPTePsUl1hx45gxlqevc63HA
         RcTHyKXFP9oy5BuZM3nQ+s3btcqkYOpIuHLZANsy9Iz5xR8jMLg6E31r5SAQSE2tBKnb
         8HfzfgQVdXgGTgQi+LRnfeJgzG9arNlhVD2H/AnjC2Sc6+/c0aZsiy52x52r9lHuDk/P
         ehUHSEAYqb7l9VXrFZIl/30hVV5M7VWz3p/Gwg15Z+uztCfdIz5Jm2qOZEbO4/jtNzVs
         R6Cw==
X-Forwarded-Encrypted: i=1; AFNElJ8sJyRdKK4XJk8UZCSJbplKKedfSNZd9CHYpCoBDnYDxQAl1C1BW7Z3Mm1YJ3EKMRF1TqaujhQWUgX7@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl7lUffDp8OfGK3g+sND2VQIIoboOSWwoVHjOPYzEiif1tSAHY
	NiTWoXQFuAqlmuqpowxomeelXYLxo4NP2M/VDYMo+P9GCmN79QZc4e/afqu7g7J9GR414l650C5
	At/74EJXlFc47xWvzTdxnV9IJy73e21g=
X-Gm-Gg: Acq92OGMSCrQwP+HYuPaqydOAQs+P3Wi6VzxKR0p8V4yO3YbowIDa2wFffmn7uEycE1
	2ZjOl77BvYtFupdK59z0dNOFk5X80QZCeh6nLvUEqPgi8VyaDj2XzaKwCD7AaOsT2LBezRO8JIg
	eOcR7jTxFQYYOp+wsXiwxVFAUUJODZDkMcJsyLJmfvG0vJ0+g8EiE1ogYsmM2wVPQKgfHVVFiB5
	G5LIfi+aMq6B45RwDuG9qd6Vl6DmQOfmnycwWcNTqrS3E62bSmQM4hVGFeA6JZYmkhs0KCde1Im
	aOwNjyNYoHhErN6aG+fHAZHvFWJVn5CGRHzcnetWDXVr2VMnEo345gc1Fjv8SKgxvoyAn0CyFtt
	u1EHVqrTOAZTKTWxdJY/9j+wLoOlylDdRSdkUEyoQQvkz1MhSIdsrRLl21xuCgDI2TFQxqMMrY6
	BLa6jItnZK9Mu5jEu9JLxFiw==
X-Received: by 2002:a05:622a:488d:b0:517:9407:5c36 with SMTP id
 d75a77b69052e-517fe578a22mr116819211cf.53.1781373143637; Sat, 13 Jun 2026
 10:52:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612024647.656382-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260612024647.656382-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 13 Jun 2026 12:52:12 -0500
X-Gm-Features: AVVi8CeDah8uh1K7iwfo0O2tx9iL71K-NkH3a2Rdz1YKlxN4XmiTlaKcBhtOvBE
Message-ID: <CAH2r5muSaeXUVc5MSw-mpse6AaN=6w8PYKO-iU-mqH=3a9basw@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] smbinfo: update notify subcommand
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to smb3-utils for-next

On Thu, Jun 11, 2026 at 9:47=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Add the `notify` subcommand to bash-completion.
>
> Fix the following warning:
>
>   ./smbinfo:963: SyntaxWarning: 'return' in a 'finally' block
>     return False
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  bash-completion/smbinfo | 5 +++--
>  smbinfo                 | 3 +--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/bash-completion/smbinfo b/bash-completion/smbinfo
> index 52e6821..3f1f9f6 100644
> --- a/bash-completion/smbinfo
> +++ b/bash-completion/smbinfo
> @@ -24,7 +24,8 @@ smb_info()
>               quota
>               secdesc
>               keys
> -             gettconinfo"
> +             gettconinfo
> +             notify"
>         case $prev in
>                 '-v'|'-h')
>                         return 0
> @@ -33,7 +34,7 @@ smb_info()
>                 'filefsfullsizeinfo'|'fileinternalinfo'|'filemodeinfo'|'f=
ilepositioninfo'|\
>                 'filestandardinfo'|'filestreaminfo'|'filecompressioninfo'=
|'fsctl-getobjid'|\
>                 'getcompression'|'setcompression'|'list-snapshots'|'quota=
'|'secdesc'|'keys'|\
> -               'gettconinfo')
> +               'gettconinfo'|'notify')
>                         local IFS=3D$'\n'
>                         compopt -o filenames
>                         COMPREPLY=3D( $(compgen -f -o dirnames -- ${cur:-=
""}) )
> diff --git a/smbinfo b/smbinfo
> index a6095e1..d6c30f1 100755
> --- a/smbinfo
> +++ b/smbinfo
> @@ -306,7 +306,7 @@ def main():
>      sap.add_argument("file")
>      sap.set_defaults(func=3Dcmd_gettconinfo)
>
> -    sap =3D subp.add_parser("notify", help=3D"Query a directory for chan=
ge notifications")
> +    sap =3D subp.add_parser("notify", help=3D"Query a directory for chan=
ge notifications. Press Ctrl+C to exit.")
>      sap.add_argument("file")
>      sap.set_defaults(func=3Dcmd_notify)
>
> @@ -960,7 +960,6 @@ def cmd_notify(args):
>          pass
>      finally:
>          os.close(fd)
> -        return False
>
>  def notify_thread(fd):
>      fmt =3D "<IBI"
> --
> 2.54.0
>


--=20
Thanks,

Steve
