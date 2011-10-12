From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 12/16] cifs: eliminate is_multi_rsp parm to find_cifs_mid
Date: Wed, 12 Oct 2011 15:34:19 +0400
Message-ID: <CAKywueShQc2CimaQzivebne_a+L8aVHVsUbLotRn+xEKFU=fUQ@mail.gmail.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
	<1314616624-5362-13-git-send-email-jlayton@redhat.com>
	<CAKywueS13LXqw2NgbCqd0hyh7qVwzqL7MZwF8Z5X3HdWmJOrBA@mail.gmail.com>
	<20111012072805.0f21a5a5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111012072805.0f21a5a5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/12 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 12 Oct 2011 12:43:04 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2011/8/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > Change find_cifs_mid to only return NULL if a mid could not be fou=
nd.
>> > If we got part of a multi-part T2 response, then coalesce it and s=
till
>> > return the mid. The caller can determine the T2 receive status fro=
m
>> > the flags in the mid.
>> >
>> > With this change, there is no need to pass a pointer to "length" a=
s
>> > well so just pass by value. If a mid is found, then we can just ma=
rk
>> > it as malformed. If one isn't found, then the value of "length" wo=
n't
>> > change anyway.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/connect.c | =A0 35 ++++++++++++++++-------------------
>> > =A01 files changed, 16 insertions(+), 19 deletions(-)
>> >
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index 6b4fcb3..9518457 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -576,8 +576,7 @@ dequeue_mid(struct mid_q_entry *mid, int malfo=
rmed)
>> >
>> > =A0static struct mid_q_entry *
>> > =A0find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *b=
uf,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 int *malformed, bool is_large_buf, bool =
*is_multi_rsp,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 char **bigbuf)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 int malformed, bool is_large_buf, char *=
*bigbuf)
>> > =A0{
>> > =A0 =A0 =A0 =A0struct mid_q_entry *mid =3D NULL;
>> >
>> > @@ -585,16 +584,14 @@ find_cifs_mid(struct TCP_Server_Info *server=
, struct smb_hdr *buf,
>> > =A0 =A0 =A0 =A0if (!mid)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return mid;
>> >
>> > - =A0 =A0 =A0 if (*malformed =3D=3D 0 && check2ndT2(buf) > 0) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We have a multipart transact2 res=
p */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *is_multi_rsp =3D true;
>> > + =A0 =A0 =A0 if (malformed =3D=3D 0 && check2ndT2(buf) > 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->multiRsp =3D true;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid->resp_buf) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* merge response -=
 fix up 1st*/
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *malformed =3D coale=
sce_t2(buf, mid->resp_buf);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*malformed > 0) =
{
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *mal=
formed =3D 0;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid-=
>multiRsp =3D true;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retu=
rn NULL;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 malformed =3D coales=
ce_t2(buf, mid->resp_buf);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (malformed > 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 malf=
ormed =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 ^^^^
>> this is unnecessary because we return from the function as the next =
step.
>>
>
> <forehead slap>
>
> Correct. It's a harmless thing though. Mind if I fix this in a
> follow-on patch to the whole series? I hate to have to respin it for
> this...
>

The follow-on patch is ok for me.

--=20
Best regards,
Pavel Shilovsky.
