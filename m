Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6538472F85
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 20:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664728; cv=pass; b=ERkg+i/DWt4rNkZexcUjH4gmzTY3AiExUgRXxkg0/kXsPNdeb+8NzOw0u01lf65D1RZJhAJx9ncotsj0yd2UqoKb8Ol0ApHtWJZiHoNuNQjDDHsTPrYXIpldKMtCQS1cEg32GF6LAbGWydJDVN/94RDylXP9bgg0pqEShJeUjxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664728; c=relaxed/simple;
	bh=ouU5vnObNCRXXRCAJUl0+eFGH1itc8MD2tIvm/u4LRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A+G9/WpI8YBQakTtkVLjospj/7VzaVN9b4ERiFv3EfAP7VGS6rF5FW7m3hvJuGfR9fW/hOji1ohUl0TkMBnVwKyohk0RdEqnERPAHiKygJzmkzohA4YKqt74ft7yIUVrkAzIYz7rEaicWwK+ptjS+FyOKFxTV2M1m8AxHmDE4Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MuAXtOgd; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MuAXtOgd"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e6c4a867cso550862185a.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 13:12:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784664725; cv=none;
        d=google.com; s=arc-20260327;
        b=URohISiogVk/4PaDfNAaGVy+5jp2k63pf9XnC1KxICb9ygUhD96kXUkDOTR+sQIksR
         9PfaanzAbFpojkK8G8eaa6/vxEUCD10V48//LDR2wqV6/nGnct5dk5pLS9hKRqkP17Yb
         +dnnmHSwSp6ExpbE1Fi4V7zUrPDI2MQJOaYFRLo4plsIK9Cst6sN/Ix3GuzMsS3dCTJv
         gsDCoJFk2rIe1XLHiSd78mflejWBPaj8nsRrgHvXfRr6xgsam+SPbrN53Eg8+XH6Q6aW
         MFKyFiYopAA6c74D7Ft9sAi8I4j91hPwEf2Cxyh2SfWHp1OlfF8jX4Ft4GNM9P/neD3x
         K+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XgkXeWTAX9bLtJJjXZMesN6EnzMBmqE1pVXr319IAi4=;
        fh=mfQpPEEx8x+g1A+wk+xNtKttI3jfj3oqJoAzQ6gFuKQ=;
        b=UOubEYttfC032/L3OtF+kKNezND0lABAU0lYVJmvFBTvKes/D6Sykkf6yC9aKMaOZc
         RGFqU/it7Pk9X5qd0UJcRVW6gdTm08W9YuyQLLrnC7HTp/q4ZK9LBin5dIhXQTzJCR5+
         puKf5ss70s4otcPwGo7OpId21jgEzbUihupwkNng3kSK0iAE+hQvS5IDnYVIbrzahOEA
         9ue/yVde4fVELzdcyYMJ4GxvsQ1DH5fcF30vpvP150AyfJyvxF9oIh+3Ei+jTKrdysVu
         0FF0CLdnG3JqYsLZWu6mc6Y5NLA5v4nf5BQNA5FNiCAgKVink/W8Sd6hbPB0ht/TH82f
         zUCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784664725; x=1785269525; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XgkXeWTAX9bLtJJjXZMesN6EnzMBmqE1pVXr319IAi4=;
        b=MuAXtOgdgh3mnAtIQhRQSncDIXnsFkUCKHcKkKj04KnzkdDM99p99NT5qckFcXiOdU
         1DgIfTZF78g1OE0nIyDhQqH90sziwRtBcSoCV7Z0O6XazEzo7jbeId6hqJ4isuye3IPN
         0r6hoBRd98e8wNyfPwuMMh1I7yOcc6br9cU+F2+xwOY/YZvJYxYceNiZWoH/EI1LDeqk
         AwxBw1ETqFjcTThQVviO9KsQFKkCctdb+3Az7ETY7l+upM3c6p8WUZqpZMMZkNET6JT8
         DJgfA8kyoht9pPzcgdbP/wdQhm5Eqw6tcpRrZND11WOvHx/EHAl10tPqJCiZPtibLMY1
         gxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784664725; x=1785269525;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XgkXeWTAX9bLtJJjXZMesN6EnzMBmqE1pVXr319IAi4=;
        b=EyTWhaKNmM6zhZHi/xUAYcxL6GqQiSACdaybJx7z7/YuS/qsRuaIGTyQs36n3gyy5b
         ZScPKZ94DsqKGAWtL6t1qGlBP+hZreVJ9341AJqKnDtBpyRrXnO5aycJSfvmNwKHUhIV
         DOE+41FVsOcqVznCOUNSikyFRP3zheR+mud5sRQYgPo7OCko+GB/zUIJY8hPBnFs9hpz
         j5qhf68Ahp+2AyEXWVuOGM9Guhv3nxRf9siVr3NUYxmBneMLhjoC2qgzQiKUX7Q0mVex
         5dcDWR8DSKLnetO3S3o9j84By6XayP+Yq1XWXmyR7r9kBCuVu4JHDbRpmX32DQOmjjdO
         I2Ag==
