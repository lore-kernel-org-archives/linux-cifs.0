From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount option named backup
Date: Mon, 19 Sep 2011 13:34:35 -0500
Message-ID: <CADT32eJ3h3sgcg8PrssAgYR1i0Hv0hA_Tm15LPpvDvXxG1B64A@mail.gmail.com>
References: <1313166821-9172-1-git-send-email-shirishpargonkar@gmail.com>
	<CADT32eJsAgNkhnY1VZ6wpxa2013h7TmO6i3H=4a6D8ke8iU2Aw@mail.gmail.com>
	<20110823091510.2d8b8027@corrin.poochiereds.net>
	<CADT32eJPyKhkTx6vbsS4hRnaqAQAs0aTime_pz-NRvowotVyqg@mail.gmail.com>
	<20110829202910.0038ca06@corrin.poochiereds.net>
	<CADT32e+XQ7ar7y_MADUwwEi081Q_-QDeY79ga9ykOxVyp=yb8g@mail.gmail.com>
	<20110830105201.1aff3900@tlielax.poochiereds.net>
	<CAH2r5mt4U1pqGiD4ELQnM_Xgies38-dhZj_XtXi1TFWbE-260A@mail.gmail.com>
	<CADT32eLZW1ihDk_6JTU8Y7Vy5onc6qfJCfChOa=9ZwLd34ubTg@mail.gmail.com>
	<CAH2r5mt_Ve4bpch-3dBT8JXw+AP=SE6dX2m3oQoM9mUkJQBR4A@mail.gmail.com>
	<CADT32eK+X26AXr6OBNn+woaLKotECCvAM2Vchih7-+LcvOuXrQ@mail.gmail.com>
	<20110918080034.12f277c3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110918080034.12f277c3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 18, 2011 at 7:00 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 17 Sep 2011 14:04:56 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Aug 30, 2011 at 12:54 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>> > On Tue, Aug 30, 2011 at 12:32 PM, Shirish Pargaonkar
>> > <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> On Tue, Aug 30, 2011 at 12:09 PM, Steve French <smfrench-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>> >>> On Tue, Aug 30, 2011 at 9:52 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>=
 wrote:
