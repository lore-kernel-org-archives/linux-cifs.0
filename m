From: Jeff Layton <jlayton@redhat.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Wed, 9 Mar 2011 18:45:42 -0500
Message-ID: <20110309184542.07c5ffe6@corrin.poochiereds.net>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110309215148.GW15097@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 10 Mar 2011 08:51:48 +1100
Dave Chinner <david@fromorbit.com> wrote:
> 
> Sounds like a case for the same dirty page lifecycle as NFS: clean
> -> dirty -> writeback -> unstable -> clean. i.e. the page is
> unstable after the issuing of the IO until the response from the
> server so the page can't be reclaimed while the IO is still in
> progress at the server...
> 

It's a little more complicated than that for NFS. Unstable pages are
ones that have had successful writes but that have not been committed
yet. Once a NFS COMMIT call completes, the page is marked clean and can
be freed by the VM.

Actual writeback in NFS is pretty similar to other filesystems -- the
page is only under writeback until the WRITE response is received. It
just doesn't clear the dirty bit until a COMMIT response is received.

That said, an unstable write model for CIFS is not a bad idea. Just
substitute a SMB_COM_FLUSH for a NFS COMMIT call...

-- 
Jeff Layton <jlayton@redhat.com>
