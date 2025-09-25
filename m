Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0143DDC3
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 03:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758771338; cv=none; b=i37e0xnlUAhM84kD+H64NhMDkoEhCSzPkBYI9rF5fMJh5iq7fwxehpoBen+9Co7IQBBcHKhiRsUwfl7DjM4zr4/Cq4dRmXkcLDdYK5zQyTnXWf7yR/X3XyIIWrPUizFlF+OWUQeONh6laPu23kKCXICVoubs8EM1+LBUbJfl1p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758771338; c=relaxed/simple;
	bh=P3B79nJYgC+rmXgtNMai8Yko47dZLILc4ZGiyUzb17A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jDAIgJQ4tPx4E4AQQm/ftSd3tatZpvTVMYWZCrBC97lG+yfNXc5326UnYWtKURDAghyq3K8tQiW/yyWFmleIoQXOei1f/VMErLncLO4iZvVM4rtg1NY3BqCaHFCSbJP7QojlGMDnSr1OB/XHMGmu/KNNP/V5Nwerm8kXxY0sfDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HW2tPRpx; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HW2tPRpx"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-70ba7aa131fso4806796d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 24 Sep 2025 20:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758771335; x=1759376135; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bIK7aUYfmSEbOwNlXiG3VqvRSfHmRXXXHr1UU8T6Rgk=;
        b=HW2tPRpx196Z/MoR7LK/PYo0T1MXWsSBwM1WFMp/LvkK8FI6asseiq2QSU1Xxt4hM6
         ZiTrhVMa0S0C3gUHErFxeDZ1a/CoColrveHFLqxM/+vFuQvNAS6ZBkUL5Xrh+2uRQmBC
         Poc0bjO0IidbrSSnMFOppoFAEkGR3TBGJ5JSG7TpECcSeb/PgDT5Zf26op5moHu+ht5o
         sZbWPwn/Nwi1RzZWVD8PNWW0QIdLHMmHMTrAuiuFBtizrOIePKxfBPqpX/IZD7cUIVEa
         ZhP699w6nFicAoLgxNEG1JEqT5BCbgruAsdENFHgvAzAmC6rcZ3zwFKeJhuxHfJcacEX
         cMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758771335; x=1759376135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bIK7aUYfmSEbOwNlXiG3VqvRSfHmRXXXHr1UU8T6Rgk=;
        b=HZHnQOsum+eisoFg4pDuWJ2twuYtolC9eynnLSNrxX1qg+Z1U5Pph7NDTGV4tkZJ2E
         lOd/Tcyi0RJ2NjX3iWK+A5klWEHyXBeleQ3nJYgYL+fl38JU8tMIwpzschTW/79E/Il3
         dIZKSJQ9+EXUkjfYle3yekD4Kif8vvcHX8vMc6FjtJyqdB02QywFhaWpy33+VMEi+0Vw
         Pem/dEhXKUI5gWdoU1eC7GYRO5fvIH1LKS4I6YAI8zIwH06Kp+393JigIGjyPn4vJ/J5
         ZJVC/hZq70ml1eiRn7bGhK04fF4C6Uq9f6iQ28zPzvEH8lb+gmkS7Wnfe4zg/nCj/Kp6
         X4Pw==
X-Forwarded-Encrypted: i=1; AJvYcCU5OYsd4ztYUjCCJL0150L42t6/NJ66e44n2kBTAhuGyUFn1QTGF5DQN/1eJbbTZ/F+vWRqQOuIVCRs@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs74N1MbE1Q0/dWtM4wlpPv/IRkgDZprlvML67w9KYUsPDyqT5
	Xo/52XwmV1JipGKLV9SrjiZG4qxzKbLlfN4wE4TkKOzOVfCXOzqOhvMnXfN3RSQaVTHfhz9Bu18
	OWGzTjlQJbe8rgrUk1NvmCFs0qTJCzXE=
X-Gm-Gg: ASbGncu4wBzJOShEb3PjvhyLt7wdUYaYLHsNaqQW4GvqfFer6HVHAqAvxF2r96JBIUe
	uVO7aOAHup431NrQb/hnEuH55XlboEd3FxFzWyGIvkRY2fwwauBxJzoVvJIitpCFtxFu6DEEoRb
	5r0imUaIl4NHeg3nEQTim1pXiXQ+2m67QXdzgYSaM61F36Yx/F9BJBbibOmvDYmL0Y4Wir0Q0RV
	Vn1snNMSgpHsQKWH/Y8nhE9A5tkYRwJIi22o+h7yxI0nmrAcEL+6pJ/ocFeHSTG2SRI+fQjeB3A
	IzC52FnCzuEXk10kj+N2nVsDzS/M32l2vyNYR72aEUJQQwD5es16Gwr8T9yUObAAFp3GoySleE1
	DAjBCI+iIpu8VRQ9Pqku9
