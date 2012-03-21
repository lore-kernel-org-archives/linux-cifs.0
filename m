From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs aio_write improvements
Date: Wed, 21 Mar 2012 12:43:34 -0500
Message-ID: <CAH2r5msS3P-FRPyg_+vNq07h=VusE-yAPAuw6pVBVicK2R95HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Do you have any test cases which we could use to measure performance
improvement for this?

The user space calls for vectored async i/o in linux are confusing.

-- 
Thanks,

Steve
