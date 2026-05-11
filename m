Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F93363098
	for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 23:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778543450; cv=pass; b=tEtQCx6AZvkzzranHiwefqpPh+mkwjy7E1o37HA/wq8dtU7x5ZHLWdUwz+ns8Xceg1Xypw8qTCJ24WkvHeepKFN+Gs6lLMmYwaDnlkPs+MaYDZOBGJjJhwpph0YCjZ4ADM+qt1MfRQSEH2z+ycTC5n9kJNjJRAI5EMR/Wq62zmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778543450; c=relaxed/simple;
	bh=CRA/oLmdHZYnKMFP82eFWfkWa4OW2WEJ1weiSQ1xxBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ckYoL1g4gfrAbsoRN59/E6oNqXmFS/3WeMmZTnm1HJJ3ajkX3IOKYM2pc+enQdCPzafiLK0nimXHDs6s2sCVG3l+dDb8Q/QJeaxlggY7Mq5Mbcp1Fwamcb+gdH+19wSF5G3JqbRFXFYajAbdG5Plf6GeXP2Wi5NEKoCqHJFIqO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+Bn6zPd; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+Bn6zPd"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8b701756684so55705476d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 16:50:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778543447; cv=none;
        d=google.com; s=arc-20240605;
        b=lmJKR/b4BF10G/ZP1PZ61pLx/PxLXEtWq5Dpgt1YP8vRHFD8+pYuydQNQ4NpyPuVG9
         8pTtACqz1R7wLjf/k8sk/yMgV0ymY4TNYg+DwBNWiGKmC0cbTz/iz88FsFGgrvavLVsv
         wAOZbmf/6sawvRwPi+BMVPcvYCZPwOagGQLWrA6gV6F5G55q/HwC64xLZo7F+A2Fxf4A
         w4HmLVj7smaPm/mQw73Euix9vWxQcySbVwqa9HOFOib/SZjtBu6f/q3f5blFl2uOdBC8
         ClMYNZYThx5dAWr3ixEg26beZ5seOK0SA5Sm8ntfKsgBtzaFbmaA62EVqchakBkLGZiI
         9rSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sG1jgUpmk5IFJE13u+XdZLiUAHXVrcTYjw8TDUpzTK8=;
        fh=7A3r6+09tzNnhHTw+uNnYVJyzJRQqAQTAUc0TDW5sqE=;
        b=MtjCkTc035CEQKBeJvoSKnUMSQtKLKVky0CqsJTFZSeE/FUe75v8EE9dUIggn70lbA
         qy2hoyJtPJoorbTZ0Np73RYVMx2i9dcmo6eX/du1VBZOqF0Nm153DXDCm3uHt6pTiyKH
         /PLNkVo5EPV/VyReKvVpHEgika690eaCnwFsEqkJYEp11ERE0repVUIbPqY/qWsaq18s
         eabqBTDUQwkR+XDmMfJ/RL1bA2kkOOWgZE6AYoxCPEkPgQq1t/Suo58nNJ1dr5fI2DqO
         OnOQXYjE6XtrjLUGQVLgGZX5VSGlevLsQHbyWPLFWV5FLKyJxT0SY0UXpsTxF96vxJIi
         IZKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778543447; x=1779148247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sG1jgUpmk5IFJE13u+XdZLiUAHXVrcTYjw8TDUpzTK8=;
        b=U+Bn6zPdceUEACcrVlJb2YmmS4XOJMQd+CbQQ+gRjK5Qe60IiwPYizx0czDsdCjeDW
         pvCVMWzjZa/rh1XzCZ4DkRGMVkeQ/kaxkFyY7NE8wrAAZrrw9wrD0X0tBYQVV4tKubE5
         R9opzK3ks6oUUv/PSCSZYgH45XnI5G+rm9FWMSB96k/EJ6z59WjquQRV3JXn78jdLATY
         0Rtp9+Q60GjK2RcbcBR24y1vm6bOVPRAClxn/KK12Zb6QakBBOIT0BP7opOUIgPZuR58
         kJIHFm3okEjgc+cuWssI1Iv5YLQtZxVb/YVJUviH8J9yXnvvtFiBAO5c/J1elUqw8W6L
         NNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778543447; x=1779148247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sG1jgUpmk5IFJE13u+XdZLiUAHXVrcTYjw8TDUpzTK8=;
        b=SB42/RdbmzojVXAX3YEnFHThEj0AV/9W0+h71ozudxmWnzrInkqgStViRxs1L9KWE3
         918CVEz0lCUaTZrbn0hKvPoh4acd6NKB6ampuQl5aCS7b9dBVkn0drSaEOcOBCi8Vj/t
         y5LMnz966Q1ciSwTa2m77P/PeYFsbqRm8sd1kAfOUFG8Yg1EeCVFbql2mGhps07Zvl8B
         +FM3Z/3GxWKnJKj45MdWibgCIcbgF7taVtjkLpKOe21+i8O6VvI49f22MSjmatHfJZ5n
         Xw+UVugMLelpO4Y1HWc15VzPNtgQ2tFXvTPxGBYSXxvaMNvtBB06x4M+kdkMuD4JcCM/
         RThg==
