From: Jeff Layton <jlayton@redhat.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Wed, 9 Mar 2011 21:12:25 -0500
Message-ID: <20110309211225.2e16d14f@corrin.poochiereds.net>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<20110309184542.07c5ffe6@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110309184542.07c5ffe6@corrin.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 9 Mar 2011 18:45:42 -0500
Jeff Layton <jlayton@redhat.com> wrote:

> On Thu, 10 Mar 2011 08:51:48 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> > 
> > Sounds like a case for the same dirty page lifecycle as NFS: clean
> > -> dirty -> writeback -> unstable -> clean. i.e. the page is
> > unstable after the issuing of the IO until the response from the
> > server so the page can't be reclaimed while the IO is still in
> > progress at the server...
> > 
> 
> It's a little more complicated than that for NFS. Unstable pages are
> ones that have had successful writes but that have not been committed
> yet. Once a NFS COMMIT call completes, the page is marked clean and can
> be freed by the VM.
> 
> Actual writeback in NFS is pretty similar to other filesystems -- the
> page is only under writeback until the WRITE response is received. It
> just doesn't clear the dirty bit until a COMMIT response is received.
> 

Sorry, that's incorrect...NFS does clear the dirty bit after writeback,
but doesn't mark the inode clean until all pages have been committed.

Either way though, that really has little to do with keeping the pages
stable while sending them, but more to do with the fact that the server
can buffer up writes and then later crash and lose them. A successful
COMMIT means that the writes got committed to stable storage.

FWIW, CIFS is currently vulnerable to that problem too, so an unstable
write model isn't a bad idea, IMO.

-- 
Jeff Layton <jlayton@redhat.com>
