Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4330484D25;
	Wed,  7 Aug 2024 21:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723067035; cv=none; b=YWLJBGf2WDlwdGa2qHhDSwsgJUGEQcHDDUILA4mnzULjNDpBULb/Ux1z/XYASX1xsJLDRLKLBN6DObAF0mguKfe5GIL3KcSG9t2aAtyA9J0H0q3+OhsEJYdrwiA/JK3X40pKiwCSTo2OOH+JGt5CGnry4SNnSlOyzZdkDwdH9eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723067035; c=relaxed/simple;
	bh=lkGBHmKx8utfBumhDKHFBqKXIafzXpT/uwm6N8Wpdx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kMdVrpVageDJ0rHeMn80IFt1pU2xiqs4vdk+LZuciwllN5qmNETevfKw71DAxpYQlJTORDx8BhWtlEIB9d1TNLnP15Z3Ilhx9sgLpSfwkm3uLLaG+VJ4U9CHJlbyogUFTaIoOrgprrWLwGFJOJQzXtRECWARuXJzjqCMSTTWCtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LSPEPToA; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSPEPToA"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ef27bfd15bso2630721fa.2;
        Wed, 07 Aug 2024 14:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723067031; x=1723671831; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jll19MbGKA1ExOhPJwMcVT0BjOA2+xszLa20Qb3/6ts=;
        b=LSPEPToARVot12Eiqr1ie0bnutF3FnWWBOvh2F/N2K9ptgEBP0X4Vau6xF+ngdztkw
         nKeSuW7MdYUMyTKpGPCWQHTDnFz1Ie9vAmPOBneJgmiSStg8YeeUWwKJ/KkKQQaQ6wYp
         tsTN8OCdNvub0JIsMMeHQriAYZtk9skcK4e+36iypOLeV63uZmlrkNpbK6riyX1NSBRo
         /s1tGikRxWNz6Yd+sg/AWmxeuV/BpBoeZaJwt+ctH/13OWcZIkrqvpWrzFhfmJOVd5VA
         5g4IHNQ2n8w17OqDT+Y5qKHAfTgVcFEhNji0Oykeq6m+2Mc0yxuHCVSypYkaYxne7IYg
         d0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723067031; x=1723671831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jll19MbGKA1ExOhPJwMcVT0BjOA2+xszLa20Qb3/6ts=;
        b=vqRstsUvtxKYGJuUBuytDdVahc0mW0L3W2Vh3GITSK2i0OaDh9A9uvclEFrbtU3uUW
         cJPVvEHuIZVnsGUlJxcNF1IfJsv349PR80kkQoa3C0dBZPk7lEsBd40noJJTbX0BwtO0
         SFoL9K5FhGn9pCxLcP/9WnlL27jMKRGqWxLhUZKOhPiElHtnZOzL27TC61qC50UBIUtb
         wdNj/MAVIj1vLGn03vZUMevCjGQ+RXYrTyxdZzgLBEpGpGlxclh1mBDI5DwEH6q57Zdh
         c0ivgJbJa/mSuZtlnjUUSWAcF6xjmsm3nMnO1y3y1voSZ5vid1VIkn7l+Eszh/nTthyp
         JH2A==
X-Forwarded-Encrypted: i=1; AJvYcCXq6QnGpeVk33a8noweZCVDcPRHC0fp2hJDcaVWisfCPNSLAwwa9OpTNQv1Fo/WHARM/hDxpeCzAafgE/CfOS85gTO4RXrv22iF3POF8Bo/v6gwxURKnXBMZWEyX/qzfJQPKrvZV4G5rQ==
X-Gm-Message-State: AOJu0YwXV50dcbyzpvJtYr2oh00+gqxLLNGM+eYAWnSbl6qFI+aC1eyj
	YsC1Az3iD4OFxep0JnFQRdEmgjtfc86Ir00ktsLfcF8DxqyWs5JUCw5AdV+ETOVhxh3OPKNdWoN
	ocD2jft4mtVjFVkx809m3BeE/X9Q=
X-Google-Smtp-Source: AGHT+IFVIyLTqdb8azfpb133JgIONeq3ywsb/Aea06oSsz8r2rgOsh6GqvlrMVg47Bz/l18QM1G0RB+ZwFoW1rvyyzI=
X-Received: by 2002:a2e:9110:0:b0:2ef:2c20:e061 with SMTP id
 38308e7fff4ca-2f15aab0a5emr132863931fa.22.1723067030885; Wed, 07 Aug 2024
 14:43:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807165320.56450-1-shenxiaxi26@gmail.com>
In-Reply-To: <20240807165320.56450-1-shenxiaxi26@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 7 Aug 2024 16:43:39 -0500
Message-ID: <CAH2r5mu_hvBnbzbRnpzjAULubsTf5o4TsD3Piqjwn6HsF7BC8A@mail.gmail.com>
Subject: Re: [PATCH] Fix spelling errors in Server Message Block
To: Xiaxi Shen <shenxiaxi26@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	skhan@linuxfoundation.org, javier.carrasco.cruz@gmail.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next


