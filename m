From: Jeremy Allison <jra@samba.org>
Subject: Re: Big performance improvements seen with cifs async write
 patches even over localhost
Date: Fri, 27 May 2011 09:47:02 -0700
Message-ID: <20110527164702.GB28520@samba2>
References: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, May 27, 2011 at 12:14:19AM -0500, Steve French wrote:
> Did some informal testing of Jeff Layton's cifs async_write patch set
> tonight (recent kernel). Copying 700MB sequentially was 20% faster
> from cifs kernel client to Samba 3.6 with his patches - even mounted
> over localhost (where network latency is a much smaller issue) and
> with a slow laptop drive!
> 
> I was simply doing
> 
> time dd if=/dev/zero of=/mnt/null bs=1M count=700
> 
> repeated 4 times each way (with old module, and with same code with
> Jeff's cifs async write code builtin), deleting the target file in
> between each run.
> 
> I am looking forward to trying this over GigE tomorrow to servers with
> faster disks.

Very nice ! Now where's my encrypted transport Steve ? :-) :-)

Jeremy.