X-Gm-Message-State: AOJu0Yw4pTfH2TzBQPGN6qJoIr10mlg3DNjFiheIOx92XdfnwBFwGe4L
	cOLSIqNlUDPIwt5AtdvLpkQ9acBUxonVPBozZSN36FqLTgwa2+ZusCXCEli9hmEFMdPBTUrzlZX
	Arw/+l4VXQiVKcUTaP407ZTbHannPOWRrg/mG
X-Gm-Gg: AfdE7cnIpAjA4OiGd9cLsSPvHK100ByN8Pqrgzu3xLSs7KxIoqjHe95BLSw4qOMmxQQ
	BPN2a0kvfxhWsfIGD41+A8dphCb3fsL60cp1NLI9iJcTE7XLzBCIfyLPKC68LnOnIjKWJuG0dcy
	fVzVnYz5n76QbvV0pTGjRSeaRTh3HjkQNWjXQzUeSDbpe+bFviCpWh+JskKuF5bgiaggfPoe0sV
	Q5SveV+A4dH0vbodUY7Qxij37Pb88iXekHKGIaybfF2u788bWuFjBKdCQketaNZA5EF3YYvc2Mb
	V33dULZOQrhRBFhmMvdAqxXquYWnl6wTJ4erJS/+07FcsBtBSv82ztIi4QJ3okKjF+uGEOAA27t
	DOteeXYxMT3ZJew3aPNIVVOgHsLBQ4KxnEOKSjcITsYwUx2j6ny8j984YUBSGpDt21V5MZjAfZr
	PW5yNgJPy+XKQ=
X-Received: by 2002:a05:620a:268c:b0:92e:73bf:e948 with SMTP id
 af79cd13be357-930b416daebmr1992827485a.57.1784664725440; Tue, 21 Jul 2026
 13:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721172755.41346-1-carl@jpartners.org>
In-Reply-To: <20260721172755.41346-1-carl@jpartners.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Jul 2026 15:11:53 -0500
X-Gm-Features: AUfX_myfUAi1lsKMXMox3785AvEgqaS9SMvwgo2tZ9UrWpDjM6qhmqZl374U73w
Message-ID: <CAH2r5mvvc=CsqpZxJXh2QFpgwo6MNiQcgq0E87hqXAiKONkXzw@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: handle STATUS_STOPPED_ON_SYMLINK
 responses without a symlink target
To: Carl Johnson <carl@jpartners.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	=?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next and added Cc:stable

