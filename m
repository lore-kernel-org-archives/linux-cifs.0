Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF793D565F
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 08:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933143; cv=none; b=Ds/RRG4c+ekqBlUiE+jGWdvpJBt+jqty0bCtf5mk2PBTujYhunRSfngLZiNt1vmYL0e7D5qvFglWc8PIFIxNGbqrUZmwIknDDOGX+wpsGNykjJVJ8+7MViknmW+TWf8MI/BB8PILW0/uNfmKpPJRsf3dE6LskNB71VEBttIo0Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933143; c=relaxed/simple;
	bh=02RgzUA6Aphy31UxX62Fk5g5U66JoFRi2vZcmHy8gcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nz1WoBLrfvAW5qpiB3oQ9c5CLO20BIaS0o5scKAk1xAt1ZjAF+8LUwTVxj7N2+ApMpZHy9ngr8ScXyAU/VMy1qP4h6lyrLFaRB7auEe8htGfqi4OQMuHbjES82wrUBDNbOdJqYZeZnHB7niBSLYFH+hIiaeE1vdPJ67AcvrJFdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6cdq2qe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6cdq2qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122661F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 08:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783933142;
	bh=MPhl5m5mM6ss/nIsTLC8FGh4YSRh/4jlhvg0ZnUD6xE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I6cdq2qe+fXSt1c3i0jIszpyDFzxkznWdc6rIPQp2proETeGTtSNIyrKzqe/9iWPt
	 aN0/txjn2KBkrMqIobII5RgJJvWK9IvCe+O0iVsJ4MPyAmDq96ScT3TVF2ibayp2Tm
	 toJJXVxfh4sWcA1uNeTmavOWAghdJelcgEcc0k9yokAzhkLv38LdvOyhkc8xgJiSDk
	 u42b7Kqavjehl29EOg8ZRCsMrzTHoxxHjISrysk7uLVS7Py+1GOdV/rTfkbi5ss+lv
	 cWp3oKSC3LOiVjytslduqhA4z5Wnoa1Ffzf4b91jOBWQLNvzsefDrXy0/mJZX2wnoT
	 8FUAhQ79ILdyQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15bf399d3bso343032266b.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 01:59:01 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz1LJHj8o0VgBxucUWlnR7CaNYHlNUXXuV00UyGiLsPf9/FS2mk
	pZI+UVltBqU9hV86+LmwrIwdTaJQZgUjKtWC/n9w5XjMFKe6ePL9dAhYOadnrXRabKBSyGQEuIC
	z0YTZD03MAKt8Q+cFsyKzZM6ANXjzoAg=
X-Received: by 2002:a17:907:e1c3:20b0:c15:fc73:65b7 with SMTP id
 a640c23a62f3a-c161e90f834mr206379266b.29.1783933140687; Mon, 13 Jul 2026
 01:59:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713071141.3909087-1-wangzhaolong@fnnas.com> <20260713071141.3909087-4-wangzhaolong@fnnas.com>
In-Reply-To: <20260713071141.3909087-4-wangzhaolong@fnnas.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 13 Jul 2026 17:58:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ymPFFLwW+a6_88LHL_tZXEuffUW8NymbSp3t+OZHosw@mail.gmail.com>
X-Gm-Features: AUfX_mz3DGcpCz_T3vDzA_LdktHSvqekh9HlF4PKIey3dGTSlGBqJ6X9gVXiz4I
Message-ID: <CAKYAXd-ymPFFLwW+a6_88LHL_tZXEuffUW8NymbSp3t+OZHosw@mail.gmail.com>
Subject: Re: [RFC 3/3] ksmbd: use splice payloads for simple SMB2 READ
To: wang zhaolong <wangzhaolong@fnnas.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 4:18=E2=80=AFPM wang zhaolong <wangzhaolong@fnnas.c=
om> wrote:
>
> From: Wang Zhaolong <wangzhaolong@fnnas.com>
Hi Wang,

Could you rebase the series on the current #ksmbd-for-next-next branch
to test this ?
>
> Use the page-backed payload path for plain TCP SMB2 READ requests of at
> least 64 KiB.
Could you provide benchmark results ? and requests smaller than 64 KiB
are unlikely to benefit from this optimization? Theoretically, it
seems like it would improve, but I am wondering how much performance
improvement there actually is.

> Unsupported collection results fall back before response
> ownership is committed; permission, locking and allocation failures retai=
n
> the existing error handling.
>
> Keep signed, encrypted, compressed, compound and RDMA requests on the
> buffered path because they require signing, response transforms, compound
> response layout, or alternate transport handling. Streams, non-regular
> files, O_DIRECT and DAX reads also remain on the buffered path.
>
> Signed-off-by: Wang Zhaolong <wangzhaolong@fnnas.com>
> ---
>  fs/smb/server/smb2pdu.c | 67 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index b73167785e87..a4a80ecc6d2f 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -7304,10 +7304,38 @@ static ssize_t smb2_read_rdma_channel(struct ksmb=
d_work *work,
>                 return err;
>
>         return length;
>  }
>
> +#define KSMBD_READ_PAYLOAD_MIN_IO_SIZE SZ_64K
> +
> +static bool smb2_read_payload_allowed(struct ksmbd_work *work,
> +                                     struct smb2_read_req *req,
> +                                     struct ksmbd_file *fp,
> +                                     size_t length, bool is_rdma_channel=
)
> +{
> +       struct ksmbd_conn *conn =3D work->conn;
> +       struct file *filp =3D fp->filp;
> +
> +       if (is_rdma_channel || length < KSMBD_READ_PAYLOAD_MIN_IO_SIZE ||
> +           !conn->transport->ops->write_read_payload)
> +               return false;
> +       if (req->Flags & SMB2_READFLAG_REQUEST_COMPRESSED)
> +               return false;
> +       if (work->next_smb2_rcv_hdr_off || le32_to_cpu(req->hdr.NextComma=
nd))
> +               return false;
> +       if (work->encrypted)
> +               return false;
> +       if (work->sess &&
> +           (work->sess->sign || conn->ops->is_sign_req(work, SMB2_READ_H=
E)))
> +               return false;
> +       if (ksmbd_stream_fd(fp) || !S_ISREG(file_inode(filp)->i_mode) ||
> +           (filp->f_flags & O_DIRECT) || IS_DAX(file_inode(filp)))
Since ksmbd does not currently open files with O_DIRECT, is the
O_DIRECT check needed here, or is it only intended as a defensive
guard for future support?
