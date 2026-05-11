Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B193D2FE04E
	for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778537469; cv=pass; b=kiz8HzNqMqK3yQMTP/2HDDLan1ZX4peFzUIrv3ozia8rjaDLJIUT8B0yrcsnMWT6u6rVaa769k0KtP5W3cV6sCB9MecQs+bmRtT0BYt8CRquZ35aJf6E4S7KAhv3dbZvKcKoP44RdmSm+kNej0SZjxm55pLG01g6uF7hCQzGwkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778537469; c=relaxed/simple;
	bh=thsCBRl0qK8273+MmmcxPOmFm0T+g8OYNpAAgRXhRko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nY9U68PDj3v/UyGW/7ilvUA/iTOteqlNHC3skOfvqgzXSAHsZOoigwy9OU+E8s2ESfDNuzFZW1Zpt0aoafZvrGBvYJa0+TafknLfMmpmwBlAT7+bwPTo60jnDRWIvuuoMTPveA25Is8Yf+sVgMeU4+EUOEUaZCzxtmYS530QFhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EgZMGHIW; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EgZMGHIW"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8b4298d271fso82671636d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 15:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778537466; cv=none;
        d=google.com; s=arc-20240605;
        b=HClRklpbIsYI2nKnsLVhhnw6iSXrZ5iSBsmb0Akj0o6D8o8DhkQpwReA8L+3DGQvPL
         /dybOEXY8HA4IbkXPKkl0k5BhCr6STr2+KFWz3Xh+q1sCHvoa5iFN8ZIM4XUbTaAh2pU
         xXPZltmQCZBdzMcS39SzduOAIlLPzq20VnXtCho20qOcpWdygSaVG9A8sIGYt8GJtKzB
         GF97k+UvUVVR8fYkj80zdJXnY7YnIn8NoUbgJeGZHXyUmgLl7X/jzSFnuc5rirN0lC4Z
         66dovBobeP70kb+phN32VGrb4Zs3NPlfq3CWYl3p5g5fVmS3osDxhIQI9C64r0SkFph5
         gyhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xA14yPdl7czhoRXpBb1tPNtZhtnenSfb1i3rOmE8FVA=;
        fh=7A3r6+09tzNnhHTw+uNnYVJyzJRQqAQTAUc0TDW5sqE=;
        b=MGnJqYo/gu0qwqwCKkdKi4zkTMVSVulnGIfRIPFJKsS4YQV/CGER7bmjTns5NcLY7U
         glyKKXcogwds9jalNKbD0FIA9Qp1vdDYzizUq5PWxvnZSdOK7nmW+TPpHtn+Jw28w4qG
         t9J0AUsARDp3MnmBngmQyZFljXs2Irllr1MklDMaYAI4OUrph4mtYUzQrKve0ZC80PlV
         dSgE+TMNTV+9pd5rI05nBhh4f7vCvjG3ZJNMKTtYtFZOLotVHM08XGLBhpl3mpG2NXTD
         s4MXFCqq9cuf1Tw677bFvoJaFOc/5XcKE442R8R/RK3pY8iJjyZ/i9qfGsHtLnfSo01+
         cg3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778537466; x=1779142266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xA14yPdl7czhoRXpBb1tPNtZhtnenSfb1i3rOmE8FVA=;
        b=EgZMGHIWsaUS8Q26IFPLBlQst5y+ferpGEJYAFnqW6bprv8r63Yd1elNsbwXTO4Yyg
         0BiWaLJg6C0eunNQm89t7rpc0WpwXevRa4Njq8YN1/64rBoZYQHH3uAExLImj0lmfSot
         cXE6PcJlWso0LpNbysJD5F2JFSz40GEbrKtSMBON6KEHbgDRW5CFL/194IC4yu0B4/24
         zFdd51q9VJYMT05K3EA9ew9vslAm7Pda7glMgXOnXAyxxx+q9hiB1jW6sXhA0FCZ6tS6
         HYpMdlqoWKba6t8g9C/MxCxh0/9LlsPqbEu3pcoYfInF8/QB6fHQE2SpU98lxeSedaKZ
         yWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778537466; x=1779142266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xA14yPdl7czhoRXpBb1tPNtZhtnenSfb1i3rOmE8FVA=;
        b=mdzoBHepMjozH3vDYQgQe+2sRFoRh4DrVr/dmNBDGYnbhYTB9h8JgzOXOrb3KSopMQ
         VkIyNuQUlKMQAWYlMLKPbrIOMizJxU/MR3EJpBuKI97YEfzK58II7kmZC3jA7rn7w6oq
         dhII9sTmYw7x6AAZpTnQ5iX4kyRoN76flrkFVqp0utY/7bVyB056F+t8KblzDPTwC/qL
         RnZkxRy1aIUUbHSQB/ktET7wl0IgKYc/4cnI52hDzXiFfB/yS35at12eA9AqROVRUXs4
         VWwONGl1ViKP2Qat1K7hgEItn3mt4M8mWEr/EnSE5pjgwP8SudqRJL3rjmuF2caXohZi
         TYjQ==