>> >>>> On Tue, 30 Aug 2011 09:03:05 -0500
>> >>>> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>>>
>> >>>>> On Mon, Aug 29, 2011 at 7:29 PM, Jeff Layton <jlayton-eUNUBHrolfY@public.gmane.org=
g> wrote:
>> >>>>> > On Mon, 29 Aug 2011 16:24:33 -0500
>> >>>>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>>>> >
>> >>>>> >> On Tue, Aug 23, 2011 at 8:15 AM, Jeff Layton <jlayton@samba=
=2Eorg> wrote:
>> >>>>> >> > On Mon, 22 Aug 2011 08:33:49 -0500
>> >>>>> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>>>> >> >
>> >>>>> >> >> On Fri, Aug 12, 2011 at 11:33 AM, =A0<shirishpargaonkar@=
gmail.com> wrote:
>> >>>>> >> >> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>>>> >> >> >
>> >>>>> >> >> >
>> >>>>> >> >> > Add mount option backup.
>> >>>>> >> >> >
>> >>>>> >> >> > It allows an authenticated user to access files with t=
he intent to back them
>> >>>>> >> >> > up including their ACLs, who may not have access permi=
ssion but has
>> >>>>> >> >> > "Backup files and directories user right" on them (by =
virtue of being part
>> >>>>> >> >> > of the built-in group Backup Operators.
>> >>>>> >> >> >
>> >>>>> >> >> > If an authenticated user is not part of the built-in g=
roup Backup Operators
>> >>>>> >> >> > at the server, access to such files is denied.
>> >>>>> >> >> >
>> >>>>> >> >> >
>> >>>>> >> >> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@g=
mail.com>
>> >>>>> >> >> > ---
>> >>>>> >> >>
>> >>>>> >> >>
>> >>>>> >> >> Jeff, =A0Steve,
>> >>>>> >> >>
>> >>>>> >> >> Any comments on this patch (and manpage patch in cifs-ut=
ils)?
>> >>>>> >> >>
>> >>>>> >> >
>> >>>>> >> > This seems like a really nasty kludge. It doesn't seem li=
ke the
>> >>>>> >> > implications of this have been carefully considered.
>> >>>>> >> >
>> >>>>> >> > What happens I mount with the "backup" flag and do not ha=
ve the
>> >>>>> >> > necessary permissions on the server to use the flag in an=
 open? Will
>> >>>>> >> > this new flag be mutually exclusive with "multiuser"?
>> >>>>> >> >
>> >>>>> >> > One idea that might be better is to come up with way to m=
ark certain
>> >>>>> >> > (unix) users with the appropriate flag. If all the backup=
 users were in
>> >>>>> >> > a certan group, for instance, then you could use that inf=
o to decide
>> >>>>> >> > whether to set the flag in the open calls.
>> >>>>> >> >
>> >>>>> >> > --
>> >>>>> >> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> >>>>> >> >
>> >>>>> >>
>> >>>>> >> Jeff, one comment, it is not the (unix) user that matters, =
it is the
>> >>>>> >> user on the server (authenticated) user at the server becau=
se the
>> >>>>> >> user right to access a file in backup mode can be granted o=
nly
>> >>>>> >> to a user at the server.
>> >>>>> >>
>> >>>>> >
>> >>>>> > Right, I realize that.
>> >>>>> >
>> >>>>> >> I think care should be taken to make sure that backup and
>> >>>>> >> multiuser are mutually exclusive mount options in mount.cif=
s.
>> >>>>> >>
>> >>>>> >
>> >>>>> > My objection here is more fundamental...
>> >>>>> >
>> >>>>> > This patchset lends itself to a single, specific use. You ca=
n create a
>> >>>>> > mount that you want to use for backups. Typically, when runn=
ing backups
>> >>>>> > like this you also intend for this mount to be used by only =
one (unix)
>> >>>>> > user.
>> >>>>> >
>> >>>>> > Adding a "backup" option is tantamount to adding extra privi=
leges to
>> >>>>> > this mount for anyone who accesses it. However, it's not cle=
ar to me
>> >>>>> > how these extra privileges will be secured from other users =
that don't
>> >>>>> > necessarily need them.
>> >>>>> >
>> >>>>> > It seems to me that it would be far more useful to find a wa=
y to only
>> >>>>> > add these extra "backup" permissions for certain unix users =
that are
>> >>>>> > accessing the mount.
>> >>>>> >
>> >>>>> > Does that make sense?
>> >>>>> >
>> >>>>> > --
>> >>>>> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> >>>>> >
>> >>>>>
>> >>>>> Jeff, definitely. Thanks. =A0I think one way might be to speci=
fy an
>> >>>>> user or uid and restrict the usage of that mount to that user =
id?
>> >>>>> So you can specify mount option as =A0either backup=3Duserxyz
>> >>>>> or backup=3D1001 perhaps?
>> >>>>>
>> >>>>
>> >>>> Sure, that might be reasonable.
>> >>>>
>> >>>> Since backup privileges are tied to a group on the server, we c=
ould
>> >>>> also mirror that semantic on the client. Have a backup=3D<gid> =
and turn
>> >>>> on the backup flag for any unix user who is in that group. That=
 would
>> >>>> seem to allow for better integration with things like nss_winbi=
nd.
>> >>>
>> >>> That seems like a good idea - although I prefer that it allow
>> >>> uid and/or gid to be specified for easier usability
>> >>>
>> >>>
>> >>>
>> >>> --
>> >>> Thanks,
>> >>>
>> >>> Steve
>> >>>
>> >>
>> >> Steve, how would we be able to distinguish between uids and gids?
>> >> The same id e.g 1001, could be either an uid or a gid!
>> >> The same applies to a name, it could be a group as well as
>> >> an user name.
>> > One option - allow them to distinguished via different mount optio=
n:
>> >
>> > presumably "backupuid=3D" =A0 =A0and "backupgid=3D" =A0 =A0If we c=
hoose to retain
>> > "backup" as a mount option as well - then when neither backupuid n=
or
>> > backupgid is specified then the uid of the process mounting would =
be
>> > used as "backupuid" with no backupgid implied by default.
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>> >
>>
>> Not sure if there is a way to check in kernel whether a user/uid is
>> part of a certain group/gid!
>> If not, I think the options are to do so by perhaps making a upcall
>> or verify whether the specified group/gid is the primary group of
>> the user/uid accessing the file (in the backup intent mode) on
>> the server.
>> My preference is for the second option and we can clarify this in th=
e
>> man page stanza of this mount option (backupgid).
>>
>
> There most certainly is a way to check this in the kernel. It has to =
do
> this all the time to check permissions. See in_group_p().
>
> You don't want to check whether the current uid is in a particular
> group, but rather whether the current task credential is. Otherwise
> that code won't work if someone runs this under newgrp and the group =
is
> password protected.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

So a check should be whether the gid specified with the
mount option backupgid is either same as egid of the task
or one of the gids of the supplementary groups to which
euid of the task belongs to!

Not sure how the acquired egid using newgroup api/command
and password protection comes into the picture in this context.

Regards,

Shirish
