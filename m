From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] manpage: change port option description (try #2)
Date: Tue, 4 Jan 2011 23:22:36 +0300
Message-ID: <AANLkTinYjstp1M=J7fVF1w3GHyNaof-gVVTf2RW=aAoa@mail.gmail.com>
References: <1290105010-2915-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290105010-2915-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/18 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Provide changes according to new ip/port connection logic in CIFS.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0mount.cifs.8 | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 7d2bf69..bde0770 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -132,7 +132,7 @@ instructs the client to ignore any gid provided b=
y the server for files and dire
> =A0.PP
> =A0port=3D\fIarg\fR
> =A0.RS 4
> -sets the port number on the server to attempt to contact to negotiat=
e CIFS support\&. If the CIFS server is not listening on this port or i=
f it is not specified, the default ports will be tried i\&.e\&. port 44=
5 is tried and if no response then port 139 is tried\&.
> +sets the port number on which the client will attempt to contact the=
 CIFS server\&. If this value is specified, look for an existing connec=
tion with this port, and use that if one exists\&. If one doesn't exist=
, try to create a new connection on that port\&. If that connection fai=
ls, return an error\&. If this value isn't specified, look for an exist=
ing connection on port 445 or 139\&. If no such connection exists, try =
to connect on port 445 first and then port 139 if that fails\&. Return =
an error if both fail\&.
> =A0.RE
> =A0.PP
> =A0servern=3D\fIarg\fR
> --
> 1.7.3.2
>
>

Jeff, what's about this patch? The kernel part is already pushed to ups=
tream.

--=20
Best regards,
Pavel Shilovsky.
