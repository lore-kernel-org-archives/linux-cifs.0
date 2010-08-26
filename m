From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs bindaddr v2] cifs: Allow binding to local IP address.
Date: Thu, 26 Aug 2010 18:36:54 -0500
Message-ID: <AANLkTikdghfNW0Qq9DkWk8a363EYvKHQn65iOn0ni6e7@mail.gmail.com>
References: <1282844096-13295-1-git-send-email-greearb@candelatech.com>
	<20100826155733.6eccc377@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826155733.6eccc377-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There are clearly valid reasons for being able to select outgoing
interface - I wouldn't mind doing this using IPv6 address format if
that is more natural (since that can include ipv4 addresses) - or
distinct ipv4/ipv6

On Thu, Aug 26, 2010 at 2:57 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 26 Aug 2010 10:34:56 -0700
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
>
>> When using multi-homed machines, it's nice to be able to specify
>> the local IP to use for outbound connections. =A0This patch gives
>> cifs the ability to bind to a particular IP address.
>>
>> Usage: =A0mount -t cifs -o bindaddr=3D192.168.1.50,user=3Dfoo, ...
>>
>> Signed-off-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
>> ---
>> :100644 100644 b7431af... 77293db... M =A0 =A0 =A0 =A0fs/cifs/cifsfs=
=2Ec
>> :100644 100644 c9d0cfc... c0176d8... M =A0 =A0 =A0 =A0fs/cifs/cifsgl=
ob.h
>> :100644 100644 ec0ea4a... bacbf46... M =A0 =A0 =A0 =A0fs/cifs/connec=
t.c
>> =A0fs/cifs/cifsfs.c =A0 | =A0 =A04 +++
>> =A0fs/cifs/cifsglob.h | =A0 =A01 +
>> =A0fs/cifs/connect.c =A0| =A0 53 +++++++++++++++++++++++++++++++++++=
+++++++++++++++-
>> =A03 files changed, 56 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index b7431af..77293db 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -374,6 +374,10 @@ cifs_show_options(struct seq_file *s, struct vf=
smount *m)
>> =A0 =A0 =A0 if (tcon->ses->domainName)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",domain=3D%s", tcon->ses-=
>domainName);
>>
>> + =A0 =A0 if (tcon->ses->server->ip4_local_ip)
>> + =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",bindaddr=3D%pI4",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&tcon->ses->server-=
>ip4_local_ip);
>> +
>> =A0 =A0 =A0 seq_printf(s, ",uid=3D%d", cifs_sb->mnt_uid);
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",forceuid");
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index c9d0cfc..c0176d8 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -157,6 +157,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in sockAddr;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in6 sockAddr6;
>> =A0 =A0 =A0 } addr;
>> + =A0 =A0 u32 ip4_local_ip;
>> =A0 =A0 =A0 wait_queue_head_t response_q;
>> =A0 =A0 =A0 wait_queue_head_t request_q; /* if more than maxmpx to s=
rvr must block*/
>> =A0 =A0 =A0 struct list_head pending_mid_q;
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index ec0ea4a..bacbf46 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -105,6 +105,7 @@ struct smb_vol {
>> =A0 =A0 =A0 bool sockopt_tcp_nodelay:1;
>> =A0 =A0 =A0 unsigned short int port;
>> =A0 =A0 =A0 char *prepath;
>> + =A0 =A0 u32 local_ip; /* allow binding to a local IP address if !=3D=
 0 */
>> =A0 =A0 =A0 struct nls_table *local_nls;
>> =A0};
>>
>> @@ -1064,6 +1065,32 @@ cifs_parse_mount_options(char *options, const=
 char *devname,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "long\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "bindaddr", 8) =3D=
=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_storage la=
ddr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(&laddr, 0, sizeof(l=
addr));
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!value || !*value) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KER=
N_WARNING "CIFS: bindaddr value"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0" not specified.\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1; =
=A0 =A0 =A0 /* needs_arg; */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i =3D cifs_convert_address=
((struct sockaddr *)(&laddr),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0value, strlen(value));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->local=
_ip =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KER=
N_WARNING "CIFS: =A0Could not parse"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0" bindaddr: %s\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0value);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct soc=
kaddr_in *s4;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s4 =3D (st=
ruct sockaddr_in *)&laddr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (s4->si=
n_family =3D=3D AF_INET)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 vol->local_ip =3D s4->sin_addr.s_addr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 printk(KERN_WARNING "WARNING: =A0IPv6 "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0"bindaddr not supported yet.\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "prefixpath", =
10) =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!value || !*value) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(K=
ERN_WARNING
>> @@ -1393,7 +1420,8 @@ cifs_parse_mount_options(char *options, const =
char *devname,
>> =A0}
>>
>> =A0static bool
>> -match_address(struct TCP_Server_Info *server, struct sockaddr *addr=
)
>> +match_address(struct TCP_Server_Info *server, struct sockaddr *addr=
,
>> + =A0 =A0 =A0 =A0 =A0 u32 local_ip4)
>> =A0{
>> =A0 =A0 =A0 struct sockaddr_in *addr4 =3D (struct sockaddr_in *)addr=
;
>> =A0 =A0 =A0 struct sockaddr_in6 *addr6 =3D (struct sockaddr_in6 *)ad=
dr;
>> @@ -1406,6 +1434,8 @@ match_address(struct TCP_Server_Info *server, =
struct sockaddr *addr)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (addr4->sin_port &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 addr4->sin_port !=3D server->add=
r.sockAddr.sin_port)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (local_ip4 && (local_ip4 !=3D server->i=
p4_local_ip))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 case AF_INET6:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ipv6_addr_equal(&addr6->sin6_addr,
>> @@ -1487,7 +1517,7 @@ cifs_find_tcp_session(struct sockaddr *addr, s=
truct smb_vol *vol)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsNew)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!match_address(server, addr))
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!match_address(server, addr, vol->loca=
l_ip))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!match_security(server, vol))
>> @@ -1602,6 +1632,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =A0 =A0 =A0 =A0* no need to spinlock this init of tcpStatus or srv_c=
ount
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 tcp_ses->tcpStatus =3D CifsNew;
>> + =A0 =A0 tcp_ses->ip4_local_ip =3D volume_info->local_ip;
>> =A0 =A0 =A0 ++tcp_ses->srv_count;
>>
>> =A0 =A0 =A0 if (addr.ss_family =3D=3D AF_INET6) {
>> @@ -1678,6 +1709,10 @@ cifs_find_smb_ses(struct TCP_Server_Info *ser=
ver, struct smb_vol *vol)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
vol->password ? vol->password : "",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MAX_PASSWORD_SIZE))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->ip4_local_ip &=
&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (server->ip4_local=
_ip !=3D ses->server->ip4_local_ip))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* TODO: =A0Deal with IPv6=
 local addr matching? --Ben */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++ses->ses_count;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&cifs_tcp_ses_lock);
