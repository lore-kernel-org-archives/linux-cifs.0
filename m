From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 10/15] cifs: convert GlobalSMBSeslock from a rwlock to
 regular spinlock
Date: Tue, 12 Oct 2010 09:28:27 -0400
Message-ID: <20101012132827.GB2567@infradead.org>
References: <1286559072-29032-1-git-send-email-jlayton@redhat.com>
 <1286559072-29032-11-git-send-email-jlayton@redhat.com>
 <4CB2A478.50401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CB2A478.50401-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Suresh, any chance you could only quote short, relevant portions
of the patch?  Your full quotes are almost unreadable.
