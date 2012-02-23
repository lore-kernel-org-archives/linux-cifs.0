From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 04/11] CIFS: Delete echo_retries module parm
Date: Thu, 23 Feb 2012 10:16:37 +0400
Message-ID: <CAKywueQDP9un8U_pchAJcP1fE+h08hQ0qDyoiBL1Ma=EasDXiw@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-5-git-send-email-piastry@etersoft.ru>
	<20120222112323.3d1afe4b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120222112323.3d1afe4b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/22 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Wed, 22 Feb 2012 10:32:57 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> It's the essential step before respecting MaxMpxCount value during
>> negotiating because we will keep only one extra slot for sending
>> echo requests. If there is no response for echo message - reconnect
>> the tcp session.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/README =A0 =A0 | =A0 =A06 +-----
>> =A0fs/cifs/cifsfs.c =A0 | =A0 =A05 -----
>> =A0fs/cifs/cifsglob.h | =A0 =A03 ---
>> =A0fs/cifs/connect.c =A0| =A0 =A07 +++----
>> =A04 files changed, 4 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/cifs/README b/fs/cifs/README
>> index 895da1d..b7d782b 100644
>> --- a/fs/cifs/README
>> +++ b/fs/cifs/README
>> @@ -753,10 +753,6 @@ module loading or during the runtime by using t=
he interface
>>
>> =A0i.e. echo "value" > /sys/module/cifs/parameters/<param>
>>
>> -1. echo_retries - The number of echo attempts before giving up and
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 reconnecting to the server. The defaul=
t is 5. The value 0
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 means never reconnect.
>> -
>> -2. enable_oplocks - Enable or disable oplocks. Oplocks are enabled =
by default.
>> +1. enable_oplocks - Enable or disable oplocks. Oplocks are enabled =
by default.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Y/y/1]. To disable use any of [=
N/n/0].
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index b1fd382..e1ce1ca 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -77,11 +77,6 @@ unsigned int cifs_max_pending =3D CIFS_MAX_REQ;
>> =A0module_param(cifs_max_pending, int, 0444);
>> =A0MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to serv=
er. "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
Default: 50 Range: 2 to 256");
>> -unsigned short echo_retries =3D 5;
>> -module_param(echo_retries, ushort, 0644);
>> -MODULE_PARM_DESC(echo_retries, "Number of echo attempts before givi=
ng up and "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"reconnecti=
ng server. Default: 5. 0 means "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"never reco=
nnect.");
>> =A0module_param(enable_oplocks, bool, 0644);
>> =A0MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool=
). Default:"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"y/Y/=
1");
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 600d61c..674792e 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -1049,9 +1049,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv; =A0 =A0=
/* min size of big ntwrk buf pool */
>> =A0GLOBAL_EXTERN unsigned int cifs_min_small; =A0/* min size of smal=
l buf pool */
>> =A0GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at o=
nce to server*/
>>
>> -/* reconnect after this many failed echo attempts */
>> -GLOBAL_EXTERN unsigned short echo_retries;
>> -
>> =A0#ifdef CONFIG_CIFS_ACL
>> =A0GLOBAL_EXTERN struct rb_root uidtree;
>> =A0GLOBAL_EXTERN struct rb_root gidtree;
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 673813f..86d7a40 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -373,12 +373,11 @@ allocate_buffers(struct TCP_Server_Info *serve=
r)
>> =A0static bool
>> =A0server_unresponsive(struct TCP_Server_Info *server)
>> =A0{
>> - =A0 =A0 if (echo_retries > 0 && server->tcpStatus =3D=3D CifsGood =
&&
>> - =A0 =A0 =A0 =A0 time_after(jiffies, server->lstrp +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (echo_retr=
ies * SMB_ECHO_INTERVAL))) {
>> + =A0 =A0 if (server->tcpStatus =3D=3D CifsGood &&
>> + =A0 =A0 =A0 =A0 time_after(jiffies, server->lstrp + SMB_ECHO_INTER=
VAL)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Server %s has not responded i=
n %d seconds. "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Reconnecting...", s=
erver->hostname,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (echo_retries * SMB_EC=
HO_INTERVAL / HZ));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMB_ECHO_INTERVAL / HZ=
);
>
> This will be a problem since we skip sending an echo when the client
> has gotten a response recently (within the last echo interval).
>
> Consider:
>
> 1s =A0 =A0 =A0client sends a normal smb request
> 2s =A0 =A0 =A0client gets a response
> 30s =A0 =A0 echo workqueue job pops, and decides we got a response
> =A0 =A0 =A0 =A0recently and don't need to send another
> ...
> 65s =A0 =A0 kernel_recvmsg times out, and we see that we haven't gott=
en
> =A0 =A0 =A0 =A0a response in >60s
>
> ...I think you'll probably want to only reconnect when we haven't
> gotten a response in 2 echo intervals? Or maybe there's a better way?
>

Seems like 2 intervals is good for now. We can change this later, if
we find a better way.

--=20
Best regards,
Pavel Shilovsky.
