Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1A61BD9FB
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 22:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731968872; cv=none; b=q4KzQ28eWIYnOMBUFXpfUf93ixqT2CYMRWhuyYdOJelsIMpeI5jYUxhtSL/G23am+VrjCEY8gEFNsxy+GIa20dCwCOvaEw0zvit0JK0rfp7CYeTnJXgm1Xvi+irLbI9DBC6RMikt7nLahbcZM+JW9KuCA70dm3EUZ54idWvXGDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731968872; c=relaxed/simple;
	bh=w1MUaLNoTyWP7dx5fTc92lYIB4DOvZ2PaJ8VbVK/X4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lMBs9d0kzS4NPdjZNZgnt76SfOG/js/tn0tTioL68CxTwsS/gu2FGdAPhw7g06srQisopsfcbrHmHHflMr5XbbhhCR62B4Ed8mzApnOo6nYiQSpy0ecYvM1J6AFoRIhDQNKubbPvqbzbie01Qh4vXT+4+mVPgzkRm927w59XgVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F38GI+Na; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F38GI+Na"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb59652cb9so32691141fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 14:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731968868; x=1732573668; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBAROlsCiJEvjQwYqrUo8hFfWOIq42HbXccblWy0z8Y=;
        b=F38GI+Na7a2PHocGVg7MqhIxoqnUdaHz2E5IM4pqmlwHpmCQZp+5GFj7AjTA1Hvfnc
         9XUt+rSQ4DX03HMOSZIX7p9vHraEKywYM54O1HC4jHOJGsc3OdHE6iDEIWPoHXHQjgCx
         SOlsLLl7410tOYFDEMZDm8QcV50XfLD7rUxWg5b8QoqWYJzDlua1yLyTRtEMxcDg5VRw
         nYElF1xxGRGFSyIxSiRwghbT1UlT5wBvB4puwVUxtRcicvryIXqKv1ESgYX3udTfzplo
         n+WY/gn9w3Nb4Z67XbCEDk/MY32HGp+2rkgY8c/FdOiDzGtmX4E+WTl5tWpo1dC0f2Z/
         bQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731968868; x=1732573668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBAROlsCiJEvjQwYqrUo8hFfWOIq42HbXccblWy0z8Y=;
        b=GJ3fpXrYSc4G9oH3XyDeOrpotTWePYoiKGmMFO3T2ZfktjXARSNq1ruW9SO3IOppC8
         H8zwPpmYqblmCT6U8c4NH5rfiOZQkMUey3TV4xBFrPK3gTjnu8yjTK/iklcKPwxNfvqr
         Jc3pJn9jwVlG1ndfkf/0Mbe1i81cKyR+W/JEahzVbhwZv+XcGLv4oWceNJYezLBh3aFZ
         LYcoRhM8qQxIPT0GSFAle1dSHfDfsHpV2UljM7G09WN8eyz1tqw//Fj+amh75w7qmyc8
         75PxFlF2bQ7zKCG2sAT/fKhm6MlZKEScEWSN6tL7IoDI5bKawuoGVgiCSoGx+Jha72Bw
         P65w==
X-Gm-Message-State: AOJu0Ywaav0+bjpyUAo4X2NWsa5G9gegtmRHWP4axxPB6y6XAMmW3/bj
	PU0ukKF/JcpmsaV9V5s+RfzZhjqyH3J5n8Wkk7qw+8q1t+aH8+HFpOYJSZMZsyD9jYnTGe2BHCJ
	gf8CQ/cMAxLPJwLluyQmivJVIYmQ=
X-Google-Smtp-Source: AGHT+IF668u3pgtFX3C0Hd/mhB+f4KPCxExvKpsEQk2K7+pnACcdijxZQwYQmdOH3s7fnOEWlAldOEI4WvSQx7iXy+w=
X-Received: by 2002:a05:651c:e0d:b0:2fb:c20:dbc5 with SMTP id
 38308e7fff4ca-2ff6070e571mr48708191fa.29.1731968868207; Mon, 18 Nov 2024
 14:27:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118215028.1066662-1-paul@darkrain42.org> <20241118215028.1066662-2-paul@darkrain42.org>
In-Reply-To: <20241118215028.1066662-2-paul@darkrain42.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Nov 2024 16:27:37 -0600
Message-ID: <CAH2r5msDpWJB6qy0yo1trWOvYi3T=bH2V2=jkonBzHR7T=e2rg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] smb: cached directories can be more than root file handle
To: Paul Aurich <paul@darkrain42.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Nov 18, 2024 at 3:50=E2=80=AFPM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> Update this log message since cached fids may represent things other
> than the root of a mount.
>
> Fixes: e4029e072673 ("cifs: find and use the dentry for cached non-root d=
irectories also")
> Signed-off-by: Paul Aurich <paul@darkrain42.org>
> ---
>  fs/smb/client/cached_dir.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 0ff2491c311d..585e1dc72432 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -399,11 +399,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tco=
n,
>                 return -ENOENT;
>
>         spin_lock(&cfids->cfid_list_lock);
>         list_for_each_entry(cfid, &cfids->entries, entry) {
>                 if (dentry && cfid->dentry =3D=3D dentry) {
> -                       cifs_dbg(FYI, "found a cached root file handle by=
 dentry\n");
> +                       cifs_dbg(FYI, "found a cached file handle by dent=
ry for %pd\n",
> +                                dentry);
>                         kref_get(&cfid->refcount);
>                         *ret_cfid =3D cfid;
>                         spin_unlock(&cfids->cfid_list_lock);
>                         return 0;
>                 }
> --
> 2.45.2
>
>


--=20
Thanks,

Steve
