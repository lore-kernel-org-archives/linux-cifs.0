Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CE4BA29;
	Thu, 14 Mar 2024 03:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710386059; cv=none; b=mc6bGKFJulSCAGwtxQVxb1NlEFncbARjzHHMI/trcUoZnMa8e/TwJ1f/LwwcmF/gKkyAtPFwUcrt4cvM3QB69EEek18LurHZ/H/tsDg8pfgmnMA9pytixVePPwvKejqzE2TInd4Vzsg7WzWarINs2PC9bb2IPIuNiSywyLErk+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710386059; c=relaxed/simple;
	bh=x/TLFjyCS8HDwBawdiWm57iNGQ9scNv3N74xuVyJ8q0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BWRtuv3rSTUauc1+kV1RlnpqW9GuaM1dX1FYvqq/3raPJCxezjumHQcOhsUFormr9V7lSVo94FKZq5CEHn0AWRwSct7qweEIjXs6Xcjo/Z2xd1Z611K1jEYLlYrlL/T4gtcNS2iw6gVw4SNdw6G+frJjYcFqjwNZ9IxZMJEB2SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0DGaO/j; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0DGaO/j"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d109e82bd0so5370361fa.3;
        Wed, 13 Mar 2024 20:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710386056; x=1710990856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFRXR6JXd171H6JhlHg8M0dfWr3UCSzsqgNW2RVeNNU=;
        b=Y0DGaO/jKJF1Je3q3L5+9hoNXyoQscfsZMhNHcN6k+otMPJEjikFr78C0QgCZevdzm
         c5Jri11nwHOUxHi5bfIv1kDVon9NKUCMEre0+rfhTa9+cdMVJgskJ7s9YK7PLyJqGvpI
         +7JZTJoaxLaih98+TojsdbX8ubb/d7v9s74c7ZAcCZT6TaZmE+VwtJaksCLxpZJ1hubk
         jgrGP/b/DySDNXOIc7riEFjdXIf2aDDn/sIUKNfyHTpf46cCjSo7aNR6d8dZmI53Mf0u
         A3uj8ojGFUi8hOnggVnjLV+Md4mUGvUazixZk72mPL49j/CboH17WWp7ZT8Hs099oIc4
         HyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710386056; x=1710990856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DFRXR6JXd171H6JhlHg8M0dfWr3UCSzsqgNW2RVeNNU=;
        b=ii5kRtAJ5paRh+Fkaz9qxJ1E4g5SLzxoQGAQh6OKWg/UmIrd3lNMJE9+S2+U/ytz2n
         Nsi8yQ2WlDNOkXOGe1kW5qWV+pYpWK2cUYIg7XJ8Dna0MEPBRoy8kdsRZraQUSq74x2z
         o4QWWPUg/JPfi9vELsucVDYWdbvFgmTOL/Gem/J/966GMgzrHdQ1ytMeUyXyE6nbYKBy
         LeW7LU1oOPctyXf8zBBvU/djHZGt48DxJmbuuYwPkMpnFvpVQ6Gf6cCA+03EOyESaj0u
         gLr4KrWqvxGEsbWB/1Xh8Zm7WERpbXhHTfbV/o4TaqDjTTLUzsdOEfBMCry12Yf+Y+7T
         WMUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuT2PW4pSy2V7J/xKu85GhlFXIlj/aa4LnxZTy+fPZB7yZom/8S7mPfEQUKNoCIZ07qkh42s9efmPif+2R1WXEhXBpLuNa
X-Gm-Message-State: AOJu0YxwYYAaoXmy/idaKNe97hLeMPrnE3QPbJ1v9eNKncK3dZI8yDax
	WLH6ma4cb2vzaYyQou/JQL0blaa1PUW3/+pkDkYX1vWn60bUz6muL/Cd8QM3D+/xEoRYReeH61Q
	4SiJjM0kp0azp+oG3w+hIAfOJxaA=
X-Google-Smtp-Source: AGHT+IEOFT4r5h0ibIH0VSNs1+UT6l5POA1rJ60x+somqfdMt/wcSLM15FVYo8+w8b4QaERTw4ZyeW4JAeZirC7sORU=
X-Received: by 2002:a2e:b604:0:b0:2d2:50ba:e5b6 with SMTP id
 r4-20020a2eb604000000b002d250bae5b6mr248994ljn.10.1710386055579; Wed, 13 Mar
 2024 20:14:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313104041.188204-1-sprasad@microsoft.com> <20240313104041.188204-2-sprasad@microsoft.com>
