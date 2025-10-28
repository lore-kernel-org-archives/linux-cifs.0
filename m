Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E169824169F
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761622624; cv=none; b=eARwK/4+phBWFFD98oX+vRTtdEjFHK/buK0tK17k1huduxGoH503Shf2lGfS3W1EBugX3IyPYVQHvt0/NAYEaetSjYQ0O2KPtJ7QxUVYlxLSqAk55UoA6OtL9lYcbaLJltGKKEHryC3ycsfUtczybziLxo/sm29GcHXWkkPNcZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761622624; c=relaxed/simple;
	bh=S3BmcgS4xVcrE3ZC38o3OVCMEPwsQA0vndgMWf1I4Ek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tzynYcT8RB7h3MbhL3GUiqCaMV5GpE6XTRpsIeKGUwquii9y4QtYKEPSSbYTGAeO8PpcX+4058b6QGXLBEXGuj6O+yOwSzv52GjuuTSnNahG0Qo1+PZRFZqERcGj/bDaEzyB1lLVYsScl7vPtU6j1/JBrmMBJdW+BJEq5yfZyN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8ihm4/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8ihm4/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B68C4CEF1
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761622623;
	bh=S3BmcgS4xVcrE3ZC38o3OVCMEPwsQA0vndgMWf1I4Ek=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=H8ihm4/V3h9J2U4g0hfadXd4Cc6DODYIq1QBgalD6djU5uEsML+jXMGW8DhrWEVQy
	 NW98eHrdmfM9/DwZ91vZxLXLHDzLcYcXRjJGYgWGbFXREejTySlhXsnFCiXFtQErL4
	 c+9atFs654XulqEB/EO+ojCI0D/0c5FlWdDGBXABZ4B4OGQ4dCcGRbHuV9rlXJ21sT
	 W1+sfEucdt/SxKfiPP/xvWObsEHfV/9UBy1/WITQ4zQDjcDz5K1vfDITGKcuR3qcC1
	 JBCyVxBZxwcE6usw0EEJ9LalLT0D+PJjzSmhrxus2VU60HR/FvsLTPISCaRcJMIlmB
	 6Tjg9LN1Q0dWQ==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so9371276a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 20:37:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVQc0IN6e5NfU/mJAiEQYhUiUMmJuWSpOG4k98I2RrnxqEpUfV+NkNcy5lJD0LgxQzAjd9CUboOL+KG@vger.kernel.org
X-Gm-Message-State: AOJu0YxJBikPBLIR6MZWDetZDG+tjpcFVCjPSHryQ6hjJGBoUOcEWLMu
	nj2qwbv18k23aIOVaZpz39KRZpgbZzQJbAWvtDrjuX025ieLl64e3QrN8F8rIWASGPFMjjK+DCN
	LBeE+CWYlIaXMibKN2ma29xrKkJ00f/0=
X-Google-Smtp-Source: AGHT+IHIm46+EoccTTJ5LnW+elU8mE73TC/7E0vTFszkgP2ZgToxfoPROYnBRseXtqF0pE20R3X5xIKpkYBvp1uv0vk=
X-Received: by 2002:a05:6402:1e8a:b0:634:9121:7a2d with SMTP id
 4fb4d7f45d1cf-63ed8260271mr1838920a12.26.1761622621939; Mon, 27 Oct 2025
 20:37:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev> <20251027071316.3468472-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-7-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 28 Oct 2025 12:36:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_LqhpKCJAPKm0yBC-G+tTJpVQJSoTCbEN7Gdz1kMnQDg@mail.gmail.com>
X-Gm-Features: AWmQ_bmNYe8oXKy2T2g_T5KFFqjGidYceYDSvLqYsh4hZZ6mEEN0MLYMd3Vg8Q0
Message-ID: <CAKYAXd_LqhpKCJAPKm0yBC-G+tTJpVQJSoTCbEN7Gdz1kMnQDg@mail.gmail.com>
Subject: Re: [PATCH v4 06/24] smb: move file access permission bits
 definitions to common/smb1pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 4:15=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> There are only 2 different definitions between the client and server:
