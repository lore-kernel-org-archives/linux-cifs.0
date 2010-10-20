From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Strange hardlink behavior with CIFS
Date: Wed, 20 Oct 2010 10:01:01 -0500
Message-ID: <AANLkTim4WXheVcOhMehZpS058PbrukE9Z=DDiTpaC1G3@mail.gmail.com>
References: <1287428685.16450.282.camel@calx>
	<4CBD6843.3060702@suse.de>
	<loom.20101020T111137-239@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bjoern <bjoern-6mE/F8KvGsCzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20101020T111137-239-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 20, 2010 at 4:18 AM, bjoern <bjoern-6mE/F8KvGsCzQB+pC5nmwQ@public.gmane.org> wrote:
>
> > A quick test on 2.6.36-rc4 kernel reveals that the problem is no longer
> > reproducible. Could you try a more recent kernel and see whether the
> > problem is reproducible?
>
> I had this problem on 2.6.32.
> I just gave 2.6.36-rc4 a spin and I can't reproduce this issue anymore with the
> new kernel. So, all-clear at least from my side.

It may have been one of these changes:

commit 4065c802da7484fa36f8cdf10f18d087233ecb88
Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon May 17 07:18:58 2010 -0400

    cifs: fix noserverino handling when unix extensions are enabled

    The uniqueid field sent by the server when unix extensions are enabled
    is currently used sometimes when it shouldn't be. The readdir codepath
    is correct, but most others are not. Fix it.

commit 84f30c66c3689745abbd3b9ce39816caeb9bec3b
Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon May 17 07:18:57 2010 -0400

    cifs: don't update uniqueid in cifs_fattr_to_inode

    We use this value to find an inode within the hash bucket, so we can't
    change this without re-hashing the inode. For now, treat this value
    as immutable.

    Eventually, we should probably use an inode number change on a path
    based operation to indicate that the lookup cache is invalid, but that's
    a bit more code to deal with.


commit db19272edc93661835bf6ec9736cfd0754aa3c62
Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon May 17 14:51:49 2010 -0400

    cifs: always revalidate hardlinked inodes when using noserverino


--
Thanks,

Steve
