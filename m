Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA18C2AE77
	for <linux-cifs@vger.kernel.org>; Sat,  4 Oct 2025 02:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759546325; cv=none; b=HlgWXG4vK0vmG+sjDk4MxHwwe68ldzYh8NQkRhGmZ6XdLspZ+A++Y+AtPQIml921ONud4PVneRlCr1AimYAYc8rU18bNmwvcAYJy0YrSNuQghxaOJkwJIMUENU+YQVHEpz8jkizolwmkW9pdPyiAgrItqF/vE1G6cp2rqgzqvBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759546325; c=relaxed/simple;
	bh=LENceijK2rVyiZb5f19o3wvzEc4T3tlN7haXjE+p/4Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XbCUjczGFYcAaGX/cerQvi6Lh7FJiHzPgfGQDOAfPLQfd0u89q0hlLyY1Y6Rt6XNBE2+RrdoVsDpFeCFP5ThP4NWM4wwOI6CKUabmNCSYXVUpWU/OgyUzZ12UEBZiG28IOc7OxNqAZc6AuYYajQHZ9RRGvY9/89VZX0SSPgElNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KOOv8/jk; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOOv8/jk"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-799572d92b0so26275166d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 03 Oct 2025 19:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759546323; x=1760151123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=606cVu+a4TNaOLcUUYanfX39+8tNLQIyp3w/5KcznsE=;
        b=KOOv8/jk0VvfrvvmM5DwbseyfGW3rrZptTX6w7jCmtklkjO1i921K6ZQQh2lP/gruN
         XzXQuou9x5yTv8G3jAgFb3nfUZaJB6ZFGnLbobOcy5rVoUletlSD5h5/yweYb4F7/Q+I
         2r79l/uylhqkSGEJmRxRvdyN5JKdMEYRkE8js+jaKai4deROS759DQSyuJ0bM/CK37YW
         3EJn9aD+F+/6x5MdpMU1WnnQ75QveOJGKcevX0GiioqHy28m4EBZDkHn6x7qGW2CqsJ4
         3vRkEI1hccwmyY3YBVj2WkxY51hBag4NB/xxI5swIO2G+/H7u1wwDk4DbNLvtqud6205
         nDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759546323; x=1760151123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=606cVu+a4TNaOLcUUYanfX39+8tNLQIyp3w/5KcznsE=;
        b=uh7oF2QckhY4eAfqRCqdCgQvj/TxvxwrwOzjYRHRmPTlvBhQ9HilykYwRQiWyOi3UF
         uVJYgK5BT8JjUdE0ZnFMNprOmiNr0qSd9vPboSTC9ER/+5EqhIpSwUsQSVvaLvDkB/3A
         eLGXPdlujQq1ZYjIqzcTjZDVvYf460sZyesesOHyHimFqXh2UFE2WodFQeh7MZWUupt/
         ZQS92kofqi3oo5Xkjxi0XvMzMC0uqzNM5ntE+W0yRIXlA7JyUd3AMhgMcIZ/+4+UW2NP
         uJ9MSoRSyyJ/IGcnOrJxQAguYSIcWl9ms3m/0rQPNztbpWfLq0q0lZ1pRvxBToZnjJBw
         oGcg==
X-Forwarded-Encrypted: i=1; AJvYcCV/1NO/r3E8KmcVRxNQV+QipgNHyVkBbHk/Ls1cPgUp7VTK1x+lH5BC3R52CVlheIkLsD3MPudHdMML@vger.kernel.org
X-Gm-Message-State: AOJu0YwYMXKglPyJkwcIGc9QPJ7imtKKx52O+SashwsI+UUYwQjht4Z7
	Mz9wEwAjWvojn4o2dQkcqK95VfA8BAFe1LZrL6U6Q27HZd70a0jfeL3UEjA6d0rKLL0SEkjh9UM
	7Z9glzpghFXoqzCjbsz+S8z3gVp2RztE=
