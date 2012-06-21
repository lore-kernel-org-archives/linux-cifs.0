From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 06/24] CIFS: Add SMB2 credits support
Date: Thu, 21 Jun 2012 11:43:21 +0400
Message-ID: <CAKywueTM7mEdaQmoWh8R2Wngk4ra8XacdiGETAepzaPbWrgDEw@mail.gmail.com>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
	<1340202664-28696-7-git-send-email-pshilovsky@samba.org>
	<20120620192038.26b486ec@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120620192038.26b486ec-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/21 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 20 Jun 2012 18:30:46 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> For SMB2 protocol we can add more than one credit for one received
>> request: it depends on CreditRequest field in SMB2 response header.
>> Also we divide all requests by type: echos, oplocks and others. Each
>> type uses its own slot pull.
>>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A05 +++
>> =A0fs/cifs/cifsproto.h | =A0 =A01 +
>> =A0fs/cifs/connect.c =A0 | =A0 =A02 +-
>> =A0fs/cifs/smb2ops.c =A0 | =A0 77 ++++++++++++++++++++++++++++++++++=
+++++++++++++++++
>> =A04 files changed, 84 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 3575f0f..d94d3ee 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -343,6 +343,11 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 char server_GUID[16];
>> =A0 =A0 =A0 __u16 sec_mode;
>> =A0 =A0 =A0 bool session_estab; /* mark when very first sess is esta=
blished */
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 int echo_credits; =A0/* echo reserved slots */
>> + =A0 =A0 int oplock_credits; =A0/* oplock break reserved slots */
>> + =A0 =A0 bool echos:1; /* enable echos */
>> +#endif
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> =A0 =A0 =A0 enum securityEnum secType;
>> =A0 =A0 =A0 bool oplocks:1; /* enable oplocks */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 80d35ee..907f43c 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -91,6 +91,7 @@ extern int SendReceiveBlockingLock(const unsigned =
int xid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf ,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *out_buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *bytes_returned);
>> +extern int cifs_reconnect(struct TCP_Server_Info *server);
>> =A0extern int checkSMB(char *buf, unsigned int length);
>> =A0extern bool is_valid_oplock_break(char *, struct TCP_Server_Info =
*);
>> =A0extern bool backup_cred(struct cifs_sb_info *);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 718bbea..cced470 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -296,7 +296,7 @@ static int cifs_setup_volume_info(struct smb_vol=
 *volume_info, char *mount_data,
>> =A0 * reconnect tcp session
>> =A0 * wake up waiters on reconnection? - (not needed currently)
>> =A0 */
>> -static int
>> +int
>> =A0cifs_reconnect(struct TCP_Server_Info *server)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index 09530f4..ab2590f 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -20,6 +20,79 @@
>> =A0#include "cifsglob.h"
>> =A0#include "smb2pdu.h"
>> =A0#include "smb2proto.h"
>> +#include "cifsproto.h"
>> +#include "cifs_debug.h"
>> +
>> +static void
>> +change_conf(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 server->credits +=3D server->echo_credits + server->oplock=
_credits;
>> + =A0 =A0 server->oplock_credits =3D server->echo_credits =3D 0;
>> + =A0 =A0 switch (server->credits) {
>> + =A0 =A0 case 0:
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> + =A0 =A0 case 1:
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->echos =3D false;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0minor nit if you end up respinning thi=
s. The proper
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spelling in English is "echoes".

Thanks - will fix it.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->oplocks =3D false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "disabling echos and oplocks");
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case 2:
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->echos =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->oplocks =3D false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->echo_credits =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "disabling oplocks");
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->echos =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->oplocks =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->echo_credits =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->oplock_credits =3D 1;
>> + =A0 =A0 }
>> + =A0 =A0 server->credits -=3D server->echo_credits + server->oplock=
_credits;
>> +}
>> +
>> +static void
>> +smb2_add_credits(struct TCP_Server_Info *server, const unsigned int=
 add,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0const int optype)
>> +{
>> + =A0 =A0 int *val;
>> + =A0 =A0 spin_lock(&server->req_lock);
>> + =A0 =A0 val =3D server->ops->get_credits_field(server, optype);
>> + =A0 =A0 *val +=3D add;
>> + =A0 =A0 server->in_flight--;
>> + =A0 =A0 if (server->in_flight =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 change_conf(server);
>> + =A0 =A0 spin_unlock(&server->req_lock);
>> + =A0 =A0 wake_up(&server->request_q);
>> +}
>> +
>> +static void
>> +smb2_set_credits(struct TCP_Server_Info *server, const int val)
>> +{
>> + =A0 =A0 spin_lock(&server->req_lock);
>> + =A0 =A0 server->credits =3D val;
>> + =A0 =A0 spin_unlock(&server->req_lock);
>> +}
>> +
>> +static int *
>> +smb2_get_credits_field(struct TCP_Server_Info *server, const int op=
type)
>> +{
>> + =A0 =A0 switch (optype) {
>> + =A0 =A0 case CIFS_ECHO_OP:
>> + =A0 =A0 =A0 =A0 =A0 =A0 return &server->echo_credits;
>> + =A0 =A0 case CIFS_OBREAK_OP:
>> + =A0 =A0 =A0 =A0 =A0 =A0 return &server->oplock_credits;
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 return &server->credits;
>> + =A0 =A0 }
>> +}
>> +
>> +static unsigned int
>> +smb2_get_credits(struct mid_q_entry *mid)
>> +{
>> + =A0 =A0 return le16_to_cpu(((struct smb2_hdr *)mid->resp_buf)->Cre=
ditRequest);
>> +}
>>
>> =A0static __u64
>> =A0smb2_get_next_mid(struct TCP_Server_Info *server)
>> @@ -35,6 +108,10 @@ smb2_get_next_mid(struct TCP_Server_Info *server=
)
>> =A0struct smb_version_operations smb21_operations =3D {
>> =A0 =A0 =A0 .setup_request =3D smb2_setup_request,
>> =A0 =A0 =A0 .check_receive =3D smb2_check_receive,
>> + =A0 =A0 .add_credits =3D smb2_add_credits,
>> + =A0 =A0 .set_credits =3D smb2_set_credits,
>> + =A0 =A0 .get_credits_field =3D smb2_get_credits_field,
>> + =A0 =A0 .get_credits =3D smb2_get_credits,
>> =A0 =A0 =A0 .get_next_mid =3D smb2_get_next_mid,
>> =A0};
>>
>
> Looks fine.
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best regards,
Pavel Shilovsky.
