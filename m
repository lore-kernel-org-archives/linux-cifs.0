From: Paul Walmsley <paul@pwsan.com>
Subject: Re: LOCKDEP: 3.9-rc1: mount.nfs/4272 still has locks held!
Date: Sun, 31 Mar 2013 00:07:01 +0000 (UTC)
Message-ID: <alpine.DEB.2.00.1303310004550.6436@utopia.booyaka.com>
References: <20130305140312.243cb094@tlielax.poochiereds.net> <20130305190923.GI12795@htj.dyndns.org> <20130305183941.19ff39ce@tlielax.poochiereds.net> <20130305234700.GE1227@htj.dyndns.org> <20130306181608.GA18687@redhat.com> <20130306185304.GM1227@htj.dyndns.org>
 <CA+55aFwDogteVd=vwGHXDSASnga-nZZnKaQz9aO1yBU2CPKSbA@mail.gmail.com> <20130306212452.GO1227@htj.dyndns.org> <CA+55aFy49AWptMcvEzJxg95ikf-dC+-vcCPq-cnaCCwje3tyoQ@mail.gmail.com> <20130306213636.GP1227@htj.dyndns.org> <20130306214016.GQ1227@htj.dyndns.org>
 <20130313111727.63391672@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	"Myklebust, Trond" <Trond.Myklebust@netapp.com>,
	Mandeep Singh Baines <msb@chromium.org>,
	Ming Lei <ming.lei@canonical.com>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-cifs@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <20130313111727.63391672@tlielax.poochiereds.net>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 13 Mar 2013, Jeff Layton wrote:

> Of course, this is all a lot of work, and not something we can shove
> into the kernel for 3.9 at this point. In the meantime, while Mandeep's
> warning is correctly pointing out a problem, I think we ought to back
> it out until we can fix this properly.

Revert posted at:

http://marc.info/?l=linux-kernel&m=136468829626184&w=2

Andrew or Linus, care to pick this up before for 3.9-rc?


- Paul
