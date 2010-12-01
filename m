From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove Local_System_Name
Date: Wed, 1 Dec 2010 08:39:09 -0600
Message-ID: <AANLkTik1BazmLP0r2VsGqK4P2yjASVdASmwCtPSHAhaR@mail.gmail.com>
References: <1290457863-10804-1-git-send-email-jlayton@redhat.com>
	<1290457863-10804-3-git-send-email-jlayton@redhat.com>
	<AANLkTinNLbq1c57TvejaR8hvBxJTD62T6kP1hLOpGegX@mail.gmail.com>
	<20101201092731.7aeded31@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101201092731.7aeded31-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 1, 2010 at 8:27 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 1 Dec 2010 08:10:03 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Nov 22, 2010 at 2:31 PM, Jeff Layton <jlayton-vpEMnDpepFvY2uhgrK1nQg@public.gmane.org=
t> wrote:
>> > ...this string is zeroed out and nothing ever changes it.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/cifsfs.c =A0 | =A0 =A01 -
>> > =A0fs/cifs/cifsglob.h | =A0 =A02 --
>> > =A0fs/cifs/connect.c =A0| =A0 23 ++++++++++-------------
>> > =A03 files changed, 10 insertions(+), 16 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> > index 041d7c3..57a7386 100644
>> > --- a/fs/cifs/cifsfs.c
>> > +++ b/fs/cifs/cifsfs.c
>> > @@ -931,7 +931,6 @@ init_cifs(void)
>> > =A0 =A0 =A0 =A0GlobalCurrentXid =3D 0;
>> > =A0 =A0 =A0 =A0GlobalTotalActiveXid =3D 0;
>> > =A0 =A0 =A0 =A0GlobalMaxActiveXid =3D 0;
>> > - =A0 =A0 =A0 memset(Local_System_Name, 0, 15);
>> > =A0 =A0 =A0 =A0spin_lock_init(&cifs_tcp_ses_lock);
>> > =A0 =A0 =A0 =A0spin_lock_init(&cifs_file_list_lock);
>> > =A0 =A0 =A0 =A0spin_lock_init(&GlobalMid_Lock);
>> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> > index b4c2524..2ffa029 100644
>> > --- a/fs/cifs/cifsglob.h
>> > +++ b/fs/cifs/cifsglob.h
>> > @@ -743,8 +743,6 @@ GLOBAL_EXTERN unsigned int GlobalTotalActiveXi=
d; /* prot by GlobalMid_Sem */
>> > =A0GLOBAL_EXTERN unsigned int GlobalMaxActiveXid; /* prot by Globa=
lMid_Sem */
>> > =A0GLOBAL_EXTERN spinlock_t GlobalMid_Lock; =A0/* protects above &=
 list operations */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0/* on midQ entries */
>> > -GLOBAL_EXTERN char Local_System_Name[15];
>> > -
>> > =A0/*
>> > =A0* =A0Global counters, updated atomically
>> > =A0*/
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index 251a17c..7758120 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -806,23 +806,20 @@ cifs_parse_mount_options(char *options, cons=
t char *devname,
>> > =A0 =A0 =A0 =A0short int override_gid =3D -1;
>> > =A0 =A0 =A0 =A0bool uid_specified =3D false;
>> > =A0 =A0 =A0 =A0bool gid_specified =3D false;
>> > + =A0 =A0 =A0 char *nodename =3D utsname()->nodename;
>> >
>> > =A0 =A0 =A0 =A0separator[0] =3D ',';
>> > =A0 =A0 =A0 =A0separator[1] =3D 0;
>> >
>> > - =A0 =A0 =A0 if (Local_System_Name[0] !=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(vol->source_rfc1001_name, Loc=
al_System_Name, 15);
>> > - =A0 =A0 =A0 else {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *nodename =3D utsname()->nodena=
me;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int n =3D strnlen(nodename, 15);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(vol->source_rfc1001_name, 0x2=
0, 15);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < n; i++) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* does not have to =
be perfect mapping since field is
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 informational, only =
used for servers that do not support
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port 445 and it can =
be overridden at mount time */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->source_rfc1001_=
name[i] =3D toupper(nodename[i]);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > - =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0* does not have to be perfect mapping since field=
 is
>> > + =A0 =A0 =A0 =A0* informational, only used for servers that do no=
t support
>> > + =A0 =A0 =A0 =A0* port 445 and it can be overridden at mount time
>> > + =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 memset(vol->source_rfc1001_name, 0x20, 15);
>> > + =A0 =A0 =A0 for (i =3D 0; i < strnlen(nodename, 15); i++)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->source_rfc1001_name[i] =3D toup=
per(nodename[i]);
>> > +
>> > =A0 =A0 =A0 =A0vol->source_rfc1001_name[15] =3D 0;
>> > =A0 =A0 =A0 =A0/* null target name indicates to use *SMBSERVR defa=
ult called name
>> > =A0 =A0 =A0 =A0 =A0 if we end up sending RFC1001 session initializ=
e */
>> > --
>> > 1.7.3.2
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>> We probably should define 15 or add an explanation for 15.
>
> Good point. I guess that should probably be RFC1001_NAME_LEN ? There
> are a number of other places that use hardcoded "15" or "16" values
> around this as well. Any objection to me fixing that in a separate
> cleanup patch?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

RFC1001_NAME_LEN  sounds apt.
No objection.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
