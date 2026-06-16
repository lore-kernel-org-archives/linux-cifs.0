Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA3B40B398
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 07:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781595459; cv=pass; b=uWh9ONTfU6Vodn3AHs8rgYEw7oKx5I9KjQymjKVBzqdAReB/Y7iSexSV03QvEwjHR2u3z/j4tcYqxULP4xN2kBG/YhJWetBpmu/3/+CEwhP8HdIQllx8lDLJxY9iLdKorXDoyEHtqKW8ZRUXCvqKaNoNOlEP+J5ugvprR2c0JR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781595459; c=relaxed/simple;
	bh=tozSY0s2M4MKzC0xYDT3vbOli4RDvCLiHJFHZavzPCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W2YAsXEy2sYyaM5OHd4Ng+PiWW9Zsqlm14iqRjPk8ut4byoGlK2HYjdzzs2RheeLiY2sugb7NLturUrMhr4XLHcSSqNr7xl4AcBd8rZ1KAQMrfiEqU28EczUtwEwGUYn20GDayDPlD/7f/m3AzyQBiv3cN7Uh2YHd3s7grIdFxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLoYNPQY; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLoYNPQY"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8cd45d4b7e2so51257826d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 00:37:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781595457; cv=none;
        d=google.com; s=arc-20240605;
        b=XiufuInUX+fv2I9LDmZKdliNcQS1ZYhWdWpEpDWHHu2Qc1z9Cwt91VTkB0GcFAZ/cU
         xOuGePyjBJm3FECPG5W4ewy5Hm5ugvX7a3qUPnjyI8tLOzsu9H9wRiMSJOVJyQW8olW8
         Rt7CY8mDO0OfAP+KnhiN1E8R6+GrTY8ufL4JI5SuT79eSHak+LJVUCSFIKwHNoVxHeIl
         ApPtRDcsyp4vIxLJPrRoEOjZ2a5+0H8HYA7EilIh8RC+A0GGkIb4q7w2vbCeuWlzl2+9
         WEV/OrA0Q35c6qyw3ykENcHTQEMmnJ9k/UB7s+TADKvT2rDfYtWeJ+T1hEdlAvFAzKb7
         xshg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nptm9W4b8Xz0dBqBPsQS5dqUH5HS4b9vdtPB6TKu2Rk=;
        fh=WkSMKs1cAkjmBqyClNDEtWhaGL/cV5putU8yeScfGOA=;
        b=FOMyk1ymcrhgNUKJ7f95vcpdbuQ+Goh84mVxtnLSfAa12lwxLLUeIRZxlzIAUgiylp
         xMJHcn+Ez8IB0lYZdvFEcGLhIdOt2tP3maawKqRa0p6sgmTU8cRcHgLZy6JUQNgcyOoK
         /UOlzvSRNx1k/on+f/+xJ9gLyw2ImeSofbY+Q6+A6cGLmMD/tqfS1RZpWs6NkBOVNwv+
         glGrXn3MijBp4HnYb40Kl1oXvx29GPtpYP68shGXGlst+lq2gNk6+Z50s/nGHKqfYYbU
         AxzI6AZeAVbiPkg1JW0Pe4L6RkizsIADopNEOuKdlPdDfyV2AiiQKj3xI0Y1hi80QByy
         XH/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781595457; x=1782200257; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nptm9W4b8Xz0dBqBPsQS5dqUH5HS4b9vdtPB6TKu2Rk=;
        b=XLoYNPQYKoGHiSSTFe8nmrXslqOMoiMQE7FGV4t3p9TA88IsItf/kL+xPsG6chWNHV
         X96JpmPTV+PRXmfUrqdw/QbIHDk3e7DCE9FKlZLzdBt+O0JreU0HhG85beP1G2arQvGN
         zQku2MRzU/m8VnmBNCXveGb23fhAk8c+DU790ibzmKFBlckqj8IBeK58GyYwtJqQBMpS
         jNBl1lwZGVsnywSN8XBll/6oA7NTsjvga4mUJNyUsRXOI+nSG+QtVLzxKMZR0HwjPanB
         a2WOXtZ1vgLjpFDU/dtO6hLgR1w4CX6GJBilTx33w7X0jui+kB0MPmR7c8ql36IFNMxG
         MLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781595457; x=1782200257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nptm9W4b8Xz0dBqBPsQS5dqUH5HS4b9vdtPB6TKu2Rk=;
        b=JCbNP7eWkyucXrmNQ1xuu71fl2wgY8Hd+NuhfLGdzJsID0PberPiW0dBTPVvQAlusA
         bSZUlkLehms/m3zx+NSNx91bmAhCv19ZchbZb+MI67KyB35VIIeU18YMIoyXe79BYGST
         gGq++OjtcoAEcNmMlAWc+gT3o3XX02RTpx5rltoNTftHA1zjhEJodbWhg05xBRi8GTz6
         xt0ZDST9KeGAn70jOlbQQ/EPo70j1C4b0NU6paqKGXeuo56LaTerF9xK7+h90qrP0HY3
         0a8WD2OY15rDNqJ/q7wPi4gCols6fRM3hmTH59C52tOVed3IrqnGpzXEED2dSTLZO3uM
         Epaw==