>
>   - SET_FILE_READ_RIGHTS:
>     - client: rename to CLIENT_SET_FILE_READ_RIGHTS
>     - server: rename to SERVER_SET_FILE_READ_RIGHTS
>   - SET_FILE_WRITE_RIGHTS
>     - client: rename to CLIENT_SET_FILE_WRITE_RIGHTS
>     - server: rename to SERVER_SET_FILE_WRITE_RIGHTS
>
> Perhaps in the future we can change them to be the same, move them to
> common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/cifsacl.c    |   4 +-
>  fs/smb/client/cifspdu.h    | 112 ---------------------------------
>  fs/smb/common/smb1pdu.h    | 123 ++++++++++++++++++++++++++++++++++++-
>  fs/smb/common/smb2pdu.h    |   6 --
>  fs/smb/server/smb_common.h |  55 -----------------
>  fs/smb/server/smbacl.c     |   2 +-
>  6 files changed, 125 insertions(+), 177 deletions(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index ce2ebc213a1d..5c3d8eb68868 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -654,9 +654,9 @@ static void mode_to_access_flags(umode_t mode, umode_=
t bits_to_use,
>            is this but we have cleared all the bits sans RWX for
>            either user or group or other as per bits_to_use */
>         if (mode & S_IRUGO)
> -               *pace_flags |=3D SET_FILE_READ_RIGHTS;
> +               *pace_flags |=3D CLIENT_SET_FILE_READ_RIGHTS;
>         if (mode & S_IWUGO)
> -               *pace_flags |=3D SET_FILE_WRITE_RIGHTS;
> +               *pace_flags |=3D CLIENT_SET_FILE_WRITE_RIGHTS;
>         if (mode & S_IXUGO)
>                 *pace_flags |=3D SET_FILE_EXEC_RIGHTS;
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index 86167875574c..a063c98683bc 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -117,118 +117,6 @@
>  #define SMBOPEN_OTRUNC        0x0002
>  #define SMBOPEN_OAPPEND       0x0001
>
> -/*
> - * These are the file access permission bits defined in CIFS for the
> - * NTCreateAndX as well as the level 0x107
> - * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107, SMB_QUERY_FILE_A=
LL_INFO
> - * responds with the AccessFlags.
> - * The AccessFlags specifies the access permissions a caller has to the
> - * file and can have any suitable combination of the following values:
> - */
> -
> -#define FILE_READ_DATA        0x00000001  /* Data can be read from the f=
ile   */
> -                                         /* or directory child entries c=
an   */
> -                                         /* be listed together with the =
     */
> -                                         /* associated child attributes =
     */
> -                                         /* (so the FILE_READ_ATTRIBUTES=
 on  */
> -                                         /* the child entry is not neede=
d)   */
> -#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the =
file  */
> -                                         /* or new file can be created i=
n    */
> -                                         /* the directory               =
     */
> -#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the=
 file */
> -                                         /* (for non-local files over SM=
B it */
> -                                         /* is same as FILE_WRITE_DATA) =
     */
> -                                         /* or new subdirectory can be  =
     */
> -                                         /* created in the directory    =
     */
> -#define FILE_READ_EA          0x00000008  /* Extended attributes associa=
ted   */
> -                                         /* with the file can be read   =
     */
> -#define FILE_WRITE_EA         0x00000010  /* Extended attributes associa=
ted   */
> -                                         /* with the file can be written=
     */
> -#define FILE_EXECUTE          0x00000020  /*Data can be read into memory=
 from */
> -                                         /* the file using system paging=
 I/O */
> -                                         /* for executing the file / scr=
ipt  */
> -                                         /* or right to traverse directo=
ry   */
> -                                         /* (but by default all users ha=
ve   */
> -                                         /* directory bypass traverse   =
     */
> -                                         /* privilege and do not need th=
is   */
> -                                         /* permission on directories at=
 all)*/
> -#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted =
from  */
> -                                         /* the directory (so the DELETE=
 on  */
> -                                         /* the child entry is not neede=
d)   */
> -#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with =
the   */
> -                                         /* file or directory can be rea=
d    */
> -#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with =
the   */
> -                                         /* file or directory can be wri=
tten */
> -#define DELETE                0x00010000  /* The file or dir can be dele=
ted   */
> -#define READ_CONTROL          0x00020000  /* The discretionary access co=
ntrol */
> -                                         /* list and ownership associate=
d    */
> -                                         /* with the file or dir can be =
read */
> -#define WRITE_DAC             0x00040000  /* The discretionary access co=
ntrol */
> -                                         /* list associated with the fil=
e or */
> -                                         /* directory can be written    =
     */
> -#define WRITE_OWNER           0x00080000  /* Ownership information assoc=
iated */
> -                                         /* with the file/dir can be wri=
tten */
> -#define SYNCHRONIZE           0x00100000  /* The file handle can waited =
on to */
> -                                         /* synchronize with the complet=
ion  */
> -                                         /* of an input/output request  =
     */
> -#define SYSTEM_SECURITY       0x01000000  /* The system access control l=
ist   */
> -                                         /* associated with the file or =
     */
> -                                         /* directory can be read or wri=
tten */
> -                                         /* (cannot be in DACL, can in S=
ACL) */
> -#define MAXIMUM_ALLOWED       0x02000000  /* Maximal subset of GENERIC_A=
LL    */
> -                                         /* permissions which can be gra=
nted */
> -                                         /* (cannot be in DACL nor SACL)=
     */
> -#define GENERIC_ALL           0x10000000  /* Same as: GENERIC_EXECUTE | =
      */
> -                                         /*          GENERIC_WRITE |    =
     */
> -                                         /*          GENERIC_READ |     =
     */
> -                                         /*          FILE_DELETE_CHILD |=
     */
> -                                         /*          DELETE |           =
     */
> -                                         /*          WRITE_DAC |        =
     */
> -                                         /*          WRITE_OWNER        =
     */
> -                                         /* So GENERIC_ALL contains all =
bits */
> -                                         /* mentioned above except these=
 two */
> -                                         /* SYSTEM_SECURITY  MAXIMUM_ALL=
OWED */
> -#define GENERIC_EXECUTE       0x20000000  /* Same as: FILE_EXECUTE |    =
      */
> -                                         /*          FILE_READ_ATTRIBUTE=
S |  */
> -                                         /*          READ_CONTROL |     =
     */
> -                                         /*          SYNCHRONIZE        =
     */
> -#define GENERIC_WRITE         0x40000000  /* Same as: FILE_WRITE_DATA | =
      */
> -                                         /*          FILE_APPEND_DATA | =
     */
> -                                         /*          FILE_WRITE_EA |    =
     */
> -                                         /*          FILE_WRITE_ATTRIBUT=
ES | */
> -                                         /*          READ_CONTROL |     =
     */
> -                                         /*          SYNCHRONIZE        =
     */
> -#define GENERIC_READ          0x80000000  /* Same as: FILE_READ_DATA |  =
      */
> -                                         /*          FILE_READ_EA |     =
     */
> -                                         /*          FILE_READ_ATTRIBUTE=
S |  */
> -                                         /*          READ_CONTROL |     =
     */
> -                                         /*          SYNCHRONIZE        =
     */
> -
> -#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_READ_ATTR=
IBUTES)
> -#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> -                               | FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
> -#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> -
> -#define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_WRITE=
_EA \
> -                               | FILE_READ_ATTRIBUTES \
> -                               | FILE_WRITE_ATTRIBUTES \
> -                               | DELETE | READ_CONTROL | WRITE_DAC \
> -                               | WRITE_OWNER | SYNCHRONIZE)
> -#define SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> -                               | FILE_READ_EA | FILE_WRITE_EA \
> -                               | FILE_READ_ATTRIBUTES \
> -                               | FILE_WRITE_ATTRIBUTES \
> -                               | DELETE | READ_CONTROL | WRITE_DAC \
> -                               | WRITE_OWNER | SYNCHRONIZE)
> -#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUT=
E \
> -                               | FILE_READ_ATTRIBUTES \
> -                               | FILE_WRITE_ATTRIBUTES \
> -                               | DELETE | READ_CONTROL | WRITE_DAC \
> -                               | WRITE_OWNER | SYNCHRONIZE)
> -
> -#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
> -                               | READ_CONTROL | SYNCHRONIZE)
> -
>  /*
>   * Invalid readdir handle
>   */
> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> index f14d3d9aac22..9fe6fc4b05a7 100644
> --- a/fs/smb/common/smb1pdu.h
> +++ b/fs/smb/common/smb1pdu.h
> @@ -75,7 +75,128 @@
>  #define SMBFLG2_UNICODE cpu_to_le16(0x8000)
>
>  /*
> - * File Attribute flags
> + * These are the file access permission bits defined in CIFS for the
> + * NTCreateAndX as well as the level 0x107
> + * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107, SMB_QUERY_FILE_A=
LL_INFO
> + * responds with the AccessFlags.
> + * The AccessFlags specifies the access permissions a caller has to the
> + * file and can have any suitable combination of the following values:
> + */
> +
> +#define FILE_READ_DATA        0x00000001  /* Data can be read from the f=
ile   */
Please don't move them to smb1pdu.h.
These are common definitions that are also defined in the smb2 specificatio=
n.
> +                                         /* or directory child entries c=
an   */
> +                                         /* be listed together with the =
     */
