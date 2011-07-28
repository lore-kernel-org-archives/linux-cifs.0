From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: patch status
Date: Thu, 28 Jul 2011 08:07:50 -0500
Message-ID: <CAH2r5mtRqCQQiwSuzUv9tjGnmfb9jtqo0odZPrUYyGMBBPor6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed and merged
      cifs: advertise the right receive buffer size to the server
      cifs: trivial: goto out here is unnecessary
      cifs: don't start signing too early
      cifs: fix name parsing in CIFSSMBQAllEAs

am currently looking at the oplock refcounting patch, and Pavel's
demultiplex simplification series, the on to the others.

-- 
Thanks,

Steve