On Wed, Aug 7, 2024 at 11:53=E2=80=AFAM Xiaxi Shen <shenxiaxi26@gmail.com> =
wrote:
>
> Fixed typos in various files under fs/smb/client/
>
> Signed-off-by: Xiaxi Shen <shenxiaxi26@gmail.com>
> ---
>  fs/smb/client/cifsglob.h  | 4 ++--
>  fs/smb/client/misc.c      | 2 +-
>  fs/smb/client/smbdirect.c | 8 ++++----
>  fs/smb/client/transport.c | 2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index f6d1f075987f..66677b8fc9be 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -345,7 +345,7 @@ struct smb_version_operations {
>         /* connect to a server share */
>         int (*tree_connect)(const unsigned int, struct cifs_ses *, const =
char *,
>                             struct cifs_tcon *, const struct nls_table *)=
;
> -       /* close tree connecion */
> +       /* close tree connection */
>         int (*tree_disconnect)(const unsigned int, struct cifs_tcon *);
>         /* get DFS referrals */
>         int (*get_dfs_refer)(const unsigned int, struct cifs_ses *,
> @@ -816,7 +816,7 @@ struct TCP_Server_Info {
>          * Protected by @refpath_lock and @srv_lock.  The @refpath_lock i=
s
>          * mostly used for not requiring a copy of @leaf_fullpath when ge=
tting
>          * cached or new DFS referrals (which might also sleep during I/O=
).
> -        * While @srv_lock is held for making string and NULL comparions =
against
> +        * While @srv_lock is held for making string and NULL comparisons=
 against
>          * both fields as in mount(2) and cache refresh.
>          *
>          * format: \\HOST\SHARE[\OPTIONAL PATH]
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index b28ff62f1f15..3fe5bfc389d0 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -352,7 +352,7 @@ checkSMB(char *buf, unsigned int total_read, struct T=
CP_Server_Info *server)
>                                  * on simple responses (wct, bcc both zer=
o)
>                                  * in particular have seen this on
>                                  * ulogoffX and FindClose. This leaves
> -                                * one byte of bcc potentially unitialize=
d
> +                                * one byte of bcc potentially uninitiali=
zed
>                                  */
>                                 /* zero rest of bcc */
>                                 tmp[sizeof(struct smb_hdr)+1] =3D 0;
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index d74e829de51c..7bcc379014ca 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -406,7 +406,7 @@ static void smbd_post_send_credits(struct work_struct=
 *work)
>                         else
>                                 response =3D get_empty_queue_buffer(info)=
;
>                         if (!response) {
> -                               /* now switch to emtpy packet queue */
> +                               /* now switch to empty packet queue */
>                                 if (use_receive_queue) {
>                                         use_receive_queue =3D 0;
>                                         continue;
> @@ -618,7 +618,7 @@ static struct rdma_cm_id *smbd_create_id(
>
>  /*
>   * Test if FRWR (Fast Registration Work Requests) is supported on the de=
vice
> - * This implementation requries FRWR on RDMA read/write
> + * This implementation requires FRWR on RDMA read/write
>   * return value: true if it is supported
>   */
>  static bool frwr_is_supported(struct ib_device_attr *attrs)
> @@ -2177,7 +2177,7 @@ static int allocate_mr_list(struct smbd_connection =
*info)
>   * MR available in the list. It may access the list while the
>   * smbd_mr_recovery_work is recovering the MR list. This doesn't need a =
lock
>   * as they never modify the same places. However, there may be several C=
PUs
> - * issueing I/O trying to get MR at the same time, mr_list_lock is used =
to
> + * issuing I/O trying to get MR at the same time, mr_list_lock is used t=
o
>   * protect this situation.
>   */
>  static struct smbd_mr *get_mr(struct smbd_connection *info)
> @@ -2311,7 +2311,7 @@ struct smbd_mr *smbd_register_mr(struct smbd_connec=
tion *info,
>         /*
>          * There is no need for waiting for complemtion on ib_post_send
>          * on IB_WR_REG_MR. Hardware enforces a barrier and order of exec=
ution
> -        * on the next ib_post_send when we actaully send I/O to remote p=
eer
> +        * on the next ib_post_send when we actually send I/O to remote p=
eer
>          */
>         rc =3D ib_post_send(info->id->qp, &reg_wr->wr, NULL);
>         if (!rc)
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index adfe0d058701..6e68aaf5bd20 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -1289,7 +1289,7 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>  out:
>         /*
>          * This will dequeue all mids. After this it is important that th=
e
> -        * demultiplex_thread will not process any of these mids any futh=
er.
> +        * demultiplex_thread will not process any of these mids any furt=
her.
>          * This is prevented above by using a noop callback that will not
>          * wake this thread except for the very last PDU.
>          */
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
