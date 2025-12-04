Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4B618EFD1
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764872830; cv=none; b=hcsqrY1352gisLH8ohSXf30miRgQb9eeFmqGvHWzNZaHWuux1Yoif1l6OYTX9lvJ2hWrjJaLaR2GFwLeSOtRVFDu7TrVYYhfPN6yzXSu55G6swestPbLPJGmuwEsVIlFSLrx+N89kOUHD8Ttdd8A+WU95GKPmDsc6Vif86dm0DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764872830; c=relaxed/simple;
	bh=1RQtfuag3iHgpUkTxl7PWP6cA4tPn4h3u8RXaU5HUBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jsTTMczJ/nci0x5spWpb+hKVf0M7Xqkt8RvZSqkAe4OH2UtGehcSesDPznhnT+WUIVRBPor2GwQE/OriYQFbUFs9SmqmCttxZK+zQNI1HKcGTCL4gT9vLf72t1Dw0pAq+LrxwhldAMSVY2MTjTaFNonOkqujuYQUZgxikzFVorg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQxC3bX0; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQxC3bX0"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b2e530a748so106933285a.0
        for <linux-cifs@vger.kernel.org>; Thu, 04 Dec 2025 10:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764872828; x=1765477628; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V67/Pz/Y2qRZEtas0Nfuwx0q+lHznRd82bmhOC3XCQY=;
        b=fQxC3bX0GgLnTYNBU4G3JPyTDARXlSEtlz1CdF7fsEKTPwjwefDYHSMwHk2qyCUKbz
         FK8WAb+iULJxkBKGVzMDoyCqYshOswaithrQvDgQDvN/9ZdwgS1T9AQ9u0HOyObidpJq
         2fjV5OcSJcUVP/kzQmqsTzWymgiM05pg8nJMfgTeLXfhOuYklptqcDrU/fW+Aoo3oJNA
         ZnBL3/Q1XhX4zqC97ddG13UiXd+mcpaMx4jCKdOdf1Me7+6E5zgAvMbqUsJ+tYsuwLVq
         8MzzmAFeppv6CN4buMkKfeemni6Ucvq+ONjB9R9sN5lxb1birxCjeRzUh0MCP5e8S4c8
         OONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764872828; x=1765477628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V67/Pz/Y2qRZEtas0Nfuwx0q+lHznRd82bmhOC3XCQY=;
        b=NK193t3ub87hvt2UqMTYbuceMmNs6fdUd0CKToT3JSaFmPXM1yNQaUexMc75O2AGm5
         bc70p3P+Gzi2zEuh8kPH7mdxxdYHXFLArzADSNiIzGL4xaCPfunXPC9sUfoIY5vrPInw
         /al9CaLQzUyXOcNQDyhsBAogLbEVDCa8/9y7gSOMgnZ4HfN2tINwmuaycXNHH7JQsQSm
         rfbX5S1rxrjd0rERYs7JuQYBq6/iO4RL54Ta3VEZBDTE5dJ3fzjKpKU1q+Wt58T/uG/S
         /LinqLicpuYUu2a8M1CmSRyC6XJuxa/RCkC2lmM/Q7kf1eW5so2tuJC39B/97F3z+5AJ
         iiuQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1N+i4lGa5jTHt9mhn2k8w/cvISMc5FdRNvFlOBSbrKwrrRKkJCnAJ1ZEhqpY5ElYPWPTL3pA2znTO@vger.kernel.org
X-Gm-Message-State: AOJu0Yyty6ZXxvuYIHrf2tQouaC7HytqpfYgANhpQT4xw/52DEcrL519
	dF0QXafyUyu99srSxVNg6TGgr2XqhEAUXmChKKUXJq9DkhWk9w83c+yQXtX6OjxS3VmRLsEyjCx
	ZHtRtTbo4HEvEkk7gvtQhfm6cf/B4eKw=
