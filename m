Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B46C20DF4;
	Sun,  4 May 2025 01:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746323159; cv=none; b=WPVDq9VbEAP54dV/BYzEaNvNTzhYe76Rj9DCIw9pPNKiBKAdOARG7Pzk1Y/5tHJ2kHZrigWN3uxHFHmdncOLIF+OuPZ1+CPQe9Gw24Q+pHL204OMSocP/fGcxEfebik1HvWS6kNvicwV4E3T2LBqW/Gj2DVsnbX6HpS3dIZ0GHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746323159; c=relaxed/simple;
	bh=lCtX5gDrKX/LLpQICcWlytfAboCij27A2i/XbIp9ZLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qvWp5luZ6NRPNg6an/w/ST4zUomQGsT8+xrN+6ZgtmGT/Hu828hFgXMnwpt+vBy8C5bEQCPx1RhcWIqAzTWZJTAatTqbHsto0PBjGUaAkxGBag0B+o8ucSO3zH3rUoEasLWK3MLq5sA1u8DPMtmPZUDg0OlRojYf9dK38Zy1JRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AmBS2dXI; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmBS2dXI"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30c461a45f8so28924761fa.1;
        Sat, 03 May 2025 18:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746323155; x=1746927955; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B7lnzCOHIwkizy9wWqNhagK46sAvR2JhHgjOg7AFEkU=;
        b=AmBS2dXIh8/ENUA1drDwC8FwRBRhgHCuknaWz+aQOwbwEYUPPWPrJknc9RTHqwuhJz
         40RRxjXGlBOKCzc+O7q2ZF5jNf91M5TDTFu1kjNYiXGAQOYUPxApjO83E2HRHNsr5M9h
         5L/9bOmqC6sJLEbToMUiRIYYIqbLC9Vct3F41eoIbqdA3eDGd/cm7SnbVUHrBgd87WLb
         4GwNrtbB7nNaJ52+U659T1nQyhG0TA6OdbR81N2pKDr/PbTLr6I6RRqxbJaLWF42avWc
         0GZY7SyKpjzb9fSi/po+wN0HBxY3ETijmXklo27U8FicnaFkrJOv+2vCAEDqKuIP4+m6
         78vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746323155; x=1746927955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B7lnzCOHIwkizy9wWqNhagK46sAvR2JhHgjOg7AFEkU=;
        b=nBrrmTazOl7Os2VfA5rwxUmGvy61HIjCffiV88Hy2Si4qyQWJU9vYr2ydZ/ZOlNegs
         30Fw0fmuyRuT3L6q1xE9W/OQYYmNV4V6FYXo3TU+oJJYlIAMVyl8nkHPPmGkPZoBx8yW
         31BGc/IJxFY8zebcGGuxyna3AMkBPsoPQi9MI/A4axBBybvnwWez3dMa7nOWpcsdkEAp
         n9PyrIqUZ5fVReCJelqOStY5epgDDWtmbIZEBVAJXvi2Sct2hm/SsfDBSvpKV06RMQXr
         WO0/KXF4a28AFqC7c+Z0GzYhwnbcsl4qSBcsjIu/ZiGqnKVPMLIk6iZ6Jlf3gIxCsA1k
         2ntw==
X-Forwarded-Encrypted: i=1; AJvYcCVbHHRGZCKhTue/nrJIWPt+z4kvmB4VYexlFSeFNE32lPM5GUGMo+5GPbtWI2NENiQNr8Vd/pP0/eUSAPO/@vger.kernel.org, AJvYcCWQ8tqCWrXRukphYlJUH8nIFZBnI/ahouhTtIEWaThD63C5kP61nxQC6Y5/NgW/dOVkRcbqZIHv3fQ+@vger.kernel.org
X-Gm-Message-State: AOJu0YwYvR0uOhHSQ3B6UP6mQC4+NOPhQay6VYBnNcF5atOkT0V1Omnk
	jn7yG6HA98cdQQtWgf6Pji8YSFz0O0xMZ/0/FI6AZQE8LidQ4aAaGNQ9EJFovB5P9SMV0vNeGLI
	hN3rlb/KtZ5oKl9DgwE5QuYfEvnc=
X-Gm-Gg: ASbGncvTE/ndlzXfmys5UafhfZ0wnSsK7zdtTtKkSWCHEY855JJxy+vNykYp7EpYbzi
	sncHqI7hHWQwTMFzuuClkddpBi7Uu4zU7QhXYz2tM/Ged3pLXJ1iRgQF/Hn22xElVC81ipx+Usq
	ubO5B64nJNYwuYNThFTZxcyAU=
X-Google-Smtp-Source: AGHT+IG4qF3iVI5uWcYBZcuo9Y/YT1JDNmGSRnwvpFqRu8CNxzzYJpMUSlIaKXPHHmx3mvmbXuVDMwt5Pq6PShRcZVQ=
X-Received: by 2002:a2e:be0d:0:b0:30d:e104:b67c with SMTP id
 38308e7fff4ca-32352607341mr6769451fa.39.1746323155173; Sat, 03 May 2025
 18:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250503234030.130605-1-linux@treblig.org>
