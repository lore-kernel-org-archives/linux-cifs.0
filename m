Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581D19D08F;
	Mon, 26 May 2025 03:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748231844; cv=none; b=Cyjxu668jket/ZjH7ex/5OE1t1JdIsHw6lM2rp+chgzoCTGqYthURhQhZWZTuCMDaxY9vosz9L7uzGokJwLqdIeSL3MECNF344FBTtQ4PTFoiB9adC2tAUfLL4r6Wv80mlF0JvS9AghlRQZlZG1L04/Hju6olA8Or6XYhJd15To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748231844; c=relaxed/simple;
	bh=pWUuIdj/mES3UrDkctgQF/95KeFIX871EUzEOhGNdu8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T7VfbFerr/T2+ctUOg5/v+NLNXxVUa4guvNM+GVO1PmokXjhQGx3IC0R1DOGM6rCiDFZm+kdDz+yp6MGIzZdyfLxdaCjEkSsjsso0eG1/o+OsNPmer4F6FtSloVtOSn9geDH2EQznfEHoPJw5mHXvvmmCK+u6gY9RcfdpliWEHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZrNrGyWs; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZrNrGyWs"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30db1bc464dso18181661fa.0;
        Sun, 25 May 2025 20:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748231840; x=1748836640; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFYKaF5MdOzMoUJdYK+pJqy+h1cRWqDSmXlmSKPedVg=;
        b=ZrNrGyWsvQKLmATwdpVzDARiphfh7bV3pILAg6WwTxJhxUTmJ2S+AgjpuY977V0qqa
         zCe8jRRD/fgnVKKt84KGtzfL1PZq4Ue/77AnnDnsqhz8lw6/Z3D+p0lA8vpBe/fiTCIu
         M2hSQY2jt6f6CPKpz6Eci9z+/59LKKo1j89qqD9YaLcTfz38lFUUX/Q0A6MUjSaK4DdO
         x5dZJrxKLIpAVJD2LwjqRQNPOzLP+f/z2NGJ1GucV2//zVtDb1ioUcllQ3R8cIR4Dk3A
         66g+najA+P6IPBdNzzjBaN9MVACPUgStDqyIZ7dr3AAyb4cyagOuS/te4wHAaqGw05ar
         xgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748231840; x=1748836640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zFYKaF5MdOzMoUJdYK+pJqy+h1cRWqDSmXlmSKPedVg=;
        b=dORWbHN2Odr/959j5KdXFBYdNATGxqkv42DCCwOwOv0b3iaPHfad8CUD/x/wMiw2p+
         yGh+rKosJu5DiC+HufZVBLKv9G7EWjYBTe2y4eZ7LVMCNruyC6RXCc46HqdTGYi2bIMO
         gEtlXYPX+QgB88fSC23f4G6p/2WgzRSMUTooi2fJBQjDAh+bQ2dGxVmXbthvwFDctAhe
         WMPWW6C4y/JMrYG+LeihlEpsiLpeA7SvKEYfvkOq+MEaIg2TR5llHt+3PIhauUji5u5M
         T9JJvhzS422qlnfcU54WTUKzq67yHxdKvMQHQQfQXM04bwU8i/RqKV0mkzCM/UOSh6a1
         ikuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzIHXkdla4hksrMp3JyfpdB5nIrIf+3iFiBWPLcHSz/d02G5wVBoKOnohTr34lJWme2YbWsLKwVhR8@vger.kernel.org, AJvYcCXmqMg03HFlnaV2YJ7bu76lzWRNW+G6DMcZCYwPNAxlFZeuS0vEoyB8qPfYWDNaeCD+7o0nJTytehRnH4MC@vger.kernel.org
X-Gm-Message-State: AOJu0YwKgwXBa49Dm7z13i6npdNqdQqbVM+PEcVZSWFAVr5UCKo9woML
	p0c6d+Q4844nRA7U4Bs37axdr8HX/c+5fms5l3zMIcyr0S/KiQnK0U1KpQCKwVx2tw2vYJVPQwD
	nF6UJrmY4yEf4ZrFVM3tIGvOGWBnni9I=
X-Gm-Gg: ASbGnctnXW1QaAOzLWGJGR0FTvsKHNgChrcMx88olemi9rftRbOTYZn6kIdbWJWFMc+
	mZjQjhTj3tYTrEGRlJDVK3afOgep70tvtJ0bhNWkPOkvP/KCpDMgNMM4g/G2FjRSRZVIfXQr9/A
	J3QayRnxilaRRGN9EXq7jOXWQJGBRIPRFvR8pC+inlumVYE8F9DOstXD/RQmQkRzjSiIk=
X-Google-Smtp-Source: AGHT+IFglGOFvc94hDJJ+iVTcL3H6Lguo5HUhsNTeHxD1snKYkGJepa0VX6LderHITQpczdb+2Xp4I0HIVJ8Ctj4OUQ=
X-Received: by 2002:a05:651c:b25:b0:30b:cb10:3a20 with SMTP id
 38308e7fff4ca-3295ba791e0mr21311351fa.32.1748231840130; Sun, 25 May 2025
 20:57:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250503234030.130605-1-linux@treblig.org>
In-Reply-To: <20250503234030.130605-1-linux@treblig.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 25 May 2025 22:57:08 -0500
X-Gm-Features: AX0GCFvPd0Adolnn1ZM7I39tciaAPW3DaBAHk6K8jPSv5S55usBDLzH4A01Y66g
Message-ID: <CAH2r5mvG_y6-z618TyHnNVf9ueS3hrWP8NPP_HJOTCxAnBvYKQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Remove an unused function and variable
To: linux@treblig.org
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

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
