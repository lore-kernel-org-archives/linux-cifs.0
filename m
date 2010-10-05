From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/15] cifs: fix cifs_show_options to show "username=" or "multiuser"
Date: Tue, 5 Oct 2010 17:01:18 -0500
Message-ID: <AANLkTimkxBpNLN+pAXaKsXf5dPy19LFeszjadCyjCeGH@mail.gmail.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-12-git-send-email-jlayton@redhat.com>
	<AANLkTikafmJ14vib9-0SPZ6AaTmjpeps7VGzd5SSgoni@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikafmJ14vib9-0SPZ6AaTmjpeps7VGzd5SSgoni-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In reviewing this patch which changes the show_options on cifs mounts
to not display the network username (when multiuser mount flag is
turned on) ie not display the username sent on SMB SessionSetup.

1) Would there be value in showing the network (cifs) username that is
associated with the uid (fsuid) of this process?  (Presumably the
username we send in cifs sessionsetup could be slightly different than
the local username for this unix uid).

2) In the future can't the domain name differ as well (so should we
special case the domain name - or perhaps showing the default domain
is fine?)

On Tue, Oct 5, 2010 at 4:59 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> In reviewing this patch which changes the show_options on cifs mounts=
 to not
> display the network username (when multiuser mount flag is turned on)=
 ie not
> display the username sent on SMB SessionSetup.
>
> 1) Would there be value in showing the network (cifs) username that i=
s
> associated with the uid (fsuid) of this process?=A0 (Presumably the u=
sername
> we send in cifs sessionsetup could be slightly different than the loc=
al
> username for this unix uid).
>
> 2) In the future can't the domain name differ as well (so should we s=
pecial
> case the domain name - or perhaps showing the default domain is fine?=
)
>
> On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>>
>> ...based on CIFS_MOUNT_MULTIUSER flag.
>>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 =A06 +++++-
>> =A01 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 2b897e3..51090cec 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -371,8 +371,12 @@ cifs_show_options(struct seq_file *s, struct vf=
smount
>> *m)
>> =A0 =A0 =A0 =A0srcaddr =3D (struct sockaddr *)&tcon->ses->server->sr=
caddr;
>>
>> =A0 =A0 =A0 =A0seq_printf(s, ",unc=3D%s", tcon->treeName);
>> - =A0 =A0 =A0 if (tcon->ses->userName)
>> +
>> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",multiuser");
>> + =A0 =A0 =A0 else if (tcon->ses->userName)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",username=3D%s", tcon-=
>ses->userName);
>> +
>> =A0 =A0 =A0 =A0if (tcon->ses->domainName)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",domain=3D%s", tcon->s=
es->domainName);
>>
>> --
>> 1.7.2.3
>>
>
>
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve
