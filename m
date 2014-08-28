From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] generic/013: encapsulate remount during cleanup
Date: Thu, 28 Aug 2014 10:08:49 -0700
Message-ID: <20140828170849.GA20891@infradead.org>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
 <1409084918-17764-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1409084918-17764-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 27, 2014 at 12:28:36AM +0400, Pavel Shilovsky wrote:
> The existing code calls remount for $TEST_DEV with constantly defined
> mount options. This can fail if a user specifies different mount options.
> Fix this by using new _test_remount() call that remounts $TEST_DEV.

Looks technically correct, but I still wonder why it's needed at all,
I can't see anything in the test that would remount the filesystem
read-only.  git history isn't a help here as the remount goes back to
the first public revision.
