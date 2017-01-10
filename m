From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Document mfsymlinks in the mount.cifs man page
Date: Tue, 10 Jan 2017 14:16:47 -0600
Message-ID: <CAH2r5mtL_2iS54J2Jppo94dvdC8fwq8OUEs6DWZQvr36D=-K4g@mail.gmail.com>
References: <1483516099-24421-1-git-send-email-sprabhu@redhat.com> <1483534093.2826.0.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483534093.2826.0.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

thx.  Looks fine.

On Wed, Jan 4, 2017 at 6:48 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2017-01-04 at 13:18 +0530, Sachin Prabhu wrote:
>> Information from the cifs README in the kernel sources is used.
>>
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  mount.cifs.8 | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/mount.cifs.8 b/mount.cifs.8
>> index af6b097..01579f6 100644
>> --- a/mount.cifs.8
>> +++ b/mount.cifs.8
>> @@ -450,6 +450,11 @@ sfu
>>  When the CIFS Unix Extensions are not negotiated, attempt to create dev=
ice files and fifos in a format compatible with Services for Unix (SFU)\&. =
In addition retrieve bits 10\-12 of the mode via the SETFILEBITS extended a=
ttribute (as SFU does)\&. In the future the bottom 9 bits of the mode mode =
also will be emulated using queries of the security descriptor (ACL)\&. [NB=
: requires version 1\&.39 or later of the CIFS VFS\&. To recognize symlinks=
 and be able to create symlinks in an SFU interoperable form requires versi=
on 1\&.40 or later of the CIFS VFS kernel module\&.
>>  .RE
>>  .PP
>> +mfsymlinks
>> +.RS 4
>> +Enable support for Minshall+French symlinks(see http://wiki.samba.org/i=
ndex.php/UNIX_Extensions#Minshall.2BFrench_symlinks). This option is ignore=
d when specified together with the 'sfu' option. Minshall+French symlinks a=
re used even if the server supports the CIFS Unix Extensions.
>> +.RE
>> +.PP
>>  serverino
>>  .RS 4
>>  Use inode numbers (unique persistent file identifiers) returned by the =
server instead of automatically generating temporary inode numbers on the c=
lient\&. Although server inode numbers make it easier to spot hardlinked fi=
les (as they will have the same inode numbers) and inode numbers may be per=
sistent (which is userful for some sofware), the server does not guarantee =
that the inode numbers are unique if multiple server side mounts are export=
ed under a single share (since inode numbers on the servers might not be un=
ique if multiple filesystems are mounted under the same shared higher level=
 directory)\&. Note that not all servers support returning server inode num=
bers, although those that support the CIFS Unix Extensions, and Windows 200=
0 and later servers typically do support this (although not necessarily on =
every local server filesystem)\&. Parameter has no effect if the server lac=
ks support for returning inode numbers or equivalent\&. This behavior is en=
abled by default\!
>>  &.
>
> Looks good to me. I'll go ahead and merge unless anyone has objections
> in the next few days.
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
