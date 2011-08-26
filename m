From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs with "prefixpath" option getting NT_STATUS_ACCESS_DENIED
Date: Fri, 26 Aug 2011 10:53:25 +0400
Message-ID: <CAKywueQu=eDOmQFW=AV=T4XJVdUyuriSwPYuLmh64sH4bHP1hA@mail.gmail.com>
References: <CAD4ZOMwcYFut0o8Krw-Z+tiGwz9VNvy4jRvwMcXv42P60pJxbg@mail.gmail.com>
	<CAKywueRh-c3JoqdGSg4iTSX+KvCbwVpS4GUwprFOkpQwaF4=3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rafael Ganascim <rganascim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRh-c3JoqdGSg4iTSX+KvCbwVpS4GUwprFOkpQwaF4=3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/26 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2011/8/22 Rafael Ganascim <rganascim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Hi,
>>
>> I think that this problem is related to:
>>
>> http://article.gmane.org/gmane.linux.kernel.cifs/3878
>>
>>
>> I have this fileserver structure:
>> =A0- complete path: //fileserver-la-01/ti$/geral/
>> =A0- //fileserver-la-01/ti$: in this parent dir, my user don't have
>> permission to access
>>
>>
>> Using the kernel version 2.6.38 the mount reports:
>>
>> # mount -v /mnt/xxxx/latigeral/
>> parsing options: rw,credentials=3D/etc/credentials,uid=3D1000
>>
>> mount.cifs kernel mount options
>> unc=3D//fileserver-la-01\ti$,user=3Dxxxxxx,pass=3Dxxxxx,ver=3D1,rw,c=
redentials=3D/etc/credentials,uid=3D1000,prefixpath=3Dgeral/
>> #
>>
>>
>> Using the kernel 3.0.2:
>>
>> # mount -v /mnt/xxxx/latigeral
>> parsing options: rw,credentials=3D/etc/credentials,uid=3D1000
>>
>> mount.cifs kernel mount options
>> unc=3D//fileserver-la-01\ti$,user=3Dxxxxxx,pass=3Dxxxxx,ver=3D1,rw,c=
redentials=3D/etc/credentials,uid=3D1000,prefixpath=3Dgeral/
>> mount error(13): Permission denied
>> Refer to the mount.cifs(8) manual page (e.g.man mount.cifs)
>> #
>>
>> The cifsFYI messages are in the attachments, cifsFYI.txt.
>>
>> To workaround this problem (in my box), I had set the 'full_path'
>> (from prefixpath) in the call to cifs_get_inode_info in the function
>> cifs_root_iget (~ inode.c:888), if the prefixpath isn't null. This
>> worked for me, but it's bad solution, I think (i'm not a programmer =
:(
>> ).
>>
>> What do you think about this problem? There are a 'good' solution fo=
r it?
>>
>>
>> Thanks,
>> --
>>
>> Rafael Ganascim
>>
>
> Hi!
>
> I posted the patch "CIFS: Fix NT_STATUS_ACCESS for moutn with
> prefixpath option" to the list - that should help.
>
> Jeff, Al, can you comment on this, please?
>
> --
> Best regards,
> Pavel Shilovsky.
>

Sorry - wrong title. resend as "CIFS: Fix NT_STATUS_ACCESS_DENIED for
mounts with prefixpath option" patch.

--=20
Best regards,
Pavel Shilovsky.
