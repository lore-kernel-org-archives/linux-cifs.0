Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF712BDC26
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778783971; cv=pass; b=DzRO7+AlTX0zi11JZrOkPQC/3KxKmIsdF6ExFvb6KIutOz+JZKrzuKrgKLvDMR72uKSyVz2fI8ijTE8NUv+IxWEVacP213Zgb3H82pz3r7ZH6Y6wMMmndBK1h1fqYJnqoHzBvsr8Fkce+J/DXEMqgVn5z4epw4JdiNRPV5Z2vAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778783971; c=relaxed/simple;
	bh=Pf8KbioMC4clkQYt1w9gWaGZZ0Shp0tkaRw0S8S1lVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=okbbitpQjOGrJnSBJIlXNJ57yUeX64KGd37E5ZQ3fXqWRwB4K/ysSR9w2kpROCRDjlPR4B2i0QHb7kupEC+CHrlaiHVuTZeEoUjWfJVY3y/uxSkqFFHCLOd+qAbcNGH1c8rn2sB1HoC0yrlXvm9dO+n2XUx/l998qUv7h+bBQg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aN5gPE2E; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aN5gPE2E"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8acb856a674so2079076d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:39:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778783969; cv=none;
        d=google.com; s=arc-20240605;
        b=E5/EOhSK35zz4W/bisG773r85I4YAEcCmNGxzALaHxLXZp214Nb1CWyRAKCDZMcSsx
         3ggaucjQjivguWOC1J4WstzoX4qt5l67IuqelZDuFws/aiRl12OudTRuOPRBX3lia+pR
         z990hF+6JNapf/2K1PEBar84v1zjQsQ8rNcl0+EYfnwDAi1gde8xo22EBUJvkkHAQuoR
         MdD1MuPC0F/NoG3N2e2iQowEtB2M8X6DDdp+pvmctwQNsG+lcQRsq3/6CRZBk5/Zf6ja
         sFOilhislcsq2HT1QmiUh25aCLpjZQ69KUjU0+SO3Hj2rnz0V4HxiUI5OnnUb5fi9ZsZ
         Bj8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zPvYHiUTOR575K/puttizC2lDOCY+c31zrynnMQ1Tj4=;
        fh=7A3r6+09tzNnhHTw+uNnYVJyzJRQqAQTAUc0TDW5sqE=;
        b=MkEWkt/d9qe0KEjWhOODtFdIW6/jQ9UCnkzugx0fsuQcQS5/aOPk+1VhYWYLAS/ocC
         64UguyQwzSvxn7QmbLWWRxbIqD8dMt+6tcZSHljqX0MY+Ie2Jjb9mmlwt/2DqdxJ+9g5
         lBjXDzxGS1SU0sKFECvLroT0xLxJb6jG/tsGWhvl8tFncNuYkDMkWHRj2T6gu3iumX3d
         vdbH6jgD84MMQLk2Femirh/8nGndFWqfVSETEFX+I7GGgFnV68m0/JkdbSZI486Kaclj
         pTj/oDtkjWuIksJuabFYW03L616zP08UZUnLs8rnwhnSnm1RdkkTZLj/htszkwQVGGO5
         MLuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778783969; x=1779388769; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPvYHiUTOR575K/puttizC2lDOCY+c31zrynnMQ1Tj4=;
        b=aN5gPE2Eg7+VxyniWNTdlbAvWW6/r0IM4NpBBVnk/UpJYFtRnyADXSQbNu9Q28it1C
         eDZZloqFZBHFPvwmlDVFbtaUQ1iBVkVwPVp/N8gFS38rm8SCcljfGninI1geDDMQMsn7
         jBUXOU5aNGrBzRLmHW+H4RMrFYKmie/CqxvSCl3HknHay/F99FyC6h7oWf1ExOKOSacl
         +9mkcw8QKASlHTuDLQEEhNrwTB/Ygp7+oWRCuq8kZJz5hgf45UqUI3RZEGuL7+OysVQh
         BVP9ojo/RMwgflnMJgeXyQByjb+Ha/5LRvTx3WCkurwnGUfxSNgs9SKBy31uzVFDg95W
         90ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778783969; x=1779388769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zPvYHiUTOR575K/puttizC2lDOCY+c31zrynnMQ1Tj4=;
        b=f+hO5CSPmSL4+aaUvYiar7QnAD4yz0a4fkMKwQ9UmaSyPPHseBz74cOYyHT3FEaqKQ
         SYtueQJVIOIpKKT4vUrFwMJnbpnaP2MSfXi09beZsDZ1HC4pU1SCVkol64H31DLmGS6p
         wxh7NENmLTq7JD09UITI3IKlOZmr0p1hZV4JPhJ2R80E+Uyv7xsoi7eUMvryIxpn/w+n
         vfUtRlNXOYsJPcdIYcaAFWy+iVM6o22NWe0BArRwU4cBZ82MYONCy0rR0dwhMYldemz+
         sacuttXxH6cfhZtzlkMbwwfR98nRoUxr6ggKUmjj9BsupdwXPywuRVAz5zHZejq+sSPL
         qe9g==
