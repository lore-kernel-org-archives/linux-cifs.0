From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS related seg fault (v2.6.37)
Date: Wed, 19 Jan 2011 22:55:54 -0600
Message-ID: <AANLkTin7jRk6S2XWcRineCtazQb3rgYsBPakV513Ph9n@mail.gmail.com>
References: <AANLkTikp0=w7k+PsUCQVQwxnZMLsp3F7a3rEDQAas20G@mail.gmail.com>
	<4D37BDE4.1000104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Teoh <htmldeveloper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D37BDE4.1000104-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 19, 2011 at 10:45 PM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>=
 wrote:
> (Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>
> On 01/20/2011 07:05 AM, Peter Teoh wrote:
>> Filed a bug today:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D27082
>>
>> Version of kernel (linus git tree synced): =A0 v2.6.37-3737-g0c21e3a
>>
>> Output of dmesg summarized here:
>>
>> [ 7273.369563] ------------[ cut here ]------------
>> [ 7273.369575] kernel BUG at fs/dcache.c:1358!
>
> Looks like the issue is already fixed in VFS (see discussion):
> =A0 =A0 =A0 =A0http://thread.gmane.org/gmane.linux.kernel.cifs/2284
>
> Jeff: Looks like the issue is reproducible with 2.6.37 too.. Any idea
> which is the commit that fixes this problem and whether it has been
> marked for -stable?

So Jeff's change referenced (to fs/cifs/dir.c) above is not needed due
to a vfs change?



--=20
Thanks,

Steve
