From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 05/11] CIFS: Prepare credits code for a slot reservation
Date: Tue, 20 Mar 2012 11:03:12 +0400
Message-ID: <CAKywueR-LHU9r4H0g7g-akn7gV4qWQ57Q_SfHnrsEAXK2ooSFQ@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-6-git-send-email-piastry@etersoft.ru>
	<20120319152702.3eee1608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120319152702.3eee1608-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

19 =CD=C1=D2=D4=C1 2012=9A=C7. 23:27 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Fri, 16 Mar 2012 18:09:28 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> that is essential for CIFS/SMB/SMB2 oplock breaks and SMB2 echos.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =9Afs/cifs/cifsglob.h =9A| =9A 14 ++++++++++++--
>> =9Afs/cifs/transport.c | =9A 22 ++++++++++++++--------
>> =9A2 files changed, 26 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index d55de96..2309a67 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -315,12 +315,22 @@ in_flight(struct TCP_Server_Info *server)
>> =9A =9A =9A return num;
>> =9A}
>>
>> +static inline int*
>> +get_credits_field(struct TCP_Server_Info *server)
>> +{
>> + =9A =9A /*
>> + =9A =9A =9A* This will change to switch statement when we reserve =
slots for echos
>> + =9A =9A =9A* and oplock breaks.
>> + =9A =9A =9A*/
>> + =9A =9A return &server->credits;
>> +}
>> +
>> =9Astatic inline bool
>> -has_credits(struct TCP_Server_Info *server)
>> +has_credits(struct TCP_Server_Info *server, int *credits)
>
> Why are you passing "credits" by reference here? Might as well pass b=
y
> value...

This was done because we need to be sure that we are doing credits
pointer dereferencing under server->req_lock - no one is changing it
at that time. We wake up by the signal, lock req_lock and then
dereference credits pointer (that may refer to reserved credits slot
in the future).

>
>> =9A{
>> =9A =9A =9A int num;
>> =9A =9A =9A spin_lock(&server->req_lock);
>> - =9A =9A num =3D server->credits;
>> + =9A =9A num =3D *credits;
>> =9A =9A =9A spin_unlock(&server->req_lock);
>> =9A =9A =9A return num > 0;
>> =9A}
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 11787cc..20dc7ba 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -255,26 +255,26 @@ smb_send(struct TCP_Server_Info *server, struc=
t smb_hdr *smb_buffer,
>> =9A}
>>
>> =9Astatic int
>> -wait_for_free_request(struct TCP_Server_Info *server, const int lon=
g_op)
>> +wait_for_free_credits(struct TCP_Server_Info *server, const int opt=
ype,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A int *credits)
>> =9A{
>> =9A =9A =9A int rc;
>>
>> =9A =9A =9A spin_lock(&server->req_lock);
>> -
>> - =9A =9A if (long_op =3D=3D CIFS_ASYNC_OP) {
>> + =9A =9A if (optype =3D=3D CIFS_ASYNC_OP) {
>> =9A =9A =9A =9A =9A =9A =9A /* oplock breaks must not be held up */
>> =9A =9A =9A =9A =9A =9A =9A server->in_flight++;
>> - =9A =9A =9A =9A =9A =9A server->credits--;
>> + =9A =9A =9A =9A =9A =9A *credits -=3D 1;
>> =9A =9A =9A =9A =9A =9A =9A spin_unlock(&server->req_lock);
>> =9A =9A =9A =9A =9A =9A =9A return 0;
>> =9A =9A =9A }
>>
>> =9A =9A =9A while (1) {
>> - =9A =9A =9A =9A =9A =9A if (server->credits <=3D 0) {
>> + =9A =9A =9A =9A =9A =9A if (*credits <=3D 0) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_unlock(&server->req=
_lock);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_num_waiters_inc(ser=
ver);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A rc =3D wait_event_killab=
le(server->request_q,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9A =9Ahas_credits(server));
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9A =9Ahas_credits(server, credits));
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_num_waiters_dec(ser=
ver);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (rc)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A return r=
c;
>> @@ -291,8 +291,8 @@ wait_for_free_request(struct TCP_Server_Info *se=
rver, const int long_op)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A*/
>>
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /* update # of requests =
on the wire to server */
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (long_op !=3D CIFS_BLOC=
KING_OP) {
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A server->cr=
edits--;
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (optype !=3D CIFS_BLOCK=
ING_OP) {
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A *credits -=
=3D 1;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A server->=
in_flight++;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A }
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_unlock(&server->req=
_lock);
>> @@ -302,6 +302,12 @@ wait_for_free_request(struct TCP_Server_Info *s=
erver, const int long_op)
>> =9A =9A =9A return 0;
>> =9A}
>>
>> +static int
>> +wait_for_free_request(struct TCP_Server_Info *server, const int opt=
ype)
>> +{
>> + =9A =9A return wait_for_free_credits(server, optype, get_credits_f=
ield(server));
>> +}
>> +
>> =9Astatic int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_=
buf,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct mid_q_entry **ppm=
idQ)
>> =9A{
>
>
> Other than that nit, this looks fine...
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =9Ahttp://vger.kernel.org/majordomo-info.html



--=20
Best regards,
Pavel Shilovsky.
