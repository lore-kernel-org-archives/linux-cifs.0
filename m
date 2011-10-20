From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Wed, 19 Oct 2011 21:14:37 -0500
Message-ID: <CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111013132755.6c5db87e-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 13, 2011 at 12:27 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Wed, 28 Sep 2011 00:28:10 +0300
> Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
>> This solves a problem for where a user without write permissions
>> was creating empty files. =A0This function was supposed to do a look=
up
>> only, the create happens later.
>>
>
> Not quite. This uses the open-intent goop in the VFS layer that Al Vi=
ro
> is trying to get rid of. The idea here is that doing a lookup just to
> do an open is a waste, when you could just attempt the open. There's =
no
> real reason to exempt creates from that if cifs used a sane permissio=
ns
> model...
>
>> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index 72d448b..8515afe 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -566,11 +566,13 @@ cifs_lookup(struct inode *parent_dir_inode, st=
ruct dentry *direntry,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nd && !(nd->flags & LOOKUP_DIRECTORY=
) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(nd->flags & LOOKUP_OPEN) && =
!pTcon->broken_posix_open &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(nd->intent.open.file->f_flag=
s & O_CREAT)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int f_flags;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 f_flags =3D (nd->intent.op=
en.file->f_flags & ~O_CREAT);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_posix_open(f=
ull_path, &newInode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 parent_dir_inode->i_sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 nd->intent.open.create_mode,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 nd->intent.open.file->f_flags, &oplock,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &fileHandle, xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 f_flags, &oplock, &fileHandle, xid);
>
> =A0 =A0 =A0 =A0...so this makes it only do the open at lookup time if=
 the
> =A0 =A0 =A0 =A0file already exists.
>
> =A0 =A0 =A0 =A0I suspect the real problem here is that cifs is trying=
 to
> =A0 =A0 =A0 =A0enforce permissions on the client, which happens after=
 the
> =A0 =A0 =A0 =A0lookup.
>
> =A0 =A0 =A0 =A0If the client simply allowed the server to handle the
> =A0 =A0 =A0 =A0permissions (and used the right credentials for each u=
ser),

Doesn't this force the create to happen later - rather than
at lookup time where it belongs?

if the issue is just noperm ... we should let this through if the user
has local permissions.  Doubling the cost of a file create to Samba
seems like a bad idea (ie doing aQueryPathInfo AND an NTCreateX
doubles the roundrip, doubles the load on the server etc.) - the whole
point of this is to let us do an "atomic" open or create operation
and not have to split it into multiple requests.  In any case why would
we do the open and then follow it with a create?

Can we fix this to (at least) narrow the performance penalty.


--=20
Thanks,

Steve
