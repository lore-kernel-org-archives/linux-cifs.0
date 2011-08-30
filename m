From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount option named backup
Date: Tue, 30 Aug 2011 12:32:21 -0500
Message-ID: <CADT32eLZW1ihDk_6JTU8Y7Vy5onc6qfJCfChOa=9ZwLd34ubTg@mail.gmail.com>
References: <1313166821-9172-1-git-send-email-shirishpargonkar@gmail.com>
	<CADT32eJsAgNkhnY1VZ6wpxa2013h7TmO6i3H=4a6D8ke8iU2Aw@mail.gmail.com>
	<20110823091510.2d8b8027@corrin.poochiereds.net>
	<CADT32eJPyKhkTx6vbsS4hRnaqAQAs0aTime_pz-NRvowotVyqg@mail.gmail.com>
	<20110829202910.0038ca06@corrin.poochiereds.net>
	<CADT32e+XQ7ar7y_MADUwwEi081Q_-QDeY79ga9ykOxVyp=yb8g@mail.gmail.com>
	<20110830105201.1aff3900@tlielax.poochiereds.net>
	<CAH2r5mt4U1pqGiD4ELQnM_Xgies38-dhZj_XtXi1TFWbE-260A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt4U1pqGiD4ELQnM_Xgies38-dhZj_XtXi1TFWbE-260A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 30, 2011 at 12:09 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> On Tue, Aug 30, 2011 at 9:52 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
>> On Tue, 30 Aug 2011 09:03:05 -0500
>> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> On Mon, Aug 29, 2011 at 7:29 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
>>> > On Mon, 29 Aug 2011 16:24:33 -0500
>>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> >
>>> >> On Tue, Aug 23, 2011 at 8:15 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>=
 wrote:
>>> >> > On Mon, 22 Aug 2011 08:33:49 -0500
>>> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> >> >
>>> >> >> On Fri, Aug 12, 2011 at 11:33 AM, =A0<shirishpargaonkar@gmail=
=2Ecom> wrote:
>>> >> >> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> >> >> >
>>> >> >> >
>>> >> >> > Add mount option backup.
>>> >> >> >
>>> >> >> > It allows an authenticated user to access files with the in=
tent to back them
>>> >> >> > up including their ACLs, who may not have access permission=
 but has
>>> >> >> > "Backup files and directories user right" on them (by virtu=
e of being part
>>> >> >> > of the built-in group Backup Operators.
>>> >> >> >
>>> >> >> > If an authenticated user is not part of the built-in group =
Backup Operators
>>> >> >> > at the server, access to such files is denied.
>>> >> >> >
>>> >> >> >
>>> >> >> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.=
com>
>>> >> >> > ---
>>> >> >>
>>> >> >>
>>> >> >> Jeff, =A0Steve,
>>> >> >>
>>> >> >> Any comments on this patch (and manpage patch in cifs-utils)?
>>> >> >>
>>> >> >
>>> >> > This seems like a really nasty kludge. It doesn't seem like th=
e
>>> >> > implications of this have been carefully considered.
>>> >> >
>>> >> > What happens I mount with the "backup" flag and do not have th=
e
>>> >> > necessary permissions on the server to use the flag in an open=
? Will
>>> >> > this new flag be mutually exclusive with "multiuser"?
>>> >> >
>>> >> > One idea that might be better is to come up with way to mark c=
ertain
>>> >> > (unix) users with the appropriate flag. If all the backup user=
s were in
>>> >> > a certan group, for instance, then you could use that info to =
decide
>>> >> > whether to set the flag in the open calls.
>>> >> >
>>> >> > --
>>> >> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> >> >
>>> >>
>>> >> Jeff, one comment, it is not the (unix) user that matters, it is=
 the
>>> >> user on the server (authenticated) user at the server because th=
e
>>> >> user right to access a file in backup mode can be granted only
>>> >> to a user at the server.
>>> >>
>>> >
>>> > Right, I realize that.
>>> >
>>> >> I think care should be taken to make sure that backup and
>>> >> multiuser are mutually exclusive mount options in mount.cifs.
>>> >>
>>> >
>>> > My objection here is more fundamental...
>>> >
>>> > This patchset lends itself to a single, specific use. You can cre=
ate a
>>> > mount that you want to use for backups. Typically, when running b=
ackups
>>> > like this you also intend for this mount to be used by only one (=
unix)
>>> > user.
>>> >
>>> > Adding a "backup" option is tantamount to adding extra privileges=
 to
>>> > this mount for anyone who accesses it. However, it's not clear to=
 me
>>> > how these extra privileges will be secured from other users that =
don't
>>> > necessarily need them.
>>> >
>>> > It seems to me that it would be far more useful to find a way to =
only
>>> > add these extra "backup" permissions for certain unix users that =
are
>>> > accessing the mount.
>>> >
>>> > Does that make sense?
>>> >
>>> > --
>>> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> >
>>>
>>> Jeff, definitely. Thanks. =A0I think one way might be to specify an
>>> user or uid and restrict the usage of that mount to that user id?
>>> So you can specify mount option as =A0either backup=3Duserxyz
>>> or backup=3D1001 perhaps?
>>>
>>
>> Sure, that might be reasonable.
>>
>> Since backup privileges are tied to a group on the server, we could
>> also mirror that semantic on the client. Have a backup=3D<gid> and t=
urn
>> on the backup flag for any unix user who is in that group. That woul=
d
>> seem to allow for better integration with things like nss_winbind.
>
> That seems like a good idea - although I prefer that it allow
> uid and/or gid to be specified for easier usability
>
>
>
> --
> Thanks,
>
> Steve
>

Steve, how would we be able to distinguish between uids and gids?
The same id e.g 1001, could be either an uid or a gid!
The same applies to a name, it could be a group as well as
an user name.

Regards,

Shirish
