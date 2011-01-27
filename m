From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: don't always drop malformed replies on the
 floor (try #2)
Date: Thu, 27 Jan 2011 11:26:32 -0600
Message-ID: <AANLkTi=SjhAP00f3ph-eVxinOr3B=ay49v5fpbNEy4k2@mail.gmail.com>
References: <1296146511-25942-1-git-send-email-jlayton@redhat.com>
	<1296146511-25942-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296146511-25942-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jan 27, 2011 at 10:41 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> After receiving a packet, we currently check the header. If it's no
> good, then we toss it out and continue the loop, leaving the caller
> waiting on that response. This is problematic now that the client wai=
ts
> indefinitely for responses.
>
> Check first to see if the packet is big enough for us to read the Mid=
=2E
> If it's not, then discard it since we can't do anything with it anywa=
y.
>
> If it is big enough, then go ahead and do the checkSMB checks. Don't
> immediately discard the packet however if they fail. Instead, find th=
e
> matching mid_q_entry, mark it as having a malformed response and issu=
e
> the callback.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h =A0| =A0 =A02 +-
> =A0fs/cifs/connect.c =A0 | =A0 27 ++++++++++++++++++++++-----
> =A0fs/cifs/transport.c | =A0 =A03 +++
> =A03 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 921b884..8034da1 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -652,7 +652,7 @@ static inline void free_dfs_info_array(struct dfs=
_info3_param *param,
> =A0#define =A0 MID_REQUEST_SUBMITTED 2
> =A0#define =A0 MID_RESPONSE_RECEIVED 4
> =A0#define =A0 MID_RETRY_NEEDED =A0 =A0 =A08 /* session closed while =
this request out */
> -#define =A0 MID_NO_RESP_NEEDED 0x10
> +#define =A0 MID_RESPONSE_MALFORMED 0x10
>
> =A0/* Types of response buffer returned from SendReceive2 */
> =A0#define =A0 CIFS_NO_BUFFER =A0 =A0 =A0 =A00 =A0 =A0/* Response buf=
fer not returned */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 41a0ba0..79c8195 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -584,11 +584,19 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0total_read +=3D 4; /* account for rfc1=
002 hdr */
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dump_smb(smb_buffer, total_read);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (checkSMB(smb_buffer, smb_buffer->Mi=
d, total_read)) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We know that we received enough to=
 get to the MID as we
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* checked the pdu_length earlier. No=
w check to see
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if the rest of the header is OK. W=
e borrow the length
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* var for the rest of the loop to av=
oid a new stack var.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* FIXME: why 48 bytes?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D checkSMB(smb_buffer, smb_buf=
fer->Mid, total_read);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_dump_mem("Bad SMB=
: ", smb_buffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0total_read < 48 ? total_read : 48);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->lstrp =3D jiffies;
> @@ -600,7 +608,8 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((mid_entry->mid =3D=
=3D smb_buffer->Mid) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(mid_entry->mi=
dState =3D=3D MID_REQUEST_SUBMITTED) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(mid_entry->co=
mmand =3D=3D smb_buffer->Command)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (che=
ck2ndT2(smb_buffer,server->maxBuf) > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len=
gth =3D=3D 0 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 check2ndT2(smb_buffer,server->maxBuf) > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0/* We have a multipart transact2 resp */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0isMultiRsp =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0if (mid_entry->resp_buf) {
> @@ -635,7 +644,12 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->resp_buf =3D smb_buffer;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->largeBuf =3D isLargeBuf;
> =A0multi_t2_fnd:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_ent=
ry->midState =3D MID_RESPONSE_RECEIVED;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len=
gth =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_entry->midState =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MID_RESPONSE_RECEIVED;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_entry->midState =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MID_RESPONSE_MALFORMED;

Should the decision to assign a value to midState be based on length
as well return value of function check2ndT2() or basing it on just the
value of the length is sufficient?

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_d=
el_init(&mid_entry->qhead);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->callback(mid_entry);
> =A0#ifdef CONFIG_CIFS_STATS2
> @@ -656,6 +670,9 @@ multi_t2_fnd:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0smallbuf =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (length !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* response sanity chec=
ks failed */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (!is_valid_oplock_break(smb_=
buffer, server) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !isMultiRsp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "No task to =
wake, unknown frame received! "
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 748b3b8..14312e0 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -453,6 +453,9 @@ sync_mid_result(struct mid_q_entry *mid, struct T=
CP_Server_Info *server)
> =A0 =A0 =A0 =A0case MID_RETRY_NEEDED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EAGAIN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 case MID_RESPONSE_MALFORMED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "%s: invalid mid state mid=3D=
%d state=3D%d", __func__,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid->mid, mid->midStat=
e);
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
