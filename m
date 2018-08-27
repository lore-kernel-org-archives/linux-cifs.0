From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] fs/cifs: don't translate SFM_SLASH (U+F026) to backslash
Date: Sun, 26 Aug 2018 20:40:56 -0500
Message-ID: <CAH2r5muQXJFzut4upVAk-nTFv3qGGOaG+QKLkGgqGA1HitUMGg@mail.gmail.com>
References: <20180709143314.4378-1-jkuhn@barracuda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: jkuhn@barracuda.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709143314.4378-1-jkuhn@barracuda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Tentatively merged into cifs-2.6.git for-next but would like a little
more experimentation with it if possible (or description of what
scenarios/servers have been tried)
On Mon, Jul 9, 2018 at 9:53 AM Jon Kuhn <jkuhn@barracuda.com> wrote:
>
> When a Mac client saves an item containing a backslash to a file server
> the backslash is represented in the CIFS/SMB protocol as as U+F026.
> Before this change, listing a directory containing an item with a
> backslash in its name will return that item with the backslash
> represented with a true backslash character (U+005C) because
> convert_sfm_character mapped U+F026 to U+005C when interpretting the
> CIFS/SMB protocol response.  However, attempting to open or stat the
> path using a true backslash will result in an error because
> convert_to_sfm_char does not map U+005C back to U+F026 causing the
> CIFS/SMB request to be made with the backslash represented as U+005C.
>
> This change simply prevents the U+F026 to U+005C conversion from
> happenning.  This is analogous to how the code does not do any
> translation of UNI_SLASH (U+F000).
>
> Signed-off-by: Jon Kuhn <jkuhn@barracuda.com>
> ---
>  fs/cifs/cifs_unicode.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index b380e087..a2b2355e 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -105,9 +105,6 @@ convert_sfm_char(const __u16 src_char, char *target)
>         case SFM_LESSTHAN:
>                 *target =3D '<';
>                 break;
> -       case SFM_SLASH:
> -               *target =3D '\\';
> -               break;
>         case SFM_SPACE:
>                 *target =3D ' ';
>                 break;
> --
> 2.17.1
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Learn how to protect users, data, and applications with security engineer=
ed for the public cloud by Barracuda. http://barracuda.com
>
> DISCLAIMER:
> This e-mail and any attachments to it contain confidential and proprietar=
y material of Barracuda, its affiliates or agents, and is solely for the us=
e of the intended recipient. Any review, use, disclosure, distribution or c=
opying of this transmittal is prohibited except by or on behalf of the inte=
nded recipient. If you have received this transmittal in error, please noti=
fy the sender and destroy this e-mail and any attachments and all copies, w=
hether electronic or printed.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