> +                                         /* associated child attributes =
     */
> +                                         /* (so the FILE_READ_ATTRIBUTES=
 on  */
> +                                         /* the child entry is not neede=
d)   */
> +#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the =
file  */
> +                                         /* or new file can be created i=
n    */
> +                                         /* the directory               =
     */
> +#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the=
 file */
> +                                         /* (for non-local files over SM=
B it */
> +                                         /* is same as FILE_WRITE_DATA) =
     */
> +                                         /* or new subdirectory can be  =
     */
> +                                         /* created in the directory    =
     */
> +#define FILE_READ_EA          0x00000008  /* Extended attributes associa=
ted   */
> +                                         /* with the file can be read   =
     */
> +#define FILE_WRITE_EA         0x00000010  /* Extended attributes associa=
ted   */
> +                                         /* with the file can be written=
     */
> +#define FILE_EXECUTE          0x00000020  /*Data can be read into memory=
 from */
> +                                         /* the file using system paging=
 I/O */
> +                                         /* for executing the file / scr=
ipt  */
> +                                         /* or right to traverse directo=
ry   */
> +                                         /* (but by default all users ha=
ve   */
> +                                         /* directory bypass traverse   =
     */
> +                                         /* privilege and do not need th=
is   */
> +                                         /* permission on directories at=
 all)*/
