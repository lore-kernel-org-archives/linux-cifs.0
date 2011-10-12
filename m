From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 12/16] cifs: eliminate is_multi_rsp parm to find_cifs_mid
Date: Wed, 12 Oct 2011 12:43:04 +0400
Message-ID: <CAKywueS13LXqw2NgbCqd0hyh7qVwzqL7MZwF8Z5X3HdWmJOrBA@mail.gmail.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
	<1314616624-5362-13-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314616624-5362-13-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Change find_cifs_mid to only return NULL if a mid could not be found.
> If we got part of a multi-part T2 response, then coalesce it and stil=
l
> return the mid. The caller can determine the T2 receive status from
> the flags in the mid.
>
> With this change, there is no need to pass a pointer to "length" as
> well so just pass by value. If a mid is found, then we can just mark
> it as malformed. If one isn't found, then the value of "length" won't
> change anyway.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 35 ++++++++++++++++-------------------
> =A01 files changed, 16 insertions(+), 19 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6b4fcb3..9518457 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -576,8 +576,7 @@ dequeue_mid(struct mid_q_entry *mid, int malforme=
d)
>
> =A0static struct mid_q_entry *
> =A0find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 int *malformed, bool is_large_buf, bool *is=
_multi_rsp,
> - =A0 =A0 =A0 =A0 =A0 =A0 char **bigbuf)
> + =A0 =A0 =A0 =A0 =A0 =A0 int malformed, bool is_large_buf, char **bi=
gbuf)
> =A0{
> =A0 =A0 =A0 =A0struct mid_q_entry *mid =3D NULL;
>
> @@ -585,16 +584,14 @@ find_cifs_mid(struct TCP_Server_Info *server, s=
truct smb_hdr *buf,
> =A0 =A0 =A0 =A0if (!mid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return mid;
>
> - =A0 =A0 =A0 if (*malformed =3D=3D 0 && check2ndT2(buf) > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We have a multipart transact2 resp *=
/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *is_multi_rsp =3D true;
> + =A0 =A0 =A0 if (malformed =3D=3D 0 && check2ndT2(buf) > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->multiRsp =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid->resp_buf) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* merge response - fi=
x up 1st*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *malformed =3D coalesce=
_t2(buf, mid->resp_buf);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*malformed > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *malfor=
med =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mu=
ltiRsp =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 malformed =3D coalesce_=
t2(buf, mid->resp_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (malformed > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 malform=
ed =3D 0;
                                    ^^^^
this is unnecessary because we return from the function as the next ste=
p.


> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
mid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* All parts received =
or packet is malformed. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid->multiEnd =3D true=
;
> @@ -614,7 +611,7 @@ find_cifs_mid(struct TCP_Server_Info *server, str=
uct smb_hdr *buf,
> =A0 =A0 =A0 =A0mid->resp_buf =3D buf;
> =A0 =A0 =A0 =A0mid->largeBuf =3D is_large_buf;
> =A0multi_t2_fnd:
> - =A0 =A0 =A0 dequeue_mid(mid, *malformed);
> + =A0 =A0 =A0 dequeue_mid(mid, malformed);
> =A0 =A0 =A0 =A0return mid;
> =A0}
>
> @@ -725,7 +722,6 @@ cifs_demultiplex_thread(void *p)
> =A0 =A0 =A0 =A0struct task_struct *task_to_wake =3D NULL;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid_entry;
> =A0 =A0 =A0 =A0bool isLargeBuf =3D false;
> - =A0 =A0 =A0 bool isMultiRsp =3D false;
>
> =A0 =A0 =A0 =A0current->flags |=3D PF_MEMALLOC;
> =A0 =A0 =A0 =A0cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
> @@ -745,7 +741,6 @@ cifs_demultiplex_thread(void *p)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0isLargeBuf =3D false;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 isMultiRsp =3D false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_buffer =3D (struct smb_hdr *)small=
buf;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buf =3D smallbuf;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_length =3D 4; /* enough to get RFC=
1001 header */
> @@ -823,23 +818,25 @@ cifs_demultiplex_thread(void *p)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->lstrp =3D jiffies;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D find_cifs_mid(server, smb=
_buffer, &length,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 isLargeBuf, &isMultiRsp, &bigbuf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D find_cifs_mid(server, smb=
_buffer, length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 isLargeBuf, &bigbuf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry !=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback(mid=
_entry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->multiRsp=
 && !mid_entry->multiEnd)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Was previous buf pu=
t in mpx struct for multi-rsp? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!isMultiRsp) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!mid_entry->multiRs=
p) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* smb=
 buffer will be freed by user thread */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (is=
LargeBuf)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0bigbuf =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0smallbuf =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback(mid=
_entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (length !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* response sanity che=
cks failed */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!is_valid_oplock_break(smb_b=
uffer, server) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!isMultiRsp) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!is_valid_oplock_break(smb_b=
uffer, server)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "No task to =
wake, unknown frame received! "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
NumMids %d", atomic_read(&midCount));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_dump_mem("Receive=
d Data is: ", buf,
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