X-Gm-Gg: ASbGnctr9+Mk5gPQSWdkBi220OsYKKSY5u1pJt7WgsmuANpHHyYUeB9P5ctQTIQjjy8
	UEJl9Z1t7uR5mp23f1G9rIuUBpXk/usbsm3J0hbLIInPvUy2JvtqV5+zdQjXZkwm+/GCjhYZQnh
	0uMLkmnsA7tX7C2LInC8B/IhguIfTk9WINAU8rc8U400PzyNG9EDuz1u7JnglkocaoTNKrjgvqB
	JYHZYFDaykTa62DkeP2ZBZ79gt1nKEmODWIXIhf3ckyA2zJKTV5xXZC7P2f4Hj/T+ZQpud5ldFs
	P900h14oR24F0yFiYn1ZnF6aQufbHQjoUzsZw2+4apjUdCxUl1QZS0ew2mSBM2bqC6UTMFOBltl
	jzXwGM1hPXw==
X-Google-Smtp-Source: AGHT+IEYww5TsHZRhFjmYbf1sT4n34NtGRbe+YcVMxcDI9+UwaRm4J1FOCA7M/aAO4CGPe56jp1AK7RQBU+PUnmdbnk=
X-Received: by 2002:ad4:5de6:0:b0:78e:6248:ce70 with SMTP id
 6a1803df08f44-879dc7e99c8mr79406506d6.28.1759546322496; Fri, 03 Oct 2025
 19:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251004021143.230223-1-henrique.carvalho@suse.com>
In-Reply-To: <20251004021143.230223-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 3 Oct 2025 21:51:51 -0500
X-Gm-Features: AS18NWD7TRKFKi6vAJGRBnYYqPPUm0A31jIzYTAT-pQi6ZQWNijlp4--pZRln50
Message-ID: <CAH2r5mu3bd_ozSEjGiN3tXMzrnTBuHmfqy7OrQiaUGxFTqhZ6w@mail.gmail.com>
Subject: Re: [PATCH v4] smb: client: batch SRV_COPYCHUNK entries to cut round trips
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending review/testing

