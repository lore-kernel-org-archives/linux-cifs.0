Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422AC267729
	for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2025 17:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739555746; cv=none; b=kIe4a7etVqv/uTa5+/zm9WFP+gMs+h7h4fXiWl9vrM9OD+cVpuxdHTlcaVYL2iNJm8Lm6y9n/3gc1WEKoLoGkNGqYr9T7k3mED3Zt+0Bf+I7UpzIgF+jXfa7kaTi3kGwAMmA6dc+nU5KqODM+RZcOn+z8fEn0xLc+VCpLaYkxik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739555746; c=relaxed/simple;
	bh=wJ4Txl/aZ7BBzT4OlzwQhwsvii+Gpcoag/bw717QchU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZLJL2gWxo7y9/AsY1X8X2tfxhcWnbUEkS2tEe2ZEa0kD7QwRJgUW7OuXi1yIswe22MCFgTrr0riCTsnLfT9MEfAmtMctr9SWGU6PORTUd+ZKFR7mGTjqnqx4PkD5P6D4H+IdEFYu9P/kG1kZCHlNSfv4hWhG543diWcQWBt90Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XZ0PdDTa; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XZ0PdDTa"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-543cc81ddebso2459103e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2025 09:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739555742; x=1740160542; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8dxzRmSgRou92+lTqQ/2JXEjsqwzWjhIpoHXCOlPp0=;
        b=XZ0PdDTa+6rUpLosVSp9E1/SSbQbRqecGQAyr8d0MNDA5AcEya3esC2h1YopeeT5sw
         mAU8on365YUQfX2DmqfBIEDoU3L7KFeKFzFdlS6E8NKPHBNuTo3akCUa+QpMA9uncuw1
         eK0RCFMi1nk1e3gUg0iYiiIvW4jJQdoBq9UByT0oMh+o18RNGxD6Kd7ZwSvEE+J2PqpN
         DV4JPIarEGlJ7pvhYCJXmvy6VQu7NoYvlSdCmjdEFsG0HI+6G09LIRChIt4VYsP5umOQ
         DDNdCbUMElwFACET81IUcfL91vBh1Vp8EDYqI1XQx3l4q7LW9VRusgC1sm1WGg1fkzls
         jy7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739555742; x=1740160542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F8dxzRmSgRou92+lTqQ/2JXEjsqwzWjhIpoHXCOlPp0=;
        b=O0fOw2TVhAKGJ0tIZTgI8xJ2pGyfUn/oHF5rHY4cZqP3lGDfO5IbXCcTHVwYhqbLp1
         9pPDdP4moEs21JAkx/WuQZh/tD0ez9/qtmpa3vXFT4donZZHYl+mEVIA/AH/Yolj2C6o
         sQ3qx4MNpdzk6biI6HiLdvMAjub63vSC4Y/kIPU9nddsqanfH5KCJlUZw+l6Re8iMRZQ
         dCq8T9G//G3XgPM/mabHWAstalWXer5i5pk0iQbTOcYpTGdK4ns0LQZe9hoRLf5PmzuT
         q1H/mFFKgq+F4oo72xlAb3pXtNqt75xQ4aYQG6pZ9KEF+IFvEPsglK6T37XPmTfS8CYO
         tXWQ==
X-Gm-Message-State: AOJu0YzoKbW0fQ1JXgUDDoMZI6akvJhfL+l2svEoLukoRAZ+jcC91ZfV
	lkaXAjRb+XLSrf2IOP+49TjGGx68EIH/ICh9WqlBy1+Uj6yX3BAt/0EeKRNkBPA/Uu4x2pStuTZ
	IdNbSoPFva7G385Ivhh+9dz7pIs8=
X-Gm-Gg: ASbGncvSSFmjI8ePDPzlAquzkTTkCLNZUPW7OkkFlc5GLYJVccV4f9FpVKDv6EedDgW
	BQq/KPwVeAbhjFcbHWstSW5FgYIgPuTANBtovi0wFOAFTFV4U+tDYlBfjaA/mK+vWpDjSgFwqXf
	1e6lJEOEoOrOYn+WjIfSAPXtFNOHEMKmg=
X-Google-Smtp-Source: AGHT+IHcMNLoazcTGm28lewZzX5VdpoVWqjRK7o/RuZ+C7iVPmtelj11iYIz91mkhDzC74eBsBIpp9CQW5OpDJPZ/0w=
X-Received: by 2002:a05:6512:ba6:b0:545:532:fd2f with SMTP id
 2adb3069b0e04-5452fe3659bmr146663e87.12.1739555742130; Fri, 14 Feb 2025
 09:55:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214124306.498808-1-aman1cifs@gmail.com> <20250214124306.498808-2-aman1cifs@gmail.com>
