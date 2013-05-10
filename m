From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Mount failure due to restricted access to a point along the mount path
Date: Fri, 10 May 2013 16:13:30 +0200
Message-ID: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench@gmail.com>,
	Jeff Layton <jlayton@redhat.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	sjayaraman@novell.com
To: linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi,

A while ago this was discussed:

  http://thread.gmane.org/gmane.linux.kernel.cifs/7779

This is essentially a regression introduced by the shared superblock
changes in 3.0 and several SUSE customers are complaining about it.
I've created a temporary fix which reverts 29 commits related to the
shared superblock changes.  It works, but it's obviously not a
permanent fix, especially since we definitely don't want to diverge
from mainline.

Is this issue being worked on?  Don't other distros have similar reports?

Thanks,
Miklos
