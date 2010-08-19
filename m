From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: correction of unicode header files
Date: Thu, 19 Aug 2010 15:58:07 -0500
Message-ID: <AANLkTima+akBPRM_W9+xgPHre6utGciS9TgBSgHPNUWh@mail.gmail.com>
References: <1282249633-27756-1-git-send-email-jaxbrigs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282249633-27756-1-git-send-email-jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Igor, quick question, what is 512, could it be any other number?

On Thu, Aug 19, 2010 at 3:27 PM, Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> This patch corrects a problem of compilation errors at removal of
> UNIUPR_NOLOWER definition and adds include guards to cifs_unicode.h.
>
> Signed-off-by: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifs_unicode.h | =A0 18 +++++++++++-------
> =A0fs/cifs/cifs_uniupr.h =A0| =A0 16 ++++++++--------
> =A02 files changed, 19 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> index 6506382..7fe6b52 100644
> --- a/fs/cifs/cifs_unicode.h
> +++ b/fs/cifs/cifs_unicode.h
> @@ -30,6 +30,8 @@
> =A0* =A0 =A0 This is a compressed table of upper and lower case conve=
rsion.
> =A0*
> =A0*/
> +#ifndef _CIFS_UNICODE_H
> +#define _CIFS_UNICODE_H
>
> =A0#include <asm/byteorder.h>
> =A0#include <linux/types.h>
> @@ -67,8 +69,8 @@ extern const struct UniCaseRange CifsUniUpperRange[=
];
> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* UNIUPR_N=
OUPPER */
>
> =A0#ifndef UNIUPR_NOLOWER
> -extern signed char UniLowerTable[512];
> -extern struct UniCaseRange UniLowerRange[];
> +extern signed char CifsUniLowerTable[512];
> +extern const struct UniCaseRange CifsUniLowerRange[];
> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* UNIUPR_N=
OLOWER */
>
> =A0#ifdef __KERNEL__
> @@ -337,15 +339,15 @@ UniStrupr(register wchar_t *upin)
> =A0* UniTolower: =A0Convert a unicode character to lower case
> =A0*/
> =A0static inline wchar_t
> -UniTolower(wchar_t uc)
> +UniTolower(register wchar_t uc)
> =A0{
> - =A0 =A0 =A0 register struct UniCaseRange *rp;
> + =A0 =A0 =A0 register const struct UniCaseRange *rp;
>
> - =A0 =A0 =A0 if (uc < sizeof(UniLowerTable)) {
> + =A0 =A0 =A0 if (uc < sizeof(CifsUniLowerTable)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Latin characters */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return uc + UniLowerTable[uc]; =A0/* Us=
e base tables */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return uc + CifsUniLowerTable[uc]; =A0 =
=A0 =A0/* Use base tables */
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rp =3D UniLowerRange; =A0 =A0 /* Use ra=
nge tables */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rp =3D CifsUniLowerRange; /* Use range =
tables */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while (rp->start) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (uc < rp->start) =A0=
 =A0 /* Before start of range */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 uc; =A0 =A0 =A0/* Uppercase =3D input */
> @@ -374,3 +376,5 @@ UniStrlwr(register wchar_t *upin)
> =A0}
>
> =A0#endif
> +
> +#endif /* _CIFS_UNICODE_H */
> diff --git a/fs/cifs/cifs_uniupr.h b/fs/cifs/cifs_uniupr.h
> index 18a9d97..0ac7c5a 100644
> --- a/fs/cifs/cifs_uniupr.h
> +++ b/fs/cifs/cifs_uniupr.h
> @@ -140,7 +140,7 @@ const struct UniCaseRange CifsUniUpperRange[] =3D=
 {
> =A0/*
> =A0* Latin lower case
> =A0*/
> -static signed char CifsUniLowerTable[512] =3D {
> +signed char CifsUniLowerTable[512] =3D {
> =A0 =A0 =A0 =A00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /* 000=
-00f */
> =A0 =A0 =A0 =A00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /* 010=
-01f */
> =A0 =A0 =A0 =A00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /* 020=
-02f */
> @@ -242,12 +242,12 @@ static signed char UniCaseRangeLff20[27] =3D {
> =A0/*
> =A0* Lower Case Range
> =A0*/
> -static const struct UniCaseRange CifsUniLowerRange[] =3D {
> - =A0 =A0 =A0 0x0380, 0x03ab, UniCaseRangeL0380,
> - =A0 =A0 =A0 0x0400, 0x042f, UniCaseRangeL0400,
> - =A0 =A0 =A0 0x0490, 0x04cb, UniCaseRangeL0490,
> - =A0 =A0 =A0 0x1e00, 0x1ff7, UniCaseRangeL1e00,
> - =A0 =A0 =A0 0xff20, 0xff3a, UniCaseRangeLff20,
> - =A0 =A0 =A0 0, 0, 0
> +const struct UniCaseRange CifsUniLowerRange[] =3D {
> + =A0 =A0 =A0 {0x0380, 0x03ab, UniCaseRangeL0380},
> + =A0 =A0 =A0 {0x0400, 0x042f, UniCaseRangeL0400},
> + =A0 =A0 =A0 {0x0490, 0x04cb, UniCaseRangeL0490},
> + =A0 =A0 =A0 {0x1e00, 0x1ff7, UniCaseRangeL1e00},
> + =A0 =A0 =A0 {0xff20, 0xff3a, UniCaseRangeLff20},
> + =A0 =A0 =A0 {0}
> =A0};
> =A0#endif
> --
> 1.7.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
