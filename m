From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 0/3 v3] dcache: make it more scalable on large system
Date: Wed, 29 May 2013 17:19:17 -0400
Message-ID: <20130529211917.GB6658@logfs.org>
References: <1369273048-60256-1-git-send-email-Waiman.Long@hp.com>
 <20130523094201.GA24543@dastard>
 <519E8B5F.3080905@hp.com>
 <20130527020903.GR29466@dastard>
 <51A624E2.3000301@hp.com>
 <20130529184640.GA3243@fieldses.org>
 <20130529203700.GM6123@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	Waiman Long <waiman.long@hp.com>,
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
	"Norton, Scott J" <scott.norton@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <autofs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130529203700.GM6123@two.firstfloor.org>
Sender: autofs-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 29 May 2013 22:37:00 +0200, Andi Kleen wrote:
>=20
> > As Dave said before, is the last path component sufficient?  Or how
> > about an inode number?
>=20
> Neither works, the profiler needs to find the file and read it.

Ignoring all the complexity this would cause downstream, you could do
the path lookup just once, attach some cookie to it and return the
cookie ever-after.  Maybe some combination of i_sb and i_ino would be
good enough as a cookie.

J=C3=B6rn

--
Data dominates. If you've chosen the right data structures and organize=
d
things well, the algorithms will almost always be self-evident. Data
structures, not algorithms, are central to programming.
-- Rob Pike
