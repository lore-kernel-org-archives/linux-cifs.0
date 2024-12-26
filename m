Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BEC1FAA;
	Thu, 26 Dec 2024 00:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735172562; cv=none; b=lpdMajkUYHNj5MaBAzwmqydhPn1xCMx05/0ncGFe5W8TmzAHNb/hyQiHJujflZK6o70ejJ9ojOMtocwNk9xx9QZ1nq6Fp9HWpkMM5r7awGhqEDQh+b5APBKArQoIJKVGQUJRuWEOblGwk33JgM1gQ7cnuIMk9vikdPOsNFC0pv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735172562; c=relaxed/simple;
	bh=8C6bhKgvSDrLCo0f5xI2WhUPH4PZ/Ia2r+YYfvLbbhc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CShe7zf2ZLiABo8Du1JWZNAIEkmjWtx/ODsIvInInPDsV5YCz+5yAObJy27Niyd76SUUH549TLSgB7XwJbn5NZ5SkDU9PUUQo2JZleWPF2jqhvS7R6VUGdMWvxJFYRX5dYWs6jEtSwJTGmPd6KrWKHiF8wwS0AHdHz9F+cpuOco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrSuNBdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrSuNBdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5ECC4CECD;
	Thu, 26 Dec 2024 00:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735172562;
	bh=8C6bhKgvSDrLCo0f5xI2WhUPH4PZ/Ia2r+YYfvLbbhc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DrSuNBdDqDMGcHc/9RVCNFk3hbjGpInTHr8b+Bb34JOkH04y5iweXaMjacV/XeBfZ
	 XswGPl57ygMeF2e75vC5KBRk5WrLcNj1LMRkcgAxWGU4JxyL0M9haIETxW878HdlDc
	 B9PEssUD1sVhykMsACLGmKXLSxXPPMZekOL9LZ7zU4wEIEadhljQl0xa4fYoC6Mj02
	 m/90rmx1aFXvrverfJ9ibrKt7ndmdNFvi6yGjGgFoThqrmHETHnp7rdTYXWixJezha
	 ifsfEMRWITFkYnKU0OVa4XBfMqC4CaLEvf4fXemQpkxiIn4Us4siliPH9Y4bmiUUqB
	 xmBwJCNm/6Cxw==
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-71e3cbd0583so1329533a34.1;
        Wed, 25 Dec 2024 16:22:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUSp9gqDnZrpka0UmYDzStZ30hOHCVtExVZFbO7gE27UaySGLZgXIF14pFCXXhFK6pfnNRiG2H2/r51@vger.kernel.org, AJvYcCUetVOZioQVheyrdfAyFY4mG6K6YI9aRBLRe4/5FdpNvZwKM4M6BwkC3axIt5Dg2grL6OqFJglouMCAikHF@vger.kernel.org
X-Gm-Message-State: AOJu0YwtQ/t5lAR3eEDMJekhW7yVjI/XCuzPN2zODWtDwL5aGR/wBSC/
	aHdIAOkidQqQrDwZ7MgXNvNsHfctuaKPUIvVq32z7qAA6uwWb1Nx5ltWdyBwvzPsY6KHN4orvWv
	PqDONOnheejP0neyWQRxViyGuJns=
X-Google-Smtp-Source: AGHT+IH0/oiRnGn8rBEjpaaztO/jeQB5M+mPBwBf9l5S5h6mVzkVZiTetUkzwJAdGfZHynpWzdRPvIoAA3B2lbsMFNA=
X-Received: by 2002:a05:6808:168c:b0:3e5:f4fa:5984 with SMTP id
 5614622812f47-3ed890b182amr9086373b6e.38.1735172561532; Wed, 25 Dec 2024
 16:22:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241224150829.3926-1-pali@kernel.org>
