From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Parsing for obsolete mount options
Date: Mon, 28 Feb 2011 12:56:35 -0600
Message-ID: <AANLkTi=VALjkGRSh-1KPj1Sg=33uBi1eGKWDuFkvMqHu@mail.gmail.com>
References: <AANLkTikpA7=G=5y075-jWfMUfKDj=w6URfi_hyYVnbp2@mail.gmail.com>
	<20110228134506.71e840b1@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110228134506.71e840b1-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 28, 2011 at 12:45 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Sat, 26 Feb 2011 12:08:23 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I was trying to figure out a way to parse for mount options which ar=
e
>> obsolete for smb2 (but valid for cifs), but without an "-t smb2" fs
>> type it is harder. =A0 =A0Jeff had preferred (rather than a "-t smb2=
" file
>> type) that we call smb2 a "version" of cifs, and by analogy with nfs
>> ("nfsvers=3D2", =A0"nfsvers=3D4" etc.) specify a "vers=3Dsmb2" or "v=
ers=3D2" to
>> indicate mounting with experimental smb2 is desired ... but to be ab=
le
>> to parse mount options which are now obsolete (for smb2) we have to
>> scan the whole mount option string, looking for "vers=3D2" (or
>> equivalent) first, then either call a (new) smb2_parse_mount_options
>> function, or flag them in the current cifs_parse_mount_options when =
we
>> detect a "vers=3D2" =A0- by the time we get out of
>> cifs_parse_mount_options it is too late because we don't know which
>> mount options the user specified explicitly (and which we got from
>> defaults).
>>
>> As a summary of some of the mount differences:
>> 1) sec=3Dntlm (and sec=3Dlanman) is no longer going to be valid (ntl=
mv2
>> and krb5 only)
>> 2) noblocksend and noautotune probably no longer needed
>> 3) posixpaths/noposixpaths no longer needed
>> 4) noserverino not valid
>> 5) sockopt may not be needed (nodelay can be defaulted)
>>
>
> Probably, the best thing is to do this in 2 phases:
>
> 1) parse the mount options to the best of your ability
>
> 2) check the result and see whether they make sense
>
> Autonegotiation will make the second part interesting though since yo=
u
> might not know the version until later. In that case, you probably wi=
ll
> just have to ignore options that don't have any effect on the version
> negotiated.

I may have to add a new bool (or int sec_flags_requested) in the vol
structure for at least one requested security option, in particular
for "ntlm" requested (since ntlm is the default, we want to
distinguish "use the default security mechanism" from specifying
"sec=3Dntlm" ie "give me ntlm" (which will only allow for cifs) which w=
e
want to fail)



--=20
Thanks,

Steve