X-Gm-Message-State: AOJu0YxCHBTLbbBuHU4DZcyKUL/wT6ecNygPk9YMhoQwwm9NDJCpGccd
	tWp/U0f1v2FsJmqLosBuY08gkNDWaKF4ao1aKzN2fFbyIJoPceXNYWIUbUktMx6HQz4wfJWbLwr
	a4iGXCikOCoiKqmfIw/dtbSvMGPLhuYU=
X-Gm-Gg: Acq92OGp7HU1n2e2RaDPDoqo7QWgkD29Br7J8eUm1apQxuhE0CyGeYdjXWVGaTafcy/
	XJPoyDwKgSRk+nW2cqwd8C0zC2EE4mEO8gUeSmuLspdHYKxyLgGUBibMZ2yvDVkJ5PvjupiOP+4
	gOJED58zOh232LMZKeQzml1qn9n0LzcZNv44mGdKtSA3nAUW2N7RgQuEbpIvYsy/DKYqYznfNG+
	HUu2hfC3wmpcUv3bnAnQRBzbST7q0OtqmF7RgbqN9IMuLRPH8NW24ssCrZ2AaMP79EnqKVviR9t
	wWGBSTkg3zdFqiVC8MkONC7izkA0gTqKPX2OH9X5tdWcKpF0ABGX74CbpjyszOF8i0XjcuiB61w
	1/uLjiXTvzk4SPtOkervj7TGD/CyXlnOCBrjpihZYWnaLtnL6t574/FUfKhShTo69maaftXIIqR
	O3S4KTNJixNg0+ljYRINIOFw==
X-Received: by 2002:a0c:e006:0:b0:89c:6ba4:e306 with SMTP id
 6a1803df08f44-8c66415bfb2mr8242816d6.43.1778537466260; Mon, 11 May 2026
 15:11:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501112023.338005-1-sprasad@microsoft.com> <20260501112023.338005-5-sprasad@microsoft.com>
In-Reply-To: <20260501112023.338005-5-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 May 2026 17:10:54 -0500
X-Gm-Features: AVHnY4KDKBpXlczqZLCpOtg0cQpeIyxPG6mvIBMAkrQLTOSCOxoLVqtKL1ifd8Y
Message-ID: <CAH2r5mu_S29ep_c_k1n=C_YMf11SMS4X8tQNtQn_HAenUrBwvw@mail.gmail.com>
Subject: Re: [PATCH v4 05/19] cifs: optimize readdir for small directories
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>  #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
>
> +/* Size of the minimal QueryDir response for checking if more data exist=
s */
> +#define SMB2_QD2_RESPONSE_SIZE 4096
> +
> +/*
> + * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
> + * Accounts for shared buffer space needed for all three responses.
> + */
> +#define SMB2_QD1_OUTPUT_SIZE(bufsize) \
> +       ((bufsize) - MAX_SMB2_CREATE_RESPONSE_SIZE - \
> +        sizeof(struct smb2_hdr) - SMB2_QD2_RESPONSE_SIZE)

