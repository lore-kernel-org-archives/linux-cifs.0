From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add match_port check during looking for an
 existing connection (try #2)
Date: Tue, 16 Nov 2010 22:13:26 +0300
Message-ID: <AANLkTinMADJG4hPeQNQCqbP=HYAE4xRY4Ow+LCs4BHT_@mail.gmail.com>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<1289893710-7352-2-git-send-email-piastryyy@gmail.com>
	<AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/16 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Tue, Nov 16, 2010 at 1:48 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>> If we have a share mounted by non-standard port and try to mount ano=
ther share
>> on the same host with standard port, we connect to the first share a=
gain -
>> that's wrong. This patch fixes this bug.
>
> The description seems a little strange - can you clarify?
>
> If we have an existing session with a server (using whatever port), b=
y
> default we want to use it (unless the user forces a different port
> than the existing connection was made with). =A0If we have a firewall
> issue and therefore go through a non-standard port (port=3Dsomething =
on
> mount), we usually wouldn't want to fork a new connection on a second
> connection to the same server.
>
> So if we specify port=3D5000 on a mount and we already have a mount o=
n
> port 139, it makes sense that we would want to create a new session.
> But if you already have a mount on port 5000, and did a mount with no
> port specified - why wouldn't you use the existing port? =A0It saves

When we have several Samba servers on the same host on different
ports(e.x. 445 and 5000) and user has already mounted "5000" server,
we can't use the existing connection if it tries to mount again
without specifying the port, because user wants to mount the server on
445 port rather than 5000. They are dirrefent servers with different
shares and different contents and it doesn't matter that they are
listening on the same host - we have to established two TCP connection
anyway.

> server, client and network resources.
>

--=20
Best regards,
Pavel Shilovsky.