On Fri, Oct 3, 2025 at 9:15=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> smb2_copychunk_range() used to send a single SRV_COPYCHUNK per
> SRV_COPYCHUNK_COPY IOCTL.
>
> Implement variable Chunks[] array in struct copychunk_ioctl and fill it
> with struct copychunk (MS-SMB2 2.2.31.1.1), bounded by server-advertised
> limits.
>
> This reduces the number of IOCTL requests for large copies.
>
> While we are at it, rename a couple variables to follow the terminology
> used in the specification.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V3 -> V4:
> - fix min_t truncation to u32 issue in calc_chunk_count
>
> V2 -> V3:
> - guard against potential "Invented loads" in calc_chunk_count
>   (see https://lwn.net/Articles/793253/#Invented%20Loads -- please
>   let me know if I'm misunderstanding the concept)
> - improved comments and variable naming in calc_chunk_count
> - minor documentation improvement
> - stop log flooding (reported by Paulo Alcantara): return early on rc &&
>   rc !=3D -EINVAL right after SMB2_ioctl; only validate cc_rsp size when
>   rc =3D=3D 0 or rc =3D=3D -EINVAL
> - restructure code; drop *_iter trace; fix a comment typo (per Enzo Matsu=
miya)
> - downgrade debug level from VFS to FYI on -EINVAL (per Steve French)
>
> V1 -> V2:
> - initialize ret_data_len to 0 (per Dan Carpenter)
>
>  fs/smb/client/smb2ops.c | 306 +++++++++++++++++++++++++---------------
>  fs/smb/client/smb2pdu.h |  16 ++-
>  fs/smb/client/trace.h   |   2 +-
>  3 files changed, 207 insertions(+), 117 deletions(-)
>
>
>
>  fs/smb/client/smb2ops.c | 306 +++++++++++++++++++++++++---------------
>  fs/smb/client/smb2pdu.h |  16 ++-
>  fs/smb/client/trace.h   |   2 +-
>  3 files changed, 207 insertions(+), 117 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 058050f744c0..80114292e2c9 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1803,140 +1803,226 @@ smb2_ioctl_query_info(const unsigned int xid,
>         return rc;
>  }
>
> +/**
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
> +       u32 max_chunks =3D READ_ONCE(tcon->max_chunks);
> +       u32 max_bytes_copy =3D READ_ONCE(tcon->max_bytes_copy);
> +       u32 max_bytes_chunk =3D READ_ONCE(tcon->max_bytes_chunk);
> +       u64 need;
> +       u32 allowed;
> +
> +       if (!max_bytes_chunk || !max_bytes_copy || !max_chunks)
> +               return 0;
> +
> +       /* chunks needed for the remaining bytes */
> +       need =3D DIV_ROUND_UP_ULL(bytes_left, max_bytes_chunk);
> +       /* chunks allowed per cc request */
> +       allowed =3D DIV_ROUND_UP(max_bytes_copy, max_bytes_chunk);
> +
> +       return (u32)umin(need, umin(max_chunks, allowed));
> +}
> +
> +/**
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
> +               goto out;
> +       }
>
> -       pcchunk =3D kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
> -       if (pcchunk =3D=3D NULL)
> -               return -ENOMEM;
> +       cc_req =3D kzalloc(struct_size(cc_req, Chunks, chunk_count), GFP_=
KERNEL);
> +       if (!cc_req) {
> +               rc =3D -ENOMEM;
> +               goto out;
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
> -               goto cchunk_out;
> +               goto out;
>
> -       /* For now array only one chunk long, will make more flexible lat=
er */
> -       pcchunk->ChunkCount =3D cpu_to_le32(1);
> -       pcchunk->Reserved =3D 0;
> -       pcchunk->Reserved2 =3D 0;
> +       while (total_bytes_left > 0) {
>
> -       tcon =3D tlink_tcon(trgtfile->tlink);
> +               /* Store previous offsets to allow rewind */
> +               src_off_prev =3D src_off;
> +               dst_off_prev =3D dst_off;
>
> -       trace_smb3_copychunk_enter(xid, srcfile->fid.volatile_fid,
> -                                  trgtfile->fid.volatile_fid, tcon->tid,
> -                                  tcon->ses->Suid, src_off, dest_off, le=
n);
> +               chunks =3D 0;
> +               copy_bytes =3D 0;
> +               copy_bytes_left =3D umin(total_bytes_left, tcon->max_byte=
s_copy);
> +               while (copy_bytes_left > 0 && chunks < chunk_count) {
> +                       chunk =3D &cc_req->Chunks[chunks++];
>
> -       while (len > 0) {
> -               pcchunk->SourceOffset =3D cpu_to_le64(src_off);
> -               pcchunk->TargetOffset =3D cpu_to_le64(dest_off);
> -               pcchunk->Length =3D
> -                       cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk=
));
> +                       chunk->SourceOffset =3D cpu_to_le64(src_off);
> +                       chunk->TargetOffset =3D cpu_to_le64(dst_off);
> +
> +                       chunk_bytes =3D umin(copy_bytes_left, tcon->max_b=
ytes_chunk);
> +
> +                       chunk->Length =3D cpu_to_le32(chunk_bytes);
> +                       /* Buffer is zeroed, no need to set chunk->Reserv=
ed =3D 0 */
> +
> +                       src_off +=3D chunk_bytes;
> +                       dst_off +=3D chunk_bytes;
> +
> +                       copy_bytes_left -=3D chunk_bytes;
> +                       copy_bytes +=3D chunk_bytes;
> +               }
> +
> +               cc_req->ChunkCount =3D cpu_to_le32(chunks);
> +               /* Buffer is zeroed, no need to set cc_req->Reserved =3D =
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
> +               if (rc && rc !=3D -EINVAL)
> +                       goto out;
> +
> +               if (unlikely(ret_data_len !=3D sizeof(*cc_rsp))) {
> +                       cifs_tcon_dbg(VFS, "Copychunk invalid response: s=
ize %u/%zu\n",
> +                                     ret_data_len, sizeof(*cc_rsp));
> +                       rc =3D -EIO;
> +                       goto out;
> +               }
> +
> +               bytes_written =3D le32_to_cpu(cc_rsp->TotalBytesWritten);
> +               chunks_written =3D le32_to_cpu(cc_rsp->ChunksWritten);
> +               chunk_bytes =3D le32_to_cpu(cc_rsp->ChunkBytesWritten);
> +
>                 if (rc =3D=3D 0) {
> -                       if (ret_data_len !=3D
> -                                       sizeof(struct copychunk_ioctl_rsp=
)) {
> -                               cifs_tcon_dbg(VFS, "Invalid cchunk respon=
se size\n");
> -                               rc =3D -EIO;
> -                               goto cchunk_out;
> -                       }
> -                       if (retbuf->TotalBytesWritten =3D=3D 0) {
> -                               cifs_dbg(FYI, "no bytes copied\n");
> -                               rc =3D -EIO;
> -                               goto cchunk_out;
> -                       }
> -                       /*
> -                        * Check if server claimed to write more than we =
asked
> -                        */
> -                       if (le32_to_cpu(retbuf->TotalBytesWritten) >
> -                           le32_to_cpu(pcchunk->Length)) {
> -                               cifs_tcon_dbg(VFS, "Invalid copy chunk re=
sponse\n");
> +                       /* Check if server claimed to write more than we =
asked */
> +                       if (unlikely(!bytes_written || bytes_written > co=
py_bytes ||
> +                                    !chunks_written || chunks_written > =
chunks)) {
> +                               cifs_tcon_dbg(VFS, "Copychunk invalid res=
ponse: bytes written %u/%u, chunks written %u/%u\n",
> +                                             bytes_written, copy_bytes, =
chunks_written, chunks);
>                                 rc =3D -EIO;
> -                               goto cchunk_out;
> +                               goto out;
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
> -
> -                       cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy=
 %d\n",
> -                               le32_to_cpu(retbuf->ChunksWritten),
> -                               le32_to_cpu(retbuf->ChunkBytesWritten),
> -                               le32_to_cpu(retbuf->TotalBytesWritten));
>
> -                       /*
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
> -                        */
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
> +                       total_bytes_left -=3D bytes_written;
> +                       continue;
> +               }
>
> -                       /* No need to change MaxChunks since already set =
to 1 */
> -                       chunk_sizes_updated =3D true;
> -               } else
> -                       goto cchunk_out;
> +               /*
> +                * Check if server is not asking us to reduce size.
> +                *
> +                * Note: As per MS-SMB2 2.2.32.1, the values returned
> +                * in cc_rsp are not strictly lower than what existed
> +                * before.
> +                */
> +               if (bytes_written < tcon->max_bytes_copy) {
> +                       cifs_tcon_dbg(FYI, "Copychunk MaxBytesCopy update=
d: %u -> %u\n",
> +                                     tcon->max_bytes_copy, bytes_written=
);
> +                       tcon->max_bytes_copy =3D bytes_written;
> +               }
> +
> +               if (chunks_written < tcon->max_chunks) {
> +                       cifs_tcon_dbg(FYI, "Copychunk MaxChunks updated: =
%u -> %u\n",
> +                                     tcon->max_chunks, chunks_written);
> +                       tcon->max_chunks =3D chunks_written;
> +               }
> +
> +               if (chunk_bytes < tcon->max_bytes_chunk) {
> +                       cifs_tcon_dbg(FYI, "Copychunk MaxBytesChunk updat=
ed: %u -> %u\n",
> +                                     tcon->max_bytes_chunk, chunk_bytes)=
;
> +                       tcon->max_bytes_chunk =3D chunk_bytes;
> +               }
> +
> +               /* reset to last offsets */
> +               if (retries++ < 2) {
> +                       src_off =3D src_off_prev;
> +                       dst_off =3D dst_off_prev;
> +                       kfree(cc_req);
> +                       cc_req =3D NULL;
> +                       goto retry;
> +               }
> +
> +               break;
>         }
>
> -cchunk_out:
> -       kfree(pcchunk);
> -       kfree(retbuf);
> -       if (rc)
> +out:
> +       kfree(cc_req);
> +       kfree(cc_rsp);
> +       if (rc) {
> +               trace_smb3_copychunk_err(xid, src_file->fid.volatile_fid,
> +                                        dst_file->fid.volatile_fid, tcon=
->tid,
> +                                        tcon->ses->Suid, src_off, dst_of=
f, len, rc);
>                 return rc;
> -       else
> -               return total_bytes_written;
> +       } else {
> +               trace_smb3_copychunk_done(xid, src_file->fid.volatile_fid=
,
> +                                         dst_file->fid.volatile_fid, tco=
n->tid,
> +                                         tcon->ses->Suid, src_off, dst_o=
ff, len);
> +               return len;
> +       }
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
> index fd650e2afc76..28e00c34df1c 100644
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
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
