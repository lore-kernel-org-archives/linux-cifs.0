From: Mirko Scholz <mscholz5-2/1ofaGcC4w@public.gmane.org>
Subject: file truncation on newer linux-cifs versions
Date: Sat, 14 Jan 2012 00:07:01 +0100
Message-ID: <20120113230701.GA3100@gwdu05.gwdg.de>
Reply-To: mscholz5-2/1ofaGcC4w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hello,

with linux' cifs implementation I experience file truncation when
talking to our institute's file server [1]

% rm -f zero*
% dd if=/dev/zero of=test-64 bs=64k count=1
% dd if=/dev/zero of=test-65 bs=65k count=1
dd: closing output file `test-65': No space left on device
i.e. close(2) returns ENOSPC
% ls -l test*
-rw------- 1   65536 Jan 13 22:43 test-64
-rw------- 1   65536 Jan 13 22:43 test-65

The problem does not occur in Debian Squeeze (confirmed with vanilla
v2.6.32).  Also checked with our IT guys that there is no real quota
applied.  The above error occurs in current Testing [2] (i.e. patched 3.1.0 
and current vanilla HEAD v3.2.0+).

I haven't seen anything suspicious in a tcpdump (I mean the Close
Response, which I guess should be responsible for the quota right?, looks
similar).  The dmesg with echo 7 > /proc/fs/cifs/cifsFYI for both cases
you may find at http://www.gwdg.de/~mscholz5/cifs-problem/3.0.0+ 
(from a run of git bisect I am currently in it is from a v3.0.0+)

I'd appreciate any suggestions for additional information you might need

Mirko 


[1] OS=[BlueArc Mercury 8.1.2350.22] Server=[BlueArc Mercury 8.1.2350.22]
mounted via mount.cifs
[2] mount.cifs version: 5.2
