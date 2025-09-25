Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2DD3009EF
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758815293; cv=none; b=Q6zCw9V8wLEcZzXGw4CYrXT9BU53c9uPfpukxWtlp7bN/Gw40JY40lu+yOokt4QnpWSj4Im4BOjyCV3aOdQpjKnJjCVK+4ucTazAGumNekkzmWLXtLvA0bbEZi64SCLxuuO9HptIgmUjthfDHZ8PqdAz+oPBntt5H65EF9apbNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758815293; c=relaxed/simple;
	bh=OhCmUIsc5CSNlJdE0XDcNREL58H2lhiETZ3SMJByiF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qktWHoXYSlnVDnOBbpxcaqyXrEGuEELBK0rJiRnwiUiv5adi0Ebs58iQKE2eQUdupUIhdi8ZlacwhkgstTcz55VgEL7k/9zbhaGXtgTrD76MjB9a/K/pRsFe/P1IdVbxlGhUE1NH4DfyMIk93FxNsSPosO2f5skPCuP/YGtAXeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUb1LJvw; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUb1LJvw"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-795be3a3644so5284066d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 08:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758815290; x=1759420090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PeKsQObSVCYyJFfh1E99huodAkXqyNDlJERnAWNe1cU=;
        b=KUb1LJvwe5knkZODn7WYgEY9pa/ZBtnBIoyZDVQjI/Q5cU6onvyC7YnjcWZgXg02nl
         peijtIGlcEvXJsmY3BMBmE31/AL0frHBjEw6e9KxjS6N42E+YLvihnrLMWIN9XBcca5r
         6mh8NGjjjmu7db+q4c3R9KdgtZi9WnCFeEZKi2aIzi3DJU/7cBvv+w2wejMmELDK0Pek
         o7ba8DgAH0DdJ1xY4BjKvSSmZEfUA6TyuWfzmjjctI1RUYlNs1IcFjTq2qqYZFe3qRNV
         OaPi3lLhwInT+unnxt1tsplYpxKWF/Yo7NDaZngBbsfcImvZqgR+uOem+MI09D3lnXaj
         4q6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758815290; x=1759420090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PeKsQObSVCYyJFfh1E99huodAkXqyNDlJERnAWNe1cU=;
        b=q+cGTR0o/jRwbHATOTRzMiJfbf42TNNIi5cAmubg7N9HwCJ24GLaTArrC86v40WikC
         tihPI/xiqE33jMH2U7Sy90h1PiKO2XqsQ00cQ9P1a/Go+qGcW3B21gZFXpC01yGGXJ7S
         Gu23b40jEuYYtTf5xxcd6oEYNoyhErZAJlhF1eV9tAm822fhdMYlCRVlwLdSPiFLzg2B
         PctV8uFGFdCQnbgR3CFMzSMqfTRLtutUVwX1hyk0XIuqR9+s36ZNUkM+adFL2gKv/X/0
         8Iw3dgiCLu2XaO7i0mvWdDqoTazfWjqSgYzcTwdE/YEOsJ9w8vXLW6arbBQN0gYD4wyp
         geQA==
X-Forwarded-Encrypted: i=1; AJvYcCWwQQqYn1/Ud+YbHTvX1UimTHjozBdhCCIYqf3fnxDvWH0xsbgjqQRIHRP7U6WROG7fxunmI5unkRMY@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4by3eTYPVS5nhyyL6ezoPBzusO4I8SbeWjd7Hd5Kflwzpo6KV
	fY7A2Kkt54aaUfKel96nKLUbLHiM8FxjzA03oGpLmyhwzUtWc7WKcfg+OLm96IgfGiTo4LD/EVE
	ELYZDgM3Z2T6Al7Neri3FwnT0x/5S2EY=
X-Gm-Gg: ASbGncukTadteuHH1imCigxHkUg0FjLmHsTK+Y79ymeLTKWjm8Y/t8OnM/+hci0grV2
	gbd7BEnBdvfxpo8s7uXQEFRMRfa98e0/omPWibDcniouk9MzHLI6KqkySxmAKbf70FawirFJER3
	jniSnLh/GIg1ZOFeFEjAumMhNN8/chvw3zIyDo/kiL0MiT7Dv3fYTouUYKv7rx8HDK/XDAuXiIz
	qFqBUZzol4PSInC2utCDFylVloXjZ8+0TmYrCKWXpWX0TjB90LADuDeNeYwp1DrGeZ+I7qtJUH9
	La5HS8JjolX6awXV588NJ14lgfUlT5jAl45uDfxDfuIjZpOjwtCDSuLpQXJhKB+FSrnOQXzFZEB
	m4/riK+4pSUNIlw9nZF1yvQ==