X-Gm-Message-State: AOJu0YxLkxCk2dPuvcoB8aw39IKcYtTt7LvAipmM0QPvMkEu871IZYSH
	EEusizfBsVJzLe3rXDuAzGg44JWrk/4BAuTEcZZK/Glvigjnac/FLGX1Qk0ZCqa5ZVmoxuidtbP
	uG3bnaHTQCLnbLIgZeZkpYc0G3PeQa/A=
X-Gm-Gg: Acq92OEFCFekNHJAmBrMfUmUpqkWFRvGkn8YX7aaZ0AWxEpw2zduOeJWLySHB0Njv20
	W3q7R4Ys3HHNmBb6QyTRoIYBP8mp3XaTrgLnLSP3Jv+mKFqbhAxZ4BSglG6KbyfbN6mgO8veS0D
	6aDdu5/S9tRS3YbNOF25g5bq9X2t6yYYjM2UMJr6IyDOItUSwsC96wxHdIXmAx11xwWbu8sAQ3i
	ewms4P+QY1SMxFVlUtj2yQmnZ+XGEkOT3TLckuuKdt3BS/Rad4va+HPdZcXALj4ehrILyNVp1R2
	san2r//84gGA1aa2Ku/QYANyUUGy9zEUt6enMWhXEZvBOpkiMETEOy7gYspvrm0fFRFWYQCqh8O
	mHrbNq4T2upN83Dmy7srsNgA4GIjUgkomw0OAHLSpYbC/jLRaORD6jDz4Z2xOxsWAkaJVvj9BLn
	4UGAWptxhTyy7vy9vfsuM=
X-Received: by 2002:a05:6214:4a92:b0:8c6:450d:651 with SMTP id
 6a1803df08f44-8c6450d0789mr20217406d6.2.1778543446817; Mon, 11 May 2026
 16:50:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501112023.338005-1-sprasad@microsoft.com>
 <20260501112023.338005-5-sprasad@microsoft.com> <CAH2r5mu_S29ep_c_k1n=C_YMf11SMS4X8tQNtQn_HAenUrBwvw@mail.gmail.com>
In-Reply-To: <CAH2r5mu_S29ep_c_k1n=C_YMf11SMS4X8tQNtQn_HAenUrBwvw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 May 2026 18:50:35 -0500
X-Gm-Features: AVHnY4L3DDMZVxUwhr1Pnz0lXGosRlQfy2aOvgf98W90_854q1E5byAjMNbR8Hk
Message-ID: <CAH2r5muEGk+mZqsJabZDPT2tkac0ZSebnGSpdYta0Cp+R7BDYw@mail.gmail.com>
Subject: Re: [PATCH v4 05/19] cifs: optimize readdir for small directories
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Windows seems to pick sane numbers (I just tried to Samba):
a compound with 64K in the first query, and the second one in the
compound is only 1K
the followon querydir is 1MB

