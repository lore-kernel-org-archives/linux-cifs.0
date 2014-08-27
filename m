From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cifs: skip tests that need POSIX support for
 nounix mounts
Date: Wed, 27 Aug 2014 10:13:16 -0700
Message-ID: <20140827171316.GA6807@infradead.org>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
 <1409084918-17764-4-git-send-email-pshilovsky@samba.org>
 <20140827155832.GA3103@infradead.org>
 <CAH2r5mtOF3HgsDiuZSTfu62p8do35S6a9Sy74bVOAD9CXphVQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtOF3HgsDiuZSTfu62p8do35S6a9Sy74bVOAD9CXphVQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 27, 2014 at 11:17:25AM -0500, Steve French wrote:
> Do you know a more standardized way to test if symlink support is available?
> We don't really have the same thing as the FS and Device capability ioctls
> that Microsoft offers, but even for them, they don't export whether symlink
> support is enabled as a volume or export property.
> Presumably we could try to create one and look for the rc EOPNOTSUPP), but
> it seems simple enough for now to check on mount looking for
> fs-specific features
> as Pavel has done, or to always enable the symlink tests for cifs (and
> smb3 after
> we have added it).

There's not good way to check for it except for trying.  So a simple
routine that creates a symlink on $TEST_DIR and checks if that works
would be the way to go.
