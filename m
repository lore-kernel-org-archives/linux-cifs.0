From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: remove unneeded variable initialization in cifs_reconnect_tcon
Date: Tue, 5 Apr 2011 12:20:52 -0500
Message-ID: <BANLkTi=pfFJKs3ZE1ogZrxpaJGf94RFxew@mail.gmail.com>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
	<1301607405-4379-3-git-send-email-jlayton@redhat.com>
	<BANLkTin4Js462-nZcBcSYD6YO_1b9UEeRA@mail.gmail.com>
	<20110405101729.27657db0@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110405101729.27657db0-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 5, 2011 at 12:17 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 5 Apr 2011 12:06:59 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> This is fine, but what about this alternative (initializing variable=
s
>> can make code easier to read, and given dumb compiler warnings
>> sometimes better to leave in variable initialization ...):
>>
>> stevef@stevef-laptop:~/cifs-2.6$ git diff -a
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 92e33d4..e4993a2 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -117,7 +117,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int =
smb_command)
>> =A0 =A0 =A0 =A0 =A0* calling routine
>> =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 if (!tcon)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> =A0 =A0 =A0 =A0 ses =3D tcon->ses;
>> =A0 =A0 =A0 =A0 server =3D ses->server;
>>
>>
>
> So instead of eliminating a useless variable initialization, we inste=
ad
> manufacture a use for it? That seems sort of counter-productive, no?

since we do "return rc" later in the function, why wouldn't we do the
same earlier
in the function for consistency? With rc initialized it is a bit easier=
 to read.



--=20
Thanks,

Steve