On Tue, Jul 21, 2026 at 12:36=E2=80=AFPM Carl Johnson <carl@jpartners.org> =
wrote:
>
> The macOS built-in SMB server returns STATUS_STOPPED_ON_SYMLINK for a
> CREATE on a path whose final component is a symlink, but it does not
> include a Symbolic Link Error Response in the error data: both
> ErrorContextCount and ByteCount are zero, so the symlink target is not
> present in the response at all.  Per [MS-SMB2] section 2.2.2 such a
> response should carry a valid Symbolic Link Error Response, so this is a
> server bug, but the target can still be retrieved with
> FSCTL_GET_REPARSE_POINT.
>
> Frame from a capture against macOS 26.5.2 (build 25F84):
>
>     SMB2 hdr : Status=3D0x8000002d STATUS_STOPPED_ON_SYMLINK, Cmd=3DCreat=
e
>     Error Rsp: StructureSize=3D0x0009
>                Error Context Count: 0
>                Byte Count: 0
>                Error Data: 00
>
> symlink_data() cannot find a struct smb2_symlink_err_rsp in such a
> response and returns -EINVAL, which parse_create_response() propagates,
> so smb2_query_path_info() bails out at
>
>         if (rc || !data->reparse_point)
>                 goto out;
>
> before it can retry with SMB2_OP_GET_REPARSE.  stat(), readlink() and ls
> of any server-side symlink then fail with -EINVAL:
>
>   $ ls -la Config
>   l????????? ? ? ? ? ? Config.json
>   $ stat Config/Config.json
>   stat: cannot statx 'Config/Config.json': Invalid argument
>
> A 5.10 client resolves these symlinks correctly against the same server
> and share, so this is a regression for Apple SMB servers.
>
> Handle it in several places:
>
>  - symlink_data() detects the empty response (ErrorContextCount and
>    ByteCount both zero) and returns a distinct -ENODATA, so that "server
>    did not send the target" can be told apart from a genuinely malformed
>    response and only this case is worked around.
>
>  - parse_create_response() treats -ENODATA like
>    STATUS_IO_REPARSE_TAG_NOT_HANDLED, which does not carry the target
>    either: leave the reparse tag unset and clear rc, so the existing
>    SMB2_OP_GET_REPARSE path retrieves the target.
>
>  - smb2_query_path_info() only fixes up the symlink target type when the
>    target is already known.  SMB2_OP_GET_REPARSE sets data->reparse.tag
>    but does not parse the target out of the reparse buffer; that happens
>    later, in reparse_info_to_fattr().  Without this check
>    smb2_fix_symlink_target_type() is called with a NULL target and
>    returns -EIO.  This could not happen with servers that send the target
>    inline and therefore skip SMB2_OP_GET_REPARSE.
>
>  - smb2_open_file() maps -ENODATA to -EIO, matching
>    STATUS_IO_REPARSE_TAG_NOT_HANDLED, so its callers retrieve the target
>    with SMB2_OP_GET_REPARSE as well.
>
> Tested on Debian 13, kernel 6.18.38 (armv7), against macOS 26.5.2:
> symlinks now resolve, including relative, parent-traversing and directory
> symlinks, and reads through symlinks succeed.
>
> Co-developed-by: Pali Roh=C3=A1r <pali@kernel.org>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> Signed-off-by: Carl Johnson <carl@jpartners.org>
> ---
> v2: rebased onto cifs-2.6 for-next; no functional change.  v1 was generat=
ed
>     against the 6.18.38 stable tree and did not apply to mainline/for-nex=
t.
>
>  fs/smb/client/smb2file.c  | 21 +++++++++++++++++++++
>  fs/smb/client/smb2inode.c | 23 ++++++++++++++++++++---
>  2 files changed, 41 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index 5ef919b..f35b648 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -30,6 +30,19 @@ static struct smb2_symlink_err_rsp *symlink_data(const=
 struct kvec *iov)