Isn't this suboptimal - it results in a compound with a query dir of
about 11K followed by a query dir of 4K in the same compound, but to
get the desired behavior more often (where no more files is returned
on the second one) wouldn't it be a lot more likely to succeed (ie
return the error on the second one) if SMB2_QD2_RESPONSE_SIZE was set
to e.g. 1K so SMB2_QD1_OUTPUT_SIZE could be larger, about 14K and
increase probability that directory would fit in the first query dir).

On Fri, May 1, 2026 at 6:20=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> For small directories (where the entire directory contents could be
> read in a single QueryDir request), we currently do an extra
> round-trip just to get a STATUS_NO_MORE_FILES back from the server.
>
> This change avoids doing that by adding another QueryDir to the first
> compound to the server for readdir. i.e. first request to readdir
> will correspond to a compound of (OPEN+QD1+QD2). QD2 will request
> for a smaller size (in anticipation of STATUS_NO_MORE_FILES).
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2ops.c   | 156 ++++++++++++++++++++++++++++++++++----
>  fs/smb/client/smb2pdu.c   |  19 +++--
>  fs/smb/client/smb2pdu.h   |  11 +++
>  fs/smb/client/smb2proto.h |   3 +-
>  4 files changed, 168 insertions(+), 21 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index a9d68e5fcea91..f075330f88598 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2450,18 +2450,21 @@ smb2_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>                      struct cifs_search_info *srch_inf)
>  {
>         __le16 *utf16_path;
> -       struct smb_rqst rqst[2];
> -       struct kvec rsp_iov[2];
> -       int resp_buftype[2];
> +       struct smb_rqst rqst[3];
> +       struct kvec rsp_iov[3];
> +       int resp_buftype[3];
>         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> -       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE + 1]; /* +1 for =
padding */
> +       struct kvec qd2_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE + 1]; /* +1 for=
 padding */
