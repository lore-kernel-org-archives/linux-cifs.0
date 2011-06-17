From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: problems with signing and new crypto code
Date: Fri, 17 Jun 2011 09:09:15 -0400
Message-ID: <20110617090915.4e2fcf60@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Shirish,

I've been working on some backports of some upstream patch series and
have run into what I think is a problem with the new crypto code. The
problem mainly seems to manifest itself as bad signatures in write
calls. This causes a win2k8 server (at least) to reject the call with
STATUS_ACCESS_DENIED and stop responding to other calls on the socket.

I did a bisect of sorts, and got to this patch:

commit ca83ce3d5b9ad321ee24f5870a77f0b21ac5a5de
Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Tue Apr 12 09:13:44 2011 -0400

    cifs: don't allow mmap'ed pages to be dirtied while under writeback (try #3)

My original thought was that something was altering these pages while
they were under writeback, but I did some instrumentation and found
that not to be the case. The signature is the same before and after
the send when this occurs. A key change in this patch is that when
signing is enabled, the code started using CIFSSMBWrite2(), which
marshals up the send buffer in an array of kvecs.

That leads me to believe that the cifs_sign_smb2 codepath is busted.

I'll see if I can come up with a testcase, but I'm not that familiar
with the kernel crypto code. Is this something you've seen in your
testing? Any immediate thoughts as to where the problem may be?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