>> @@ -2051,6 +2086,20 @@ ipv4_connect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket4(socket);
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 /* Bind to the local IP address if specified */
>> + =A0 =A0 if (server->ip4_local_ip) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in myaddr =3D {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .sin_family =3D AF_INET,
>> + =A0 =A0 =A0 =A0 =A0 =A0 };
>> + =A0 =A0 =A0 =A0 =A0 =A0 myaddr.sin_addr.s_addr =3D server->ip4_loc=
al_ip;
>> + =A0 =A0 =A0 =A0 =A0 =A0 myaddr.sin_port =3D 0; /* any */
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->bind(socket, (struct s=
ockaddr *) &myaddr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0sizeof(myaddr));
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Failed to bind =
to: %pI4, error: %d\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&server->ip=
4_local_ip, rc);
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 /* user overrode default port */
>> =A0 =A0 =A0 if (server->addr.sockAddr.sin_port) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket, (str=
uct sockaddr *)
>
>
> I'm not crazy about this patch. It seems like this ought to be the
> purview of the routing table. I know however that there are situation=
s
> where that's not really possible (clusters with floating IP addrs, fo=
r
> instance).
>
> That said, even if we were to do something along these lines, it seem=
s
> like it ought to be more transport neutral (i.e. not IPv4 only like
> this patch is).
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
