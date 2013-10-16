From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cp --reflink and BTRFS_IOC_CLONE
Date: Wed, 16 Oct 2013 15:02:11 -0500
Message-ID: <CAH2r5muAM_E6e_Z1M+-Z_0Lqee6ZY9g=Lhf1gdRU=P++6UkHiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Do any other file systems other than btrfs support "cp --reflink" (ie
BTRFS_IOC_CLONE).   I am cleaning the patches to cifs.ko to do this at
least for SMB2/SMB2.1/SMB3, but I thought that at the kernel file
system summit somebody mentioned other in kernel file systems that
support the copy offload ioctl that cp --reflink invokes (ie
BTRFS_IOC_CLONE).,

-- 
Thanks,

Steve
