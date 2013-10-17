From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: cp --reflink and BTRFS_IOC_CLONE
Date: Thu, 17 Oct 2013 12:48:46 +0200
Message-ID: <20131017124846.498280e7@plati.site>
References: <CAH2r5muAM_E6e_Z1M+-Z_0Lqee6ZY9g=Lhf1gdRU=P++6UkHiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muAM_E6e_Z1M+-Z_0Lqee6ZY9g=Lhf1gdRU=P++6UkHiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Oct 2013 15:02:11 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Do any other file systems other than btrfs support "cp --reflink" (ie
> BTRFS_IOC_CLONE).   I am cleaning the patches to cifs.ko to do this at
> least for SMB2/SMB2.1/SMB3, but I thought that at the kernel file
> system summit somebody mentioned other in kernel file systems that
> support the copy offload ioctl that cp --reflink invokes (ie
> BTRFS_IOC_CLONE).,
> 

I think OCFS2 does via OCFS2_IOC_REFLINK.

Cheers, David
