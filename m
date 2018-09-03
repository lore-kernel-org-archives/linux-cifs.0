From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] fs/cifs: suppress a string overflow warning
Date: Mon, 3 Sep 2018 09:44:17 -0500
Message-ID: <CAH2r5mu99E39iwx=70w6F5MxvNh1MrzbVwTRb2e8dmz9WU52sw@mail.gmail.com>
References: <20180903131558.21cdeb35@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903131558.21cdeb35@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Merged into cifs-2.6.git for-next

Is the message annoying enough on powerpc to merit going into
4.19-rc3, presumably should wait for 4.20?
On Sun, Sep 2, 2018 at 10:24 PM Stephen Rothwell <sfr@canb.auug.org.au> wro=
te:
>
> A powerpc build of cifs with gcc v8.2.0 produces this warning:
>
> fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBNegotiate=E2=80=99:
> fs/cifs/cifssmb.c:605:3: warning: =E2=80=98strncpy=E2=80=99 writing 16 by=
tes into a region of size 1 overflows the destination [-Wstringop-overflow=
=3D]
>    strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Since we are already doing a strlen() on the source, change the strncpy
> to a memcpy().
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/cifs/cifssmb.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index dc2f4cf08fe9..dcf939cb9d2f 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -601,10 +601,14 @@ CIFSSMBNegotiate(const unsigned int xid, struct cif=
s_ses *ses)
>         }
>
>         count =3D 0;
> +       /*
> +        * We know that all the name entries in the protocols array
> +        * are short (< 16 bytes anyway) and are NUL terminated.
> +        */
>         for (i =3D 0; i < CIFS_NUM_PROT; i++) {
> -               strncpy(pSMB->DialectsArray+count, protocols[i].name, 16)=
;
> -               count +=3D strlen(protocols[i].name) + 1;
> -               /* null at end of source and target buffers anyway */
> +               size_t len =3D strlen(protocols[i].name) + 1;
> +               memcpy(pSMB->DialectsArray+count, protocols[i].name, len)=
;
> +               count +=3D len;
>         }
>         inc_rfc1001_len(pSMB, count);
>         pSMB->ByteCount =3D cpu_to_le16(count);
> --
> 2.19.0.rc1
>
> --
> Cheers,
> Stephen Rothwell



--=20
Thanks,

Steve