X-Google-Smtp-Source: AGHT+IHdMA8ivFQ1fgFmz5C78GlrFuYOIElJ3pKv+aRRSF/vGQvjn9QL/p17dNr/kEjVWcELaalXOkPQu42l7M+fZwA=
X-Received: by 2002:ad4:5bc9:0:b0:76a:fcee:97aa with SMTP id
 6a1803df08f44-7fc309ec826mr53929946d6.29.1758815290243; Thu, 25 Sep 2025
 08:48:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925141920.166230-1-henrique.carvalho@suse.com>
In-Reply-To: <20250925141920.166230-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 25 Sep 2025 10:47:58 -0500
X-Gm-Features: AS18NWCDfP_C0RGU0mx42PPyFIXfKkOGVtlmhzNX5cyg2Q_ifYKbbSSF-N11u6I
Message-ID: <CAH2r5murE3rQzNNf3hfccoScXqFSmxO_dg_2dKrdMkAMw+ry_A@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: batch SRV_COPYCHUNK entries to cut roundtrips
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, dan.carpenter@linaro.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

On Thu, Sep 25, 2025 at 9:27=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> smb2_copychunk_range() used to send a single SRV_COPYCHUNK per
> SRV_COPYCHUNK_COPY IOCTL.
>
> Implement variable Chunks[] array in struct copychunk_ioctl and fill it
> with struct copychunk (MS-SMB2 2.2.31.1.1), bounded by server-advertised
> limits.
>
> This reduces the number of IOCTLs requests for large copies.
>
> While we are at it, rename a couple variables to follow the terminology
> used in the specification.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V1 -> V2:
> - initialize ret_data_len to 0
>
>  fs/smb/client/smb2ops.c | 281 ++++++++++++++++++++++++++--------------
>  fs/smb/client/smb2pdu.h |  16 ++-
>  fs/smb/client/trace.h   |   3 +-
>  3 files changed, 198 insertions(+), 102 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index e586f3f4b5c9..c469120bb4f6 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1806,140 +1806,231 @@ smb2_ioctl_query_info(const unsigned int xid,
>         return rc;
>  }
>
> +/*
> + * calc_chunk_count - calculates the number chunks to be filled in the C=
hunks[]
> + * array of struct copychunk_ioctl
> + *
> + * @tcon: destination file tcon
> + * @bytes_left: how many bytes are left to copy
> + *
> + * Return: maximum number of chunks with which Chunks[] can be filled.
> + */
> +static inline u32
> +calc_chunk_count(struct cifs_tcon *tcon, u64 bytes_left)
> +{
> +       if (!tcon->max_bytes_chunk || !tcon->max_bytes_copy || !tcon->max=
_chunks)
> +               return 0;
> +
> +       return min_t(u32, DIV_ROUND_UP_ULL(bytes_left, tcon->max_bytes_ch=
unk),
> +                    umin(tcon->max_chunks,
> +                         DIV_ROUND_UP(tcon->max_bytes_copy, tcon->max_by=
tes_chunk)));
> +}
> +
> +/*
> + * smb2_copychunk_range - server-side copy of data range
> + *
> + * @xid: transaction id
> + * @src_file: source file
> + * @dst_file: destination file
> + * @src_off: source file byte offset
> + * @len: number of bytes to copy
> + * @dst_off: destination file byte offset
> + *
> + * Obtains a resume key for @src_file and issues FSCTL_SRV_COPYCHUNK_WRI=
TE
> + * IOCTLs, splitting the request into chunks limited by tcon->max_*.
> + *
> + * Return: @len on success; negative errno on failure.
> + */
>  static ssize_t
>  smb2_copychunk_range(const unsigned int xid,
> -                       struct cifsFileInfo *srcfile,
> -                       struct cifsFileInfo *trgtfile, u64 src_off,
> -                       u64 len, u64 dest_off)
> +                    struct cifsFileInfo *src_file,
> +                    struct cifsFileInfo *dst_file,
> +                    u64 src_off,
> +                    u64 len,
> +                    u64 dst_off)
>  {
> -       int rc;
> -       unsigned int ret_data_len;
> -       struct copychunk_ioctl *pcchunk;
> -       struct copychunk_ioctl_rsp *retbuf =3D NULL;
> +       int rc =3D 0;
> +       unsigned int ret_data_len =3D 0;
> +       struct copychunk_ioctl *cc_req =3D NULL;
> +       struct copychunk_ioctl_rsp *cc_rsp =3D NULL;
>         struct cifs_tcon *tcon;
> -       int chunks_copied =3D 0;
> -       bool chunk_sizes_updated =3D false;
> -       ssize_t bytes_written, total_bytes_written =3D 0;
> +       struct copychunk *chunk;
> +       u32 chunks, chunk_count, chunk_bytes;
> +       u32 copy_bytes, copy_bytes_left;
> +       u32 chunks_written, bytes_written;
> +       u64 total_bytes_left =3D len;
> +       u64 src_off_prev, dst_off_prev;
> +       u32 retries =3D 0;
> +
> +       tcon =3D tlink_tcon(dst_file->tlink);
> +
> +       trace_smb3_copychunk_enter(xid, src_file->fid.volatile_fid,
> +                                  dst_file->fid.volatile_fid, tcon->tid,
> +                                  tcon->ses->Suid, src_off, dst_off, len=
);
> +
> +retry:
> +       chunk_count =3D calc_chunk_count(tcon, total_bytes_left);
> +       if (!chunk_count) {
> +               rc =3D -EOPNOTSUPP;
> +               goto cchunk_out;
> +       }
>
> -       pcchunk =3D kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
> -       if (pcchunk =3D=3D NULL)
> -               return -ENOMEM;
> +       cc_req =3D kzalloc(struct_size(cc_req, Chunks, chunk_count), GFP_=
KERNEL);
> +       if (!cc_req) {
> +               rc =3D -ENOMEM;
> +               goto cchunk_out;
> +       }
>
> -       cifs_dbg(FYI, "%s: about to call request res key\n", __func__);
>         /* Request a key from the server to identify the source of the co=
py */
> -       rc =3D SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
> -                               srcfile->fid.persistent_fid,
> -                               srcfile->fid.volatile_fid, pcchunk);
> +       rc =3D SMB2_request_res_key(xid,
> +                                 tlink_tcon(src_file->tlink),
> +                                 src_file->fid.persistent_fid,
> +                                 src_file->fid.volatile_fid,
> +                                 cc_req);
>
> -       /* Note: request_res_key sets res_key null only if rc !=3D0 */
> +       /* Note: request_res_key sets res_key null only if rc !=3D 0 */
>         if (rc)
>                 goto cchunk_out;
>
> -       /* For now array only one chunk long, will make more flexible lat=
er */
> -       pcchunk->ChunkCount =3D cpu_to_le32(1);
> -       pcchunk->Reserved =3D 0;
> -       pcchunk->Reserved2 =3D 0;
> +       while (total_bytes_left > 0) {
> +
> +               /* Store previous offsets to allow rewind */
> +               src_off_prev =3D src_off;
> +               dst_off_prev =3D dst_off;
> +
> +               trace_smb3_copychunk_iter(xid, src_file->fid.volatile_fid=
,
> +                                         dst_file->fid.volatile_fid, tco=
n->tid,
> +                                         tcon->ses->Suid, src_off, dst_o=
ff, len);
>
> -       tcon =3D tlink_tcon(trgtfile->tlink);
> +               chunks =3D 0;
> +               copy_bytes =3D 0;
> +               copy_bytes_left =3D umin(total_bytes_left, tcon->max_byte=
s_copy);
> +               while (copy_bytes_left > 0 && chunks < chunk_count) {
> +                       chunk =3D &cc_req->Chunks[chunks++];
>
> -       trace_smb3_copychunk_enter(xid, srcfile->fid.volatile_fid,
> -                                  trgtfile->fid.volatile_fid, tcon->tid,
> -                                  tcon->ses->Suid, src_off, dest_off, le=
n);
> +                       chunk->SourceOffset =3D cpu_to_le64(src_off);
> +                       chunk->TargetOffset =3D cpu_to_le64(dst_off);
>
> -       while (len > 0) {
> -               pcchunk->SourceOffset =3D cpu_to_le64(src_off);
> -               pcchunk->TargetOffset =3D cpu_to_le64(dest_off);
> -               pcchunk->Length =3D
> -                       cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk=
));
> +                       chunk_bytes =3D umin(copy_bytes_left, tcon->max_b=
ytes_chunk);
> +
> +                       chunk->Length =3D cpu_to_le32(chunk_bytes);
> +                       chunk->Reserved =3D 0;
> +
> +                       src_off +=3D chunk_bytes;
> +                       dst_off +=3D chunk_bytes;
> +
> +                       copy_bytes_left -=3D chunk_bytes;
> +                       copy_bytes +=3D chunk_bytes;
> +               }
> +
> +               cc_req->ChunkCount =3D cpu_to_le32(chunks);
> +               /* Buffer is zeroed, no need to set pcchunk->Reserved =3D=
 0 */
