From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: set socket send and receive timeouts before
 attempting connect
Date: Thu, 9 Jun 2011 09:10:42 -0500
Message-ID: <BANLkTinkb-wcmrhLbN_VcmLBtEJQJodeHw@mail.gmail.com>
References: <1307627623-4794-1-git-send-email-jlayton@redhat.com>
	<20110609095624.096bc108@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, da_joind-hi6Y0CQ0nG0@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110609095624.096bc108-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jun 9, 2011 at 8:56 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, =A09 Jun 2011 09:53:43 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Benjamin S. reported that he was unable to suspend his machine while
>> it had a cifs share mounted. The freezer caused this to spew when he
>> tried it:
>> We do attempt to perform a try_to_freeze in cifs_reconnect, but the
>> connection attempt itself seems to be taking longer than 20s to time
>> out. The connect timeout is governed by the socket send and receive
>> timeouts, so we can shorten that period by setting those timeouts
>> before attempting the connect instead of after.
>>
>> Adam Williamson tested the patch and said that it seems to have fixe=
d
>> suspending on his laptop when a cifs share is mounted.
>>
>> Reported-by: Benjamin S <da_joind-hi6Y0CQ0nG0@public.gmane.org>
>> Tested-by: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 16 ++++++++--------
>> =A01 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 61ed0ba..4ec9630 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2471,14 +2471,6 @@ generic_ip_connect(struct TCP_Server_Info *se=
rver)
>> =A0 =A0 =A0 if (rc < 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> - =A0 =A0 rc =3D socket->ops->connect(socket, saddr, slen, 0);
>> - =A0 =A0 if (rc < 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server", r=
c);
>> - =A0 =A0 =A0 =A0 =A0 =A0 sock_release(socket);
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> - =A0 =A0 }
>> -
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Eventually check for other socket options to change=
 from
>> =A0 =A0 =A0 =A0* the default. sock_setsockopt not used because it ex=
pects
>> @@ -2507,6 +2499,14 @@ generic_ip_connect(struct TCP_Server_Info *se=
rver)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0socket->sk->sk_sndbuf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0socket->sk->sk_rcvbuf, socket->sk->sk=
_rcvtimeo);
>>
>> + =A0 =A0 rc =3D socket->ops->connect(socket, saddr, slen, 0);
>> + =A0 =A0 if (rc < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server", r=
c);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sock_release(socket);
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 if (sport =3D=3D htons(RFC1001_PORT))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ip_rfc1001_connect(server);
>>
>> --
>> 1.7.5.2
>>
>
> Doh! I meant to mark this for stable too as I think it's probably
> reasonable for that. Steve, would you add "Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" if
> you agree?

yes


--=20
Thanks,

Steve
