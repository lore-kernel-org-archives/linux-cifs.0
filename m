From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount option named backup
Date: Tue, 30 Aug 2011 09:03:05 -0500
Message-ID: <CADT32e+XQ7ar7y_MADUwwEi081Q_-QDeY79ga9ykOxVyp=yb8g@mail.gmail.com>
References: <1313166821-9172-1-git-send-email-shirishpargonkar@gmail.com>
	<CADT32eJsAgNkhnY1VZ6wpxa2013h7TmO6i3H=4a6D8ke8iU2Aw@mail.gmail.com>
	<20110823091510.2d8b8027@corrin.poochiereds.net>
	<CADT32eJPyKhkTx6vbsS4hRnaqAQAs0aTime_pz-NRvowotVyqg@mail.gmail.com>
	<20110829202910.0038ca06@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110829202910.0038ca06-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 29, 2011 at 7:29 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 29 Aug 2011 16:24:33 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Aug 23, 2011 at 8:15 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
>> > On Mon, 22 Aug 2011 08:33:49 -0500
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Fri, Aug 12, 2011 at 11:33 AM, =A0<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>> >> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> >
>> >> >
>> >> > Add mount option backup.
>> >> >
>> >> > It allows an authenticated user to access files with the intent=
 to back them
>> >> > up including their ACLs, who may not have access permission but=
 has
>> >> > "Backup files and directories user right" on them (by virtue of=
 being part
>> >> > of the built-in group Backup Operators.
>> >> >
>> >> > If an authenticated user is not part of the built-in group Back=
up Operators
>> >> > at the server, access to such files is denied.
>> >> >
>> >> >
>> >> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> > ---
>> >>
>> >>
>> >> Jeff, =A0Steve,
>> >>
>> >> Any comments on this patch (and manpage patch in cifs-utils)?
>> >>
>> >
>> > This seems like a really nasty kludge. It doesn't seem like the
>> > implications of this have been carefully considered.
>> >
>> > What happens I mount with the "backup" flag and do not have the
>> > necessary permissions on the server to use the flag in an open? Wi=
ll
>> > this new flag be mutually exclusive with "multiuser"?
>> >
>> > One idea that might be better is to come up with way to mark certa=
in
>> > (unix) users with the appropriate flag. If all the backup users we=
re in
>> > a certan group, for instance, then you could use that info to deci=
de
>> > whether to set the flag in the open calls.
>> >
>> > --
>> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> >
>>
>> Jeff, one comment, it is not the (unix) user that matters, it is the
>> user on the server (authenticated) user at the server because the
>> user right to access a file in backup mode can be granted only
>> to a user at the server.
>>
>
> Right, I realize that.
>
>> I think care should be taken to make sure that backup and
>> multiuser are mutually exclusive mount options in mount.cifs.
>>
>
> My objection here is more fundamental...
>
> This patchset lends itself to a single, specific use. You can create =
a
> mount that you want to use for backups. Typically, when running backu=
ps
> like this you also intend for this mount to be used by only one (unix=
)
> user.
>
> Adding a "backup" option is tantamount to adding extra privileges to
> this mount for anyone who accesses it. However, it's not clear to me
> how these extra privileges will be secured from other users that don'=
t
> necessarily need them.
>
> It seems to me that it would be far more useful to find a way to only
> add these extra "backup" permissions for certain unix users that are
> accessing the mount.
>
> Does that make sense?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Jeff, definitely. Thanks.  I think one way might be to specify an
user or uid and restrict the usage of that mount to that user id?
So you can specify mount option as  either backup=3Duserxyz
or backup=3D1001 perhaps?

Regards,

Shirish