>         int rc, flags =3D 0;
>         u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>         struct cifs_open_parms oparms;
>         struct smb2_query_directory_rsp *qd_rsp =3D NULL;
> +       struct smb2_query_directory_rsp *qd2_rsp =3D NULL;
>         struct smb2_create_rsp *op_rsp =3D NULL;
>         struct TCP_Server_Info *server;
>         int retries =3D 0, cur_sleep =3D 0;
> +       unsigned int compound_resp_bufsize;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -2476,8 +2479,15 @@ smb2_query_dir_first(const unsigned int xid, struc=
t cifs_tcon *tcon,
>         if (smb3_encryption_required(tcon))
>                 flags |=3D CIFS_TRANSFORM_REQ;
>
> +       /*
> +        * Clamp compound Create+QD1+QD2 response sizing to a response si=
ze
> +        * for suited for one credit even if CIFSMaxBufSize is tuned larg=
er
> +        */
> +       compound_resp_bufsize =3D min_t(unsigned int, CIFSMaxBufSize,
> +                                     SMB2_MAX_BUFFER_SIZE);
> +
>         memset(rqst, 0, sizeof(rqst));
> -       resp_buftype[0] =3D resp_buftype[1] =3D CIFS_NO_BUFFER;
> +       resp_buftype[0] =3D resp_buftype[1] =3D resp_buftype[2] =3D CIFS_=
NO_BUFFER;
>         memset(rsp_iov, 0, sizeof(rsp_iov));
>
>         /* Open */
> @@ -2501,7 +2511,7 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                 goto qdf_free;
>         smb2_set_next_command(tcon, &rqst[0]);
>
> -       /* Query directory */
> +       /* First Query directory */
>         srch_inf->entries_in_buffer =3D 0;
>         srch_inf->index_of_last_entry =3D 2;
>
> @@ -2512,11 +2522,27 @@ smb2_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>         rc =3D SMB2_query_directory_init(xid, tcon, server,
>                                        &rqst[1],
>                                        COMPOUND_FID, COMPOUND_FID,
> -                                      0, srch_inf->info_level);
> +                                      0, srch_inf->info_level,
> +                                      SMB2_QD1_OUTPUT_SIZE(compound_resp=
_bufsize));
>         if (rc)
>                 goto qdf_free;
>
>         smb2_set_related(&rqst[1]);
> +       smb2_set_next_command(tcon, &rqst[1]);
> +
> +       /* Second Query directory - minimal size to check if more data ex=
ists */
> +       memset(&qd2_iov, 0, sizeof(qd2_iov));
> +       rqst[2].rq_iov =3D qd2_iov;
> +       rqst[2].rq_nvec =3D SMB2_QUERY_DIRECTORY_IOV_SIZE;
> +
> +       rc =3D SMB2_query_directory_init(xid, tcon, server,
> +                                      &rqst[2],
> +                                      COMPOUND_FID, COMPOUND_FID,
> +                                      0, srch_inf->info_level, SMB2_QD2_=
RESPONSE_SIZE);
> +       if (rc)
> +               goto qdf_free;
> +
> +       smb2_set_related(&rqst[2]);
>
>         if (retries) {
>                 /* Back-off before retry */
> @@ -2524,10 +2550,11 @@ smb2_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>                         msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst[0]);
>                 smb2_set_replay(server, &rqst[1]);
> +               smb2_set_replay(server, &rqst[2]);
>         }
>
>         rc =3D compound_send_recv(xid, tcon->ses, server,
> -                               flags, 2, rqst,
> +                               flags, 3, rqst,
>                                 resp_buftype, rsp_iov);
>
>         /* If the open failed there is nothing to do */
> @@ -2559,14 +2586,111 @@ smb2_query_dir_first(const unsigned int xid, str=
uct cifs_tcon *tcon,
>                 goto qdf_free;
>         }
>
> -       rc =3D smb2_parse_query_directory(tcon, &rsp_iov[1], resp_buftype=
[1],
> -                                       srch_inf);
> -       if (rc) {
> -               trace_smb3_query_dir_err(xid, fid->persistent_fid, tcon->=
tid,
> -                       tcon->ses->Suid, 0, 0, rc);
> -               goto qdf_free;
> +       qd2_rsp =3D (struct smb2_query_directory_rsp *)rsp_iov[2].iov_bas=
e;
> +
> +       /*
> +        * If QD2 has data, combine QD1 and QD2 responses before parsing.
> +        * The server cursor advances past both responses, so we can't di=
scard QD2.
> +        */
> +       if (qd2_rsp && qd2_rsp->hdr.Status =3D=3D STATUS_SUCCESS &&
> +           le32_to_cpu(qd2_rsp->OutputBufferLength) > 0) {
> +               char *combined_buf;
> +               size_t qd1_data_len, qd2_data_len, combined_len;
> +               u16 qd1_offset, qd2_offset;
> +               struct smb2_query_directory_rsp *combined_rsp;
> +               struct kvec combined_iov;
> +               FILE_DIRECTORY_INFO *last_entry_in_qd1;
> +               char *qd1_entries_start, *qd2_entries_start;
> +               unsigned int next_offset;
> +
> +               qd1_offset =3D le16_to_cpu(qd_rsp->OutputBufferOffset);
> +               qd2_offset =3D le16_to_cpu(qd2_rsp->OutputBufferOffset);
> +               qd1_data_len =3D le32_to_cpu(qd_rsp->OutputBufferLength);
> +               qd2_data_len =3D le32_to_cpu(qd2_rsp->OutputBufferLength)=
;
> +
> +               /* Allocate buffer for: QD1 header + QD1 data + QD2 data =
*/
> +               combined_len =3D qd1_offset + qd1_data_len + qd2_data_len=
;
> +               combined_buf =3D kmalloc(combined_len, GFP_KERNEL);
> +               if (!combined_buf) {
> +                       rc =3D -ENOMEM;
> +                       goto qdf_free;
> +               }
> +
> +               /* Copy QD1 header and data */
> +               memcpy(combined_buf, qd_rsp, qd1_offset + qd1_data_len);
> +
> +               /* Append QD2 data (directory entries only, not the heade=
r) */
> +               memcpy(combined_buf + qd1_offset + qd1_data_len,
> +                      (char *)qd2_rsp + qd2_offset, qd2_data_len);
> +
> +               /* Update OutputBufferLength to reflect combined data */
> +               combined_rsp =3D (struct smb2_query_directory_rsp *)combi=
ned_buf;
> +               combined_rsp->OutputBufferLength =3D cpu_to_le32(qd1_data=
_len + qd2_data_len);
> +
> +               /*
> +                * Chain QD1 and QD2 entries: find the last entry in QD1 =
and update
> +                * its NextEntryOffset to point to the first entry in QD2=
.
> +                */
> +               if (qd1_data_len > 0) {
> +                       qd1_entries_start =3D combined_buf + qd1_offset;
> +                       qd2_entries_start =3D combined_buf + qd1_offset +=
 qd1_data_len;
> +                       last_entry_in_qd1 =3D (FILE_DIRECTORY_INFO *)qd1_=
entries_start;
> +
> +                       /* Walk QD1 entries to find the last one with bou=
nds checking */
> +                       while (1) {
> +                               char *end_of_qd1 =3D qd1_entries_start + =
qd1_data_len;
> +
> +                               next_offset =3D le32_to_cpu(last_entry_in=
_qd1->NextEntryOffset);
> +                               if (next_offset =3D=3D 0)
> +                                       break;  /* Found last entry */
> +
> +                               /* Bounds check before advancing */
> +                               if ((char *)last_entry_in_qd1 + next_offs=
et >=3D end_of_qd1) {
> +                                       cifs_dbg(VFS, "query_dir_first: i=
nvalid NextEntryOffset in QD1\n");
> +                                       kfree(combined_buf);
> +                                       rc =3D -EIO;
> +                                       goto qdf_free;
> +                               }
> +
> +                               last_entry_in_qd1 =3D (FILE_DIRECTORY_INF=
O *)((char *)last_entry_in_qd1 + next_offset);
> +                       }
> +
> +                       /* Chain last QD1 entry to first QD2 entry */
> +                       last_entry_in_qd1->NextEntryOffset =3D cpu_to_le3=
2(qd2_entries_start - (char *)last_entry_in_qd1);
> +               }
> +
> +               /* Parse the combined buffer */
> +               combined_iov.iov_base =3D combined_buf;
> +               combined_iov.iov_len =3D combined_len;
> +               rc =3D smb2_parse_query_directory(tcon, &combined_iov, CI=
FS_DYNAMIC_BUFFER,
> +                                               srch_inf);
> +               if (rc) {
> +                       kfree(combined_buf);
> +                       trace_smb3_query_dir_err(xid, fid->persistent_fid=
, tcon->tid,
> +                                                tcon->ses->Suid, 0, 0, r=
c);
> +                       goto qdf_free;
> +               }
> +               /* Ownership of combined_buf transferred to srch_inf->ntw=
rk_buf_start */
> +               srch_inf->endOfSearch =3D false;
> +               cifs_dbg(FYI, "query_dir_first: combined QD1 and QD2, %d =
entries\n",
> +                        srch_inf->entries_in_buffer);
> +       } else {
> +               /* No data in QD2, just parse QD1 */
> +               rc =3D smb2_parse_query_directory(tcon, &rsp_iov[1], resp=
_buftype[1],
> +                                               srch_inf);
> +               if (rc) {
> +                       trace_smb3_query_dir_err(xid, fid->persistent_fid=
, tcon->tid,
> +                                                tcon->ses->Suid, 0, 0, r=
c);
> +                       goto qdf_free;
> +               }
> +               resp_buftype[1] =3D CIFS_NO_BUFFER;
> +
> +               /* Check if QD2 indicates end of directory */
> +               if (qd2_rsp && qd2_rsp->hdr.Status =3D=3D STATUS_NO_MORE_=
FILES) {
> +                       srch_inf->endOfSearch =3D true;
> +                       cifs_dbg(FYI, "query_dir_first: small directory, =
all entries read\n");
> +               }
>         }
> -       resp_buftype[1] =3D CIFS_NO_BUFFER;
>
>         trace_smb3_query_dir_done(xid, fid->persistent_fid, tcon->tid,
>                         tcon->ses->Suid, 0, srch_inf->entries_in_buffer);
> @@ -2575,8 +2699,10 @@ smb2_query_dir_first(const unsigned int xid, struc=
t cifs_tcon *tcon,
>         kfree(utf16_path);
>         SMB2_open_free(&rqst[0]);
>         SMB2_query_directory_free(&rqst[1]);
> +       SMB2_query_directory_free(&rqst[2]);
>         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
>         free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> +       free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
>
>         if (is_replayable_error(rc) &&
>             smb2_should_replay(tcon, &retries, &cur_sleep))
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 49dca84b169e6..2d55246d2851b 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5504,18 +5504,27 @@ int SMB2_query_directory_init(const unsigned int =
xid,
>                               struct TCP_Server_Info *server,
>                               struct smb_rqst *rqst,
>                               u64 persistent_fid, u64 volatile_fid,
> -                             int index, int info_level)
> +                             int index, int info_level,
> +                             unsigned int output_size)
>  {
>         struct smb2_query_directory_req *req;
>         unsigned char *bufptr;
>         __le16 asteriks =3D cpu_to_le16('*');
> -       unsigned int output_size =3D CIFSMaxBufSize -
> -               MAX_SMB2_CREATE_RESPONSE_SIZE -
> -               MAX_SMB2_CLOSE_RESPONSE_SIZE;
>         unsigned int total_len;
>         struct kvec *iov =3D rqst->rq_iov;
>         int len, rc;
>
> +       /*
> +        * Use provided output_size, or default to CIFSMaxBufSize calcula=
tion.
> +        * The default is for standalone QueryDir (smb2_query_dir_next).
> +        * For compounds, the caller should pass explicit output_size.
> +        */
> +       if (output_size =3D=3D 0) {
> +               output_size =3D CIFSMaxBufSize -
> +                       MAX_SMB2_CREATE_RESPONSE_SIZE -
> +                       MAX_SMB2_CLOSE_RESPONSE_SIZE;
> +       }
> +
>         rc =3D smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, server,
>                                  (void **) &req, &total_len);
>         if (rc)
> @@ -5697,7 +5706,7 @@ SMB2_query_directory(const unsigned int xid, struct=
 cifs_tcon *tcon,
>         rc =3D SMB2_query_directory_init(xid, tcon, server,
>                                        &rqst, persistent_fid,
>                                        volatile_fid, index,
> -                                      srch_inf->info_level);
> +                                      srch_inf->info_level, 0);
>         if (rc)
>                 goto qdir_exit;
>
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 30d70097fe2fa..7b7a864520c68 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -129,6 +129,17 @@ struct share_redirect_error_context_rsp {
>   */
>  #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
>
> +/* Size of the minimal QueryDir response for checking if more data exist=
s */
> +#define SMB2_QD2_RESPONSE_SIZE 4096
> +
> +/*
> + * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
> + * Accounts for shared buffer space needed for all three responses.
> + */
> +#define SMB2_QD1_OUTPUT_SIZE(bufsize) \
> +       ((bufsize) - MAX_SMB2_CREATE_RESPONSE_SIZE - \
> +        sizeof(struct smb2_hdr) - SMB2_QD2_RESPONSE_SIZE)
> +
>  #define SMB2_LEASE_READ_CACHING_HE     0x01
>  #define SMB2_LEASE_HANDLE_CACHING_HE   0x02
>  #define SMB2_LEASE_WRITE_CACHING_HE    0x04
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 230bb1e9f4e19..9de7d2fe8d466 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -194,7 +194,8 @@ int SMB2_query_directory(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>  int SMB2_query_directory_init(const unsigned int xid, struct cifs_tcon *=
tcon,
>                               struct TCP_Server_Info *server,
>                               struct smb_rqst *rqst, u64 persistent_fid,
> -                             u64 volatile_fid, int index, int info_level=
);
> +                             u64 volatile_fid, int index, int info_level=
,
> +                             unsigned int output_size);
>  void SMB2_query_directory_free(struct smb_rqst *rqst);
>  int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
>                  u64 persistent_fid, u64 volatile_fid, u32 pid,
> --
> 2.43.0
>


--=20
Thanks,

Steve