>
>                 /* Request server copy to target from src identified by k=
ey */
> -               kfree(retbuf);
> -               retbuf =3D NULL;
> -               rc =3D SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid=
,
> -                       trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_W=
RITE,
> -                       (char *)pcchunk, sizeof(struct copychunk_ioctl),
> -                       CIFSMaxBufSize, (char **)&retbuf, &ret_data_len);
> +               kfree(cc_rsp);
> +               cc_rsp =3D NULL;
> +               rc =3D SMB2_ioctl(xid, tcon, dst_file->fid.persistent_fid=
,
> +                       dst_file->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_W=
RITE,
> +                       (char *)cc_req, struct_size(cc_req, Chunks, chunk=
s),
> +                       CIFSMaxBufSize, (char **)&cc_rsp, &ret_data_len);
> +
> +               if (ret_data_len !=3D sizeof(struct copychunk_ioctl_rsp))=
 {
> +                       cifs_tcon_dbg(VFS, "Copychunk invalid response: r=
esponse size does not match expected size\n");
> +                       rc =3D -EIO;
> +                       goto cchunk_out;
> +               }
> +
>                 if (rc =3D=3D 0) {
> -                       if (ret_data_len !=3D
> -                                       sizeof(struct copychunk_ioctl_rsp=
)) {
> -                               cifs_tcon_dbg(VFS, "Invalid cchunk respon=
se size\n");
> +                       bytes_written =3D le32_to_cpu(cc_rsp->TotalBytesW=
ritten);
> +                       if (bytes_written =3D=3D 0) {
> +                               cifs_tcon_dbg(VFS, "Copychunk invalid res=
ponse: no bytes copied\n");
>                                 rc =3D -EIO;
>                                 goto cchunk_out;
>                         }
> -                       if (retbuf->TotalBytesWritten =3D=3D 0) {
> -                               cifs_dbg(FYI, "no bytes copied\n");
> +                       /* Check if server claimed to write more than we =
asked */
> +                       if (bytes_written > copy_bytes) {
> +                               cifs_tcon_dbg(VFS, "Copychunk invalid res=
ponse: unexpected value for TotalBytesWritten\n");
>                                 rc =3D -EIO;
>                                 goto cchunk_out;
>                         }
> -                       /*
> -                        * Check if server claimed to write more than we =
asked
> -                        */
> -                       if (le32_to_cpu(retbuf->TotalBytesWritten) >
> -                           le32_to_cpu(pcchunk->Length)) {
> -                               cifs_tcon_dbg(VFS, "Invalid copy chunk re=
sponse\n");
> +
> +                       chunks_written =3D le32_to_cpu(cc_rsp->ChunksWrit=
ten);
> +                       if (chunks_written > chunks) {
> +                               cifs_tcon_dbg(VFS, "Copychunk invalid res=
ponse: Invalid num chunks written\n");
>                                 rc =3D -EIO;
>                                 goto cchunk_out;
>                         }
> -                       if (le32_to_cpu(retbuf->ChunksWritten) !=3D 1) {
> -                               cifs_tcon_dbg(VFS, "Invalid num chunks wr=
itten\n");
> -                               rc =3D -EIO;
> -                               goto cchunk_out;
> +
> +                       /* Partial write: rewind */
> +                       if (bytes_written < copy_bytes) {
> +                               u32 delta =3D copy_bytes - bytes_written;
> +
> +                               src_off -=3D delta;
> +                               dst_off -=3D delta;
>                         }
> -                       chunks_copied++;
> -
> -                       bytes_written =3D le32_to_cpu(retbuf->TotalBytesW=
ritten);
> -                       src_off +=3D bytes_written;
> -                       dest_off +=3D bytes_written;
> -                       len -=3D bytes_written;
> -                       total_bytes_written +=3D bytes_written;
> -
> -                       cifs_dbg(FYI, "Chunks %d PartialChunk %d Total %z=
u\n",
> -                               le32_to_cpu(retbuf->ChunksWritten),
> -                               le32_to_cpu(retbuf->ChunkBytesWritten),
> -                               bytes_written);
> -                       trace_smb3_copychunk_done(xid, srcfile->fid.volat=
ile_fid,
> -                               trgtfile->fid.volatile_fid, tcon->tid,
> -                               tcon->ses->Suid, src_off, dest_off, len);
> -               } else if (rc =3D=3D -EINVAL) {
> -                       if (ret_data_len !=3D sizeof(struct copychunk_ioc=
tl_rsp))
> -                               goto cchunk_out;
>
> -                       cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy=
 %d\n",
> -                               le32_to_cpu(retbuf->ChunksWritten),
> -                               le32_to_cpu(retbuf->ChunkBytesWritten),
> -                               le32_to_cpu(retbuf->TotalBytesWritten));
> +                       total_bytes_left -=3D bytes_written;
>
> +               } else if (rc =3D=3D -EINVAL) {
>                         /*
> -                        * Check if this is the first request using these=
 sizes,
> -                        * (ie check if copy succeed once with original s=
izes
> -                        * and check if the server gave us different size=
s after
> -                        * we already updated max sizes on previous reque=
st).
> -                        * if not then why is the server returning an err=
or now
> +                        * Check if server is not asking us to reduce siz=
e.
> +                        *
> +                        * Note: As per MS-SMB2 2.2.32.1, the values retu=
rned
> +                        * in cc_rsp are not strictly lower than what exi=
sted
> +                        * before.
> +                        *
>                          */
> -                       if ((chunks_copied !=3D 0) || chunk_sizes_updated=
)
> -                               goto cchunk_out;
> -
> -                       /* Check that server is not asking us to grow siz=
e */
> -                       if (le32_to_cpu(retbuf->ChunkBytesWritten) <
> -                                       tcon->max_bytes_chunk)
> -                               tcon->max_bytes_chunk =3D
> -                                       le32_to_cpu(retbuf->ChunkBytesWri=
tten);
> -                       else
> -                               goto cchunk_out; /* server gave us bogus =
size */
> +                       if (le32_to_cpu(cc_rsp->ChunksWritten) < tcon->ma=
x_chunks) {
> +                               cifs_tcon_dbg(VFS, "Copychunk MaxChunks u=
pdated: %u -> %u\n",
> +                                             tcon->max_chunks,
> +                                             le32_to_cpu(cc_rsp->ChunksW=
ritten));
> +                               tcon->max_chunks =3D le32_to_cpu(cc_rsp->=
ChunksWritten);
> +                       }
> +                       if (le32_to_cpu(cc_rsp->ChunkBytesWritten) < tcon=
->max_bytes_chunk) {
> +                               cifs_tcon_dbg(VFS, "Copychunk MaxBytesChu=
nk updated: %u -> %u\n",
> +                                             tcon->max_bytes_chunk,
> +                                             le32_to_cpu(cc_rsp->ChunkBy=
tesWritten));
> +                               tcon->max_bytes_chunk =3D le32_to_cpu(cc_=
rsp->ChunkBytesWritten);
> +                       }
> +                       if (le32_to_cpu(cc_rsp->TotalBytesWritten) < tcon=
->max_bytes_copy) {
> +                               cifs_tcon_dbg(VFS, "Copychunk MaxBytesCop=
y updated: %u -> %u\n",
> +                                             tcon->max_bytes_copy,
> +                                             le32_to_cpu(cc_rsp->TotalBy=
tesWritten));
> +                               tcon->max_bytes_copy =3D le32_to_cpu(cc_r=
sp->TotalBytesWritten);
> +                       }
>
> -                       /* No need to change MaxChunks since already set =
to 1 */
> -                       chunk_sizes_updated =3D true;
> -               } else
> +                       trace_smb3_copychunk_err(xid, src_file->fid.volat=
ile_fid,
> +                                                dst_file->fid.volatile_f=
id, tcon->tid,
> +                                                tcon->ses->Suid, src_off=
, dst_off, len, rc);
> +
> +                       /* Rewind */
> +                       if (retries++ < 2) {
> +                               src_off =3D src_off_prev;
> +                               dst_off =3D dst_off_prev;
> +                               kfree(cc_req);
> +                               cc_req =3D NULL;
> +                               goto retry;
> +                       } else
> +                               goto cchunk_out;
> +               } else { /* Unexpected */
> +                       trace_smb3_copychunk_err(xid, src_file->fid.volat=
ile_fid,
> +                                                dst_file->fid.volatile_f=
id, tcon->tid,
> +                                                tcon->ses->Suid, src_off=
, dst_off, len, rc);
>                         goto cchunk_out;
> +               }
>         }
>
> +       trace_smb3_copychunk_done(xid, src_file->fid.volatile_fid,
> +                                 dst_file->fid.volatile_fid, tcon->tid,
> +                                 tcon->ses->Suid, src_off, dst_off, len)=
;
> +
>  cchunk_out:
> -       kfree(pcchunk);
> -       kfree(retbuf);
> +       kfree(cc_req);
> +       kfree(cc_rsp);
>         if (rc)
>                 return rc;
>         else
> -               return total_bytes_written;
> +               return len;
>  }
>
>  static int
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 3c09a58dfd07..101024f8f725 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -201,16 +201,20 @@ struct resume_key_req {
>         char    Context[];      /* ignored, Windows sets to 4 bytes of ze=
ro */
>  } __packed;
>
> +
> +struct copychunk {
> +       __le64 SourceOffset;
> +       __le64 TargetOffset;
> +       __le32 Length;
> +       __le32 Reserved;
> +} __packed;
> +
>  /* this goes in the ioctl buffer when doing a copychunk request */
>  struct copychunk_ioctl {
>         char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
> -       __le32 ChunkCount; /* we are only sending 1 */
> +       __le32 ChunkCount;
>         __le32 Reserved;
> -       /* array will only be one chunk long for us */
> -       __le64 SourceOffset;
> -       __le64 TargetOffset;
> -       __le32 Length; /* how many bytes to copy */
> -       __u32 Reserved2;
> +       struct copychunk Chunks[];
>  } __packed;
>
>  struct copychunk_ioctl_rsp {
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index fd650e2afc76..63871321b464 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -266,7 +266,7 @@ DEFINE_EVENT(smb3_copy_range_err_class, smb3_##name, =
\
>         TP_ARGS(xid, src_fid, target_fid, tid, sesid, src_offset, target_=
offset, len, rc))
>
>  DEFINE_SMB3_COPY_RANGE_ERR_EVENT(clone_err);
> -/* TODO: Add SMB3_COPY_RANGE_ERR_EVENT(copychunk_err) */
> +DEFINE_SMB3_COPY_RANGE_ERR_EVENT(copychunk_err);
>
>  DECLARE_EVENT_CLASS(smb3_copy_range_done_class,
>         TP_PROTO(unsigned int xid,
> @@ -319,6 +319,7 @@ DEFINE_SMB3_COPY_RANGE_DONE_EVENT(copychunk_enter);
>  DEFINE_SMB3_COPY_RANGE_DONE_EVENT(clone_enter);
>  DEFINE_SMB3_COPY_RANGE_DONE_EVENT(copychunk_done);
>  DEFINE_SMB3_COPY_RANGE_DONE_EVENT(clone_done);
> +DEFINE_SMB3_COPY_RANGE_DONE_EVENT(copychunk_iter);
>
>
>  /* For logging successful read or write */
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
