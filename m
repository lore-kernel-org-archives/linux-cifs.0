From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Subject: Re: [PATCH] cifs: remove misleading strncpy: each name has length < 16
Date: Mon, 20 Aug 2012 19:36:26 +0200
Message-ID: <CAE2SPAbBmRov9qK2HiBQBQXaZpfJ8pmZJ-PL18FEyoZhzDza4A@mail.gmail.com>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-6-git-send-email-jim@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Jim Meyering <meyering@redhat.com>, linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1345481724-30108-6-git-send-email-jim@meyering.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Le 20 ao=C3=BBt 2012 19:29, "Jim Meyering" <jim@meyering.net> a =C3=A9crit =
:
>
> From: Jim Meyering <meyering@redhat.com>
>
> Each of the protocols[i].name strings (statically declared above)
> has length less than 16, so this use of strncpy is misleading:
>   strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
> Besides, if a new name were added with length N >=3D 16, the existing
> strncpy-using code would be buggy, creating a ->DialectsArray buffer
> containing N-16+1 unset bytes where the NUL terminator should have
> been.  Instead, traverse the name only once go get its length,
> use a BUG_ON assertion to enforce the length restriction
> and use memcpy to perform the copy.
>

Could you use ARRAY_SIZE instead of hard coding 16?
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  fs/cifs/cifssmb.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 074923c..16a9018 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -441,8 +441,10 @@ CIFSSMBNegotiate(const unsigned int xid, struct
cifs_ses *ses)
>
>         count =3D 0;
>         for (i =3D 0; i < CIFS_NUM_PROT; i++) {
> -               strncpy(pSMB->DialectsArray+count, protocols[i].name, 16)=
;
> -               count +=3D strlen(protocols[i].name) + 1;
> +               size_t len =3D strlen(protocols[i].name);
> +               BUG_ON(len >=3D 16);
> +               memcpy(pSMB->DialectsArray+count, protocols[i].name, len
+ 1);
> +               count +=3D len + 1;
>                 /* null at end of source and target buffers anyway */
>         }
>         inc_rfc1001_len(pSMB, count);
> --
> 1.7.12
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