X-Forwarded-Encrypted: i=1; AFNElJ+tFO0DTp/ZZhoKOVeUQ5d2zAs6EVSwibXQMKhi8+QQgp2cWE0nTON4CJLT3+UYpwBX4S0+S5lYK5Sx@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5jH02e0IhMm3ujtaXJiV6X6AvYUb3ILpVNn6VHR3yJ80ECmeE
	YvtLO99ylR88ERNX6bk57NmhzWRpeMIlU3U24MIyAJ5dEwFXnLdwmOEU1wzCHaPKtMzq07+7O5N
	H/feEyCFqqzEv2EjbNWSMXV4gv5xM4rA=
X-Gm-Gg: Acq92OGXO0GcrthwM675ScZiSLGseEV6PkRA1uPLpr80cz8rr8EY6Pk2gxSQZyFXfhY
	WmeNUmNe8AKeYl/kYrj3Q9yGEuxHjyKE6hyEUNTBgbxzws0xfpu7Y/+VKJr5Ryo4XCuQLLCM/Ft
	dyLSlg2bYcAkf1tlWYvw2SRdEujR2KIXnsNIj4WiVp2fQCtD1OPIkKtenEzx7F9C7MlM+HAAwFP
	NpAPMdrOOiCVxwWQnmZEnmbjDZy9gEhH7+I3t/Lk6op1rO9N3FNx/eEOugvV9b9R9b7bNJKjO9m
	ri+7sg==
X-Received: by 2002:a05:6214:29ea:b0:8c4:edb4:a44a with SMTP id
 6a1803df08f44-8d32e113d9amr297691736d6.23.1781595457066; Tue, 16 Jun 2026
 00:37:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616055357.3798387-1-rajasimandalos@gmail.com> <20260616055357.3798387-4-rajasimandalos@gmail.com>
In-Reply-To: <20260616055357.3798387-4-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Tue, 16 Jun 2026 00:37:26 -0700
X-Gm-Features: AVVi8CdVRAyLGvWIpcoBrxPg1TVeHzPwm7eav7sIwNRmKQjA-fCu6yUXjZZG5OU
Message-ID: <CAFTVevUHXk_HRnn9Lbsbkw1FWkROwJ53F6ivWB2wgVFMu3mM1Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] smb: client: sync retrans on remount
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Mon, Jun 15, 2026 at 10:54=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> The retrans mount option controls how many times the client retries
> sending a request before giving up.  Although remount already stored
> the new value in cifs_sb->ctx, it was never propagated to
> server->retrans, so the running connection kept using the old count.
>
> Introduce smb3_sync_server_opts() to push ctx options that live on
> TCP_Server_Info into the live server struct after a successful
> remount.  For now it handles retrans; subsequent patches will extend
> it to other server-level knobs.
>
> The previous patch in this series ("smb: client: sync runtime state
> into ctx on reconfigure") duplicates the existing context on remount,
> so a bare 'mount -o remount' carries the old retrans value forward and
> the parser only overwrites it when the user explicitly passes
> retrans=3DN.  No special-casing for the bare-remount /proc/mounts replay
> is therefore needed; in particular, an explicit retrans=3D0 from the
> user now correctly resets the value to the compile-time default.
>
> Writes to server->retrans are unsynchronized to match the existing
> convention: every other reader of the field (smb2ops.c retry path,
> cifs_show_options(), the original cifs_get_tcp_session() writer) does
> not take server->srv_lock, and match_server() only reads it under
> srv_lock as part of the larger match function.
>
> Note that retrans lives on TCP_Server_Info and is therefore shared
> across all mounts to the same server; reconfiguring one mount updates
> the value seen by every other mount sharing the connection.  This is
> consistent with the existing semantics: cifs_show_options() already
> reads server->retrans for /proc/mounts on every mount, and the
> runtime retry path always uses the server's value rather than any
> per-mount copy.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index d5a7d4dd402b..bfbea0648f6a 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1278,6 +1278,24 @@ static void smb3_sync_ses_chan_max(struct cifs_ses=
 *ses, size_t max_channels)
>         spin_unlock(&ses->chan_lock);
>  }
>
> +/*
> + * Synchronize server-level options that are stored on TCP_Server_Info
> + * at mount time.  These fields are consulted at runtime (retry logic)
> + * so remount needs to update the live server struct in addition to
> + * cifs_sb->ctx.  Note these live on TCP_Server_Info and are therefore
> + * shared across all mounts to the same server; reconfiguring one mount
> + * updates the value seen by every other mount sharing the connection,
> + * matching how cifs_show_options() and the runtime retry path already
> + * read them unsynchronized from the server struct.
> + */
> +static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
> +{
> +       struct TCP_Server_Info *server =3D cifs_sb_master_tcon(cifs_sb)->=
ses->server;
> +       struct smb3_fs_context *ctx =3D cifs_sb->ctx;
> +
> +       server->retrans =3D ctx->retrans;
> +}
> +
>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> @@ -1447,6 +1465,8 @@ static int smb3_reconfigure(struct fs_context *fc)
>         if (!rc)
>                 rc =3D dfs_cache_remount_fs(cifs_sb);
>  #endif
> +       if (!rc)
> +               smb3_sync_server_opts(cifs_sb);
>
>         return rc;
>
> --
> 2.43.0
>