It was weird though that Windows was trying level 0x51 query dir
(which the Samba server did not recognize, so Windows retries with
level 37 which Samba does recognize

On Mon, May 11, 2026 at 5:10=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> >  #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
> >
> > +/* Size of the minimal QueryDir response for checking if more data exi=
sts */
> > +#define SMB2_QD2_RESPONSE_SIZE 4096
> > +
> > +/*
> > + * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
> > + * Accounts for shared buffer space needed for all three responses.
> > + */
> > +#define SMB2_QD1_OUTPUT_SIZE(bufsize) \
> > +       ((bufsize) - MAX_SMB2_CREATE_RESPONSE_SIZE - \
> > +        sizeof(struct smb2_hdr) - SMB2_QD2_RESPONSE_SIZE)
>
> Isn't this suboptimal - it results in a compound with a query dir of
> about 11K followed by a query dir of 4K in the same compound, but to
> get the desired behavior more often (where no more files is returned
> on the second one) wouldn't it be a lot more likely to succeed (ie
> return the error on the second one) if SMB2_QD2_RESPONSE_SIZE was set
> to e.g. 1K so SMB2_QD1_OUTPUT_SIZE could be larger, about 14K and
> increase probability that directory would fit in the first query dir).
>
> On Fri, May 1, 2026 at 6:20=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > For small directories (where the entire directory contents could be
> > read in a single QueryDir request), we currently do an extra
> > round-trip just to get a STATUS_NO_MORE_FILES back from the server.
> >
> > This change avoids doing that by adding another QueryDir to the first
> > compound to the server for readdir. i.e. first request to readdir
> > will correspond to a compound of (OPEN+QD1+QD2). QD2 will request
> > for a smaller size (in anticipation of STATUS_NO_MORE_FILES).
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/smb2ops.c   | 156 ++++++++++++++++++++++++++++++++++----
> >  fs/smb/client/smb2pdu.c   |  19 +++--
> >  fs/smb/client/smb2pdu.h   |  11 +++
> >  fs/smb/client/smb2proto.h |   3 +-
> >  4 files changed, 168 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index a9d68e5fcea91..f075330f88598 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -2450,18 +2450,21 @@ smb2_query_dir_first(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >                      struct cifs_search_info *srch_inf)
> >  {
> >         __le16 *utf16_path;
> > -       struct smb_rqst rqst[2];
> > -       struct kvec rsp_iov[2];
> > -       int resp_buftype[2];
> > +       struct smb_rqst rqst[3];
> > +       struct kvec rsp_iov[3];
> > +       int resp_buftype[3];
> >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > -       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE + 1]; /* +1 fo=
r padding */
> > +       struct kvec qd2_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE + 1]; /* +1 f=
or padding */
> >         int rc, flags =3D 0;
> >         u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> >         struct cifs_open_parms oparms;
> >         struct smb2_query_directory_rsp *qd_rsp =3D NULL;
> > +       struct smb2_query_directory_rsp *qd2_rsp =3D NULL;
> >         struct smb2_create_rsp *op_rsp =3D NULL;
> >         struct TCP_Server_Info *server;
> >         int retries =3D 0, cur_sleep =3D 0;
> > +       unsigned int compound_resp_bufsize;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -2476,8 +2479,15 @@ smb2_query_dir_first(const unsigned int xid, str=
uct cifs_tcon *tcon,
> >         if (smb3_encryption_required(tcon))
> >                 flags |=3D CIFS_TRANSFORM_REQ;
> >
> > +       /*
> > +        * Clamp compound Create+QD1+QD2 response sizing to a response =
size
> > +        * for suited for one credit even if CIFSMaxBufSize is tuned la=
rger
> > +        */
> > +       compound_resp_bufsize =3D min_t(unsigned int, CIFSMaxBufSize,
> > +                                     SMB2_MAX_BUFFER_SIZE);
> > +
> >         memset(rqst, 0, sizeof(rqst));
> > -       resp_buftype[0] =3D resp_buftype[1] =3D CIFS_NO_BUFFER;
> > +       resp_buftype[0] =3D resp_buftype[1] =3D resp_buftype[2] =3D CIF=
S_NO_BUFFER;
> >         memset(rsp_iov, 0, sizeof(rsp_iov));
> >
> >         /* Open */
> > @@ -2501,7 +2511,7 @@ smb2_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >                 goto qdf_free;
> >         smb2_set_next_command(tcon, &rqst[0]);
> >
> > -       /* Query directory */
> > +       /* First Query directory */
> >         srch_inf->entries_in_buffer =3D 0;
> >         srch_inf->index_of_last_entry =3D 2;
> >
> > @@ -2512,11 +2522,27 @@ smb2_query_dir_first(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >         rc =3D SMB2_query_directory_init(xid, tcon, server,
> >                                        &rqst[1],
> >                                        COMPOUND_FID, COMPOUND_FID,
> > -                                      0, srch_inf->info_level);
> > +                                      0, srch_inf->info_level,
> > +                                      SMB2_QD1_OUTPUT_SIZE(compound_re=
sp_bufsize));
> >         if (rc)
> >                 goto qdf_free;
> >
> >         smb2_set_related(&rqst[1]);
> > +       smb2_set_next_command(tcon, &rqst[1]);
> > +
> > +       /* Second Query directory - minimal size to check if more data =
exists */
> > +       memset(&qd2_iov, 0, sizeof(qd2_iov));
> > +       rqst[2].rq_iov =3D qd2_iov;
> > +       rqst[2].rq_nvec =3D SMB2_QUERY_DIRECTORY_IOV_SIZE;
> > +
> > +       rc =3D SMB2_query_directory_init(xid, tcon, server,
> > +                                      &rqst[2],
> > +                                      COMPOUND_FID, COMPOUND_FID,
> > +                                      0, srch_inf->info_level, SMB2_QD=
2_RESPONSE_SIZE);
> > +       if (rc)
> > +               goto qdf_free;
> > +
> > +       smb2_set_related(&rqst[2]);
> >
> >         if (retries) {
> >                 /* Back-off before retry */
> > @@ -2524,10 +2550,11 @@ smb2_query_dir_first(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >                         msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst[0]);
> >                 smb2_set_replay(server, &rqst[1]);
> > +               smb2_set_replay(server, &rqst[2]);
> >         }
> >
> >         rc =3D compound_send_recv(xid, tcon->ses, server,
> > -                               flags, 2, rqst,
> > +                               flags, 3, rqst,
> >                                 resp_buftype, rsp_iov);
> >
> >         /* If the open failed there is nothing to do */
> > @@ -2559,14 +2586,111 @@ smb2_query_dir_first(const unsigned int xid, s=
truct cifs_tcon *tcon,
> >                 goto qdf_free;
> >         }
> >
> > -       rc =3D smb2_parse_query_directory(tcon, &rsp_iov[1], resp_bufty=
pe[1],
> > -                                       srch_inf);
> > -       if (rc) {
> > -               trace_smb3_query_dir_err(xid, fid->persistent_fid, tcon=
->tid,
> > -                       tcon->ses->Suid, 0, 0, rc);
> > -               goto qdf_free;
> > +       qd2_rsp =3D (struct smb2_query_directory_rsp *)rsp_iov[2].iov_b=
ase;
> > +
> > +       /*
> > +        * If QD2 has data, combine QD1 and QD2 responses before parsin=
g.
> > +        * The server cursor advances past both responses, so we can't =
discard QD2.
> > +        */
> > +       if (qd2_rsp && qd2_rsp->hdr.Status =3D=3D STATUS_SUCCESS &&
> > +           le32_to_cpu(qd2_rsp->OutputBufferLength) > 0) {
> > +               char *combined_buf;
> > +               size_t qd1_data_len, qd2_data_len, combined_len;
> > +               u16 qd1_offset, qd2_offset;
> > +               struct smb2_query_directory_rsp *combined_rsp;
> > +               struct kvec combined_iov;
> > +               FILE_DIRECTORY_INFO *last_entry_in_qd1;
> > +               char *qd1_entries_start, *qd2_entries_start;
> > +               unsigned int next_offset;
> > +
> > +               qd1_offset =3D le16_to_cpu(qd_rsp->OutputBufferOffset);
> > +               qd2_offset =3D le16_to_cpu(qd2_rsp->OutputBufferOffset)=
;
> > +               qd1_data_len =3D le32_to_cpu(qd_rsp->OutputBufferLength=
);
> > +               qd2_data_len =3D le32_to_cpu(qd2_rsp->OutputBufferLengt=
h);
> > +
> > +               /* Allocate buffer for: QD1 header + QD1 data + QD2 dat=
a */
> > +               combined_len =3D qd1_offset + qd1_data_len + qd2_data_l=
en;
> > +               combined_buf =3D kmalloc(combined_len, GFP_KERNEL);
> > +               if (!combined_buf) {
> > +                       rc =3D -ENOMEM;
> > +                       goto qdf_free;
> > +               }
> > +
> > +               /* Copy QD1 header and data */
> > +               memcpy(combined_buf, qd_rsp, qd1_offset + qd1_data_len)=
;
> > +
> > +               /* Append QD2 data (directory entries only, not the hea=
der) */
> > +               memcpy(combined_buf + qd1_offset + qd1_data_len,
> > +                      (char *)qd2_rsp + qd2_offset, qd2_data_len);
> > +
> > +               /* Update OutputBufferLength to reflect combined data *=
/
> > +               combined_rsp =3D (struct smb2_query_directory_rsp *)com=
bined_buf;
> > +               combined_rsp->OutputBufferLength =3D cpu_to_le32(qd1_da=
ta_len + qd2_data_len);
> > +
> > +               /*
> > +                * Chain QD1 and QD2 entries: find the last entry in QD=
1 and update
> > +                * its NextEntryOffset to point to the first entry in Q=
D2.
> > +                */
> > +               if (qd1_data_len > 0) {
> > +                       qd1_entries_start =3D combined_buf + qd1_offset=
;
> > +                       qd2_entries_start =3D combined_buf + qd1_offset=
 + qd1_data_len;
> > +                       last_entry_in_qd1 =3D (FILE_DIRECTORY_INFO *)qd=
1_entries_start;
> > +
> > +                       /* Walk QD1 entries to find the last one with b=
ounds checking */
> > +                       while (1) {
> > +                               char *end_of_qd1 =3D qd1_entries_start =
+ qd1_data_len;
> > +
> > +                               next_offset =3D le32_to_cpu(last_entry_=
in_qd1->NextEntryOffset);
> > +                               if (next_offset =3D=3D 0)
> > +                                       break;  /* Found last entry */
> > +
> > +                               /* Bounds check before advancing */
> > +                               if ((char *)last_entry_in_qd1 + next_of=
fset >=3D end_of_qd1) {
> > +                                       cifs_dbg(VFS, "query_dir_first:=
 invalid NextEntryOffset in QD1\n");
> > +                                       kfree(combined_buf);
> > +                                       rc =3D -EIO;
> > +                                       goto qdf_free;
> > +                               }
> > +
> > +                               last_entry_in_qd1 =3D (FILE_DIRECTORY_I=
NFO *)((char *)last_entry_in_qd1 + next_offset);
> > +                       }
> > +
> > +                       /* Chain last QD1 entry to first QD2 entry */
> > +                       last_entry_in_qd1->NextEntryOffset =3D cpu_to_l=
e32(qd2_entries_start - (char *)last_entry_in_qd1);
> > +               }
> > +
> > +               /* Parse the combined buffer */
> > +               combined_iov.iov_base =3D combined_buf;
> > +               combined_iov.iov_len =3D combined_len;
> > +               rc =3D smb2_parse_query_directory(tcon, &combined_iov, =
CIFS_DYNAMIC_BUFFER,
> > +                                               srch_inf);
> > +               if (rc) {
> > +                       kfree(combined_buf);
> > +                       trace_smb3_query_dir_err(xid, fid->persistent_f=
id, tcon->tid,
> > +                                                tcon->ses->Suid, 0, 0,=
 rc);
> > +                       goto qdf_free;
> > +               }
> > +               /* Ownership of combined_buf transferred to srch_inf->n=
twrk_buf_start */
> > +               srch_inf->endOfSearch =3D false;
> > +               cifs_dbg(FYI, "query_dir_first: combined QD1 and QD2, %=
d entries\n",
> > +                        srch_inf->entries_in_buffer);
> > +       } else {
> > +               /* No data in QD2, just parse QD1 */
> > +               rc =3D smb2_parse_query_directory(tcon, &rsp_iov[1], re=
sp_buftype[1],
> > +                                               srch_inf);
> > +               if (rc) {
> > +                       trace_smb3_query_dir_err(xid, fid->persistent_f=
id, tcon->tid,
> > +                                                tcon->ses->Suid, 0, 0,=
 rc);
> > +                       goto qdf_free;
> > +               }
> > +               resp_buftype[1] =3D CIFS_NO_BUFFER;
> > +
> > +               /* Check if QD2 indicates end of directory */
> > +               if (qd2_rsp && qd2_rsp->hdr.Status =3D=3D STATUS_NO_MOR=
E_FILES) {
> > +                       srch_inf->endOfSearch =3D true;
> > +                       cifs_dbg(FYI, "query_dir_first: small directory=
, all entries read\n");
> > +               }
> >         }
> > -       resp_buftype[1] =3D CIFS_NO_BUFFER;
> >
> >         trace_smb3_query_dir_done(xid, fid->persistent_fid, tcon->tid,
> >                         tcon->ses->Suid, 0, srch_inf->entries_in_buffer=
);
> > @@ -2575,8 +2699,10 @@ smb2_query_dir_first(const unsigned int xid, str=
uct cifs_tcon *tcon,
> >         kfree(utf16_path);
> >         SMB2_open_free(&rqst[0]);
> >         SMB2_query_directory_free(&rqst[1]);
> > +       SMB2_query_directory_free(&rqst[2]);
> >         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> >         free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> > +       free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
> >
> >         if (is_replayable_error(rc) &&
> >             smb2_should_replay(tcon, &retries, &cur_sleep))
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 49dca84b169e6..2d55246d2851b 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -5504,18 +5504,27 @@ int SMB2_query_directory_init(const unsigned in=
t xid,
> >                               struct TCP_Server_Info *server,
> >                               struct smb_rqst *rqst,
> >                               u64 persistent_fid, u64 volatile_fid,
> > -                             int index, int info_level)
> > +                             int index, int info_level,
> > +                             unsigned int output_size)
> >  {
> >         struct smb2_query_directory_req *req;
> >         unsigned char *bufptr;
> >         __le16 asteriks =3D cpu_to_le16('*');
> > -       unsigned int output_size =3D CIFSMaxBufSize -
> > -               MAX_SMB2_CREATE_RESPONSE_SIZE -
> > -               MAX_SMB2_CLOSE_RESPONSE_SIZE;
> >         unsigned int total_len;
> >         struct kvec *iov =3D rqst->rq_iov;
> >         int len, rc;
> >
> > +       /*
> > +        * Use provided output_size, or default to CIFSMaxBufSize calcu=
lation.
> > +        * The default is for standalone QueryDir (smb2_query_dir_next)=
.
> > +        * For compounds, the caller should pass explicit output_size.
> > +        */
> > +       if (output_size =3D=3D 0) {
> > +               output_size =3D CIFSMaxBufSize -
> > +                       MAX_SMB2_CREATE_RESPONSE_SIZE -
> > +                       MAX_SMB2_CLOSE_RESPONSE_SIZE;
> > +       }
> > +
> >         rc =3D smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, server,
> >                                  (void **) &req, &total_len);
> >         if (rc)
> > @@ -5697,7 +5706,7 @@ SMB2_query_directory(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >         rc =3D SMB2_query_directory_init(xid, tcon, server,
> >                                        &rqst, persistent_fid,
> >                                        volatile_fid, index,
> > -                                      srch_inf->info_level);
> > +                                      srch_inf->info_level, 0);
> >         if (rc)
> >                 goto qdir_exit;
> >
> > diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> > index 30d70097fe2fa..7b7a864520c68 100644
> > --- a/fs/smb/client/smb2pdu.h
> > +++ b/fs/smb/client/smb2pdu.h
> > @@ -129,6 +129,17 @@ struct share_redirect_error_context_rsp {
> >   */
> >  #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
> >
> > +/* Size of the minimal QueryDir response for checking if more data exi=
sts */
> > +#define SMB2_QD2_RESPONSE_SIZE 4096
> > +
> > +/*
> > + * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
> > + * Accounts for shared buffer space needed for all three responses.
> > + */
> > +#define SMB2_QD1_OUTPUT_SIZE(bufsize) \
> > +       ((bufsize) - MAX_SMB2_CREATE_RESPONSE_SIZE - \
> > +        sizeof(struct smb2_hdr) - SMB2_QD2_RESPONSE_SIZE)
> > +
> >  #define SMB2_LEASE_READ_CACHING_HE     0x01
> >  #define SMB2_LEASE_HANDLE_CACHING_HE   0x02
> >  #define SMB2_LEASE_WRITE_CACHING_HE    0x04
> > diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> > index 230bb1e9f4e19..9de7d2fe8d466 100644
> > --- a/fs/smb/client/smb2proto.h
> > +++ b/fs/smb/client/smb2proto.h
> > @@ -194,7 +194,8 @@ int SMB2_query_directory(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >  int SMB2_query_directory_init(const unsigned int xid, struct cifs_tcon=
 *tcon,
> >                               struct TCP_Server_Info *server,
> >                               struct smb_rqst *rqst, u64 persistent_fid=
,
> > -                             u64 volatile_fid, int index, int info_lev=
el);
> > +                             u64 volatile_fid, int index, int info_lev=
el,
> > +                             unsigned int output_size);
> >  void SMB2_query_directory_free(struct smb_rqst *rqst);
> >  int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
> >                  u64 persistent_fid, u64 volatile_fid, u32 pid,
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