In-Reply-To: <20250214124306.498808-2-aman1cifs@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 14 Feb 2025 11:55:31 -0600
X-Gm-Features: AWEUYZnsaqyXObzCAmR35vPzi6mHl6abGrAYETBGbmnjiF5n6mBpbGoBHcnsbKY
Message-ID: <CAH2r5msOL9ZpN+ArxrOPZKA6UWXeyqSs9yf1bTrH1=_dCXfLNQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] CIFS: adds min_offload and other params to cifs_debug
To: aman1cifs@gmail.com
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com, 
	sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com, 
	bharathsm@microsoft.com, Aman <aman1@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If these parameters are the same for all channels with your patch,
would it make sense to print them only once (rather than once per
channel) to save debug output?

On Fri, Feb 14, 2025 at 6:43=E2=80=AFAM <aman1cifs@gmail.com> wrote:
>
> From: Aman <aman1@microsoft.com>
>
> This change adds more parameters for debugging into the status of all
> channels. It adds the following TCP server parameters to cifs_debug.c
>
>         - min_offload
>         - compression.requested
>         - dfs_conn
>         - ignore_signature
>         - leaf_fullpath
>         - retrans
>         - noblockcnt
>         - noblocksnd
>         - sign
>         - max_credits
>
> This is a logical follow up to a previous patch titled:
> "[PATCH] CIFS: Propagate min offload along with other parameters from
> primary to secondary channels",
> however this has been tested and applies independently.
>
> Signed-off-by: Aman <aman1@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 47 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index e03c890de..64a565c46 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -147,8 +147,16 @@ cifs_dump_channel(struct seq_file *m, int i, struct =
cifs_chan *chan)
>                    "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
>                    "\n\t\tTCP status: %d Instance: %d"
>                    "\n\t\tLocal Users To Server: %d SecMode: 0x%x Req On =
Wire: %d"
> -                  "\n\t\tIn Send: %d In MaxReq Wait: %d",
> -                  i+1, server->conn_id,
> +                  "\n\t\tIn Send: %d In MaxReq Wait: %d"
> +                  "\n\t\tCompression Requested: %s"
> +                  "\n\t\tdfs_conn: %s"
> +                  "\n\t\tIgnore Signature: %s"
> +                  "\n\t\tretrans: %d"
> +                  "\n\t\tUse non-blocking connect: %s"
> +                  "\n\t\tUse non-blocking sendmsg: %s"
> +                  "\n\t\tSigning Enabled: %s"
> +                  "\n\t\tMin Offload: %d Max Credits: %d",
> +                  i, server->conn_id,
>                    server->credits,
>                    server->echo_credits,
>                    server->oplock_credits,
> @@ -159,7 +167,22 @@ cifs_dump_channel(struct seq_file *m, int i, struct =
cifs_chan *chan)
>                    server->sec_mode,
>                    in_flight(server),
>                    atomic_read(&server->in_send),
> -                  atomic_read(&server->num_waiters));
> +                  atomic_read(&server->num_waiters),
> +                  str_yes_no(server->compression.requested),
> +                  str_yes_no(server->dfs_conn),
> +                  str_yes_no(server->ignore_signature),
> +                  server->retrans,
> +                  str_yes_no(server->noblockcnt),
> +                  str_yes_no(server->noblocksnd),
> +                  str_yes_no(server->sign),
> +                  server->min_offload,
> +                  server->max_credits);
> +
> +       if (server->leaf_fullpath) {
> +               seq_printf(m, "\n\t\tDFS leaf full path: %s",
> +                          server->leaf_fullpath);
> +       }
> +
>  #ifdef CONFIG_NET_NS
>         if (server->net)
>                 seq_printf(m, " Net namespace: %u ", server->net->ns.inum=
);
> @@ -487,6 +510,24 @@ static int cifs_debug_data_proc_show(struct seq_file=
 *m, void *v)
>                 else
>                         seq_puts(m, "disabled (not supported by this serv=
er)");
>
> +               seq_printf(m, "\nCompression Requested: %s"
> +                  "\ndfs_conn: %s"
> +                  "\nIgnore Signature: %s"
> +                  "\nretrans: %d"
> +                  "\nUse non-blocking connect: %s"
> +                  "\nUse non-blocking sendmsg: %s"
> +                  "\nSigning Enabled: %s"
> +                  "\nMin Offload: %d Max Credits: %d",
> +                  str_yes_no(server->compression.requested),
> +                  str_yes_no(server->dfs_conn),
> +                  str_yes_no(server->ignore_signature),
> +                  server->retrans,
> +                  str_yes_no(server->noblockcnt),
> +                  str_yes_no(server->noblocksnd),
> +                  str_yes_no(server->sign),
> +                  server->min_offload,
> +                  server->max_credits);
> +
>                 seq_printf(m, "\n\n\tSessions: ");
>                 i =3D 0;
>                 list_for_each_entry(ses, &server->smb_ses_list, smb_ses_l=
ist) {
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