X-Gm-Message-State: AOJu0Ywi+XShNTMPMMsRvOu9XZBWHeaIDH5bbm2k4Vd8Df+GJ7wTVHhi
	g9UCA3IZ2KkYdIa6bBXW9ow8+i6IERTXbK3S2UDuUFjBBRnPCikuEZrTpPirGQ0uT7/l4KJsyCF
	fJ/OTZ7NUozCln3oCXtNDh++J7DtUStk=
X-Gm-Gg: Acq92OHyLENMFfcKl5jPLFhuFrMnxSoEJX8VZf4eQ/XY+lE0CqPWuWsjxb1WKh1tjU3
	Th49rbZUvkQK6MMvjbEiZtu80oKU5QffY6WOxuU9R/LyL2bk7ObjqahADWGklG67RwqP3jg9i+p
	ilRmBnjHoMJ9sce4/CrVkrSYds5GKDCezb1cRtO2ydR3+Zw4jLjl5Q0EShtE5ivClwZtcyysZJQ
	Bhdf2mNu46zrICPF1P9y70D18LKXf+XLbNd0MI4nwZJVC6Upivd1+oqakQC819S7fcc+8reSK0g
	4/BTNcYxu7LOZ2kkBSlU6GmiaFa5Ptp0qJ6Pi8U5HY8dyHWOJrHBC0ljgiQ4jxo0h+pwGAnIE/j
	gxhOqfZ5L4/dmAh5JyVwdX8SGeScCCS2yUbFY0lmFLOItD6FNlluHgITxlERH++gjGss7LgfIwZ
	OmUPKEt2OPJHXdT14vORnMBg==
X-Received: by 2002:a05:6214:410c:b0:8ac:a708:eaab with SMTP id
 6a1803df08f44-8c8fae7777amr74089846d6.7.1778783968735; Thu, 14 May 2026
 11:39:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514180823.497293-1-sprasad@microsoft.com> <20260514180823.497293-3-sprasad@microsoft.com>
In-Reply-To: <20260514180823.497293-3-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 14 May 2026 13:39:16 -0500
X-Gm-Features: AVHnY4JFxISWWQgaGDZ0WS17uKJ-iOViYh-u5r_9NGbVP10jADZfv8XFySo9Pwo
Message-ID: <CAH2r5msmVa2VQ_GwKVn1WRhrnxS4GUuzO2wL8XBrsY+RH8JJbA@mail.gmail.com>
Subject: Re: [PATCH v5 03/17] cifs: optimize readdir for small directories
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+/* Size of the minimal QueryDir response for checking if more data exists =
*/
+#define SMB2_QD2_RESPONSE_SIZE 4096

I would rather do (like WIndows client) and set this to 1K so QD1 size
can be bigger and catch the no more files warning more often

On Thu, May 14, 2026 at 1:08=E2=80=AFPM <nspmangalore@gmail.com> wrote:
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
>  fs/smb/client/smb2ops.c   | 158 ++++++++++++++++++++++++++++++++++----
>  fs/smb/client/smb2pdu.c   |  19 +++--
>  fs/smb/client/smb2pdu.h   |  11 +++
>  fs/smb/client/smb2proto.h |   3 +-
>  4 files changed, 170 insertions(+), 21 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index e6cb9b144530d..a7fe82e522de6 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2456,18 +2456,21 @@ smb2_query_dir_first(const unsigned int xid, stru=
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
> @@ -2482,8 +2485,15 @@ smb2_query_dir_first(const unsigned int xid, struc=
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
> @@ -2507,7 +2517,7 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                 goto qdf_free;
>         smb2_set_next_command(tcon, &rqst[0]);
>
> -       /* Query directory */
> +       /* First Query directory */
>         srch_inf->entries_in_buffer =3D 0;
>         srch_inf->index_of_last_entry =3D 2;
>
> @@ -2518,11 +2528,27 @@ smb2_query_dir_first(const unsigned int xid, stru=
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
> @@ -2530,10 +2556,11 @@ smb2_query_dir_first(const unsigned int xid, stru=
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
> @@ -2565,14 +2592,113 @@ smb2_query_dir_first(const unsigned int xid, str=
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
O *)
> +                                       ((char *)last_entry_in_qd1 + next=
_offset);
> +                       }
> +
> +                       /* Chain last QD1 entry to first QD2 entry */
> +                       last_entry_in_qd1->NextEntryOffset =3D
> +                               cpu_to_le32(qd2_entries_start - (char *)l=
ast_entry_in_qd1);
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
> @@ -2581,8 +2707,10 @@ smb2_query_dir_first(const unsigned int xid, struc=
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
> index b2d6f89c74da8..eb471213df463 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5514,18 +5514,27 @@ int SMB2_query_directory_init(const unsigned int =
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
> @@ -5707,7 +5716,7 @@ SMB2_query_directory(const unsigned int xid, struct=
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
> index 1ceb95b907e6b..6b4dc4fea21e8 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -199,7 +199,8 @@ int SMB2_query_directory(const unsigned int xid, stru=
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