X-Google-Smtp-Source: AGHT+IEZH9SVd9zNx7E67aDdhvo1VrGsYKoyoHRwQsrcWXJN0UfaGH315HI8D1XGrV+kBCTwmo3R27/OfYmsZ1b5NzY=
X-Received: by 2002:a05:6214:2685:b0:787:907:d26a with SMTP id
 6a1803df08f44-7fc33707691mr30923466d6.29.1758771335479; Wed, 24 Sep 2025
 20:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923191417.237112-1-henrique.carvalho@suse.com>
In-Reply-To: <20250923191417.237112-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 24 Sep 2025 22:35:23 -0500
X-Gm-Features: AS18NWDsftARsDtzivWKVHqtDfJ3cUMPj0Ue2G85HsbH0amnZXjeIfCBcw4PztQ
Message-ID: <CAH2r5mv5LjdD4OkC4SGkywTA4bMu0X7eQJqu4UhJVNNrzL+O4A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: add tcon information to smb2_reconnect()
 debug messages
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged (the revised patch sent later by Hernrique) to cifs-2.6.git for-next

Good catch - looks useful for debugging in future

On Tue, Sep 23, 2025 at 2:17=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> smb2_reconnect() debug messages lack tcon context, making it hard to
> identify which tcon is reconnecting in multi-share environments.
>
> Change cifs_dbg() to cifs_tcon_dbg() to include tcon information.
>
> Closes: https://bugzilla.suse.com/show_bug.cgi?id=3D1234066
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/smb2pdu.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index c3b9d3f6210f..9e3b2cb7b5cd 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -240,8 +240,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>                  */
>                 if (smb2_command !=3D SMB2_TREE_DISCONNECT) {
>                         spin_unlock(&tcon->tc_lock);
> -                       cifs_dbg(FYI, "can not send cmd %d while umountin=
g\n",
> -                                smb2_command);
> +                       cifs_tcon_dbg(FYI, "can not send cmd %d while umo=
unting\n",
> +                                     smb2_command);
>                         return -ENODEV;
>                 }
>         }
> @@ -296,9 +296,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>                 return 0;
>         }
>         spin_unlock(&ses->chan_lock);
> -       cifs_dbg(FYI, "sess reconnect mask: 0x%lx, tcon reconnect: %d",
> -                tcon->ses->chans_need_reconnect,
> -                tcon->need_reconnect);
> +       cifs_tcon_dbg(FYI, "sess reconnect mask: 0x%lx, tcon reconnect: %=
d\n",
> +                     tcon->ses->chans_need_reconnect,
> +                     tcon->need_reconnect);
>
>         mutex_lock(&ses->session_mutex);
>         /*
> @@ -392,11 +392,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
>
>         rc =3D cifs_tree_connect(0, tcon);
>
> -       cifs_dbg(FYI, "reconnect tcon rc =3D %d\n", rc);
> +       cifs_tcon_dbg(FYI, "reconnect tcon rc =3D %d\n", rc);
>         if (rc) {
>                 /* If sess reconnected but tcon didn't, something strange=
 ... */
>                 mutex_unlock(&ses->session_mutex);
> -               cifs_dbg(VFS, "reconnect tcon failed rc =3D %d\n", rc);
> +               cifs_tcon_dbg(VFS, "reconnect tcon failed rc =3D %d\n", r=
c);
>                 goto out;
>         }
>
> @@ -442,8 +442,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>                                                        from_reconnect);
>                         goto skip_add_channels;
>                 } else if (rc)
> -                       cifs_dbg(FYI, "%s: failed to query server interfa=
ces: %d\n",
> -                                __func__, rc);
> +                       cifs_tcon_dbg(FYI, "%s: failed to query server in=
terfaces: %d\n",
> +                                     __func__, rc);
>
>                 if (ses->chan_max > ses->chan_count &&
>                     ses->iface_count &&
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
