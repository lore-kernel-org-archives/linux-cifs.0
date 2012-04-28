From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setuids/setgids by default
Date: Sat, 28 Apr 2012 10:52:01 -0500
Message-ID: <CAH2r5msFQ504mwveQ6hZpXoZpTuPjze=GgOBowVg4xACfuP5+Q@mail.gmail.com>
References: <CAKywueSQQfzwkWgE33+w=y2pnQQd4nxhvJX71NaAa0E_BLAcbg@mail.gmail.com>
	<20120428080230.160c6b38@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120428080230.160c6b38-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Apr 28, 2012 at 7:02 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 28 Apr 2012 14:42:35 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi!
>>
>> Now CIFS client doesn't enforce uid and gid permission from the
>> process that create file by default (new files are created with moun=
t
>> user permission) and it can be 'fixed' by setuids/setgids mount
>> option. Why this options should not be by default? I think it
>> contradict POSIX.
>>
>
> Welcome to the morass that we call "the cifs.ko permissions model".
>
> The reason we don't do that by default is because it doesn't work. Wh=
at
> happens is that the client does a unix SetPathInfo call to try and
> chown the file, but in =A0order to chown() a file on unix, you need
> superuser permissions.
>
> Once the session setup is done, the server daemon will usually setuid=
()
> itself to the user you're mounting as, and at that point you don't ha=
ve
> permissions to chown anymore.
>
> What "setuids" also does is to "fake up" the ownership of the inode
> temporarily just after creation. That's just a hack though -- as soon=
 as
> the attributes are fetched from the server again, that goes away, so
> results with that are inconsistent.
>
> Ha, and it looks like "setuids" is broken when you create files in
> cifs_lookup anyway! Maybe someone should fix that sometime...
>
> In any case, I maintain that the only *real* fix for all of these
> permissions problems is to both:
>
> 1) have users use the correct credentials when they talk to the serve=
r.
> Files get created with the correct ownership this way.
>
> 2) stop trying to enforce permissions on the client. It's racy and ju=
st
> gets in the way. Permissions can only be correctly enforced by the
> server.
>
> This is what the "multiuser" mount option does. If anything, I'd rath=
er
> see a transition to that being the default. It's the only sane
> solution, IMO.

I think moving to multiuser as default for SMB2 mounts, for example,
would be logical (and probably cifsacl as well, and of course noperm
checking on the client) - not sure we want to change the cifs mount
defaults quickly but makes sense for smb2 (and reduces
complexity).


--=20
Thanks,

Steve