> +#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted =
from  */
> +                                         /* the directory (so the DELETE=
 on  */
> +                                         /* the child entry is not neede=
d)   */
> +#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with =
the   */
> +                                         /* file or directory can be rea=
d    */
> +#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with =
the   */
> +                                         /* file or directory can be wri=
tten */
> +#define DELETE                0x00010000  /* The file or dir can be dele=
ted   */
> +#define READ_CONTROL          0x00020000  /* The discretionary access co=
ntrol */
> +                                         /* list and ownership associate=
d    */
> +                                         /* with the file or dir can be =
read */
> +#define WRITE_DAC             0x00040000  /* The discretionary access co=
ntrol */
> +                                         /* list associated with the fil=
e or */
> +                                         /* directory can be written    =
     */
> +#define WRITE_OWNER           0x00080000  /* Ownership information assoc=
iated */
> +                                         /* with the file/dir can be wri=
tten */
> +#define SYNCHRONIZE           0x00100000  /* The file handle can waited =
on to */
> +                                         /* synchronize with the complet=
ion  */
> +                                         /* of an input/output request  =
     */
> +#define SYSTEM_SECURITY       0x01000000  /* The system access control l=
ist   */
> +                                         /* associated with the file or =
     */
> +                                         /* directory can be read or wri=
tten */
> +                                         /* (cannot be in DACL, can in S=
ACL) */
> +#define MAXIMUM_ALLOWED       0x02000000  /* Maximal subset of GENERIC_A=
LL    */
> +                                         /* permissions which can be gra=
nted */
> +                                         /* (cannot be in DACL nor SACL)=
     */