>         u8 *end =3D (u8 *)err + iov->iov_len;
>         u32 len;
>
> +       /*
> +        * Per [MS-SMB2] section 2.2.2, a STATUS_STOPPED_ON_SYMLINK respo=
nse has to
> +        * carry a Symbolic Link Error Response, so ByteCount cannot be z=
ero.  Some
> +        * servers (e.g. the macOS built-in SMB server) violate this and =
return an
> +        * empty error response, with both ErrorContextCount and ByteCoun=
t set to
> +        * zero, i.e. without the symlink target.  Detect this and return=
 -ENODATA
> +        * so that callers can tell "server did not send the target" apar=
t from a
> +        * malformed response, and retrieve the target with FSCTL_GET_REP=
ARSE_POINT
> +        * instead.
> +        */
> +       if (!err->ErrorContextCount && !le32_to_cpu(err->ByteCount))
> +               return ERR_PTR(-ENODATA);
> +
>         if (err->ErrorContextCount) {
>                 struct smb2_error_context_rsp *p;
>
> @@ -199,6 +212,14 @@ int smb2_open_file(const unsigned int xid, struct ci=
fs_open_parms *oparms,
>                         rc =3D smb2_parse_symlink_response(oparms->cifs_s=
b, &err_iov,
>                                                          oparms->path,
>                                                          &data->symlink_t=
arget);
> +                       /*
> +                        * If smb2_parse_symlink_response returned -ENODA=
TA then the
> +                        * symlink_target was not sent. Treat this as if =
the SMB2_open()
> +                        * failed with STATUS_IO_REPARSE_TAG_NOT_HANDLED =
status, which is
> +                        * indicated by the -EIO errno.
> +                        */
> +                       if (rc =3D=3D -ENODATA)
> +                               rc =3D -EIO;
>                         if (!rc) {
>                                 memset(&data->fi, 0, sizeof(data->fi));
>                                 oparms->create_options |=3D OPEN_REPARSE_=
POINT;
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 6c9c229..213bc29 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -792,9 +792,19 @@ static int parse_create_response(struct cifs_open_in=
fo_data *data,
>                 rc =3D smb2_parse_symlink_response(cifs_sb, iov,
>                                                  full_path,
>                                                  &data->symlink_target);
> -               if (rc)
> +               if (rc !=3D 0 && rc !=3D -ENODATA)
>                         return rc;
> -               tag =3D IO_REPARSE_TAG_SYMLINK;
> +               /*
> +                * -ENODATA means that the response was parsed but did no=
t contain
> +                * the symlink target at all (see symlink_data()).  Treat=
 it like
> +                * STATUS_IO_REPARSE_TAG_NOT_HANDLED, which does not cont=
ain it
> +                * either: leave the tag unset and clear rc, so that the =
caller
> +                * retrieves the target with SMB2_OP_GET_REPARSE.
> +                */
> +               if (rc =3D=3D -ENODATA)
> +                       rc =3D 0;
> +               else
> +                       tag =3D IO_REPARSE_TAG_SYMLINK;
>                 reparse_point =3D true;
>                 break;
>         case STATUS_SUCCESS:
> @@ -987,7 +997,14 @@ int smb2_query_path_info(const unsigned int xid,
>                                 rc =3D -EOPNOTSUPP;
>                 }
>
> -               if (data->reparse.tag =3D=3D IO_REPARSE_TAG_SYMLINK && !r=
c) {
> +               /*
> +                * If the symlink was already parsed in create response t=
hen it is needed to fix
> +                * its type now (after the second call with OPEN_REPARSE_=
POINT which filled the
> +                * data->fi.Attributes). If the symlink was not parsed in=
 create response then
> +                * the data->symlink_target was not filled yet and then t=
he type will be fixed
> +                * later after data->symlink_target is filled.
> +                */
> +               if (data->reparse.tag =3D=3D IO_REPARSE_TAG_SYMLINK && !r=
c && data->symlink_target) {
>                         bool directory =3D le32_to_cpu(data->fi.Attribute=
s) & ATTR_DIRECTORY;
>                         rc =3D smb2_fix_symlink_target_type(&data->symlin=
k_target, directory, cifs_sb);
>                 }
> --
> 2.50.1 (Apple Git-155)
>
>


--=20
Thanks,

Steve