In-Reply-To: <20241224150829.3926-1-pali@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 26 Dec 2024 09:22:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Wy0_skGEhrWNT1u7w4VTbmk_FUH_PN2oN6G-npM3Ntg@mail.gmail.com>
Message-ID: <CAKYAXd_Wy0_skGEhrWNT1u7w4VTbmk_FUH_PN2oN6G-npM3Ntg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Update description about ACL permissions
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 25, 2024 at 12:08=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> There are some incorrect information about individual SMB permission
> constants like WRITE_DAC can change ownership, or incomplete information =
to
> distinguish between ACL types (discretionary vs system) and there is
> completely missing information how permissions apply for directory object=
s
> and what is meaning of GENERIC_* bits.
>
> Fix and extend description of all SMB permission constants to match the
> reality, how the reference Windows SMB / NTFS implementation handles them=
.
>
> Links to official Microsoft documentation related to permissions:
> https://learn.microsoft.com/en-us/windows/win32/fileio/file-access-rights=
-constants
> https://learn.microsoft.com/en-us/windows/win32/secauthz/access-mask
> https://learn.microsoft.com/en-us/windows/win32/secauthz/standard-access-=
rights
> https://learn.microsoft.com/en-us/windows/win32/secauthz/generic-access-r=
ights
> https://learn.microsoft.com/en-us/windows/win32/api/winternl/nf-winternl-=
ntcreatefile
> https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/nf-n=
tifs-ntcreatefile
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>
> Anyway, I see that these client constants are copied also in server
> fs/smb/server/smb_common.h file. Maybe they could be deduplicated into
> some fs/smb/common/* file?
Yes, We can move them to fs/smb/common/* file.

Thanks.
>
> ---
>  fs/smb/client/cifspdu.h | 77 ++++++++++++++++++++++++++++++++---------
>  1 file changed, 60 insertions(+), 17 deletions(-)
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index f4c348b5c4f1..3ad1bb79ea9e 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -190,38 +190,81 @@
>   */
>
>  #define FILE_READ_DATA        0x00000001  /* Data can be read from the f=
ile   */
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
>  #define FILE_WRITE_DATA       0x00000002  /* Data can be written to the =
file  */
> +                                         /* or new file can be created i=
n    */
> +                                         /* the directory               =
     */
>  #define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the=
 file */
> +                                         /* (for non-local files over SM=
B it */
> +                                         /* is same as FILE_WRITE_DATA) =
     */
> +                                         /* or new subdirectory can be  =
     */
> +                                         /* created in the directory    =
     */
>  #define FILE_READ_EA          0x00000008  /* Extended attributes associa=
ted   */
>                                           /* with the file can be read   =
     */
>  #define FILE_WRITE_EA         0x00000010  /* Extended attributes associa=
ted   */
>                                           /* with the file can be written=
     */
>  #define FILE_EXECUTE          0x00000020  /*Data can be read into memory=
 from */
>                                           /* the file using system paging=
 I/O */
> -#define FILE_DELETE_CHILD     0x00000040
> +                                         /* for executing the file / scr=
ipt  */
> +                                         /* or right to traverse directo=
ry   */
> +                                         /* (but by default all users ha=
ve   */
> +                                         /* bypass traverse privilege an=
d do */
> +                                         /* not need this permission at =
all) */
> +#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted =
from  */
> +                                         /* the directory (so the DELETE=
 on  */
> +                                         /* the child entry is not neede=
d)   */
>  #define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with =
the   */
> -                                         /* file can be read            =
     */
> +                                         /* file or directory can be rea=
d    */
>  #define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with =
the   */
> -                                         /* file can be written         =
     */
> -#define DELETE                0x00010000  /* The file can be deleted    =
      */
> -#define READ_CONTROL          0x00020000  /* The access control list and=
      */
> -                                         /* ownership associated with th=
e    */
> -                                         /* file can be read            =
     */
> -#define WRITE_DAC             0x00040000  /* The access control list and=
      */
> -                                         /* ownership associated with th=
e    */
> -                                         /* file can be written.        =
     */
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
>  #define WRITE_OWNER           0x00080000  /* Ownership information assoc=
iated */
> -                                         /* with the file can be written=
     */
> +                                         /* with the file/dir can be wri=
tten */
>  #define SYNCHRONIZE           0x00100000  /* The file handle can waited =
on to */
>                                           /* synchronize with the complet=
ion  */
>                                           /* of an input/output request  =
     */
>  #define SYSTEM_SECURITY       0x01000000  /* The system access control l=
ist   */
> -                                         /* can be read and changed     =
     */
> -#define MAXIMUM_ALLOWED       0x02000000
> -#define GENERIC_ALL           0x10000000
> -#define GENERIC_EXECUTE       0x20000000
> -#define GENERIC_WRITE         0x40000000
> -#define GENERIC_READ          0x80000000
> +                                         /* list associated with the fil=
e or */
> +                                         /* dir can be read or written  =
     */
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
>                                          /* In summary - Relevant file   =
    */
>                                          /* access flags from CIFS are   =
    */
>                                          /* file_read_data, file_write_da=
ta  */
> --
> 2.20.1
>
