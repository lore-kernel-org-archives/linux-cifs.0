From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: cope with negative dentries in cifs_get_root
Date: Fri, 5 Aug 2011 10:01:47 -0500
Message-ID: <CAH2r5mvB8jyZnnSaGCs1Z=NWMCh6LQBpwTR3hY1Fv9pxw54+Kw@mail.gmail.com>
References: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
	<20110805145428.GS2203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110805145428.GS2203-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 5, 2011 at 9:54 AM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote=
:
> On Fri, Aug 05, 2011 at 09:02:40AM -0400, Jeff Layton wrote:
>> The loop around lookup_one_len doesn't handle the case where it migh=
t
>> return a negative dentry, which can cause an oops on the next pass
>> through the loop. Check for that and break out of the loop with an
>> error of -ENOENT if there is one.
>
> Ouch. =A0Nice catch and that one is my damn fault. =A0Do you want tha=
t one
> to go through cifs or vfs tree? =A0ACK, in any case...

Probably safer to go through my tree, reduce chance of merge conflict
Was planning on sending a merge request up soon in any case.



--=20
Thanks,

Steve