> +#define GENERIC_ALL           0x10000000  /* Same as: GENERIC_EXECUTE | =
      */
> +                                         /*          GENERIC_WRITE |    =
     */
> +                                         /*          GENERIC_READ |     =
     */
> +                                         /*          FILE_DELETE_CHILD |=
     */
> +                                         /*          DELETE |           =
     */
> +                                         /*          WRITE_DAC |        =
     */
> +                                         /*          WRITE_OWNER        =
     */
> +                                         /* So GENERIC_ALL contains all =
bits */
> +                                         /* mentioned above except these=
 two */
> +                                         /* SYSTEM_SECURITY  MAXIMUM_ALL=
OWED */
> +#define GENERIC_EXECUTE       0x20000000  /* Same as: FILE_EXECUTE |    =
      */
> +                                         /*          FILE_READ_ATTRIBUTE=
S |  */
> +                                         /*          READ_CONTROL |     =
     */
> +                                         /*          SYNCHRONIZE        =
     */
> +#define GENERIC_WRITE         0x40000000  /* Same as: FILE_WRITE_DATA | =
      */
> +                                         /*          FILE_APPEND_DATA | =
     */
> +                                         /*          FILE_WRITE_EA |    =
     */
> +                                         /*          FILE_WRITE_ATTRIBUT=
ES | */
> +                                         /*          READ_CONTROL |     =
     */
> +                                         /*          SYNCHRONIZE        =
     */
> +#define GENERIC_READ          0x80000000  /* Same as: FILE_READ_DATA |  =
      */
> +                                         /*          FILE_READ_EA |     =
     */
> +                                         /*          FILE_READ_ATTRIBUTE=
S |  */
> +                                         /*          READ_CONTROL |     =
     */
> +                                         /*          SYNCHRONIZE        =
     */
> +
> +#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_READ_ATTR=
IBUTES)
> +#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> +                               | FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
> +#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> +
> +#define CLIENT_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FIL=
E_WRITE_EA \
> +                               | FILE_READ_ATTRIBUTES \
> +                               | FILE_WRITE_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define SERVER_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
> +                               | FILE_READ_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define CLIENT_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA=
 \
> +                               | FILE_READ_EA | FILE_WRITE_EA \
> +                               | FILE_READ_ATTRIBUTES \
> +                               | FILE_WRITE_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define SERVER_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA=
 \
> +                               | FILE_WRITE_EA \
> +                               | FILE_DELETE_CHILD \
> +                               | FILE_WRITE_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUT=
E \
> +                               | FILE_READ_ATTRIBUTES \
> +                               | FILE_WRITE_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
> +                               | READ_CONTROL | SYNCHRONIZE)
> +
> +/*
> + * File Attribute flags - see MS-SMB 2.2.1.4.1
>   */
>  #define ATTR_READONLY  0x0001
>  #define ATTR_HIDDEN    0x0002
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index f79a5165a7cc..f2fbd651ab8f 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1149,12 +1149,6 @@ struct smb2_server_client_notification {
>  #define FILE_OVERWRITE_IF_LE           cpu_to_le32(0x00000005)
>  #define FILE_CREATE_MASK_LE             cpu_to_le32(0x00000007)
>
> -#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
> -                       | FILE_READ_ATTRIBUTES)
> -#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> -                       | FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
> -#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> -
>  /* CreateOptions Flags */
>  #define FILE_DIRECTORY_FILE_LE         cpu_to_le32(0x00000001)
>  /* same as #define CREATE_NOT_FILE_LE  cpu_to_le32(0x00000001) */
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index 810fad0303d7..df67b370025d 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -38,61 +38,6 @@
>  #define F_CREATED      2
>  #define F_OVERWRITTEN  3
>
> -#define FILE_READ_DATA        0x00000001  /* Data can be read from the f=
ile   */
> -#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the =
file  */
> -#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the=
 file */
