From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount option named backup
Date: Mon, 29 Aug 2011 16:24:33 -0500
Message-ID: <CADT32eJPyKhkTx6vbsS4hRnaqAQAs0aTime_pz-NRvowotVyqg@mail.gmail.com>
References: <1313166821-9172-1-git-send-email-shirishpargonkar@gmail.com>
	<CADT32eJsAgNkhnY1VZ6wpxa2013h7TmO6i3H=4a6D8ke8iU2Aw@mail.gmail.com>
	<20110823091510.2d8b8027@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110823091510.2d8b8027-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 23, 2011 at 8:15 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 22 Aug 2011 08:33:49 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Aug 12, 2011 at 11:33 AM, =A0<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >
>> >
>> > Add mount option backup.
>> >
>> > It allows an authenticated user to access files with the intent to=
 back them
>> > up including their ACLs, who may not have access permission but ha=
s
>> > "Backup files and directories user right" on them (by virtue of be=
ing part
>> > of the built-in group Backup Operators.
>> >
>> > If an authenticated user is not part of the built-in group Backup =
Operators
>> > at the server, access to such files is denied.
>> >
>> >
>> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > ---
>>
>>
>> Jeff, =A0Steve,
>>
>> Any comments on this patch (and manpage patch in cifs-utils)?
>>
>
> This seems like a really nasty kludge. It doesn't seem like the
> implications of this have been carefully considered.
>
> What happens I mount with the "backup" flag and do not have the
> necessary permissions on the server to use the flag in an open? Will
> this new flag be mutually exclusive with "multiuser"?
>
> One idea that might be better is to come up with way to mark certain
> (unix) users with the appropriate flag. If all the backup users were =
in
> a certan group, for instance, then you could use that info to decide
> whether to set the flag in the open calls.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Jeff, one comment, it is not the (unix) user that matters, it is the
user on the server (authenticated) user at the server because the
user right to access a file in backup mode can be granted only
to a user at the server.

I think care should be taken to make sure that backup and
multiuser are mutually exclusive mount options in mount.cifs.

Regards,

Shirish