X-Gm-Gg: ASbGncteXjNOFqiTQykm87N0Oc4IHH234ePGyCZv13OcrRgl5NjOKYieHg7ZlpMPvua
	9BPCOrZ7Buuwy4UWFwz5dpccAYSRd3d4QV2yBp1i6rDnkir3IbtvsXb0eCDb4i6wD0oJ5G23EOD
	kvnCSb/UEWouHqWL2nUDZq+apDa2fqd0cOWttl3r+Wv/jtF+VFB511Aojb9tyPGxib+5yxlNs7V
	4+MNLumAjRGmylu7ICjMjoNwd3d9/zVYINKIw+iYl8+vRPtL4deWNW1LI0F+KDBhbLtD8iBfpal
	b7VYKZie69Fr7zXt8S6wV4Rtn+p2orUOz0ymayLBjpDWfWIdKhbZobA7Vg3OGTkvDrl/L2vqkCy
	gPhykPmX9aoVwisgvySY+daIQ9dPnc3TTiqF8hZhy62ToWQjPIlGSg4PK2Mv3WpeIsZhD3JsAaH
	oOh4UJQ9AqU9hvwoksWEMo
X-Google-Smtp-Source: AGHT+IFwIRL2uv0VbBo0MrB07x+mcs6E+XvHVxu73IyjzjcUZo5e5/3+xHxFnGFkz2N1vcZs1k7CxldLJPUYR39b2GY=
X-Received: by 2002:a05:622a:4d4:b0:4ee:24e8:c9a1 with SMTP id
 d75a77b69052e-4f0175fc81bmr99237271cf.44.1764872827810; Thu, 04 Dec 2025
 10:27:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204180626.244415-1-pc@manguebit.org> <20251204180626.244415-2-pc@manguebit.org>
In-Reply-To: <20251204180626.244415-2-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 4 Dec 2025 12:26:54 -0600
X-Gm-Features: AWmQ_bm7_u2tWMWLiT8uu6McCcdAr3dwRLKvCNVeFMOcrifo1yC6FeDhR2cR7Vo
Message-ID: <CAH2r5mtWk2x7XvMy0PUkqCpUzMYGf_yECBZ+PPdtTcoH_Ovokg@mail.gmail.com>
Subject: Re: [PATCH 2/3] smb: client: improve error message when creating SMB session
To: Paulo Alcantara <pc@manguebit.org>
Cc: Pierguido Lambri <plambri@redhat.com>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added the first two of the three patches to cifs-2.6.git for-next

On Thu, Dec 4, 2025 at 12:06=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> When failing to create a new SMB session with 'sec=3Dkrb5' for example,
> the following error message isn't very useful
>
>         CIFS: VFS: \\srv Send error in SessSetup =3D -126
>
> Improve it by printing the following instead on dmesg
>
>         CIFS: VFS: \\srv failed to create a new SMB session with Kerberos=
: -126
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: Pierguido Lambri <plambri@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/connect.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 3838dd14d4da..bc28e21340e7 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4238,8 +4238,10 @@ cifs_setup_session(const unsigned int xid, struct =
cifs_ses *ses,
>         struct sockaddr_in6 *addr6 =3D (struct sockaddr_in6 *)&pserver->d=
staddr;
>         struct sockaddr_in *addr =3D (struct sockaddr_in *)&pserver->dsta=
ddr;
>         bool is_binding =3D false;
> +       bool new_ses;
>
>         spin_lock(&ses->ses_lock);
> +       new_ses =3D ses->ses_status =3D=3D SES_NEW;
>         cifs_dbg(FYI, "%s: channel connect bitmap: 0x%lx\n",
>                  __func__, ses->chans_need_reconnect);
>
> @@ -4325,7 +4327,10 @@ cifs_setup_session(const unsigned int xid, struct =
cifs_ses *ses,
>         }
>
>         if (rc) {
> -               cifs_server_dbg(VFS, "Send error in SessSetup =3D %d\n", =
rc);
> +               if (new_ses) {
> +                       cifs_server_dbg(VFS, "failed to create a new SMB =
session with %s: %d\n",
> +                                       get_security_type_str(ses->sectyp=
e), rc);
> +               }
>                 spin_lock(&ses->ses_lock);
>                 if (ses->ses_status =3D=3D SES_IN_SETUP)
>                         ses->ses_status =3D SES_NEED_RECON;
> --
> 2.52.0
>


--=20
Thanks,

Steve