> -#define FILE_READ_EA          0x00000008  /* Extended attributes associa=
ted   */
> -/* with the file can be read        */
> -#define FILE_WRITE_EA         0x00000010  /* Extended attributes associa=
ted   */
> -/* with the file can be written     */
> -#define FILE_EXECUTE          0x00000020  /*Data can be read into memory=
 from */
> -/* the file using system paging I/O */
> -#define FILE_DELETE_CHILD     0x00000040
> -#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with =
the   */
> -/* file can be read                 */
> -#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with =
the   */
> -/* file can be written              */
> -#define DELETE                0x00010000  /* The file can be deleted    =
      */
> -#define READ_CONTROL          0x00020000  /* The access control list and=
      */
> -/* ownership associated with the    */
> -/* file can be read                 */
> -#define WRITE_DAC             0x00040000  /* The access control list and=
      */
> -/* ownership associated with the    */
> -/* file can be written.             */
> -#define WRITE_OWNER           0x00080000  /* Ownership information assoc=
iated */
> -/* with the file can be written     */
> -#define SYNCHRONIZE           0x00100000  /* The file handle can waited =
on to */
> -/* synchronize with the completion  */
> -/* of an input/output request       */
> -#define GENERIC_ALL           0x10000000
> -#define GENERIC_EXECUTE       0x20000000
> -#define GENERIC_WRITE         0x40000000
> -#define GENERIC_READ          0x80000000
> -/* In summary - Relevant file       */
> -/* access flags from CIFS are       */
> -/* file_read_data, file_write_data  */
> -/* file_execute, file_read_attributes*/
> -/* write_dac, and delete.           */
> -
> -#define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
> -               | FILE_READ_ATTRIBUTES \
> -               | DELETE | READ_CONTROL | WRITE_DAC \
> -               | WRITE_OWNER | SYNCHRONIZE)
> -#define SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> -               | FILE_WRITE_EA \
> -               | FILE_DELETE_CHILD \
> -               | FILE_WRITE_ATTRIBUTES \
> -               | DELETE | READ_CONTROL | WRITE_DAC \
> -               | WRITE_OWNER | SYNCHRONIZE)
> -#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUT=
E \
> -               | FILE_READ_ATTRIBUTES \
> -               | FILE_WRITE_ATTRIBUTES \
> -               | DELETE | READ_CONTROL | WRITE_DAC \
> -               | WRITE_OWNER | SYNCHRONIZE)
> -
> -#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
> -               | READ_CONTROL | SYNCHRONIZE)
> -
>  /* generic flags for file open */
>  #define GENERIC_READ_FLAGS     (READ_CONTROL | FILE_READ_DATA | \
>                 FILE_READ_ATTRIBUTES | \
> diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
> index 5aa7a66334d9..b70ba50f1f10 100644
> --- a/fs/smb/server/smbacl.c
> +++ b/fs/smb/server/smbacl.c
> @@ -180,7 +180,7 @@ static void mode_to_access_flags(umode_t mode, umode_=
t bits_to_use,
>          * either user or group or other as per bits_to_use
>          */
>         if (mode & 0444)
> -               *pace_flags |=3D SET_FILE_READ_RIGHTS;
> +               *pace_flags |=3D SERVER_SET_FILE_READ_RIGHTS;
>         if (mode & 0222)
>                 *pace_flags |=3D FILE_WRITE_RIGHTS;
>         if (mode & 0111)
> --
> 2.43.0
>
