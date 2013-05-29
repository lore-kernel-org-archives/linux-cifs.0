From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/3 v3] dcache: make it more scalable on large system
Date: Wed, 29 May 2013 22:37:00 +0200
Message-ID: <20130529203700.GM6123@two.firstfloor.org>
References: <1369273048-60256-1-git-send-email-Waiman.Long@hp.com>
 <20130523094201.GA24543@dastard>
 <519E8B5F.3080905@hp.com>
 <20130527020903.GR29466@dastard>
 <51A624E2.3000301@hp.com>
 <20130529184640.GA3243@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Waiman Long <waiman.long@hp.com>,
	Dave Chinner <david@fromorbit.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Layton <jlayton@redhat.com>,
	Miklos Szeredi <mszeredi@suse.cz>, Ian Kent <raven@themaw.net>,
	Sage Weil <sage@inktank.com>, Steve French <sfrench@samba.org>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>,
	"Norton, Scott J" <scott.norton@hp.com>,
	Andi Kleen <andi@firstfloor.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130529184640.GA3243@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> As Dave said before, is the last path component sufficient?  Or how
> about an inode number?

Neither works, the profiler needs to find the file and read it.

inode searching would be incredible expensive, unless the file system
provided a "open-by-inode" primitive

In normal operation you only have that event when starting up the
program and when each shared library gets mapped in.

-Andi
