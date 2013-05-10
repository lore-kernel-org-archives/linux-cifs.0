From: Jeff Layton <jlayton@redhat.com>
Subject: Re: Mount failure due to restricted access to a point along the
 mount path
Date: Fri, 10 May 2013 10:27:54 -0400
Message-ID: <20130510102754.184cd90d@corrin.poochiereds.net>
References: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	sjayaraman@novell.com
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 10 May 2013 16:13:30 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Hi,
> 
> A while ago this was discussed:
> 
>   http://thread.gmane.org/gmane.linux.kernel.cifs/7779
> 
> This is essentially a regression introduced by the shared superblock
> changes in 3.0 and several SUSE customers are complaining about it.
> I've created a temporary fix which reverts 29 commits related to the
> shared superblock changes.  It works, but it's obviously not a
> permanent fix, especially since we definitely don't want to diverge
> from mainline.
> 
> Is this issue being worked on?  Don't other distros have similar reports?
> 
> Thanks,
> Miklos

I don't know of anyone currently working on it. There are a couple of
possible approaches to fixing it, I think:

1) if the dentries to get down to the root of the mount don't already
exist, then attach some sort of "placeholder" inode that can be fleshed
out later if and when the dentry is accessed via other means.

2) do something like what NFS does (see commit 54ceac45). This becomes
a bit more complicated due to the fact that the server may not hand out
real inode numbers and we sometimes have to fake them up.

#1 is probably simpler to implement, but I'll confess that I haven't
thought through all of the potential problems with it.

-- 
Jeff Layton <jlayton@redhat.com>