In-Reply-To: <20250503234030.130605-1-linux@treblig.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 3 May 2025 20:45:43 -0500
X-Gm-Features: ATxdqUEAZB9i7S5uPsM1MexTMN1OssUOvRay6NTBCvtlxfTs81yFYFIHOqDPCAE
Message-ID: <CAH2r5mtCa3W1t_RBwPQDoHKb14JHydmP3CdmjoF5BNfkTn5ing@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Remove an unused function and variable
To: linux@treblig.org
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This looks fine as something for 6.16-rc next month.

On Sat, May 3, 2025 at 6:40=E2=80=AFPM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> SMB2_QFS_info() has been unused since 2018's
> commit 730928c8f4be ("cifs: update smb2_queryfs() to use compounding")
>
> sign_CIFS_PDUs has been unused since 2009's
> commit 2edd6c5b0517 ("[CIFS] NTLMSSP support moving into new file, old de=
ad
> code removed")
>
> Remove them.
>
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  fs/smb/client/cifsfs.c    |  1 -
>  fs/smb/client/smb2pdu.c   | 65 ---------------------------------------
>  fs/smb/client/smb2proto.h |  3 --
>  3 files changed, 69 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index a08c42363ffc..d192a19bd761 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -70,7 +70,6 @@ bool require_gcm_256; /* false by default */
>  bool enable_negotiate_signing; /* false by default */
>  unsigned int global_secflags =3D CIFSSEC_DEF;
>  /* unsigned int ntlmv2_support =3D 0; */
> -unsigned int sign_CIFS_PDUs =3D 1;
>
>  /*
>   * Global transaction id (XID) information
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index c4d52bebd37d..eef971509589 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5919,71 +5919,6 @@ SMB311_posix_qfs_info(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>         return rc;
>  }
>
> -int
> -SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
> -             u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdat=
a)
> -{
> -       struct smb_rqst rqst;
> -       struct smb2_query_info_rsp *rsp =3D NULL;
> -       struct kvec iov;
> -       struct kvec rsp_iov;
> -       int rc =3D 0;
> -       int resp_buftype;
> -       struct cifs_ses *ses =3D tcon->ses;
> -       struct TCP_Server_Info *server;
> -       struct smb2_fs_full_size_info *info =3D NULL;
> -       int flags =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> -
> -replay_again:
> -       /* reinitialize for possible replay */
> -       flags =3D 0;
> -       server =3D cifs_pick_channel(ses);
> -
> -       rc =3D build_qfs_info_req(&iov, tcon, server,
> -                               FS_FULL_SIZE_INFORMATION,
> -                               sizeof(struct smb2_fs_full_size_info),
> -                               persistent_fid, volatile_fid);
> -       if (rc)
> -               return rc;
> -
> -       if (smb3_encryption_required(tcon))
> -               flags |=3D CIFS_TRANSFORM_REQ;
> -
> -       memset(&rqst, 0, sizeof(struct smb_rqst));
> -       rqst.rq_iov =3D &iov;
> -       rqst.rq_nvec =3D 1;
> -
> -       if (retries)
> -               smb2_set_replay(server, &rqst);
> -
> -       rc =3D cifs_send_recv(xid, ses, server,
> -                           &rqst, &resp_buftype, flags, &rsp_iov);
> -       free_qfs_info_req(&iov);
> -       if (rc) {
> -               cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
> -               goto qfsinf_exit;
> -       }
> -       rsp =3D (struct smb2_query_info_rsp *)rsp_iov.iov_base;
> -
> -       info =3D (struct smb2_fs_full_size_info *)(
> -               le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
> -       rc =3D smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
> -                              le32_to_cpu(rsp->OutputBufferLength), &rsp=
_iov,
> -                              sizeof(struct smb2_fs_full_size_info));
> -       if (!rc)
> -               smb2_copy_fs_info_to_kstatfs(info, fsdata);
> -
> -qfsinf_exit:
> -       free_rsp_buf(resp_buftype, rsp_iov.iov_base);
> -
> -       if (is_replayable_error(rc) &&
> -           smb2_should_replay(tcon, &retries, &cur_sleep))
> -               goto replay_again;
> -
> -       return rc;
> -}
> -
>  int
>  SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
>               u64 persistent_fid, u64 volatile_fid, int level)
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 4662c7e2d259..035aa1624053 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -259,9 +259,6 @@ extern int smb2_handle_cancelled_close(struct cifs_tc=
on *tcon,
>                                        __u64 volatile_fid);
>  extern int smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP=
_Server_Info *server);
>  void smb2_cancelled_close_fid(struct work_struct *work);
> -extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
> -                        u64 persistent_file_id, u64 volatile_file_id,
> -                        struct kstatfs *FSData);
>  extern int SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tco=
n *tcon,
>                          u64 persistent_file_id, u64 volatile_file_id,
>                          struct kstatfs *FSData);
> --
> 2.49.0
>
>


--=20
Thanks,

Steve
