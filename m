From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: kudos & congrats on efficiency.
Date: Fri, 26 May 2017 11:12:36 -0700
Message-ID: <59287014.4040006@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I tend to be a bit of a performance-geek -- often running various 
self-relevant benchmarks to see how long things take and working on 
optimizing configs for  speed & efficiency. 

I wanted to backup a 45.5GB dir (with 260 subdirs, & 633 files) from my
Win7SP1 PC to my home server.  I frequently have the Win7 disk
(SSD-based) mounted on a top-level dir. 

An aside, I want to repeat a kudo relating to win-symlinks appearing
as linux-native symlinks via CIFS.  That's excellent.  It may have
just 'fallen out' from other work, but it's still very cool.

Second is on efficiency, uncovered by running tar.  I thought
the 45G would take a few-several minutes to xfer even with my 8Gb (says
10, but get a 20% penalty for having an older PCIe bus) ethernet.
It took < 2 minutes to write to a tar file.  I ran the tar again
(after dropping local caches) w/output to /dev/null...
took 82.02s : average 568MB/s!  With CIFS taking 70-80% cpu.
A rerun on the server after another dropcache, averaged 687MB/s. 
Maybe subsequent runs benefit from the win7-cache.
Not sure how to readily drop the Win7 cache (other than alloc'ing
all mem in the machine and forcing the cache to be dumped)...

Anyway, for comparison, my current version of samba
gives ~450MB/s for reads and ~200MB/s for writes.

Congrats!
-Linda W.