In-Reply-To: <20240313104041.188204-2-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Mar 2024 22:14:04 -0500
Message-ID: <CAH2r5msf7=aC0evP90pS5ktZVYTPAZhdtAFVE4T_wMks6k4=eQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: make sure server interfaces are requested only
 for SMB3+
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	Shyam Prasad N <sprasad@microsoft.com>, Stable <stable@vger.kernel.org>, 
	=?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next pending testing and
additional review

On Wed, Mar 13, 2024 at 5:40=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Some code paths for querying server interfaces make a false
> assumption that it will only get called for SMB3+. Since this
> function now can get called from a generic code paths, the correct
> thing to do is to have specific handler for this functionality
> per SMB dialect, and call this handler.
>
> This change adds such a handler and implements this handler only
> for SMB 3.0 and 3.1.1.
>
> Cc: Stable <stable@vger.kernel.org>
> Cc: Jan =C4=8Cerm=C3=A1k <sairon@sairon.cz>
> Reported-by: Paulo Alcantara <pc@manguebit.com>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h | 3 +++
>  fs/smb/client/connect.c  | 6 +++++-
>  fs/smb/client/smb2ops.c  | 2 ++
>  fs/smb/client/smb2pdu.c  | 5 +++--
>  4 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 53c75cfb33ab..b29b57ab9807 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -346,6 +346,9 @@ struct smb_version_operations {
>         /* informational QFS call */
>         void (*qfs_tcon)(const unsigned int, struct cifs_tcon *,
>                          struct cifs_sb_info *);
> +       /* query for server interfaces */
> +       int (*query_server_interfaces)(const unsigned int, struct cifs_tc=
on *,
> +                                      bool);
>         /* check if a path is accessible or not */
>         int (*is_path_accessible)(const unsigned int, struct cifs_tcon *,
>                                   struct cifs_sb_info *, const char *);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index ac9595504f4b..234160460615 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -123,12 +123,16 @@ static void smb2_query_server_interfaces(struct wor=
k_struct *work)
>         struct cifs_tcon *tcon =3D container_of(work,
>                                         struct cifs_tcon,
>                                         query_interfaces.work);
> +       struct TCP_Server_Info *server =3D tcon->ses->server;
>
>         /*
>          * query server network interfaces, in case they change
>          */
> +       if (!server->ops->query_server_interfaces)
> +               return;
> +
>         xid =3D get_xid();
> -       rc =3D SMB3_request_interfaces(xid, tcon, false);
> +       rc =3D server->ops->query_server_interfaces(xid, tcon, false);
>         free_xid(xid);
>
>         if (rc) {
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 4695433fcf39..3b8896987197 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -5538,6 +5538,7 @@ struct smb_version_operations smb30_operations =3D =
{
>         .tree_connect =3D SMB2_tcon,
>         .tree_disconnect =3D SMB2_tdis,
>         .qfs_tcon =3D smb3_qfs_tcon,
> +       .query_server_interfaces =3D SMB3_request_interfaces,
>         .is_path_accessible =3D smb2_is_path_accessible,
>         .can_echo =3D smb2_can_echo,
>         .echo =3D SMB2_echo,
> @@ -5653,6 +5654,7 @@ struct smb_version_operations smb311_operations =3D=
 {
>         .tree_connect =3D SMB2_tcon,
>         .tree_disconnect =3D SMB2_tdis,
>         .qfs_tcon =3D smb3_qfs_tcon,
> +       .query_server_interfaces =3D SMB3_request_interfaces,
>         .is_path_accessible =3D smb2_is_path_accessible,
>         .can_echo =3D smb2_can_echo,
>         .echo =3D SMB2_echo,
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 608ee05491e2..4fa47c59cc04 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -409,14 +409,15 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
>         spin_unlock(&ses->ses_lock);
>
>         if (!rc &&
> -           (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> +           (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) &&
> +           server->ops->query_server_interfaces) {
>                 mutex_unlock(&ses->session_mutex);
>
>                 /*
>                  * query server network interfaces, in case they change
>                  */
>                 xid =3D get_xid();
> -               rc =3D SMB3_request_interfaces(xid, tcon, false);
> +               rc =3D server->ops->query_server_interfaces(xid, tcon, fa=
lse);
>                 free_xid(xid);
>
>                 if (rc =3D=3D -EOPNOTSUPP && ses->chan_count > 1) {
> --
> 2.34.1
>


--=20
Thanks,

Steve
