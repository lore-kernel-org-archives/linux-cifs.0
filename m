From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: Move protocol specific demultiplex thread calls
 to ops struct
Date: Sat, 19 May 2012 10:51:47 +0400
Message-ID: <CAKywueSz7YKc+DSrR6EnfrMCyx1wnh-b1O_eoaui1Xs68ocQ2w@mail.gmail.com>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-5-git-send-email-piastry@etersoft.ru>
	<20120518125153.03c3ab34@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120518125153.03c3ab34-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 17 May 2012 19:43:43 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h | =A0 =A06 ++++++
>> =A0fs/cifs/connect.c =A0| =A0 27 ++++-----------------------
>> =A0fs/cifs/smb1ops.c =A0| =A0 26 ++++++++++++++++++++++++++
>> =A03 files changed, 36 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 080dd86..7b3e8fe 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -170,6 +170,12 @@ struct smb_version_operations {
>> =A0 =A0 =A0 unsigned int (*read_data_offset)(char *);
>> =A0 =A0 =A0 unsigned int (*read_data_length)(char *);
>> =A0 =A0 =A0 int (*map_error)(char *, bool);
>> + =A0 =A0 struct mid_q_entry * (*find_mid)(struct TCP_Server_Info *,=
 char *);
>> +#ifdef CONFIG_CIFS_DEBUG2
>> + =A0 =A0 void (*dump_detail)(void *);
>> +#endif
>> + =A0 =A0 int (*check_message)(char *, unsigned int);
>> + =A0 =A0 bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
>> =A0};
>>
>> =A0struct smb_version_values {
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 65ec6ef..ce033d7 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -783,25 +783,6 @@ is_smb_response(struct TCP_Server_Info *server,=
 unsigned char type)
>> =A0 =A0 =A0 return false;
>> =A0}
>>
>> -static struct mid_q_entry *
>> -find_mid(struct TCP_Server_Info *server, char *buffer)
>> -{
>> - =A0 =A0 struct smb_hdr *buf =3D (struct smb_hdr *)buffer;
>> - =A0 =A0 struct mid_q_entry *mid;
>> -
>> - =A0 =A0 spin_lock(&GlobalMid_Lock);
>> - =A0 =A0 list_for_each_entry(mid, &server->pending_mid_q, qhead) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (mid->mid =3D=3D buf->Mid &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mid_state =3D=3D MID_REQUEST_=
SUBMITTED &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(mid->command) =3D=3D b=
uf->Command) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Loc=
k);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return mid;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 }
>> - =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> - =A0 =A0 return NULL;
>> -}
>> -
>> =A0void
>> =A0dequeue_mid(struct mid_q_entry *mid, bool malformed)
>> =A0{
>> @@ -986,7 +967,7 @@ standard_receive3(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
>> =A0 =A0 =A0 =A0* 48 bytes is enough to display the header and a litt=
le bit
>> =A0 =A0 =A0 =A0* into the payload for debugging purposes.
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 length =3D checkSMB(buf, server->total_read);
>> + =A0 =A0 length =3D server->ops->check_message(buf, server->total_r=
ead);
>> =A0 =A0 =A0 if (length !=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Bad SMB: ", buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min_t(unsigned int, serv=
er->total_read, 48));
>> @@ -1059,7 +1040,7 @@ cifs_demultiplex_thread(void *p)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->total_read +=3D length;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D find_mid(server, buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D server->ops->find_mid(server=
, buf);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!mid_entry || !mid_entry->receive)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D standard_rece=
ive3(server, mid_entry);
>> @@ -1076,13 +1057,13 @@ cifs_demultiplex_thread(void *p)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry !=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!mid_entry->multiRsp=
 || mid_entry->multiEnd)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entr=
y->callback(mid_entry);
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (!is_valid_oplock_break(buf, ser=
ver)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (!server->ops->is_oplock_break(b=
uf, server)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No task to wa=
ke, unknown frame received! "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
NumMids %d", atomic_read(&midCount));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Received =
Data is: ", buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 HEADER_SIZE(server));
>> =A0#ifdef CONFIG_CIFS_DEBUG2
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_detail(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ops->dump_detail(b=
uf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mids(server);
>> =A0#endif /* CIFS_DEBUG2 */
>>
>
>
> Hmmm, might it be cleaner to unconditionally add the dump_detail
> operation to smb_version_operations, and only set it when
> CONFIG_CIFS_DEBUG2 is enabled?
>
> With that, you could get rid of the #ifdef clutter in the code above.=
=2E.

Ok. In this case we should slightly fix cifs_dump_mids that is between
#ifdef statement too.

>
>
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index 31a6111..8a0b35b 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -22,6 +22,7 @@
>> =A0#include "cifs_debug.h"
>> =A0#include "cifspdu.h"
>> =A0#include "cifsproto.h"
>> +#include "cifs_debug.h"
>>
>> =A0/*
>> =A0 * An NT cancel request header looks just like the original reque=
st except:
>> @@ -82,6 +83,25 @@ cifs_read_data_length(char *buf)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_to_cpu(rsp->DataLength);
>> =A0}
>>
>> +static struct mid_q_entry *
>> +cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
>> +{
>> + =A0 =A0 struct smb_hdr *buf =3D (struct smb_hdr *)buffer;
>> + =A0 =A0 struct mid_q_entry *mid;
>> +
>> + =A0 =A0 spin_lock(&GlobalMid_Lock);
>> + =A0 =A0 list_for_each_entry(mid, &server->pending_mid_q, qhead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (mid->mid =3D=3D buf->Mid &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mid_state =3D=3D MID_REQUEST_=
SUBMITTED &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(mid->command) =3D=3D b=
uf->Command) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Loc=
k);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return mid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> + =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> + =A0 =A0 return NULL;
>> +}
>> +
>> =A0struct smb_version_operations smb1_operations =3D {
>> =A0 =A0 =A0 .send_cancel =3D send_nt_cancel,
>> =A0 =A0 =A0 .compare_fids =3D cifs_compare_fids,
>> @@ -90,6 +110,12 @@ struct smb_version_operations smb1_operations =3D=
 {
>> =A0 =A0 =A0 .read_data_offset =3D cifs_read_data_offset,
>> =A0 =A0 =A0 .read_data_length =3D cifs_read_data_length,
>> =A0 =A0 =A0 .map_error =3D map_smb_to_linux_error,
>> + =A0 =A0 .find_mid =3D cifs_find_mid,
>> + =A0 =A0 .check_message =3D checkSMB,
>> +#ifdef CONFIG_CIFS_DEBUG2
>> + =A0 =A0 .dump_detail =3D cifs_dump_detail,
>> +#endif
>> + =A0 =A0 .is_oplock_break =3D is_valid_oplock_break,
>> =A0};
>>
>> =A0struct smb_version_values smb1_values =3D {
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Best regards,
Pavel Shilovsky.
