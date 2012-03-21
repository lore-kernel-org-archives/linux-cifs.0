From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 21 Mar 2012 15:33:57 -0500
Message-ID: <CAH2r5mt6NiZmF1JZPG2sZ7bwNFiWpxxQ9Q6OoJXC_st7+oUoZg@mail.gmail.com>
References: <1331307197.10670.2.camel@localhost>
	<20120321133855.52901c60@redhat.com>
	<1332354787.2818.7.camel@localhost>
	<20120321163051.0fa2c714@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120321163051.0fa2c714-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sachin,
I am a little worried about merge conflicts - am about 1/3 of the way
through merging (and reviewing) Pavel's and similarly have started to
merge Jeff's patches, so make sure you rebase them on what is in
cifs-2.6.git tree on samba.org

On Wed, Mar 21, 2012 at 3:30 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 21 Mar 2012 18:33:07 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Wed, 2012-03-21 at 13:38 -0400, Jeff Layton wrote:
>> > On Fri, 09 Mar 2012 15:33:17 +0000
>> > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> > > Use the standard token parser instead of the long if confidtion =
to parse
>> > > cifs mount options.
>> > >
>> > > This was first proposed by Scott Lovenberg
>> > > http://lists.samba.org/archive/linux-cifs-client/2010-May/006079=
=2Ehtml
>> > >
>> > > Mount options have been grouped together in terms of their input=
 types.
>> > > Aliases for username, password, domain and credentials have been=
 added.
>> > > The password parser has been modified to make it easier to read.
>> > >
>> > > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > >
>> >
>> >
>> > In testing this today, I found a problem. I tried to mount up a sh=
are
>> > with sec=3Dnone as the options. With that, I got this error:
>> >
>> > =A0 =A0 CIFS: Unknown mount option pass=3D
>> >
>> > The problem is that the mount.cifs helper will pass a blank "pass=3D=
"
>> > option to the kernel. It seems like the standard option parser doe=
sn't
>> > have a way to allow you to specify an optional argument. That may =
need
>> > to be added in order for this to work.
>>
>>
>> We could use it in this manner.
>>
>> ----
>> Allow mount option pass to be a blank value.
>>
>> When using sec=3Dnone, the mount.cifs helper will pass a blank 'pass=
=3D'
>> mount option. This should be handled by the parser.
>>
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0 =A07 +++++++
>> =A01 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 8f83ea0..831f242 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -107,6 +107,9 @@ enum {
>> =A0 =A0 =A0 /* Mount options to be ignored */
>> =A0 =A0 =A0 Opt_ignore,
>>
>> + =A0 =A0 /* Options which could be blank */
>> + =A0 =A0 Opt_blank_pass,
>> +
>> =A0 =A0 =A0 Opt_err
>> =A0};
>>
>> @@ -180,6 +183,7 @@ static const match_table_t cifs_mount_option_tok=
ens =3D {
>>
>> =A0 =A0 =A0 { Opt_user, "user=3D%s" },
>> =A0 =A0 =A0 { Opt_user, "username=3D%s" },
>> + =A0 =A0 { Opt_blank_pass, "pass=3D" },
>> =A0 =A0 =A0 { Opt_pass, "pass=3D%s" },
>> =A0 =A0 =A0 { Opt_pass, "password=3D%s" },
>> =A0 =A0 =A0 { Opt_ip, "ip=3D%s" },
>> @@ -1546,6 +1550,9 @@ cifs_parse_mount_options(const char *mountdata=
, const char *devname,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->nullauth =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 case Opt_blank_pass:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->password =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case Opt_pass:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* passwords have to be =
handled differently
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to allow the charac=
ter used for deliminator
>
> ACK.
>
> Since Steve hasn't committed this yet, care to send a respin of the
> original? I don't think there are any others that require the ability
> to handle a blank option, but we can always add that later if needed.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
